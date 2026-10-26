import { createStep } from "@mastra/core/workflows";
import { ontoEthiqueConfig } from "../../../config/ontoethique";
import { adaSynthesis } from "../../../lib/ontoethique/synthesis";

// Synthèse discursive de l'ADA onto-éthique (symbiose, risques, cribles, questions) ; non bloquante
export const discourseStep = createStep({
  id: "discourse",
  execute: async ({ inputData }: any) => {
    const { model, triples } = inputData;
    if (!model.pulsations.length) {
      console.log("⚠️ Aucune pulsation : synthèse non rédigée.");
      return { model, triples, synthesis: "" };
    }
    console.log("🧠 Agent : ADA onto-éthique (synthèse)...");
    try {
      const { text } = await adaSynthesis(model, model.metrics, ontoEthiqueConfig);
      return { model, triples, synthesis: text };
    } catch (e) {
      console.warn("⚠️ Synthèse de l'ADA impossible :", (e as Error).message);
      return { model, triples, synthesis: "" };
    }
  },
});
