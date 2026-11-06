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
    { id: "raisonner", label: "Raisonner", semiosis: "Formel", chain: ["concept", "actant", "concept"],
      negative: { name: "Aliénation logique", description: "acceptation passive de biais, incohérence conceptuelle, erreurs syntaxiques" },
      neutral: { name: "Routinisation", description: "pures opérations mécaniques sans gain logique" },
      positive: { name: "Puissance critique", description: "rigueur de l'argumentation, structuration de l'esprit critique" } },
    { id: "resonner", label: "Résonner", semiosis: "Intuitif / Essences", chain: ["concept source", "concept destination"],
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

  // formulaires de saisie générés depuis les resource templates de l'instance Omeka S
  omekaForms: {
    // ordre du processus de modélisation ; templateId : o:id du resource template dans l'instance
    templates: [
      { key: "physique", label: "Physiques", templateId: 3 },
      { key: "crible", label: "Cribles", templateId: 5 },
      { key: "personne", label: "Personnes", templateId: 8 },
      { key: "agent", label: "Agents", templateId: 6 },
      { key: "actant", label: "Actants", templateId: 4 },
      { key: "concept", label: "Concepts", templateId: 2 },
      { key: "pouvoir", label: "Pouvoirs existentiels", templateId: 7 },
      { key: "pulsation", label: "Pulsations existentielles", templateId: 12 },
      { key: "raison", label: "Raison trajective", templateId: 10 },
    ],
    // template des pouvoirs existentiels : son intensité et son type sont contrôlés
    powerTemplateId: 7,
    // intensité du pouvoir : -100 = diminution extrême, 0 = pas de changement, 100 = augmentation extrême
    intensity: { term: "jdc:intensite", min: -100, max: 100, step: 1 },
    // propriété qui porte le type du pouvoir
    powerTypeTerm: "dcterms:type",
    // types de pouvoir ; sequence : maillons attendus, dans l'ordre (propriété de chaque maillon)
    powerTypes: [
      { id: "discerner", label: "Pouvoir de discerner", sequence: [
        { name: "physique", term: "jdc:hasPhysique" }, { name: "crible", term: "jdc:hasCrible" }, { name: "actant", term: "jdc:hasActant" }, { name: "concept", term: "jdc:hasConcept" }] },
      { id: "raisonner", label: "Pouvoir de raisonner", sequence: [
        { name: "concept source", term: "jdc:hasConcept" }, { name: "actant", term: "jdc:hasActant" }, { name: "concept destination", term: "jdc:hasConcept" }] },
      { id: "resonner", label: "Pouvoir de résonner", sequence: [
        { name: "concept source", term: "jdc:hasConcept" }, { name: "concept destination", term: "jdc:hasConcept" }] },
      { id: "agir", label: "Pouvoir d'agir", sequence: [
        { name: "concept", term: "jdc:hasConcept" }, { name: "actant", term: "jdc:hasActant" }, { name: "crible", term: "jdc:hasCrible" }, { name: "physique", term: "jdc:hasPhysique" }] },
    ],
    // résultats proposés par la recherche d'un item lié
    searchLimit: 20,
  },

  // IHM EcoNetwork : modélisation pas à pas d'un écosystème de connaissances (page /econetwork)
  econetwork: {
    // resource template des écosystèmes de connaissances
    ecoTemplateId: 14,
    // propriété qui rattache un élément à son écosystème (portée par l'élément, valeur = item de l'écosystème)
    ecoProperty: "jdc:hasEcoCon",
    // types d'éléments proposés par « lier » depuis le nœud de l'écosystème (resource templates)
    elementTemplateIds: [3, 5, 8, 6, 4, 2, 7, 12, 10, 9],
    // nombre maximum d'items liés lus autour des éléments (taille du réseau)
    maxLinked: 300,
    // interface web d'Omeka S relayée par le serveur sous le chemin de l'instance (ex. /omk_ontoethique/) : l'iframe
    // « détails » est alors de même origine et la session Omeka S y fonctionne ; false = iframe vers l'instance elle-même
    omekaProxy: true,
    // taille maximale (Mo) d'un fichier déposé comme média à la création d'un nœud
    maxMediaMB: 50,
  },

  // IHM EcoSpace : écosystème de connaissances modélisé dans un espace 3D sur une grille hexagonale (page /ecospace)
  ecospace: {
    // dossier des espaces (un fichier <écosystème>.json : grille et placements), dans le répertoire de données
    dir: "resultats/ecospace",
    // grille créée avec un nouvel espace (reprise ensuite telle qu'enregistrée dans le fichier de l'espace)
    grid: {
      // nombre d'anneaux autour de l'hexagone central (3·r·(r+1)+1 hexagones)
      radius: 6,
      // rayon d'un hexagone (centre → sommet), en mètres ; 1 unité de la scène = 1 m
      hexSize: 10,
      // hexagones « pointe en haut » (pointy) ou « côté plat en haut » (flat), au sens de redblobgames.com
      orientation: "pointy",
      // position géographique de l'hexagone (0, 0, 0) : Université Paris 8, Saint-Denis
      origin: { lon: 2.3637, lat: 48.9447, alt: 0 },
    },
    // formes des éléments ontologiques, par resource template ; dimensions en fraction de hexSize (1 = rayon de l'hexagone)
    // layer : couche occupée sur l'hexagone (un élément par couche et par hexagone ; défaut : la clé de la forme)
    // actant : fullerène C60 (icosaèdre tronqué) centré sur l'hexagone + sphère dont le pôle nord touche ce centre
    shapes: [
      // subRings : anneaux de la sous-grille de l'hexagone (personnes et agents ; plus d'anneaux si nécessaire), subMargin :
      // réduction de la sous-grille pour qu'elle reste à l'intérieur de l'hexagone
      { key: "actant", label: "Actant", templateId: 4, layer: "dessous", fullereneRadius: 1, sphereRadius: 1, color: "#d0602e", subRings: 2, subMargin: 0.95 },
      // personne et agent : ajoutés seulement depuis un actant (anchor), qui les désigne par anchorTerm ; fullerène centré (moitié
      // au-dessus, moitié en dessous de la grille) sur
      // un hexagone de la sous-grille de l'actant (rayon memberRatio × taille du sous-hexagone), emplacement attribué au
      // premier libre depuis le centre (le sous-hexagone central reste à l'actant) et conservé ; comme l'actant, une sphère
      // sous la grille (rayon sphereRatio × rayon du fullerène) dont le pôle nord touche le centroïde du fullerène
      { key: "personne", label: "Personne", templateId: 8, anchor: "actant", anchorTerm: "jdc:hasPerson", color: "#2f6fb0", memberRatio: 0.8, sphereRatio: 1 },
      { key: "agent", label: "Agent", templateId: 6, anchor: "actant", anchorTerm: "jdc:hasAgent", color: "#c08a1e", memberRatio: 0.8, sphereRatio: 1 },
      // physique : boîte au-dessus de la grille, à base carrée inscrite dans l'hexagone (baseRatio × le plus grand carré
      // inscrit), allant de la date de modification (o:modified) à la date de création (createdTerm, sinon o:created) sur
      // l'échelle temporelle ; ses enfants (items qui le désignent par parentTerm) sont des boîtes intérieures empilées
      // de haut en bas par ordre alphabétique du titre, de hauteur proportionnelle à leur importance (importanceTerm,
      // 1 par défaut) ; childPadding : marge intérieure d'un parent (fraction de ses dimensions) ; maxDepth : profondeur lue
      { key: "physique", label: "Physique", templateId: 3, layer: "dessus", color: "#2e7d5b", baseRatio: 0.95,
        createdTerm: "dcterms:created", importanceTerm: "jdc:importance", parentTerm: "dcterms:isPartOf", childPadding: 0.08, maxDepth: 6 },
      // concept (« bulle conceptuelle ») : capsule d'axe horizontal est-ouest (cylindre fermé par deux demi-sphères) sous
      // la grille (free : pas de couche d'hexagone) ; ni taille ni position saisies : la hiérarchie est lue dans Omeka S
      // (narrowerTerm sur le parent, broaderTerm sur l'enfant ; relations annotées par l'écosystème ou sans annotation) et
      // la géométrie en est calculée. Sans enfant : rayon leafRadius, longueur = 2 × rayon + caractères du titre ×
      // charWidth (titre tronqué à maxLabel caractères, haut de labelHeight) ; parent : enfants sur une ligne le long de
      // son axe, sous une bande pour son titre, padding de marge et d'écart. Frères répartis de façon équilibrée (ordre
      // alphabétique, écarts égaux, centrés) ; racines en grille presque carrée centrée, écart spacing, sommet à topDepth
      // sous la grille (sous la sphère des actants). Tailles en fraction de grid.hexSize. relatedTerm : liés (détails)
      { key: "concept", label: "Concept", templateId: 2, free: true, color: "#8a4fb8", charWidth: 0.12, labelHeight: 0.25, leafRadius: 0.2,
        padding: 0.08, spacing: 0.5, topDepth: 2.2, maxLabel: 40, narrowerTerm: "skos:narrower", broaderTerm: "skos:broader", relatedTerm: "skos:related" },
    ] as Record<string, any>[],
    // échelle temporelle verticale des physiques : surface de la grille = maintenant, hauteur `height` (m) = plus ancienne
    // date de création ; bornes du curseur de la page ; mode linear ou log (intervalles récents dilatés)
    timeScale: { height: 60, minHeight: 5, maxHeight: 1000, mode: "linear" },
    // nombre maximal de copies demandées en une fois par « dupliquer »
    maxDuplicates: 100,
    // copie du fichier de l'espace (positions) dans Omeka S, comme média de l'item écosystème : envoyée delay ms après le
    // dernier enregistrement (les modifications rapprochées n'en font qu'un), seulement si le contenu a changé (sha256) ;
    // identifiée par dcterms:identifier = identifierPrefix + écosystème ; sert à restaurer un espace absent en local
    omekaMedia: { enabled: true, delay: 3000, identifierPrefix: "ecospace-", title: "EcoSpace : positions des éléments" },
  },

  // dossier des fichiers produits (dans le répertoire de données)
  outputDir: "resultats/ontoethique",
};

export type OntoEthiqueConfig = typeof defaultOntoEthiqueConfig;

// sous-dossier de outputDir où chaque exécution (ou évaluation saisie à la main) est archivée
export const RUNS_DIR = "analyses";

// configuration effective : défauts + surcharges de ontoethique.config.json
export const ontoEthiqueConfig: OntoEthiqueConfig = mergeConfig(defaultOntoEthiqueConfig, readConfigOverride(ONTOETHIQUE_CONFIG_FILE));
