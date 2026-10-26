# Guide de l'utilisateur

**ontoÉthique** (http://127.0.0.1:7280) évalue la **symbiose** entre les actants humains, les agents numériques (IA) et l'environnement documentaire d'une **activité située** : un cours, une rédaction assistée, une curation collaborative… Il applique le protocole de mesure des fluctuations du métamodèle onto-éthique :

- chaque **existence informationnelle** est décrite par quatre dimensions : matérielle (parties extensives), conceptuelle (essence), sociale (actant), temporelle (rapport) ;
- à chaque **pulsation** de l'activité, une existence exprime quatre **pouvoirs** : discerner, raisonner, résonner, agir ;
- chaque pouvoir reçoit un score **de -100 (diminution, tristesse) à +100 (augmentation, joie)**, 0 marquant l'indifférence, rattaché à sa séquence de sémiose (par exemple *physique → crible → actant → concept* pour discerner).

## 1. Préparer les traces

1. Dans Zotero (de préférence une **bibliothèque de groupe**, pour que chaque annotation garde son auteur), créer une collection contenant les traces de l'activité : comptes rendus, journaux de bord, captures, transcriptions d'échanges avec une IA, observations.
2. Les participants annotent ces traces dans le lecteur de Zotero : commentaires, notes, surlignages.
3. **Auto-évaluation** (facultative) : un participant ajoute à une annotation un marqueur comme `discerner+40`, `raisonner-30`, `résonner:60` ou `agir=-10`. L'annotation devient une pulsation de ce participant, **validée d'office** (souveraineté de l'expertise humaine).

## 2. Lancer une modélisation

1. **⚙ Paramètres** : renseigner Albert, Zotero et Omeka S, puis **Enregistrer et tester les connexions**.
2. Onglet **Activité** : titre et description de l'activité (tâche, participants, agents numériques, environnement, période), collection Zotero, réglages de lecture.
3. **Enregistrer et modéliser** : le journal s'affiche dans l'onglet **Exécution** ; à la fin, l'évaluation s'ouvre dans l'onglet **Diagrammes**.

Le traitement identifie les existences, évalue les pulsations de chaque trace, mesure les fluctuations et rédige une synthèse. Les **agents numériques n'ont pas accès au pouvoir de résonance** : leur score de Résonner est fixé par la règle de la barrière numérique (0 par défaut, réglable dans *Règles et seuils*).

**Sans collection ni modèle de langage** : **Nouvelle évaluation manuelle** crée une évaluation vide (existences et pulsations à saisir) ; **Charger l'exemple de l'article** reprend les scénarios A (rédaction manuelle) et B (rédaction assistée par une IA connexionniste).

## 3. Lire et corriger l'évaluation

| Onglet | Contenu |
|---|---|
| **Existences** | une fiche par existence : genre, éléments des quatre dimensions, cribles, traces, complexité ontologique ; cliquer pour modifier, **Ajouter une existence** |
| **Matrice des affects** | une ligne par pulsation : scores colorés (rouge : diminution, vert : augmentation), origine (*agent*, *humain*, *autoevaluation*, *regle*) et ✔ si validé. Cliquer sur une ligne ouvre l'éditeur : score (curseur), état de la grille, maillons de la séquence de sémiose, justification, citation, valeurs tardiennes |
| **Diagrammes** | indice et équilibre de la symbiose, alertes, **spirales coniques de Pappus**, profils des pouvoirs, moyennes par genre, tableau des moyennes et des états |
| **Synthèse** | discours de l'ADA onto-éthique (les références `[p3]` ouvrent la pulsation) ; **Nouvelle synthèse** après corrections |
| **Rapport** | rapport de l'exécution (consommation, coût) et fichiers : modèle JSON, matrice CSV, Turtle, JSON-LD, spirales |
| **Évaluations** | toutes les évaluations (archive locale et Omeka S) : ouvrir, supprimer |

**Corriger et valider** : dans l'éditeur, une évaluation modifiée devient *humaine* ; la case **validé** (ou **Tout valider et enregistrer**) confirme une proposition de l'agent. Indiquer **votre nom** et le **motif** : chaque correction est tracée dans l'historique des **révisions**, exporté avec le modèle. Les indicateurs, les spirales et les fichiers sont recalculés à chaque enregistrement.

**Enregistrer dans Omeka S** (bandeau de l'évaluation) dépose la version corrigée dans l'item de configuration de l'évaluation (créé pour une évaluation manuelle).

## 4. Interpréter

- **Grille des affects** : Discerner (cécité cognitive / stase / clarté sémiotique), Raisonner (aliénation logique / routinisation / puissance critique), Résonner (impasse intuitive / barrière numérique / scientia intuitiva), Agir (misère symbolique / geste blanc / création autopoïétique).
- **Valeurs tardiennes** : utilité et beauté (Désir), vérité (Croyance) de ce qui est discerné ; une valeur-vérité effondrée signale l'**indignation**.
- **Symbiose** : l'indice (de -1 à 1) est la valence moyenne des existences ; l'équilibre (de 0 à 1) compare humains, agents et environnement. Un indice positif avec un faible équilibre signale un profit asymétrique.
- **Alertes** : notamment le risque de **misère symbolique** — un humain dont les pouvoirs de raisonner et de résonner diminuent tandis qu'un agent agit fortement.
- **Spirale de Pappus** : rayon = augmentations de Résonner, altitude = augmentations d'Agir, rotation = Discerner + Raisonner. Un **cône évasé** traduit des intuitions nombreuses, une **flèche** une production sans résonance, un **tube** une activité qui sédimente sans se dilater.

Les scores sont des **expressions situées et subjectives**, non des mesures physiques : la matrice est un support pour une **éthique de la discussion** entre participants, que la synthèse prolonge par des questions ouvertes.
