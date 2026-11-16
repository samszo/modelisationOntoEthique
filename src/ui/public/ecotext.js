// Nouvel écosystème depuis une description textuelle (EcoSpace, étape 1.1) : saisie guidée rubrique par rubrique
// (phrases modèles, autocomplétion locale des titres existants et des noms déjà cités, suite proposée par Albert),
// modélisation par l'agent, aperçu modifiable, puis création dans Omeka S et dans l'espace avec les routes existantes

const h = (tag, props = {}, ...children) => {
  const e = Object.assign(document.createElement(tag), props);
  for (const c of children.flat()) if (c != null && c !== false) e.append(c);
  return e;
};
const fold = x => String(x ?? "").normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
const KIND_LABEL = { actant: "actant", personne: "personne", agent: "agent", physique: "physique", concept: "concept", crible: "crible", pulsation: "pulsation", cite: "déjà cité" };
// types proposés en premier selon la rubrique
const STAGE_KINDS = { ecosysteme: [], actants: ["actant", "personne", "agent"], physiques: ["physique"], concepts: ["concept"], pouvoirs: ["physique", "crible", "actant", "concept"], pulsations: ["pulsation"] };
const DRAFT_KEY = "ecotext-draft";

const CSS = `
.et-stage { border: 1px solid var(--line); border-radius: 8px; margin: 8px 0; background: var(--panel); }
.et-stage > summary { cursor: pointer; padding: 8px 12px; font-weight: 600; display: flex; gap: 8px; align-items: baseline; }
.et-stage > summary .muted { font-weight: 400; font-size: 12.5px; }
.et-stage[open] > summary { border-bottom: 1px solid var(--line); }
.et-body { padding: 10px 12px; }
.et-help { color: var(--muted); font-size: 13px; margin: 0 0 6px; }
.et-chips { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 6px; }
.et-chip { font-size: 12.5px; border: 1px dashed var(--line); border-radius: 14px; padding: 2px 10px; background: var(--bg); cursor: pointer; color: var(--ink); text-align: left; }
.et-chip:hover { border-color: var(--accent); }
.et-text { width: 100%; min-height: 110px; box-sizing: border-box; font: inherit; padding: 8px; border: 1px solid var(--line); border-radius: 6px; background: var(--panel); color: var(--ink); resize: vertical; }
.et-ac li .k { margin-left: auto; color: var(--muted); font-size: 12px; }
.et-ac li.active { background: var(--bg); }
.et-sug { border-left: 3px solid var(--accent); padding: 6px 10px; margin-top: 6px; background: var(--bg); border-radius: 0 6px 6px 0; font-size: 14px; }
.et-sug p { margin: 0 0 6px; white-space: pre-wrap; }
.et-preview h4 { margin: 14px 0 6px; }
.et-preview table { width: 100%; border-collapse: collapse; font-size: 13px; }
.et-preview th, .et-preview td { border-top: 1px solid var(--line); padding: 4px; text-align: left; vertical-align: top; }
.et-preview input:not([type=checkbox]), .et-preview select, .et-preview textarea { width: 100%; box-sizing: border-box; font: inherit; font-size: 13px; padding: 3px 5px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel); color: var(--ink); }
.et-preview td.n { width: 70px; } .et-preview td.c { width: 22px; }
.et-badge { font-size: 11.5px; border-radius: 10px; padding: 1px 7px; white-space: nowrap; }
.et-badge.ex { background: color-mix(in srgb, var(--ok) 18%, transparent); color: var(--ok); }
.et-badge.new { background: color-mix(in srgb, var(--accent) 15%, transparent); color: var(--accent); }
.et-wrap { overflow-x: auto; }
`;

// ouvre la saisie dans box ; deps : { api, toast, withBusy, busyStep, geocode, ecoTemplateId, ecos, onCreated(eco) }
export async function openEcoText(box, deps) {
  if (!document.getElementById("et-css")) document.head.append(h("style", { id: "et-css", textContent: CSS }));
  box.replaceChildren(h("p", { className: "muted", textContent: "Chargement des rubriques et des titres existants…" }));
  let vocab;
  try { vocab = await deps.api("/api/ecotext/vocab"); } catch (e) { box.textContent = e.message; return; }
  let draft = {};
  try { draft = JSON.parse(localStorage.getItem(DRAFT_KEY) ?? "{}") ?? {}; } catch { draft = {}; }
  const sections = Object.fromEntries(vocab.stages.map(s => [s.id, String(draft[s.id] ?? "")]));
  const saveDraft = () => { try { localStorage.setItem(DRAFT_KEY, JSON.stringify(sections)); } catch {} };
  // journal de la génération (suites proposées, modélisations), conservé dans l'item de l'écosystème à la création
  const journal = [];
  const existing = Object.entries(vocab.existing).flatMap(([k, xs]) => xs.map(x => ({ title: x.title, kind: k, id: x.id })));
  // noms cités entre « » dans toutes les rubriques
  const cited = () => [...new Set(Object.values(sections).flatMap(t => [...t.matchAll(/«\s*([^«»]+?)\s*»/g)].map(m => m[1].trim())).filter(x => x && !/^\{\{/.test(x)))];

  const stages = vocab.stages.map((st, i) => {
    const ta = h("textarea", { className: "et-text", value: sections[st.id], placeholder: `${st.help}\nCliquer une phrase modèle ou écrire ; les noms se complètent (↑ ↓, Entrée ou Tab), Tab passe au prochain {{…}}.` });
    const ac = h("ul", { className: "ac-list et-ac", role: "listbox" }), sug = h("div");
    const count = h("span", { className: "muted" });
    const updCount = () => { const n = (sections[st.id].match(/[.!?](\s|$)/g) ?? []).length; count.textContent = sections[st.id].trim() ? `· ${n || 1} phrase${n > 1 ? "s" : ""}` : "· vide"; };
    let shown = [], active = -1, token = null;
    const insert = (txt, from = ta.selectionStart, to = ta.selectionEnd) => {
      ta.setRangeText(txt, from, to, "end"); sections[st.id] = ta.value; saveDraft(); updCount(); ta.focus();
    };
    const selectPlaceholder = (start = 0) => { const m = /\{\{[^}]*\}\}/.exec(ta.value.slice(start)); if (!m) return false; ta.focus(); ta.setSelectionRange(start + m.index, start + m.index + m[0].length); return true; };
    const chips = h("div", { className: "et-chips" }, st.patterns.map(p => h("button", { type: "button", className: "et-chip", textContent: p, title: "Insérer cette phrase modèle ; les {{…}} sont à compléter",
      onclick: () => { const pos = ta.selectionStart, lead = ta.value && !/\s$/.test(ta.value.slice(0, pos)) ? (pos ? " " : "") : ""; insert(lead + p, pos, ta.selectionEnd); selectPlaceholder(pos); } })));
    // fragment en cours : après un « non refermé, sinon le dernier mot
    const fragment = () => {
      const pos = ta.selectionStart, before = ta.value.slice(0, pos), open = before.lastIndexOf("«");
      if (open >= 0 && before.lastIndexOf("»") < open) return { from: open, q: before.slice(open + 1).trim(), quoted: true };
      const m = /([\p{L}\p{N}'’-]+)$/u.exec(before);
      return m ? { from: pos - m[1].length, q: m[1], quoted: false } : null;
    };
    const render = () => ac.replaceChildren(...shown.map((o, k) => h("li", { role: "option", className: k === active ? "active" : "", onmousedown: e => { e.preventDefault(); accept(o); } },
      h("span", { textContent: o.title }), h("span", { className: "k", textContent: `${KIND_LABEL[o.kind] ?? o.kind}${o.id ? ` · item ${o.id}` : ""}` }))));
    const refresh = () => {
      token = fragment();
      const q = fold(token?.q ?? "");
      if (!token || q.length < (vocab.minChars ?? 2) || /\{\{/.test(token.q)) { shown = []; render(); return; }
      const pref = STAGE_KINDS[st.id] ?? [], pool = [...cited().map(t => ({ title: t, kind: "cite" })), ...existing];
      const seen = new Set();
      shown = pool.filter(o => fold(o.title).includes(q) && fold(o.title) !== q && !seen.has(fold(o.title) + o.kind) && seen.add(fold(o.title) + o.kind))
        .map(o => ({ o, s: (fold(o.title).startsWith(q) ? 0 : 2) + (o.kind === "cite" ? 0 : pref.includes(o.kind) ? 0.5 : 1) }))
        .sort((a, b) => a.s - b.s || a.o.title.length - b.o.title.length).slice(0, vocab.maxSuggestions ?? 12).map(x => x.o);
      active = shown.length ? 0 : -1; render();
    };
    const accept = o => {
      if (!token) return;
      const after = ta.value.slice(ta.selectionStart), close = token.quoted && /^[^«]*?»/.test(after) ? after.indexOf("»") + 1 : 0;
      insert(`« ${o.title} »`, token.from, ta.selectionStart + close);
      shown = []; render();
    };
    ta.oninput = () => { sections[st.id] = ta.value; saveDraft(); updCount(); refresh(); };
    ta.onclick = refresh;
    ta.onblur = () => setTimeout(() => { shown = []; render(); }, 150);
    ta.onkeydown = e => {
      if (shown.length) {
        if (e.key === "ArrowDown" || e.key === "ArrowUp") { e.preventDefault(); active = (active + (e.key === "ArrowDown" ? 1 : shown.length - 1)) % shown.length; render(); return; }
        if ((e.key === "Enter" || e.key === "Tab") && active >= 0) { e.preventDefault(); accept(shown[active]); return; }
        if (e.key === "Escape") { e.preventDefault(); shown = []; render(); return; }
      }
      if (e.key === "Tab" && !e.shiftKey && selectPlaceholder(ta.selectionEnd)) e.preventDefault();
    };
    // suite proposée par Albert
    const ask = h("button", { type: "button", className: "btn small", textContent: "Suggérer la suite", title: "Albert propose une à trois phrases pour cette rubrique, d'après tout ce qui est déjà écrit" });
    ask.onclick = async () => {
      ask.disabled = true; ask.textContent = "Suggestion…";
      try {
        const r = await deps.api("/api/ecotext/suggest", { method: "POST", body: { stage: st.id, sections } });
        const step = { kind: "suggestion", stage: st.id, at: new Date().toISOString(), prompt: r.prompt, response: r.text, model: r.model, cost: r.cost, accepted: false };
        journal.push(step);
        const p = h("p", { textContent: r.text });
        sug.replaceChildren(h("div", { className: "et-sug" }, p,
          h("div", { className: "toolbar" },
            h("button", { type: "button", className: "btn small primary", textContent: "Ajouter", onclick: () => { step.accepted = true; const v = ta.value; insert((v && !/\s$/.test(v) ? " " : "") + r.text, v.length, v.length); sug.replaceChildren(); selectPlaceholder(v.length); } }),
            h("button", { type: "button", className: "btn small", textContent: "Ignorer", onclick: () => sug.replaceChildren() }),
            h("span", { className: "muted", style: "font-size:12px", textContent: `${r.cost?.tokens ?? "?"} tokens${r.cost?.co2g != null ? ` · ${r.cost.co2g.toFixed(2)} g CO₂e` : ""}` }))));
      } catch (e) { deps.toast("Suggestion impossible : " + e.message); }
      finally { ask.disabled = false; ask.textContent = "Suggérer la suite"; }
    };
    const next = i + 1 < vocab.stages.length ? h("button", { type: "button", className: "btn small", textContent: `Étape suivante : ${vocab.stages[i + 1].label} →`, onclick: () => openStage(i + 1) }) : null;
    const det = h("details", { className: "et-stage", open: i === 0 },
      h("summary", {}, h("span", { textContent: `${i + 1}. ${st.label}` }), count),
      h("div", { className: "et-body" }, h("p", { className: "et-help", textContent: st.help }), chips, ta, ac, sug, h("div", { className: "toolbar", style: "margin-top:6px" }, ask, next)));
    det.addEventListener("toggle", () => { if (det.open) stages.forEach((x, k) => { if (k !== i) x.det.open = false; }); });
    updCount();
    return { det, ta };
  });
  const openStage = i => { stages[i].det.open = true; stages[i].det.scrollIntoView({ block: "nearest", behavior: "smooth" }); stages[i].ta.focus(); };

  const preview = h("div", { className: "et-preview" });
  const analyse = h("button", { type: "button", className: "btn primary", textContent: "Analyser la description", title: "L'agent transforme la description en modélisation onto-éthique, à relire avant la création" });
  analyse.onclick = async () => {
    try {
      const r = await deps.withBusy("Modélisation de la description", async () => { deps.busyStep("Modélisation par l'agent (Albert) et rapprochement avec les items existants"); return deps.api("/api/ecotext/model", { method: "POST", body: { sections } }); });
      journal.push({ kind: "model", at: new Date().toISOString(), prompt: r.prompt, response: r.raw, model: r.iaModel, cost: r.cost, durationMs: r.durationMs });
      renderPreview(preview, r.model, vocab, deps, r, { sections, journal });
      preview.scrollIntoView({ block: "start", behavior: "smooth" });
    } catch (e) { deps.toast("Analyse impossible : " + e.message); }
  };
  const clear = h("button", { type: "button", className: "btn", textContent: "Effacer", onclick: () => {
    if (!confirm("Effacer toute la description ?")) return;
    for (const s of vocab.stages) sections[s.id] = "";
    stages.forEach(x => { x.ta.value = ""; x.ta.dispatchEvent(new Event("input")); });
    preview.replaceChildren();
  } });
  box.replaceChildren(
    h("p", { className: "lead", textContent: "Décrire l'écosystème rubrique par rubrique : les phrases modèles et l'autocomplétion (titres existants dans Omeka S, noms déjà cités) guident la saisie, « Suggérer la suite » demande des phrases à Albert. « Analyser » produit la modélisation, à relire et corriger avant de créer l'écosystème et son espace. Le brouillon est gardé dans ce navigateur." }),
    ...stages.map(x => x.det),
    h("div", { className: "toolbar", style: "margin-top:10px" }, analyse, clear),
    preview);
}

// ==========================================
// Aperçu modifiable
// ==========================================
const list = xs => (xs ?? []).map(x => typeof x === "string" ? x : x.titre).join(" ; ");
const parseList = v => String(v ?? "").split(/\s*;\s*/).map(x => x.replace(/^«\s*|\s*»$/g, "").trim()).filter(Boolean);
function renderPreview(box, m, vocab, deps, meta, session) {
  const inp = (obj, key, props = {}) => { const i = h("input", { value: obj[key] ?? "", ...props }); i.oninput = () => { obj[key] = props.type === "number" ? (i.value === "" ? null : Number(i.value)) : i.value; }; return i; };
  const listInp = (obj, key, kind) => { const i = h("input", { value: list(obj[key]), title: "Séparer par ;" }); i.oninput = () => { obj[key] = parseList(i.value).map(t => ({ titre: t, existing: (vocab.existing[kind] ?? []).find(x => fold(x.title) === fold(t))?.id ?? null })); }; return i; };
  const keep = obj => { if (obj.keep == null) obj.keep = true; const c = h("input", { type: "checkbox", checked: obj.keep, title: "Créer cet élément" }); c.onchange = () => { obj.keep = c.checked; }; return c; };
  const badge = obj => h("span", { className: `et-badge ${obj.existing ? "ex" : "new"}`, textContent: obj.existing ? `existant · item ${obj.existing}` : "nouveau" });
  const table = (head, rows) => h("div", { className: "et-wrap" }, h("table", {}, h("thead", {}, h("tr", {}, head.map(t => h("th", { textContent: t })))), h("tbody", {}, rows)));
  const sec = (title, n, content) => [h("h4", { textContent: `${title} (${n})` }), n ? content : h("p", { className: "muted", textContent: "aucun" })];
  const e = m.ecosysteme;
  const types = vocab.powerTypes;
  const create = h("button", { type: "button", className: "btn primary", textContent: "Créer l'écosystème et son espace" });
  create.onclick = () => createAll(m, vocab, deps, session).catch(err => deps.toast("Création interrompue : " + err.message));
  box.replaceChildren(
    h("h3", { textContent: "Modélisation proposée" }),
    h("p", { className: "muted", style: "font-size:13px", textContent: `Relire et corriger avant la création : décocher ce qu'il ne faut pas créer ; listes séparées par « ; ». Les éléments « existant » sont repris tels quels dans Omeka S. Lieux : recherchés sur la carte à la création (le premier résultat), dates AAAA, AAAA-MM ou AAAA-MM-JJ.${meta?.cost ? ` Analyse : ${meta.cost.tokens} tokens, ${(meta.durationMs / 1000).toFixed(1)} s${meta.cost.co2g != null ? `, ${meta.cost.co2g.toFixed(2)} g CO₂e` : ""}.` : ""}` }),
    ...sec("Écosystème", 1, table(["Titre", "Description", "Lieu (origine de la grille)"], [h("tr", {}, h("td", {}, inp(e, "titre")), h("td", {}, (() => { const t = h("textarea", { value: e.description ?? "", rows: 2 }); t.oninput = () => { e.description = t.value; }; return t; })()), h("td", {}, inp(e, "lieu")))])),
    ...sec("Actants", m.actants.length, table(["", "Titre", "", "Personnes", "Agents", "Lieu", "Date"], m.actants.map(a => h("tr", {}, h("td", { className: "c" }, keep(a)), h("td", {}, inp(a, "titre")), h("td", {}, badge(a)), h("td", {}, listInp(a, "personnes", "personne")), h("td", {}, listInp(a, "agents", "agent")), h("td", {}, inp(a, "lieu")), h("td", { className: "n" }, inp(a, "date")))))),
    ...sec("Physiques", m.physiques.length, table(["", "Titre", "", "Contenu dans", "Création", "Importance", "Lieu", "Date"], m.physiques.map(p => h("tr", {}, h("td", { className: "c" }, keep(p)), h("td", {}, inp(p, "titre")), h("td", {}, badge(p)), h("td", {}, inp(p, "parent")), h("td", { className: "n" }, inp(p, "creation")), h("td", { className: "n" }, inp(p, "importance", { type: "number", min: 1, max: 10 })), h("td", {}, inp(p, "lieu")), h("td", { className: "n" }, inp(p, "date")))))),
    ...sec("Concepts", m.concepts.length, table(["", "Titre", "", "Englobé par"], m.concepts.map(c => h("tr", {}, h("td", { className: "c" }, keep(c)), h("td", {}, inp(c, "titre")), h("td", {}, badge(c)), h("td", {}, inp(c, "parent")))))),
    ...sec("Cribles", m.cribles.length, table(["Titre", ""], m.cribles.map(c => h("tr", {}, h("td", {}, inp(c, "titre")), h("td", {}, badge(c)))))),
    ...sec("Pouvoirs", m.pouvoirs.length, table(["", "Réf.", "Type", "Intensité", "Maillons (séparer par ; les éléments d'un maillon)", "Titre"], m.pouvoirs.map(p => {
      const steps = h("div");
      const draw = () => {
        const seq = types.find(t => t.id === p.type)?.sequence ?? [];
        p.maillons = seq.map((name, i) => ({ name, elements: p.maillons.find(x => x.name === name)?.elements ?? p.maillons[i]?.elements ?? [] }));
        steps.replaceChildren(...p.maillons.map(st => { const i = h("input", { value: st.elements.join(" ; "), placeholder: st.name }); i.oninput = () => { st.elements = parseList(i.value); }; return h("label", { style: "display:block;font-size:12px;color:var(--muted)" }, st.name, i); }));
      };
      const sel = h("select", {}, types.map(t => h("option", { value: t.id, textContent: t.label, selected: t.id === p.type })));
      sel.onchange = () => { p.type = sel.value; draw(); };
      draw();
      return h("tr", {}, h("td", { className: "c" }, keep(p)), h("td", { className: "n" }, inp(p, "ref")), h("td", {}, sel), h("td", { className: "n" }, inp(p, "intensite", { type: "number", min: -100, max: 100 })), h("td", {}, steps), h("td", {}, inp(p, "titre")));
    }))),
    ...sec("Pulsations", m.pulsations.length, table(["", "Titre", "", "Pouvoirs (réf., dans l'ordre)", "Lieu", "Date", "Flux (ordre « pulsation » ; …)"], m.pulsations.map(p => {
      const pw = h("input", { value: (p.pouvoirs ?? []).join(" ; ") }); pw.oninput = () => { p.pouvoirs = parseList(pw.value); };
      const fx = h("input", { value: (p.flux ?? []).map(f => `${f.ordre ?? ""} « ${f.vers} »${f.rang != null ? ` ${f.rang}` : ""}`.trim()).join(" ; "), title: "ex. : avant « Autre pulsation » ; pendant « Une troisième » 2" });
      fx.oninput = () => { p.flux = fx.value.split(/\s*;\s*/).map(s => /^(avant|pendant|après|apres)?\s*«\s*([^»]+?)\s*»\s*(\d+)?/i.exec(s.trim())).filter(Boolean).map(x => ({ ordre: x[1] ? x[1].toLowerCase().replace("apres", "après") : null, vers: x[2], rang: x[3] ? Number(x[3]) : null })); };
      return h("tr", {}, h("td", { className: "c" }, keep(p)), h("td", {}, inp(p, "titre")), h("td", {}, badge(p)), h("td", {}, pw), h("td", {}, inp(p, "lieu")), h("td", { className: "n" }, inp(p, "date")), h("td", {}, fx));
    }))),
    h("div", { className: "toolbar", style: "margin-top:12px" }, create));
}

// ==========================================
// Création : écosystème, grille, origine, éléments, pouvoirs, pulsations, positions
// ==========================================
const M_PER_DEG = 111320;
function hexOfGeo(grid, g) {
  const o = grid.origin, S = grid.hexSize, R3 = Math.sqrt(3);
  const x = (g.lon - o.lon) * M_PER_DEG * Math.cos(o.lat * Math.PI / 180), z = -(g.lat - o.lat) * M_PER_DEG;
  const fq = grid.orientation === "flat" ? (2 / 3 * x) / S : (R3 / 3 * x - 1 / 3 * z) / S, fr = grid.orientation === "flat" ? (-1 / 3 * x + R3 / 3 * z) / S : (2 / 3 * z) / S, fs = -fq - fr;
  let q = Math.round(fq), r = Math.round(fr), s = Math.round(fs);
  const dq = Math.abs(q - fq), dr = Math.abs(r - fr), ds = Math.abs(s - fs);
  if (dq > dr && dq > ds) q = -r - s; else if (dr > ds) r = -q - s;
  return { q: q || 0, r: r || 0 };
}
// date saisie (AAAA, AAAA-MM, AAAA-MM-JJ) → ISO ; null si illisible
function isoDate(d) {
  const m = /^\s*(-?\d{1,4})(?:-(\d{1,2}))?(?:-(\d{1,2}))?\s*$/.exec(String(d ?? ""));
  if (!m) return null;
  const t = Date.UTC(+m[1], (m[2] ? +m[2] : 1) - 1, m[3] ? +m[3] : 1);
  return Number.isFinite(t) ? new Date(t).toISOString() : null;
}
const timestamp = d => { const m = /^\s*(-?\d{1,4})(?:-(\d{1,2}))?(?:-(\d{1,2}))?\s*$/.exec(String(d ?? "")); return m ? [m[1], m[2]?.padStart(2, "0"), m[3]?.padStart(2, "0")].filter(Boolean).join("-") : ""; };

async function createAll(m, vocab, deps, session = {}) {
  const e = m.ecosysteme, title = String(e.titre ?? "").trim();
  if (!title) throw new Error("Titre de l'écosystème obligatoire");
  if (deps.ecos?.some(x => fold(x.title) === fold(title)) && !confirm(`Un écosystème « ${title} » existe déjà : y ajouter ces éléments ?`)) return;
  const warn = [], api = deps.api, k = x => fold(String(x ?? "").trim());
  const ids = { actant: new Map(), physique: new Map(), concept: new Map(), pouvoir: new Map(), pulsation: new Map() };
  const keepOf = xs => (xs ?? []).filter(x => x.keep !== false && String(x.titre ?? "").trim());
  // lieux : premier résultat du service de géocodage, une requête par seconde au plus (règle de Nominatim)
  const places = new Map(); let lastGeo = 0;
  const geo = async lieu => {
    const q = String(lieu ?? "").trim();
    if (!q) return null;
    if (places.has(q)) return places.get(q);
    const wait = 1100 - (Date.now() - lastGeo); if (wait > 0) await new Promise(r => setTimeout(r, wait));
    lastGeo = Date.now();
    deps.busyStep(`Recherche du lieu « ${q} »`);
    let g = null;
    try { const r = (await deps.geocode(q))[0]; if (r) g = { lon: +r.lon, lat: +r.lat, address: r.display_name }; else warn.push(`lieu introuvable : ${q}`); }
    catch (err) { warn.push(`lieu « ${q} » non recherché : ${err.message}`); }
    places.set(q, g);
    return g;
  };
  const position = async (item, g, date) => {
    if (!g) return;
    try { await api("/api/ecospace/position", { method: "POST", body: { eco, item, lon: g.lon, lat: g.lat, at: isoDate(date) ?? new Date().toISOString(), address: g.address } }); }
    catch (err) { warn.push(`position de l'item ${item} : ${err.message}`); }
  };
  let eco;
  await deps.withBusy(`Création de « ${title} »`, async () => {
    // 1. écosystème et grille
    const values = { "dcterms:title": [{ type: "literal", value: title }] };
    if (String(e.description ?? "").trim()) values["dcterms:description"] = [{ type: "literal", value: e.description.trim() }];
    deps.busyStep("Création de l'écosystème dans Omeka S");
    const r = await api("/api/ontoethique/form/item", { method: "POST", body: { template: deps.ecoTemplateId, values } });
    eco = r.id;
    let space = await api("/api/ecospace/space", { method: "POST", body: { eco } });
    // 2. origine : lieu de l'écosystème, sinon du premier actant ou physique qui en a un
    const og = await geo(e.lieu || keepOf(m.actants).find(a => a.lieu)?.lieu || keepOf(m.physiques).find(p => p.lieu && !p.parent)?.lieu);
    if (og) space = await api("/api/ecospace/origin", { method: "POST", body: { eco, lon: og.lon, lat: og.lat } });
    const grid = space.grid, near = g => g ? hexOfGeo(grid, g) : { q: 0, r: 0 };
    const tplOf = key => space.shapes?.find(s => s.key === key)?.templateId;
    const opts = await api(`/api/econetwork/linkable?item=${eco}`), o = opts.find(x => x.reverse) ?? opts[0];
    if (!o) throw new Error("Le modèle de l'écosystème ne prévoit aucun lien vers ses éléments");
    const link = async (x, templateId) => (await api("/api/econetwork/link", { method: "POST", body: x.existing ? { eco, parent: eco, term: o.term, existing: x.existing } : { eco, parent: eco, term: o.term, templateId, title: x.titre.trim() } })).id;
    // 3. actants (placés au lieu indiqué, sinon près de l'origine), personnes et agents
    for (const a of keepOf(m.actants)) {
      try {
        const id = await link(a, tplOf("actant"));
        ids.actant.set(k(a.titre), id);
        const g = await geo(a.lieu);
        await api("/api/ecospace/place", { method: "POST", body: { eco, item: id, near: near(g) } });
        await position(id, g, a.date);
        for (const [shape, xs] of [["personne", a.personnes], ["agent", a.agents]]) for (const p of xs ?? []) {
          const t = typeof p === "string" ? { titre: p } : p;
          try { await api("/api/ecospace/member", { method: "POST", body: t.existing ? { eco, actant: id, shape, existing: t.existing } : { eco, actant: id, shape, title: t.titre } }); }
          catch (err) { warn.push(`${shape} « ${t.titre} » : ${err.message}`); }
        }
      } catch (err) { warn.push(`actant « ${a.titre} » : ${err.message}`); }
    }
    // 4. physiques : les contenants avant leurs enfants ; racines placées, enfants dans leur contenant
    let todo = keepOf(m.physiques);
    for (let pass = 0; todo.length && pass < 20; pass++) {
      const later = [];
      for (const p of todo) {
        const parent = p.parent ? ids.physique.get(k(p.parent)) : null;
        if (p.parent && !parent && todo.some(x => k(x.titre) === k(p.parent))) { later.push(p); continue; }
        try {
          const body = p.existing ? { eco, existing: p.existing } : { eco, title: p.titre.trim(), created: timestamp(p.creation), importance: p.importance ?? "" };
          if (parent) body.parent = parent;
          const r = await api("/api/ecospace/physique", { method: "POST", body });
          ids.physique.set(k(p.titre), r.id);
          if (!parent) { const g = await geo(p.lieu); await api("/api/ecospace/place", { method: "POST", body: { eco, item: r.id, near: near(g) } }); await position(r.id, g, p.date); }
        } catch (err) { warn.push(`physique « ${p.titre} » : ${err.message}`); }
      }
      if (later.length === todo.length) { warn.push(`physiques non créés (contenant introuvable) : ${later.map(x => x.titre).join(", ")}`); break; }
      todo = later;
    }
    // 5. concepts (ajoutés à l'espace), puis leur hiérarchie
    for (const c of keepOf(m.concepts)) {
      try { const id = await link(c, tplOf("concept")); ids.concept.set(k(c.titre), id); await api("/api/ecospace/place", { method: "POST", body: { eco, item: id, near: { q: 0, r: 0 } } }); }
      catch (err) { warn.push(`concept « ${c.titre} » : ${err.message}`); }
    }
    for (const c of keepOf(m.concepts)) if (c.parent) {
      const child = ids.concept.get(k(c.titre)), parent = ids.concept.get(k(c.parent));
      if (!child || !parent) { warn.push(`hiérarchie « ${c.parent} » → « ${c.titre} » : concept manquant`); continue; }
      try { await api("/api/ecospace/concept/relate", { method: "POST", body: { eco, item: parent, as: "child", existing: child } }); }
      catch (err) { warn.push(`hiérarchie « ${c.parent} » → « ${c.titre} » : ${err.message}`); }
    }
    // 6. pouvoirs : maillons existants (créés ci-dessus ou repris) ou à créer par titre (cribles, concepts)
    const cribles = new Map(keepOf(m.cribles).filter(c => c.existing).map(c => [k(c.titre), c.existing]));
    const stepValue = (name, t) => {
      const key = /^physique/.test(name) ? "physique" : /^actant/.test(name) ? "actant" : /^concept/.test(name) ? "concept" : "crible";
      const id = key === "crible" ? cribles.get(k(t)) : ids[key].get(k(t));
      if (id) return { existing: id };
      if (key === "physique" || key === "actant") throw new Error(`${name} « ${t} » absent de l'espace`);
      return { title: t };
    };
    for (const p of keepOf(m.pouvoirs.map(x => ({ ...x, titre: x.titre || x.ref })))) {
      try {
        const steps = p.maillons.map(st => { const vs = st.elements.map(t => stepValue(st.name, t)); if (!vs.length) throw new Error(`maillon « ${st.name} » vide`); return vs.length > 1 ? vs : vs[0]; });
        const r = await api("/api/ecospace/power", { method: "POST", body: { eco, type: p.type, intensity: Number(p.intensite) || 0, title: p.titre && p.titre !== p.ref ? p.titre : "", steps } });
        ids.pouvoir.set(p.ref, r.id);
      } catch (err) { warn.push(`pouvoir ${p.ref} : ${err.message}`); }
    }
    // 7. pulsations : créées avec leur premier pouvoir, puis les suivants dans l'ordre ; position ; flux ensuite
    for (const p of keepOf(m.pulsations)) {
      const pws = (p.pouvoirs ?? []).map(r => ids.pouvoir.get(r)).filter(Boolean);
      if (!pws.length) { warn.push(`pulsation « ${p.titre} » : aucun de ses pouvoirs n'a été créé`); continue; }
      try {
        let id = null;
        for (const pw of pws) id = (await api("/api/ecospace/pulsation", { method: "POST", body: id ? { eco, power: pw, existing: id } : p.existing ? { eco, power: pw, existing: p.existing } : { eco, power: pw, title: p.titre.trim() } })).id;
        ids.pulsation.set(k(p.titre), id);
        await position(id, await geo(p.lieu), p.date);
      } catch (err) { warn.push(`pulsation « ${p.titre} » : ${err.message}`); }
    }
    const fluxes = keepOf(m.pulsations).flatMap(p => (p.flux ?? []).map(f => ({ from: ids.pulsation.get(k(p.titre)), to: ids.pulsation.get(k(f.vers)), f, p })));
    if (fluxes.length) {
      const rel = (await api(`/api/ecospace/space?eco=${eco}`)).pulseRelatives ?? [];
      for (const { from, to, f, p } of fluxes) {
        if (!from || !to) { warn.push(`flux « ${p.titre} » → « ${f.vers} » : pulsation manquante`); continue; }
        const r = f.ordre ? rel.find(x => fold(x.title).startsWith(fold(f.ordre).slice(0, 4))) : null;
        try { await api("/api/ecospace/pulsation/flux", { method: "POST", body: { eco, pulsation: from, to, relative: r?.id ?? "", order: f.rang ?? "" } }); }
        catch (err) { warn.push(`flux « ${p.titre} » → « ${f.vers} » : ${err.message}`); }
      }
    }
    // 8. journal de la génération dans l'item de l'écosystème (saisies, suites proposées, modélisations, modèle validé)
    const counts = Object.entries(ids).map(([kk, x]) => `${x.size} ${kk}(s)`).join(", ");
    try {
      deps.busyStep("Journal de la génération dans l'item de l'écosystème (jdc:pipeline)");
      await api("/api/ecotext/pipeline", { method: "POST", body: { eco, run: new Date().toISOString(), sections: session.sections ?? {}, steps: session.journal ?? [],
        validated: m, report: `Créés : ${counts}.${warn.length ? ` Avertissements : ${warn.join(" ; ")}` : " Aucun avertissement."}` } });
    } catch (err) { warn.push(`journal de la génération non enregistré : ${err.message}`); }
  });
  const n = [...Object.values(ids)].reduce((s, x) => s + x.size, 0);
  deps.toast(`Écosystème ${eco} créé : ${n} élément(s), pouvoir(s) et pulsation(s)${warn.length ? ` · ${warn.length} avertissement(s)` : ""}`);
  if (warn.length) { console.warn("⚠️ Écosystème depuis un texte :", warn); alert(`Création terminée avec ${warn.length} avertissement(s) :\n- ${warn.join("\n- ")}`); }
  deps.onCreated({ id: eco, title });
}
