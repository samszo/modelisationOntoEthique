// Modèle onto-éthique d'une activité située : existences informationnelles, pulsations (évaluations des quatre pouvoirs),
// révisions humaines ; règles du métamodèle (barrière numérique, souveraineté humaine) et auto-évaluations Zotero
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import type { ZoteroArticle } from "../../tools/fetchZoteroData";
import type { Metrics } from "./metrics";

// origine d'une évaluation : proposée par un agent, saisie ou validée par un humain, auto-évaluation d'un participant
// (marqueur Zotero), imposée par une règle du métamodèle
export type Origin = "agent" | "humain" | "autoevaluation" | "regle";

export interface Existence {
  id: string;
  name: string;
  // genre (config.kinds) : humain, agent, environnement…
  kind: string;
  description?: string;
  // éléments de chaque dimension existentielle (config.dimensions) : supports, concepts, rôles, événements…
  dimensions: Record<string, string[]>;
  // cribles (interfaces, outils, grilles de lecture) par lesquels l'existence discerne et agit
  cribles?: string[];
  // documents de la collection où l'existence apparaît (titres)
  documents?: string[];
  origin?: Origin;
}

export interface Evaluation {
  // de -100 (diminution, tristesse) à +100 (augmentation, joie) ; 0 = indifférence ; null = pouvoir non observé
  score: number | null;
  // maillons de la séquence de sémiose du pouvoir (config.powers[].chain), ex. physique → crible → actant → concept
  chain: string[];
  justification?: string;
  // passage de la trace qui fonde l'évaluation
  citation?: string;
  origin: Origin;
  // validée par un humain : protégée des agents et des règles (souveraineté de l'expertise humaine)
  validated?: boolean;
}

export interface Pulsation {
  id: string;
  // rang dans la trajectoire de l'existence (ordre chronologique de l'activité)
  order: number;
  moment: string;
  existence: string;
  document?: { title: string; zoteroKey?: string; omekaItemId?: number };
  date?: string;
  evaluations: Record<string, Evaluation>;
  // valeurs tardiennes (config.values) de ce qui est discerné, de -100 à +100
  values?: Record<string, number | null>;
  origin: Origin;
}

// trace d'une modification (oa:motivatedBy) : l'histoire du modèle reste lisible
export interface Revision {
  at: string;
  author?: string;
  action: "ajout" | "modification" | "suppression";
  target: { type: "pulsation" | "existence" | "activite"; id: string };
  motivation: "editing" | "assessing" | "commenting";
  note?: string;
  before?: unknown;
  after?: unknown;
}

export interface OntoModel {
  runId: string;
  workflowId: string;
  // exécution du workflow ou évaluation saisie à la main
  mode: "workflow" | "manuel";
  activity: { title: string; description: string };
  collection?: { key: string; name: string | null } | null;
  createdAt: string;
  updatedAt: string;
  existences: Existence[];
  pulsations: Pulsation[];
  revisions: Revision[];
  metrics?: Metrics;
}

export const POWER_IDS = ["discerner", "raisonner", "resonner", "agir"] as const;

export const slug = (s: string) =>
  String(s ?? "").toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "").slice(0, 60) || "x";

export const clampScore = (v: unknown): number | null => {
  if (v === null || v === undefined || v === "") return null;
  const n = Number(v);
  return Number.isFinite(n) ? Math.max(-100, Math.min(100, Math.round(n))) : null;
};

const kindOf = (config: OntoEthiqueConfig, kind: string) => config.kinds.find(k => k.id === kind);

// règles du métamodèle, appliquées après toute évaluation (agents, saisie humaine, import) :
// scores bornés, barrière numérique sur Résonner pour les genres sans résonance (sauf évaluation humaine validée)
export function applyRules(model: OntoModel, config: OntoEthiqueConfig): OntoModel {
  const byId = new Map(model.existences.map(e => [e.id, e]));
  const barrier = config.rules.noResonanceScore;
  for (const p of model.pulsations) {
    for (const ev of Object.values(p.evaluations)) ev.score = clampScore(ev.score);
    for (const [k, v] of Object.entries(p.values ?? {})) p.values![k] = clampScore(v);
    const existence = byId.get(p.existence);
    if (!existence || barrier === null || kindOf(config, existence.kind)?.resonance !== false) continue;
    const current = p.evaluations.resonner;
    if (current?.validated && current.origin !== "regle" && config.rules.humanSovereignty) continue;
    p.evaluations.resonner = {
      score: barrier, chain: [], origin: "regle", validated: true,
      justification: "Barrière numérique : le pouvoir de résonance n'est pas accessible à ce genre d'existence (règle du métamodèle).",
    };
  }
  return model;
}

// identifiant de pouvoir à partir d'un marqueur (identifiant ou libellé, accents ignorés)
function powerFromTag(config: OntoEthiqueConfig, word: string) {
  const w = slug(word);
  return config.powers.find(p => slug(p.id) === w || slug(p.label) === w)?.id ?? null;
}

// auto-évaluations des participants : annotations ou notes Zotero portant des marqueurs « pouvoir±score »
// → une pulsation par annotation, attribuée à l'actant humain auteur de l'annotation (créé au besoin)
export function selfEvaluations(articles: ZoteroArticle[], config: OntoEthiqueConfig) {
  if (!config.selfEvaluation.enabled) return { existences: [] as Existence[], pulsations: [] as Pulsation[] };
  const re = new RegExp(config.selfEvaluation.tagPattern, "i");
  const existences = new Map<string, Existence>();
  const pulsations: Pulsation[] = [];
  for (const a of articles) {
    for (const an of a.annotations ?? []) {
      const evaluations: Record<string, Evaluation> = {};
      for (const tag of an.tags ?? []) {
        const m = re.exec(tag);
        const power = m ? powerFromTag(config, m[1]!) : null;
        if (!power) continue;
        evaluations[power] = { score: clampScore(m![2]), chain: [], justification: an.note || undefined, citation: an.phrase || undefined, origin: "autoevaluation", validated: true } as Evaluation;
      }
      if (!Object.keys(evaluations).length) continue;
      const author = an.author || "Participant non identifié";
      const id = `humain-${slug(author)}`;
      if (!existences.has(id)) existences.set(id, { id, name: author, kind: "humain", dimensions: {}, documents: [], origin: "autoevaluation" });
      const ex = existences.get(id)!;
      if (!ex.documents!.includes(a.title)) ex.documents!.push(a.title);
      pulsations.push({
        id: "", order: 0, existence: id, origin: "autoevaluation",
        moment: (an.phrase || an.note || a.title).slice(0, 140),
        document: { title: a.title, zoteroKey: a.zoteroKey, ...(a.omekaItemId ? { omekaItemId: a.omekaItemId } : {}) },
        ...(an.date ? { date: an.date } : {}),
        evaluations,
      });
    }
  }
  return { existences: [...existences.values()], pulsations };
}

// numérotation stable des pulsations (p1, p2…) et ordre dans la trajectoire de chaque existence (date, puis rang)
export function numberPulsations(pulsations: Pulsation[]) {
  pulsations.forEach((p, i) => { if (!p.id) p.id = `p${i + 1}`; });
  const used = new Set<string>();
  for (const p of pulsations) {
    while (used.has(p.id)) p.id = `${p.id}b`;
    used.add(p.id);
  }
  const byExistence = new Map<string, Pulsation[]>();
  for (const p of pulsations) byExistence.set(p.existence, [...(byExistence.get(p.existence) ?? []), p]);
  for (const list of byExistence.values()) {
    list.filter(p => !p.order).forEach(p => (p.order = Math.max(0, ...list.map(x => x.order)) + 1));
  }
  return pulsations;
}

// pulsations d'une existence dans l'ordre de sa trajectoire
export const trajectory = (model: OntoModel, existenceId: string) =>
  model.pulsations.filter(p => p.existence === existenceId).sort((a, b) => a.order - b.order || String(a.date ?? "").localeCompare(String(b.date ?? "")));

// tableau à plat (CSV) : une ligne par pulsation et par pouvoir
export function matrixCsv(model: OntoModel, config: OntoEthiqueConfig): string {
  const names = new Map(model.existences.map(e => [e.id, e]));
  const q = (v: unknown) => `"${String(v ?? "").replace(/"/g, '""').replace(/\r?\n/g, " ")}"`;
  const rows = [["pulsation", "ordre", "existence", "genre", "moment", "document", "pouvoir", "score", "sémiose", "justification", "citation", "origine", "validée", ...config.values.map(v => v.label)].map(q).join(",")];
  for (const p of model.pulsations) {
    const ex = names.get(p.existence);
    for (const power of config.powers) {
      const ev = p.evaluations[power.id];
      if (!ev) continue;
      rows.push([p.id, p.order, ex?.name ?? p.existence, ex?.kind ?? "", p.moment, p.document?.title ?? "", power.label, ev.score ?? "", ev.chain.join(" → "), ev.justification ?? "", ev.citation ?? "", ev.origin, ev.validated ? "oui" : "non",
        ...config.values.map(v => p.values?.[v.id] ?? "")].map(q).join(","));
    }
  }
  return rows.join("\n") + "\n";
}

// nouveau modèle vide (évaluation saisie à la main ou exécution du workflow)
export function emptyModel(o: { runId: string; workflowId: string; mode: OntoModel["mode"]; activity: OntoModel["activity"]; collection?: OntoModel["collection"] }): OntoModel {
  const now = new Date().toISOString();
  return { runId: o.runId, workflowId: o.workflowId, mode: o.mode, activity: o.activity, collection: o.collection ?? null, createdAt: now, updatedAt: now, existences: [], pulsations: [], revisions: [] };
}
