// Mise en forme des données transmises aux agents d'ontoÉthique (activité, métamodèle, grille des affects, traces,
// existences, pulsations) et schémas de leurs réponses structurées
import { z } from "zod";
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import type { ZoteroArticle } from "../../tools/fetchZoteroData";
import type { Existence, OntoModel } from "./model";
import type { Metrics } from "./metrics";

export const fillTemplate = (template: string, vars: Record<string, string>) =>
  template.replace(/\{\{(\w+)\}\}/g, (m, k) => (k in vars ? vars[k] || "(aucun)" : m));

export const formatActivity = (a: OntoModel["activity"]) => `${a.title}\n${a.description}`.trim();

export const formatKinds = (config: OntoEthiqueConfig) =>
  config.kinds.map(k => `- ${k.id} : ${k.label}${k.resonance ? "" : " (sans résonance)"}`).join("\n");

export const formatDimensions = (config: OntoEthiqueConfig) =>
  config.dimensions.map(d => `- ${d.id} — ${d.label} (${d.spinoza} ; métrique ${d.metric} ; ${d.pretopology} ; ${d.analogy}) : ${d.instruction}`).join("\n");

export const formatGrid = (config: OntoEthiqueConfig) =>
  config.powers.map(p => `- ${p.id} — ${p.label} (${p.semiosis}) ; séquence : ${p.chain.join(" → ")}\n  -100 à -1 : ${p.negative.name} (${p.negative.description}) ; 0 : ${p.neutral.name} (${p.neutral.description}) ; +1 à +100 : ${p.positive.name} (${p.positive.description})`).join("\n");

export const formatValues = (config: OntoEthiqueConfig) =>
  config.values.map(v => `- ${v.id} — ${v.label} (${v.force}) : ${v.question}`).join("\n");

export const formatExistences = (existences: Existence[], config: OntoEthiqueConfig, detailed = false) =>
  existences.map(e => {
    const head = `- ${e.id} : ${e.name} (${config.kinds.find(k => k.id === e.kind)?.label ?? e.kind})`;
    if (!detailed) return head;
    const dims = config.dimensions.map(d => `${d.label} : ${(e.dimensions?.[d.id] ?? []).join(", ") || "—"}`).join(" ; ");
    return `${head}${e.description ? ` — ${e.description}` : ""}\n  ${dims}${e.cribles?.length ? ` ; cribles : ${e.cribles.join(", ")}` : ""}`;
  }).join("\n");

// trace documentaire : titre, annotations et notes (auteur, date, marqueurs), début du texte
export function formatDocument(a: ZoteroArticle, n: number, config: OntoEthiqueConfig, maxChars = config.analysis.maxCharsPerDocument) {
  const anns = (a.annotations ?? []).slice(0, config.analysis.maxAnnotationsPerDocument).map(x =>
    `- ${x.phrase ? `« ${x.phrase.trim()} »` : "(note)"}${x.note ? ` — ${x.note.trim()}` : ""} (${[x.author, x.date?.slice(0, 10), ...(x.tags ?? [])].filter(Boolean).join(", ") || "sans auteur"})`);
  const text = (a.text ?? "").replace(/\s+\n/g, "\n").trim();
  return [
    `[D${n}] ${a.title}${a.tags?.length ? ` — marqueurs : ${a.tags.join(", ")}` : ""}`,
    anns.length ? `Annotations et notes :\n${anns.join("\n")}` : "",
    text ? `Texte :\n${text.slice(0, maxChars)}${text.length > maxChars ? "\n[…]" : ""}` : "",
  ].filter(Boolean).join("\n");
}

// indicateurs de l'écosystème et de chaque existence (synthèse de l'ADA)
export function formatMetrics(metrics: Metrics, config: OntoEthiqueConfig) {
  const s = metrics.symbiosis;
  const lines = [`Symbiose : indice ${s.index ?? "—"} (de -1 à 1), équilibre entre genres ${s.balance ?? "—"} (1 = mêmes fluctuations) — ${s.interpretation}.`,
    `Complexité ontologique moyenne : ${metrics.complexity.mean ?? "—"}.`];
  for (const e of metrics.existences) {
    lines.push(`- ${e.name} (${e.kind}, ${e.pulsations} pulsation(s)) : ${config.powers.map(p => `${p.label} ${e.powers[p.id]?.mean ?? "—"}${e.powers[p.id]?.stateName ? ` (${e.powers[p.id]!.stateName})` : ""}`).join(", ")} ; valence ${e.valence ?? "—"}, intensité ${e.intensity ?? "—"}, affect ${e.affect ?? "—"} ; ` +
      `${config.values.map(v => `${v.label} ${e.values[v.id] ?? "—"}`).join(", ")} ; complexité ${e.complexity.index} ; spirale : ${e.spiral.shape} (dilatation ${e.spiral.dilation}, altitude ${e.spiral.altitude}, ${e.spiral.turns} tour(s))`);
  }
  return lines.join("\n");
}

// pulsations les plus intenses, avec origine et validation
export function formatPulsations(model: OntoModel, config: OntoEthiqueConfig, max: number) {
  const name = new Map(model.existences.map(e => [e.id, e.name]));
  const intensity = (p: OntoModel["pulsations"][number]) => Object.values(p.evaluations).reduce((n, e) => n + Math.abs(e.score ?? 0), 0);
  return [...model.pulsations].sort((a, b) => intensity(b) - intensity(a)).slice(0, max).map(p =>
    `- [${p.id}] ${name.get(p.existence) ?? p.existence} — ${p.moment}${p.document ? ` (${p.document.title})` : ""} : ` +
    config.powers.map(pw => { const e = p.evaluations[pw.id]; return e && e.score !== null ? `${pw.label} ${e.score} [${e.origin}${e.validated ? ", validé" : ""}]${e.chain.length ? ` (${e.chain.join(" → ")})` : ""}${e.justification ? ` « ${e.justification} »` : ""}` : null; }).filter(Boolean).join(" ; ")
  ).join("\n");
}

// ==========================================
// Schémas des réponses structurées
// ==========================================
export const existencesSchema = (config: OntoEthiqueConfig) => z.object({
  existences: z.array(z.object({
    id: z.string(),
    name: z.string(),
    kind: z.string(),
    description: z.string(),
    ...Object.fromEntries(config.dimensions.map(d => [d.id, z.array(z.string())])),
    cribles: z.array(z.string()),
    // numéros des documents [D…] où l'existence apparaît
    documents: z.array(z.number()),
  })),
});

const evaluationSchema = z.object({ score: z.number().nullable(), chain: z.array(z.string()), justification: z.string(), citation: z.string() });

export const pulsationsSchema = (config: OntoEthiqueConfig) => z.object({
  pulsations: z.array(z.object({
    moment: z.string(),
    existence: z.string(),
    ...Object.fromEntries(config.powers.map(p => [p.id, evaluationSchema])),
    ...Object.fromEntries(config.values.map(v => [v.id, z.number().nullable()])),
  })),
});
