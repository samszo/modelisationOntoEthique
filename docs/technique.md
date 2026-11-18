# Documentation technique

Écosystème d'agents IA pour la **modélisation onto-éthique des existences informationnelles** dans un environnement humain-numérique (Laboratoire Paragraphe, Université Paris 8). Le projet est écrit en **TypeScript**, exécuté par **tsx** sous **Node.js 22+**, et orchestré par des workflows **Mastra**. Les modèles de langage sont ceux de l'**API Albert** (compatible OpenAI), les traces viennent de **Zotero** et les résultats sont archivés dans **Omeka S**.

Le socle (connexions, comptage des tokens et coût, onglet Workflow, item de configuration Omeka S, archives, serveur) est repris de l'écosystème `ecosysteme-agents-recherche` ; chaque application y ajoute son workflow, son lanceur, sa page et son serveur :

| Application | Workflow | Lanceur | Page | Serveur | Section |
|---|---|---|---|---|---|
| ontoÉthique | `ontoEthiqueWorkflow` (`src/workflow/ontoethiqueWorkflow.ts`) | `src/runners/ontoethique.ts` | `ontoethique.html` | `ONTOETHIQUE_PORT` 7280 | 12 |

Le cadre théorique et le protocole de mesure sont ceux de l'article « Le tournant ontologique dans les humanités numériques » (S. Szoniecky) : métamodèle à quatre dimensions existentielles, quatre pouvoirs de la pulsation existentielle, grille des affects (-100 à +100), triplets de sémiose, valeurs tardiennes, spirale conique de Pappus.

## 1. Architecture

```mermaid
flowchart LR
    subgraph Client
        NAV[Navigateur]
    end
    subgraph S1["Serveur ontoethique : src/ui/server.ts (7280)"]
        UI1[API HTTP + ontoethique.html]
        CFG1[(.env + .env.ontoethique<br/>ontoethique.config.json)]
    end
    subgraph T1["Processus enfant : runners/ontoethique.ts"]
        WF1[ontoEthiqueWorkflow]
    end
    AG[Agents]
    LIB[Bibliothèque onto-éthique<br/>règles, mesures, LOD]
    NAV -- HTTP / SSE --> UI1
    UI1 -- lit / écrit --> CFG1
    UI1 -- spawn tsx --> WF1
    UI1 -- corrections, synthèse --> LIB
    WF1 --> AG
    WF1 --> LIB
    AG -- chat completions --> ALB[(API Albert)]
    WF1 -- API web v3 --> ZOT[(Zotero)]
    WF1 & UI1 -- API REST --> OMK[(Omeka S)]
    WF1 & UI1 -- fichiers --> FS[(resultats/ontoethique)]
```

- **Interface** (`src/ui/server.ts`) : serveur `node:http` sans dépendance, lancé une fois par application, qui gère les connexions et la configuration, lance le workflow dans un **processus enfant** (configuration et connexions relues à chaque exécution), diffuse le journal en **Server-Sent Events** et sert les résultats. Les routes propres à ontoÉthique sont dans `src/ui/ontoethiqueRoutes.ts`.
- **Lanceur** (`src/runners/ontoethique.ts`) : enregistre la configuration dans Omeka S, exécute le workflow, écrit les fichiers de l'évaluation, importe les documents dans l'item de configuration.
- **Bibliothèque** (`src/lib/ontoethique/`) : fonctions pures partagées par le workflow et les routes (règles du métamodèle, mesures, export Linked Open Data) : une correction humaine recalcule exactement ce que calcule le workflow.
- **Paramètres de connexion** : page commune `src/ui/public/settings.html`, servie sur `/parametres` ; elle enregistre les connexions dans `.env.ontoethique` (qui surcharge `.env`).
- **Répertoire de données** : le répertoire courant (racine du projet en local, volume `/data` dans Docker, le code étant dans `/app`).

Règles de passage des données dans Mastra : après un `.then(...)`, l'étape reçoit la sortie de l'étape précédente ; après un `.parallel([...])`, `{ "<id étape>": sortie }` ; `getStepResult("<id>")` donne la sortie d'une étape antérieure. Les outils sont appelés **directement** (`outil.execute({ data })`) : les données brutes ne passent jamais par un modèle.

## 2. Organisation du code

```
src/
├── agents/                   ask.ts (askAgent), overrides.ts (agents.config.json) ; existencesAgent, affectsAgent, adaAgent
├── config/
│   ├── index.ts              socle commun (defaultWorkflowConfig : modèles Albert, Zotero, extraction, coût, termes Omeka S)
│   ├── ontoethique.ts        configuration d'ontoÉthique (defaultOntoEthiqueConfig, ontoEthiqueConfig, RUNS_DIR)
│   ├── models.ts             modèles Albert
│   └── store.ts              fusion avec workflow.config.json / ontoethique.config.json (REPLACED_PATHS)
├── lib/
│   ├── ontoethique/          model (types, règles, auto-évaluations, CSV), metrics (pouvoirs, symbiose, alertes, spirales),
│   │                         linkedData (Turtle, JSON-LD), spiralHtml, prompts (mise en forme, schémas zod),
│   │                         synthesis (ADA), outputs (liste blanche, fichiers dérivés), example (scénarios A et B de l'article)
│   ├── analysis/             annotationPositions (grille de couleurs), codebook (codes des marqueurs), cleanGraph (identifiants)
│   ├── extraction/           pdfExtract, attachmentExtract, zip, chunkText
│   ├── metrics/              usage (tokens), impact (énergie, carbone, argent), usageHistory (onglet Workflow)
│   ├── ecospace/             hex (grille hexagonale : coordonnées cube, scène, géographie)
│   ├── omeka/                omk (client), templateForm (formulaires des resource templates), network (réseau EcoNetwork), proxy (mandataire de l'interface web), oaAnnotations, conceptIndex, zoteroCollections
│   ├── albert/               albert (client de l'API Albert)
│   └── zotero/               zotero (client), zoteroToOmeka, duplicates
├── tools/                    fetchZoteroData, buildResourceTemplateForm (outils Mastra)
├── workflow/
│   ├── ontoethiqueWorkflow.ts
│   ├── steps/common/         fetchLiteratureStep
│   ├── steps/ontoethique/    existencesStep, pulsationsStep, metricsStep, discourseStep
│   ├── reports/              ontoethiqueReport, usageReport (consommation et coût, partagé)
│   ├── runs/                 saveWorkflowConfig (item Omeka), importSynthesis (médias)
│   └── diagrams.ts           AGENTS + DIAGRAMS (onglet Workflow)
├── runners/ontoethique.ts
└── ui/
    ├── server.ts             serveur d'une application (npm run ui:ontoethique)
    ├── ontoethiqueRoutes.ts  routes d'ontoÉthique
    ├── econetworkRoutes.ts   routes de l'IHM EcoNetwork (/econetwork)
    ├── ecospaceRoutes.ts     routes de l'IHM EcoSpace (/ecospace)
    └── public/               ontoethique.html, econetwork.html, ecospace.html, settings.html, workflowDiagram.js, templateForm.js
```

Hors de `src/` : `docs/` (documentation), `scripts/build-docs.ts`, `docker/entrypoint.sh`, `.vscode/launch.json`, `.claude/launch.json` (configurations `ui-ontoethique` et `ui-ontoethique-test`).

### Agents (`src/agents/`)

| Agent | Modèle | Rôle |
|---|---|---|
| `existencesAgent` (Ontologue des existences) | analytique | identifie les existences informationnelles de l'activité (humains, agents numériques, environnement) et décrit leurs quatre dimensions, leurs cribles et les traces où elles apparaissent |
| `affectsAgent` (Évaluateur des affects) | analytique | un appel par trace : pulsations attestées, score des quatre pouvoirs, séquence de sémiose, justification, citation, valeurs tardiennes |
| `adaAgent` (ADA onto-éthique) | analytique | synthèse discursive : diagnostic de symbiose, comparaison des existences, risques, ajustement des cribles, questions pour une éthique de la discussion ; cite les pulsations `[p3]` |
| `ecoModelAgent` (Modélisateur d'écosystème) | analytique | EcoSpace, nouvel écosystème depuis un texte : transforme la description en modélisation onto-éthique (écosystème, actants avec personnes et agents, physiques et contenants, concepts et hiérarchie, cribles, pouvoirs et leurs maillons, pulsations, flux, lieux et dates), sortie structurée `EcoModelSchema` |
| `ecoSuggestAgent` (Assistant de description) | rapide | EcoSpace : propose la suite d'une rubrique de la saisie guidée (une à trois phrases, texte brut) |

Chaque agent exporte ses instructions (`XXX_INSTRUCTIONS`) et sa demande à variables (`XXX_PROMPT`), passées par `overridable` / `overridableModel` et `agentText` : elles sont modifiables dans l'onglet **Workflow** (`agents.config.json`). Les appels passent par `askAgent` (sortie structurée zod, comptage des tokens, étiquette `(nomAgent)` dans la source).

### Comptage des tokens et coût

Chaque appel à un modèle enregistre sa consommation (`recordUsage`, fait par `askAgent`). `usageSummary()` alimente le rapport, l'item de configuration (`curation:data`) et l'historique `usage.history.jsonl` (estimation du coût dans l'onglet Workflow). `estimateImpact` convertit les tokens en énergie, carbone et argent avec les hypothèses de `costs` (`workflow.config.json`). La nouvelle synthèse demandée depuis la page est comptée de la même façon (tâche `synthese`).

## 3. Modèle onto-éthique

Le modèle d'une évaluation (`OntoModel`, `src/lib/ontoethique/model.ts`, fichier `modele.json`) :

```mermaid
erDiagram
    ACTIVITE {
        string runId "exécution ou évaluation manuelle"
        string mode "workflow ou manuel"
        string title
        string description
    }
    EXISTENCE {
        string id
        string name
        string kind "humain, agent, environnement"
        list materielle "parties extensives"
        list conceptuelle "essence"
        list sociale "actant"
        list temporelle "rapport"
        list cribles
    }
    PULSATION {
        string id "p1, p2…"
        int order "rang dans la trajectoire"
        string moment
        string document "trace Zotero"
        int utilite "valeurs tardiennes"
        int verite
        int beaute
    }
    EVALUATION {
        string pouvoir "discerner, raisonner, resonner, agir"
        int score "-100 à +100, null = non observé"
        list chain "séquence de sémiose"
        string justification
        string citation
        string origin "agent, humain, autoevaluation, regle"
        bool validated
    }
    REVISION {
        date at
        string author
        string action "ajout, modification, suppression"
        string motivation "oa:editing, oa:assessing"
    }
    ACTIVITE ||--o{ EXISTENCE : ""
    EXISTENCE ||--o{ PULSATION : "trajectoire"
    PULSATION ||--o{ EVALUATION : "quatre pouvoirs"
    ACTIVITE ||--o{ REVISION : "traçabilité"
```

**Règles du métamodèle** (`applyRules`, appliquées après toute évaluation : agents, auto-évaluations, saisie humaine) :

- scores bornés à [-100, 100] et arrondis ;
- **barrière numérique** : pour un genre sans résonance (`kinds[].resonance = false`), Résonner reçoit `rules.noResonanceScore` (0 par défaut ; `null` désactive la règle) avec l'origine `regle` ;
- **souveraineté de l'expertise humaine** (`rules.humanSovereignty`) : une évaluation validée par un humain n'est pas remplacée par la règle ; l'écart est signalé par une alerte « barrière contestée » pour la discussion.

**Auto-évaluations** (`selfEvaluations`) : une annotation ou une note Zotero portant des marqueurs conformes à `selfEvaluation.tagPattern` (`discerner+40`, `agir:-30`, `Résonner=10`…) devient une pulsation de l'actant humain auteur de l'annotation (créé au besoin, `humain-<nom>`), avec l'origine `autoevaluation`, validée d'office.

## 4. Mesure des fluctuations (`src/lib/ontoethique/metrics.ts`)

Sans modèle de langage :

| Indicateur | Calcul |
|---|---|
| Statistiques d'un pouvoir | nombre, moyenne, somme, somme des augmentations et des diminutions, min, max ; **état** de la grille d'après la moyenne (diminution, neutre, augmentation) et son nom (Cécité cognitive, Clarté sémiotique…) |
| Valence, intensité, affect | moyenne des scores, moyenne des écarts à 0 ; joie (> 0,5), tristesse (< -0,5), indifférence |
| Valeurs tardiennes | moyennes de l'utilité, de la vérité, de la beauté |
| Complexité ontologique | entropie normalisée de la répartition des éléments entre les quatre dimensions (1 = dimensions également constituées) × log₂(1 + nombre d'éléments) — proposition d'opérationnalisation |
| Par genre | moyennes des pouvoirs et de la valence des humains, des agents, de l'environnement |
| Symbiose | **indice** = valence moyenne des existences ÷ 100 (de -1 à 1) ; **équilibre** = 1 − écart des valences entre genres ÷ 200 ; interprétation : symbiose mutuellement profitable, croissance déséquilibrée, indifférence, diminution des puissances |
| Alertes | misère symbolique (humain dont Raisonner et Résonner ≤ `lowThreshold` alors qu'un agent agit ≥ `highThreshold`), cécité cognitive, aliénation logique (agents), indignation (valeur-vérité ≤ `indignationThreshold`), geste blanc, barrière contestée, déséquilibre entre genres |

**Spirale conique de Pappus** : pour chaque existence, les pulsations sont parcourues dans l'ordre de sa trajectoire ; le **rayon** croît des augmentations de Résonner (dilatation rhizomatique), l'**altitude** de celles d'Agir, l'**angle** tourne de Discerner + Raisonner (déplacement topographique, `spiral.pointsPerTurn` points par tour, sens inverse si la somme est négative). `spiral.stepsPerPulsation` points sont interpolés entre deux pulsations. Forme : *cône évasé* (rayon / altitude > `flaredRatio`), *flèche* (< `slenderRatio`), *tube* (la seconde moitié de la trajectoire gagne de l'altitude sans s'élargir, `tubeGrowth`), sinon *cône équilibré* ; *disque* sans altitude, *point* sans augmentation.

## 5. Export Linked Open Data (`src/lib/ontoethique/linkedData.ts`)

Les mêmes triplets sont écrits en **Turtle** (`modele_onto_ethique.ttl`) et en **JSON-LD** (`modele_onto_ethique.jsonld`). Vocabulaire `oe:` (`ontology.baseUri`), individus sous `ontology.dataUri` + identifiant d'évaluation.

| Terme | Usage |
|---|---|
| `oe:ActiviteSituee` (+ `prov:Activity`) | l'activité : `dcterms:title`, `dcterms:description`, `oe:indiceSymbiose`, `oe:equilibreSymbiose` |
| `oe:ActantHumain`, `oe:AgentNumerique`, `oe:EnvironnementDocumentaire` | existences : `rdfs:label`, `oe:genre`, `oe:participeA`, `oe:dimensionMaterielle` / `Conceptuelle` / `Sociale` / `Temporelle`, `oe:crible`, `oe:valence`, `oe:complexiteOntologique`, `oe:formeSpirale` |
| `oe:Pulsation` | `oe:existence`, `oe:ordre`, `rdfs:label` (moment), `dcterms:source` / `dcterms:references` (trace Zotero), `oe:valeurUtilite` / `Verite` / `Beaute`, `prov:wasGeneratedBy` |
| `oe:Evaluation` | `oe:pouvoir` (`oe:Discerner`…), `oe:score`, `oe:semiose`, `rdfs:comment`, `oa:exact` (citation), `oe:origine`, `oe:validee` |
| `oa:Annotation` | révisions humaines : `oa:motivatedBy` (`oa:editing`, `oa:assessing`), `oa:hasTarget`, `dcterms:creator`, `oa:bodyValue` |

## 6. Modèle de données Omeka S

Le workflow écrit dans le modèle commun de l'écosystème : la collection Zotero (`bibo:Collection`), ses documents et leurs `oa:Annotation` (étape `fetch-literature`), et un **item de configuration** par exécution (`dcterms:MethodOfInstruction`, `dcterms:type` « Configuration de workflow », `dcterms:identifier` = identifiant d'exécution, `dcterms:description` = configuration JSON avec `workflowId: onto-ethique`, `curation:status`, `curation:data` = tokens et coût). Les fichiers de l'évaluation y sont déposés comme médias (`dcterms:identifier` = `<runId>/<fichier>`). Une évaluation manuelle reçoit son item de configuration au premier « Enregistrer dans Omeka S » ; un nouvel enregistrement dépose les fichiers corrigés et retire les anciens médias de même nom.

### Formulaires générés depuis les resource templates

L'outil Mastra `buildResourceTemplateForm` (`src/tools/`) et `buildTemplateForm` (`src/lib/omeka/templateForm.ts`) décrivent le formulaire d'un resource template ; le module `src/ui/public/templateForm.js` le dessine dans l'onglet **Formulaires Omeka S**, dans l'ordre : Physiques (3), Cribles (5), Personnes (8), Agents (6), Actants (4), Concepts (2), Pouvoirs (7), Pulsations (12), Raison trajective (10).

| Précision du template | Effet |
|---|---|
| `o:data.item_sets` | collections d'items de l'item créé (`o:item_set`) |
| `o:data.suggested_resource_class_ids` | classe de l'item (`o:resource_class`) |
| `o:data_type` `customvocab:N` | liste : items de la collection du vocabulaire, ou termes, ou adresses ; `custom_vocab_open` autorise une valeur hors liste |
| `o:data_type` `resource:item` | recherche d'un item (`resource_query` du template) |
| `numeric:integer`, `numeric:timestamp`, `wikidata:…` | nombre entier ; date (AAAA, AAAA-MM, AAAA-MM-JJ ou AAAA-MM-JJTHH:MM:SS, contrôlée par le serveur) ; adresse |
| `value_annotations_template` | champs d'annotation de la valeur (`@annotation`), ex. Temporalités : ordre relatif, ordre successif |

`itemPayload` contrôle les valeurs (propriété du template, type autorisé, appartenance à la liste, obligatoires). Pour un pouvoir, `checkPower` (`src/lib/ontoethique/omekaForms.ts`) exige une intensité entière de -100 à 100, un type et **au moins** un élément par maillon de sa séquence (un maillon peut en relier plusieurs). Le type est reconnu par `powerTypeOf` d'après un texte (identifiant, libellé, ou titre de l'item du vocabulaire des types : dans l'instance, `dcterms:type` est un item du custom vocab 16 — « Dicerner », « Raisonner », « Résonner », « Agir ») ; casse, accents et une faute de frappe sont tolérés :

| Type | Séquence |
|---|---|
| Pouvoir de discerner | physique → crible → actant → concept |
| Pouvoir de raisonner | concept → actant → concept |
| Pouvoir de résonner | concept → actant → concept (l'actant héberge les concepts dans son intériorité) |
| Pouvoir d'agir | concept → actant → crible → physique |

Le maillon d'un lien (source ou destination de `jdc:hasConcept`, élément supplémentaire) est porté par l'annotation de valeur `dcterms:type` écrite par EcoSpace ; sans annotation, l'ordre des valeurs. Le formulaire de modification (`templateForm.js`) écrit le type comme l'**item** du vocabulaire quand le modèle l'impose (`GET /api/ontoethique/form` ajoute à chaque type `itemId`, `itemTitle`, `itemType`) ; à l'enregistrement (`POST /api/econetwork/item`), le maillon de chaque lien est repris de la valeur envoyée ou, à défaut, du lien existant vers le même item (le modèle ne déclarant pas d'annotation pour ces propriétés).

**Formulaires** (`templateForm.js`) : `GET /api/ontoethique/form` renvoie aussi `managed` (champs non affichés : positions, créées par le dialogue « position » d'EcoSpace, et journal de génération) et `templates` (types d'items des formulaires) ; un champ d'item lié dont la recherche ne trouve pas le titre saisi propose **Créer « titre » et le lier** (type au choix parmi les templates de son `resource_query`, sinon tous) : `POST /api/ontoethique/form/item` (`eco` facultatif : l'item est rattaché à l'écosystème par `econetwork.ecoProperty`), la valeur est sélectionnée et enregistrée avec le formulaire.

### IHM EcoNetwork

Page `src/ui/public/econetwork.html`, servie sur `/econetwork` par le serveur ontoÉthique (routes `src/ui/econetworkRoutes.ts`, bibliothèque `src/lib/omeka/network.ts`). La modélisation y suit des **étapes** (navigation latérale, précédente / suivante, état dans l'adresse `#step=1.2&eco=<id>`) :

| Étape | Contenu |
|---|---|
| 1.1 Créer ou choisir un écosystème | items du template `econetwork.ecoTemplateId` ; création par le formulaire du template |
| 1.2 Réseau de l'écosystème | graphe **d3-force** : l'écosystème, ses **éléments** (items dont `jdc:hasEcoCon` le désigne, ou qu'il désigne par cette propriété) et les ressources liées aux éléments (valeurs sortantes et items qui les désignent) |

Un clic sur un nœud ouvre un **menu circulaire** (icônes d'après Lucide, libellé au survol ; le second anneau garde les libellés des types, dans la couleur du type) :

| Action | Effet |
|---|---|
| lier | second anneau : propriétés du template du nœud dont un type de données est un custom vocab adossé à une collection d'items → template qui crée ses items dans cette collection. Le titre est autocomplété (`/api/econetwork/search`) : items dont le titre contient la saisie, parmi les templates acceptés par la propriété, avec leur type et l'indication « déjà lié ». Un item choisi est lié tel quel (`existing`) ; sinon le nouvel item (repris s'il existe avec ce titre et ce template) est créé. Dans les deux cas il est rattaché à l'écosystème, puis ajouté aux valeurs de la propriété du parent. Un nouveau nœud peut recevoir un **média** (fichier déposé ou adresse importée par Omeka S), comme un nouvel écosystème à l'étape 1.1 ; un média en échec n'annule pas la création. Depuis l'écosystème : les types `elementTemplateIds`. `jdc:hasEcoCon` n'est pas proposé comme lien |
| dupliquer | copie de toutes les valeurs, titre suivant libre (« titre 2 », « titre 3 »…) |
| détails | onglet **Omeka S** : page d'administration de l'item dans une iframe, servie par le **mandataire** du serveur (même origine) ; onglet **Fiche** : valeurs lues par l'API (`details` de `GET /api/econetwork/item`) ; lien vers un nouvel onglet |
| supprimer | conséquences affichées : parents — écosystèmes de rattachement (lien porté par le nœud) et nœuds qui le désignent (avec « délier ») — et enfants impactés ; **retirer du réseau** (retire le rattachement) ou **supprimer dans Omeka S**, refusé tant qu'un autre nœud l'utilise ou qu'il est rattaché à un autre écosystème |
| modifier | formulaire du template pré-rempli ; les champs du template sont remplacés, les autres propriétés conservées |

Mandataire Omeka S (`src/lib/omeka/proxy.ts`, `econetwork.omekaProxy`) : le serveur relaie vers l'instance toutes les requêtes dont le chemin est celui de l'instance (`/omk_ontoethique/…`, tiré de `OMKS_API_URL`), avant ses propres routes. Sans lui, l'iframe (127.0.0.1:7280 → localhost) est d'un autre site : le cookie de session d'Omeka S, sans attribut `SameSite` donc traité en `Lax`, n'y est pas envoyé et la connexion échoue (« Invalid or missing CSRF token »). Réécritures : `Host`, `Origin` et `Referer` vers l'instance ; `Location` absolue vers l'instance → chemin relatif (retour sur l'item après connexion, Omeka S mémorisant `redirect_url`) ; `Domain` et `Secure` retirés des cookies. Les adresses des pages Omeka S étant relatives à la racine (`/omk_ontoethique/…`), le contenu n'est pas modifié. Une instance installée à la racine d'un domaine (chemin vide) n'est pas relayée : l'iframe pointe alors vers l'instance elle-même. Le serveur écoutant sur 127.0.0.1, le mandataire n'expose l'instance qu'à la machine locale.

Formulaires : une propriété de template sans type de données imposé reçoit les types par défaut d'Omeka S (texte, item lié, adresse), sans quoi une valeur liée (ex. `jdc:hasEcoCon` du template Personne) n'était pas affichée.

Écriture : un `PATCH` Omeka S remplace **toutes** les valeurs d'un item ; `writeValues` relit l'item et renvoie l'ensemble de ses propriétés avec les valeurs modifiées. Le type de la valeur de rattachement est celui du template de l'élément (`customvocab:15` sur l'instance), à défaut `resource:item`. Le client Omeka S du serveur est gardé 5 minutes (son initialisation relit vocabulaires et templates).

| Méthode et route | Rôle |
|---|---|
| `GET /econetwork` | page |
| `GET /api/econetwork/ecos` | écosystèmes |
| `GET /api/econetwork/graph?eco=` | nœuds (`role` : eco, element, linked ; template, classe) et liens (propriété) |
| `GET /api/econetwork/linkable?item=` | propriétés et types de nœuds liables |
| `GET /api/econetwork/search?parent=&term=&q=` | items existants liables par la propriété (`id, title, templateId, template, linked`) |
| `POST /api/econetwork/link` | `{ eco, parent, term, templateId, title }` (nouveau nœud) ou `{ eco, parent, term, existing }` (item existant) |
| `POST /api/econetwork/media/file?item=&name=&title=` | fichier en corps brut (`Content-Type` du fichier, `econetwork.maxMediaMB` au plus) → média `upload` ; repris si l'item a déjà un média de même empreinte SHA-256 |
| `POST /api/econetwork/media/url` | `{ item, url, title }` → média `url` (Omeka S télécharge l'adresse) ; http(s) vers une adresse publique seulement (localhost, adresses privées et de lien local refusées, y compris après résolution DNS) ; repris si cette source est déjà attachée |
| `POST /api/econetwork/duplicate` | `{ item }` : copie de l'item (titre incrémenté, valeurs copiées ; un concept sans ses enfants `narrowerTerm`) ; EcoSpace la rattache selon le type : personne ou agent au même actant (`/api/ecospace/member`), crible au maillon crible de tous les pouvoirs qui le contiennent (`/api/ecospace/power/link`), actant, physique racine et concept placés (`/api/ecospace/place`), pouvoir, pulsation et physique enfant par leurs valeurs copiées (`dupText`, `duplicate`) |
| `GET`, `POST /api/econetwork/item` | valeurs au format du formulaire et fiche `details` ; `{ id, values }` : modification contrôlée par le template ; les propriétés gérées ailleurs (`managedTerms` : `ecospace.geoHistory.property` positions, `ecotext.pipeline.property` journal) ne sont ni affichées par le formulaire (`managed` de `GET /api/ontoethique/form`) ni réécrites |
| `GET /api/econetwork/impact?item=` | parents, enfants, écosystèmes |
| `POST /api/econetwork/delete` | `{ item, eco, mode: network \| omeka }` |
| `POST /api/econetwork/unlink` | `{ source, target, term }` |

### IHM EcoSpace

Page `src/ui/public/ecospace.html` (three.js 0.169 par carte d'import, d3 pour le menu), servie sur `/ecospace` par le serveur ontoÉthique (routes `src/ui/ecospaceRoutes.ts`, bibliothèque `src/lib/ecospace/hex.ts`). Elle remplace la représentation en réseau de forces d'EcoNetwork par un **espace en trois dimensions** ; la création, la liaison, la modification et la suppression des items passent par les routes d'EcoNetwork.

| Étape | Contenu |
|---|---|
| 1.1 Créer ou choisir un écosystème | comme EcoNetwork ; un nouvel écosystème reçoit aussitôt son espace (grille) ; ou **depuis un texte** (module `ecotext.js`, voir ci-dessous) |
| 1.2 Espace de l'écosystème | grille hexagonale et éléments placés ; un écosystème sans espace propose « Créer la grille » |

**Grille** : hexagones à moins de `radius` anneaux du centre (3·r·(r+1)+1), de rayon `hexSize` mètres (1 unité de la scène = 1 m), orientation `pointy` ou `flat`. Chaque hexagone a deux systèmes de coordonnées : **cube** (q, r, s ; q + r + s = 0, [redblobgames](https://www.redblobgames.com/grids/hexagons/#coordinates-cube)) et **géographique** (longitude, latitude, altitude), par projection locale autour de `origin` (est = +x, nord = −z, altitude = y ; 111 320 m par degré de latitude). La grille est fixée à la création de l'espace : modifier `ecospace.grid` ne change que les espaces créés ensuite.

**Stockage** : un fichier `resultats/ecospace/<écosystème>.json` (`{ eco, created, grid, placements: [{ item, q, r, s, shape, placed }] }`). Les items restent dans Omeka S, rattachés à l'écosystème par `econetwork.ecoProperty` ; titre et template sont relus à chaque ouverture (un item supprimé apparaît « introuvable »).

**Formes** (`ecospace.shapes`, par resource template ; dimensions en fraction de `hexSize`) :

| Élément | Forme | Placement |
|---|---|---|
| Actant (template 4) | fullerène C60 (icosaèdre tronqué : 60 atomes, 90 liaisons, enveloppe convexe translucide), rayon `fullereneRadius` ; sphère de rayon `sphereRadius` (par défaut tous deux égaux au rayon de l'hexagone, `hexSize`) | centroïde du fullerène au centre de l'hexagone (altitude 0) ; pôle nord de la sphère sur ce centroïde (centre de la sphère à −`sphereRadius`, sous la grille) |
| Personne (template 8), Agent (template 6) | comme l'actant, petit **fullerène** C60 + **sphère** sous la grille (couleur propre) : fullerène de rayon `memberRatio` × taille du sous-hexagone, sphère de rayon `sphereRatio` × celui du fullerène, pôle nord au centroïde du fullerène ; titre au-dessus. La sphère d'un actant qui a des membres devient translucide (45 % au lieu de 85 %) pour laisser voir les leurs ; **ajout seulement depuis un actant** (menu « lier » de l'actant ; `POST /api/ecospace/place` les refuse) | **sous-grille** de l'hexagone de l'actant (`subGrid`, `src/lib/ecospace/hex.ts`) : sous-hexagones d'orientation inverse, `subRings` anneaux (plus si nécessaire), à la plus grande taille qui les garde dans l'hexagone (× `subMargin`) — 2 anneaux = 19 sous-hexagones de 0,217 × `hexSize` ×0,95 ; dessinée sur la tuile de l'actant. Le sous-hexagone central reste à l'actant ; un membre est centré sur le premier sous-hexagone libre, au niveau de la grille (moitié du fullerène au-dessus, moitié en dessous ; `y` = 0 ; `geo.sphereCenter` = centre de la sphère) depuis le centre, emplacement conservé dans l'espace (`members` : actant → membre → q, r). Les membres sont lus dans Omeka S : valeurs `anchorTerm` de l'actant (`jdc:hasPerson`, `jdc:hasAgent`) ; une même personne peut figurer dans plusieurs actants. Supprimer → « Détacher » retire la valeur de l'actant |
| Physique (template 3) | boîte à base carrée : le plus grand carré inscrit dans l'hexagone ((3 − √3) × rayon) × `baseRatio` ; hauteur = durée entre la date de création (`createdTerm`, sinon `o:created`) et la date de modification (`o:modified`) | au-dessus de l'hexagone, sur l'**échelle temporelle** : y = 0 (surface) = maintenant, y = H = plus ancienne date de création des physiques de l'espace ; la boîte va de y(modification) à y(création). **Enfants** (physiques qui le désignent par `parentTerm`, `dcterms:isPartOf`) : boîtes intérieures, de la base du parent moins sa marge `childPadding` ; la hauteur du parent (moins la même marge relative) est partagée en **tranches empilées de haut en bas, dans l'ordre alphabétique des titres**, proportionnelles à leur importance (`importanceTerm`, `jdc:importance`, 1 par défaut ; toutes nulles = parts égales ; une importance nulle parmi d'autres = pas de boîte) ; les dates d'un enfant ne fixent donc pas sa position (elles restent affichées au survol et dans les détails) ; profondeur `maxDepth`. **Image** : si le physique a un média de type `image/*` (le premier), l'image est plaquée sur chaque face de sa boîte (étirée à ses proportions ; opacité 0,92, ou 0,45 si la boîte contient des enfants) |
| Concept (template 2) | **bulle conceptuelle** : capsule translucide d'**axe horizontal est-ouest**, cylindre fermé à ses deux extrémités par des demi-sphères. **Aucune taille ni position saisie à la main** (ni glisser, ni poignées) : `layoutConcepts` (`src/lib/ecospace/concepts.ts`) les calcule à chaque lecture de l'espace. **Taille** : sans enfant, rayon `leafRadius` et longueur = 2 × rayon + caractères du titre × `charWidth` (titre tronqué à `maxLabel` caractères) ; parent : ses enfants sont rangés sur une ligne le long de son axe (écarts `padding`), décalés d'une demi-hauteur de titre en diagonale vers le bas-sud, et son titre occupe la bande opposée (haut-nord, `labelY`, `labelZ`) — rayon = plus grand rayon d'enfant + `labelHeight`/2 + `padding`, longueur = ligne des enfants (ou titre, si plus long) + marges + demi-sphères. Titre écrit dans la scène (sprite tourné vers la caméra, `charWidth` par caractère, `labelHeight` de haut) | **Position** : frères répartis de façon équilibrée — ordre alphabétique du titre, écarts égaux, ensemble centré sur le parent ; racines (concepts sans parent dans l'espace) en grille presque carrée (⌈√n⌉ colonnes, écart `spacing`) centrée sous la grille, sommets alignés à `topDepth` sous la surface. L'hexagone d'un concept est celui au-dessus de son centre (calculé) ; celui du placement n'est gardé que pour mémoire. **Hiérarchie** lue dans Omeka S entre concepts placés : `broaderTerm` (`skos:broader`) de l'enfant ou `narrowerTerm` (`skos:narrower`) du parent, relations **gérées** = annotées par cet écosystème (`econetwork.ecoProperty`, `jdc:hasEcoCon`) ou sans annotation d'écosystème ; celles annotées par d'autres écosystèmes seulement sont ignorées. Plusieurs parents : le plus petit identifiant ; un cycle fait du concept une racine. Elle se modifie **par le menu** (« lier » : concept parent, concept enfant, détacher) ; les relations écrites portent l'annotation de l'écosystème. `relatedTerm` (`skos:related`) est seulement affiché dans les détails |
| Pouvoir (template 7) | **cylindre translucide** (`powerTube` : une géométrie partagée de 40 triangles mise à l'échelle, quelle que soit la longueur du segment ; couleur du type : `colors`, Discerner bleu, Raisonner violet, Résonner or, Agir rouge), rayon `tubeRadius` (× `hexSize`) ; ses hexagones (treillis « zigzag » de `lattice` hexagones par tour) ne sont plus dessinés — un tube de 165 km en comptait des millions — mais calculés : `cellAt` donne l'hexagone (j, k) du point cliqué sur la surface, `cellLocal` / `cellWorld` son centre ; un tube par **segment droit**, les segments suivants (changement de direction), les **relations multiples** et les **branches** sont des tubes enfants, joints par une sphère (`jointRatio`). **Crible** : anneau (`cribleRatio`, `cribleColor`) traversé par le tube. Survol : hexagone (ligne `j` le long de l'axe, rang `k` autour) ; **clic sur un hexagone** : menu lier → **Connecter ici** (maillon au choix, élément placé ou nouveau ; un tube enfant part de cet hexagone, un crible y pose son anneau), **Branche** (nouveau pouvoir de même type, maillons repris) ; détails, supprimer, modifier | ancré au centre des éléments : actant = centroïde du fullerène, physique = centre de sa boîte (racine ou intérieure), concept = centre de sa bulle. Chaîne principale : premier élément de chaque maillon, dans l'ordre de la séquence (`omekaForms.powerTypes`). **Maillons multiples** : chaque lien du pouvoir porte en annotation de valeur son maillon (`roleTerm`, `dcterms:type` : « concept source »…) ; sans annotation, l'ordre des valeurs. Un élément supplémentaire part de l'hexagone où il a été connecté (`powerLinks` de l'espace : pouvoir → « maillon\|item » → `{ seg, j, k }`, `seg` = clé de segment « type\|de\|vers » ou « type\|segment@j,k\|vers » pour un tube enfant), sinon du maillon principal précédent ; crible connecté : anneau sur son hexagone. Une branche est un autre pouvoir de même type qui partage un début de chaîne (segments identiques dessinés une fois). **Intériorité** : les concepts de **tous** les pouvoirs quittent la disposition sous la grille et vont dans la sphère de leurs actants ; concepts groupés par ensemble d'actants hôtes, chaque groupe empilé (`interiorLayout`) sous le centre de ses hôtes — au milieu de plusieurs actants, donc dans l'**intersection de leurs sphères** (diagramme de Venn) ; chaque sphère grandit juste assez pour contenir les capsules de ses groupes (calcul exact : rayon minimal d'une sphère de pôle nord fixe contenant les extrémités de l'axe d'une capsule ; marge `interiorPadding`) et devient translucide. Types `interior` (Raisonner, Résonner) : le tube relie directement les concepts. **Création depuis n'importe quel maillon** (`powerSectors` : secteurs de « lier » d'un physique, crible, actant ou concept, un par type de pouvoir et par maillon de sa séquence qui a la forme de l'élément, libellé « Type · source » si elle y revient ; `askPower(type, élément, null, maillon)` fixe l'élément à ce maillon) : dialogue des maillons dans l'ordre, « + » pour plusieurs éléments d'un même maillon, intensité ; suggestions des cribles et concepts sans tenir compte des accents ni de la casse (un titre saisi sans accent reprend l'élément existant) |

**Couches** : un hexagone porte un élément par couche de forme (`shape.layer`, défaut : la clé de la forme) : l'actant occupe la couche `dessous` (sa sphère est sous la grille), le physique la couche `dessus` ; un actant et un physique peuvent donc partager un hexagone, pas deux physiques racines ni deux actants.

**Échelle temporelle** : curseur de hauteur H (`timeScale.minHeight` à `maxHeight`, progression géométrique ; défaut `height`) et mode **linéaire** ou **logarithmique** (y ∝ log(1 + 99u), u = ancienneté relative : les intervalles récents sont dilatés). Un axe gradué (7 graduations, précision adaptée à leur écart) est dessiné au nord-ouest de la grille. Le curseur ne recharge rien : positions et hauteurs sont recalculées par la page.

**Nouvel écosystème depuis un texte** (étape 1.1, bouton « Nouvel écosystème depuis un texte » ; module `src/ui/public/ecotext.js`, routes `src/ui/ecotextRoutes.ts`, fonctions `src/lib/ecospace/ecotext.ts`) : saisie guidée, une rubrique ouverte à la fois (`ecotext.stages` : écosystème, actants et personnes, physiques, concepts, pouvoirs, pulsations), chacune avec son aide et ses **phrases modèles** insérables (`{{…}}` à compléter : Tab sélectionne le suivant) ; **autocomplétion locale** sans appel au modèle — après un « non refermé ou sur le dernier mot (`minChars`), titres des items existants (`GET /api/ecotext/vocab`) et noms déjà cités entre « » dans toutes les rubriques, types de la rubrique en premier, ↑ ↓ puis Entrée ou Tab insère « titre » ; **Suggérer la suite** (`POST /api/ecotext/suggest`, `eco-suggest-agent`, modèle rapide) propose des phrases à ajouter ou ignorer ; brouillon dans `localStorage` (`ecotext-draft`). **Analyser** (`POST /api/ecotext/model`, `eco-model-agent`, modèle analytique, sortie `EcoModelSchema` : un champ par maillon de pouvoir, `concept_source`, `concept_destination`…) ; `completeModel` normalise les textes, ordonne les maillons selon la séquence du type (`alignSteps`), déclare les éléments cités dans les maillons et les contenants manquants, rapproche chaque élément d'un item existant de même titre et de même type (`existing`), écarte les flux qui ne visent pas une autre pulsation de la liste et les titres de pouvoir génériques. **Aperçu modifiable** (`renderPreview`) : tableaux par type, case pour ne pas créer, badge existant / nouveau, listes séparées par « ; », type de pouvoir (les maillons suivent sa séquence), intensité, pouvoirs et flux des pulsations. **Création** (`createAll`, par les routes existantes, dans une fenêtre d'opération) : écosystème (`POST /api/ontoethique/form/item`, titre et description), grille, origine = lieu de l'écosystème (sinon du premier actant ou physique racine) géocodé (premier résultat de Nominatim, une requête par seconde), actants (`/api/econetwork/link` puis `/api/ecospace/place` près de l'hexagone de leur lieu, position datée `/api/ecospace/position`), personnes et agents (`/api/ecospace/member`), physiques (contenants d'abord, racines placées et positionnées), concepts (placés) puis hiérarchie (`/api/ecospace/concept/relate`), pouvoirs (`/api/ecospace/power` : maillons existants par identifiant, cribles et concepts nouveaux par titre ; un actant ou un physique absent fait sauter le pouvoir), pulsations (créées avec leur premier pouvoir, puis les suivants ; position), flux (ordre relatif rapproché des options de `pulseRelatives`) ; une erreur sur un élément devient un avertissement et la création continue ; enfin le **journal de la génération** est conservé dans l'item de l'écosystème (`POST /api/ecotext/pipeline`, propriété `ecotext.pipeline.property` = `jdc:pipeline`) : une valeur par étape — saisie de chaque rubrique, chaque suite proposée (ajoutée ou ignorée), chaque modélisation de l'agent, modélisation validée avec le bilan de la création — préfixée par la date de la génération (`[AAAA-MM-JJ HH:MM]`, une même génération est remplacée, les autres valeurs conservées) et annotée selon le modèle d'annotation de la propriété (template 17 « Incitation » : `dcterms:title` étape, `dcterms:description` texte saisi, date ou bilan, `jdc:prompt` demande envoyée, `jdc:reponse` réponse ou modélisation JSON, `jdc:iaModel` modèle, `jdc:cost` tokens, coût, énergie, carbone, durée) ; le journal est tenu par la page pendant la session et s'affiche dans l'onglet **Journal** des détails (EcoSpace : puce « Écosystème : … » de l'en-tête ou bouton **Écosystème** de la rubrique Vues et affichage, ouverts sur le journal ; EcoNetwork : détails du nœud de l'écosystème), module partagé `pipelineJournal.js` (`renderPipeline` : générations de la plus récente à la plus ancienne, étapes repliables avec texte saisi, demande, réponse JSON indentée, modèle et coût ; onglet affiché seulement si l'item a un journal) ; à la fin, l'écosystème est choisi (étape 1.2). Coût : les deux agents passent par `askAgent` et l'historique de consommation (tâche `ecotexte`).

**Rubriques et fond de l'espace** : au-dessus de la scène, sous le titre et la ligne d'information (`#space-info`), quatre rubriques repliables (`details.rubric`, état mémorisé dans `localStorage` `ecospace-rub-<id>`) : **Aide** (repliée par défaut), **Vues et affichage** (boutons de vue, liste, légende, origine géographique ; un bouton bascule `toggle` dont le bloc est masqué est grisé), **Pulsations** (animation, vitesse, échelle turbo, suivi ; repliée, elle indique si l'animation est arrêtée) et **Échelle temporelle** (hauteur, mode, dates choisies, streamgraph ; repliée, elle résume la fenêtre de dates dans `#time-sum` et le streamgraph n'est dessiné qu'à son ouverture). Fond de la scène (`paintBackground`, couleurs `--sky` et `--under`, thèmes clair et sombre) : un disque de l'emprise de la grille (`extent`) est dessiné avant tout le reste (sans test de profondeur, `renderOrder` −10) — face du dessus `--under`, face du dessous `--sky` — et le fond (`scene.background`) vaut `--sky` quand la caméra est au-dessus de la grille, `--under` en dessous : vu d'en haut, l'espace sous la grille se détache du reste ; vu d'en bas, on voit le ciel à travers la grille.

**Streamgraph des éléments** (`#timeline`, `renderTimeline`, `streamData`, d3 7.9 : `d3.stack` + `stackOffsetSilhouette`, `d3.area` + `curveMonotoneX`, sur le modèle de d3-graph-gallery.com/graph/streamgraph_basic.html) : sous la barre de l'échelle temporelle, en abscisse le temps de la plus ancienne date (création d'un physique ou position) à maintenant (`fullTimeBounds`), dans le mode de l'échelle temporelle (linéaire ou logarithmique, récent dilaté), échantillonné en `STREAM_SAMPLES` (160) dates régulières à l'écran ; en épaisseur, le **nombre d'éléments de chaque type présents** à chaque date (`presence`) : physiques racines depuis leur création (leurs enfants ne sont pas comptés), actants et personnes pendant les séjours de leurs positions datées (`track`, jusqu'au retrait), agents comme leur actant, autres éléments depuis leur placement (`placed`) ; couleur de la forme, légende avec l'effectif actuel, axe vertical gradué en nombre d'éléments (épaisseur totale du flux). Survol : règle verticale et effectifs par type à la date pointée, sur la première ligne (au-dessus du libellé « éléments » de l'axe vertical). Un **brush** (`d3.brushX`) choisit les dates affichées : pendant le glissement seule l'indication des dates change, au relâchement la fenêtre devient l'échelle temporelle de l'espace (haut = début, surface = fin ; `time.oldest`, `time.now`), mémorisée par écosystème (`localStorage` `ecospace-window-<éco>`) ; un clic hors de la sélection ou **Toutes les dates** revient à l'étendue complète. **Éléments hors de la période** (`timeOff`, appliqué par `applyVisibility` sans être mémorisé comme caché) : un élément daté présent à aucun moment de la fenêtre (mêmes périodes que le streamgraph : physique depuis sa création, actant, personne, agent, concept selon `presence`) disparaît de la scène et de la liste (`#elements`, qui indique en tête combien sont masqués, avec un lien « toutes les dates ») ; un pouvoir quand tous ses éléments sont hors période, un crible ou une pulsation quand tous leurs pouvoirs le sont (les tubes suivent leurs extrémités) ; les badges des grands hexagones ne comptent que les éléments affichés (`updateBadges` : ancêtres de l'hexagone de chaque élément ; un hexagone sans élément affiché perd son badge, sauf celui de l'origine). La vue de l'espace fournit pour chaque élément suivi `track` (positions de cet écosystème, triées par date). **Déplacement dans le temps** (`placeInTime`, appelé par `buildItems`) : chaque actant et physique à positions datées est posé sur l'hexagone de base de sa position à la date de la surface (`time.now` : fin de la fenêtre, maintenant sans fenêtre ; `positionAt` : dernière position jusqu'à cette date, sinon la première connue), ou le libre le plus proche sur sa couche, dans l'ordre de placement (comme `rehexPlacements`) ; résultat dans `p.shown = { hex, at, moved }`, `p.q`/`p.r` restent la position de référence (serveur, actions du menu). Les personnes et agents suivent le décalage de leur actant, les concepts d'intériorité le décalage moyen de leurs actants hôtes ; pouvoirs, cribles et pulsations suivent les ancres ; `updateBadges` retire l'élément déplacé des grands hexagones de sa référence et l'ajoute à ceux de sa position à la date (s'ils existent : la grille à niveaux reste celle des positions de référence). **Chemin spatio-temporel** (`buildTracks`, cube espace-temps) : pour chaque élément suivi, dans la fenêtre de dates, un trait vertical par séjour à sa position géographique (hauteur = date), un trait horizontal à la date de chaque déplacement, un point par position ; une position au-delà de 1,15 × l'emprise de la grille est ramenée au bord avec une étiquette (lieu, distance, date) ; caché avec l'élément dans la liste.

**Origine géographique** (bouton de la barre de l'espace) : dialogue avec une carte **Leaflet** 1.9.4 (chargée à la première ouverture depuis le CDN ; tuiles `ecospace.map.tiles`), repère déplaçable sur le centre de la grille et cercle de son emprise ; **recherche de lieu** par le service de géocodage `map.geocoder` (Nominatim, appelé par le navigateur, résultats en français, `searchLimit`), **Ma position** (géolocalisation de l'appareil, altitude si fournie), clic sur la carte ou saisie de la latitude, longitude et altitude ; « Enregistrer » appelle `POST /api/ecospace/origin` (l'espace enregistré est aussi copié dans Omeka S).

**Grille calculée d'après les positions géographiques** : chaque actant et chaque physique placé garde une **position géographique de référence** (`pos` du placement : centre de l'hexagone où il a été placé ou déplacé ; un espace antérieur la reçoit à la lecture). Quand l'origine ou une position change, `rehexPlacements` (`src/lib/ecospace/hex.ts`, avec `geoToPlane`, inverse de `planeToGeo`) recalcule leurs hexagones de base (taille `hexSize`) : dans l'ordre de placement, l'hexagone qui contient leur position, sinon le plus proche libre sur la même couche (`nearestFree` : anneaux autour de lui, sans limite de grille). Un changement d'hexagone sans changement de lieu n'ajoute pas de point à l'historique.

**Grille à niveaux** (`adaptiveGrid`, `grid.maxRings`, `lod`), sur le modèle de **H3** (index hexagonal hiérarchique d'Uber, utilisé par l'API H3 de TravelTime) : hiérarchie d'**ouverture 7** — chaque hexagone a exactement 7 enfants (son enfant central et ses 6 voisins), de taille √7 fois plus petite et tournés de atan(√3/5) ≈ 19,1° ; parent (`parentHex` : arrondi cube de ((3q + r)/7, (−q + 2r)/7)) et enfants (`centerChild` : (2q − r, q + 3r), `childHexes`) se calculent sur les coordonnées axiales, sans recherche géométrique, et chaque hexagone de base a un seul ancêtre par niveau (partition exacte, vérifiée). Les éléments gardent leur taille (hexagones de base) ; niveau du haut = le plus petit dont `maxRings` anneaux autour de l'origine contiennent tout (au niveau 0 : au moins `radius` anneaux) — 24 km pour des éléments à 165 km. Un hexagone de niveau > 0 qui contient un élément, l'origine ou un hexagone du disque de rayon `radius` autour d'elle est découpé en ses 7 enfants, jusqu'au niveau 0. Chaque cellule porte, comme les propriétés agrégées par cellule de l'API H3 de TravelTime, `count` et `kinds` (nombre d'éléments par type), et un **index hiérarchique** `id` (hexagone du haut puis chiffre de chaque enfant, 0 = central, 1 à 6 = direction : « 8:0,0/35406102 »). La vue renvoie `hexes` (niveau 0, avec `parent` et `id`) et `levels` (`top`, `aperture`, `radius`, `lod`, `cells` : niveau, taille, rotation `angle`, centre, géographie, `count`, `kinds`, `split`, `parent`, `id`) ; calcul en quelques millisecondes. La page (`buildGrid`) range chaque sous-grille dans un groupe (dans celui de son parent) qui contient un tracé unique des contours (hexagones tournés de leur niveau) et un **maillage instancié** des tuiles de base (couleur par instance : survol, menu, centre ; `paintTiles`) : quelques appels de dessin au lieu d'un par hexagone. `updateLod` (à chaque image) n'affiche une sous-grille que si la caméra est à moins de `lod` × la taille de son hexagone, sinon un **badge** « n éléments » (infobulle : effectifs par type ; « origine » pour l'hexagone de l'origine) la remplace. Un clic sur un badge ou sur un grand hexagone découpé (`coarseAt` : ancêtres de l'hexagone de base du point, comme dans H3, puis descente tant que la sous-grille est visible) **zoome** dessus (`zoomCell`) ; le survol donne sa taille, son niveau, son index et ses effectifs. Tampon de profondeur logarithmique (de 1 m à des centaines de km) ; l'échelle temporelle reste près de l'origine (`homeExtent`), la vue d'ensemble et la rose des vents couvrent toute la grille (`extent`). Le placement accepte tout hexagone de base (`validHex`).

**Historique des positions** (`ecospace.geoHistory`) : à chaque lecture de l'espace, `trackPositions` compare la position de chaque élément suivi (`shapes` : actant, physique, personne) à la dernière enregistrée (`geoLast` du fichier de l'espace ; une personne est suivie dans chacun de ses actants) et, si elle a changé, ajoute un point à son fichier **GeoJSON** `resultats/ecospace/<geoHistory.dir>/<item>.geojson` (FeatureCollection : `Point` [lon, lat, alt], propriétés `eco`, `at`, `event` placé / déplacé, `shape`, `q`, `r`, `s`, et pour une personne `actant`, `sub` ; un élément retiré de l'espace reçoit une entité sans géométrie, `event` retiré). Actant et physique : position de référence ; personne : position de référence de son actant décalée de son sous-hexagone. Le fichier est copié comme **média de l'item** dans Omeka S (`omekaMedia` ; `dcterms:identifier` = `identifierPrefix` + item, envoi `delay` ms après le dernier changement, ignoré si inchangé (sha256), ancienne version retirée) ; Omeka S doit accepter le type de média « application/geo+json » et l'extension « geojson » (Administration > Paramètres > Sécurité) ; une copie en échec est retentée à une lecture de l'espace après `retryDelay` ms. Les positions sont aussi écrites dans la **propriété `geoHistory.property`** de l'item (`jdc:hasPosition`, modèles Physique, Actant et Personne) par `syncPositions`, dans le même envoi différé : une valeur littérale par point (« latitude, longitude · date · adresse »), annotée selon le modèle d'annotation de la propriété (template 16 « Position spatio-temporelle ») : `dcterms:title` (événement et date UTC), `dcterms:description` (adresse choisie, en littéral), `jdc:geoPosition` (`geography:coordinates`, « latitude,longitude »), `jdc:timePosition` (`numeric:timestamp`), plus l'écosystème (`ecoProperty`). Seules les valeurs annotées par un écosystème de l'historique sont remplacées (les valeurs saisies à la main dans Omeka S sont conservées) ; rien n'est écrit si elles sont à jour ; état dans `omekaProperty` de `GET /api/ecospace/geo`, nouvel essai comme pour le média. Détails d'un actant, d'un physique racine ou d'une personne : position de référence et lien vers l'historique.

**Position spatio-temporelle** (action **position** du menu circulaire et de la liste des éléments, actants, physiques racines et pulsations — `positionTarget` côté serveur : historique enregistré et copié par `pulseHistory`, sans position de référence ni hexagone ; une personne suit son actant) : dialogue `#dlg-position` (`askPosition`) avec une carte Leaflet (repère déplaçable, clic, trajectoire en pointillés des positions de l'écosystème), champ **Adresse ou lieu** avec recherche (`geocode`, service `map.geocoder` partagé avec l'origine : le lieu choisi place le repère et devient l'adresse de la position, `address`), latitude, longitude, altitude et **date** (`datetime-local`, maintenant par défaut) ; historique de l'item dans cet écosystème (plus récent en tête), chaque position pouvant être **corrigée** (reprise dans le formulaire) ou **supprimée**. `POST /api/ecospace/position` ajoute ou corrige un point, `POST /api/ecospace/position/delete` en retire un ; `applyHistory` trie l'historique par date, prend comme position de référence le point le plus récent de l'écosystème (une position antérieure ne fait que compléter l'historique), recalcule les hexagones (`rehex`), met à jour `geoLast` (pas de point ajouté à la relecture) et programme la copie dans Omeka S.

**Pulsations existentielles** (forme `pulse`, template 12) : `view` renvoie `pulsations` (items du template rattachés à l'écosystème par `ecoProperty` : `powers` et `flux`, chacun avec sa temporalité lue dans l'annotation de valeur — `relative` { id, title }, `order` — et `track`, ses **positions spatio-temporelles** dans l'écosystème : `positionTrack` fusionne les points de son historique `geoHistory` et les valeurs de `geoHistory.property` (`jdc:hasPosition`) saisies dans Omeka S, sans écosystème ou annotées par celui-ci, coordonnées lues dans l'annotation `annotation.geo` et date dans `annotation.time` (sinon dans le texte de la valeur), doublons à la seconde fusionnés) et `pulseRelatives` (options de l'ordre relatif, d'après l'annotation du champ `fluxTerm` du modèle). `buildPowers` calcule le **parcours** de chaque pouvoir (`powerRoutes` : éléments de chaque maillon dans l'ordre de la séquence, crible = centre de son anneau, actant hôte d'un pouvoir intérieur sauté) et le **graphe des tubes** (`tubeGraph` : nœuds = extrémités des segments, anneaux et départs des tubes enfants projetés sur l'axe du segment porteur ; arêtes = tronçons d'axe). La page (`buildPulsations`, après `buildPowers`) pose le **foyer** au-dessus de la position de la pulsation à la date de la surface (`positionAt(pl, time.now)`, `geoToScene`, sans hexagone de référence ; sinon au-dessus du premier élément du parcours) ; une pulsation à positions compte dans `datedItems` (streamgraph, étendue des dates, chemin spatio-temporel `buildTracks`) et `timeOff` utilise ses périodes (`presence`) au lieu de celles de ses pouvoirs ; l'animation est arrêtée à l'ouverture (`setPulse(false)`, non mémorisé). Elle dessine pour chaque pulsation un **éclair** : parcours = concaténation des parcours de ses pouvoirs triés par ordre successif (sinon ordre d'ajout), éléments consécutifs identiques fusionnés ; **foyer** cliquable (octaèdre lumineux de rayon `markerRadius`, à `markerLift` × hexSize au-dessus du premier élément ou de la grille, empilé si plusieurs pulsations y partent) ; un **saut** par élément : du foyer au premier élément à l'air libre, puis plus court chemin (Dijkstra, `tubePath`) le long des axes des tubes (à défaut de chemin : saut direct). Animation (`animatePulses`, horloge propre à chaque pulsation) : la tête avance à `pulseSpeed` hexagones par seconde (curseur **Vitesse** de la barre d'outils, 0,5 à 20, valeur initiale `speed`, `localStorage` `ecospace-pulse-speed`), éclair brisé (zigzag tous les `boltStep` × hexSize, écart `boltJitter` × longueur borné par le rayon du tube moins la gaine, renouvelé 25 fois par seconde), tube de rayon `boltRadius` dans une gaine 2,5 fois plus large, tête lumineuse (sphère `headRadius`, halo `haloSize`, lumière ponctuelle `lightIntensity` de portée `lightDistance`) ; extinction en `fade` s et éclat (`burstSize`) sur l'élément atteint, puis `pause` s au foyer. **Couleur** : `d3.interpolateTurbo((intensité + 100) / 200)` de l'intensité du pouvoir de l'élément visé (milieu de l'échelle si inconnue) ; foyer : intensité moyenne ; dégradé rappelé dans la barre d'outils (`#turbo-bar`). Une pulsation sans pouvoir dessiné n'a pas d'éclair. **Flux** : arc de Bézier quadratique (TubeGeometry, rayon `fluxRadius` × hexSize, hauteur max(`fluxLift` × longueur, 0,5 × hexSize)) d'un foyer à l'autre, flèche vers la pulsation la plus tardive (« Avant » inverse le sens, « Pendant » : trait double sans flèche), étiquette « ordre relatif · ordre successif », `particles` particules qui circulent. Sélection : par le foyer. Zoom depuis la liste : cadre tout le parcours. Menu : **lier → Pulsation** sur un tube ; sur un foyer, **lier → Pouvoir** et **lier → Flux** (dialogue `#dlg-power` réutilisé, `pulseDialog`) ; détails : foyer, parcours de l'éclair, pouvoirs et flux avec leur temporalité ; suppression : retrait de l'écosystème ou suppression dans Omeka S ; pas de duplication. Bouton **Pulsations** : arrêt ou reprise de l'animation (`localStorage` `ecospace-pulse`). Dans la liste des éléments, un flux est caché quand l'une de ses pulsations l'est. Durée d'un saut selon sa longueur : `hopEase` × ln(1 + longueur / (vitesse × `hopEase`)) — longueur / vitesse pour un saut court, croissance logarithmique au-delà, la vitesse apparente augmente donc avec la distance — au plus `maxHop` s (4 s : un saut de 116 km entre actants éloignés durait 48 min à 4 hex/s) ; départ et arrivée ralentis (accélération sinusoïdale). **Taille apparente minimale** : au-delà de `sizeRef` hexagones de la caméra (12), foyer, tête, éclair et éclats grossissent en proportion de la distance ; éclair, tête et éclats sont dessinés sans test de profondeur (`renderOrder` 50) et restent visibles dans une sphère d'actant ou derrière une boîte. **Suivi d'une pulsation** (rubrique Pulsations, `#pulse-follow`, `startFollow`, `followTick`) : la caméra vole vers la tête (30 hexagones), puis, à chaque image, la cible et la caméra se déplacent de la même quantité que la tête (calées sur elle pendant un saut, lissées au retour au foyer) : orientation et distance restent celles que l'utilisateur choisit (tourner, zoomer) ; l'information indique l'élément visé, son pouvoir et l'étape (« → HyperCard (Définir les sources) · étape 4 / 14 ») ; à l'arrivée sur chaque élément, **pause** de `followDwell` s (curseur **Pause** de la rubrique, 0 à 8 s, 2,5 par défaut, `localStorage` `ecospace-pulse-dwell`) : l'horloge de la pulsation s'arrête (`holdUntil`), la vue se recentre et zoome sur l'élément (`frameOf` : boîte englobante de ses objets — un physique précis, la bulle d'un concept ; actant : son fullerène) et l'information affiche « ⏸ titre (type) · étape · secondes restantes », puis la vue revient à la distance de suivi choisie ; bouton **⏸ Pause / ▶ Reprendre** (`#pulse-hold`, actif pendant le suivi : horloge et arrêt sur élément figés, caméra libre) ; **parcours** (`#pulse-route`, `renderRoute`, repliable) : la liste numérotée des éléments de la pulsation choisie (couleur et titre du pouvoir, type), étape en cours mise en évidence (`markRoute`) ; un clic sur une étape (`goToStep`) lance le suivi et amène l'éclair sur cet élément ; un autre déplacement de vue (vue d'ensemble, zoom sur un élément ou une cellule), Échap ou « Arrêter le suivi » l'arrêtent ; le suivi relance l'animation si elle était arrêtée.

**Légende** des formes et de la grille (`#legend`) : cachée par défaut, bouton **Légende** (état dans `localStorage` `ecospace-legend`).

**Liste des éléments** (bouton **Éléments**, panneau à droite de la scène, état mémorisé dans `localStorage` `ecospace-list`) : construite après chaque `buildItems` à partir des cibles de la scène (`collectEntries` : une entrée par élément avec tous ses objets 3D ; clé = item, `m:<actant>:<item>` pour une personne ou un agent, `pw:<item>` pour un pouvoir, `cr:<item>` pour un crible), groupée par type (ordre des formes de la configuration, puis crible) et en arbre contenant → contenu (physiques et concepts enfants ; enfants **repliés par défaut**, bouton ▸/▾ par parent avec leur nombre, dépliage gardé pendant la session par écosystème ; le filtre liste à plat toutes les correspondances), filtrable par titre (sans accents). Par ligne : case **afficher / cacher**, **zoom** (vol de caméra animé vers la boîte englobante, direction de vue conservée ; actant : son fullerène, sa sphère pouvant faire des kilomètres), **détails**, **modifier**, **dupliquer**, **supprimer** (mêmes fonctions et mêmes restrictions que le menu circulaire) ; case par type pour tout un type ; **Tout afficher**. Visibilité effective (`applyVisibility`) : élément caché, type caché, contenant caché (parent physique ou concept, actant d'une personne ou d'un agent), ou toutes les sphères d'une intériorité cachées ; un tube est caché si tous ses pouvoirs le sont ou si son élément d'extrémité l'est, un anneau de crible et une jonction suivent leurs pouvoirs ; les objets cachés ne se sélectionnent plus (`pick`). Les éléments cachés sont propres au navigateur (`localStorage` `ecospace-hidden-<eco>`), ni dans le fichier de l'espace ni dans Omeka S.

**Performances du chargement** : la vue lit les arbres des physiques en parallèle (`physNode` : image et enfants d'un nœud, puis frères, en même temps — un arbre de 47 physiques passe de 6,5 s à quelques allers-retours) ; les identifiants des propriétés (`propId`) et les formulaires des resource templates (`templateForm`, `templateCacheTtl`, 10 min) restent en mémoire (le formulaire des pulsations coûtait 2,4 s à chaque chargement). Espace 42 : réponse de `GET /api/ecospace/space` de 9,4 s à 1,4 s ; scène de 1,5 milliard de triangles (nanotubes) à 120 000, 300 appels de dessin à moins.

**Copie des positions dans Omeka S** (`ecospace.omekaMedia`) : chaque enregistrement du fichier de l'espace (`resultats/ecospace/<éco>.json` : grille, placements, emplacements des personnes et agents) programme, `delay` ms plus tard (les modifications rapprochées n'en font qu'un envoi), son dépôt comme **média de l'item écosystème** : fichier `ecospace-<éco>.json`, `dcterms:title` = `title`, `dcterms:identifier` = `identifierPrefix` + écosystème. Rien n'est envoyé si un média de même identifiant a la même empreinte (`o:sha256`) ; sinon le nouveau média est déposé puis les anciennes versions sont supprimées. Un échec est non bloquant (`⚠️` dans les journaux) ; l'état de la dernière copie (`omekaCopy` : `ok`, `media`, `error`, `pending`) est renvoyé avec l'espace et affiché dans la ligne d'information de la page (détail de l'erreur au survol). Si le fichier local est absent, `GET /api/ecospace/space` restaure l'espace depuis ce média. **Prérequis** : Omeka S doit accepter les fichiers JSON (type `application/json` et extension `json` dans Administration > Paramètres > Sécurité ; le type est déduit du contenu, un dépôt en `.txt` est aussi refusé).

**Fenêtre de progression** (`#dlg-busy`, `withBusy(titre, fn)`) : les opérations longues — chargement de l'espace, création de la grille, placement, liens entre concepts, détachement, duplication, modification, suppression — ouvrent une fenêtre modale (Échap inactif) qui liste leurs étapes, terminées (✓) ou en cours, avec la durée de chacune et la durée totale ; elle n'apparaît qu'au-delà de 300 ms. Chaque appel au serveur y ajoute une étape décrite (table `API_STEPS`), la construction de la scène 3D aussi (`setSpace`, asynchrone : la fenêtre est affichée avant ce calcul synchrone) ; `withBusy` est réentrant (une opération qui recharge l'espace garde une seule fenêtre).

**Menu circulaire** (celui d'EcoNetwork, sur l'hexagone ou l'élément cliqué — le plus proche de la caméra ; parmi des éléments de même famille traversés (boîtes imbriquées, concepts emboîtés, actant et ses personnes et agents), le plus profond ; un parent se sélectionne par sa marge ; le menu s'ouvre après le délai d'un double-clic ; un glisser fait tourner la vue ; un double-clic rapproche la vue de l'élément) :

| Action | Hexagone libre | Hexagone occupé |
|---|---|---|
| lier | second anneau : **seulement les éléments qui peuvent y être placés** — types de `econetwork.elementTemplateIds` dotés d'une forme, non ancrés (ni personne ni agent) et dont la couche est libre, plus le concept (sous la grille) ; les types sans forme ne sont pas affichés ; inactif si aucun (un physique demande aussi sa date de création, aujourd'hui par défaut, et son importance) ; titre autocomplété parmi les items de ce type (un élément de l'écosystème non placé est seulement placé ; un item déjà placé n'est pas proposé) ; sinon création (avec média facultatif) et rattachement à l'écosystème, puis placement | **seulement les liens prévus par le resource template de l'élément** (`/api/econetwork/linkable` : propriétés et templates acceptés, lus une fois par template et mis en cache ; « lier » est inactif quand on sait que le modèle n'en prévoit aucun) et qu'EcoSpace représente : actant → personne (`jdc:hasPerson`) et agent (`jdc:hasAgent`) ; physique → **physique enfant** (`parentTerm` vers un physique ; nouveau, avec date, importance et média, ou existant de l'écosystème ; un physique qui contient déjà le parent est refusé) ; concept → concept parent (`broaderTerm`), concept enfant (`narrowerTerm`), détacher ; personne, agent : aucun. Les routes `member`, `concept/relate` et `physique` (avec parent) refusent un lien que le modèle ne prévoit pas |
| dupliquer | — | demande le **nombre de copies** (1 à `maxDuplicates`) ; chaque copie de l'item (titre suivant libre, sans ses enfants) est placée sur l'hexagone le plus proche dont la couche est libre ; un physique enfant donne des frères dans le même parent |
| détails | coordonnées cube, distance au centre, géographie, position dans la scène, occupation par couche | iframe Omeka S (mandataire) et fiche, avec la position : actant, centroïde du fullerène et centre de la sphère ; physique, dates, importance, parent, enfants et hauteur à l'échelle courante |
| supprimer | — | retirer de l'espace (l'item reste élément de l'écosystème), retirer de l'écosystème, ou supprimer dans Omeka S (si aucun autre nœud ne l'utilise : un physique qui a des enfants est bloqué) ; physique enfant : **détacher** de son parent (retrait de la valeur `parentTerm`) ou supprimer dans Omeka S |
| modifier | — | formulaire du template |

Sur un **concept**, « lier » propose : **Concept parent** (nouveau ou existant ; il englobera le concept ; si celui-ci avait déjà un parent, le nouveau s'intercale entre les deux), **Concept enfant** (nouveau ou existant ; un concept existant quitte son parent actuel) et **Détacher** (le concept redevient une racine). Un concept repris hors de l'espace y est ajouté ; les cycles sont refusés (l'autocomplétion grise le concept lui-même et, selon le cas, ses descendants ou ses ancêtres).

| Route | Rôle |
|---|---|
| `GET /ecospace` | page |
| `GET /api/ecospace/space?eco=` | `{ exists: false, grid }` ou l'espace : `grid`, `hexes` (`q, r, s, x, z, geo`), `placements` (avec `title`, `templateId`, `missing`, `geo` ; actant : `sub` (sous-grille : `size`, `orientation`, `rings`, `slots`) ; actant : `sphereRadius` et `interior` (concepts de son intériorité) ; concept : `inActant`, `hosts` (actants hôtes) ; `powers` (pouvoirs : `item`, `title`, `type`, `typeLabel`, `intensity`, `color`, `interior`, `steps` = `{ name, key, term, item, title, members: [{ item, title, attach }] }`) ; `powerTypes` (`id`, `label`, `longLabel`, `sequence` avec `key` et `templateId`) ; personne / agent (ajoutés à la liste) : `actant`, `anchorTerm`, `sub` (sous-hexagone), `subSize`, `x, y, z, radius`, `sphereRadius` ; concept : géométrie calculée `x, y, z, radius, length`, `label` (titre affiché), `chars`, `labelY`, `labelZ`, `level`, `parent`, `narrower` (enfants), `related` ; physique : `tree` = `{ id, title, created, createdFromRecord, modified, importance, image, depth, children }`, `image` = identifiant du premier média image ou `null`), `shapes`, `timeScale`, `maxDuplicates`, `now`, `omekaFrame` |
| `GET /api/ecospace/image?media=` | image d'un média (vignette `large` d'Omeka S, sinon l'original), relayée par le serveur pour que WebGL la lise depuis la même origine ; refusée si ce n'est pas une image ou si son adresse n'est pas sur l'hôte de `OMKS_API_URL` |
| `POST /api/ecospace/space` | `{ eco }` : crée l'espace (repris s'il existe) ; l'item doit être du template des écosystèmes |
| `POST /api/ecospace/place` | `{ eco, item, q, r }` ou `{ eco, item, near: { q, r } }` (concept : ajouté à l'espace, sa bulle est calculée) (hexagone le plus proche dont la couche est libre) ; l'item doit avoir une forme ; hexagone dans la grille et libre dans la couche de la forme ; un élément déjà placé est déplacé |
| `POST /api/ecospace/physique` | `{ eco, parent?, title, created?, importance? }` (nouveau physique, rattaché à l'écosystème et, s'il y a un parent, enfant de celui-ci ; repris s'il existe avec ce titre et ce parent) ou `{ eco, parent, existing }` (physique existant ajouté comme enfant ; cycles refusés) |
| `POST /api/ecospace/member` | `{ eco, actant, shape: "personne" \| "agent", title }` ou `{ …, existing }` : personne ou agent créé (rattaché à l'écosystème) ou repris (même template), ajouté aux valeurs `anchorTerm` de l'actant placé s'il n'y est pas ; renvoie `{ id, created }` |
| `POST /api/ecospace/power` | `{ eco, type, intensity, title?, steps }` : un maillon par élément de la séquence du type, chacun `{ existing }`, `{ title }` ou une liste (relations multiples) ; physiques (racines ou boîtes intérieures) et actants existants et placés ; cribles et concepts existants ou créés (repris par titre), rattachés à l'écosystème, concepts ajoutés à l'espace ; liens annotés par leur maillon (`roleTerm`) ; contrôlé par `checkPower` (au moins un élément par maillon) ; `{ id, title }` |
| `POST /api/ecospace/power/link` | `{ eco, power, step, existing \| title, attach? }` : élément ajouté au maillon `step` d'un pouvoir (relation multiple, lien annoté) ; `attach` = `{ seg, j, k }` hexagone du tube où il se branche, mémorisé dans `powerLinks` ; `{ id, title, added }` |
| `POST /api/ecospace/pulsation` | `{ eco, power, existing \| title }` : pulsation existentielle créée (template de la forme `pulse`, rattachée à l'écosystème) ou reprise parmi celles de l'écosystème ; le pouvoir (dessiné dans l'espace) y est ajouté par `powerTerm`, annoté par son ordre successif ; `{ id, title, created, added }` |
| `GET /api/ecotext/vocab` | rubriques et phrases modèles (`ecotext.stages`), types de pouvoir et séquences, titres des items existants par type (templates de `omekaForms.templates`, cache `vocabCacheTtl`) |
| `POST /api/ecotext/suggest` | `{ stage, sections }` : suite de la rubrique proposée par `eco-suggest-agent` (texte brut nettoyé), coût de l'appel |
| `GET /api/ecotext/pipeline` | `?item=` : journal de génération de l'item (valeurs de `jdc:pipeline` regroupées par génération, annotations lues selon `ecotext.pipeline.annotation`) |
| `POST /api/ecotext/pipeline` | `{ eco, run, sections, steps, validated, report }` : journal de la génération écrit dans `jdc:pipeline` de l'item de l'écosystème (valeurs annotées, template 17) |
| `POST /api/ecotext/model` | `{ sections }` : modélisation par `eco-model-agent`, complétée et rapprochée des items existants (`completeModel`), durée et coût |
| `POST /api/ecospace/pulsation/flux` | `{ eco, pulsation, to, relative?, order? }` : flux `fluxTerm` d'une pulsation vers une autre de l'écosystème, annoté par sa temporalité (`relativeTerm` : item des temporalités relatives — Après, Avant, Pendant ; `successiveTerm` : entier) ; un flux existant vers la même pulsation est remplacé ; `{ from, to }` |
| `POST /api/ecospace/publish` | `{ eco }` : copie immédiate du fichier de l'espace dans Omeka S (média de l'écosystème) ; `{ id, created }` (`created: false` si le contenu est inchangé) |
| `POST /api/ecospace/origin` | `{ eco, lon, lat, alt? }` : origine géographique de la grille (centre de l'hexagone 0, 0 ; longitude −180 à 180, latitude −90 à 90, altitude conservée si absente) ; les actants et physiques gardent leur position géographique de référence et changent d'hexagone (grille à niveaux) ; renvoie l'espace et `moved` (éléments qui changent d'hexagone) |
| `POST /api/ecospace/position` | `{ eco, item, lon, lat, alt?, at?, address?, index? }` : actant ou physique placé, ou pulsation de l'écosystème ; `address` gardée avec le point (chaîne vide : retirée) ; nouveau point de l'historique (`at` ISO, défaut maintenant ; événement « déplacé ») ou point `index` corrigé ; position de référence = point le plus récent de l'écosystème, hexagones recalculés ; renvoie l'espace et `moved` |
| `POST /api/ecospace/position/delete` | `{ eco, item, index }` : retire un point de l'historique (au moins une position doit rester dans l'écosystème) ; mêmes recalculs |
| `GET /api/ecospace/geo` | `?item=` (`&eco=` : positions dans cet écosystème seulement) : historique des positions de l'item (GeoJSON, `application/geo+json`), avec `omeka` (état de la dernière copie dans Omeka S) |
| `POST /api/ecospace/unplace` | `{ eco, item }` : libère l'hexagone ; un concept retiré garde ses relations dans Omeka S, ses enfants deviennent des racines de l'espace |
| `POST /api/ecospace/concept/relate` | `{ eco, item, as: "parent" \| "child", title }` ou `{ …, existing }` : concept parent ou enfant d'un concept placé, créé (rattaché à l'écosystème) ou repris, ajouté à l'espace ; relations écrites (`setParent` : relations gérées remplacées, nouvelles annotées par l'écosystème) ; parent intercalé si le concept en avait déjà un ; cycle refusé ; renvoie `{ id, created, changes }` (`+ id terme id` / `− id terme id`) |
| `POST /api/ecospace/concept/detach` | `{ eco, item }` : retire le parent du concept (relations gérées avec les concepts de l'espace) ; renvoie l'espace et `changes` |

## 7. Configuration

| | ontoÉthique |
|---|---|
| Défauts | `src/config/ontoethique.ts` (`defaultOntoEthiqueConfig`) ; socle : `src/config/index.ts` |
| Surcharges | `ontoethique.config.json` (`ONTOETHIQUE_CONFIG_FILE`) ; socle : `workflow.config.json` |
| Configuration effective | `ontoEthiqueConfig` ; socle : `workflowConfig` |

Les modifications faites dans l'interface sont enregistrées dans le fichier de surcharges (seules les différences). Les tableaux sont remplacés en bloc ; les chemins `kappa.codes`, `annotationPositions`, `omeka.vocabs` et `costs.models` aussi (`REPLACED_PATHS`).

| Clé | Rôle |
|---|---|
| `workflowId` | `onto-ethique` : titre et repérage des items de configuration |
| `input.zoteroCollection` | collection des traces de l'activité |
| `activity.title`, `activity.description` | activité située évaluée |
| `models.analytics`, `models.fast` | modèles Albert (rôles analytique et rapide de l'onglet Workflow) |
| `analysis.mergeDuplicates` | fusion des documents en double |
| `analysis.maxDocuments`, `maxCharsPerDocument`, `existencesCharsPerDocument`, `maxAnnotationsPerDocument`, `maxExistences`, `concurrency` | traces évaluées, taille des extraits (évaluateur, ontologue), annotations transmises, existences, appels simultanés |
| `kinds` | genres d'existences (`id`, `label`, `resonance`) |
| `dimensions` | métamodèle : `id`, `label`, `spinoza`, `metric`, `pretopology`, `analogy`, `instruction` |
| `powers` | grille des affects : `id` (identifiants fixes : `discerner`, `raisonner`, `resonner`, `agir`), `label`, `semiosis`, `chain`, états `negative` / `neutral` / `positive` |
| `values` | valeurs tardiennes (`utilite`, `verite`, `beaute`) et force (Désir, Croyance) |
| `rules.noResonanceScore`, `rules.humanSovereignty` | barrière numérique, souveraineté de l'expertise humaine |
| `selfEvaluation.enabled`, `selfEvaluation.tagPattern` | auto-évaluations par marqueurs Zotero |
| `symbiosis.lowThreshold`, `highThreshold`, `indignationThreshold` | seuils des alertes |
| `spiral.pointsPerTurn`, `stepsPerPulsation`, `flaredRatio`, `slenderRatio`, `tubeGrowth` | géométrie et formes de la spirale |
| `discourse.maxPulsations` | pulsations transmises à l'ADA |
| `ontology.baseUri`, `ontology.dataUri` | espaces de noms de l'export LOD |
| `omekaForms.templates` | templates du processus de modélisation, dans l'ordre (`key`, `label`, `templateId`) |
| `omekaForms.powerTemplateId`, `intensity`, `powerTypeTerm`, `powerTypes` | pouvoirs existentiels : intensité (-100 à 100), propriété du type, types et séquences attendues |
| `omekaForms.searchLimit` | résultats de la recherche d'un item lié |
| `econetwork.ecoTemplateId`, `ecoProperty`, `elementTemplateIds`, `maxLinked`, `omekaProxy`, `maxMediaMB` | IHM EcoNetwork : template des écosystèmes (14), propriété de rattachement (`jdc:hasEcoCon`), types proposés par « lier » depuis l'écosystème, taille maximale du réseau, mandataire de l'interface Omeka S pour l'iframe « détails » (true), taille maximale d'un fichier déposé comme média (50 Mo) |
| `ecospace.dir`, `grid` (`radius`, `hexSize`, `orientation`, `origin`, `maxRings`, `lod`), `geoHistory` (`enabled`, `shapes`, `dir`, `omekaMedia`, `delay`, `retryDelay`, `identifierPrefix`, `title`, `property`, `geoType`, `annotation` : `title`, `place`, `geo`, `time`), `shapes` (dont `layer`), `timeScale` (`height`, `minHeight`, `maxHeight`, `mode`), `maxDuplicates`, `templateCacheTtl`, `omekaMedia` (`enabled`, `delay`, `identifierPrefix`, `title`), `map` (`tiles`, `attribution`, `geocoder`, `zoom`, `searchLimit`) | IHM EcoSpace : dossier des espaces (`resultats/ecospace`), grille d'un nouvel espace (6 anneaux, hexagones de 10 m, pointe en haut, origine Université Paris 8), formes par template (actant : fullerène + sphère, de même rayon que l'hexagone, sous-grille `subRings`, `subMargin` ; personne et agent : petits fullerènes + sphères sur la sous-grille de leur actant, `anchor`, `anchorTerm`, `memberRatio`, `sphereRatio` ; pouvoir : cylindres aux hexagones calculés, `power`, `tubeRadius`, `lattice`, `jointRatio`, `cribleRatio`, `cribleColor`, `interior`, `interiorPadding`, `roleTerm`, `colors` ; pulsation : éclair lumineux qui parcourt les éléments de ses pouvoirs par l'intérieur des tubes et flux fléchés, `pulse`, `powerTerm`, `fluxTerm`, `relativeTerm`, `successiveTerm`, `speed`, `maxHop`, `hopEase`, `sizeRef`, `pause`, `fade`, `boltStep`, `boltJitter`, `boltRadius`, `markerLift`, `markerRadius`, `headRadius`, `haloSize`, `burstSize`, `lightIntensity`, `lightDistance` (couleur : échelle turbo), `fluxColor`, `fluxRadius`, `fluxLift`, `particles` ; physique : boîtes temporelles imbriquées ; concept : bulles horizontales sous la grille, dimensionnées par leur titre ou leurs enfants et réparties de façon équilibrée (`charWidth`, `labelHeight`, `leafRadius`, `padding`, `spacing`, `topDepth`, `maxLabel`), hiérarchie `skos:narrower` / `skos:broader` ; couches `dessous` et `dessus`), échelle temporelle des physiques (60 m, de 5 à 1 000 m, linéaire), copies par duplication bornées (`maxDuplicates`), formulaires des resource templates gardés en mémoire 10 min (`templateCacheTtl`), copie des positions dans Omeka S comme média de l'écosystème (envoi 3 s après le dernier enregistrement) |
| `ecotext.stages` (`id`, `label`, `help`, `patterns`), `pipeline` (`property`, `maxChars`, `annotation` : `title`, `description`, `prompt`, `response`, `model`, `cost`), `suggestMaxWords`, `maxElements`, `vocabCacheTtl`, `minChars`, `maxSuggestions` | description textuelle d'un nouvel écosystème : rubriques de la saisie guidée et leurs phrases modèles, longueur de la suite proposée, éléments par type, cache des titres existants, autocomplétion |
| `outputDir` | `resultats/ontoethique` |

Socle (`workflow.config.json`) : `models.provider`, `zotero.automaticTags`, `extraction.*`, `annotationPositions`, `costs.*` (devise, électricité, carbone, matériel, tarifs par modèle), `omeka.*` (vocabulaires, classes, propriétés).

## 8. API de l'interface

Routes communes :

| Méthode et route | Rôle |
|---|---|
| `GET /` | page de l'application |
| `GET /parametres` | page des connexions (`settings.html`) |
| `GET`, `POST /api/settings` | connexions (secrets masqués, valeurs héritées signalées) et configuration de l'application |
| `POST /api/check` | teste Albert, Zotero et Omeka S |
| `GET`, `POST /api/zotero/collections` | collections de la bibliothèque enregistrée ou en cours de saisie |
| `GET /api/albert/models` | modèles disponibles |
| `GET /api/workflow`, `POST /api/workflow/agent` | diagramme, agents, coût estimé ; textes et modèle d'un agent |
| `GET /api/apps` | application du serveur et adresses des applications |
| `POST /api/run`, `POST /api/run/stop`, `GET /api/run`, `GET /api/run/events` | lancer, arrêter, état, journal (SSE) |
| `GET /docs/…` | documentation HTML |

Routes propres à ontoÉthique (`src/ui/ontoethiqueRoutes.ts`, 404 sur un autre serveur). Les identifiants d'évaluation sont validés (`[\w-]{1,80}`) et seuls les fichiers de la liste `ONTO_FILES` sont servis :

| Méthode et route | Rôle |
|---|---|
| `GET`, `POST /api/ontoethique/settings` | configuration de l'application |
| `GET /api/ontoethique/runs` | évaluations : archive locale (`resultats/ontoethique/analyses/<run>/analyse.json`) et items de configuration Omeka S (`workflowId = onto-ethique`) |
| `GET /api/ontoethique/results?run=` | fichiers d'une évaluation (archive locale, sinon médias Omeka S) |
| `GET /api/ontoethique/file?run=&name=&raw=` | contenu d'un fichier (`raw=1` : page HTML telle quelle) |
| `GET /api/ontoethique/model?run=` | modèle (`modele.json`) |
| `POST /api/ontoethique/manual` | `{ title, description }` ou `{ example: true }` : évaluation manuelle (identifiant `manuel-<date>-<aléa>`) |
| `POST /api/ontoethique/activity` | `{ run, activity }` |
| `POST /api/ontoethique/pulsation` | `{ run, pulsation, author?, note?, motivation? }` : ajout (identifiant attribué) ou modification |
| `POST /api/ontoethique/pulsation/delete` | `{ run, id }` |
| `POST /api/ontoethique/existence` | `{ run, existence }` : ajout ou modification |
| `POST /api/ontoethique/existence/delete` | `{ run, id }` : l'existence et ses pulsations |
| `POST /api/ontoethique/synthesis` | `{ run }` : nouvelle synthèse de l'ADA à partir du modèle corrigé, avec son coût |
| `POST /api/ontoethique/omeka` | `{ run }` : dépôt des fichiers dans l'item de configuration (créé pour une évaluation manuelle) |
| `GET /api/ontoethique/forms` | templates du processus (`omekaForms.templates`) |
| `GET /api/ontoethique/form?template=` | formulaire d'un template (avec intensité et types pour les pouvoirs) |
| `GET /api/ontoethique/form/search?template=&term=&q=` | recherche d'un item à lier, restreinte par le `resource_query` du template : titre contenant la saisie (partie de mot ; accents et casse ignorés par la base), triés par titre — et non recherche plein texte, qui n'accepte que des mots entiers |
| `GET /api/ontoethique/form/items?template=` | items existants du template |
| `POST /api/ontoethique/form/item` | `{ template, values }` : création contrôlée ; un item de même titre et de même template n'est pas recréé (`created: false`) |
| `POST /api/ontoethique/runs/delete` | `{ runId, omeka }` : Omeka S d'abord, puis archive locale |

Chaque modification charge le modèle (recopié depuis Omeka S s'il n'existe que là), l'applique, ajoute une **révision**, puis `writeModelFiles` réapplique les règles, recalcule les indicateurs et réécrit `modele.json`, `matrice_affects.csv`, le Turtle, le JSON-LD et les spirales ; la réponse est le modèle à jour.

## 9. Étendre le projet

- **Ajouter une application** : skill `nouvelle-application` (`.claude/skills/`) : configuration, étapes, workflow, agents, lanceur, rapport, entrée `APPS` du serveur, routes, page, `package.json`, `.claude/launch.json`, `.vscode/launch.json`, Docker, documentation.
- **Ajouter ou modifier un agent** : skill `agent-albert`. **Brancher une API** : skill `connecteur-api`. **Enregistrer dans Omeka S** : skill `persistance-omeka`.
- **Ajouter un pouvoir, une dimension, un genre** : les tableaux `powers`, `dimensions`, `kinds` de la configuration ; les schémas des agents, l'export LOD et la page s'y adaptent. La spirale utilise les identifiants `discerner`, `raisonner`, `resonner`, `agir`.

## 10. Documentation et conteneur

- `npm run docs` convertit `docs/*.md` en `docs/html/*.html` (servi sur `/docs/`).
- `Dockerfile` : image `node:22-bookworm-slim`, code dans `/app`, données dans le volume `/data` ; commandes `workflow-ui` (serveur de l'application `WORKFLOW_APP`) et `workflow-ontoethique` (ligne de commande).
- `docker-compose.yml` : service `ontoethique` (7280, publié sur `127.0.0.1`), volume `./data:/data`, `host.docker.internal` pour un Omeka S local.
- `.vscode/launch.json` : débogage du workflow, du serveur sur 7290 (avec le processus enfant) et du fichier courant.

## 11. Limites connues

- `tsc --noEmit` signale des erreurs liées à la configuration TypeScript (CommonJS avec `verbatimModuleSyntax`) et aux types Mastra (étapes sans schéma) ; l'exécution par tsx n'est pas affectée.
- Les scores proposés par les agents sont des hypothèses de lecture : la matrice est faite pour être corrigée et validée par les participants (onglet Matrice) ; la synthèse distingue les évaluations validées.
- La complexité ontologique, l'indice de symbiose et la géométrie de la spirale sont des opérationnalisations proposées du métamodèle, réglables dans la configuration.
- Le workflow dépose seulement les fichiers de l'évaluation : les existences et pulsations qu'il produit ne deviennent pas des items Omeka S (la saisie par formulaire crée, elle, des items).
- Les formulaires créent des items sans les modifier ensuite (modification dans Omeka S). Chargement d'environ 3 s pour les pouvoirs : les listes sont relues à chaque ouverture.
- Les extensions `ttl`, `jsonld`, `csv`, `md`, `html` et `json` doivent être autorisées dans Omeka S (sinon dépôt en `.txt`).

## 12. Workflow ontoÉthique

```mermaid
flowchart TD
    IN([zoteroCollection,<br/>activité située]) --> F[fetch-literature<br/>fetchZoteroData : documents,<br/>annotations, notes → Omeka S]
    F --> E[existences<br/>existencesAgent + auto-évaluations<br/>4 dimensions, cribles]
    E --> P[pulsations<br/>affectsAgent par trace<br/>4 pouvoirs, sémiose, valeurs<br/>applyRules : barrière numérique]
    P --> M[metrics<br/>pouvoirs, symbiose, alertes,<br/>complexité, spirales, triplets RDF]
    M --> D[discourse<br/>adaAgent : synthèse]
    D --> OUT([modele.json, matrice CSV, Turtle, JSON-LD,<br/>spirales, synthèse, rapport → Omeka S])
    OUT --> H[page : corrections et validations humaines<br/>→ recalcul, révisions, nouvelle synthèse]
```

| Élément | Rôle |
|---|---|
| `fetch-literature` | étape commune : collection, annotations (auteur, couleur, date, marqueurs), notes, enregistrement dans Omeka S ; `mergeDuplicates` selon `analysis.mergeDuplicates` |
| `existences` (`existencesStep.ts`) | documents retenus (`selectDocuments` : texte ou annotations, `maxDocuments`) ; auto-évaluations ; un appel à l'ontologue avec tous les documents (`existencesCharsPerDocument`) ; genres normalisés ; participants auto-évalués fusionnés par identifiant ou nom ; échec si aucune existence |
| `pulsations` (`pulsationsStep.ts`) | un appel à l'évaluateur par document (`concurrency` simultanés) ; existence résolue par identifiant ou nom ; scores `null` écartés ; auto-évaluations placées avant les pulsations de l'agent pour chaque document ; numérotation `p1…`, rangs par existence ; `applyRules` |
| `metrics` (`metricsStep.ts`) | `computeMetrics` et nombre de triplets RDF |
| `discourse` (`discourseStep.ts`) | `adaSynthesis` ; non bloquante (avertissement si Albert est indisponible) |
| `src/runners/ontoethique.ts` | refus sans collection ; item de configuration ; exécution ; `writeModelFiles` dans `resultats/ontoethique/analyses/<runId>/` (+ copie à la racine de `outputDir`) ; `synthese_ada.md`, `rapport_ontoethique.md`, `analyse.json` ; coût ; statut et médias Omeka S |

Fichiers d'une évaluation : `modele.json`, `matrice_affects.csv`, `modele_onto_ethique.ttl`, `modele_onto_ethique.jsonld`, `spirales_pappus.html` (page autonome Plotly), `synthese_ada.md`, `rapport_ontoethique.md` (exécutions du workflow), `analyse.json` (description : mode, statut, dates, activité, collection, item de configuration, tokens, coût, totaux, symbiose, configuration).

### Un serveur par application

| | ontoÉthique (`ontoethique`) |
|---|---|
| Lancement | `npm run ui:ontoethique` (ou `npm run ui`) |
| Port / adresse d'écoute | `ONTOETHIQUE_PORT` (7280) / `ONTOETHIQUE_HOST` (ou `HOST`) |
| Connexions | `.env` surchargé par `.env.ontoethique` (`ONTOETHIQUE_ENV_FILE`) |
| Configuration | `ontoethique.config.json` (+ `workflow.config.json` pour le socle) |
| Workflow lancé | `src/runners/ontoethique.ts` |
| Page | `ontoethique.html` |
