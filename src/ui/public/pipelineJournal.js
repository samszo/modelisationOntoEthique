// Journal de la génération d'un écosystème depuis un texte (propriété jdc:pipeline de l'item, valeurs annotées selon le
// template 17) : affiché dans l'onglet « Journal » des détails (EcoSpace, EcoNetwork), par génération puis par étape

const h = (tag, props = {}, ...children) => {
  const e = Object.assign(document.createElement(tag), props);
  for (const c of children.flat()) if (c != null && c !== false) e.append(c);
  return e;
};

const CSS = `
.pj-run { margin: 0 0 14px; }
.pj-run > h3 { font-size: 15px; margin: 0 0 6px; }
.pj-step { border: 1px solid var(--line); border-radius: 6px; margin: 4px 0; background: var(--panel); }
.pj-step > summary { cursor: pointer; padding: 6px 10px; display: flex; gap: 8px; align-items: baseline; font-size: 14px; }
.pj-step > summary .k { font-size: 11.5px; border-radius: 10px; padding: 1px 7px; background: var(--bg); color: var(--muted); white-space: nowrap; }
.pj-step > summary .m { margin-left: auto; color: var(--muted); font-size: 12px; text-align: right; }
.pj-body { padding: 4px 10px 10px; border-top: 1px solid var(--line); }
.pj-body h4 { margin: 8px 0 3px; font-size: 12.5px; color: var(--muted); font-weight: 600; }
.pj-body pre { margin: 0; white-space: pre-wrap; word-break: break-word; font: 12.5px/1.45 ui-monospace, SFMono-Regular, Menlo, monospace; background: var(--bg); padding: 6px 8px; border-radius: 4px; max-height: 320px; overflow: auto; }
.pj-body p { margin: 0; white-space: pre-wrap; font-size: 13.5px; }
`;

// genre d'étape d'après son libellé (Saisie, Suite proposée, Modélisation…)
const kindOf = label => /^Saisie/.test(label) ? "saisie" : /^Suite propos/.test(label) ? "suggestion" : /validée/.test(label) ? "validation" : /^Modélisation/.test(label) ? "modélisation" : "étape";
// réponse JSON indentée si elle en est une
const pretty = s => { try { const o = JSON.parse(s); return JSON.stringify(o, null, 2); } catch { return s; } };

// nombre d'étapes du journal d'un item (0 s'il n'en a pas)
export async function pipelineCount(api, item) {
  try { const r = await api(`/api/ecotext/pipeline?item=${item}`); return r.runs.reduce((n, x) => n + x.steps.length, 0); } catch { return 0; }
}

// remplit box avec le journal de l'item
export async function renderPipeline(box, api, item) {
  if (!document.getElementById("pj-css")) document.head.append(h("style", { id: "pj-css", textContent: CSS }));
  box.replaceChildren(h("p", { className: "muted", textContent: "Chargement du journal…" }));
  let r;
  try { r = await api(`/api/ecotext/pipeline?item=${item}`); } catch (e) { box.replaceChildren(h("p", { className: "ko", textContent: e.message })); return 0; }
  if (!r.runs.length) { box.replaceChildren(h("p", { className: "muted", textContent: `Aucune génération enregistrée dans ${r.property} : le journal est écrit quand l'écosystème est créé depuis un texte (étape 1.1 d'EcoSpace).` })); return 0; }
  box.replaceChildren(
    h("p", { className: "help", textContent: `Journal de la génération depuis un texte (${r.property}, valeurs annotées : demande, réponse, modèle, coût), de la plus récente à la plus ancienne.` }),
    ...r.runs.map(run => h("section", { className: "pj-run" },
      h("h3", { textContent: `Génération du ${run.at || "?"} · ${run.steps.length} étape(s)` }),
      ...run.steps.map(st => {
        const kind = kindOf(st.label), body = [];
        if (st.description) body.push(h("h4", { textContent: kind === "saisie" ? "Texte saisi" : kind === "validation" ? "Bilan" : "Description" }), h("p", { textContent: st.description }));
        if (st.prompt) body.push(h("details", {}, h("summary", { textContent: "Demande envoyée au modèle" }), h("pre", { textContent: st.prompt })));
        if (st.response) body.push(h("h4", { textContent: kind === "suggestion" ? "Suite proposée" : "Réponse" }), h("pre", { textContent: pretty(st.response) }));
        const meta = [st.model, st.cost].filter(Boolean).join(" · ");
        return h("details", { className: "pj-step", open: kind === "validation" },
          h("summary", {}, h("span", { className: "k", textContent: kind }), h("span", { textContent: st.label }), meta ? h("span", { className: "m", textContent: meta }) : null),
          h("div", { className: "pj-body" }, body.length ? body : h("p", { className: "muted", textContent: "—" })));
      }))));
  return r.runs.length;
}
