import { createStep } from "@mastra/core/workflows";
import { ontoEthiqueConfig } from "../../../config/ontoethique";
import { applyRules, type OntoModel } from "../../../lib/ontoethique/model";
import { computeMetrics } from "../../../lib/ontoethique/metrics";
import { modelTriples } from "../../../lib/ontoethique/linkedData";

// Mesure des fluctuations (sans modèle) : pouvoirs par existence et par genre, complexité ontologique, symbiose, alertes,
// spirales de Pappus ; triplets de l'export Linked Open Data
export const metricsStep = createStep({
  id: "metrics",
  execute: async ({ inputData }: any) => {
    const model: OntoModel = applyRules(inputData.model, ontoEthiqueConfig);
    model.metrics = computeMetrics(model, ontoEthiqueConfig);
    const triples = modelTriples(model, ontoEthiqueConfig, model.metrics).length;
    const s = model.metrics.symbiosis;
    console.log(`📐 Symbiose ${s.index ?? "—"} (équilibre ${s.balance ?? "—"}) : ${s.interpretation} · ${model.metrics.alerts.length} alerte(s) · ${triples} triplet(s) RDF`);
    return { model, triples };
  },
});
