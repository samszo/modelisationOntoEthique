// Routes de la description textuelle d'un nouvel écosystème (EcoSpace, étape 1.1) : vocabulaire de l'autocomplétion,
// suite proposée par eco-suggest-agent, modélisation par eco-model-agent, journal de la génération (jdc:pipeline) ; la création (écosystème, espace, éléments,
// pouvoirs, pulsations, positions) est faite par la page avec les routes d'EcoSpace et d'EcoNetwork
import http from "http";
import type { Omk } from "../lib/omeka/omk";
import type { OntoEthiqueConfig } from "../config/ontoethique";
import { askAgent } from "../agents/ask";
import { agentModelId, agentText } from "../agents/overrides";
import { ecoModelAgent, ecoSuggestAgent, ECO_MODEL_PROMPT, ECO_SUGGEST_PROMPT } from "../agents/ecoTextAgent";
import { completeModel, EcoModelSchema, formatExisting, formatSections, type Kind, type Vocab } from "../lib/ecospace/ecotext";
import { appendUsageHistory } from "../lib/metrics/usageHistory";
import { toWritable, writeValues } from "../lib/omeka/network";
import { estimateImpact } from "../lib/metrics/impact";
import type { UsageSummary } from "../lib/metrics/usage";

type Handler = (req: http.IncomingMessage, res: http.ServerResponse, url: URL) => Promise<void> | void;
interface Ctx {
  config: () => OntoEthiqueConfig;
  costs: () => any;
  serverOmk: () => Promise<Omk>;
  sendJson: (res: http.ServerResponse, status: number, data: unknown) => void;
  readBody: (req: http.IncomingMessage) => Promise<any>;
}

// suite proposée en texte brut : sans Markdown, puces ni commentaires, en une suite de phrases
const cleanSuggestion = (t: string) => t.replace(/\{\/\*[\s\S]*?\*\/\}|\/\*[\s\S]*?\*\//g, " ").replace(/\*+|__|`/g, "")
  .split(/\n+/).map(l => l.replace(/^\s*(?:[-•–]|\d+[.)])\s+/, "").trim()).filter(Boolean).join(" ").replace(/\s{2,}/g, " ").trim();
const fill = (tpl: string, vars: Record<string, string>) => tpl.replace(/\{\{(\w+)\}\}/g, (m, k) => (k in vars ? (vars[k] || "(aucun)") : m));

export function ecotextRoutes(ctx: Ctx): Record<string, Handler> {
  const cfg = () => ctx.config().ecotext;
  const json = (fn: (req: http.IncomingMessage, url: URL) => Promise<unknown>): Handler => async (req, res, url) => {
    try { ctx.sendJson(res, 200, await fn(req, url)); } catch (e) { ctx.sendJson(res, 400, { error: (e as Error).message }); }
  };
  // titres des items existants par type (templates de omekaForms), en cache vocabCacheTtl ms
  let vocabCache: { at: number; data: Promise<Vocab> } | null = null;
  const vocab = () => {
    if (!vocabCache || Date.now() - vocabCache.at > (Number(cfg().vocabCacheTtl) || 600000)) {
      const data = (async () => {
        const omk = await ctx.serverOmk(), kinds: Kind[] = ["actant", "personne", "agent", "physique", "concept", "crible", "pulsation"];
        const tpl = (k: Kind) => ctx.config().omekaForms.templates.find(t => t.key === k)?.templateId;
        const lists = await Promise.all(kinds.map(k => tpl(k) ? omk.getAllItems(`resource_template_id=${tpl(k)}&sort_by=title`).catch(() => []) : Promise.resolve([])));
        return Object.fromEntries(kinds.map((k, i) => [k, (lists[i] as any[]).map(it => ({ id: it["o:id"] as number, title: String(it["o:title"] ?? "") })).filter(x => x.title)])) as Vocab;
      })();
      vocabCache = { at: Date.now(), data };
      data.catch(() => { vocabCache = null; });
    }
    return vocabCache.data;
  };
  // consommation d'un appel : historique (onglet coût) et impact renvoyé à la page
  const usageOf = (source: string, agentId: string, model: string, usage: any, task: string) => {
    const input = Number(usage?.inputTokens ?? usage?.promptTokens ?? 0) || 0, output = Number(usage?.outputTokens ?? usage?.completionTokens ?? 0) || 0;
    const entry = { source, model: agentModelId(agentId, model), calls: 1, inputTokens: input, outputTokens: output, reasoningTokens: 0, totalTokens: input + output, unknown: input + output ? 0 : 1 };
    const summary: UsageSummary = { entries: [entry], calls: 1, inputTokens: input, outputTokens: output, reasoningTokens: 0, totalTokens: input + output, unknown: entry.unknown };
    appendUsageHistory("ontoethique", summary, task);
    const impact = estimateImpact(summary, ctx.costs());
    return { tokens: summary.totalTokens, energyWh: impact.energyWh, co2g: impact.co2g, apiCost: impact.apiCost, currency: impact.currency };
  };
  const sectionsOf = (b: any) => {
    const ids = new Set(cfg().stages.map(s => s.id)), out: Record<string, string> = {};
    for (const [k, v] of Object.entries(b?.sections ?? {})) if (ids.has(k)) out[k] = String(v ?? "").slice(0, 20000);
    return out;
  };

  // propriétés Omeka S (o:id), en cache
  const propIds = new Map<string, number>();
  const propId = async (omk: Omk, term: string) => {
    if (!propIds.has(term)) {
      const p = (await omk.request(omk.url("properties", { term })))[0];
      if (!p) throw new Error(`Propriété ${term} absente de l'instance Omeka S`);
      propIds.set(term, p["o:id"]);
    }
    return propIds.get(term)!;
  };
  const costText = (c: any) => c ? [c.tokens != null && `${c.tokens} tokens`, c.apiCost != null && `${Number(c.apiCost).toFixed(5)} ${c.currency ?? "€"}`,
    c.energyWh != null && `${Number(c.energyWh).toFixed(4)} Wh`, c.co2g != null && `${Number(c.co2g).toFixed(4)} g CO₂e`, c.durationMs != null && `${(c.durationMs / 1000).toFixed(1)} s`].filter(Boolean).join(" · ") : "";

  return {
    // rubriques, phrases modèles, types de pouvoir (séquences) et titres existants pour l'autocomplétion
    "GET /api/ecotext/vocab": json(async () => ({
      stages: cfg().stages, minChars: cfg().minChars, maxSuggestions: cfg().maxSuggestions,
      powerTypes: ctx.config().omekaForms.powerTypes.map(t => ({ id: t.id, label: t.label, sequence: t.sequence.map(s => s.name) })),
      existing: await vocab(),
    })),

    // suite d'une rubrique ({ stage, sections }) : quelques phrases proposées par eco-suggest-agent
    "POST /api/ecotext/suggest": json(async req => {
      const b = await ctx.readBody(req), sections = sectionsOf(b), st = cfg().stages.find(s => s.id === b.stage);
      if (!st) throw new Error("Rubrique inconnue");
      const model = ctx.config().models.fast, source = `Suite de la description : ${st.label} (ecoSuggestAgent)`;
      const prompt = fill(agentText("eco-suggest-agent", "prompt", ECO_SUGGEST_PROMPT), {
        rubrique: st.label, aide: st.help, modeles: st.patterns.map(p => `- ${p}`).join("\n"),
        description: formatSections(cfg().stages, sections), en_cours: sections[st.id] ?? "", max: String(cfg().suggestMaxWords),
      });
      console.log(`🧠 Agent : ecoSuggestAgent (${st.label})`);
      const { text, usage } = await askAgent(ecoSuggestAgent, { model, source, prompt });
      return { text: cleanSuggestion(text), prompt, model: agentModelId("eco-suggest-agent", model), cost: usageOf(source, "eco-suggest-agent", model, usage, "ecotexte") };
    }),

    // journal de la génération conservé dans l'item de l'écosystème ({ eco, run, sections, steps, validated, report }) :
    // une valeur de pipeline.property par étape, annotée selon le modèle de la propriété (template 17) ; les valeurs
    // d'une même génération (préfixe [run]) sont remplacées, les autres conservées
    "POST /api/ecotext/pipeline": json(async req => {
      const b = await ctx.readBody(req), pc = cfg().pipeline, an = pc.annotation, max = Number(pc.maxChars) || 60000;
      const eco = Number(b.eco);
      if (!Number.isInteger(eco) || eco <= 0) throw new Error("Identifiant d'écosystème invalide");
      const run = String(b.run ?? "").slice(0, 40).replace(/[\[\]]/g, "") || new Date().toISOString();
      const omk = await ctx.serverOmk(), item = await omk.request(omk.url(`items/${eco}`));
      if (item["o:resource_template"]?.["o:id"] !== ctx.config().econetwork.ecoTemplateId) throw new Error(`L'item ${eco} n'est pas un écosystème de connaissances`);
      const terms = [pc.property, ...Object.values(an)].filter(Boolean) as string[];
      const pid = Object.fromEntries(await Promise.all(terms.map(async t => [t, await propId(omk, t)] as const)));
      const txt = (v: unknown) => (typeof v === "string" ? v : v == null ? "" : JSON.stringify(v, null, 1)).slice(0, max).trim();
      const stamp = run.slice(0, 16).replace("T", " ");
      // étape → valeur annotée (champs vides omis)
      const value = (label: string, a: { title?: string; description?: unknown; prompt?: unknown; response?: unknown; model?: unknown; cost?: unknown }) => {
        const annotation: Record<string, any[]> = {};
        for (const [k, v] of Object.entries(a)) {
          const term = (an as any)[k], s = k === "cost" ? costText(v) : txt(v);
          if (term && s) annotation[term] = [{ type: "literal", property_id: pid[term], "@value": s }];
        }
        return { type: "literal", property_id: pid[pc.property], "@value": `[${stamp}] ${label}`, "@annotation": annotation };
      };
      const stages = cfg().stages, sections = sectionsOf(b), vals: any[] = [];
      for (const st of stages) if (sections[st.id]?.trim()) vals.push(value(`Saisie : ${st.label}`, { title: `Saisie : ${st.label}`, description: sections[st.id] }));
      for (const s of Array.isArray(b.steps) ? b.steps.slice(0, 200) : []) {
        if (s?.kind === "suggestion") {
          const st = stages.find(x => x.id === s.stage), label = `Suite proposée : ${st?.label ?? s.stage} (${s.accepted ? "ajoutée" : "ignorée"})`;
          vals.push(value(label, { title: label, description: s.at ? `le ${String(s.at).slice(0, 19).replace("T", " ")} (UTC)` : "", prompt: s.prompt, response: s.response, model: s.model, cost: s.cost }));
        } else if (s?.kind === "model") {
          vals.push(value("Modélisation par l'agent (eco-model-agent)", { title: "Modélisation par l'agent", description: s.at ? `le ${String(s.at).slice(0, 19).replace("T", " ")} (UTC)` : "", prompt: s.prompt, response: s.response, model: s.model, cost: { ...(s.cost ?? {}), durationMs: s.durationMs } }));
        }
      }
      if (b.validated) vals.push(value("Modélisation validée (aperçu corrigé) et création", { title: "Modélisation validée et création", description: b.report, response: b.validated }));
      const keep = (item[pc.property] ?? []).filter((v: any) => !String(v["@value"] ?? "").startsWith(`[${stamp}]`));
      await writeValues(omk, eco, { [pc.property]: [...keep.map(toWritable), ...vals] });
      console.log(`📤 [OMEKA] Écosystème depuis un texte : ${vals.length} étape(s) de la génération écrites dans ${pc.property} de l'item ${eco}`);
      return { values: vals.length };
    }),

    // modélisation de la description ({ sections }) : schéma de l'agent, rapproché des items existants et complété
    "POST /api/ecotext/model": json(async req => {
      const b = await ctx.readBody(req), sections = sectionsOf(b);
      const description = formatSections(cfg().stages, sections);
      if (!Object.values(sections).some(v => v.trim())) throw new Error("Description vide");
      const v = await vocab(), model = ctx.config().models.analytics, source = "Modélisation d'un écosystème depuis un texte (ecoModelAgent)";
      const prompt = fill(agentText("eco-model-agent", "prompt", ECO_MODEL_PROMPT), { description, existants: formatExisting(v, description), max: String(cfg().maxElements) });
      console.log("🧠 Agent : ecoModelAgent");
      const started = Date.now();
      const { object, usage } = await askAgent(ecoModelAgent, { model, source, prompt, schema: EcoModelSchema });
      if (!object) throw new Error("Réponse du modèle illisible");
      const powerTypes = ctx.config().omekaForms.powerTypes.map(t => ({ id: t.id, sequence: t.sequence }));
      const result = completeModel(object, v, powerTypes);
      console.log(`✅ Écosystème depuis un texte : ${result.actants.length} actant(s), ${result.physiques.length} physique(s), ${result.concepts.length} concept(s), ${result.pouvoirs.length} pouvoir(s), ${result.pulsations.length} pulsation(s)`);
      return { model: result, raw: object, prompt, iaModel: agentModelId("eco-model-agent", model), durationMs: Date.now() - started, cost: usageOf(source, "eco-model-agent", model, usage, "ecotexte") };
    }),
  };
}
