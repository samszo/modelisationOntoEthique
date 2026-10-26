// Description des workflows pour leur diagramme (onglet Workflow de chaque application) : étapes dans l'ordre d'exécution
// (plusieurs étapes dans un même groupe = exécution en parallèle), agents impliqués, et agents appelés hors du workflow
// (actions de l'interface, autres traitements). À tenir à jour avec les .then() / .parallel() des fichiers *Workflow.ts.
import { EXISTENCES_INSTRUCTIONS, EXISTENCES_PROMPT } from "../agents/existencesAgent";
import { AFFECTS_INSTRUCTIONS, AFFECTS_PROMPT } from "../agents/affectsAgent";
import { ADA_INSTRUCTIONS, ADA_PROMPT } from "../agents/adaAgent";

export type ModelRole = "analytique" | "rapide" | "vision";

export interface AgentInfo {
  id: string;
  name: string;
  role: string;
  model: ModelRole;
  tools?: string[];
  instructions: string;
  // demande modifiable (gabarit à variables) ; sans elle, la demande est construite par le programme
  prompt?: string;
  promptHelp?: string;
  // où sont les autres textes envoyés à l'agent
  note?: string;
  // étiquette des appels de l'agent dans les tableaux de consommation (ex. « (adaAgent) »)
  usageTag: string;
  // libellés des mêmes appels dans les rapports antérieurs aux agents
  legacyUsage?: string[];
  // consommation par défaut, tant qu'aucune exécution n'est connue : tokens par appel, appels par traitement
  estimate: { inputTokens: number; outputTokens: number; callsPerRun: number };
}

export interface StepInfo { id: string; label: string; description: string; agents?: string[]; model?: ModelRole }
export interface WorkflowDiagram { workflowId: string; title: string; stages: StepInfo[][]; outside: StepInfo[] }

export const AGENTS: Record<string, AgentInfo> = {
  "existences-agent": { id: "existences-agent", usageTag: "(existencesAgent)", estimate: { inputTokens: 9000, outputTokens: 1800, callsPerRun: 1 },
    name: "Ontologue des existences", role: "identifie les existences informationnelles de l'activité et leurs quatre dimensions", model: "analytique",
    instructions: EXISTENCES_INSTRUCTIONS, prompt: EXISTENCES_PROMPT,
    promptHelp: "Variables : {{activite}} (titre et description), {{genres}}, {{dimensions}} (métamodèle), {{max}} (nombre d'existences), {{auto_evaluations}} (participants auto-évalués), {{documents}} (traces numérotées [D…], début du texte, annotations et notes).",
    note: "La réponse suit un schéma (identifiant, nom, genre, description, éléments de chaque dimension, cribles, numéros des documents)." },
  "affects-agent": { id: "affects-agent", usageTag: "(affectsAgent)", estimate: { inputTokens: 5500, outputTokens: 1500, callsPerRun: 20 },
    name: "Évaluateur des affects", role: "relève les pulsations d'une trace et les évalue dans la grille des affects", model: "analytique",
    instructions: AFFECTS_INSTRUCTIONS, prompt: AFFECTS_PROMPT,
    promptHelp: "Variables : {{activite}}, {{existences}} (identifiants et genres), {{grille}} (pouvoirs, séquences de sémiose, états), {{valeurs}} (valeurs tardiennes), {{document}} (la trace évaluée).",
    note: "Un appel par document. La réponse suit un schéma (moment, existence, pour chaque pouvoir : score, séquence, justification, citation ; valeurs). La barrière numérique est appliquée ensuite par le programme." },
  "ada-agent": { id: "ada-agent", usageTag: "(adaAgent)", estimate: { inputTokens: 6000, outputTokens: 2200, callsPerRun: 1 },
    name: "ADA onto-éthique", role: "interprète la matrice : symbiose, risques, ajustement des cribles, questions pour la discussion", model: "analytique",
    instructions: ADA_INSTRUCTIONS, prompt: ADA_PROMPT,
    promptHelp: "Variables : {{activite}}, {{existences}} (avec leurs dimensions), {{indicateurs}} (symbiose, pouvoirs, valeurs, complexité, spirales), {{alertes}}, {{pulsations}} (les plus intenses, avec leur origine)." },
};

export const DIAGRAMS: Record<"ontoethique", WorkflowDiagram> = {
  ontoethique: {
    workflowId: "onto-ethique",
    title: "ontoÉthique",
    stages: [
      [{ id: "fetch-literature", label: "Traces de l'activité", description: "Collection Zotero : documents, annotations, notes et marqueurs, enregistrés dans Omeka S" }],
      [{ id: "existences", label: "Existences informationnelles", description: "Humains, agents numériques, environnement ; dimensions matérielle, conceptuelle, sociale, temporelle ; participants auto-évalués", agents: ["existences-agent"] }],
      [{ id: "pulsations", label: "Grille des affects", description: "Pulsations de chaque trace : quatre pouvoirs (-100 à +100), séquences de sémiose, valeurs tardiennes ; barrière numérique", agents: ["affects-agent"] }],
      [{ id: "metrics", label: "Mesure des fluctuations", description: "Pouvoirs par existence et par genre, complexité ontologique, symbiose, alertes, spirales de Pappus, triplets RDF (sans modèle)" }],
      [{ id: "discourse", label: "Synthèse discursive", description: "Diagnostic de symbiose, risques, ajustement des cribles, questions pour la discussion", agents: ["ada-agent"] }],
    ],
    outside: [
      { id: "synthesis", label: "Nouvelle synthèse", description: "Onglet Synthèse : synthèse rédigée à partir de la matrice corrigée et validée par les humains", agents: ["ada-agent"] },
    ],
  },
};
