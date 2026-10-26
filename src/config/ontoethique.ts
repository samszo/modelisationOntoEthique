// Configuration du workflow ontoÉthique : modélisation onto-éthique des existences informationnelles d'une activité
// située (métamodèle à quatre dimensions, grille des affects des quatre pouvoirs, spirale conique de Pappus)
// Valeurs par défaut ; l'application cliente enregistre les modifications dans ontoethique.config.json
import path from "path";
import { mergeConfig, readConfigOverride } from "./store";
import { workflowConfig } from ".";

export const ONTOETHIQUE_CONFIG_FILE = path.resolve(process.cwd(), process.env.ONTOETHIQUE_CONFIG_FILE || "ontoethique.config.json");

export const defaultOntoEthiqueConfig = {
  workflowId: "onto-ethique",

  input: {
    // collection Zotero des traces de l'activité (comptes rendus, journaux, observations, annotations des participants)
    zoteroCollection: workflowConfig.input.zoteroCollection,
  },

  // activité située évaluée : elle cadre l'identification des existences et la lecture des pulsations
  activity: {
    title: "Activité située",
    description: "Décrire l'activité (tâche, participants humains, agents numériques, environnement documentaire, période) dont on veut évaluer la symbiose.",
  },

  // modèles Albert de l'application (rôles « analytique » et « rapide » de l'onglet Workflow)
  models: {
    analytics: workflowConfig.models.analytics,
    fast: workflowConfig.models.fast,
  },

  // lecture des traces de la collection
  analysis: {
    // documents en double fusionnés (annotations cumulées), comme dans les autres applications
    mergeDuplicates: true,
    // nombre maximum de documents évalués (un appel à l'évaluateur des affects par document)
    maxDocuments: 30,
    // caractères du texte d'un document transmis à l'évaluateur des affects
    maxCharsPerDocument: 12000,
    // caractères de chaque document transmis à l'ontologue (toutes les traces dans une seule demande)
    existencesCharsPerDocument: 1500,
    // nombre maximum d'existences identifiées
    maxExistences: 12,
    // annotations et notes d'un document transmises aux agents
    maxAnnotationsPerDocument: 80,
    // appels simultanés à l'évaluateur des affects
    concurrency: 3,
  },

  // genres d'existences informationnelles ; resonance : false = pouvoir de résonance inaccessible (agents numériques)
  kinds: [
    { id: "humain", label: "Actant humain", resonance: true },
    { id: "agent", label: "Agent numérique", resonance: false },
    { id: "environnement", label: "Environnement documentaire", resonance: false },
  ],

  // métamodèle onto-éthique : quatre dimensions existentielles et leurs correspondances
  dimensions: [
    { id: "materielle", label: "Matérielle (Physique)", spinoza: "Parties extensives", metric: "Euclidienne", pretopology: "Extérieur", analogy: "Branches (connaissance des chocs)",
      instruction: "Supports, code, médias, interfaces, traces physiques : le plan de l'expression." },
    { id: "conceptuelle", label: "Conceptuelle (Essence)", spinoza: "Essence", metric: "Topologique", pretopology: "Intérieur", analogy: "Racines (connaissance des essences)",
      instruction: "Concepts, intentions, contenus : le plan du contenu." },
    { id: "sociale", label: "Sociale (Actant)", spinoza: "Rapport (point de vue)", metric: "Topographique", pretopology: "Bord", analogy: "Graines (dynamiques génératives)",
      instruction: "Rôles, relations, points de vue, communautés : ce qui fait agir et ce qui est agi." },
    { id: "temporelle", label: "Temporelle (Rapport)", spinoza: "Rapport (actualisation)", metric: "Temporelle", pretopology: "Flux", analogy: "Sève (actualisation des potentiels)",
      instruction: "Versions, événements, rythmes, durées : l'actualisation des rapports." },
  ],

  // grille des affects : quatre pouvoirs, séquence de sémiose (maillons du triplet) et états de la matrice
  powers: [
    { id: "discerner", label: "Discerner", semiosis: "Anasémiose", chain: ["physique", "crible", "actant", "concept"],
      negative: { name: "Cécité cognitive", description: "surcharge informationnelle, bruit, perte de repères, désinformation" },
      neutral: { name: "Stase", description: "point de vue neutre, pas de nouvelle perception" },
      positive: { name: "Clarté sémiotique", description: "filtrage réussi par un crible, accès à la structure" } },
    { id: "raisonner", label: "Raisonner", semiosis: "Formel", chain: ["sujet", "prédicat", "objet"],
      negative: { name: "Aliénation logique", description: "acceptation passive de biais, incohérence conceptuelle, erreurs syntaxiques" },
      neutral: { name: "Routinisation", description: "pures opérations mécaniques sans gain logique" },
      positive: { name: "Puissance critique", description: "rigueur de l'argumentation, structuration de l'esprit critique" } },
    { id: "resonner", label: "Résonner", semiosis: "Intuitif / Essences", chain: ["concept source", "actant", "concept destination"],
      negative: { name: "Impasse intuitive", description: "déconnexion sémantique, vide émotionnel, répétition de formules mortes" },
      neutral: { name: "Barrière numérique", description: "limite absolue des agents numériques, incapables de résonance" },
      positive: { name: "Scientia Intuitiva", description: "saut conceptuel, résonance harmonique, saisie immédiate des essences" } },
    { id: "agir", label: "Agir", semiosis: "Catasémiose", chain: ["concept", "actant", "crible", "physique"],
      negative: { name: "Misère symbolique", description: "passivité, réduction à un état d'agent purement réactif ou grégaire" },
      neutral: { name: "Geste blanc", description: "action automatique sans trace ni inscription mémorielle" },
      positive: { name: "Création autopoïétique", description: "écriture, enregistrement d'une trace modifiant l'écosystème" } },
  ],

  // valeurs tardiennes qualifiant ce qui est discerné (de -100 à +100) et force dont elles relèvent
  values: [
    { id: "utilite", label: "Valeur-utilité", force: "Désir", question: "est-ce utile ?" },
    { id: "verite", label: "Valeur-vérité", force: "Croyance", question: "est-ce crédible ?" },
    { id: "beaute", label: "Valeur-beauté", force: "Désir", question: "est-ce harmonieux ?" },
  ],

  rules: {
    // score imposé à Résonner pour les genres sans résonance (barrière numérique) ; null : pas de contrainte
    // (l'article note 0 dans la grille ; -100 dans le scénario B « limite absolue »)
    noResonanceScore: 0 as number | null,
    // souveraineté de l'expertise humaine : une évaluation validée par un humain n'est plus modifiée par les agents
    humanSovereignty: true,
  },

  // auto-évaluations des participants : marqueurs Zotero d'une annotation ou d'une note (ex. « discerner+40 », « agir:-30 »)
  selfEvaluation: {
    enabled: true,
    // expression régulière : 1er groupe = pouvoir (identifiant ou libellé), 2e groupe = score
    tagPattern: "^\\s*(discerner|raisonner|r[ée]sonner|agir)\\s*[:=]?\\s*([+-]?\\d{1,3})\\s*$",
  },

  // indicateurs de symbiose
  symbiosis: {
    // moyenne en dessous de laquelle un pouvoir est jugé en diminution (alertes)
    lowThreshold: -20,
    // moyenne au-dessus de laquelle un pouvoir est jugé en augmentation (alertes)
    highThreshold: 40,
    // valeur-vérité moyenne en dessous de laquelle la croyance bascule en indignation
    indignationThreshold: -40,
  },

  // spirale conique de Pappus : empreinte diagrammatique de la trajectoire de chaque existence
  spiral: {
    // points de Discerner + Raisonner pour un tour complet (déplacement topographique)
    pointsPerTurn: 200,
    // points dessinés par pulsation
    stepsPerPulsation: 24,
    // rapport rayon / altitude au-delà duquel le cône est « évasé », en deçà duquel il est « élancé » (flèche)
    flaredRatio: 1.5,
    slenderRatio: 0.5,
    // part de l'altitude gagnée sur la seconde moitié de la trajectoire sans élargissement notable : forme « tube »
    tubeGrowth: 0.1,
  },

  // synthèse discursive de l'ADA onto-éthique
  discourse: {
    // pulsations transmises à l'agent (les plus intenses)
    maxPulsations: 60,
  },

  // export Linked Open Data (Turtle et JSON-LD) des existences et des pulsations
  ontology: {
    // espace de noms du vocabulaire onto-éthique (à remplacer par l'URI publiée du vocabulaire)
    baseUri: "https://github.com/samszo/modelisationOntoEthique/ontologie#",
    // espace de noms des individus d'une exécution (suivi de l'identifiant d'exécution)
    dataUri: "https://github.com/samszo/modelisationOntoEthique/donnees/",
  },

  // dossier des fichiers produits (dans le répertoire de données)
  outputDir: "resultats/ontoethique",
};

export type OntoEthiqueConfig = typeof defaultOntoEthiqueConfig;

// sous-dossier de outputDir où chaque exécution (ou évaluation saisie à la main) est archivée
export const RUNS_DIR = "analyses";

// configuration effective : défauts + surcharges de ontoethique.config.json
export const ontoEthiqueConfig: OntoEthiqueConfig = mergeConfig(defaultOntoEthiqueConfig, readConfigOverride(ONTOETHIQUE_CONFIG_FILE));
