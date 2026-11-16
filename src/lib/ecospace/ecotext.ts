// Description textuelle d'un écosystème : schéma de la modélisation produite par eco-model-agent, mise en forme des
// demandes, rapprochement avec les items existants d'Omeka S et complétion (éléments cités dans les pouvoirs)
import { z } from "zod";

const lieu = z.string().nullable().describe("lieu tel qu'écrit (adresse, ville, institution), sinon null");
const date = z.string().nullable().describe("date AAAA, AAAA-MM ou AAAA-MM-JJ, sinon null");

export const EcoModelSchema = z.object({
  ecosysteme: z.object({ titre: z.string(), description: z.string(), lieu }),
  actants: z.array(z.object({ titre: z.string(), personnes: z.array(z.string()), agents: z.array(z.string()), lieu, date })),
  physiques: z.array(z.object({ titre: z.string(), parent: z.string().nullable().describe("titre du physique qui le contient"), creation: date,
    importance: z.number().nullable().describe("1 à 10"), lieu, date })),
  concepts: z.array(z.object({ titre: z.string(), parent: z.string().nullable().describe("titre du concept qui l'englobe") })),
  cribles: z.array(z.object({ titre: z.string() })),
  pouvoirs: z.array(z.object({
    ref: z.string().describe("identifiant court du pouvoir, repris par les pulsations"),
    type: z.enum(["discerner", "raisonner", "resonner", "agir"]),
    intensite: z.number().describe("-100 à +100"),
    titre: z.string().nullable().describe("nom du pouvoir s'il est donné par le texte, sinon null"),
    // un champ par maillon (titres des éléments) : ceux de la séquence du type sont remplis, les autres vides
    physique: z.array(z.string()).describe("discerner : 1er maillon ; agir : 4e maillon"),
    crible: z.array(z.string()).describe("discerner : 2e maillon ; agir : 3e maillon"),
    actant: z.array(z.string()).describe("tous les types"),
    concept: z.array(z.string()).describe("discerner : 4e maillon ; agir : 1er maillon"),
    concept_source: z.array(z.string()).describe("raisonner, résonner : 1er maillon"),
    concept_destination: z.array(z.string()).describe("raisonner, résonner : 3e maillon"),
  })),
  pulsations: z.array(z.object({ titre: z.string(), pouvoirs: z.array(z.string()).describe("ref des pouvoirs, dans l'ordre"), lieu, date,
    flux: z.array(z.object({ vers: z.string().describe("titre exact d'une AUTRE pulsation de la liste"), ordre: z.enum(["avant", "pendant", "après"]).nullable().describe("cette pulsation a lieu avant, pendant ou après l'autre"), rang: z.number().nullable() })) })),
});
export type EcoModel = z.infer<typeof EcoModelSchema>;

// types d'éléments rapprochés des items existants (clé de forme → template)
export type Kind = "actant" | "personne" | "agent" | "physique" | "concept" | "crible" | "pulsation";
export type Vocab = Record<Kind, { id: number; title: string }[]>;
export const fold = (x: unknown) => String(x ?? "").normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/[«»"“”]/g, "").replace(/\s+/g, " ").trim().toLowerCase();

// rubriques de la saisie → texte de la demande
export function formatSections(stages: { id: string; label: string }[], sections: Record<string, string>) {
  return stages.map(s => `## ${s.label}\n${String(sections[s.id] ?? "").trim() || "(aucun)"}`).join("\n\n");
}
// titres existants, par type (tronqués à max par type) : seulement ceux cités dans le texte, sinon les premiers
export function formatExisting(vocab: Vocab, text: string, max = 60) {
  const t = fold(text);
  return (Object.keys(vocab) as Kind[]).map(k => {
    const cited = vocab[k].filter(x => x.title && t.includes(fold(x.title)));
    return `${k} : ${cited.slice(0, max).map(x => x.title).join(" | ") || "(aucun cité)"}`;
  }).join("\n");
}

// maillons d'un pouvoir dans l'ordre de la séquence de son type : champ du schéma de chaque maillon (« concept
// source » → concept_source ; à défaut, concept)
export function alignSteps(seq: { name: string }[], p: Record<string, any>) {
  return seq.map(st => {
    const key = st.name.replace(/\s+/g, "_"), base = st.name.split(" ")[0]!;
    const vs: string[] = (p[key]?.length ? p[key] : p[base]) ?? [];
    return { name: st.name, elements: vs.map(e => String(e).trim()).filter(Boolean) };
  });
}
// textes du modèle : tirets insécables et espaces spéciales normalisés
const clean = (v: any): any => typeof v === "string" ? v.replace(/[\u2010\u2011\u2012\u2013]/g, "-").replace(/[\u00a0\u202f]/g, " ").trim()
  : Array.isArray(v) ? v.map(clean) : v && typeof v === "object" ? Object.fromEntries(Object.entries(v).map(([k, x]) => [k, clean(x)])) : v;

// modélisation complétée et rapprochée : chaque élément reçoit `existing` (o:id d'un item de même titre et de même type)
// ; les éléments cités dans les maillons et absents des listes y sont ajoutés ; doublons fusionnés
export function completeModel(raw: EcoModel, vocab: Vocab, powerTypes: { id: string; sequence: { name: string }[] }[]) {
  const m: EcoModel = clean(raw);
  const find = (k: Kind, title: string) => vocab[k]?.find(x => fold(x.title) === fold(title))?.id ?? null;
  const uniq = <T extends { titre: string }>(xs: T[]) => { const seen = new Set<string>(); return xs.filter(x => x.titre?.trim() && !seen.has(fold(x.titre)) && !!seen.add(fold(x.titre))); };
  const out = {
    ecosysteme: m.ecosysteme,
    actants: uniq(m.actants).map(a => ({ ...a, existing: find("actant", a.titre),
      personnes: a.personnes.filter(Boolean).map(t => ({ titre: t, existing: find("personne", t) })), agents: a.agents.filter(Boolean).map(t => ({ titre: t, existing: find("agent", t) })) })),
    physiques: uniq(m.physiques).map(p => ({ ...p, existing: find("physique", p.titre) })),
    concepts: uniq(m.concepts).map(c => ({ ...c, existing: find("concept", c.titre) })),
    cribles: uniq(m.cribles).map(c => ({ ...c, existing: find("crible", c.titre) })),
    pouvoirs: [] as any[], pulsations: [] as any[],
  };
  const ensure = (key: "actants" | "physiques" | "concepts" | "cribles", kind: Kind, title: string) => {
    if ((out[key] as any[]).some(x => fold(x.titre) === fold(title))) return;
    const base: any = { titre: title, existing: find(kind, title) };
    if (key === "actants") Object.assign(base, { personnes: [], agents: [], lieu: null, date: null });
    if (key === "physiques") Object.assign(base, { parent: null, creation: null, importance: null, lieu: null, date: null });
    if (key === "concepts") base.parent = null;
    (out[key] as any[]).push(base);
  };
  const keyOf = (name: string): ["actants" | "physiques" | "concepts" | "cribles", Kind] | null =>
    /^physique/.test(name) ? ["physiques", "physique"] : /^crible/.test(name) ? ["cribles", "crible"] : /^actant/.test(name) ? ["actants", "actant"] : /^concept/.test(name) ? ["concepts", "concept"] : null;
  const refs = new Set<string>();
  for (const p of m.pouvoirs) {
    const pt = powerTypes.find(t => t.id === p.type);
    if (!pt) continue;
    const steps = alignSteps(pt.sequence, p);
    for (const st of steps) { const k = keyOf(st.name); if (k) for (const e of st.elements) ensure(k[0], k[1], e); }
    let ref = (p.ref || `p${out.pouvoirs.length + 1}`).trim();
    while (refs.has(ref)) ref += "'";
    refs.add(ref);
    // nom générique (le type seul) : le titre sera calculé à la création
    const titre = p.titre && !powerTypes.some(t => fold(t.id) === fold(p.titre) || fold(p.titre).includes(`pouvoir de ${fold(t.id)}`)) ? p.titre : null;
    out.pouvoirs.push({ ref, type: p.type, intensite: Math.max(-100, Math.min(100, Math.round(Number(p.intensite) || 0))), titre, maillons: steps });
  }
  // parents cités et non déclarés
  for (const p of [...out.physiques]) if (p.parent) ensure("physiques", "physique", p.parent);
  for (const c of [...out.concepts]) if (c.parent) ensure("concepts", "concept", c.parent);
  // flux : seulement vers une autre pulsation de la liste
  const pls = uniq(m.pulsations), plTitles = new Set(pls.map(p => fold(p.titre)));
  out.pulsations = pls.map(p => ({ ...p, existing: find("pulsation", p.titre), pouvoirs: p.pouvoirs.filter(r => refs.has(r)),
    flux: p.flux.filter(f => plTitles.has(fold(f.vers)) && fold(f.vers) !== fold(p.titre)) }));
  return out;
}
export type CompleteModel = ReturnType<typeof completeModel>;
