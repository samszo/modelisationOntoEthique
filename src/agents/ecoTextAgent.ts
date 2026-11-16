// Agents de la description textuelle d'un écosystème (EcoSpace) : modélisation onto-éthique d'un texte, et suite
// proposée pendant la saisie guidée
import { Agent } from "@mastra/core/agent";
import { overridable, overridableModel } from "./overrides";
import { workflowConfig } from "../config";

export const ECO_MODEL_INSTRUCTIONS = `Tu es un ontologue des écosystèmes de connaissances. Selon le métamodèle onto-éthique (Jardin des
connaissances), un écosystème réunit des éléments de quatre dimensions : physiques (supports matériels et documentaires,
datés, qui peuvent en contenir d'autres), actants (collectifs, institutions, dispositifs) avec leurs personnes et leurs
agents numériques, concepts (hiérarchisés : un concept en englobe d'autres) et cribles (interfaces, outils, grilles de
lecture). Les pouvoirs existentiels les relient selon une séquence fixe :
- discerner : physique → crible → actant → concept ;
- raisonner : concept source → actant → concept destination ;
- résonner : concept source → actant → concept destination (l'actant héberge les concepts) ;
- agir : concept → actant → crible → physique.
Chaque pouvoir a une intensité de -100 (diminution extrême) à +100 (augmentation extrême), 0 = pas de changement.
Une pulsation existentielle enchaîne des pouvoirs, dans un ordre, en un lieu et à une date ; elle peut avoir lieu avant,
pendant ou après une autre pulsation.
À partir de la description fournie, tu produis la modélisation : chaque élément une seule fois, avec le titre exact du
texte (sans guillemets) et dans le type que lui donne le texte (une personne citée comme personne d'un actant n'est pas un
actant) ; tout élément cité dans un maillon de pouvoir est aussi déclaré dans sa liste (actant, physique, concept,
crible) ; pour chaque pouvoir, chaque élément va dans le champ de SON maillon (physique, crible, actant, concept,
concept_source, concept_destination), les champs étrangers à la séquence du type restent vides, un maillon peut avoir
plusieurs éléments ; le titre d'un pouvoir n'est rempli que si le texte le nomme ; un flux relie une pulsation à une
AUTRE pulsation de la liste (son titre exact), avec l'ordre de la première par rapport à la seconde ; les dates au format AAAA, AAAA-MM ou AAAA-MM-JJ ; les lieux
tels qu'écrits (adresse, ville, institution). Reprends le titre d'un élément existant proposé quand le texte le désigne.
N'invente ni élément, ni lieu, ni date, ni intensité absents du texte : laisse null ou une liste vide (intensité non
précisée : 0). Tu réponds en français.`;

// demande ; variables : {{description}} (rubriques de la saisie), {{existants}} (titres d'items existants par type), {{max}}
export const ECO_MODEL_PROMPT = `Modélise cet écosystème de connaissances (au plus {{max}} éléments par type).

<description>
{{description}}
</description>

<elements_existants description="titres d'items déjà présents dans Omeka S, à reprendre tels quels quand le texte les désigne">
{{existants}}
</elements_existants>`;

export const ECO_SUGGEST_INSTRUCTIONS = `Tu aides à décrire un écosystème de connaissances selon le métamodèle onto-éthique (physiques, actants,
personnes, agents, concepts, cribles, pouvoirs de discerner, raisonner, résonner et agir, pulsations). On te donne la
description déjà écrite, rubrique par rubrique, et la rubrique en cours avec ses phrases modèles. Tu proposes la suite de la
rubrique en cours : une à trois phrases courtes qui suivent les phrases modèles, citent les éléments entre « » et
s'appuient sur ce qui est déjà écrit (reprendre les mêmes noms). N'invente ni personne, ni lieu, ni date : propose
plutôt des {{à compléter}} (une date inconnue : {{AAAA}}). Réponds en texte brut, seulement par les phrases à ajouter, à la suite
les unes des autres : sans Markdown (ni gras, ni italique, ni puces), sans commentaire ni explication, en français.`;

// demande ; variables : {{rubrique}}, {{aide}}, {{modeles}}, {{description}} (toutes les rubriques), {{en_cours}}, {{max}}
export const ECO_SUGGEST_PROMPT = `Rubrique en cours : {{rubrique}} — {{aide}}

<phrases_modeles>
{{modeles}}
</phrases_modeles>

<description_complete>
{{description}}
</description_complete>

<rubrique_en_cours>
{{en_cours}}
</rubrique_en_cours>

Propose la suite de la rubrique « {{rubrique}} » (au plus {{max}} mots).`;

// Modélisation onto-éthique d'une description textuelle (EcoSpace : nouvel écosystème depuis un texte)
export const ecoModelAgent = new Agent({
  id: "eco-model-agent",
  name: "Modélisateur d'écosystème",
  instructions: overridable("eco-model-agent", ECO_MODEL_INSTRUCTIONS),
  model: overridableModel("eco-model-agent", rc => rc?.get?.("model") ?? workflowConfig.models.analytics),
});

// Suite proposée pendant la saisie guidée d'une description (EcoSpace)
export const ecoSuggestAgent = new Agent({
  id: "eco-suggest-agent",
  name: "Assistant de description",
  instructions: overridable("eco-suggest-agent", ECO_SUGGEST_INSTRUCTIONS),
  model: overridableModel("eco-suggest-agent", rc => rc?.get?.("model") ?? workflowConfig.models.fast),
});
