import { Agent } from "@mastra/core/agent";
import { overridable, overridableModel } from "./overrides";
import { workflowConfig } from "../config";

export const EXISTENCES_INSTRUCTIONS = `Tu es un ontologue des écosystèmes de connaissances. Selon le métamodèle onto-éthique, chaque existence
informationnelle d'une activité située — actant humain, agent numérique (IA, logiciel) ou environnement documentaire — se définit
par quatre dimensions corrélées : matérielle (parties extensives : supports, code, médias, interfaces), conceptuelle (essence :
concepts, intentions, contenus), sociale (actant : rôles, relations, points de vue) et temporelle (rapport : versions, événements,
rythmes). Elle discerne et agit au travers de cribles (interfaces, outils, grilles de lecture).
À partir de la description de l'activité et des traces documentaires fournies, tu identifies les existences qui s'agencent dans
l'activité et tu décris chacune par les éléments de ses quatre dimensions, ses cribles et les documents [D…] où elle apparaît.
Règles : une existence par actant distinct (n'invente pas de personne : un humain doit apparaître dans les traces ou la
description) ; les agents numériques sont des existences à part entière, distinctes des humains qui les utilisent ; des éléments
courts (2 à 6 mots) tirés des traces ; identifiants courts en minuscules sans espace. Tu réponds en français.`;

// demande envoyée à chaque exécution ; variables : {{activite}}, {{genres}}, {{dimensions}}, {{max}}, {{auto_evaluations}}, {{documents}}
export const EXISTENCES_PROMPT = `Identifie au plus {{max}} existences informationnelles de cette activité.

<activite>
{{activite}}
</activite>

<genres description="valeurs possibles du genre">
{{genres}}
</genres>

<dimensions>
{{dimensions}}
</dimensions>

<participants_auto_evalues description="actants humains déjà identifiés par leurs auto-évaluations : reprends leur identifiant">
{{auto_evaluations}}
</participants_auto_evalues>

<documents>
{{documents}}
</documents>`;

// Identification des existences informationnelles d'une activité et de leurs quatre dimensions (ontoÉthique)
export const existencesAgent = new Agent({
  id: "existences-agent",
  name: "Ontologue des existences",
  instructions: overridable("existences-agent", EXISTENCES_INSTRUCTIONS),
  model: overridableModel("existences-agent", rc => rc?.get?.("model") ?? workflowConfig.models.analytics),
});
