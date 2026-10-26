// Sections « Consommation de tokens » et « Coût du traitement », partagées par les rapports des workflows
import type { UsageSummary } from "../../lib/metrics/usage";
import { fmtCo2, fmtEnergy, fmtMoney, type ImpactSummary } from "../../lib/metrics/impact";

const cell = (s: unknown) => String(s ?? "").replace(/\|/g, "\\|").replace(/\n/g, " ");

export function usageReport(usage?: UsageSummary, impact?: ImpactSummary): string[] {
  const lines: string[] = [];
  const push = (...l: string[]) => lines.push(...l);
  // ==========================================
  // Consommation de tokens
  // ==========================================
  if (usage?.calls) {
    const u = usage;
    const n = (x: number) => x.toLocaleString("fr-FR");
    push(
      "## Consommation de tokens",
      "",
      `**${n(u.totalTokens)} tokens** au total pour ${u.calls} appel(s) aux modèles : ${n(u.inputTokens)} en entrée, ${n(u.outputTokens)} en sortie` +
        (u.reasoningTokens ? ` (dont ${n(u.reasoningTokens)} de raisonnement)` : "") + ".",
      "",
      "| Traitement | Modèle | Appels | Entrée | Sortie | Total |",
      "|---|---|---|---|---|---|"
    );
    for (const e of [...u.entries].sort((a, b) => b.totalTokens - a.totalTokens)) {
      push(`| ${cell(e.source)} | \`${e.model}\` | ${e.calls} | ${n(e.inputTokens)} | ${n(e.outputTokens)} | ${n(e.totalTokens)} |`);
    }
    // total par modèle
    const byModel = new Map<string, number>();
    for (const e of u.entries) byModel.set(e.model, (byModel.get(e.model) ?? 0) + e.totalTokens);
    for (const [model, total] of byModel) push(`| **Total** | \`${model}\` | | | | **${n(total)}** |`);
    push("");
    if (u.unknown) push(`> ${u.unknown} appel(s) sans consommation renvoyée par l'API, non comptés.`, "");
  }

  // ==========================================
  // Coût du traitement (estimation)
  // ==========================================
  if (impact?.models.length) {
    const im = impact;
    const h = im.hypotheses;
    const cur = im.currency;
    push(
      "## Coût du traitement (estimation)",
      "",
      "| | |",
      "|---|---|",
      `| Énergie | **${fmtEnergy(im.energyWh)}** |`,
      `| Émissions | **${fmtCo2(im.co2g)}** |`,
      `| Coût de l'électricité | ${fmtMoney(im.electricityCost, cur)} |`,
      `| Coût équivalent API (tarifs de référence) | **${fmtMoney(im.apiCost, cur)}** |`,
      "",
      "| Modèle | Tokens | Énergie | Émissions | Coût équivalent API |",
      "|---|---|---|---|---|"
    );
    for (const m of im.models) {
      push(`| \`${m.model}\`${m.known ? "" : " ¹"} | ${m.tokens.toLocaleString("fr-FR")} | ${fmtEnergy(m.energyWh)} | ${fmtCo2(m.co2g)} | ${fmtMoney(m.apiCost, cur)} |`);
    }
    push("");
    if (im.models.some(m => !m.known)) push("¹ Modèle absent de la configuration des coûts : valeurs par défaut utilisées.", "");
    // ordres de grandeur pour situer l'estimation
    const ledMinutes = (im.energyWh / 10) * 60;
    const phoneCharges = im.energyWh / 15;
    push(
      `Ordres de grandeur : l'énergie équivaut à ${ledMinutes < 1 ? `${Math.round(ledMinutes * 60)} secondes` : `${Math.round(ledMinutes)} minutes`} d'une ampoule LED de 10 W, soit ${phoneCharges.toLocaleString("fr-FR", { maximumFractionDigits: 2 })} recharge(s) de smartphone (≈ 15 Wh).`,
      "",
      "> **Méthode et hypothèses** — estimation, non mesure. Énergie par token ≈ 2 × paramètres actifs du modèle (opérations) ÷ " +
        `(rendement GPU ${h.hardware.flopsPerJoule.toExponential(1).replace(".", ",").replace("e+", " × 10^")} opérations/J × utilisation ${Math.round(h.hardware.utilization * 100)} %) × PUE ${h.hardware.pue.toLocaleString("fr-FR")} ; ` +
        `émissions = énergie × ${h.carbonIntensity.toLocaleString("fr-FR")} gCO₂e/kWh ; électricité à ${h.electricityPrice.toLocaleString("fr-FR")} ${cur}/kWh. ` +
        "Le coût équivalent API applique les tarifs de référence du marché (€ par million de tokens en entrée et en sortie) : l'API Albert étant mise à disposition par l'État, ce n'est pas un montant facturé. " +
        "Non compris : fabrication du matériel, réseau, postes de travail. Hypothèses modifiables dans `workflow.config.json` (section `costs`).",
      ""
    );
  }
  return lines;
}
