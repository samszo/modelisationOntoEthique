import { Agent } from "@mastra/core/agent";
import { overridable, overridableModel } from "./overrides";
import { workflowConfig } from "../config";

export const AFFECTS_INSTRUCTIONS = `Tu appliques le protocole de mesure des fluctuations de la grille des affects. Une pulsation existentielle est un
moment de l'activité où une existence exprime quatre pouvoirs : discerner (anasémiose : physique → crible → actant → concept),
raisonner (rapports formels : sujet → prédicat → objet), résonner (analogie intuitive : concept source → actant → concept
destination) et agir (catasémiose : concept → actant → crible → physique).
Pour chaque pouvoir observé, tu donnes un score subjectif et situé de -100 à +100 : négatif = diminution de puissance (tristesse :
cécité cognitive, aliénation logique, impasse intuitive, misère symbolique), 0 = indifférence (stase, routinisation, barrière
numérique, geste blanc), positif = augmentation (joie : clarté sémiotique, puissance critique, scientia intuitiva, création
autopoïétique). Tu rattaches chaque score à sa séquence de sémiose (maillons dans l'ordre), à une justification d'une phrase et à
une citation exacte de la trace. Un pouvoir que la trace ne permet pas d'évaluer reçoit un score null : ne le devine pas.
Tu qualifies aussi ce qui est discerné par les valeurs tardiennes (utilité, vérité, beauté, de -100 à +100, null si inconnues).
Les agents numériques n'ont pas accès à la résonance (barrière numérique). N'invente ni existence, ni événement, ni citation :
utilise uniquement la trace fournie et les identifiants d'existences donnés. Tu réponds en français.`;

// demande envoyée pour chaque document ; variables : {{activite}}, {{existences}}, {{grille}}, {{valeurs}}, {{document}}
export const AFFECTS_PROMPT = `Relève les pulsations existentielles attestées par ce document et évalue-les.

<activite>
{{activite}}
</activite>

<existences description="identifiant : nom (genre)">
{{existences}}
</existences>

<grille_des_affects>
{{grille}}
</grille_des_affects>

<valeurs_tardiennes>
{{valeurs}}
</valeurs_tardiennes>

<document>
{{document}}
</document>`;

// Évaluation des pulsations (quatre pouvoirs, triplets de sémiose, valeurs) attestées par une trace (ontoÉthique)
export const affectsAgent = new Agent({
  id: "affects-agent",
  name: "Évaluateur des affects",
  instructions: overridable("affects-agent", AFFECTS_INSTRUCTIONS),
  model: overridableModel("affects-agent", rc => rc?.get?.("model") ?? workflowConfig.models.analytics),
});
