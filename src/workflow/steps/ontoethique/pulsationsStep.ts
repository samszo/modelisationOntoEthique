import { createStep } from "@mastra/core/workflows";
import { askAgent } from "../../../agents/ask";
import { affectsAgent, AFFECTS_PROMPT } from "../../../agents/affectsAgent";
import { agentText } from "../../../agents/overrides";
import { ontoEthiqueConfig } from "../../../config/ontoethique";
import { applyRules, clampScore, emptyModel, numberPulsations, slug, type Evaluation, type Existence, type Pulsation } from "../../../lib/ontoethique/model";
import { fillTemplate, formatActivity, formatDocument, formatExistences, formatGrid, formatValues, pulsationsSchema } from "../../../lib/ontoethique/prompts";
import type { ZoteroArticle } from "../../../tools/fetchZoteroData";
import { selectDocuments } from "./existencesStep";

// exécute fn sur chaque élément avec au plus `limit` appels simultanés, dans l'ordre des résultats
async function mapLimit<T, R>(items: T[], limit: number, fn: (x: T, i: number) => Promise<R>): Promise<R[]> {
  const out: R[] = new Array(items.length);
  let next = 0;
  await Promise.all(Array.from({ length: Math.max(1, Math.min(limit, items.length)) }, async () => {
    while (next < items.length) { const i = next++; out[i] = await fn(items[i]!, i); }
  }));
  return out;
}

// Pulsations attestées par chaque trace (évaluateur des affects), auto-évaluations des participants, règles du métamodèle
export const pulsationsStep = createStep({
  id: "pulsations",
  execute: async ({ inputData, getStepResult, runId }: any) => {
    const config = ontoEthiqueConfig;
    const literature: any = getStepResult("fetch-literature") ?? {};
    const documents = selectDocuments(literature.articles ?? []);
    const existences: Existence[] = inputData?.existences ?? [];
    const selfPulsations: Pulsation[] = inputData?.selfPulsations ?? [];
    const ids = new Set(existences.map(e => e.id));
    // existence désignée par l'agent : identifiant donné, sinon nom approché
    const resolve = (ref: string) => (ids.has(ref) ? ref : existences.find(e => slug(e.name) === slug(ref) || slug(e.id) === slug(ref))?.id ?? null);

    const template = agentText("affects-agent", "prompt", AFFECTS_PROMPT);
    const common = { activite: formatActivity(config.activity), existences: formatExistences(existences, config), grille: formatGrid(config), valeurs: formatValues(config) };
    let skipped = 0, failed = 0;
    const perDocument = await mapLimit(documents, config.analysis.concurrency, async (a: ZoteroArticle, i) => {
      console.log(`🧠 Agent : Évaluateur des affects — [D${i + 1}] ${a.title}`);
      try {
        const { object } = await askAgent(affectsAgent, {
          model: config.models.analytics, source: "Pulsations et grille des affects (affectsAgent)", schema: pulsationsSchema(config),
          prompt: fillTemplate(template, { ...common, document: formatDocument(a, i + 1, config) }),
        });
        const list: Pulsation[] = [];
        for (const x of (object?.pulsations ?? []) as any[]) {
          const existence = resolve(String(x.existence ?? ""));
          if (!existence) { skipped++; continue; }
          const evaluations: Record<string, Evaluation> = {};
          for (const p of config.powers) {
            const ev = x[p.id];
            const score = clampScore(ev?.score);
            if (score === null) continue;
            evaluations[p.id] = { score, chain: (ev.chain ?? []).map(String).filter(Boolean), justification: ev.justification || undefined, citation: ev.citation || undefined, origin: "agent", validated: false } as Evaluation;
          }
          if (!Object.keys(evaluations).length) continue;
          list.push({
            id: "", order: 0, existence, origin: "agent", moment: String(x.moment || a.title).slice(0, 200),
            document: { title: a.title, zoteroKey: a.zoteroKey, ...(a.omekaItemId ? { omekaItemId: a.omekaItemId } : {}) },
            evaluations, values: Object.fromEntries(config.values.map(v => [v.id, clampScore(x[v.id])])),
          });
        }
        return list;
      } catch (e) {
        failed++;
        console.warn(`⚠️ Évaluation de « ${a.title} » impossible :`, (e as Error).message);
        return [];
      }
    });

    // dans l'ordre des documents : auto-évaluations du document, puis pulsations proposées par l'agent
    const pulsations: Pulsation[] = [];
    documents.forEach((a, i) => pulsations.push(...selfPulsations.filter(p => p.document?.zoteroKey === a.zoteroKey), ...perDocument[i]!));
    if (skipped) console.warn(`⚠️ ${skipped} pulsation(s) attribuée(s) à une existence inconnue, ignorée(s)`);
    if (documents.length && failed === documents.length && !selfPulsations.length) throw new Error("Aucune trace n'a pu être évaluée (voir les avertissements ci-dessus).");

    const model = emptyModel({ runId: runId ?? "", workflowId: config.workflowId, mode: "workflow", activity: config.activity });
    model.existences = existences;
    model.pulsations = numberPulsations(pulsations);
    applyRules(model, config);
    console.log(`💓 ${model.pulsations.length} pulsation(s) évaluée(s) sur ${documents.length} document(s)`);
    return { model };
  },
});
