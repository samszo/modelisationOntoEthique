// Synthèse discursive de l'ADA onto-éthique : appelée par l'étape « discourse » et, après des corrections humaines,
// par la route POST /api/ontoethique/synthesis
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import { askAgent } from "../../agents/ask";
import { adaAgent, ADA_PROMPT } from "../../agents/adaAgent";
import { agentText } from "../../agents/overrides";
import type { OntoModel } from "./model";
import type { Metrics } from "./metrics";
import { fillTemplate, formatActivity, formatExistences, formatMetrics, formatPulsations } from "./prompts";

export async function adaSynthesis(model: OntoModel, metrics: Metrics, config: OntoEthiqueConfig, source = "Synthèse onto-éthique (adaAgent)") {
  // demande de l'agent : celle par défaut ou celle modifiée dans l'onglet Workflow (agents.config.json)
  const prompt = fillTemplate(agentText("ada-agent", "prompt", ADA_PROMPT), {
    activite: formatActivity(model.activity),
    existences: formatExistences(model.existences, config, true),
    indicateurs: formatMetrics(metrics, config),
    alertes: metrics.alerts.map(a => `- [${a.level}] ${a.message}`).join("\n"),
    pulsations: formatPulsations(model, config, config.discourse.maxPulsations),
  });
  const { text, usage } = await askAgent(adaAgent, { model: config.models.analytics, source, prompt });
  return { text: text.trim(), usage };
}
