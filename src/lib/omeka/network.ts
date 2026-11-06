// Réseau d'un écosystème de connaissances dans Omeka S : éléments rattachés par la propriété d'écosystème, items liés,
// types de nœuds liables (custom vocabs des templates), impact d'une suppression, conversion des valeurs pour l'écriture
import type { Omk } from "./omk";
import type { FormValue } from "./templateForm";

export interface NetNode { id: number; title: string; templateId: number | null; template: string; classTerm: string; role: "eco" | "element" | "linked" }
export interface NetLink { source: number; target: number; term: string; label: string }
export interface NetworkConfig { ecoTemplateId: number; ecoProperty: string; elementTemplateIds: number[]; maxLinked: number }

// valeurs d'un item : propriétés seulement (clés « préfixe:terme » dont la valeur est une liste de valeurs Omeka)
export const itemProperties = (item: any): Record<string, any[]> =>
  Object.fromEntries(Object.entries(item).filter(([k, v]) => /^[\w-]+:[\w-]+$/.test(k) && Array.isArray(v) && (v as any[])[0]?.property_id !== undefined)) as Record<string, any[]>;

// valeur lue → valeur écrite (annotation de valeur comprise)
export function toWritable(v: any): any {
  const out: any = { type: v.type, property_id: v.property_id, ...(v.is_public === false ? { is_public: false } : {}) };
  if (v.value_resource_id) out.value_resource_id = v.value_resource_id;
  else if (v["@id"] && !v["@value"]) { out["@id"] = v["@id"]; if (v["o:label"]) out["o:label"] = v["o:label"]; }
  else { out["@value"] = v["@value"]; if (v["@language"]) out["@language"] = v["@language"]; }
  if (v["@annotation"]) out["@annotation"] = Object.fromEntries(Object.entries(v["@annotation"]).map(([k, vs]) => [k, (vs as any[]).map(toWritable)]));
  return out;
}

// valeurs d'un item au format du formulaire (édition)
export function formValues(item: any): Record<string, FormValue[]> {
  const conv = (v: any): FormValue => ({
    type: v.type,
    ...(v.value_resource_id ? { id: v.value_resource_id, label: v.display_title } : v["@id"] && !v["@value"] ? { uri: v["@id"], label: v["o:label"] } : { value: v["@value"] }),
    ...(v["@annotation"] ? { annotation: Object.fromEntries(Object.entries(v["@annotation"]).map(([k, vs]) => [k, (vs as any[]).map(conv)])) } : {}),
  });
  return Object.fromEntries(Object.entries(itemProperties(item)).map(([k, vs]) => [k, vs.map(conv)]));
}

const node = (i: any, role: NetNode["role"], templates: Map<number, any>, classes: Map<number, string>): NetNode => {
  const tid = i["o:resource_template"]?.["o:id"] ?? null;
  return { id: i["o:id"], title: String(i["o:title"] ?? `Item ${i["o:id"]}`), templateId: tid, template: tid ? templates.get(tid)?.["o:label"] ?? "" : "", classTerm: classes.get(i["o:resource_class"]?.["o:id"]) ?? "", role };
};

export async function instanceIndex(omk: Omk) {
  const [templates, classes] = await Promise.all([omk.request(omk.url("resource_templates", { per_page: 500 })), omk.request(omk.url("resource_classes", { per_page: 2000 }))]);
  return { templates: new Map<number, any>(templates.map((t: any) => [t["o:id"], t])), classes: new Map<number, string>(classes.map((c: any) => [c["o:id"], c["o:term"]])) };
}

// items qui pointent vers un item (toute propriété)
// (propriété vide = toutes les propriétés ; sans ce paramètre, Omeka S ignore le filtre)
export const referencing = (omk: Omk, id: number) => omk.getAllItems(`property[0][property]=&property[0][type]=res&property[0][text]=${id}`);

// remplace les valeurs de propriétés d'un item en conservant toutes les autres : un PATCH Omeka S remplace l'ensemble
// des valeurs de l'item, on renvoie donc toutes ses propriétés
export async function writeValues(omk: Omk, id: number, changes: Record<string, any[]>) {
  const item = await omk.request(omk.url(`items/${id}`));
  const props = Object.fromEntries(Object.entries(itemProperties(item)).map(([k, vs]) => [k, vs.map(toWritable)]));
  for (const [k, vs] of Object.entries(changes)) { if (vs.length) props[k] = vs; else delete props[k]; }
  return omk.request(omk.url(`items/${id}`), "PUT", {
    ...(item["o:resource_template"] ? { "o:resource_template": { "o:id": item["o:resource_template"]["o:id"] } } : {}),
    ...(item["o:resource_class"] ? { "o:resource_class": { "o:id": item["o:resource_class"]["o:id"] } } : {}),
    "o:item_set": (item["o:item_set"] ?? []).map((x: any) => ({ "o:id": x["o:id"] })),
    "o:is_public": item["o:is_public"] ?? true,
    ...props,
  });
}

export async function ecoGraph(omk: Omk, ecoId: number, cfg: NetworkConfig) {
  const { templates, classes } = await instanceIndex(omk);
  const eco = await omk.request(omk.url(`items/${ecoId}`));
  if (eco["o:resource_template"]?.["o:id"] !== cfg.ecoTemplateId) throw new Error("Cet item n'est pas un écosystème de connaissances");
  const nodes = new Map<number, NetNode>([[ecoId, node(eco, "eco", templates, classes)]]);
  const links: NetLink[] = [];
  const items = new Map<number, any>([[ecoId, eco]]);
  // éléments : ceux qui portent la propriété d'écosystème vers lui, et ceux qu'il désigne lui-même par cette propriété
  const members = await omk.getAllItems(`property[0][property]=${encodeURIComponent(cfg.ecoProperty)}&property[0][type]=res&property[0][text]=${ecoId}`);
  for (const m of members) { items.set(m["o:id"], m); nodes.set(m["o:id"], node(m, "element", templates, classes)); }
  for (const v of eco[cfg.ecoProperty] ?? []) if (v.value_resource_id && !nodes.has(v.value_resource_id)) {
    const m = await omk.request(omk.url(`items/${v.value_resource_id}`)).catch(() => null);
    if (m) { items.set(m["o:id"], m); nodes.set(m["o:id"], node(m, "element", templates, classes)); }
  }
  const elements = [...nodes.values()].filter(n => n.role === "element").map(n => n.id);
  // ressources liées aux éléments : valeurs des éléments (sortantes) et items qui les désignent (entrantes)
  const addLinksOf = (item: any) => {
    for (const [term, vs] of Object.entries(itemProperties(item))) for (const v of vs) {
      if (!v.value_resource_id || v.value_resource_name !== "items") continue;
      links.push({ source: item["o:id"], target: v.value_resource_id, term, label: v.property_label ?? term });
    }
  };
  for (const id of elements) addLinksOf(items.get(id));
  // items qui désignent un des éléments : une seule requête (conditions jointes par « or »)
  const refQuery = elements.map((id, i) => `${i ? `property[${i}][joiner]=or&` : ""}property[${i}][property]=&property[${i}][type]=res&property[${i}][text]=${id}`).join("&");
  for (const r of elements.length ? await omk.getAllItems(refQuery) : []) if (!items.has(r["o:id"]) && items.size < cfg.maxLinked) { items.set(r["o:id"], r); nodes.set(r["o:id"], node(r, "linked", templates, classes)); addLinksOf(r); }
  const missing = [...new Set(links.map(l => l.target).filter(id => !nodes.has(id)))].slice(0, Math.max(0, cfg.maxLinked - nodes.size));
  for (const t of await Promise.all(missing.map(id => omk.request(omk.url(`items/${id}`)).catch(() => null)))) if (t) nodes.set(t["o:id"], node(t, "linked", templates, classes));
  // un lien par couple et propriété, entre nœuds présents
  const seen = new Set<string>();
  const kept = links.filter(l => nodes.has(l.source) && nodes.has(l.target) && !seen.has(`${l.source}|${l.target}|${l.term}`) && seen.add(`${l.source}|${l.target}|${l.term}`));
  return { eco: nodes.get(ecoId)!, nodes: [...nodes.values()], links: kept };
}

// types de nœuds liables depuis un item : propriétés de son template dont un type de données est un custom vocab
// adossé à une collection d'items ; le type de nœud est le template qui crée ses items dans cette collection.
// Depuis l'écosystème : les types d'éléments de la configuration, rattachés par la propriété d'écosystème.
export async function linkableTypes(omk: Omk, itemId: number, cfg: NetworkConfig) {
  const { templates } = await instanceIndex(omk);
  const item = await omk.request(omk.url(`items/${itemId}`));
  const tid = item["o:resource_template"]?.["o:id"];
  if (tid === cfg.ecoTemplateId) {
    return [{ term: cfg.ecoProperty, label: "élément de l'écosystème", reverse: true, dataType: "resource:item",
      types: cfg.elementTemplateIds.filter(id => templates.has(id)).map(id => ({ templateId: id, label: templates.get(id)["o:label"] })) }];
  }
  const t = templates.get(tid);
  if (!t) return [];
  const bySet = new Map<string, number[]>();
  for (const x of templates.values()) for (const s of x["o:data"]?.item_sets ?? []) bySet.set(String(s), [...(bySet.get(String(s)) ?? []), x["o:id"]]);
  const out: { term: string; label: string; reverse: boolean; dataType: string; types: { templateId: number; label: string }[] }[] = [];
  for (const p of t["o:resource_template_property"] ?? []) {
    // le rattachement à l'écosystème n'est pas un lien de modélisation
    if (p["o:property"]["o:id"] === (await omk.request(omk.url("properties", { term: cfg.ecoProperty })))[0]?.["o:id"]) continue;
    const types: string[] = p["o:data_type"]?.length ? p["o:data_type"] : p["o:data"]?.[0]?.["o:data_type"] ?? [];
    for (const dt of types.filter(x => x.startsWith("customvocab:"))) {
      const vocab = await omk.request(omk.url(`custom_vocabs/${dt.split(":")[1]}`)).catch(() => null);
      const set = vocab?.["o:item_set"]?.["o:id"];
      const targets = set ? bySet.get(String(set)) ?? [] : [];
      if (!targets.length) continue;
      const prop = await omk.request(omk.url(`properties/${p["o:property"]["o:id"]}`));
      out.push({ term: prop["o:term"], label: p["o:alternate_label"] || prop["o:label"], reverse: false, dataType: dt,
        types: targets.map(id => ({ templateId: id, label: templates.get(id)?.["o:label"] ?? `Template ${id}` })) });
    }
  }
  return out;
}

// items existants liables par une propriété du nœud (autocomplétion de « lier ») : titre contenant q, parmi les types
// de nœud acceptés par cette propriété ; linked : déjà lié au nœud par cette propriété
export async function searchLinkable(omk: Omk, parentId: number, term: string, q: string, cfg: NetworkConfig, limit = 20) {
  const option = (await linkableTypes(omk, parentId, cfg)).find(o => o.term === term);
  if (!option) throw new Error("Cette propriété ne lie aucun type de nœud");
  const labels = new Map(option.types.map(t => [t.templateId, t.label]));
  const params = new URLSearchParams({ "property[0][property]": "dcterms:title", "property[0][type]": "in", "property[0][text]": q, sort_by: "title", per_page: String(limit) });
  for (const id of labels.keys()) params.append("resource_template_id[]", String(id));
  const [items, parent] = await Promise.all([omk.request(omk.url("items", params.toString())), omk.request(omk.url(`items/${parentId}`))]);
  const linked = new Set<number>(option.reverse ? [] : (parent[term] ?? []).map((v: any) => v.value_resource_id));
  return items.filter((i: any) => i["o:id"] !== parentId).map((i: any) => {
    const tid = i["o:resource_template"]?.["o:id"];
    const member = option.reverse && (i[cfg.ecoProperty] ?? []).some((v: any) => v.value_resource_id === parentId);
    return { id: i["o:id"], title: String(i["o:title"] ?? `Item ${i["o:id"]}`), templateId: tid, template: labels.get(tid) ?? "", linked: member || linked.has(i["o:id"]) };
  });
}

// conséquences d'une suppression : parents (items qui désignent le nœud) et enfants (items qu'il désigne)
export async function deletionImpact(omk: Omk, itemId: number, cfg: NetworkConfig) {
  const item = await omk.request(omk.url(`items/${itemId}`));
  const parents = (await referencing(omk, itemId)).filter((r: any) => r["o:id"] !== itemId).map((r: any) => ({
    id: r["o:id"], title: r["o:title"], terms: Object.entries(itemProperties(r)).filter(([, vs]) => vs.some(v => v.value_resource_id === itemId)).map(([k]) => k),
  }));
  const children: { id: number; title: string; term: string }[] = [];
  const ecos: { id: number; title: string }[] = [];
  for (const [term, vs] of Object.entries(itemProperties(item))) for (const v of vs) {
    if (!v.value_resource_id) continue;
    if (term === cfg.ecoProperty) ecos.push({ id: v.value_resource_id, title: v.display_title });
    else children.push({ id: v.value_resource_id, title: v.display_title, term });
  }
  return { item: { id: itemId, title: item["o:title"], templateId: item["o:resource_template"]?.["o:id"] ?? null }, parents, children, ecos };
}

// titre suivant : « titre 2 », puis « titre 3 »…
export const nextTitle = (title: string, n?: number) => {
  const m = /^(.*?)\s+(\d+)$/.exec(title);
  return m ? `${m[1]} ${n ?? Number(m[2]) + 1}` : `${title} ${n ?? 2}`;
};
