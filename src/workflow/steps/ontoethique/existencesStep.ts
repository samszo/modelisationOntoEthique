import { createStep } from "@mastra/core/workflows";
import { askAgent } from "../../../agents/ask";
import { existencesAgent, EXISTENCES_PROMPT } from "../../../agents/existencesAgent";
import { agentText } from "../../../agents/overrides";
import { ontoEthiqueConfig } from "../../../config/ontoethique";
import { selfEvaluations, slug, type Existence } from "../../../lib/ontoethique/model";
import { existencesSchema, fillTemplate, formatActivity, formatDimensions, formatDocument, formatKinds } from "../../../lib/ontoethique/prompts";
import type { ZoteroArticle } from "../../../tools/fetchZoteroData";

// documents évalués : ceux qui ont du texte ou des annotations, dans l'ordre de la collection
export const selectDocuments = (articles: ZoteroArticle[]) =>
  articles.filter(a => (a.text ?? "").trim() || (a.annotations ?? []).length).slice(0, ontoEthiqueConfig.analysis.maxDocuments);

// genre reconnu dans la réponse de l'agent (identifiant ou libellé approché), sinon environnement documentaire
function normalizeKind(kind: string) {
  const k = slug(kind);
  const kinds = ontoEthiqueConfig.kinds;
  return kinds.find(x => x.id === k || slug(x.label) === k)?.id
    ?? (/hum|person|particip|cherch|etudi/.test(k) ? "humain" : /agent|ia|ai|llm|logiciel|algo|machine|modele/.test(k) ? "agent" : kinds.find(x => x.id === "environnement")?.id ?? kinds[0]!.id);
}

// Existences informationnelles de l'activité (agent) et leurs quatre dimensions, complétées des participants auto-évalués
export const existencesStep = createStep({
  id: "existences",
  execute: async ({ inputData }: any) => {
    const config = ontoEthiqueConfig;
    const articles: ZoteroArticle[] = inputData?.articles ?? [];
    const documents = selectDocuments(articles);
    const self = selfEvaluations(documents, config);
    if (self.pulsations.length) console.log(`🙋 ${self.pulsations.length} auto-évaluation(s) de ${self.existences.length} participant(s) dans les marqueurs Zotero`);

    let found: Existence[] = [];
    if (documents.length) {
      console.log(`🧠 Agent : Ontologue des existences (${documents.length} document(s))...`);
      try {
        const prompt = fillTemplate(agentText("existences-agent", "prompt", EXISTENCES_PROMPT), {
          activite: formatActivity(config.activity),
          genres: formatKinds(config),
          dimensions: formatDimensions(config),
          max: String(config.analysis.maxExistences),
          auto_evaluations: self.existences.map(e => `- ${e.id} : ${e.name}`).join("\n"),
          documents: documents.map((a, i) => formatDocument(a, i + 1, config, config.analysis.existencesCharsPerDocument)).join("\n\n"),
        });
        const { object } = await askAgent(existencesAgent, { model: config.models.analytics, source: "Existences informationnelles (existencesAgent)", schema: existencesSchema(config), prompt });
        found = (object?.existences ?? []).slice(0, config.analysis.maxExistences).map((x: any) => ({
          id: slug(x.id || x.name), name: String(x.name || x.id), kind: normalizeKind(String(x.kind ?? "")), description: x.description || undefined,
          dimensions: Object.fromEntries(config.dimensions.map(d => [d.id, (x[d.id] ?? []).map(String).filter(Boolean)])),
          cribles: (x.cribles ?? []).map(String).filter(Boolean),
          documents: (x.documents ?? []).map((n: number) => documents[n - 1]?.title).filter(Boolean),
          origin: "agent" as const,
        }));
      } catch (e) {
        console.warn("⚠️ Identification des existences impossible :", (e as Error).message);
      }
    }

    // participants auto-évalués : fusionnés avec l'existence de même identifiant ou de même nom
    const existences = [...found];
    for (const s of self.existences) {
      const same = existences.find(e => e.id === s.id || slug(e.name) === slug(s.name));
      if (!same) { existences.push(s); continue; }
      same.documents = [...new Set([...(same.documents ?? []), ...(s.documents ?? [])])];
      for (const p of self.pulsations) if (p.existence === s.id) p.existence = same.id;
    }
    // identifiants uniques
    const seen = new Set<string>();
    for (const e of existences) { let id = e.id, n = 2; while (seen.has(id)) id = `${e.id}-${n++}`; e.id = id; seen.add(id); }
    if (!existences.length) throw new Error("Aucune existence informationnelle identifiée : vérifier la collection, la description de l'activité et la connexion Albert.");
    console.log(`🌱 ${existences.length} existence(s) : ${existences.map(e => `${e.name} (${e.kind})`).join(", ")}`);
    return { existences, selfPulsations: self.pulsations, documents: documents.length };
  },
});
