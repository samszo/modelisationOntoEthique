// Fichiers d'une évaluation onto-éthique (liste blanche servie par le serveur) et écriture des fichiers dérivés du modèle
// (indicateurs recalculés, CSV, Turtle, JSON-LD, spirales) — après le workflow comme après une correction humaine
import fs from "fs/promises";
import path from "path";
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import type { SynthesisDocument } from "../../workflow/runs/importSynthesis";
import { applyRules, matrixCsv, type OntoModel } from "./model";
import { computeMetrics } from "./metrics";
import { toJsonLd, toTurtle } from "./linkedData";
import { spiralHtml } from "./spiralHtml";

export const ONTO_FILES = [
  { name: "rapport_ontoethique.md", title: "Rapport de l'exécution", type: "text/markdown" },
  { name: "synthese_ada.md", title: "Synthèse de l'ADA onto-éthique", type: "text/markdown" },
  { name: "modele.json", title: "Modèle onto-éthique (données)", type: "application/json" },
  { name: "matrice_affects.csv", title: "Matrice des affects (CSV)", type: "text/csv" },
  { name: "modele_onto_ethique.ttl", title: "Modèle onto-éthique (Turtle)", type: "text/turtle" },
  { name: "modele_onto_ethique.jsonld", title: "Modèle onto-éthique (JSON-LD)", type: "application/ld+json" },
  { name: "spirales_pappus.html", title: "Spirales coniques de Pappus", type: "text/html" },
];
export const MODEL_FILE = "modele.json";
// fichiers recalculés à partir du modèle (les autres décrivent l'exécution ou la synthèse)
const DERIVED = new Set(["modele.json", "matrice_affects.csv", "modele_onto_ethique.ttl", "modele_onto_ethique.jsonld", "spirales_pappus.html"]);

// règles du métamodèle, indicateurs recalculés, puis fichiers dérivés écrits dans dir ; renvoie les documents écrits
export async function writeModelFiles(dir: string, model: OntoModel, config: OntoEthiqueConfig): Promise<SynthesisDocument[]> {
  applyRules(model, config);
  model.metrics = computeMetrics(model, config);
  model.updatedAt = new Date().toISOString();
  await fs.mkdir(dir, { recursive: true });
  const content: Record<string, string> = {
    "modele.json": JSON.stringify(model, null, 2),
    "matrice_affects.csv": matrixCsv(model, config),
    "modele_onto_ethique.ttl": toTurtle(model, config, model.metrics),
    "modele_onto_ethique.jsonld": JSON.stringify(toJsonLd(model, config, model.metrics), null, 2),
    "spirales_pappus.html": spiralHtml(model.metrics, model.activity.title),
  };
  const docs: SynthesisDocument[] = [];
  for (const f of ONTO_FILES.filter(f => DERIVED.has(f.name))) {
    const filePath = path.join(dir, f.name);
    await fs.writeFile(filePath, content[f.name]!);
    docs.push({ filePath, title: f.title, type: f.type });
  }
  return docs;
}
