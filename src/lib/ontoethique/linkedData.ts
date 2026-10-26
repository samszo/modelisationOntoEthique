// Export Linked Open Data (principes FAIR) du modèle onto-éthique : Turtle et JSON-LD à partir des mêmes triplets
// (vocabulaire oe: de config.ontology.baseUri, avec dcterms, prov, oa, rdfs, xsd)
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import { slug, type OntoModel } from "./model";
import type { Metrics } from "./metrics";

type Obj = { iri: string } | { value: string | number | boolean; datatype?: string; lang?: string };
type Triple = [string, string, Obj];

const XSD = "http://www.w3.org/2001/XMLSchema#";
const PREFIXES = (config: OntoEthiqueConfig) => ({
  oe: config.ontology.baseUri,
  dcterms: "http://purl.org/dc/terms/",
  prov: "http://www.w3.org/ns/prov#",
  oa: "http://www.w3.org/ns/oa#",
  rdfs: "http://www.w3.org/2000/01/rdf-schema#",
  rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  xsd: XSD,
});

// classe RDF d'un genre d'existence
const KIND_CLASS: Record<string, string> = { humain: "oe:ActantHumain", agent: "oe:AgentNumerique", environnement: "oe:EnvironnementDocumentaire" };
const cap = (s: string) => slug(s).split("-").map(w => w.charAt(0).toUpperCase() + w.slice(1)).join("");

export function modelTriples(model: OntoModel, config: OntoEthiqueConfig, metrics?: Metrics): Triple[] {
  const base = `${config.ontology.dataUri}${encodeURIComponent(model.runId)}/`;
  const t: Triple[] = [];
  const iri = (s: string) => ({ iri: s });
  const lit = (value: string | number | boolean, datatype?: string) => ({ value, ...(datatype ? { datatype } : {}) });
  const fr = (value: string) => ({ value, lang: "fr" });
  const activity = `${base}activite`;

  t.push([activity, "rdf:type", iri("oe:ActiviteSituee")], [activity, "rdf:type", iri("prov:Activity")], [activity, "dcterms:title", fr(model.activity.title)]);
  if (model.activity.description) t.push([activity, "dcterms:description", fr(model.activity.description)]);
  t.push([activity, "dcterms:identifier", lit(model.runId)], [activity, "dcterms:created", lit(model.createdAt, `${XSD}dateTime`)], [activity, "dcterms:modified", lit(model.updatedAt, `${XSD}dateTime`)]);
  if (model.collection?.key) t.push([activity, "dcterms:source", lit(`zotero:collection/${model.collection.key}`)]);
  if (metrics?.symbiosis.index !== null && metrics?.symbiosis.index !== undefined) t.push([activity, "oe:indiceSymbiose", lit(metrics.symbiosis.index, `${XSD}decimal`)]);
  if (metrics?.symbiosis.balance !== null && metrics?.symbiosis.balance !== undefined) t.push([activity, "oe:equilibreSymbiose", lit(metrics.symbiosis.balance, `${XSD}decimal`)]);

  const exIri = (id: string) => `${base}existence/${encodeURIComponent(id)}`;
  for (const e of model.existences) {
    const s = exIri(e.id);
    t.push([s, "rdf:type", iri(KIND_CLASS[e.kind] ?? "oe:ExistenceInformationnelle")], [s, "rdfs:label", fr(e.name)], [s, "oe:genre", lit(e.kind)], [s, "oe:participeA", iri(activity)]);
    if (e.description) t.push([s, "dcterms:description", fr(e.description)]);
    for (const d of config.dimensions) for (const el of e.dimensions?.[d.id] ?? []) t.push([s, `oe:dimension${cap(d.id)}`, fr(el)]);
    for (const c of e.cribles ?? []) t.push([s, "oe:crible", fr(c)]);
    const m = metrics?.existences.find(x => x.id === e.id);
    if (m) {
      if (m.valence !== null) t.push([s, "oe:valence", lit(m.valence, `${XSD}decimal`)]);
      t.push([s, "oe:complexiteOntologique", lit(m.complexity.index, `${XSD}decimal`)], [s, "oe:formeSpirale", fr(m.spiral.shape)]);
    }
  }

  for (const p of model.pulsations) {
    const s = `${base}pulsation/${encodeURIComponent(p.id)}`;
    t.push([s, "rdf:type", iri("oe:Pulsation")], [s, "oe:existence", iri(exIri(p.existence))], [s, "oe:ordre", lit(p.order, `${XSD}integer`)], [s, "rdfs:label", fr(p.moment)], [s, "prov:wasGeneratedBy", iri(activity)]);
    if (p.date) t.push([s, "dcterms:date", lit(p.date)]);
    if (p.document) t.push([s, "dcterms:source", fr(p.document.title)]);
    if (p.document?.zoteroKey) t.push([s, "dcterms:references", lit(`zotero:item/${p.document.zoteroKey}`)]);
    for (const v of config.values) { const x = p.values?.[v.id]; if (typeof x === "number") t.push([s, `oe:valeur${cap(v.id)}`, lit(x, `${XSD}integer`)]); }
    for (const [power, ev] of Object.entries(p.evaluations)) {
      if (ev.score === null) continue;
      const e = `${s}/${power}`;
      t.push([s, "oe:evaluation", iri(e)], [e, "rdf:type", iri("oe:Evaluation")], [e, "oe:pouvoir", iri(`oe:${cap(power)}`)], [e, "oe:score", lit(ev.score, `${XSD}integer`)], [e, "oe:origine", lit(ev.origin)], [e, "oe:validee", lit(!!ev.validated, `${XSD}boolean`)]);
      if (ev.chain.length) t.push([e, "oe:semiose", fr(ev.chain.join(" → "))]);
      if (ev.justification) t.push([e, "rdfs:comment", fr(ev.justification)]);
      if (ev.citation) t.push([e, "oa:exact", fr(ev.citation)]);
    }
  }

  // révisions humaines : traçabilité des modifications (oa:motivatedBy)
  model.revisions.forEach((r, i) => {
    const s = `${base}revision/${i + 1}`;
    t.push([s, "rdf:type", iri("oa:Annotation")], [s, "oa:motivatedBy", iri(`oa:${r.motivation}`)], [s, "dcterms:created", lit(r.at, `${XSD}dateTime`)], [s, "oa:hasTarget", iri(r.target.type === "pulsation" ? `${base}pulsation/${encodeURIComponent(r.target.id)}` : r.target.type === "existence" ? exIri(r.target.id) : activity)], [s, "dcterms:type", lit(r.action)]);
    if (r.author) t.push([s, "dcterms:creator", fr(r.author)]);
    if (r.note) t.push([s, "oa:bodyValue", fr(r.note)]);
  });
  return t;
}

const escapeTtl = (s: string) => s.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, "\\n").replace(/\r/g, "");

export function toTurtle(model: OntoModel, config: OntoEthiqueConfig, metrics?: Metrics): string {
  const prefixes = PREFIXES(config);
  const term = (s: string) => (/^[a-z]+:[A-Za-z][\w-]*$/.test(s) && s.split(":")[0]! in prefixes ? s : `<${s}>`);
  const obj = (o: Obj) => {
    if ("iri" in o) return term(o.iri);
    if (typeof o.value === "boolean") return String(o.value);
    const v = `"${escapeTtl(String(o.value))}"`;
    return o.lang ? `${v}@${o.lang}` : o.datatype ? `${v}^^${term(o.datatype.replace(XSD, "xsd:"))}` : v;
  };
  const bySubject = new Map<string, Triple[]>();
  for (const tr of modelTriples(model, config, metrics)) bySubject.set(tr[0], [...(bySubject.get(tr[0]) ?? []), tr]);
  const out = [
    `# Modèle onto-éthique « ${model.activity.title.replace(/\n/g, " ")} » (${model.runId}) — généré le ${new Date().toISOString()}`,
    ...Object.entries(prefixes).map(([p, u]) => `@prefix ${p}: <${u}> .`), "",
  ];
  for (const [s, list] of bySubject) {
    out.push(`${term(s)}\n    ${list.map(([, p, o]) => `${p === "rdf:type" ? "a" : term(p)} ${obj(o)}`).join(" ;\n    ")} .`, "");
  }
  return out.join("\n");
}

export function toJsonLd(model: OntoModel, config: OntoEthiqueConfig, metrics?: Metrics) {
  const prefixes = PREFIXES(config);
  const nodes = new Map<string, Record<string, any>>();
  for (const [s, p, o] of modelTriples(model, config, metrics)) {
    const node = nodes.get(s) ?? { "@id": s };
    const value = "iri" in o ? (p === "rdf:type" ? o.iri : { "@id": o.iri }) : o.lang ? { "@value": o.value, "@language": o.lang } : o.datatype ? { "@value": o.value, "@type": o.datatype.replace(XSD, "xsd:") } : o.value;
    const key = p === "rdf:type" ? "@type" : p;
    node[key] = node[key] === undefined ? value : [...(Array.isArray(node[key]) ? node[key] : [node[key]]), value];
    nodes.set(s, node);
  }
  return { "@context": prefixes, "@graph": [...nodes.values()] };
}
