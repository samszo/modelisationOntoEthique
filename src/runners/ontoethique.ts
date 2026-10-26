// Lancement du workflow ontoÉthique (npm run ontoethique, ou depuis l'application cliente)
import "dotenv/config";
import fs from "fs/promises";
import path from "path";
import { ontoEthiqueWorkflow } from "../workflow/ontoethiqueWorkflow";
import { ontoEthiqueConfig, RUNS_DIR } from "../config/ontoethique";
import { buildOntoEthiqueReport } from "../workflow/reports/ontoethiqueReport";
import { saveWorkflowConfig, updateWorkflowStatus } from "../workflow/runs/saveWorkflowConfig";
import { attachDocuments, type SynthesisDocument } from "../workflow/runs/importSynthesis";
import { appendUsageHistory } from "../lib/metrics/usageHistory";
import { usageSummary } from "../lib/metrics/usage";
import { estimateImpact, fmtCo2, fmtEnergy, fmtMoney } from "../lib/metrics/impact";
import { Zotero } from "../lib/zotero/zotero";
import { writeModelFiles } from "../lib/ontoethique/outputs";
import type { OntoModel } from "../lib/ontoethique/model";

async function main() {
  console.log("🚀 ontoÉthique : modélisation onto-éthique des existences informationnelles...");
  const config = ontoEthiqueConfig;
  const input = { zoteroCollection: config.input.zoteroCollection, mergeDuplicates: config.analysis.mergeDuplicates };
  if (!input.zoteroCollection) {
    // chaîne exacte lue par src/ui/server.ts pour marquer l'exécution en échec
    console.error("❌ Le workflow a échoué : aucune collection Zotero choisie (onglet Activité). Pour une évaluation sans collection, utiliser « Nouvelle évaluation manuelle ».");
    process.exitCode = 1;
    return;
  }
  const outDir = path.resolve(process.cwd(), config.outputDir);
  await fs.mkdir(outDir, { recursive: true });
  const out = (name: string) => path.join(outDir, name);

  // nom de la collection (rapport, liste des évaluations)
  const collectionName = await new Zotero(process.env.ZOTERO_USER_ID ?? "", process.env.ZOTERO_API_KEY ?? "", process.env.ZOTERO_GROUP_ID || undefined)
    .collection(input.zoteroCollection).then((c: any) => c.data?.name ?? input.zoteroCollection).catch(() => input.zoteroCollection);

  const run = await ontoEthiqueWorkflow.createRun();
  let configItemId: number | null = null;
  try {
    configItemId = await saveWorkflowConfig(run.runId, input, { workflowId: config.workflowId, config: { ...config, collectionName } });
  } catch (e) {
    console.warn("⚠️ Configuration non enregistrée dans Omeka S :", (e as Error).message);
  }

  const startedAt = new Date();
  const runResult: any = await run.start({ inputData: input });
  const endedAt = new Date();
  if (runResult.status === "failed") console.error("❌ Le workflow a échoué :", runResult.error?.message ?? runResult.error);
  const steps = runResult.steps ?? {};
  const final = steps["discourse"]?.output ?? steps["metrics"]?.output ?? steps["pulsations"]?.output ?? null;
  const model: OntoModel | null = final?.model ?? null;
  const synthesis: string = steps["discourse"]?.output?.synthesis ?? "";
  const documents: number = steps["existences"]?.output?.documents ?? 0;

  const usage = usageSummary();
  // historique de la consommation (estimation du coût dans l'onglet Workflow)
  appendUsageHistory("ontoethique", usage);
  const impact = estimateImpact(usage);
  console.log(`🔢 Tokens : ${usage.totalTokens.toLocaleString("fr-FR")} · ⚡ ${fmtEnergy(impact.energyWh)}, ${fmtCo2(impact.co2g)}, équivalent API ${fmtMoney(impact.apiCost, impact.currency)}`);

  // archive de l'exécution : fichiers dérivés du modèle (repris après chaque correction humaine), synthèse, rapport
  const archive = path.join(outDir, RUNS_DIR, run.runId);
  const files: SynthesisDocument[] = [];
  if (model) {
    model.runId = run.runId;
    model.collection = { key: input.zoteroCollection, name: collectionName };
    files.push(...await writeModelFiles(archive, model, config));
  }
  await fs.mkdir(archive, { recursive: true });
  if (synthesis) {
    await fs.writeFile(path.join(archive, "synthese_ada.md"), `# Synthèse onto-éthique – ${model?.activity.title ?? config.activity.title}\n\n${synthesis.replace(/^#\s.*\n+/, "")}\n`);
    files.push({ filePath: path.join(archive, "synthese_ada.md"), title: "Synthèse de l'ADA onto-éthique" });
  }
  await fs.writeFile(path.join(archive, "rapport_ontoethique.md"), buildOntoEthiqueReport({
    runId: run.runId, status: runResult.status, startedAt, endedAt, collectionName, model, config, documents,
    triples: steps["metrics"]?.output?.triples ?? null, usage, impact,
    ...(runResult.status === "failed" ? { error: String(runResult.error?.message ?? runResult.error) } : {}),
  }));
  files.push({ filePath: path.join(archive, "rapport_ontoethique.md"), title: "Rapport de l'exécution ontoÉthique" });
  try {
    await fs.writeFile(path.join(archive, "analyse.json"), JSON.stringify({
      runId: run.runId, workflowId: config.workflowId, mode: "workflow", status: runResult.status,
      startedAt: startedAt.toISOString(), endedAt: endedAt.toISOString(),
      activity: model?.activity ?? config.activity, collection: { key: input.zoteroCollection, name: collectionName }, configItemId,
      tokens: { calls: usage.calls, input: usage.inputTokens, output: usage.outputTokens, total: usage.totalTokens },
      impact: { energyWh: impact.energyWh, co2g: impact.co2g, electricityCost: impact.electricityCost, apiCost: impact.apiCost, currency: impact.currency },
      totals: model?.metrics?.totals ?? null, symbiosis: model?.metrics?.symbiosis ?? null,
      config,
    }, null, 2));
  } catch (e) {
    console.warn("⚠️ Description de l'exécution non écrite :", (e as Error).message);
  }
  // copie de la dernière exécution à la racine de outputDir (consultation directe des fichiers)
  for (const f of files) await fs.copyFile(f.filePath, out(path.basename(f.filePath))).catch(() => {});
  console.log(`📋 Résultats écrits dans './${config.outputDir}/${RUNS_DIR}/${run.runId}/'`);

  // enregistrement dans Omeka S : statut, consommation et documents dans l'item de configuration
  if (configItemId) {
    const imp = { energyWh: impact.energyWh, co2g: impact.co2g, electricityCost: impact.electricityCost, apiCost: impact.apiCost, currency: impact.currency };
    await updateWorkflowStatus(configItemId, runResult.status, usage, imp).catch(e => console.warn("⚠️ Statut non enregistré dans Omeka S :", (e as Error).message));
    console.log(`\n📤 [OMEKA] Import des résultats dans la configuration de l'exécution (Item ID ${configItemId})...`);
    await attachDocuments(configItemId, files, run.runId, null).catch(e => console.warn("⚠️ Documents non importés :", (e as Error).message));
  }
  console.log(runResult.status === "success" ? "✅ Modélisation onto-éthique terminée." : `Modélisation terminée avec le statut ${runResult.status}.`);
}

main().catch(e => { console.error("❌ Le workflow a échoué :", (e as Error).message); process.exitCode = 1; });
