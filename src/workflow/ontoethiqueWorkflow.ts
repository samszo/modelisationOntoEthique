import { createWorkflow } from "@mastra/core/workflows";
import { z } from "zod";
import { fetchLiteratureStep } from "./steps/common/fetchLiteratureStep";
import { existencesStep } from "./steps/ontoethique/existencesStep";
import { pulsationsStep } from "./steps/ontoethique/pulsationsStep";
import { metricsStep } from "./steps/ontoethique/metricsStep";
import { discourseStep } from "./steps/ontoethique/discourseStep";
import { ontoEthiqueConfig } from "../config/ontoethique";

// ontoÉthique : traces de l'activité (Zotero → Omeka S), existences et leurs dimensions, pulsations évaluées dans la
// grille des affects, mesure des fluctuations et de la symbiose, synthèse de l'ADA onto-éthique
export const ontoEthiqueWorkflow = createWorkflow({
  id: ontoEthiqueConfig.workflowId,
  inputSchema: z.object({ zoteroCollection: z.string(), mergeDuplicates: z.boolean().optional() }),
} as any)
  .then(fetchLiteratureStep)
  .then(existencesStep)
  .then(pulsationsStep)
  .then(metricsStep)
  .then(discourseStep)
  .commit();
