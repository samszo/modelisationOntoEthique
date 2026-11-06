# Guide de l'utilisateur

**ontoÉthique** (http://127.0.0.1:7280) évalue la **symbiose** entre les actants humains, les agents numériques (IA) et l'environnement documentaire d'une **activité située** : un cours, une rédaction assistée, une curation collaborative… Il applique le protocole de mesure des fluctuations du métamodèle onto-éthique :

- chaque **existence informationnelle** est décrite par quatre dimensions : matérielle (parties extensives), conceptuelle (essence), sociale (actant), temporelle (rapport) ;
- à chaque **pulsation** de l'activité, une existence exprime quatre **pouvoirs** : discerner, raisonner, résonner, agir ;
- chaque pouvoir reçoit un score **de -100 (diminution, tristesse) à +100 (augmentation, joie)**, 0 marquant l'indifférence, rattaché à sa séquence de sémiose (par exemple *physique → crible → actant → concept* pour discerner, *concept → actant → concept* pour raisonner, *concept → concept* pour résonner, *concept → actant → crible → physique* pour agir).

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

## 3. Créer les items dans Omeka S

L'onglet **Formulaires Omeka S** suit le processus de modélisation : Physiques, Cribles, Personnes, Agents, Actants, Concepts, Pouvoirs existentiels, Pulsations existentielles, Raison trajective. Chaque formulaire vient du modèle de ressource : les listes sont celles des vocabulaires personnalisés, la classe et la collection d'items sont appliquées d'office.

- **Pouvoir existentiel** : choisir le type (la séquence attendue s'affiche), l'intensité (-100 : diminution extrême, 0 : pas de changement, 100 : augmentation extrême) et les maillons. Pour raisonner et résonner, saisir deux concepts avec **+ Ajouter une valeur** : le premier est la source, le second la destination.
- **Pulsation existentielle** : y ajouter ses pouvoirs, et la relier aux autres pulsations (flux) avec leur temporalité : avant, pendant, après, ordre successif.
- **Raison trajective** : y ajouter les pulsations, avec leur ordre.

Un item de même titre et de même modèle n'est pas recréé : le lien vers l'item existant s'affiche.

## 4. EcoNetwork : modéliser pas à pas

http://127.0.0.1:7280/econetwork (lien **EcoNetwork** dans l'en-tête) suit la modélisation étape par étape ; la colonne de gauche permet de revenir à une étape.

1. **1.1 Créer ou choisir un écosystème de connaissances** (un média peut être joint à la création).
2. **1.2 Réseau de l'écosystème** : l'écosystème au centre, ses éléments et les ressources qui leur sont liées. Glisser un nœud pour le déplacer, molette pour zoomer, **Recentrer** pour tout voir. Un clic sur un nœud ouvre son menu circulaire (icônes ; le libellé s'affiche au survol) :
   - **lier** : choisir dans le second anneau le type du nœud (les types possibles dépendent des propriétés du modèle du nœud), puis saisir un titre. Les items existants dont le titre contient la saisie sont proposés avec leur type (« déjà lié » s'ils le sont) : en choisir un pour le lier, sinon un nouveau nœud est créé, avec au besoin un **média** : **Fichier** (déposé dans Omeka S) ou **Adresse** (une adresse publique qu'Omeka S télécharge), et un titre facultatif. Le nœud lié est aussi rattaché à l'écosystème ;
   - **dupliquer** : même nœud, titre incrémenté ;
   - **détails** : onglet **Omeka S**, la page d'administration de l'item (se connecter une fois dans le cadre : la session est ensuite gardée, et l'on revient sur l'item) ; onglet **Fiche**, toutes les valeurs du nœud (un item lié présent dans le réseau ouvre sa propre fiche) ; **Nouvel onglet ↗** ;
   - **supprimer** : la fenêtre montre les nœuds parents (dont l'écosystème de rattachement) et les enfants impactés ; un rattachement à un autre écosystème bloque la suppression. **Retirer du réseau** garde l'item dans Omeka S ; **Supprimer dans Omeka S** n'est possible que si aucun autre nœud ne l'utilise (le **délier** d'abord) ;
   - **modifier** : le formulaire du type de nœud, pré-rempli.

## 5. EcoSpace : l'écosystème en trois dimensions

http://127.0.0.1:7280/ecospace (lien **EcoSpace** dans l'en-tête) représente l'écosystème dans un espace 3D.

1. **1.1 Créer ou choisir un écosystème** : un nouvel écosystème reçoit sa **grille hexagonale** ; pour un écosystème existant, **Créer la grille** à l'étape suivante.
2. **1.2 Espace de l'écosystème** : glisser pour tourner, clic droit (ou Maj + glisser) pour déplacer, molette pour zoomer, double-clic pour s'approcher d'un hexagone ; **Vue d'ensemble**, **Vue de dessus**, **Vue de dessous**. Le survol d'un hexagone affiche ses coordonnées **cube** (q, r, s) et **géographiques** (longitude, latitude, altitude). Les positions de l'espace sont aussi **copiées dans Omeka S**, comme média de l'écosystème (fichier `ecospace-<numéro>.json`), quelques secondes après chaque modification ; la ligne d'information indique l'état de cette copie. Il faut pour cela qu'Omeka S accepte les fichiers JSON (Administration > Paramètres > Sécurité : type `application/json`, extension `json`). Pendant une opération qui prend du temps (chargement, liens entre concepts, duplication…), une **fenêtre** indique ce qui se passe : les étapes terminées et celle en cours, avec leur durée. Un clic ouvre le menu circulaire ; **lier** n'y propose que ce qui est possible : sur un hexagone libre, les éléments qui peuvent y être placés ; sur un élément, les liens prévus par son modèle (resource template) — un actant : personne et agent ; un physique : physique enfant ; un concept : parent, enfant, détacher ; une personne ou un agent : rien.
   - sur un hexagone libre, **lier** puis choisir le type d'élément : l'**Actant**, le **Physique** et le **Concept** ont leur forme ; **Personne** et **Agent** s'ajoutent depuis un actant ; les autres types suivront. Saisir un titre : un actant existant peut être choisi, sinon il est créé (média facultatif). L'actant apparaît sous la forme d'un **fullerène** (molécule C60) centré sur l'hexagone et d'une **sphère**, tous deux du même rayon que l'hexagone, dont le pôle nord touche le centre du fullerène, sous la grille ; **détails** donne les coordonnées de l'hexagone ;
   - **Personne** et **Agent** : ils ne s'ajoutent que **depuis un actant** (son menu **lier** propose Personne et Agent, à créer ou à choisir parmi les existants). Chacun est, comme l'actant, un **petit fullerène** avec une **sphère** sous la grille (bleus pour une personne, ocre pour un agent ; la sphère de l'actant devient alors translucide pour les laisser voir) centré sur une **sous-grille hexagonale** dessinée sur l'hexagone de l'actant (moitié au-dessus, moitié en dessous de la grille) : le centre reste à l'actant, les suivants se placent anneau par anneau. **Supprimer** propose de le détacher de l'actant (l'item reste dans Omeka S) ;
   - **Physique** : une **boîte** posée sur l'hexagone, qui s'élève selon le temps : la surface de la grille est *maintenant*, le haut de l'échelle la plus ancienne date de création des physiques. La boîte va de la date de dernière modification (en bas) à la date de création (en haut) : sa hauteur est sa durée. À la création, saisir la **date de création** (AAAA, AAAA-MM-JJ…) et l'**importance**. Sur un physique, **lier** ajoute un **physique enfant** : une boîte à l'intérieur de son parent. Les enfants sont empilés de haut en bas dans l'ordre alphabétique de leur titre, et la hauteur de chacun est proportionnelle à son importance face à celle des autres enfants. Si le physique a un **média image**, l'image est plaquée sur les faces de sa boîte. Le curseur **Échelle temporelle** étire ou resserre l'échelle (position et hauteur des boîtes) ; le mode **logarithmique** dilate les périodes récentes ;
   - **Concept** : une **bulle conceptuelle** couchée sous la grille, orientée est-ouest (cylindre terminé par deux demi-sphères). Sa taille et sa place sont **calculées**, on ne les règle pas à la main : une bulle sans enfant est juste assez longue pour son titre ; une bulle parent englobe ses enfants, rangés côte à côte par ordre alphabétique, son propre titre au-dessus d'eux. Les concepts de même niveau sont répartis de façon équilibrée (écarts égaux, centrés) ; les concepts sans parent forment une grille centrée sous l'espace. La hiérarchie vient d'Omeka S (*skos:narrower* / *skos:broader*) et se modifie par le menu du concept, **lier** : **Concept parent** (un concept qui l'englobera ; s'il avait déjà un parent, le nouveau s'intercale), **Concept enfant** (un concept qu'il englobera ; un concept existant quitte son ancien parent) ou **Détacher** (il redevient un concept sans parent). Chaque relation écrite est annotée par l'écosystème. Supprimer un concept de l'espace ne touche pas à ses relations dans Omeka S ;
   - un hexagone peut porter **un actant et un physique** (l'un sous la grille, l'autre au-dessus) : sur l'un, **lier** propose l'autre type ;
   - sur un élément placé : **dupliquer** (indiquer le nombre de copies ; chacune va sur l'hexagone libre le plus proche), **détails** (Omeka S, fiche et position), **supprimer** (retirer de l'espace, de l'écosystème, ou supprimer dans Omeka S ; un physique enfant peut être **détaché** de son parent), **modifier**. Pour atteindre un physique qui contient des enfants, cliquer dans sa marge, autour d'eux.

## 6. Lire et corriger l'évaluation

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

## 7. Interpréter

- **Grille des affects** : Discerner (cécité cognitive / stase / clarté sémiotique), Raisonner (aliénation logique / routinisation / puissance critique), Résonner (impasse intuitive / barrière numérique / scientia intuitiva), Agir (misère symbolique / geste blanc / création autopoïétique).
- **Valeurs tardiennes** : utilité et beauté (Désir), vérité (Croyance) de ce qui est discerné ; une valeur-vérité effondrée signale l'**indignation**.
- **Symbiose** : l'indice (de -1 à 1) est la valence moyenne des existences ; l'équilibre (de 0 à 1) compare humains, agents et environnement. Un indice positif avec un faible équilibre signale un profit asymétrique.
- **Alertes** : notamment le risque de **misère symbolique** — un humain dont les pouvoirs de raisonner et de résonner diminuent tandis qu'un agent agit fortement.
- **Spirale de Pappus** : rayon = augmentations de Résonner, altitude = augmentations d'Agir, rotation = Discerner + Raisonner. Un **cône évasé** traduit des intuitions nombreuses, une **flèche** une production sans résonance, un **tube** une activité qui sédimente sans se dilater.

Les scores sont des **expressions situées et subjectives**, non des mesures physiques : la matrice est un support pour une **éthique de la discussion** entre participants, que la synthèse prolonge par des questions ouvertes.
