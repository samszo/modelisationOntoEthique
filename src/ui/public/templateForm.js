// Formulaires générés depuis les resource templates Omeka S (/api/ontoethique/form) : champs répétables, choix du type de
// donnée, listes des custom vocabs, recherche d'items liés, annotations de valeur, intensité et séquence des pouvoirs.

const h = (tag, props = {}, ...children) => {
  const e = Object.assign(document.createElement(tag), props);
  for (const c of children.flat()) if (c != null && c !== false) e.append(c);
  return e;
};

const CSS = `
.tf-steps { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 14px; }
.tf-field { border-top: 1px solid var(--line); padding: 10px 0; }
.tf-field > label { display: block; }
.tf-value { display: flex; gap: 6px; align-items: flex-start; flex-wrap: wrap; margin-top: 6px; }
.tf-value > * { flex: 1 1 200px; }
.tf-value select.tf-type { flex: 0 1 170px; }
.tf-value > button { flex: 0 0 auto; }
.tf-ann { flex: 1 1 100%; border-left: 3px solid var(--accent); padding-left: 10px; }
.tf-seq { background: var(--bg); border-radius: 6px; padding: 6px 10px; font-size: 13px; margin: 6px 0; }
.tf-meta { font-size: 12.5px; color: var(--muted); margin-bottom: 8px; }
.tf-range { display: flex; gap: 10px; align-items: center; }
.tf-range input[type=range] { flex: 1; padding: 0; accent-color: var(--accent); }
.tf-range input[type=number] { width: 90px; }
`;

// éditeur d'une valeur ; read() renvoie { type, value | id | uri, label, annotation } ou null si elle est vide ;
// initial : valeur existante (modification d'un item)
function valueEditor(field, ctx, onRemove, initial) {
  const box = h("div", { className: "tf-value" });
  const typeSel = field.dataTypes.length > 1 ? h("select", { className: "tf-type", title: "Type de valeur", onchange: () => renderInput() }, field.dataTypes.map(d => h("option", { value: d.type, textContent: d.label }))) : null;
  // valeur existante d'un type absent du template (ex. item lié enregistré hors custom vocab) : rapportée au premier
  // type de même nature, pour être affichée et réenregistrée selon le template
  if (initial && !field.dataTypes.some(d => d.type === initial.type)) {
    const kind = initial.id ? "item" : initial.uri ? "uri" : null;
    const same = field.dataTypes.find(d => (kind ? d.kind === kind : d.kind === "literal" || d.kind === "numeric"));
    if (same) initial = { ...initial, type: same.type };
  }
  if (typeSel && initial && field.dataTypes.some(d => d.type === initial.type)) typeSel.value = initial.type;
  const slot = h("div", { style: "display:flex;gap:6px;min-width:0" });
  let read = () => null;
  const current = () => field.dataTypes.find(d => d.type === (typeSel?.value ?? field.dataTypes[0].type));

  function renderInput() {
    const d = current();
    const init = initial && initial.type === d.type ? initial : null;
    if (d.options) {
      const sel = h("select", {}, h("option", { value: "", textContent: "— choisir —" }), d.options.map(o => h("option", { value: d.kind === "item" ? o.id : d.kind === "uri" ? o.uri : o.title, textContent: o.title })));
      if (init) {
        const v = String(d.kind === "item" ? init.id : d.kind === "uri" ? init.uri : init.value);
        if (![...sel.options].some(o => o.value === v)) sel.append(h("option", { value: v, textContent: init.label || v }));
        sel.value = v;
      }
      slot.replaceChildren(sel);
      read = () => !sel.value ? null : d.kind === "item" ? { type: d.type, id: Number(sel.value) } : d.kind === "uri" ? { type: d.type, uri: sel.value, label: sel.selectedOptions[0].textContent } : { type: d.type, value: sel.value };
    } else if (d.kind === "item") {
      const q = h("input", { placeholder: "Rechercher un item…" });
      const sel = h("select", {}, h("option", { value: "", textContent: "— résultats —" }));
      if (init) { sel.append(h("option", { value: init.id, textContent: `${init.label ?? "item"} (${init.id})` })); sel.value = String(init.id); }
      let timer = null;
      q.oninput = () => { clearTimeout(timer); timer = setTimeout(async () => {
        try {
          const rs = await ctx.api(`/api/ontoethique/form/search?template=${ctx.templateId}&term=${encodeURIComponent(field.term)}&q=${encodeURIComponent(q.value)}`);
          sel.replaceChildren(h("option", { value: "", textContent: `— ${rs.length} résultat(s) —` }), ...rs.map(r => h("option", { value: r.id, textContent: `${r.title} (${r.id})` })));
        } catch (e) { ctx.toast("Recherche : " + e.message); }
      }, 250); };
      slot.replaceChildren(q, sel);
      read = () => sel.value ? { type: d.type, id: Number(sel.value) } : null;
    } else if (d.kind === "uri") {
      const uri = h("input", { type: "url", placeholder: "https://…", value: init?.uri ?? "" }), label = h("input", { placeholder: "libellé", value: init?.label ?? "" });
      slot.replaceChildren(uri, label);
      read = () => uri.value.trim() ? { type: d.type, uri: uri.value.trim(), label: label.value.trim() } : null;
    } else if (d.kind === "numeric" && d.type === "numeric:timestamp") {
      // date (Numeric Data Types) : année, année-mois, date ou date et heure
      const n = h("input", { value: init?.value ?? "", placeholder: "AAAA, AAAA-MM-JJ ou AAAA-MM-JJTHH:MM:SS", pattern: "-?\\d{1,4}(-\\d{2}(-\\d{2}(T\\d{2}(:\\d{2}(:\\d{2})?)?)?)?)?" });
      slot.replaceChildren(n);
      read = () => n.value.trim() ? { type: d.type, value: n.value.trim() } : null;
    } else if (d.kind === "numeric") {
      const n = h("input", { type: "number", step: 1, value: init?.value ?? "" });
      slot.replaceChildren(n);
      read = () => n.value !== "" ? { type: d.type, value: n.value } : null;
    } else {
      const t = field.term === "dcterms:description" ? h("textarea", { rows: 3, value: init?.value ?? "" }) : h("input", { value: init?.value ?? "" });
      slot.replaceChildren(t);
      read = () => t.value.trim() ? { type: d.type, value: t.value.trim() } : null;
    }
  }
  renderInput();
  const ann = field.annotation ? fieldsEditor(field.annotation, ctx, initial?.annotation) : null;
  box.append(...[typeSel, slot, onRemove ? h("button", { type: "button", className: "link", textContent: "Retirer", onclick: () => { box.remove(); onRemove(); } }) : null,
    ann ? h("div", { className: "tf-ann" }, h("div", { className: "help", textContent: "Temporalité de cette relation" }), ann.el) : null].filter(Boolean));
  box._read = () => { const v = read(); if (v && ann) { const a = ann.read(); if (Object.keys(a).length) v.annotation = a; } return v; };
  return box;
}

function fieldEditor(field, ctx, initial = []) {
  const list = h("div");
  const add = (removable, value) => {
    const v = valueEditor(field, ctx, removable ? refresh : null, value);
    list.append(v); refresh();
  };
  const more = h("button", { type: "button", className: "link", textContent: "+ Ajouter une valeur", onclick: () => add(true) });
  function refresh() { more.hidden = !!field.maxValues && list.children.length >= field.maxValues; }
  if (initial.length) initial.forEach((v, i) => add(i > 0, v)); else add(false);
  return { el: h("div", { className: "tf-field" }, h("label", { textContent: `${field.label}${field.required ? " *" : ""}` }), field.comment ? h("div", { className: "help", textContent: field.comment }) : null, list, more),
    read: () => [...list.children].map(c => c._read()).filter(Boolean), add };
}

function fieldsEditor(fields, ctx, initial = {}) {
  const eds = fields.map(f => ({ f, ed: fieldEditor(f, ctx, initial?.[f.term] ?? []) }));
  return { el: h("div", {}, eds.map(x => x.ed.el)), eds, read: () => Object.fromEntries(eds.map(x => [x.f.term, x.ed.read()]).filter(([, v]) => v.length)) };
}

// pouvoir existentiel : l'intensité et le type remplacent leurs champs libres ; la séquence du type guide la saisie
function powerControls(form, ctx, initial = {}) {
  const { intensity, types } = form.power;
  const start = Number(initial[intensity.term]?.[0]?.value ?? 0) || 0;
  const num = h("input", { type: "number", min: intensity.min, max: intensity.max, step: intensity.step, value: start });
  const range = h("input", { type: "range", min: intensity.min, max: intensity.max, step: intensity.step, value: start });
  const meaning = h("span", { className: "help" });
  const show = () => { const v = Number(num.value); meaning.textContent = v === 0 ? "pas de changement" : v < 0 ? "diminution du pouvoir" : "augmentation du pouvoir"; };
  range.oninput = () => { num.value = range.value; show(); };
  num.oninput = () => { range.value = num.value; show(); };
  show();
  const type = h("select", {}, types.map(t => h("option", { value: t.label, textContent: t.label })));
  if (types.some(t => t.label === initial[form.power.typeTerm]?.[0]?.value)) type.value = initial[form.power.typeTerm][0].value;
  const seq = h("div", { className: "tf-seq" });
  const showSeq = () => { seq.textContent = `Séquence : ${types.find(t => t.label === type.value).sequence.map(s => s.name).join(" → ")}. Saisir les concepts dans cet ordre.`; };
  type.onchange = showSeq; showSeq();
  return {
    el: h("div", {},
      h("div", { className: "tf-field" }, h("label", { textContent: "Type de pouvoir *" }), type, seq),
      h("div", { className: "tf-field" }, h("label", { textContent: "Intensité * (-100 : diminution extrême, 0 : pas de changement, 100 : augmentation extrême)" }), h("div", { className: "tf-range" }, range, num), meaning)),
    read: () => ({ [intensity.term]: [{ type: "literal", value: num.value }], [form.power.typeTerm]: [{ type: "literal", value: type.value }] }),
  };
}

// formulaire d'un template dessiné dans box ; values : valeurs existantes ; onSubmit(values) enregistre
export async function templateForm(box, { api, toast, templateId, values = {}, submitLabel = "Enregistrer", onSubmit }) {
  if (!document.getElementById("tf-css")) document.head.append(h("style", { id: "tf-css", textContent: CSS }));
  box.replaceChildren(h("p", { className: "muted", textContent: "Chargement du modèle…" }));
  const form = await api(`/api/ontoethique/form?template=${templateId}`);
  const c = { api, toast, templateId };
  const skip = form.power ? new Set([form.power.intensity.term, form.power.typeTerm]) : new Set();
  const fields = fieldsEditor(form.fields.filter(f => !skip.has(f.term)), c, values);
  const power = form.power ? powerControls(form, c, values) : null;
  const status = h("span", { className: "muted", style: "font-size:13px" });
  const submit = h("button", { type: "submit", className: "btn primary", textContent: submitLabel });
  box.replaceChildren(h("form", { onsubmit: async e => {
    e.preventDefault();
    submit.disabled = true;
    try { await onSubmit({ ...fields.read(), ...(power?.read() ?? {}) }, status); }
    catch (err) { status.textContent = ""; toast("Erreur : " + err.message); }
    finally { submit.disabled = false; }
  } },
    h("div", { className: "tf-meta", textContent: `Modèle « ${form.label} » · classe ${form.resourceClass?.term || "—"} · collection(s) d'items : ${form.itemSets.map(s => s.title).join(", ") || "—"}` }),
    power?.el, fields.el,
    h("div", { className: "toolbar", style: "margin-top:12px" }, submit, status)));
  return form;
}

// dernier formulaire demandé : la réponse d'un formulaire abandonné entre-temps est ignorée
let formRequest = 0;
async function renderForm(box, listBox, t, ctx, admin) {
  const request = ++formRequest;
  box.replaceChildren(h("p", { className: "muted", textContent: "Chargement du modèle…" }));
  listBox.replaceChildren();
  let form;
  try { form = await ctx.api(`/api/ontoethique/form?template=${t.templateId}`); }
  catch (e) { if (request === formRequest) box.replaceChildren(h("p", { className: "ko", textContent: e.message })); return; }
  if (request !== formRequest) return;
  const c = { ...ctx, templateId: t.templateId };
  const skip = form.power ? new Set([form.power.intensity.term, form.power.typeTerm]) : new Set();
  const fields = fieldsEditor(form.fields.filter(f => !skip.has(f.term)), c);
  const power = form.power ? powerControls(form, c) : null;
  const status = h("span", { className: "muted", style: "font-size:13px" });
  const submit = h("button", { type: "submit", className: "btn primary", textContent: "Créer l'item" });
  const el = h("form", { onsubmit: async e => {
    e.preventDefault();
    submit.disabled = true;
    try {
      const r = await ctx.api("/api/ontoethique/form/item", { method: "POST", body: { template: t.templateId, values: { ...fields.read(), ...(power?.read() ?? {}) } } });
      status.replaceChildren(r.created ? "Item créé : " : "Déjà présent, non recréé : ", r.adminUrl ? h("a", { href: r.adminUrl, target: "_blank", textContent: `${r.title} (${r.id})`, style: "color:var(--accent)" }) : `${r.title} (${r.id})`);
      if (r.created) { renderForm(box, listBox, t, ctx, admin); ctx.toast(`${t.label} : item ${r.id} créé`); }
    } catch (err) { status.textContent = ""; ctx.toast("Erreur : " + err.message); }
    finally { submit.disabled = false; }
  } },
    h("div", { className: "tf-meta", textContent: `Modèle « ${form.label} » · classe ${form.resourceClass?.term || "—"} · collection(s) d'items : ${form.itemSets.map(s => s.title).join(", ") || "—"}` }),
    power?.el, fields.el,
    h("div", { className: "toolbar", style: "margin-top:12px" }, submit, status));
  box.replaceChildren(el);
  try {
    const items = await ctx.api(`/api/ontoethique/form/items?template=${t.templateId}`);
    if (request !== formRequest) return;
    listBox.replaceChildren(h("h3", { style: "font-size:14px;margin:16px 0 4px", textContent: `Items existants (${items.length})` }),
      items.length ? h("div", {}, items.map(i => h("a", { className: "chip", href: admin + i.id, target: "_blank", textContent: i.title }))) : h("p", { className: "muted", textContent: "Aucun item." }));
  } catch (e) { listBox.textContent = e.message; }
}

export async function templateFormPanel(root, ctx) {
  if (!document.getElementById("tf-css")) document.head.append(h("style", { id: "tf-css", textContent: CSS }));
  let data;
  try { data = await ctx.api("/api/ontoethique/forms"); }
  catch (e) { root.textContent = e.message; return; }
  const box = h("div"), listBox = h("div");
  const open = (t, b) => { for (const x of steps.children) x.classList.toggle("primary", x === b); renderForm(box, listBox, t, ctx, data.omekaAdmin); };
  const steps = h("div", { className: "tf-steps" }, data.templates.map((t, i) => { const b = h("button", { type: "button", className: "btn small", textContent: `${i + 1}. ${t.label}`, onclick: () => open(t, b) }); return b; }));
  root.replaceChildren(steps, box, listBox);
  open(data.templates[0], steps.children[0]);
}
