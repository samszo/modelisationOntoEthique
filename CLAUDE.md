# CLAUDE.md

Écosystème d'agents IA pour la modélisation onto-éthique des existences informationnelles (Laboratoire Paragraphe, Université Paris 8). Le socle est repris de `ecosysteme-agents-recherche` (sans ses applications) ; chaque **application** s'y ajoute : chacune = un workflow Mastra + un lanceur + une page web + un serveur HTTP sur son propre port. Sources dans **Zotero**, modèles de l'**API Albert** (compatible OpenAI), résultats archivés dans **Omeka S**.

La documentation de référence est `docs/technique.md` (architecture, modèle de données, API, configuration). La lire avant toute modification structurelle et **la tenir à jour** à chaque ajout (étape, agent, route, clé de configuration, application).

## Commandes

```bash
npm ci                    # Node.js 22+
npm run ui:ontoethique    # ontoÉthique   http://127.0.0.1:7280   (npm run ui : idem)
npm run ontoethique       # workflow en ligne de commande (configuration enregistrée) ; npm start : idem
npm run docs              # docs/*.md → docs/html/*.html (servi sur /docs/)
docker compose up -d --build   # un service par application, volume ./data
```

- Exécution par **tsx**, pas de build. Il n'y a **pas de suite de tests** (`npm test` échoue volontairement).
- `tsc --noEmit` signale des erreurs connues (CommonJS + `verbatimModuleSyntax`, types Mastra) : ne pas chercher à les corriger toutes, ne pas s'en servir comme critère de validation. Vérifier plutôt en lançant le serveur (`.claude/launch.json` : configurations `ui-ontoethique` et `ui-ontoethique-test` sur 7281) et en exerçant les routes.
- Secrets dans `.env` (+ `.env.<app>` qui le surcharge). Ne jamais les committer ni les afficher. Les fichiers `*.config.json`, `agents.config.json`, `resultats/`, `data/` sont des données locales ignorées par git.


## Architecture (à respecter)

```
src/
├── agents/        un fichier par agent Mastra ; ask.ts (askAgent) ; overrides.ts (textes/modèles modifiables)
├── config/        defaultXxxConfig par application + store.ts (fusion avec *.config.json) + models.ts (Albert)
├── lib/<domaine>/ clients et fonctions pures : albert, zotero, omeka, extraction, analysis, rag, metrics, visualization…
├── tools/         outils Mastra uniquement (new Tool({ name, description, schema, execute })), ré-exportés par index.ts
├── workflow/
│   ├── <app>Workflow.ts      assemblage createWorkflow().then().parallel().commit()
│   ├── steps/<app>/ et steps/common/   une étape par fichier (createStep)
│   ├── reports/              rapports markdown de fin d'exécution
│   ├── runs/                 saveWorkflowConfig, importSynthesis (médias Omeka), history
│   └── diagrams.ts           AGENTS + DIAGRAMS (onglet Workflow) — à synchroniser avec les .then()/.parallel()
├── runners/<app>.ts          lancement : item Omeka, run, fichiers, coût, archive, médias
└── ui/
    ├── server.ts             UN serveur par application (argument ou WORKFLOW_APP), node:http sans framework
    ├── <app>Routes.ts        routes propres à une application quand elles sont nombreuses
    └── public/               <app>.html (HTML + JS module inline, sans build), settings.html commun, workflowDiagram.js
```

Flux d'une exécution : page → `POST /api/run` → le serveur **spawn** `tsx src/runners/<app>.ts` (config et `.env` relus à chaque lancement) → logs diffusés en **SSE** (`/api/run/events`) → le lanceur écrit dans `resultats/<app>/` et dans Omeka S.

## Conventions de code

- **Langue** : code, commentaires, logs, interface, docs et messages de commit en **français** (commits au format `feat: …` / `fix(scope): …`). Identifiants en anglais ou français selon le module voisin.
- **Commentaires** : une ligne en tête de fichier qui dit son rôle ; commentaires courts sur le *pourquoi* au-dessus des blocs non évidents. Pas de JSDoc verbeux.
- **Logs** : `console.log` avec emoji de statut (`🚀`, `🧠 Agent : …`, `📤 [OMEKA] …`, `⚠️`, `❌ Le workflow a échoué` — chaîne lue par le serveur pour détecter l'échec, `✅`).
- **Étapes** : les outils sont appelés **directement** (`outil.execute({ data })`), les données brutes ne passent jamais par un modèle. Après `.parallel([...])`, l'étape suivante reçoit `{ "<id>": sortie }` ; sinon la sortie précédente ; `getStepResult("<id>")` pour une étape antérieure. Étapes sans `inputSchema`/`outputSchema` (d'où les `as any`).
- **Agents** : instructions par défaut exportées (`XXX_INSTRUCTIONS`, et `XXX_PROMPT` si gabarit à `{{variables}}`), passées via `overridable(id, défaut)` et `overridableModel(id, …)` ; chaque agent est déclaré dans `AGENTS` de `diagrams.ts`. Voir le skill `agent-albert`.
- **Coût** : **tout** appel modèle passe par `recordUsage(source, modèle, usage)` (fait automatiquement par `askAgent`). La source contient l'étiquette `(nomAgent)` = `usageTag`.
- **Configuration** : tout paramètre réglable va dans `defaultXxxConfig` avec un commentaire ; jamais de constante magique dans une étape. `mergeConfig` remplace les tableaux en bloc et fusionne les objets clé par clé ; un objet-dictionnaire dont on doit pouvoir retirer des clés va dans `REPLACED_PATHS` (`src/config/store.ts`).
- **Erreurs non bloquantes** : Omeka indisponible, média refusé, etc. → `try/catch` + `console.warn("⚠️ …", e.message)` ; le workflow continue. Seule une erreur qui rend le résultat faux doit faire échouer l'étape.
- **Sécurité serveur** : identifiants validés par regex (`/^[\w-]{1,80}$/`), fichiers servis par liste blanche, écoute sur `127.0.0.1` par défaut, URL externes vérifiées (pas d'adresse privée). Routes propres à une app déclarées dans `APP_ONLY` (404 ailleurs).
- **Pages** : HTML autonome, CSS en variables (`--accent` par application, thème sombre), JS module inline, `fetch` vers `/api/...`, bibliothèques par CDN versionné. Lien ⚙ vers `/parametres`, liens vers les autres apps via `GET /api/apps`.
- **Idempotence** : avant de créer dans Omeka/Albert/Zotero, chercher l'existant (identifiant stable, `dcterms:identifier`, empreinte SHA-1).

## Skills du projet (`.claude/skills/`)

- `nouvelle-application` — créer une nouvelle application/workflow sur le modèle (checklist complète de tous les points de branchement + gabarits).
- `agent-albert` — ajouter ou modifier un agent (instructions, gabarit de demande, sortie structurée, coût, onglet Workflow).
- `connecteur-api` — brancher une nouvelle API externe (client `src/lib/`, champs de connexion, test de connexion, page Paramètres).
- `persistance-omeka` — enregistrer une exécution et ses résultats dans Omeka S, archives locales, coût et historique.

## En cours

Une application : **ontoÉthique** (`ontoethique`, workflow `onto-ethique`, port 7280) — protocole de mesure des fluctuations de l'article « Le tournant ontologique dans les humanités numériques » : existences et quatre dimensions, grille des affects (quatre pouvoirs, -100 à +100, triplets de sémiose, valeurs tardiennes), barrière numérique, symbiose et alertes, spirales de Pappus, synthèse de l'ADA, corrections humaines tracées, export Turtle / JSON-LD. Fonctions pures dans `src/lib/ontoethique/` (partagées par le workflow et les routes : toute modification recalcule via `writeModelFiles`). Pistes : `README.md` (section TODO).
