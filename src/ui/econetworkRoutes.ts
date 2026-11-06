// Routes de l'IHM EcoNetwork (servie par le serveur ontoÉthique) : écosystèmes, réseau, types liables, liaison d'un
// nouveau nœud, duplication, détail et modification d'un nœud, impact et suppression (réseau ou Omeka S), déliaison
import http from "http";
import crypto from "crypto";
import dns from "dns/promises";
import { isIP } from "net";
import fs from "fs";
import path from "path";
import type { Omk } from "../lib/omeka/omk";
import type { OntoEthiqueConfig } from "../config/ontoethique";
import { buildTemplateForm, itemPayload, type FormValue } from "../lib/omeka/templateForm";
import { deletionImpact, ecoGraph, formValues, itemProperties, linkableTypes, nextTitle, referencing, searchLinkable, toWritable, writeValues } from "../lib/omeka/network";
import { checkPower } from "../lib/ontoethique/omekaForms";
import { omekaWebBase } from "../lib/omeka/proxy";

type Handler = (req: http.IncomingMessage, res: http.ServerResponse, url: URL) => Promise<void> | void;
interface Ctx {
  publicDir: string;
  readEnv: () => Record<string, string>;
  config: () => OntoEthiqueConfig;
  serverOmk: () => Promise<Omk>;
  sendJson: (res: http.ServerResponse, status: number, data: unknown) => void;
  readBody: (req: http.IncomingMessage) => Promise<any>;
}

const itemId = (v: unknown) => { const n = Number(v); if (!Number.isInteger(n) || n <= 0) throw new Error("Identifiant d'item invalide"); return n; };
const validTerm = (t: unknown): t is string => typeof t === "string" && /^[\w-]+:[\w-]+$/.test(t);
const text = (v: unknown, max = 500) => String(v ?? "").slice(0, max).trim();

// adresse d'un média importé par Omeka S : http(s) vers une adresse publique (Omeka S la télécharge lui-même)
const PRIVATE = [/^127\./, /^10\./, /^192\.168\./, /^172\.(1[6-9]|2\d|3[01])\./, /^169\.254\./, /^0\./, /^::1$/, /^f[cd]/i, /^fe80:/i, /^::ffff:(127|10|192\.168|169\.254)\./i];
async function publicUrl(raw: unknown) {
  let u: URL;
  try { u = new URL(String(raw ?? "").trim()); } catch { throw new Error("Adresse du média invalide"); }
  if (!/^https?:$/.test(u.protocol)) throw new Error("Adresse du média : http ou https attendu");
  const host = u.hostname.replace(/^\[|\]$/g, "");
  if (/^localhost$|\.local(host)?$/i.test(host)) throw new Error("Adresse du média : adresse locale refusée");
  const addrs = isIP(host) ? [host] : (await dns.lookup(host, { all: true }).catch(() => { throw new Error(`Adresse du média : hôte ${host} introuvable`); })).map(a => a.address);
  if (addrs.some(a => PRIVATE.some(r => r.test(a)))) throw new Error("Adresse du média : adresse privée refusée");
  return u.toString();
}

// corps brut d'une requête (fichier déposé), limité à max octets
async function readRaw(req: http.IncomingMessage, max: number) {
  const chunks: Buffer[] = [];
  let size = 0;
  for await (const c of req) { size += c.length; if (size > max) throw new Error(`Fichier trop volumineux (${Math.round(max / 1e6)} Mo au plus)`); chunks.push(c as Buffer); }
  return Buffer.concat(chunks);
}

// fiche lisible d'un item (onglet « détails ») : la page d'administration d'Omeka S ne s'ouvre pas dans une iframe
// d'une autre origine (cookie de session non transmis : « Invalid or missing CSRF token » à la connexion)
async function itemDetails(omk: Omk, item: any) {
  const lit = (v: any): any => ({
    type: v.type,
    ...(v.value_resource_id ? { id: v.value_resource_id, text: v.display_title ?? `Item ${v.value_resource_id}` } : v["@id"] && !v["@value"] ? { uri: v["@id"], text: v["o:label"] || v["@id"] } : { text: String(v["@value"] ?? "") }),
    ...(v["@annotation"] ? { annotation: Object.values(v["@annotation"]).flatMap((vs: any) => vs.map((a: any) => `${a.property_label ?? ""} : ${a.display_title ?? a["o:label"] ?? a["@value"] ?? a["@id"] ?? ""}`)) } : {}),
  });
  const [template, rclass] = await Promise.all([
    item["o:resource_template"] ? omk.request(omk.url(`resource_templates/${item["o:resource_template"]["o:id"]}`)).catch(() => null) : null,
    item["o:resource_class"] ? omk.request(omk.url(`resource_classes/${item["o:resource_class"]["o:id"]}`)).catch(() => null) : null,
  ]);
  return {
    template: template?.["o:label"] ?? "", resourceClass: rclass ? `${rclass["o:label"]} (${rclass["o:term"]})` : "",
    itemSets: await Promise.all((item["o:item_set"] ?? []).map((s: any) => omk.request(omk.url(`item_sets/${s["o:id"]}`)).then((x: any) => String(x["o:title"] ?? s["o:id"])).catch(() => String(s["o:id"])))), isPublic: item["o:is_public"] !== false,
    created: item["o:created"]?.["@value"] ?? null, modified: item["o:modified"]?.["@value"] ?? null,
    properties: Object.entries(itemProperties(item)).map(([term, vs]) => ({ term, label: vs[0]?.property_label ?? term, values: vs.map(lit) })),
    media: (item["o:media"] ?? []).length,
  };
}

export function econetworkRoutes(ctx: Ctx): Record<string, Handler> {
  const net = () => ctx.config().econetwork;
  const omekaBase = () => ctx.readEnv().OMKS_API_URL?.replace(/\/api\/?$/, "") ?? "";
  // base de l'iframe « détails » : chemin relayé par le serveur (même origine), sinon l'instance elle-même
  const omekaFrame = () => { const w = omekaWebBase(ctx.readEnv().OMKS_API_URL); return net().omekaProxy && w?.path ? w.path : omekaBase(); };
  const propId = async (omk: Omk, term: string) => {
    const p = (await omk.request(omk.url("properties", { term })))[0];
    if (!p) throw new Error(`Propriété ${term} absente de l'instance Omeka S`);
    return p["o:id"] as number;
  };
  // remplace les valeurs d'une propriété, les autres propriétés de l'item étant conservées
  const setValues = (omk: Omk, id: number, term: string, values: any[]) => writeValues(omk, id, { [term]: values });
  const titleTaken = async (omk: Omk, templateId: number | null, title: string) =>
    (await omk.searchItemsByProp("dcterms:title", title, templateId ? `resource_template_id=${templateId}` : "")).length > 0;
  // route JSON : erreurs renvoyées en 400 avec leur message
  const json = (fn: (req: http.IncomingMessage, url: URL) => Promise<unknown>): Handler => async (req, res, url) => {
    try { ctx.sendJson(res, 200, await fn(req, url)); } catch (e) { ctx.sendJson(res, 400, { error: (e as Error).message }); }
  };

  return {
    "GET /econetwork": (_req, res) => {
      res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
      res.end(fs.readFileSync(path.join(ctx.publicDir, "econetwork.html")));
    },

    // écosystèmes de connaissances (items du template de l'écosystème)
    "GET /api/econetwork/ecos": json(async () => {
      const omk = await ctx.serverOmk();
      const items = await omk.getAllItems(`resource_template_id=${net().ecoTemplateId}&sort_by=title`);
      return { ecoTemplateId: net().ecoTemplateId, ecoProperty: net().ecoProperty, omekaBase: omekaBase(), omekaFrame: omekaFrame(),
        ecos: items.map((i: any) => ({ id: i["o:id"], title: i["o:title"], description: i["dcterms:description"]?.[0]?.["@value"] ?? "", created: i["o:created"]?.["@value"] ?? null })) };
    }),

    "GET /api/econetwork/graph": json(async (_req, url) => ({ ...(await ecoGraph(await ctx.serverOmk(), itemId(url.searchParams.get("eco")), net())), omekaBase: omekaBase(), omekaFrame: omekaFrame() })),

    "GET /api/econetwork/linkable": json(async (_req, url) => linkableTypes(await ctx.serverOmk(), itemId(url.searchParams.get("item")), net())),

    // items existants liables par une propriété du nœud (autocomplétion) : ?parent=&term=&q=
    "GET /api/econetwork/search": json(async (_req, url) => {
      const term = url.searchParams.get("term");
      if (!validTerm(term)) throw new Error("Propriété invalide");
      const q = text(url.searchParams.get("q"), 200);
      if (q.length < 2) return [];
      return searchLinkable(await ctx.serverOmk(), itemId(url.searchParams.get("parent")), term, q, net(), ctx.config().omekaForms.searchLimit);
    }),

    // lien vers un nœud enfant ({ eco, parent, term, templateId, title } ou { eco, parent, term, existing }) : item existant
    // choisi, ou nouvel item (repris s'il existe avec ce titre et ce template) ; rattaché à l'écosystème, puis ajouté aux
    // valeurs de la propriété du parent
    "POST /api/econetwork/link": json(async req => {
      const b = await ctx.readBody(req);
      const eco = itemId(b.eco), parent = itemId(b.parent);
      const omk = await ctx.serverOmk();
      let child: any = null, templateId: number, title: string;
      if (b.existing != null) {
        child = await omk.request(omk.url(`items/${itemId(b.existing)}`));
        templateId = child["o:resource_template"]?.["o:id"];
        title = String(child["o:title"] ?? "");
        if (child["o:id"] === parent) throw new Error("Un nœud ne se lie pas à lui-même");
      } else {
        templateId = itemId(b.templateId); title = text(b.title);
        if (!title) throw new Error("Titre obligatoire");
      }
      const option = (await linkableTypes(omk, parent, net())).find(o => o.term === b.term && o.types.some(t => t.templateId === templateId));
      if (!option) throw new Error("Ce type de nœud ne peut pas être lié par cette propriété");
      const form = await buildTemplateForm(omk, templateId);
      const ecoProp = await propId(omk, net().ecoProperty);
      // type de la valeur d'écosystème : celui du template de l'enfant s'il porte la propriété (custom vocab), sinon item lié
      const ecoType = form.fields.find(f => f.term === net().ecoProperty)?.dataTypes.find(d => d.kind === "item")?.type ?? "resource:item";
      if (!child) child = (await omk.searchItemsByProp(form.titleTerm, title, `resource_template_id=${templateId}`))[0];
      const created = !child;
      if (!child) {
        const payload: any = itemPayload(form, { [form.titleTerm]: [{ type: "literal", value: title }] });
        payload[net().ecoProperty] = [{ type: ecoType, property_id: ecoProp, value_resource_id: eco }];
        child = await omk.request(omk.url("items"), "POST", payload);
      } else if (!(child[net().ecoProperty] ?? []).some((v: any) => v.value_resource_id === eco)) {
        await setValues(omk, child["o:id"], net().ecoProperty, [...(child[net().ecoProperty] ?? []).map(toWritable), { type: ecoType, property_id: ecoProp, value_resource_id: eco }]);
      }
      if (!option.reverse) {
        const p = await omk.request(omk.url(`items/${parent}`));
        const current = (p[option.term] ?? []) as any[];
        if (!current.some(v => v.value_resource_id === child["o:id"])) {
          await setValues(omk, parent, option.term, [...current.map(toWritable), { type: option.dataType, property_id: await propId(omk, option.term), value_resource_id: child["o:id"] }]);
        }
      }
      console.log(`📤 [OMEKA] EcoNetwork : ${created ? "nœud créé" : "nœud existant lié"} ${child["o:id"]} (${title})`);
      return { id: child["o:id"], title, created };
    }),

    // média d'un nœud : fichier déposé (corps brut ; ?item=&name=&title=) — repris s'il est déjà attaché (même empreinte)
    "POST /api/econetwork/media/file": json(async (req, url) => {
      const id = itemId(url.searchParams.get("item"));
      const name = path.basename(text(url.searchParams.get("name"), 200)).replace(/[^\w.\- ()àâäçéèêëîïôöùûüÿœæ]/gi, "_") || "fichier";
      const buffer = await readRaw(req, net().maxMediaMB * 1e6);
      if (!buffer.length) throw new Error("Fichier vide");
      const omk = await ctx.serverOmk();
      const item = await omk.request(omk.url(`items/${id}`));
      const sha256 = crypto.createHash("sha256").update(buffer).digest("hex");
      const medias = await Promise.all((item["o:media"] ?? []).map((m: any) => omk.request(omk.url(`media/${m["o:id"]}`)).catch(() => null)));
      const same = medias.find((m: any) => m?.["o:sha256"] === sha256);
      if (same) return { id: same["o:id"], created: false };
      const title = text(url.searchParams.get("title")) || name;
      const type = String(req.headers["content-type"] ?? "application/octet-stream").split(";")[0];
      const m = await omk.request(omk.url("media"), "POST", {
        "o:ingester": "upload", file_index: "0", "o:item": { "o:id": id },
        "dcterms:title": [{ type: "literal", property_id: await propId(omk, "dcterms:title"), "@value": title }],
      }, { buffer, fileName: name, type });
      console.log(`📤 [OMEKA] EcoNetwork : média ${m["o:id"]} (${name}) ajouté à l'item ${id}`);
      return { id: m["o:id"], created: true };
    }),

    // média d'un nœud importé par Omeka S depuis une adresse ({ item, url, title }) — repris si cette adresse est déjà attachée
    "POST /api/econetwork/media/url": json(async req => {
      const b = await ctx.readBody(req);
      const id = itemId(b.item), source = await publicUrl(b.url);
      const omk = await ctx.serverOmk();
      const item = await omk.request(omk.url(`items/${id}`));
      const medias = await Promise.all((item["o:media"] ?? []).map((m: any) => omk.request(omk.url(`media/${m["o:id"]}`)).catch(() => null)));
      const same = medias.find((m: any) => m?.["o:source"] === source);
      if (same) return { id: same["o:id"], created: false };
      const m = await omk.request(omk.url("media"), "POST", {
        "o:ingester": "url", ingest_url: source, "o:item": { "o:id": id },
        "dcterms:title": [{ type: "literal", property_id: await propId(omk, "dcterms:title"), "@value": text(b.title) || source }],
      });
      console.log(`📤 [OMEKA] EcoNetwork : média ${m["o:id"]} (${source}) ajouté à l'item ${id}`);
      return { id: m["o:id"], created: true };
    }),

    // copie d'un nœud (toutes ses valeurs) sous le titre suivant libre : « titre 2 », « titre 3 »…
    "POST /api/econetwork/duplicate": json(async req => {
      const b = await ctx.readBody(req);
      const omk = await ctx.serverOmk();
      const item = await omk.request(omk.url(`items/${itemId(b.item)}`));
      const templateId = item["o:resource_template"]?.["o:id"] ?? null;
      if (templateId === net().ecoTemplateId) throw new Error("Dupliquer un écosystème : créer un nouvel écosystème à l'étape 1.1");
      let title = nextTitle(String(item["o:title"] ?? "Nœud"));
      for (let i = 0; i < 50 && await titleTaken(omk, templateId, title); i++) title = nextTitle(title);
      const props = Object.fromEntries(Object.entries(itemProperties(item)).map(([k, vs]) => [k, vs.map(toWritable)]));
      const titleProp = await propId(omk, "dcterms:title");
      props["dcterms:title"] = [{ type: "literal", property_id: titleProp, "@value": title }];
      const copy = await omk.request(omk.url("items"), "POST", {
        ...(templateId ? { "o:resource_template": { "o:id": templateId } } : {}),
        ...(item["o:resource_class"] ? { "o:resource_class": { "o:id": item["o:resource_class"]["o:id"] } } : {}),
        "o:item_set": (item["o:item_set"] ?? []).map((s: any) => ({ "o:id": s["o:id"] })), ...props,
      });
      return { id: copy["o:id"], title };
    }),

    // nœud à modifier : template, valeurs au format du formulaire, adresse dans Omeka S
    "GET /api/econetwork/item": json(async (_req, url) => {
      const omk = await ctx.serverOmk();
      const item = await omk.request(omk.url(`items/${itemId(url.searchParams.get("id"))}`));
      return { id: item["o:id"], title: item["o:title"], templateId: item["o:resource_template"]?.["o:id"] ?? null, values: formValues(item), adminUrl: `${omekaBase()}/admin/item/${item["o:id"]}`, details: await itemDetails(omk, item) };
    }),

    // modification ({ id, values }) : valeurs contrôlées par le template ; propriétés hors template conservées
    "POST /api/econetwork/item": json(async req => {
      const b = await ctx.readBody(req);
      const omk = await ctx.serverOmk();
      const id = itemId(b.id);
      const item = await omk.request(omk.url(`items/${id}`));
      const templateId = item["o:resource_template"]?.["o:id"];
      if (!templateId) throw new Error("Ce nœud n'a pas de resource template : le modifier dans Omeka S");
      const form = await buildTemplateForm(omk, templateId);
      const values: Record<string, FormValue[]> = b.values ?? {};
      if (templateId === ctx.config().omekaForms.powerTemplateId) {
        // type du pouvoir donné comme item du vocabulaire des types : son titre sert au contrôle
        const tv = values[ctx.config().omekaForms.powerTypeTerm]?.[0];
        if (tv?.id && !tv.label && tv.value == null) tv.label = String((await omk.request(omk.url(`items/${tv.id}`)).catch(() => null))?.["o:title"] ?? "");
        checkPower(values, ctx.config());
      }
      const payload: any = itemPayload(form, values);
      // pouvoir : le maillon de chaque lien (annotation roleTerm, écrite par EcoSpace) est conservé, le modèle ne déclarant
      // pas d'annotation pour ces propriétés : pris dans la valeur envoyée, sinon dans le lien existant vers le même item ;
      // un lien ajouté sans annotation est rattaché à son maillon par ordre
      if (templateId === ctx.config().omekaForms.powerTemplateId) {
        const roleT = ctx.config().ecospace.shapes.find((x: any) => x.power)?.roleTerm ?? "dcterms:type", rolePid = await propId(omk, roleT);
        for (const term of new Set(ctx.config().omekaForms.powerTypes.flatMap(t => t.sequence.map(s => s.term)))) {
          const old = (item[term] ?? []).map((v: any) => ({ id: v.value_resource_id, role: v["@annotation"]?.[roleT]?.[0]?.["@value"] })).filter((x: any) => x.role);
          const role = (values[term] ?? []).filter(v => v.id).map(v => {
            const sent = v.annotation?.[roleT]?.[0]?.value;
            if (sent) return sent;
            const i = old.findIndex((x: any) => x.id === v.id);
            return i >= 0 ? old.splice(i, 1)[0].role : undefined;
          });
          payload[term] = (payload[term] ?? []).map((pv: any, i: number) => role[i] ? { ...pv, "@annotation": { [roleT]: [{ type: "literal", property_id: rolePid, "@value": String(role[i]) }] } } : pv);
        }
      }
      // champs du template remplacés (un champ vidé est vidé dans Omeka S) ; propriétés hors template conservées
      await writeValues(omk, id, Object.fromEntries(form.fields.map(f => [f.term, payload[f.term] ?? []])));
      return { id, title: values[form.titleTerm]?.[0]?.value ?? item["o:title"] };
    }),

    "GET /api/econetwork/impact": json(async (_req, url) => deletionImpact(await ctx.serverOmk(), itemId(url.searchParams.get("item")), net())),

    // suppression ({ item, eco, mode }) : « network » retire le nœud de l'écosystème ; « omeka » supprime l'item, seulement
    // si aucun autre nœud ne l'utilise (hors écosystème)
    "POST /api/econetwork/delete": json(async req => {
      const b = await ctx.readBody(req);
      const omk = await ctx.serverOmk();
      const id = itemId(b.item), eco = itemId(b.eco);
      if (id === eco) throw new Error("L'écosystème ne se supprime pas depuis son réseau");
      const impact = await deletionImpact(omk, id, net());
      if (b.mode === "omeka") {
        const users = [...impact.parents.filter(p => p.id !== eco), ...impact.ecos.filter(e => e.id !== eco && !impact.parents.some(p => p.id === e.id))];
        if (users.length) throw new Error(`Nœud utilisé par ${users.map(p => `« ${p.title} »`).join(", ")} : le délier d'abord ou le retirer seulement du réseau`);
        await omk.deleteResource(id);
        console.log(`🗑️ [OMEKA] EcoNetwork : item ${id} supprimé`);
        return { deleted: true };
      }
      const item = await omk.request(omk.url(`items/${id}`));
      const kept = (item[net().ecoProperty] ?? []).filter((v: any) => v.value_resource_id !== eco);
      if (kept.length === (item[net().ecoProperty] ?? []).length && !impact.parents.some(p => p.id === eco)) throw new Error("Ce nœud n'est pas un élément de l'écosystème : le délier de ses parents");
      await setValues(omk, id, net().ecoProperty, kept.map(toWritable));
      const ecoItem = await omk.request(omk.url(`items/${eco}`));
      if ((ecoItem[net().ecoProperty] ?? []).some((v: any) => v.value_resource_id === id)) {
        await setValues(omk, eco, net().ecoProperty, ecoItem[net().ecoProperty].filter((v: any) => v.value_resource_id !== id).map(toWritable));
      }
      return { removed: true };
    }),

    // suppression d'un lien ({ source, target, term })
    "POST /api/econetwork/unlink": json(async req => {
      const b = await ctx.readBody(req);
      if (!validTerm(b.term)) throw new Error("Propriété invalide");
      const omk = await ctx.serverOmk();
      const source = itemId(b.source), target = itemId(b.target);
      const item = await omk.request(omk.url(`items/${source}`));
      const vs = (item[b.term] ?? []) as any[];
      if (!vs.some(v => v.value_resource_id === target)) throw new Error("Lien introuvable");
      await setValues(omk, source, b.term, vs.filter(v => v.value_resource_id !== target).map(toWritable));
      return { unlinked: true, remainingParents: (await referencing(omk, target)).length };
    }),
  };
}
