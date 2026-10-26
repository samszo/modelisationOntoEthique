// Rapport d'une exécution d'ontoÉthique (markdown) : existences, matrice des affects, symbiose, alertes, spirales, coût
import type { UsageSummary } from "../../lib/metrics/usage";
import type { ImpactSummary } from "../../lib/metrics/impact";
import type { OntoModel } from "../../lib/ontoethique/model";
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import { usageReport } from "./usageReport";

const cell = (s: unknown) => String(s ?? "").replace(/\|/g, "\\|").replace(/\n/g, " ");
const num = (x: number | null | undefined) => (x === null || x === undefined ? "—" : x.toLocaleString("fr-FR"));

export function buildOntoEthiqueReport(ctx: {
  runId: string; status: string; startedAt: Date; endedAt: Date; collectionName: string | null;
  model: OntoModel | null; config: OntoEthiqueConfig; documents: number; triples: number | null;
  usage?: UsageSummary; impact?: ImpactSummary; error?: string;
}): string {
  const { model, config } = ctx;
  const m = model?.metrics;
  const lines: string[] = [];
  const push = (...l: string[]) => lines.push(...l);
  const kind = (k: string) => config.kinds.find(x => x.id === k)?.label ?? k;

  push(
    `# Modélisation onto-éthique – ${cell(model?.activity.title ?? config.activity.title)}`,
    "",
    `Exécution \`${ctx.runId}\` · ${ctx.startedAt.toLocaleString("fr-FR")} · statut **${ctx.status}** · durée ${Math.round((ctx.endedAt.getTime() - ctx.startedAt.getTime()) / 1000)} s` +
      (ctx.collectionName ? ` · collection « ${cell(ctx.collectionName)} »` : ""),
    ""
  );
  if (ctx.error) push(`> ❌ ${cell(ctx.error)}`, "");
  if (model?.activity.description) push(`> ${cell(model.activity.description)}`, "");

  if (model && m) {
    const t = m.totals;
    push(
      "## Synthèse des mesures",
      "",
      `**${t.existences}** existence(s), **${t.pulsations}** pulsation(s) et **${t.evaluations}** évaluation(s) à partir de ${ctx.documents} document(s)` +
        `${t.validated ? ` (${t.validated} validée(s) par un humain, une règle ou une auto-évaluation)` : ""}${ctx.triples !== null ? ` · ${num(ctx.triples)} triplets RDF` : ""}.`,
      "",
      `Symbiose : indice **${num(m.symbiosis.index)}** (de -1 à 1), équilibre entre genres **${num(m.symbiosis.balance)}** — ${m.symbiosis.interpretation}. Complexité ontologique moyenne : ${num(m.complexity.mean)}.`,
      "",
      "## Existences informationnelles",
      "",
      `| Existence | Genre | ${config.dimensions.map(d => d.label).join(" | ")} | Cribles | Complexité |`,
      `|---|---|${config.dimensions.map(() => "---").join("|")}|---|---|`,
      ...model.existences.map(e => {
        const x = m.existences.find(y => y.id === e.id);
        return `| ${cell(e.name)} | ${cell(kind(e.kind))} | ${config.dimensions.map(d => cell((e.dimensions?.[d.id] ?? []).join(", ") || "—")).join(" | ")} | ${cell((e.cribles ?? []).join(", ") || "—")} | ${num(x?.complexity.index)} |`;
      }),
      "",
      "## Matrice des affects (moyennes)",
      "",
      `| Existence | ${config.powers.map(p => p.label).join(" | ")} | Valence | Intensité | Affect | ${config.values.map(v => v.label).join(" | ")} |`,
      `|---|${config.powers.map(() => "---").join("|")}|---|---|---|${config.values.map(() => "---").join("|")}|`,
      ...m.existences.map(e => `| ${cell(e.name)} (${e.pulsations}) | ${config.powers.map(p => { const s = e.powers[p.id]; return s?.count ? `${num(s.mean)} · ${cell(s.stateName)}` : "—"; }).join(" | ")} | ${num(e.valence)} | ${num(e.intensity)} | ${e.affect ?? "—"} | ${config.values.map(v => num(e.values[v.id])).join(" | ")} |`),
      "",
      "### Par genre d'existence",
      "",
      `| Genre | Existences | ${config.powers.map(p => p.label).join(" | ")} | Valence |`,
      `|---|---|${config.powers.map(() => "---").join("|")}|---|`,
      ...Object.values(m.byKind).filter(k => k.existences).map(k => `| ${cell(k.label)} | ${k.existences} | ${config.powers.map(p => num(k.powers[p.id])).join(" | ")} | ${num(k.valence)} |`),
      "",
      "## Spirales coniques de Pappus",
      "",
      "| Existence | Dilatation (Σ Résonner +) | Altitude (Σ Agir +) | Déplacement (Σ Discerner + Raisonner) | Rayon / altitude | Forme |",
      "|---|---|---|---|---|---|",
      ...m.existences.map(e => `| ${cell(e.name)} | ${num(e.spiral.dilation)} | ${num(e.spiral.altitude)} | ${num(e.spiral.displacement)} (${num(e.spiral.turns)} tour(s)) | ${num(e.spiral.ratio)} | ${cell(e.spiral.shape)} |`),
      ""
    );
    if (m.alerts.length) push("## Alertes", "", ...m.alerts.map(a => `- **${a.level}** — ${cell(a.message)}`), "");
  } else if (!ctx.error) {
    push("> Aucun modèle produit.", "");
  }

  push(...usageReport(ctx.usage, ctx.impact));
  return lines.join("\n");
}
