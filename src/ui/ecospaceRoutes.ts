// Routes de l'IHM EcoSpace (servie par le serveur ontoÉthique) : espace 3D d'un écosystème de connaissances, grille
// hexagonale (coordonnées cube et géographiques) et placement des éléments ontologiques ; la création, la liaison et la
// modification des items passent par les routes d'EcoNetwork
import http from "http";
import fs from "fs";
import crypto from "crypto";
import path from "path";
import type { Omk } from "../lib/omeka/omk";
import type { OntoEthiqueConfig } from "../config/ontoethique";
import { omekaWebBase } from "../lib/omeka/proxy";
import { buildTemplateForm, itemPayload, TIMESTAMP, type FormValue } from "../lib/omeka/templateForm";
import { linkableTypes, toWritable, writeValues } from "../lib/omeka/network";
import { cubeDistance, gridHexes, hexKey, hexToPlane, inGrid, nearestFree, planeToGeo, planeToHex, ringsFor, subGrid, type GridSpec } from "../lib/ecospace/hex";
import { interiorLayout, layoutConcepts } from "../lib/ecospace/concepts";
import { checkPower, powerTypeOf } from "../lib/ontoethique/omekaForms";

type Handler = (req: http.IncomingMessage, res: http.ServerResponse, url: URL) => Promise<void> | void;
interface Ctx {
  root: string;
  publicDir: string;
  readEnv: () => Record<string, string>;
  config: () => OntoEthiqueConfig;
  serverOmk: () => Promise<Omk>;
  sendJson: (res: http.ServerResponse, status: number, data: unknown) => void;
  readBody: (req: http.IncomingMessage) => Promise<any>;
}
// concept (forme libre) : q, r, s = hexagone où il a été ajouté ; sa géométrie est calculée à chaque lecture
interface Placement { item: number; q: number; r: number; s: number; shape: string; placed: string }
// members : emplacements des personnes et agents sur la sous-grille de chaque actant (actant → membre → q, r)
// powerLinks : élément connecté sur un hexagone d'un nanotube (pouvoir → « maillon|item » → segment seg, hexagone j, k) ;
// seg = clé du segment calculée par la page (« type|de|vers », ou nanotube enfant « type|segment@j,k|vers »)
interface Attach { seg: string; j: number; k: number }
interface Space { eco: number; created: string; grid: GridSpec; placements: Placement[]; members?: Record<string, Record<string, { q: number; r: number }>>;
  powerLinks?: Record<string, Record<string, Attach>> }

const itemId = (v: unknown) => { const n = Number(v); if (!Number.isInteger(n) || n <= 0) throw new Error("Identifiant d'item invalide"); return n; };
const text = (v: unknown, max = 500) => String(v ?? "").slice(0, max).trim();
const num = (v: unknown, name: string) => { const n = Number(v); if (!Number.isFinite(n)) throw new Error(`Coordonnée ${name} invalide`); return n; };
const int = (v: unknown, name: string) => { const n = Number(v); if (!Number.isInteger(n)) throw new Error(`Coordonnée ${name} invalide`); return n; };

export function ecospaceRoutes(ctx: Ctx): Record<string, Handler> {
  const cfg = () => ctx.config().ecospace;
  const dir = () => path.join(ctx.root, cfg().dir);
  const file = (eco: number) => path.join(dir(), `${eco}.json`);
  const load = (eco: number): Space | null => { try { return JSON.parse(fs.readFileSync(file(eco), "utf-8")); } catch { return null; } };
  const save = (s: Space) => { fs.mkdirSync(dir(), { recursive: true }); fs.writeFileSync(file(s.eco), JSON.stringify(s, null, 2)); schedulePublish(s.eco); };

  // copie du fichier de l'espace dans Omeka S, média de l'item écosystème (omekaMedia) : envoi différé et regroupé,
  // ignoré si le contenu n'a pas changé (sha256), nouveau média déposé avant le retrait des anciennes versions ; un
  // échec n'interrompt rien
  const mediaCfg = () => cfg().omekaMedia ?? { enabled: false };
  const mediaId = (eco: number) => `${mediaCfg().identifierPrefix ?? "ecospace-"}${eco}`;
  const timers = new Map<number, NodeJS.Timeout>();
  // état de la dernière copie, affiché par la page : { ok, media?, error?, at, pending? (envoi programmé) }
  const copyState = new Map<number, { ok: boolean; media?: number | null; error?: string; at?: string; pending?: boolean }>();
  const schedulePublish = (eco: number) => {
    if (!mediaCfg().enabled) return;
    clearTimeout(timers.get(eco));
    timers.set(eco, setTimeout(() => { timers.delete(eco); publish(eco).catch(e => console.warn(`⚠️ EcoSpace : copie de l'espace ${eco} dans Omeka S impossible`, e.message)); }, Number(mediaCfg().delay) || 3000));
    copyState.set(eco, { ...(copyState.get(eco) ?? { ok: true }), pending: true });
  };
  // médias de l'écosystème qui portent la copie de son espace
  const spaceMedia = async (omk: Omk, eco: number) => {
    const item = await omk.request(omk.url(`items/${eco}`));
    const medias = await Promise.all((item["o:media"] ?? []).map((m: any) => omk.request(omk.url(`media/${m["o:id"]}`)).catch(() => null)));
    return medias.filter((m: any) => (m?.["dcterms:identifier"] ?? []).some((v: any) => v["@value"] === mediaId(eco)));
  };
  const publish = (eco: number) => publishNow(eco).then(r => { copyState.set(eco, { ok: true, media: r.id, at: new Date().toISOString() }); return r; },
    (e: Error) => { copyState.set(eco, { ok: false, error: e.message, at: new Date().toISOString() }); throw e; });
  const publishNow = async (eco: number) => {
    if (!fs.existsSync(file(eco))) return { id: null, created: false };
    const buffer = fs.readFileSync(file(eco)), sha256 = crypto.createHash("sha256").update(buffer).digest("hex");
    const omk = await ctx.serverOmk();
    const old = await spaceMedia(omk, eco);
    const same = old.find((m: any) => m["o:sha256"] === sha256);
    if (same) return { id: same["o:id"], created: false };
    const [pt, pi] = await Promise.all([propId(omk, "dcterms:title"), propId(omk, "dcterms:identifier")]);
    const m = await omk.request(omk.url("media"), "POST", {
      "o:ingester": "upload", file_index: "0", "o:item": { "o:id": eco },
      "dcterms:title": [{ type: "literal", property_id: pt, "@value": mediaCfg().title ?? "EcoSpace : positions des éléments" }],
      "dcterms:identifier": [{ type: "literal", property_id: pi, "@value": mediaId(eco) }],
    }, { buffer, fileName: `${mediaId(eco)}.json`, type: "application/json" }).catch((e: Error) => {
      // Omeka S n'accepte que les types et extensions de sa liste blanche (le type est déduit du contenu)
      if (/Cannot store files/.test(e.message)) throw new Error("Omeka S refuse les fichiers JSON : ajouter le type « application/json » et l'extension « json » aux listes autorisées (Omeka S > Administration > Paramètres > Sécurité)");
      throw e;
    });
    for (const o of old) await omk.deleteResource(o["o:id"], "media").catch(e => console.warn(`⚠️ EcoSpace : ancienne copie ${o["o:id"]} non supprimée`, e.message));
    console.log(`📤 [OMEKA] EcoSpace : positions de l'écosystème ${eco} enregistrées (média ${m["o:id"]}${old.length ? `, remplace ${old.map((o: any) => o["o:id"]).join(", ")}` : ""})`);
    return { id: m["o:id"] as number, created: true };
  };
  // espace absent en local : restauré depuis sa copie dans Omeka S (si elle existe)
  const restore = async (omk: Omk, eco: number): Promise<Space | null> => {
    if (!mediaCfg().enabled) return null;
    const m = (await spaceMedia(omk, eco).catch(() => []))[0];
    if (!m?.["o:original_url"]) return null;
    const res = await fetch(m["o:original_url"], { signal: AbortSignal.timeout(15000) });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const s = await res.json() as Space;
    if (s?.eco !== eco || !s.grid || !Array.isArray(s.placements)) throw new Error("copie invalide");
    fs.mkdirSync(dir(), { recursive: true }); fs.writeFileSync(file(eco), JSON.stringify(s, null, 2));
    console.log(`📥 [OMEKA] EcoSpace : espace de l'écosystème ${eco} restauré depuis le média ${m["o:id"]}`);
    return s;
  };
  const omekaBase = () => ctx.readEnv().OMKS_API_URL?.replace(/\/api\/?$/, "") ?? "";
  const omekaFrame = () => { const w = omekaWebBase(ctx.readEnv().OMKS_API_URL); return ctx.config().econetwork.omekaProxy && w?.path ? w.path : omekaBase(); };
  const shapeOf = (templateId: number | null) => cfg().shapes.find(s => s.templateId === templateId) ?? null;
  // couche d'une forme : un hexagone reçoit un élément par couche (actant dessous, physique dessus)
  const layerOf = (key: string) => { const sh = cfg().shapes.find(s => s.key === key); return sh?.layer ?? key; };
  const ecoItem = async (omk: Omk, eco: number) => {
    const item = await omk.request(omk.url(`items/${eco}`));
    if (item["o:resource_template"]?.["o:id"] !== ctx.config().econetwork.ecoTemplateId) throw new Error(`L'item ${eco} n'est pas un écosystème de connaissances`);
    return item;
  };
  // grille d'un nouvel espace : réglages de la configuration, contrôlés
  const newGrid = (): GridSpec => {
    const g = cfg().grid;
    const radius = Math.min(30, Math.max(1, Math.round(g.radius))), hexSize = Math.max(0.1, Number(g.hexSize) || 10);
    return { radius, hexSize, orientation: g.orientation === "flat" ? "flat" : "pointy", origin: { lon: Number(g.origin.lon) || 0, lat: Number(g.origin.lat) || 0, alt: Number(g.origin.alt) || 0 } };
  };
  const physShape = () => cfg().shapes.find(x => x.key === "physique");
  const conceptShape = () => cfg().shapes.find(x => x.key === "concept");
  const isFree = (key: string) => !!cfg().shapes.find(x => x.key === key)?.free;
  // relation entre concepts gérée par cet écosystème : annotée par lui (ecoProperty), ou sans annotation d'écosystème
  // (saisie à la main) ; une relation annotée par d'autres écosystèmes seulement est ignorée et conservée
  const ecoProp = () => ctx.config().econetwork.ecoProperty as string;
  const managed = (v: any, eco: number) => { const a = v?.["@annotation"]?.[ecoProp()]; return !a?.length || a.some((x: any) => x.value_resource_id === eco); };
  const conceptIds = (s: Space) => s.placements.filter(p => p.shape === "concept").map(p => p.item);
  const fetchItems = async (omk: Omk, ids: number[]) =>
    new Map<number, any>(await Promise.all([...new Set(ids)].map(async id => [id, await omk.request(omk.url(`items/${id}`)).catch(() => null)] as [number, any])));
  // parent de chaque concept placé : skos:broader du concept, ou skos:narrower d'un autre concept placé (relations
  // gérées) ; s'il y en a plusieurs, le plus petit identifiant
  const parents = (s: Space, items: Map<number, any>) => {
    const sh = conceptShape()!, ids = new Set(conceptIds(s)), out = new Map<number, number | null>();
    const refs = (it: any, term: string) => (it?.[term] ?? []).filter((v: any) => managed(v, s.eco) && ids.has(v.value_resource_id)).map((v: any) => v.value_resource_id as number);
    for (const id of ids) {
      const cands = [...refs(items.get(id), sh.broaderTerm), ...[...ids].filter(o => o !== id && refs(items.get(o), sh.narrowerTerm).includes(id))].filter(c => c !== id);
      out.set(id, cands.sort((a, b) => a - b)[0] ?? null);
    }
    return out;
  };
  const conceptAncestors = (par: Map<number, number | null>, id: number) => {
    const out = new Set<number>();
    for (let q = par.get(id) ?? null; q != null && !out.has(q); q = par.get(q) ?? null) out.add(q);
    return out;
  };
  // bulles calculées : taille d'après le titre ou les enfants, position équilibrée entre frères
  // exclude : concepts hors de la disposition sous la grille (dans l'intériorité d'un actant)
  const layoutParams = (s: Space) => { const sh = conceptShape()!; return { S: s.grid.hexSize, charWidth: sh.charWidth, labelHeight: sh.labelHeight, leafRadius: sh.leafRadius,
    padding: sh.padding, spacing: sh.spacing, topDepth: sh.topDepth, maxLabel: sh.maxLabel ?? 40 }; };
  const layout = (s: Space, items: Map<number, any>, exclude: Set<number> = new Set()) => {
    const par = parents(s, items);
    return layoutConcepts(conceptIds(s).filter(id => !exclude.has(id)).map(id => ({ item: id, title: String(items.get(id)?.["o:title"] ?? `Item ${id}`), parent: par.get(id) ?? null })), layoutParams(s));
  };

  // pouvoirs : items du template powerTemplateId rattachés à l'écosystème ; type reconnu d'après l'item du vocabulaire
  // des types (son titre) ; maillons dans l'ordre de la séquence du type (un même terme sert plusieurs maillons dans
  // l'ordre de ses valeurs)
  const forms = () => ctx.config().omekaForms;
  const powerShape = () => cfg().shapes.find(x => x.power);
  const stepKey = (name: string) => name.split(" ")[0]!;
  const stepTemplate = (key: string) => forms().templates.find(t => t.key === key)?.templateId;
  const typeTitles = new Map<number, string>();
  const readPowers = async (omk: Omk, s: Space) => {
    const f = forms(), sh = powerShape(), out: any[] = [];
    if (!sh) return out;
    const list = await omk.request(omk.url("items", { resource_template_id: f.powerTemplateId, "property[0][property]": ecoProp(), "property[0][type]": "res",
      "property[0][text]": s.eco, per_page: 500 })).catch(() => []);
    for (const it of list) {
      const tv = it[f.powerTypeTerm]?.[0];
      let typeTitle = tv?.["@value"] ?? tv?.display_title ?? "";
      if (!typeTitle && tv?.value_resource_id) {
        if (!typeTitles.has(tv.value_resource_id)) typeTitles.set(tv.value_resource_id, String((await omk.request(omk.url(`items/${tv.value_resource_id}`)).catch(() => null))?.["o:title"] ?? ""));
        typeTitle = typeTitles.get(tv.value_resource_id);
      }
      const type = powerTypeOf(String(typeTitle), ctx.config());
      if (!type) continue;
      // maillons : chaque lien va au maillon que nomme son annotation (roleTerm), sinon par ordre des valeurs ; un maillon
      // peut relier plusieurs éléments (members), le premier forme la chaîne principale
      const roleT = sh.roleTerm ?? "dcterms:type", links = s.powerLinks?.[it["o:id"]] ?? {};
      const steps: any[] = type.sequence.map(st => ({ name: st.name, key: stepKey(st.name), term: st.term, members: [] as any[] }));
      for (const term of new Set(type.sequence.map(x => x.term))) {
        const idx = steps.map((x, i) => x.term === term ? i : -1).filter(i => i >= 0);
        let k = 0;
        for (const v of (it[term] ?? []).filter((x: any) => x.value_resource_id)) {
          const role = v["@annotation"]?.[roleT]?.[0]?.["@value"];
          let i = idx.find(i => steps[i].name === role);
          if (i == null) i = idx[Math.min(k++, idx.length - 1)]!;
          steps[i].members.push({ item: v.value_resource_id, title: v.display_title ?? null, attach: links[`${steps[i].name}|${v.value_resource_id}`] ?? null });
        }
      }
      for (const x of steps) Object.assign(x, { item: x.members[0]?.item ?? null, title: x.members[0]?.title ?? null });
      const raw = Number(it[f.intensity.term]?.[0]?.["@value"]);
      out.push({ item: it["o:id"], title: String(it["o:title"] ?? `Pouvoir ${it["o:id"]}`), type: type.id, typeLabel: type.label, intensity: Number.isFinite(raw) ? raw : null,
        color: sh.colors?.[type.id] ?? sh.color, interior: (sh.interior ?? []).includes(type.id), steps });
    }
    return out;
  };
  // intériorité : concept placé → actants placés qui l'hébergent (tous les actants des pouvoirs qui le désignent)
  const hostSets = (s: Space, powers: any[]) => {
    const concepts = new Set(conceptIds(s)), actants = new Set(s.placements.filter(p => p.shape === "actant").map(p => p.item));
    const host = new Map<number, Set<number>>();
    for (const pw of powers) {
      const as = pw.steps.filter((x: any) => x.key === "actant").flatMap((x: any) => x.members.map((m: any) => m.item)).filter((a: number) => actants.has(a));
      if (!as.length) continue;
      for (const st of pw.steps) if (st.key === "concept") for (const m of st.members) if (concepts.has(m.item)) {
        const h = host.get(m.item) ?? new Set<number>(); as.forEach((a: number) => h.add(a)); host.set(m.item, h);
      }
    }
    return host;
  };
  // pulsations : items du template de la forme pulse rattachés à l'écosystème ; pouvoirs (powerTerm) et flux vers
  // d'autres pulsations (fluxTerm), chacun avec sa temporalité (annotation : ordre relatif, ordre successif)
  const pulseShape = () => cfg().shapes.find(x => x.pulse);
  const temporality = (v: any, sh: any) => {
    const a = v?.["@annotation"] ?? {}, r = a[sh.relativeTerm]?.[0], o = Number(a[sh.successiveTerm]?.[0]?.["@value"]);
    return { relative: r ? { id: r.value_resource_id ?? null, title: String(r.display_title ?? r["@value"] ?? "") } : null, order: Number.isFinite(o) ? o : null };
  };
  const readPulsations = async (omk: Omk, s: Space) => {
    const sh = pulseShape();
    if (!sh) return [];
    const list = await omk.request(omk.url("items", { resource_template_id: sh.templateId, "property[0][property]": ecoProp(), "property[0][type]": "res",
      "property[0][text]": s.eco, per_page: 500 })).catch(() => []);
    return (list as any[]).map(it => ({ item: it["o:id"] as number, title: String(it["o:title"] ?? `Pulsation ${it["o:id"]}`),
      powers: (it[sh.powerTerm] ?? []).filter((v: any) => v.value_resource_id).map((v: any) => ({ item: v.value_resource_id, ...temporality(v, sh) })),
      flux: (it[sh.fluxTerm] ?? []).filter((v: any) => v.value_resource_id).map((v: any) => ({ to: v.value_resource_id, title: v.display_title ?? null, ...temporality(v, sh) })) }));
  };
  // temporalités relatives proposées (vocabulaire de l'annotation du flux)
  const relatives = async (omk: Omk) => {
    const sh = pulseShape();
    if (!sh) return [];
    const form = await buildTemplateForm(omk, sh.templateId).catch(() => null);
    const f: any = form?.fields.find(x => x.term === sh.fluxTerm), dt = f?.annotation?.find((x: any) => x.term === sh.relativeTerm)?.dataTypes?.find((d: any) => d.kind === "item");
    return (dt?.options ?? []).map((o: any) => ({ id: o.id, title: o.title, type: dt.type }));
  };
  // valeur de lien annotée par sa temporalité (ordre relatif : item du vocabulaire, ordre successif : entier)
  const timedValue = async (omk: Omk, term: string, type: string, id: number, rel: any, order: number | null) => {
    const sh = pulseShape()!, ann: any = {};
    if (rel) ann[sh.relativeTerm] = [{ type: rel.type, property_id: await propId(omk, sh.relativeTerm), value_resource_id: rel.id }];
    if (order != null) ann[sh.successiveTerm] = [{ type: "numeric:integer", property_id: await propId(omk, sh.successiveTerm), "@value": order }];
    return { type, property_id: await propId(omk, term), value_resource_id: id, ...(Object.keys(ann).length ? { "@annotation": ann } : {}) };
  };
  // rattachement d'un concept à un parent (null : détaché) : ses relations gérées avec les concepts de l'espace sont
  // remplacées (broaderTerm sur l'enfant, narrowerTerm sur le parent), les nouvelles annotées par l'écosystème
  const setParent = async (omk: Omk, s: Space, child: number, parent: number | null) => {
    const sh = conceptShape()!, ep = ecoProp(), ids = new Set([...conceptIds(s), child, ...(parent ? [parent] : [])]);
    const [pn, pb, pe] = await Promise.all([sh.narrowerTerm, sh.broaderTerm, ep].map(t => propId(omk, t)));
    const annotation = { [ep]: [{ type: "resource:item", property_id: pe, value_resource_id: s.eco }] };
    const link = (pid: number, target: number) => ({ type: "resource:item", property_id: pid, value_resource_id: target, "@annotation": annotation });
    const changes: string[] = [];
    const items = await fetchItems(omk, [...ids]);
    for (const [id, it] of items) {
      if (!it) continue;
      // sur l'enfant : skos:broader vers les concepts de l'espace ; sur les autres : skos:narrower vers l'enfant
      const [term, pid, target, drops] = id === child
        ? [sh.broaderTerm, pb, parent, (v: any) => ids.has(v.value_resource_id)] as const
        : [sh.narrowerTerm, pn, id === parent ? child : null, (v: any) => v.value_resource_id === child] as const;
      const vals: any[] = it[term] ?? [], drop = vals.filter(v => managed(v, s.eco) && drops(v));
      const had = new Set(drop.map(v => v.value_resource_id as number));
      if (!drop.length && target == null) continue;
      await writeValues(omk, id, { [term]: [...vals.filter(v => !drop.includes(v)).map(toWritable), ...(target != null ? [link(pid!, target)] : [])] });
      for (const x of had) if (x !== target) changes.push(`− ${id} ${term} ${x}`);
      if (target != null && !had.has(target)) changes.push(`+ ${id} ${term} ${target}`);
    }
    if (changes.length) console.log(`📤 [OMEKA] EcoSpace : hiérarchie des concepts de l'écosystème ${s.eco} (${changes.join(" ; ")})`);
    return changes;
  };
  // ajout d'un concept à l'espace (sans géométrie : elle est calculée) ; hexagone d'origine conservé pour mémoire
  const addConcept = (s: Space, item: number, hex: { q: number; r: number }) => {
    if (s.placements.some(p => p.item === item)) return;
    s.placements.push({ item, q: hex.q, r: hex.r, s: -hex.q - hex.r || 0, shape: "concept", placed: new Date().toISOString() });
  };
  const firstValue = (item: any, term: string) => (item?.[term] ?? []).find((v: any) => v["@value"] != null)?.["@value"] ?? null;
  // nœud physique : dates (création : createdTerm, sinon o:created ; modification : o:modified), importance, enfants
  // (physiques qui le désignent par parentTerm), lus récursivement jusqu'à maxDepth ; seen évite les cycles
  const physNode = async (omk: Omk, item: any, depth: number, seen: Set<number>): Promise<any> => {
    const sh = physShape()!;
    const id = item["o:id"];
    seen.add(id);
    const node: any = {
      id, title: String(item["o:title"] ?? `Item ${id}`), depth,
      created: firstValue(item, sh.createdTerm) ?? item["o:created"]?.["@value"] ?? null, createdFromRecord: !firstValue(item, sh.createdTerm),
      modified: item["o:modified"]?.["@value"] ?? item["o:created"]?.["@value"] ?? null,
      importance: Math.max(0, Number(firstValue(item, sh.importanceTerm) ?? 1) || 0), children: [],
      image: await firstImage(omk, item),
    };
    if (depth >= sh.maxDepth) return node;
    const kids = await omk.request(omk.url("items", { "property[0][property]": sh.parentTerm, "property[0][type]": "res", "property[0][text]": id,
      resource_template_id: sh.templateId, sort_by: "title", per_page: 200 })).catch(() => []);
    for (const k of kids as any[]) if (!seen.has(k["o:id"])) node.children.push(await physNode(omk, k, depth + 1, seen));
    return node;
  };
  // premier média image d'un item (texture du physique) : identifiant du média, servi par /api/ecospace/image
  const firstImage = async (omk: Omk, item: any): Promise<number | null> => {
    if (!(item["o:media"] ?? []).length) return null;
    const media = await omk.request(omk.url("media", { item_id: item["o:id"], per_page: 50 })).catch(() => []);
    const m = (media as any[]).find(x => String(x["o:media_type"] ?? "").startsWith("image/") && (x["o:original_url"] || x["o:thumbnail_urls"]?.large));
    return m ? m["o:id"] : null;
  };
  // physiques ancêtres d'un item (par parentTerm) : contrôle des cycles à la liaison d'un enfant
  const ancestors = async (omk: Omk, id: number) => {
    const out = new Set<number>(), term = physShape()!.parentTerm;
    let queue = [id];
    for (let d = 0; d < 20 && queue.length; d++) {
      const items = await Promise.all(queue.map(x => omk.request(omk.url(`items/${x}`)).catch(() => null)));
      queue = items.flatMap((it: any) => (it?.[term] ?? []).map((v: any) => v.value_resource_id).filter((x: any) => x && !out.has(x)));
      queue.forEach(x => out.add(x));
    }
    return out;
  };
  // lien prévu par le resource template d'un item (propriété term acceptant le template templateId) : seul lien que
  // « lier » peut créer depuis cet item
  const requireLink = async (omk: Omk, item: number, term: string, templateId: number, what: string) => {
    const opts = await linkableTypes(omk, item, ctx.config().econetwork as any);
    if (!opts.some(o => o.term === term && o.types.some(t => t.templateId === templateId))) throw new Error(`Le modèle de l'item ${item} ne prévoit pas ce lien (${term} vers ${what})`);
  };
  const propId = async (omk: Omk, term: string) => {
    const p = (await omk.request(omk.url("properties", { term })))[0];
    if (!p) throw new Error(`Propriété ${term} absente de l'instance Omeka S`);
    return p["o:id"] as number;
  };

  // personnes et agents : membres des actants placés (anchorTerm de l'actant), sur la sous-grille de son hexagone ;
  // emplacement attribué à la première lecture (premier libre depuis le centre), conservé dans l'espace (members)
  const memberShapes = () => cfg().shapes.filter(x => x.anchor === "actant");
  // views : placements renvoyés à la page ; chaque actant y reçoit sa sous-grille (sub : taille, orientation, slots)
  const membersView = async (omk: Omk, s: Space, items: any[], views: any[]) => {
    const act = cfg().shapes.find(x => x.key === "actant"), ms = memberShapes(), out: any[] = [];
    if (!act || !ms.length) return out;
    const keep: NonNullable<Space["members"]> = {};
    for (const [i, p] of s.placements.entries()) {
      if (p.shape !== "actant" || !items[i]) continue;
      const ids: { id: number; shape: any }[] = [];
      for (const sh of ms) for (const v of items[i][sh.anchorTerm] ?? []) if (v.value_resource_id && !ids.some(x => x.id === v.value_resource_id)) ids.push({ id: v.value_resource_id, shape: sh });
      // le sous-hexagone central reste à l'actant (centroïde de son fullerène, pôle de sa sphère, titre)
      const rings = ringsFor(ids.length + 1, act.subRings ?? 2), sg = subGrid(s.grid, rings, act.subMargin ?? 0.95);
      const free = sg.slots.filter(h => h.q || h.r);
      views[i].sub = { size: sg.size, orientation: sg.orientation, rings, slots: sg.slots.map(h => ({ q: h.q, r: h.r, s: h.s, x: h.x, z: h.z })) };
      if (!ids.length) continue;
      const old = s.members?.[p.item] ?? {}, slots: Record<string, { q: number; r: number }> = {};
      for (const m of ids) { const h = old[m.id]; if (h && (h.q || h.r) && cubeDistance({ q: 0, r: 0, s: 0 }, { ...h, s: -h.q - h.r }) <= rings) slots[m.id] = h; }
      const used = new Set(Object.values(slots).map(hexKey));
      for (const m of ids) if (!slots[m.id]) { const f = free.find(h => !used.has(hexKey(h)))!; slots[m.id] = { q: f.q, r: f.r }; used.add(hexKey(f)); }
      keep[p.item] = slots;
      const its = await Promise.all(ids.map(m => omk.request(omk.url(`items/${m.id}`)).catch(() => null)));
      const c = hexToPlane(s.grid, p);
      ids.forEach((m, j) => {
        const h = slots[m.id]!, o = sg.slots.find(x => x.q === h.q && x.r === h.r)!, radius = sg.size * (m.shape.memberRatio ?? 0.8);
        const sphereRadius = radius * (m.shape.sphereRatio ?? 1);
        // centre du fullerène sur le plan de la grille : moitié au-dessus, moitié en dessous
        const x = c.x + o.x, z = c.z + o.z;
        out.push({ item: m.id, shape: m.shape.key, actant: p.item, anchorTerm: m.shape.anchorTerm, q: p.q, r: p.r, s: p.s, sub: { q: h.q, r: h.r, s: -h.q - h.r || 0 }, subSize: sg.size, subRings: rings,
          subOrientation: sg.orientation, x, y: 0, z, radius, sphereRadius, title: its[j]?.["o:title"] ?? `Item ${m.id} (introuvable)`, missing: !its[j],
          templateId: its[j]?.["o:resource_template"]?.["o:id"] ?? null, geo: { center: planeToGeo(s.grid, { x, z }), base: planeToGeo(s.grid, { x, z }), sphereCenter: planeToGeo(s.grid, { x, z }, -sphereRadius) } });
      });
    }
    if (JSON.stringify(keep) !== JSON.stringify(s.members ?? {})) { s.members = keep; save(s); }
    return out;
  };

  // espace lu pour la page : hexagones (cube, scène, géographie) et éléments placés (titre et template lus dans Omeka S)
  const view = async (omk: Omk, s: Space) => {
    const hexes = gridHexes(s.grid).map(h => { const p = hexToPlane(s.grid, h); return { ...h, ...p, geo: planeToGeo(s.grid, p) }; });
    const items = await Promise.all(s.placements.map(p => omk.request(omk.url(`items/${p.item}`)).catch(() => null)));
    const placements = s.placements.map((p, i) => {
      const it = items[i], plane = hexToPlane(s.grid, p), shape = cfg().shapes.find(x => x.key === p.shape);
      // géographie de la forme : centroïde du fullerène (centre de l'hexagone) et centre de la sphère (sous le centroïde)
      const sphereY = -(shape?.sphereRadius ?? 0) * s.grid.hexSize;
      return { ...p, title: it?.["o:title"] ?? `Item ${p.item} (introuvable)`, missing: !it, templateId: it?.["o:resource_template"]?.["o:id"] ?? null,
        geo: p.shape === "actant" ? { centroid: planeToGeo(s.grid, plane), sphereCenter: planeToGeo(s.grid, plane, sphereY) } : { base: planeToGeo(s.grid, plane) } } as any;
    });
    // concepts : bulles calculées (hiérarchie lue dans Omeka S) ; hexagone = celui au-dessus du centre ; liés
    // (relatedTerm) affichés dans les détails
    const sh = conceptShape(), [powers, pulsations, pulseRelatives] = await Promise.all([readPowers(omk, s), readPulsations(omk, s), relatives(omk)]), host = sh ? hostSets(s, powers) : new Map<number, Set<number>>();
    if (sh) {
      const byId = new Map(s.placements.map((p, i) => [p.item, items[i]]));
      const bubbles = layout(s, byId, new Set(host.keys())), ids = new Set(conceptIds(s));
      // intériorité : concepts regroupés par ensemble d'actants hôtes, chaque groupe empilé sous le centre de ses hôtes
      // (milieu de plusieurs actants : intersection de leurs sphères, comme un diagramme de Venn) ; chaque sphère grandit
      // jusqu'à contenir les capsules de ses groupes (pôle nord toujours au centroïde du fullerène)
      const act = cfg().shapes.find(x => x.key === "actant"), S = s.grid.hexSize, pad = (powerShape()?.interiorPadding ?? 0.08) * S, base = (act?.sphereRadius ?? 1) * S;
      const groups = new Map<string, { hosts: number[]; items: number[] }>();
      for (const [id, h] of host) { const hosts = [...h].sort((a, b) => a - b), key = hosts.join(","); const g = groups.get(key) ?? { hosts, items: [] }; g.items.push(id); groups.set(key, g); }
      const need = new Map<number, number>(), inside = new Map<number, number[]>();
      const at = (a: number) => hexToPlane(s.grid, placements.find(p => p.item === a && p.shape === "actant")!);
      for (const g of groups.values()) {
        const cs = g.hosts.map(a => ({ a, ...at(a) })), cx = cs.reduce((t, c) => t + c.x, 0) / cs.length, cz = cs.reduce((t, c) => t + c.z, 0) / cs.length;
        const dmax = Math.max(...cs.map(c => Math.hypot(c.x - cx, c.z - cz)));
        const lay = interiorLayout(g.items.map(id => ({ item: id, title: String(byId.get(id)?.["o:title"] ?? `Item ${id}`) })), layoutParams(s), 0);
        const top = Math.max(...lay.bubbles.map(b => b.y + b.radius)), bottom = Math.min(...lay.bubbles.map(b => b.y - b.radius));
        // centre du groupe : sous les hôtes, assez bas pour que la capsule du haut reste sous les pôles
        const yc = Math.min(-Math.max(base, dmax), -(top + pad * 2)) - (top + bottom) / 2;
        for (const b of lay.bubbles) {
          Object.assign(b, { x: cx + b.x, y: yc + b.y, z: cz + b.z });
          const l = Math.max(0, b.length / 2 - b.radius), rr = b.radius + pad;
          // rayon minimal d'une sphère de centre (hx, -R, hz) qui contient les deux extrémités de l'axe à rr près
          for (const c of cs) for (const ex of [b.x - l, b.x + l]) {
            const dh = Math.hypot(ex - c.x, b.z - c.z), y = b.y;
            if (-y - rr > 0) need.set(c.a, Math.max(need.get(c.a) ?? base, (dh * dh + y * y - rr * rr) / (-2 * (y + rr))));
          }
          for (const c of cs) inside.set(c.a, [...(inside.get(c.a) ?? []), b.item]);
          bubbles.set(b.item, Object.assign(b, { inActant: g.hosts[0], hosts: g.hosts }));
        }
      }
      for (const [a, R0] of need) {
        const av = placements.find(p => p.item === a && p.shape === "actant")!, R = Math.max(base, R0) + pad;
        Object.assign(av, { sphereRadius: R, interior: inside.get(a) ?? [] });
        av.geo.sphereCenter = planeToGeo(s.grid, at(a), -R);
      }
      for (const p of placements.filter(x => x.shape === "concept")) {
        const b = bubbles.get(p.item)!, h = planeToHex(s.grid, b);
        Object.assign(p, b, { q: h.q, r: h.r, s: h.s, narrower: b.children, geo: { center: planeToGeo(s.grid, { x: b.x, z: b.z }, b.y) },
          related: (byId.get(p.item)?.[sh.relatedTerm] ?? []).map((v: any) => v.value_resource_id).filter((x: any) => ids.has(x)) });
      }
    }
    placements.push(...await membersView(omk, s, items, placements));
    // physiques : arbre des enfants (la position verticale dépend de l'échelle temporelle, calculée par la page)
    await Promise.all(placements.map(async (p, i) => { if (p.shape === "physique" && items[i]) (p as any).tree = await physNode(omk, items[i], 0, new Set()); }));
    // types de pouvoir pour la page : libellé court, séquence (maillons et forme de chacun)
    const powerTypes = forms().powerTypes.map(t => ({ id: t.id, label: ctx.config().powers.find(x => x.id === t.id)?.label ?? t.label, longLabel: t.label,
      sequence: t.sequence.map(st => ({ name: st.name, key: stepKey(st.name), term: st.term, templateId: stepTemplate(stepKey(st.name)) })) }));
    return { eco: s.eco, created: s.created, grid: s.grid, hexes, placements, powers, pulsations, pulseRelatives, powerTypes, map: cfg().map, omekaCopy: copyState.get(s.eco) ?? null, shapes: cfg().shapes, timeScale: cfg().timeScale, maxDuplicates: cfg().maxDuplicates ?? 20, now: new Date().toISOString(),
      omekaBase: omekaBase(), omekaFrame: omekaFrame() };
  };
  // élément d'un maillon de pouvoir ({ existing } | { title }) : physiques (racines ou boîtes intérieures d'un physique
  // placé) et actants existants et placés ; cribles et concepts existants ou créés (repris par titre) ; rattaché à
  // l'écosystème ; un concept est ajouté à l'espace
  const resolveStep = async (omk: Omk, s: Space, eco: number, name: string, v: any) => {
    const key = stepKey(name), tid = stepTemplate(key), ecoPid = await propId(omk, ecoProp());
    if (!tid) throw new Error(`Maillon ${name} : template inconnu (omekaForms.templates)`);
    let item: any;
    if (v?.existing != null) {
      item = await omk.request(omk.url(`items/${itemId(v.existing)}`));
      if (item["o:resource_template"]?.["o:id"] !== tid) throw new Error(`Maillon ${name} : l'item ${item["o:id"]} n'est pas du bon type`);
    } else {
      const title = text(v?.title);
      if (!title) throw new Error(`Maillon ${name} : élément ou titre attendu`);
      if (key !== "crible" && key !== "concept") throw new Error(`Maillon ${name} : choisir un élément placé`);
      item = (await omk.request(omk.url("items", { resource_template_id: tid, "property[0][property]": "dcterms:title", "property[0][type]": "eq", "property[0][text]": title })))[0];
      if (!item) {
        const sf = await buildTemplateForm(omk, tid);
        item = await omk.request(omk.url("items"), "POST", { ...itemPayload(sf, { [sf.titleTerm]: [{ type: "literal", value: title }] }),
          [ecoProp()]: [{ type: "resource:item", property_id: ecoPid, value_resource_id: eco }] });
        console.log(`📤 [OMEKA] EcoSpace : ${key} ${item["o:id"]} créé pour un pouvoir`);
      }
    }
    const id = item["o:id"] as number;
    const placed = s.placements.some(p => p.item === id && p.shape === key)
      || (key === "physique" && [...await ancestors(omk, id)].some(a => s.placements.some(p => p.item === a && p.shape === "physique")));
    if ((key === "physique" || key === "actant") && !placed) throw new Error(`Maillon ${name} : « ${item["o:title"]} » doit d'abord être placé dans l'espace`);
    if (!(item[ecoProp()] ?? []).some((x: any) => x.value_resource_id === eco))
      await writeValues(omk, id, { [ecoProp()]: [...(item[ecoProp()] ?? []).map(toWritable), { type: "resource:item", property_id: ecoPid, value_resource_id: eco }] });
    if (key === "concept") addConcept(s, id, s.placements.find(p => p.shape === "actant") ?? { q: 0, r: 0 });
    return item;
  };
  // lien d'un pouvoir vers un élément, annoté par le nom de son maillon (roleTerm)
  const roleValue = async (omk: Omk, term: string, id: number, name: string) => {
    const roleT = powerShape()?.roleTerm ?? "dcterms:type";
    return { type: "resource:item", property_id: await propId(omk, term), value_resource_id: id,
      "@annotation": { [roleT]: [{ type: "literal", property_id: await propId(omk, roleT), "@value": name }] } };
  };
  const json = (fn: (req: http.IncomingMessage, url: URL) => Promise<unknown>): Handler => async (req, res, url) => {
    try { ctx.sendJson(res, 200, await fn(req, url)); } catch (e) { ctx.sendJson(res, 400, { error: (e as Error).message }); }
  };

  return {
    "GET /ecospace": (_req, res) => {
      res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
      res.end(fs.readFileSync(path.join(ctx.publicDir, "ecospace.html")));
    },

    // espace d'un écosystème ({ exists: false } tant que sa grille n'est pas créée)
    // image d'un média (texture d'un physique), relayée par le serveur : même origine pour WebGL ; seule une adresse
    // de l'instance Omeka S configurée est lue (vignette « large » de préférence, sinon l'original)
    "GET /api/ecospace/image": async (_req, res, url) => {
      try {
        const omk = await ctx.serverOmk();
        const m = await omk.request(omk.url(`media/${itemId(url.searchParams.get("media"))}`));
        if (!String(m["o:media_type"] ?? "").startsWith("image/")) throw new Error("Ce média n'est pas une image");
        const src = new URL(m["o:thumbnail_urls"]?.large ?? m["o:original_url"]);
        if (src.host !== new URL(ctx.readEnv().OMKS_API_URL).host) throw new Error("Image hors de l'instance Omeka S");
        const r = await fetch(src);
        const type = r.headers.get("content-type") ?? "";
        if (!r.ok || !type.startsWith("image/")) throw new Error(`Image indisponible (HTTP ${r.status})`);
        res.writeHead(200, { "Content-Type": type, "Cache-Control": "private, max-age=3600" });
        res.end(Buffer.from(await r.arrayBuffer()));
      } catch (e) { ctx.sendJson(res, 404, { error: (e as Error).message }); }
    },

    "GET /api/ecospace/space": json(async (_req, url) => {
      const eco = itemId(url.searchParams.get("eco"));
      const omk = await ctx.serverOmk();
      const s = load(eco) ?? await restore(omk, eco).catch(e => { console.warn(`⚠️ EcoSpace : restauration de l'espace ${eco} impossible`, e.message); return null; });
      if (!s) return { exists: false, eco, grid: newGrid() };
      return { exists: true, ...(await view(omk, s)) };
    }),

    // copie immédiate du fichier de l'espace dans Omeka S ({ eco }) : { id, created } (created : false si inchangé)
    "POST /api/ecospace/publish": json(async req => {
      const eco = itemId((await ctx.readBody(req)).eco);
      if (!load(eco)) throw new Error("Espace inexistant");
      clearTimeout(timers.get(eco)); timers.delete(eco);
      return await publish(eco);
    }),

    // création de l'espace d'un écosystème : grille hexagonale (repris s'il existe déjà)
    "POST /api/ecospace/space": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco);
      const omk = await ctx.serverOmk();
      await ecoItem(omk, eco);
      let s = load(eco);
      if (!s) {
        s = { eco, created: new Date().toISOString(), grid: newGrid(), placements: [] };
        save(s);
        console.log(`🧭 EcoSpace : grille de l'écosystème ${eco} créée (${gridHexes(s.grid).length} hexagones)`);
      }
      return { exists: true, ...(await view(omk, s)) };
    }),

    // origine géographique de la grille ({ eco, lon, lat, alt? }) : centre de l'hexagone (0, 0) ; les coordonnées
    // géographiques de tous les hexagones et éléments en découlent (planeToGeo), les positions dans la scène ne changent pas
    "POST /api/ecospace/origin": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco), s = load(eco);
      if (!s) throw new Error("Espace inexistant : créer d'abord sa grille");
      const lon = num(b.lon, "longitude"), lat = num(b.lat, "latitude"), alt = b.alt == null || b.alt === "" ? s.grid.origin.alt ?? 0 : num(b.alt, "altitude");
      if (Math.abs(lon) > 180 || Math.abs(lat) > 90) throw new Error("Longitude (−180 à 180) ou latitude (−90 à 90) hors limites");
      const old = s.grid.origin;
      s.grid.origin = { lon: +lon.toFixed(7), lat: +lat.toFixed(7), alt: +alt.toFixed(2) };
      save(s);
      console.log(`🧭 EcoSpace : origine de l'écosystème ${eco} : ${old.lon}, ${old.lat} → ${s.grid.origin.lon}, ${s.grid.origin.lat} (alt. ${s.grid.origin.alt} m)`);
      return { exists: true, ...(await view(await ctx.serverOmk(), s)) };
    }),

    // placement d'un élément ({ eco, item, q, r } ou { eco, item, near: { q, r } } = hexagone libre le plus proche) ;
    // un hexagone porte un élément par couche de forme (actant sous la grille et physique au-dessus peuvent cohabiter) ;
    // un élément déjà placé est déplacé ; la forme dépend du template de l'item
    "POST /api/ecospace/place": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco), id = itemId(b.item);
      const s = load(eco);
      if (!s) throw new Error("Espace inexistant : créer d'abord sa grille");
      const omk = await ctx.serverOmk();
      const item = await omk.request(omk.url(`items/${id}`));
      const shape = shapeOf(item["o:resource_template"]?.["o:id"] ?? null);
      if (!shape) throw new Error(`Pas de forme définie pour le modèle « ${item["o:resource_template"] ? `template ${item["o:resource_template"]["o:id"]}` : "sans modèle"} »`);
      if (shape.power) throw new Error(`${shape.label} : à créer depuis le premier élément de sa chaîne (menu lier)`);
      if (shape.pulse) throw new Error(`${shape.label} : à créer depuis un pouvoir (menu lier du nanotube)`);
      if (shape.anchor) throw new Error(`${shape.label} : à ajouter depuis un ${shape.anchor} (menu lier de l'${shape.anchor})`);
      // concept : ajouté à l'espace ; sa bulle (taille, position) est calculée d'après sa hiérarchie
      if (shape.free) {
        const hex = b.near ? { q: int(b.near.q, "q"), r: int(b.near.r, "r") } : { q: int(b.q, "q"), r: int(b.r, "r") };
        if (!inGrid(s.grid, hex)) throw new Error("Hexagone hors de la grille");
        addConcept(s, id, hex);
        save(s);
        console.log(`🧭 EcoSpace : concept ${id} ajouté à l'écosystème ${eco}`);
        return await view(omk, s);
      }
      const layer = layerOf(shape.key);
      const taken = new Set(s.placements.filter(p => p.item !== id && !isFree(p.shape) && layerOf(p.shape) === layer).map(hexKey));
      let hex: { q: number; r: number } | null;
      if (b.near) { const q = int(b.near.q, "q"), r = int(b.near.r, "r"); hex = nearestFree(s.grid, { q, r, s: -q - r }, taken); if (!hex) throw new Error("Grille pleine"); }
      else hex = { q: int(b.q, "q"), r: int(b.r, "r") };
      if (!inGrid(s.grid, hex)) throw new Error("Hexagone hors de la grille");
      if (taken.has(hexKey(hex))) throw new Error(`Hexagone déjà occupé (couche ${layer})`);
      s.placements = [...s.placements.filter(p => p.item !== id), { item: id, q: hex.q, r: hex.r, s: -hex.q - hex.r || 0, shape: shape.key, placed: new Date().toISOString() }];
      save(s);
      console.log(`🧭 EcoSpace : ${shape.label} ${id} placé en (${hex.q}, ${hex.r}, ${-hex.q - hex.r || 0}) dans l'écosystème ${eco}`);
      return view(omk, s);
    }),

    // physique : nouvel item ({ eco, parent?, title, created?, importance? }) ou item existant ({ eco, parent, existing })
    // rattaché à l'écosystème ; parent = physique dont il devient l'enfant (parentTerm) ; un physique de même titre et de
    // même parent est repris au lieu d'être recréé
    "POST /api/ecospace/physique": json(async req => {
      const b = await ctx.readBody(req);
      const sh = physShape();
      if (!sh) throw new Error("Forme physique absente de ecospace.shapes");
      const eco = itemId(b.eco), parent = b.parent != null ? itemId(b.parent) : null;
      const omk = await ctx.serverOmk();
      const ecoProp = ctx.config().econetwork.ecoProperty;
      if (parent) {
        const p = await omk.request(omk.url(`items/${parent}`));
        if (p["o:resource_template"]?.["o:id"] !== sh.templateId) throw new Error("Le parent n'est pas un élément physique");
        await requireLink(omk, parent, sh.parentTerm, sh.templateId, "un physique");
      }
      const form = await buildTemplateForm(omk, sh.templateId);
      const parentType = form.fields.find(f => f.term === sh.parentTerm)?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
      const ecoType = form.fields.find(f => f.term === ecoProp)?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
      let child: any, created = false;
      if (b.existing != null) {
        child = await omk.request(omk.url(`items/${itemId(b.existing)}`));
        if (child["o:resource_template"]?.["o:id"] !== sh.templateId) throw new Error("L'item choisi n'est pas un élément physique");
      } else {
        const title = text(b.title);
        if (!title) throw new Error("Titre obligatoire");
        child = (await omk.searchItemsByProp("dcterms:title", title, `resource_template_id=${sh.templateId}`))
          .find((i: any) => parent ? (i[sh.parentTerm] ?? []).some((v: any) => v.value_resource_id === parent) : !(i[sh.parentTerm] ?? []).length);
        if (!child) {
          const values: Record<string, FormValue[]> = { [form.titleTerm]: [{ type: "literal", value: title }] };
          const date = text(b.created, 40);
          if (date) { if (!TIMESTAMP.test(date)) throw new Error("Date de création : AAAA, AAAA-MM-JJ ou AAAA-MM-JJTHH:MM:SS"); values[sh.createdTerm] = [{ type: "numeric:timestamp", value: date }]; }
          if (b.importance != null && b.importance !== "") values[sh.importanceTerm] = [{ type: "numeric:integer", value: String(Math.round(Number(b.importance)) || 0) }];
          const payload: any = itemPayload(form, values);
          payload[ecoProp] = [{ type: ecoType, property_id: await propId(omk, ecoProp), value_resource_id: eco }];
          if (parent) payload[sh.parentTerm] = [{ type: parentType, property_id: await propId(omk, sh.parentTerm), value_resource_id: parent }];
          child = await omk.request(omk.url("items"), "POST", payload);
          created = true;
        }
      }
      const id = child["o:id"];
      if (!created) {
        const writes: Record<string, any[]> = {};
        if (!(child[ecoProp] ?? []).some((v: any) => v.value_resource_id === eco))
          writes[ecoProp] = [...(child[ecoProp] ?? []).map(toWritable), { type: ecoType, property_id: await propId(omk, ecoProp), value_resource_id: eco }];
        if (parent && !(child[sh.parentTerm] ?? []).some((v: any) => v.value_resource_id === parent)) {
          if (parent === id || (await ancestors(omk, parent)).has(id)) throw new Error("Un physique ne peut pas être contenu dans lui-même ou dans l'un de ses enfants");
          writes[sh.parentTerm] = [...(child[sh.parentTerm] ?? []).map(toWritable), { type: parentType, property_id: await propId(omk, sh.parentTerm), value_resource_id: parent }];
        }
        if (Object.keys(writes).length) await writeValues(omk, id, writes);
      }
      console.log(`📤 [OMEKA] EcoSpace : physique ${created ? "créé" : "repris"} ${id}${parent ? ` dans ${parent}` : ""}`);
      return { id, title: String(child["o:title"] ?? b.title), created };
    }),

    // retrait d'un élément de l'espace ({ eco, item }) : l'item reste dans Omeka S
    "POST /api/ecospace/unplace": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco), id = itemId(b.item);
      const s = load(eco);
      if (!s) throw new Error("Espace inexistant");
      // un concept retiré garde ses relations dans Omeka S ; ses enfants deviennent des racines de l'espace
      s.placements = s.placements.filter(p => p.item !== id);
      save(s);
      return await view(await ctx.serverOmk(), s);
    }),

    // pouvoir ({ eco, type, intensity, title?, steps }) : steps = un maillon par élément de la séquence du type, chacun
    // { existing } | { title } ou une liste (relations multiples) ; physiques (racines ou boîtes intérieures) et actants
    // existants et placés ; cribles et concepts existants ou créés (repris s'ils existent avec ce titre), rattachés à
    // l'écosystème, concepts ajoutés à l'espace ; item pouvoir créé (type = item du vocabulaire des types, intensité,
    // liens annotés par leur maillon : roleTerm), contrôlé par checkPower ; une branche est un autre pouvoir de même type
    "POST /api/ecospace/power": json(async req => {
      const b = await ctx.readBody(req);
      const f = forms(), type = f.powerTypes.find(t => t.id === b.type);
      if (!type) throw new Error(`Type attendu : ${f.powerTypes.map(t => t.id).join(", ")}`);
      const eco = itemId(b.eco), s = load(eco);
      if (!s) throw new Error("Espace inexistant");
      const steps: any[] = Array.isArray(b.steps) ? b.steps : [];
      if (steps.length !== type.sequence.length) throw new Error(`${type.label} : ${type.sequence.length} maillons attendus (${type.sequence.map(x => x.name).join(" → ")})`);
      const omk = await ctx.serverOmk();
      const form = await buildTemplateForm(omk, f.powerTemplateId);
      const chosen: { name: string; term: string; id: number; title: string }[] = [];
      for (const [i, st] of type.sequence.entries()) {
        const vs = (Array.isArray(steps[i]) ? steps[i] : [steps[i]]).filter(Boolean);
        if (!vs.length) throw new Error(`Maillon ${st.name} : élément attendu`);
        for (const v of vs) { const it = await resolveStep(omk, s, eco, st.name, v); chosen.push({ name: st.name, term: st.term, id: it["o:id"], title: String(it["o:title"] ?? it["o:id"]) }); }
      }
      // type : item du vocabulaire des types dont le titre désigne ce type
      const tf = form.fields.find(x => x.term === f.powerTypeTerm);
      const tdt = tf?.dataTypes.find(d => d.kind === "item");
      const opt = (tdt as any)?.options?.find((o: any) => powerTypeOf(o.title, ctx.config())?.id === type.id);
      const intensity = Math.round(Number(b.intensity ?? 0));
      const main = type.sequence.map(st => chosen.find(c => c.name === st.name)!.title);
      const values: Record<string, FormValue[]> = {
        [form.titleTerm]: [{ type: "literal", value: text(b.title) || `${ctx.config().powers.find(x => x.id === type.id)?.label ?? type.label} : ${main.join(" → ")}` }],
        [f.intensity.term]: [{ type: "literal", value: String(intensity) }],
        [f.powerTypeTerm]: opt ? [{ type: tdt!.type, id: opt.id, label: opt.title }] : [{ type: "literal", value: type.label }],
      };
      for (const c of chosen) (values[c.term] ??= []).push({ type: "resource:item", id: c.id });
      checkPower(values, ctx.config());
      const payload: any = itemPayload(form, values);
      // liens annotés par leur maillon (le rôle distingue concept source et destination, et les relations multiples)
      for (const term of new Set(chosen.map(c => c.term))) payload[term] = await Promise.all(chosen.filter(c => c.term === term).map(c => roleValue(omk, term, c.id, c.name)));
      payload[ecoProp()] = [{ type: "resource:item", property_id: await propId(omk, ecoProp()), value_resource_id: eco }];
      const power = await omk.request(omk.url("items"), "POST", payload);
      save(s);
      console.log(`📤 [OMEKA] EcoSpace : pouvoir ${power["o:id"]} (${type.label}) créé : ${chosen.map(c => `${c.name} ${c.title}`).join(" ; ")}`);
      return { id: power["o:id"], title: power["o:title"] };
    }),

    // élément connecté à un pouvoir ({ eco, power, step, existing | title, attach? }) : step = nom du maillon ; attach =
    // hexagone du nanotube où il se branche ({ seg, j, k } : clé du segment, ligne et rang de l'hexagone) ; le lien est ajouté
    // au pouvoir avec son rôle (relation multiple), l'hexagone mémorisé dans l'espace (powerLinks)
    "POST /api/ecospace/power/link": json(async req => {
      const b = await ctx.readBody(req);
      const f = forms(), eco = itemId(b.eco), powerId = itemId(b.power), s = load(eco);
      if (!s) throw new Error("Espace inexistant");
      const omk = await ctx.serverOmk();
      const power = await omk.request(omk.url(`items/${powerId}`));
      if (power["o:resource_template"]?.["o:id"] !== f.powerTemplateId) throw new Error("L'item n'est pas un pouvoir");
      const tv = power[f.powerTypeTerm]?.[0];
      const type = powerTypeOf(String(tv?.["@value"] ?? tv?.display_title ?? (tv?.value_resource_id ? (await omk.request(omk.url(`items/${tv.value_resource_id}`)))["o:title"] : "")), ctx.config());
      const st = type?.sequence.find(x => x.name === b.step);
      if (!type || !st) throw new Error(`Maillon attendu : ${type?.sequence.map(x => x.name).join(", ") ?? "type de pouvoir inconnu"}`);
      const it = await resolveStep(omk, s, eco, st.name, b);
      const id = it["o:id"] as number, roleT = powerShape()?.roleTerm ?? "dcterms:type", vals: any[] = power[st.term] ?? [];
      const exists = vals.some(v => v.value_resource_id === id && (v["@annotation"]?.[roleT]?.[0]?.["@value"] ?? st.name) === st.name);
      if (!exists) await writeValues(omk, powerId, { [st.term]: [...vals.map(toWritable), await roleValue(omk, st.term, id, st.name)] });
      const a = b.attach;
      if (a && /^[\w|@,.:-]{1,400}$/.test(String(a.seg ?? "")) && [a.j, a.k].every(x => Number.isInteger(Number(x)) && Number(x) >= 0)) {
        ((s.powerLinks ??= {})[powerId] ??= {})[`${st.name}|${id}`] = { seg: String(a.seg), j: Number(a.j), k: Number(a.k) };
      }
      save(s);
      console.log(`📤 [OMEKA] EcoSpace : ${st.name} ${id} connecté au pouvoir ${powerId}${a?.seg ? ` (hexagone ${a.j}, ${a.k} du segment ${a.seg})` : ""}`);
      return { id, title: it["o:title"], added: !exists };
    }),

    // pulsation d'un pouvoir ({ eco, power, existing | title }) : pulsation créée (rattachée à l'écosystème) ou reprise
    // parmi celles de l'écosystème ; le pouvoir y est ajouté (powerTerm)
    "POST /api/ecospace/pulsation": json(async req => {
      const b = await ctx.readBody(req), sh = pulseShape();
      if (!sh) throw new Error("Aucune forme de pulsation dans la configuration (ecospace.shapes)");
      const eco = itemId(b.eco), powerId = itemId(b.power), s = load(eco);
      if (!s) throw new Error("Espace inexistant");
      const omk = await ctx.serverOmk();
      if (!(await readPowers(omk, s)).some(p => p.item === powerId)) throw new Error("Ce pouvoir n'est pas dessiné dans cet espace");
      const form = await buildTemplateForm(omk, sh.templateId);
      const itemType = (term: string) => form.fields.find(f => f.term === term)?.dataTypes.find(d => d.kind === "item" && !d.type.startsWith("customvocab"))?.type ?? "resource:item";
      let item: any, created = false;
      if (b.existing != null) {
        item = await omk.request(omk.url(`items/${itemId(b.existing)}`));
        if (item["o:resource_template"]?.["o:id"] !== sh.templateId || !(item[ecoProp()] ?? []).some((v: any) => v.value_resource_id === eco)) throw new Error("L'item choisi n'est pas une pulsation de cet écosystème");
      } else {
        const title = text(b.title);
        if (!title) throw new Error("Titre obligatoire");
        item = await omk.request(omk.url("items"), "POST", { ...itemPayload(form, { [form.titleTerm]: [{ type: "literal", value: title }] }),
          [ecoProp()]: [{ type: itemType(ecoProp()), property_id: await propId(omk, ecoProp()), value_resource_id: eco }] });
        created = true;
      }
      const id = item["o:id"] as number, vals: any[] = item[sh.powerTerm] ?? [];
      const added = !vals.some(v => v.value_resource_id === powerId);
      if (added) await writeValues(omk, id, { [sh.powerTerm]: [...vals.map(toWritable), await timedValue(omk, sh.powerTerm, itemType(sh.powerTerm), powerId, null, vals.length + 1)] });
      console.log(`📤 [OMEKA] EcoSpace : pulsation ${id} ${created ? "créée" : "reprise"}${added ? `, pouvoir ${powerId} ajouté` : ""}`);
      return { id, title: item["o:title"], created, added };
    }),

    // flux d'une pulsation vers une autre pulsation de l'écosystème ({ eco, pulsation, to, relative?, order? }) : lien
    // fluxTerm annoté par sa temporalité (relative : item des temporalités relatives ; order : ordre successif) ; un flux
    // existant vers la même pulsation est remplacé
    "POST /api/ecospace/pulsation/flux": json(async req => {
      const b = await ctx.readBody(req), sh = pulseShape();
      if (!sh) throw new Error("Aucune forme de pulsation dans la configuration (ecospace.shapes)");
      const eco = itemId(b.eco), from = itemId(b.pulsation), to = itemId(b.to), s = load(eco);
      if (!s) throw new Error("Espace inexistant");
      if (from === to) throw new Error("Un flux relie deux pulsations différentes");
      const omk = await ctx.serverOmk(), pls = await readPulsations(omk, s);
      if (![from, to].every(id => pls.some(p => p.item === id))) throw new Error("Les deux pulsations doivent appartenir à cet écosystème");
      const rel = b.relative == null || b.relative === "" ? null : (await relatives(omk)).find((r: any) => r.id === Number(b.relative));
      if (b.relative != null && b.relative !== "" && !rel) throw new Error("Ordre relatif inconnu");
      const order = b.order == null || b.order === "" ? null : int(b.order, "ordre successif");
      const form = await buildTemplateForm(omk, sh.templateId);
      const type = form.fields.find(f => f.term === sh.fluxTerm)?.dataTypes.find(d => d.kind === "item" && !d.type.startsWith("customvocab"))?.type ?? "resource:item";
      const item = await omk.request(omk.url(`items/${from}`)), vals: any[] = item[sh.fluxTerm] ?? [];
      await writeValues(omk, from, { [sh.fluxTerm]: [...vals.filter(v => v.value_resource_id !== to).map(toWritable), await timedValue(omk, sh.fluxTerm, type, to, rel, order)] });
      console.log(`📤 [OMEKA] EcoSpace : flux ${from} → ${to}${rel ? ` (${rel.title}${order != null ? `, ${order}` : ""})` : order != null ? ` (${order})` : ""}`);
      return { from, to };
    }),

    // personne ou agent d'un actant placé ({ eco, actant, shape, title } ou { …, existing }) : item créé (rattaché à
    // l'écosystème) ou repris, désigné par l'actant (anchorTerm) ; il apparaît sur la sous-grille de l'actant
    "POST /api/ecospace/member": json(async req => {
      const b = await ctx.readBody(req);
      const sh = memberShapes().find(x => x.key === b.shape);
      if (!sh) throw new Error("Type attendu : personne ou agent");
      const eco = itemId(b.eco), actantId = itemId(b.actant);
      const s = load(eco);
      if (!s?.placements.some(x => x.item === actantId && x.shape === "actant")) throw new Error("Actant non placé dans cet espace");
      const omk = await ctx.serverOmk();
      await requireLink(omk, actantId, sh.anchorTerm, sh.templateId, sh.label.toLowerCase());
      const form = await buildTemplateForm(omk, sh.templateId);
      const ecoType = form.fields.find(f => f.term === ecoProp())?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
      let item: any, created = false;
      if (b.existing != null) {
        item = await omk.request(omk.url(`items/${itemId(b.existing)}`));
        if (item["o:resource_template"]?.["o:id"] !== sh.templateId) throw new Error(`L'item choisi n'est pas un(e) ${sh.label.toLowerCase()}`);
        if (!(item[ecoProp()] ?? []).some((v: any) => v.value_resource_id === eco))
          await writeValues(omk, item["o:id"], { [ecoProp()]: [...(item[ecoProp()] ?? []).map(toWritable), { type: ecoType, property_id: await propId(omk, ecoProp()), value_resource_id: eco }] });
      } else {
        const title = text(b.title);
        if (!title) throw new Error("Titre obligatoire");
        item = await omk.request(omk.url("items"), "POST", { ...itemPayload(form, { [form.titleTerm]: [{ type: "literal", value: title }] }),
          [ecoProp()]: [{ type: ecoType, property_id: await propId(omk, ecoProp()), value_resource_id: eco }] });
        created = true;
      }
      const id = item["o:id"] as number, actant = await omk.request(omk.url(`items/${actantId}`));
      const vals: any[] = actant[sh.anchorTerm] ?? [];
      if (!vals.some(v => v.value_resource_id === id)) {
        const aForm = await buildTemplateForm(omk, actant["o:resource_template"]?.["o:id"]).catch(() => null);
        const type = aForm?.fields.find(f => f.term === sh.anchorTerm)?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
        await writeValues(omk, actantId, { [sh.anchorTerm]: [...vals.map(toWritable), { type, property_id: await propId(omk, sh.anchorTerm), value_resource_id: id }] });
      }
      console.log(`📤 [OMEKA] EcoSpace : ${sh.label.toLowerCase()} ${id} ${created ? "créé(e)" : "repris(e)"} pour l'actant ${actantId} (${sh.anchorTerm})`);
      return { id, created };
    }),

    // concept parent ou enfant d'un concept placé ({ eco, item, as: "parent" | "child", title } ou { …, existing }) :
    // concept créé (rattaché à l'écosystème) ou repris, ajouté à l'espace s'il n'y est pas ; la hiérarchie est écrite
    // dans Omeka S (relations annotées par l'écosystème), les bulles sont recalculées. Un parent ajouté à un concept qui
    // en avait déjà un s'intercale entre les deux
    "POST /api/ecospace/concept/relate": json(async req => {
      const b = await ctx.readBody(req);
      const sh = conceptShape();
      if (!sh) throw new Error("Forme concept absente de ecospace.shapes");
      if (b.as !== "parent" && b.as !== "child") throw new Error("Relation attendue : parent ou child");
      const eco = itemId(b.eco), targetId = itemId(b.item);
      const s = load(eco);
      const tp = s?.placements.find(x => x.item === targetId && x.shape === "concept");
      if (!s || !tp) throw new Error("Concept non placé dans cet espace");
      const omk = await ctx.serverOmk();
      // parent : broaderTerm du concept ; enfant : narrowerTerm du concept
      await requireLink(omk, targetId, b.as === "parent" ? sh.broaderTerm : sh.narrowerTerm, sh.templateId, "un concept");
      const form = await buildTemplateForm(omk, sh.templateId);
      const ecoType = form.fields.find(f => f.term === ecoProp())?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
      let other: any, created = false;
      if (b.existing != null) {
        other = await omk.request(omk.url(`items/${itemId(b.existing)}`));
        if (other["o:resource_template"]?.["o:id"] !== sh.templateId) throw new Error("L'item choisi n'est pas un concept");
        if (other["o:id"] === targetId) throw new Error("Un concept ne peut pas être son propre parent");
      } else {
        const title = text(b.title);
        if (!title) throw new Error("Titre obligatoire");
        other = await omk.request(omk.url("items"), "POST", { ...itemPayload(form, { [form.titleTerm]: [{ type: "literal", value: title }] }),
          [ecoProp()]: [{ type: ecoType, property_id: await propId(omk, ecoProp()), value_resource_id: eco }] });
        created = true;
      }
      const otherId = other["o:id"] as number;
      // contrôle des cycles sur la hiérarchie actuelle (concept repris compris)
      addConcept(s, otherId, tp);
      const items = await fetchItems(omk, conceptIds(s)), par = parents(s, items);
      const [child, parent] = b.as === "child" ? [otherId, targetId] : [targetId, otherId];
      // (l'espace n'est enregistré qu'après ce contrôle)
      if (conceptAncestors(par, parent).has(child)) {
        throw new Error(`« ${items.get(child)?.["o:title"]} » contient déjà « ${items.get(parent)?.["o:title"]} » : la relation créerait un cycle`);
      }
      if (!created && !(other[ecoProp()] ?? []).some((v: any) => v.value_resource_id === eco))
        await writeValues(omk, otherId, { [ecoProp()]: [...(other[ecoProp()] ?? []).map(toWritable), { type: ecoType, property_id: await propId(omk, ecoProp()), value_resource_id: eco }] });
      const old = par.get(child) ?? null;
      const changes = await setParent(omk, s, child, parent);
      // parent intercalé : il prend la place de l'enfant sous l'ancien parent
      if (b.as === "parent" && old != null && old !== parent && par.get(parent) == null && !conceptAncestors(par, old).has(parent)) changes.push(...await setParent(omk, s, parent, old));
      save(s);
      console.log(`📤 [OMEKA] EcoSpace : concept ${otherId} ${created ? "créé" : "repris"} comme ${b.as === "child" ? "enfant" : "parent"} du concept ${targetId}`);
      return { id: otherId, created, changes };
    }),

    // détachement d'un concept de son parent ({ eco, item }) : il devient une racine de l'espace
    "POST /api/ecospace/concept/detach": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco), id = itemId(b.item);
      const s = load(eco);
      if (!s?.placements.some(x => x.item === id && x.shape === "concept")) throw new Error("Concept non placé dans cet espace");
      const omk = await ctx.serverOmk();
      const changes = await setParent(omk, s, id, null);
      return { ...(await view(omk, s)), changes };
    }),
  };
}
