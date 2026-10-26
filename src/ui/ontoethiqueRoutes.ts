// Routes du serveur ontoÉthique : évaluations effectuées (archive locale et Omeka S), fichiers, modèle, corrections et
// validations humaines (pulsations, existences, activité), évaluation manuelle, nouvelle synthèse, enregistrement dans Omeka S
import http from "http";
import fs from "fs";
import path from "path";
import crypto from "crypto";
import { containerUrl, type Omk } from "../lib/omeka/omk";
import { RUNS_DIR, type OntoEthiqueConfig } from "../config/ontoethique";
import { writeConfigOverride } from "../config/store";
import { ONTO_FILES, MODEL_FILE, writeModelFiles } from "../lib/ontoethique/outputs";
import { clampScore, emptyModel, slug, type Evaluation, type Existence, type OntoModel, type Origin, type Pulsation, type Revision } from "../lib/ontoethique/model";
import { articleExample } from "../lib/ontoethique/example";
import { adaSynthesis } from "../lib/ontoethique/synthesis";
import { estimateImpact } from "../lib/metrics/impact";
import { appendUsageHistory } from "../lib/metrics/usageHistory";
import type { UsageSummary } from "../lib/metrics/usage";
import { attachDocuments } from "../workflow/runs/importSynthesis";
import { saveWorkflowConfig, updateWorkflowStatus } from "../workflow/runs/saveWorkflowConfig";
import { agentModelId } from "../agents/overrides";

type Handler = (req: http.IncomingMessage, res: http.ServerResponse, url: URL) => Promise<void> | void;
interface Ctx {
  root: string;
  readEnv: () => Record<string, string>;
  config: () => OntoEthiqueConfig;
  defaults: OntoEthiqueConfig;
  configFile: string;
  costs: () => any;
  serverOmk: () => Promise<Omk>;
  sendJson: (res: http.ServerResponse, status: number, data: unknown) => void;
  readBody: (req: http.IncomingMessage) => Promise<any>;
}

const validId = (id: unknown): id is string => typeof id === "string" && /^[\w-]{1,80}$/.test(id);
const text = (v: unknown, max = 4000) => String(v ?? "").slice(0, max).trim();
const list = (v: unknown, max = 60) => (Array.isArray(v) ? v.map(x => text(x, 300)).filter(Boolean).slice(0, max) : []);
const ORIGINS = new Set<Origin>(["agent", "humain", "autoevaluation", "regle"]);

export function ontoEthiqueRoutes(ctx: Ctx): Record<string, Handler> {
  const runsDir = () => path.join(ctx.root, ctx.config().outputDir, RUNS_DIR);
  const runDir = (run: string) => path.join(runsDir(), run);
  const omekaAdmin = () => ctx.readEnv().OMKS_API_URL?.replace(/\/api\/?$/, "/admin/item/") ?? "";
  const readJson = (file: string) => { try { return JSON.parse(fs.readFileSync(file, "utf-8")); } catch { return null; } };

  // ==========================================
  // Évaluations effectuées : archive locale + items de configuration dans Omeka S
  // ==========================================
  function localRuns() {
    if (!fs.existsSync(runsDir())) return [];
    return fs.readdirSync(runsDir()).filter(validId).map(id => {
      const a = readJson(path.join(runDir(id), "analyse.json"));
      if (!a) return null;
      return { runId: a.runId ?? id, mode: a.mode ?? "workflow", status: a.status, startedAt: a.startedAt, endedAt: a.endedAt, activity: a.activity ?? null, collection: a.collection ?? null,
        configItemId: a.configItemId ?? null, tokens: a.tokens ?? null, impact: a.impact ?? null, totals: a.totals ?? null, symbiosis: a.symbiosis ?? null, source: "local" };
    }).filter(Boolean) as any[];
  }

  async function omekaRuns(): Promise<{ runs: any[]; error?: string }> {
    const env = ctx.readEnv();
    if (!env.OMKS_API_URL) return { runs: [], error: "Omeka S non configuré" };
    try {
      const omk = await ctx.serverOmk();
      const items = await omk.getAllItems("property[0][property]=dcterms:type&property[0][type]=eq&property[0][text]=Configuration de workflow&sort_by=created&sort_order=desc");
      const val = (it: any, t: string) => it[t]?.[0]?.["@value"] ?? null;
      const runs: any[] = [];
      for (const it of items) {
        let config: any = {};
        try { config = JSON.parse(val(it, "dcterms:description") ?? "{}"); } catch { /* description illisible */ }
        if (config.workflowId !== ctx.defaults.workflowId) continue;
        let data: any = null;
        try { data = JSON.parse(val(it, "curation:data") ?? "null"); } catch { /* pas de consommation */ }
        runs.push({
          runId: val(it, "dcterms:identifier") ?? `omeka-${it["o:id"]}`, mode: config.mode ?? "workflow",
          status: val(it, "curation:status") ?? "inconnu", startedAt: val(it, "curation:dateStart") ?? val(it, "dcterms:date"), endedAt: val(it, "curation:dateEnd") ?? "",
          activity: config.activity ?? null, collection: config.input?.zoteroCollection ? { key: config.input.zoteroCollection, name: config.collectionName ?? null } : null,
          configItemId: it["o:id"], tokens: data?.tokens ?? null, impact: data?.impact ?? null, totals: null, symbiosis: null, source: "omeka",
        });
      }
      return { runs };
    } catch (e) {
      return { runs: [], error: (e as Error).message };
    }
  }

  // médias d'une exécution dans Omeka S : nom du fichier (fin de dcterms:identifier « <run>/<fichier> ») → média
  const omekaMedia = new Map<string, Map<string, { id: number; url: string }>>();
  async function omekaFiles(run: string, refresh = false) {
    if (refresh || !omekaMedia.has(run)) {
      const omk = await ctx.serverOmk();
      const item = (await omk.searchItemsByProp("dcterms:identifier", run))[0];
      if (!item) throw new Error(`Évaluation ${run} introuvable (ni archive locale, ni configuration dans Omeka S)`);
      const files = new Map<string, { id: number; url: string }>();
      for (const m of await omk.request(omk.url("media", { item_id: item["o:id"], per_page: 100 }))) {
        const name = path.basename(String(m["dcterms:identifier"]?.[0]?.["@value"] ?? ""));
        // le dernier média déposé pour un nom de fichier l'emporte
        if (ONTO_FILES.some(f => f.name === name) && m["o:original_url"] && (files.get(name)?.id ?? 0) < m["o:id"]) files.set(name, { id: m["o:id"], url: m["o:original_url"] });
      }
      omekaMedia.set(run, files);
    }
    return omekaMedia.get(run)!;
  }

  async function readRunFile(run: string, name: string): Promise<Buffer> {
    if (!ONTO_FILES.some(f => f.name === name)) throw new Error("Fichier inconnu");
    if (!validId(run)) throw new Error("Identifiant d'évaluation invalide");
    const local = path.join(runDir(run), name);
    if (fs.existsSync(local)) return fs.readFileSync(local);
    const media = (await omekaFiles(run)).get(name);
    if (!media) throw new Error("Fichier absent de cette évaluation");
    const r = await fetch(containerUrl(media.url));
    if (!r.ok) throw new Error(`Omeka S ${r.status} sur le fichier de l'évaluation`);
    return Buffer.from(await r.arrayBuffer());
  }

  // évaluation modifiable : archive locale, recopiée depuis Omeka S si elle n'existe que là
  async function loadModel(run: string): Promise<OntoModel> {
    if (!validId(run)) throw new Error("Identifiant d'évaluation invalide");
    const dir = runDir(run);
    if (!fs.existsSync(path.join(dir, MODEL_FILE))) {
      const media = await omekaFiles(run);
      fs.mkdirSync(dir, { recursive: true });
      for (const [name] of media) fs.writeFileSync(path.join(dir, name), await readRunFile(run, name));
      if (!fs.existsSync(path.join(dir, "analyse.json"))) {
        const r = (await omekaRuns()).runs.find(x => x.runId === run);
        fs.writeFileSync(path.join(dir, "analyse.json"), JSON.stringify({ ...(r ?? { runId: run }), source: undefined }, null, 2));
      }
      if (!fs.existsSync(path.join(dir, MODEL_FILE))) throw new Error("Cette évaluation n'a pas de modèle (modele.json)");
    }
    return JSON.parse(fs.readFileSync(path.join(dir, MODEL_FILE), "utf-8"));
  }

  // enregistre le modèle modifié (règles, indicateurs, fichiers dérivés) et met à jour la description de l'évaluation
  async function saveModel(model: OntoModel, revision?: Revision) {
    if (revision) model.revisions.push(revision);
    await writeModelFiles(runDir(model.runId), model, ctx.config());
    const file = path.join(runDir(model.runId), "analyse.json");
    const a = readJson(file) ?? { runId: model.runId, mode: model.mode, status: "success", startedAt: model.createdAt };
    fs.writeFileSync(file, JSON.stringify({ ...a, activity: model.activity, endedAt: a.endedAt ?? model.updatedAt, updatedAt: model.updatedAt, totals: model.metrics?.totals ?? null, symbiosis: model.metrics?.symbiosis ?? null, modified: true }, null, 2));
    return model;
  }

  // pulsation reçue de la page : textes bornés, scores entre -100 et 100, origines connues
  function cleanPulsation(p: any, model: OntoModel): Pulsation {
    const config = ctx.config();
    if (!model.existences.some(e => e.id === p?.existence)) throw new Error("Existence inconnue");
    const evaluations: Record<string, Evaluation> = {};
    for (const pw of config.powers) {
      const e = p.evaluations?.[pw.id];
      if (!e) continue;
      const origin: Origin = ORIGINS.has(e.origin) ? e.origin : "humain";
      evaluations[pw.id] = { score: clampScore(e.score), chain: list(e.chain, 8), origin, validated: !!e.validated,
        ...(text(e.justification) ? { justification: text(e.justification) } : {}), ...(text(e.citation) ? { citation: text(e.citation) } : {}) };
    }
    return {
      id: validId(p.id) ? p.id : "", order: Math.max(1, Math.round(Number(p.order) || 1)), moment: text(p.moment, 300) || "Pulsation", existence: p.existence,
      ...(p.document?.title ? { document: { title: text(p.document.title, 300), ...(validId(p.document.zoteroKey) ? { zoteroKey: p.document.zoteroKey } : {}), ...(Number(p.document.omekaItemId) ? { omekaItemId: Number(p.document.omekaItemId) } : {}) } } : {}),
      ...(text(p.date, 40) ? { date: text(p.date, 40) } : {}),
      evaluations, values: Object.fromEntries(config.values.map(v => [v.id, clampScore(p.values?.[v.id])])),
      origin: ORIGINS.has(p.origin) ? p.origin : "humain",
    };
  }

  function cleanExistence(e: any): Existence {
    const config = ctx.config();
    if (!config.kinds.some(k => k.id === e?.kind)) throw new Error("Genre d'existence inconnu");
    const name = text(e.name, 200);
    if (!name) throw new Error("Nom de l'existence manquant");
    return { id: validId(e.id) ? e.id : slug(name), name, kind: e.kind, ...(text(e.description) ? { description: text(e.description) } : {}),
      dimensions: Object.fromEntries(config.dimensions.map(d => [d.id, list(e.dimensions?.[d.id])])), cribles: list(e.cribles), documents: list(e.documents), origin: ORIGINS.has(e.origin) ? e.origin : "humain" };
  }

  const revision = (action: Revision["action"], target: Revision["target"], body: any, before?: unknown, after?: unknown): Revision => ({
    at: new Date().toISOString(), action, target, motivation: body.motivation === "assessing" ? "assessing" : "editing",
    ...(text(body.author, 120) ? { author: text(body.author, 120) } : {}), ...(text(body.note, 1000) ? { note: text(body.note, 1000) } : {}),
    ...(before !== undefined ? { before } : {}), ...(after !== undefined ? { after } : {}),
  });

  // route de modification : modèle chargé, modifié par fn, enregistré, renvoyé
  const edit = (fn: (model: OntoModel, body: any) => Revision | undefined | Promise<Revision | undefined>): Handler => async (req, res) => {
    const body = await ctx.readBody(req);
    try {
      const model = await loadModel(body.run);
      const rev = await fn(model, body);
      ctx.sendJson(res, 200, await saveModel(model, rev));
    } catch (e) {
      ctx.sendJson(res, 400, { error: (e as Error).message });
    }
  };

  return {
    "GET /api/ontoethique/settings": (_req, res) => ctx.sendJson(res, 200, { config: ctx.config(), defaults: ctx.defaults, configFile: path.relative(ctx.root, ctx.configFile) }),
    "POST /api/ontoethique/settings": async (req, res) => {
      const { config } = await ctx.readBody(req);
      ctx.sendJson(res, 200, { ok: true, override: writeConfigOverride(ctx.defaults, config, ctx.configFile) });
    },

    "GET /api/ontoethique/runs": async (_req, res) => {
      const [local, omeka] = [localRuns(), await omekaRuns()];
      // l'archive locale est plus complète (totaux, symbiose, corrections) ; Omeka S apporte les évaluations faites ailleurs
      const byRun = new Map<string, any>();
      for (const r of omeka.runs) byRun.set(r.runId, r);
      for (const r of local) { const o = byRun.get(r.runId); byRun.set(r.runId, { ...o, ...r, configItemId: r.configItemId ?? o?.configItemId ?? null, source: o ? "local+omeka" : "local" }); }
      ctx.sendJson(res, 200, { runs: [...byRun.values()].sort((a, b) => String(b.startedAt).localeCompare(String(a.startedAt))), omekaAdmin: omekaAdmin(), omekaError: omeka.error ?? null });
    },

    // fichiers d'une évaluation : archive locale, sinon médias Omeka S
    "GET /api/ontoethique/results": async (_req, res, url) => {
      const run = url.searchParams.get("run");
      try {
        if (!validId(run)) throw new Error("Identifiant d'évaluation invalide");
        const dir = runDir(run);
        if (fs.existsSync(dir)) {
          return ctx.sendJson(res, 200, ONTO_FILES.filter(f => fs.existsSync(path.join(dir, f.name))).map(f => ({ ...f, size: fs.statSync(path.join(dir, f.name)).size, mtime: fs.statSync(path.join(dir, f.name)).mtimeMs })));
        }
        const media = await omekaFiles(run);
        ctx.sendJson(res, 200, ONTO_FILES.filter(f => media.has(f.name)).map(f => ({ ...f, size: null, mtime: null, omeka: true })));
      } catch (e) { ctx.sendJson(res, 404, { error: (e as Error).message }); }
    },

    "GET /api/ontoethique/file": async (_req, res, url) => {
      const name = url.searchParams.get("name") ?? "";
      let content: Buffer;
      try { content = await readRunFile(url.searchParams.get("run") ?? "", name); }
      catch (e) { return ctx.sendJson(res, 404, { error: (e as Error).message }); }
      // raw=1 : page HTML servie telle quelle (spirales en plein écran) ; sinon en texte
      const raw = url.searchParams.get("raw") === "1" && name.endsWith(".html");
      const type = name.endsWith(".json") || name.endsWith(".jsonld") ? "application/json" : raw ? "text/html" : "text/plain";
      res.writeHead(200, { "Content-Type": `${type}; charset=utf-8` });
      res.end(content);
    },

    "GET /api/ontoethique/model": async (_req, res, url) => {
      const run = url.searchParams.get("run") ?? "";
      try {
        if (!validId(run)) throw new Error("Identifiant d'évaluation invalide");
        ctx.sendJson(res, 200, JSON.parse((await readRunFile(run, MODEL_FILE)).toString("utf-8")));
      } catch (e) { ctx.sendJson(res, 404, { error: (e as Error).message }); }
    },

    // évaluation saisie à la main (sans collection ni modèle de langage) ; example : scénarios A et B de l'article
    "POST /api/ontoethique/manual": async (req, res) => {
      const body = await ctx.readBody(req);
      const config = ctx.config();
      const stamp = new Date().toISOString().replace(/[-:T]/g, "").slice(0, 14);
      const runId = `manuel-${stamp}-${crypto.randomBytes(3).toString("hex")}`;
      const model = body.example ? articleExample(runId, config)
        : emptyModel({ runId, workflowId: config.workflowId, mode: "manuel", activity: { title: text(body.title, 300) || config.activity.title, description: text(body.description) || config.activity.description } });
      fs.mkdirSync(runDir(runId), { recursive: true });
      fs.writeFileSync(path.join(runDir(runId), "analyse.json"), JSON.stringify({ runId, workflowId: config.workflowId, mode: "manuel", status: "success", startedAt: model.createdAt, endedAt: model.createdAt, activity: model.activity, collection: null, configItemId: null }, null, 2));
      await saveModel(model);
      ctx.sendJson(res, 200, { runId, model });
    },

    "POST /api/ontoethique/activity": edit((model, body) => {
      const before = { ...model.activity };
      model.activity = { title: text(body.activity?.title, 300) || model.activity.title, description: text(body.activity?.description) };
      return revision("modification", { type: "activite", id: model.runId }, body, before, model.activity);
    }),

    // ajout ou modification d'une pulsation ({ run, pulsation, author?, note?, motivation? })
    "POST /api/ontoethique/pulsation": edit((model, body) => {
      const p = cleanPulsation(body.pulsation, model);
      const i = model.pulsations.findIndex(x => x.id === p.id);
      if (i < 0) {
        const n = Math.max(0, ...model.pulsations.map(x => Number(/^p(\d+)/.exec(x.id)?.[1] ?? 0))) + 1;
        p.id = `p${n}`;
        if (!body.pulsation.order) p.order = Math.max(0, ...model.pulsations.filter(x => x.existence === p.existence).map(x => x.order)) + 1;
        model.pulsations.push(p);
        return revision("ajout", { type: "pulsation", id: p.id }, body, undefined, p);
      }
      const before = model.pulsations[i];
      model.pulsations[i] = p;
      return revision("modification", { type: "pulsation", id: p.id }, body, before, p);
    }),

    "POST /api/ontoethique/pulsation/delete": edit((model, body) => {
      const i = model.pulsations.findIndex(x => x.id === body.id);
      if (i < 0) throw new Error("Pulsation introuvable");
      const [before] = model.pulsations.splice(i, 1);
      return revision("suppression", { type: "pulsation", id: String(body.id) }, body, before);
    }),

    "POST /api/ontoethique/existence": edit((model, body) => {
      const e = cleanExistence(body.existence);
      const i = model.existences.findIndex(x => x.id === body.existence?.id);
      if (i < 0) {
        let id = e.id, n = 2;
        while (model.existences.some(x => x.id === id)) id = `${e.id}-${n++}`;
        e.id = id;
        model.existences.push(e);
        return revision("ajout", { type: "existence", id: e.id }, body, undefined, e);
      }
      const before = model.existences[i];
      model.existences[i] = { ...e, id: before!.id };
      return revision("modification", { type: "existence", id: before!.id }, body, before, model.existences[i]);
    }),

    // suppression d'une existence et de ses pulsations
    "POST /api/ontoethique/existence/delete": edit((model, body) => {
      const i = model.existences.findIndex(x => x.id === body.id);
      if (i < 0) throw new Error("Existence introuvable");
      const [before] = model.existences.splice(i, 1);
      const removed = model.pulsations.filter(p => p.existence === body.id);
      model.pulsations = model.pulsations.filter(p => p.existence !== body.id);
      return revision("suppression", { type: "existence", id: String(body.id) }, body, { existence: before, pulsations: removed });
    }),

    // nouvelle synthèse de l'ADA à partir de la matrice corrigée ; coût de l'appel
    "POST /api/ontoethique/synthesis": async (req, res) => {
      const body = await ctx.readBody(req);
      try {
        const config = ctx.config();
        const model = await loadModel(body.run);
        if (!model.pulsations.length) throw new Error("Aucune pulsation à interpréter");
        await writeModelFiles(runDir(model.runId), model, config);
        const source = "Nouvelle synthèse (adaAgent)";
        const started = Date.now();
        const { text: synthesis, usage } = await adaSynthesis(model, model.metrics!, config, source);
        const input = Number(usage?.inputTokens ?? usage?.promptTokens ?? 0) || 0, output = Number(usage?.outputTokens ?? usage?.completionTokens ?? 0) || 0;
        const entry = { source, model: agentModelId("ada-agent", config.models.analytics), calls: 1, inputTokens: input, outputTokens: output, reasoningTokens: 0, totalTokens: input + output, unknown: input + output ? 0 : 1 };
        const summary: UsageSummary = { entries: [entry], calls: 1, inputTokens: input, outputTokens: output, reasoningTokens: 0, totalTokens: input + output, unknown: entry.unknown };
        appendUsageHistory("ontoethique", summary, "synthese");
        const impact = estimateImpact(summary, ctx.costs());
        fs.writeFileSync(path.join(runDir(model.runId), "synthese_ada.md"), `# Synthèse onto-éthique – ${model.activity.title}\n\n${synthesis.replace(/^#\s.*\n+/, "")}\n\n_Synthèse rédigée le ${new Date().toLocaleString("fr-FR")} à partir de ${model.metrics!.totals.validated} évaluation(s) validée(s)._\n`);
        ctx.sendJson(res, 200, { synthesis, durationMs: Date.now() - started, tokens: summary.totalTokens, impact: { energyWh: impact.energyWh, co2g: impact.co2g, apiCost: impact.apiCost, currency: impact.currency } });
      } catch (e) { ctx.sendJson(res, 502, { error: (e as Error).message }); }
    },

    // enregistrement dans Omeka S : item de configuration (créé pour une évaluation manuelle), fichiers remplacés
    "POST /api/ontoethique/omeka": async (req, res) => {
      const body = await ctx.readBody(req);
      try {
        const config = ctx.config();
        const model = await loadModel(body.run);
        const file = path.join(runDir(model.runId), "analyse.json");
        const a = readJson(file) ?? {};
        let itemId: number | null = a.configItemId ?? null;
        if (!itemId) {
          itemId = await saveWorkflowConfig(model.runId, { zoteroCollection: model.collection?.key ?? "" }, { workflowId: config.workflowId, config: { ...config, mode: model.mode, activity: model.activity } });
          await updateWorkflowStatus(itemId, "success");
          fs.writeFileSync(file, JSON.stringify({ ...a, configItemId: itemId }, null, 2));
        }
        // nouveaux médias déposés, puis anciens médias des mêmes fichiers retirés : l'item garde la dernière version
        const omk = await ctx.serverOmk();
        const docs = ONTO_FILES.filter(f => fs.existsSync(path.join(runDir(model.runId), f.name))).map(f => ({ filePath: path.join(runDir(model.runId), f.name), title: f.title, type: f.type }));
        const previous = await omekaFiles(model.runId, true).catch(() => new Map<string, { id: number; url: string }>());
        const mediaIds = await attachDocuments(itemId, docs, model.runId, null);
        // un fichier redéposé a un média plus récent : l'ancien est supprimé (un fichier refusé garde son ancien média)
        const current = await omekaFiles(model.runId, true).catch(() => new Map<string, { id: number; url: string }>());
        for (const [name, m] of previous) {
          if (current.get(name) && current.get(name)!.id !== m.id) await omk.deleteResource(m.id, "media").catch(e => console.warn("⚠️ Ancien média non supprimé :", (e as Error).message));
        }
        omekaMedia.delete(model.runId);
        ctx.sendJson(res, 200, { itemId, media: mediaIds.length, adminUrl: omekaAdmin() + itemId });
      } catch (e) { ctx.sendJson(res, 502, { error: (e as Error).message }); }
    },

    // suppression d'une évaluation ({ runId, omeka }) : Omeka S d'abord (rien n'est supprimé si cela échoue), puis archive locale
    "POST /api/ontoethique/runs/delete": async (req, res) => {
      const { runId, omeka } = await ctx.readBody(req);
      try {
        if (!validId(runId)) throw new Error("Identifiant d'évaluation invalide");
        const local = fs.existsSync(runDir(runId));
        let omekaItem: number | null = null;
        if (omeka) {
          const omk = await ctx.serverOmk();
          const item = (await omk.searchItemsByProp("dcterms:identifier", runId)).find((it: any) => {
            try { return JSON.parse(it["dcterms:description"]?.[0]?.["@value"] ?? "{}").workflowId === ctx.defaults.workflowId; } catch { return false; }
          });
          if (item) { await omk.deleteResource(item["o:id"]); omekaItem = item["o:id"]; }
          omekaMedia.delete(runId);
        }
        if (local) fs.rmSync(runDir(runId), { recursive: true, force: true });
        if (!local && !omekaItem) throw new Error(`Évaluation ${runId} introuvable${omeka ? "" : " dans l'archive locale"}`);
        ctx.sendJson(res, 200, { ok: true, local, omekaItem });
      } catch (e) { ctx.sendJson(res, 400, { error: (e as Error).message }); }
    },
  };
}
