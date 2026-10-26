// Configuration du socle commun aux applications (modèles Albert, Zotero, extraction, coût, termes Omeka S)
// Valeurs par défaut ; surcharges dans workflow.config.json. Chaque application a en plus sa propre configuration (src/config/<app>.ts).
import { mergeConfig, readConfigOverride } from "./store";

export const defaultWorkflowConfig = {
  // identifiant par défaut d'une exécution (chaque application donne le sien à saveWorkflowConfig)
  workflowId: "socle",

  input: {
    // collection Zotero proposée par défaut aux applications
    zoteroCollection: "",
  },

  // modèles de langage (API Albert)
  models: {
    provider: "https://albert.api.etalab.gouv.fr/v1",
    analytics: "openai/gpt-oss-120b",
    fast: "mistralai/Ministral-3-8B-Instruct-2512",
  },

  // Zotero
  zotero: {
    // marqueurs ajoutés automatiquement (import, éditeur) en plus des marqueurs manuels
    automaticTags: true,
  },

  // découpage des textes extraits
  extraction: {
    chunkSize: 12000,
    chunkOverlap: 1000,
    maxAnnotationChars: 6000,
  },

  // catégorie des concepts issus des marqueurs Zotero (enregistrement des annotations dans Omeka S)
  tagCategory: "marqueur",

  // positionnement selon la couleur de l'annotation (palette Zotero par défaut), repris par l'enregistrement des
  // annotations dans Omeka S (curation:category) ; une application peut passer sa propre grille à positionForColor
  annotationPositions: [
    { color: "#ffd400", name: "jaune", position: "Idée clé", instruction: "Passage central." },
    { color: "#5fb236", name: "vert", position: "Accord", instruction: "Idée partagée." },
    { color: "#ff6666", name: "rouge", position: "Désaccord", instruction: "Affirmation contestée." },
    { color: "#2ea8e5", name: "bleu", position: "Définition", instruction: "Définition d'un concept." },
    { color: "#a28ae5", name: "violet", position: "Méthode", instruction: "Méthode, protocole." },
    { color: "#e56eee", name: "magenta", position: "Question", instruction: "Question ouverte." },
    { color: "#f19837", name: "orange", position: "Exemple", instruction: "Exemple, cas, terrain." },
    { color: "#aaaaaa", name: "gris", position: "Contexte", instruction: "Élément de contexte." },
  ],
  // distance RGB maximale pour rattacher une couleur à la palette (les PDF annotés hors Zotero varient légèrement)
  annotationColorTolerance: 80,

  // codes de grille reconnus dans les marqueurs Zotero des annotations (séparés des marqueurs ordinaires, curation:type)
  kappa: {
    codes: {} as Record<string, string>,
  },

  // estimation du coût d'un traitement (énergie, carbone, argent) à partir des tokens consommés
  // valeurs par défaut indicatives, à ajuster : voir la section « Coût du traitement » du rapport
  costs: {
    currency: "€",
    // prix de l'électricité (€/kWh)
    electricityPrice: 0.2,
    // intensité carbone de l'électricité (gCO2e/kWh) : mix français en analyse de cycle de vie, ordre de grandeur
    carbonIntensity: 32,
    // matériel d'inférence : rendement GPU (opérations par joule, H100 ≈ 1,4e12 en bf16),
    // taux d'utilisation effectif en inférence, PUE du centre de données
    hardware: { flopsPerJoule: 1.4e12, utilization: 0.2, pue: 1.2 },
    // par modèle : paramètres actifs (milliards), prix de référence du marché (€ par million de tokens)
    models: [
      { model: "openai/gpt-oss-120b", activeParamsB: 5.1, inputPricePerM: 0.15, outputPricePerM: 0.6 },
      { model: "mistralai/Ministral-3-8B-Instruct-2512", activeParamsB: 8, inputPricePerM: 0.1, outputPricePerM: 0.1 },
      { model: "mistralai/Mistral-Small-3.2-24B-Instruct-2506", activeParamsB: 24, inputPricePerM: 0.1, outputPricePerM: 0.3 },
      { model: "BAAI/bge-m3", activeParamsB: 0.57, inputPricePerM: 0.01, outputPricePerM: 0 },
    ],
    // modèle absent de la liste
    fallback: { activeParamsB: 10, inputPricePerM: 0.5, outputPricePerM: 1.5 },
  },

  // nettoyage des identifiants de concepts (cleanGraph)
  cleaning: {
    batchSize: 80,
  },

  // propriétés Omeka S utilisées
  omeka: {
    vocabs: ["dcterms", "skos", "oa", "bibo", "curation"],
    conceptClass: "skos:Concept",
    // classe de l'item décrivant la configuration d'une exécution du workflow
    configClass: "dcterms:MethodOfInstruction",
    // date de la dernière extraction sémantique d'une pièce jointe (vide = à extraire)
    accessTerm: "curation:access",
    // lien pièce jointe → concepts
    subjectTerm: "dcterms:subject",
    // lien concept → concept
    relationTerm: "dcterms:relation",
    // code de la grille d'annotation (sur l'oa:Annotation)
    codeTerm: "curation:type",
    // auteur de l'annotation (sur l'oa:Annotation)
    authorTerm: "dcterms:creator",
  },
};

export type WorkflowConfig = typeof defaultWorkflowConfig;

// configuration effective : défauts + surcharges de workflow.config.json
export const workflowConfig: WorkflowConfig = mergeConfig(defaultWorkflowConfig, readConfigOverride());
