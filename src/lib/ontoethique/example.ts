// Exemple de l'article (scénarios A et B de rédaction) : évaluation saisie à la main qui permet d'essayer la matrice,
// les indicateurs et les spirales sans collection Zotero ni appel à un modèle
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import { applyRules, emptyModel, type Evaluation, type OntoModel } from "./model";

const ev = (score: number, chain: string[], justification: string): Evaluation => ({ score, chain, justification, origin: "humain", validated: true });

export function articleExample(runId: string, config: OntoEthiqueConfig): OntoModel {
  const model = emptyModel({
    runId, workflowId: config.workflowId, mode: "manuel",
    activity: {
      title: "Comparaison de deux pulsations de rédaction",
      description: "Scénario A : rédaction manuelle d'un texte de recherche. Scénario B : rédaction assistée par une IA connexionniste pure. Exemple de l'article « Le tournant ontologique dans les humanités numériques » (S. Szoniecky).",
    },
  });
  model.existences = [
    { id: "humain-a", name: "Humain – rédaction manuelle (A)", kind: "humain", origin: "humain",
      description: "Chercheur qui rédige seul, à partir de ses lectures.",
      dimensions: { materielle: ["clavier d'ordinateur", "traitement de texte", "notes de lecture"], conceptuelle: ["écrire", "argumentation"], sociale: ["auteur", "communauté de recherche"], temporelle: ["rédaction lente", "versions successives"] },
      cribles: ["clavier d'ordinateur", "grille de lecture"] },
    { id: "humain-b", name: "Humain – rédaction assistée (B)", kind: "humain", origin: "humain",
      description: "Chercheur qui délègue la rédaction à un modèle de langage.",
      dimensions: { materielle: ["interface de dialogue", "texte généré"], conceptuelle: ["écrire"], sociale: ["prescripteur"], temporelle: ["génération ultra-rapide"] },
      cribles: ["interface de dialogue"] },
    { id: "ia-b", name: "IA connexionniste (B)", kind: "agent", origin: "humain",
      description: "Grand modèle de langage utilisé sans ancrage ontologique.",
      dimensions: { materielle: ["poids du modèle", "serveur d'inférence", "tokens"], conceptuelle: ["distribution statistique"], sociale: ["assistant"], temporelle: ["génération de masse"] },
      cribles: ["prompt", "fenêtre de contexte"] },
  ];
  model.pulsations = [
    { id: "p1", order: 1, existence: "humain-a", origin: "humain", moment: "Rédaction manuelle (lente)", values: { utilite: 40, verite: 70, beaute: 60 },
      evaluations: {
        discerner: ev(40, ["notes de lecture", "grille de lecture", "chercheur", "concepts du corpus"], "Lecture attentive, filtrage par la grille de lecture."),
        raisonner: ev(80, ["hypothèse", "est étayée par", "citations"], "Argumentation construite et vérifiée."),
        resonner: ev(90, ["symbiose", "chercheur", "symbole"], "Saut analogique entre symbiose et symbole."),
        agir: ev(50, ["écrire", "chercheur", "clavier d'ordinateur", "texte de l'article"], "Trace écrite, mais lente."),
      } },
    { id: "p2", order: 1, existence: "humain-b", origin: "humain", moment: "Rédaction assistée par IA", values: { utilite: 80, verite: -30, beaute: 20 },
      evaluations: {
        discerner: ev(10, ["texte généré", "interface de dialogue", "chercheur", "idées reçues"], "Peu de perception nouvelle."),
        raisonner: ev(-30, ["texte généré", "est accepté sans", "vérification"], "Paresse logique."),
        resonner: ev(-50, ["formule", "chercheur", "formule"], "Perte de sensation, formules mortes."),
        agir: ev(90, ["écrire", "chercheur", "interface de dialogue", "texte généré"], "Génération de masse ultra-rapide."),
      } },
    { id: "p3", order: 1, existence: "ia-b", origin: "humain", moment: "Rédaction assistée par IA", values: { utilite: 80, verite: -20, beaute: 30 },
      evaluations: {
        discerner: ev(80, ["corpus d'entraînement", "fenêtre de contexte", "modèle", "motifs statistiques"], "Captation massive de motifs."),
        raisonner: ev(60, ["prompt", "est complété par", "suite probable"], "Raisonnement syntaxique."),
        resonner: ev(-100, [], "Limite absolue : le modèle ne résonne pas."),
        agir: ev(90, ["réponse", "modèle", "tokens", "texte généré"], "Génération de masse."),
      } },
  ];
  return applyRules(model, config);
}
