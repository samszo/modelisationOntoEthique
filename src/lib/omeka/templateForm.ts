// Formulaire décrit à partir d'un resource template Omeka S : champs, types de données, listes des custom vocabs, item
// sets et classe du template, annotations de valeur ; et charge utile de création d'un item à partir des valeurs saisies
import type { Omk } from "./omk";

export type DataKind = "literal" | "numeric" | "item" | "uri";
export interface FormOption { id?: number; title: string; uri?: string }
export interface FormDataType { type: string; kind: DataKind; label: string; options?: FormOption[]; query?: string; open?: boolean }
export interface FormField {
  term: string; propertyId: number; label: string; comment: string; required: boolean; maxValues: number | null;
  dataTypes: FormDataType[]; annotation?: FormField[];
}
export interface TemplateForm {
  templateId: number; label: string; titleTerm: string;
  resourceClass: { id: number; term: string } | null;
  itemSets: { id: number; title: string }[];
  fields: FormField[];
}
// valeur saisie : item lié (id), adresse (uri, label) ou texte (value) ; annotation : valeurs de l'annotation de valeur
export interface FormValue { type: string; value?: string | number; id?: number; uri?: string; label?: string; annotation?: Record<string, FormValue[]> }

const TEXTS: Record<string, string> = { literal: "Texte", "resource:item": "Item lié", uri: "Adresse" };

// o:terms et o:uris d'un custom vocab : tableau, ou texte d'une entrée par ligne selon la version du module
const lines = (v: unknown): string[] => (Array.isArray(v) ? v.map(String) : typeof v === "string" ? v.split("\n").map(s => s.trim()).filter(Boolean) : []);

async function customVocabType(omk: Omk, type: string, open: boolean): Promise<FormDataType> {
  const vocab = await omk.request(omk.url(`custom_vocabs/${type.split(":")[1]}`));
  const label = String(vocab["o:label"] ?? type);
  const setId = vocab["o:item_set"]?.["o:id"];
  if (setId) {
    const items = await omk.getAll("items", `item_set_id=${setId}&sort_by=title`);
    return { type, kind: "item", label, open, options: items.map((i: any) => ({ id: i["o:id"], title: String(i["o:title"] ?? `Item ${i["o:id"]}`) })) };
  }
  const uris = lines(vocab["o:uris"]);
  if (uris.length) return { type, kind: "uri", label, open, options: uris.map(l => { const [uri, ...rest] = l.split(/\s+/); return { uri: uri!, title: rest.join(" ") || uri! }; }) };
  return { type, kind: "literal", label, open, options: lines(vocab["o:terms"]).map(title => ({ title })) };
}

async function dataType(omk: Omk, type: string, data: any): Promise<FormDataType> {
  if (type.startsWith("customvocab:")) return customVocabType(omk, type, data.custom_vocab_open === "yes" || data.custom_vocab_open === "1");
  if (type.startsWith("resource")) return { type, kind: "item", label: TEXTS[type] ?? "Ressource liée", query: String(data.resource_query ?? "") };
  if (type.startsWith("numeric:")) return { type, kind: "numeric", label: "Nombre" };
  if (type === "uri" || type.startsWith("wikidata:") || type.startsWith("valuesuggest:")) return { type, kind: "uri", label: type.startsWith("wikidata:") ? "Wikidata (adresse)" : "Adresse" };
  return { type, kind: "literal", label: TEXTS[type] ?? type };
}

export async function buildTemplateForm(omk: Omk, templateId: number): Promise<TemplateForm> {
  const t = await omk.request(omk.url(`resource_templates/${templateId}`));
  const data = t["o:data"] ?? {};
  const classes = Object.entries(data.suggested_resource_class_ids ?? {}) as [string, number][];
  const resourceClass = classes[0] ? { term: classes[0][0], id: Number(classes[0][1]) } : t["o:resource_class"] ? { id: t["o:resource_class"]["o:id"], term: "" } : null;
  const itemSets = await Promise.all((data.item_sets ?? []).map(async (id: string) => {
    const s = await omk.request(omk.url(`item_sets/${id}`));
    return { id: Number(id), title: String(s["o:title"] ?? id) };
  }));
  const fields: FormField[] = [];
  for (const p of t["o:resource_template_property"] ?? []) {
    const d = p["o:data"]?.[0] ?? {};
    const prop = await omk.request(omk.url(`properties/${p["o:property"]["o:id"]}`));
    const types: string[] = p["o:data_type"]?.length ? p["o:data_type"] : d["o:data_type"]?.length ? d["o:data_type"] : ["literal"];
    const nested = Number(d.value_annotations_template) || 0;
    const annotation = nested ? (await buildTemplateForm(omk, nested)).fields : undefined;
    fields.push({
      term: prop["o:term"], propertyId: p["o:property"]["o:id"],
      label: p["o:alternate_label"] || d["o:alternate_label"] || prop["o:label"],
      comment: p["o:alternate_comment"] || d["o:alternate_comment"] || prop["o:comment"] || "",
      required: !!p["o:is_required"] || d["o:is_required"] === "1",
      maxValues: Number(d.max_values) || null,
      dataTypes: await Promise.all(types.map(ty => dataType(omk, ty, d))),
      ...(annotation ? { annotation } : {}),
    });
  }
  const titleProp = t["o:title_property"]?.["o:id"];
  return { templateId, label: t["o:label"], titleTerm: fields.find(f => f.propertyId === titleProp)?.term ?? "dcterms:title", resourceClass, itemSets, fields };
}

// valeurs Omeka d'un champ, contrôlées par rapport aux types de données et aux listes du template
function fieldValues(field: FormField, values: FormValue[]) {
  if (field.maxValues && values.length > field.maxValues) throw new Error(`« ${field.label} » : ${field.maxValues} valeur(s) au plus`);
  return values.map(v => {
    const dt = field.dataTypes.find(x => x.type === v.type);
    if (!dt) throw new Error(`« ${field.label} » : type de valeur non autorisé (${v.type})`);
    const out: Record<string, any> = { type: dt.type, property_id: field.propertyId };
    if (dt.kind === "item") {
      const id = Number(v.id);
      if (!Number.isInteger(id) || id <= 0) throw new Error(`« ${field.label} » : item invalide`);
      if (dt.options && !dt.open && !dt.options.some(o => o.id === id)) throw new Error(`« ${field.label} » : l'item ${id} n'est pas dans la liste « ${dt.label} »`);
      out.value_resource_id = id;
    } else if (dt.kind === "uri") {
      const uri = String(v.uri ?? "").trim();
      if (!/^https?:\/\//.test(uri)) throw new Error(`« ${field.label} » : adresse invalide`);
      if (dt.options && !dt.open && !dt.options.some(o => o.uri === uri)) throw new Error(`« ${field.label} » : adresse hors de la liste « ${dt.label} »`);
      out["@id"] = uri;
      if (v.label) out["o:label"] = String(v.label).slice(0, 500);
    } else {
      const text = String(v.value ?? "").trim();
      if (!text) throw new Error(`« ${field.label} » : valeur vide`);
      if (dt.kind === "numeric" && !/^-?\d+$/.test(text)) throw new Error(`« ${field.label} » : nombre entier attendu`);
      if (dt.options?.length && !dt.open && !dt.options.some(o => o.title === text)) throw new Error(`« ${field.label} » : valeur hors de la liste « ${dt.label} »`);
      out["@value"] = text;
    }
    if (field.annotation && v.annotation) {
      const a = fieldsPayload(field.annotation, v.annotation);
      if (Object.keys(a).length) out["@annotation"] = a;
    }
    return out;
  });
}

function fieldsPayload(fields: FormField[], values: Record<string, FormValue[]>) {
  const out: Record<string, any> = {};
  for (const f of fields) {
    const list = values[f.term] ?? [];
    if (!list.length) { if (f.required) throw new Error(`« ${f.label} » est obligatoire`); continue; }
    out[f.term] = fieldValues(f, list);
  }
  return out;
}

// charge utile de POST /api/items : template, classe, item sets et valeurs contrôlées
export function itemPayload(form: TemplateForm, values: Record<string, FormValue[]>) {
  const unknown = Object.keys(values).filter(k => !form.fields.some(f => f.term === k));
  if (unknown.length) throw new Error(`Propriété hors du template : ${unknown.join(", ")}`);
  return {
    "o:resource_template": { "o:id": form.templateId },
    ...(form.resourceClass ? { "o:resource_class": { "o:id": form.resourceClass.id } } : {}),
    "o:item_set": form.itemSets.map(s => ({ "o:id": s.id })),
    ...fieldsPayload(form.fields, values),
  };
}
