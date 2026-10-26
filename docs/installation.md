# Documentation d'installation

## 1. Prérequis

- **Node.js 22+** et npm (installation locale), ou **Docker** et Docker Compose.
- Une clé de l'**API Albert** (modèles de langage).
- Une clé d'API **Zotero** (lecture de la bibliothèque ou du groupe).
- Une instance **Omeka S** avec une clé d'API (rôle Auteur au moins) — facultative pour une évaluation manuelle, nécessaire à l'archivage.

## 2. Variables d'environnement

Copier `.env.example` en `.env`, ou renseigner les connexions depuis la page **⚙ Paramètres** de l'interface (elle écrit `.env.ontoethique`, qui surcharge `.env`).

| Variable | Rôle |
|---|---|
| `ALBERT_API_KEY` | clé de l'API Albert |
| `ZOTERO_API_KEY`, `ZOTERO_USER_ID`, `ZOTERO_GROUP_ID` | bibliothèque Zotero (groupe facultatif) |
| `OMKS_API_URL`, `OMKS_KEY_IDENTITY`, `OMKS_KEY_CREDENTIAL` | API Omeka S |
| `ONTOETHIQUE_PORT`, `ONTOETHIQUE_HOST`, `ONTOETHIQUE_URL` | port (7280), adresse d'écoute (127.0.0.1), adresse publique |
| `ONTOETHIQUE_ENV_FILE`, `ONTOETHIQUE_CONFIG_FILE`, `AGENTS_CONFIG_FILE`, `WORKFLOW_CONFIG_FILE`, `USAGE_HISTORY_FILE` | chemins des fichiers de connexion, de configuration et d'historique |

Ces fichiers contiennent des secrets : ils sont exclus de git et de l'image Docker.

## 3. Installation locale

```bash
npm ci
```

```bash
npm run ui:ontoethique
```

Ouvrir http://127.0.0.1:7280. Le workflow peut aussi être lancé en ligne de commande avec la configuration enregistrée :

```bash
npm run ontoethique
```

La documentation HTML se régénère avec `npm run docs` (servie sur `/docs/`).

**Déboguer avec Visual Studio Code** : configurations « Workflow : ontoÉthique » et « Interface : ontoÉthique (7290) » (`.vscode/launch.json`) ; le workflow lancé depuis l'interface est suivi en processus enfant.

## 4. Installation Docker

```bash
docker compose up -d --build
```

Le service `ontoethique` écoute sur http://127.0.0.1:7280 (publié seulement sur la machine hôte). Les données (`.env`, `.env.ontoethique`, fichiers de configuration, `resultats/`) sont dans `./data`. Un Omeka S installé sur la machine hôte (`http://localhost/...`) est joint par `host.docker.internal`. Commande en ligne : `docker compose exec ontoethique workflow-ontoethique`.

## 5. Préparer Omeka S

| Préfixe | Usage | Installation |
|---|---|---|
| `dcterms` | métadonnées de tous les items | fourni avec Omeka S |
| `bibo` | classes des documents | fourni avec Omeka S |
| `skos` | `skos:Concept` (marqueurs des annotations) | import (Admin › Vocabulaires) |
| `oa` | `oa:Annotation` | module **Annotate** ou import de `http://www.w3.org/ns/oa#` |
| `curation` | `curation:status`, `curation:data`, `curation:access`… | module **Curation** |

Dans *Admin › Paramètres › Sécurité*, autoriser si besoin :

| Extension | Type MIME | Fichiers |
|---|---|---|
| `md` | `text/markdown`, `text/plain` | rapport, synthèse |
| `json` | `application/json` | modèle onto-éthique |
| `jsonld` | `application/ld+json` | modèle (JSON-LD) |
| `ttl` | `text/turtle` | modèle (Turtle) |
| `csv` | `text/csv` | matrice des affects |
| `html` | `text/html` | spirales de Pappus |

Une extension refusée n'interrompt rien : le fichier est déposé en `.txt` (format d'origine dans `dcterms:format`), ou reste disponible localement.

## 6. Vérifier l'installation

1. Ouvrir http://127.0.0.1:7280, **⚙ Paramètres › Enregistrer et tester les connexions** : Albert, Zotero et Omeka S en vert.
2. Onglet **Activité › Charger l'exemple de l'article** : l'onglet Diagrammes affiche trois spirales et une alerte de misère symbolique (aucune connexion requise).
3. Choisir une petite collection, **Enregistrer et modéliser** : le journal se termine par « ✅ Modélisation onto-éthique terminée. », le rapport indique une consommation non nulle et l'item « Configuration onto-ethique – … » apparaît dans Omeka S avec le statut `success`.

## 7. Dépannage

| Symptôme | Cause probable |
|---|---|
| « Collections indisponibles » | clé ou identifiant Zotero, groupe sans accès |
| « Forbidden » ou « HTTP 401 » à la synthèse | clé Albert absente ou refusée |
| « Aucune existence informationnelle identifiée » | collection sans texte ni annotation, description de l'activité trop vague, Albert indisponible |
| Fichiers absents de l'item Omeka S | extensions non autorisées (section 5) |
| Diagrammes vides | Plotly (CDN jsDelivr) inaccessible depuis le navigateur |
