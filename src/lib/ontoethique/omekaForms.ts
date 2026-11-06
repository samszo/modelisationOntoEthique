// Contrôles propres aux pouvoirs existentiels saisis par formulaire : intensité de -100 à 100, type du pouvoir et
// maillons de sa séquence (physique → crible → actant → concept, concept → actant → concept…)
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import type { FormValue, TemplateForm } from "../omeka/templateForm";

export const formTitle = (form: TemplateForm, values: Record<string, FormValue[]>) => String(values[form.titleTerm]?.[0]?.value ?? "").trim();

// type de pouvoir désigné par un texte : identifiant, libellé (« Pouvoir de discerner ») ou titre de l'item du
// vocabulaire des types (« Discerner ») ; casse, accents et une faute de frappe (« Dicerner ») tolérés
const norm = (x: string) => x.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().trim();
const near = (a: string, b: string) => {
  if (Math.abs(a.length - b.length) > 1) return false;
  let i = 0, j = 0, diff = 0;
  while (i < a.length && j < b.length) {
    if (a[i] === b[j]) { i++; j++; continue; }
    if (++diff > 1) return false;
    if (a.length > b.length) i++; else if (b.length > a.length) j++; else { i++; j++; }
  }
  return diff + (a.length - i) + (b.length - j) <= 1;
};
export function powerTypeOf(text: string, config: OntoEthiqueConfig) {
  const t = norm(String(text ?? ""));
  if (!t) return null;
  return config.omekaForms.powerTypes.find(p => [p.id, p.label, p.label.split(" ").pop() ?? ""].some(x => near(norm(x), t))) ?? null;
}

export function checkPower(values: Record<string, FormValue[]>, config: OntoEthiqueConfig) {
  const f = config.omekaForms;
  const raw = String(values[f.intensity.term]?.[0]?.value ?? "").trim();
  const intensity = Number(raw);
  if (!/^[+-]?\d+$/.test(raw) || intensity < f.intensity.min || intensity > f.intensity.max) throw new Error(`Intensité du pouvoir : entier de ${f.intensity.min} à ${f.intensity.max} attendu`);
  // type : texte, ou item du vocabulaire des types (son titre dans label)
  const tv = values[f.powerTypeTerm]?.[0];
  const type = powerTypeOf(String(tv?.value ?? tv?.label ?? ""), config);
  if (!type) throw new Error(`Type de pouvoir attendu : ${f.powerTypes.map(t => t.label).join(", ")}`);
  // au moins un élément par maillon ; un maillon peut en relier plusieurs (relations multiples) ; un même terme peut
  // servir deux maillons (concept source et destination) : le rôle est porté par une annotation de la valeur (EcoSpace),
  // sinon par l'ordre des valeurs
  for (const term of new Set(type.sequence.map(s => s.term))) {
    const links = type.sequence.filter(s => s.term === term);
    if ((values[term]?.length ?? 0) < links.length) throw new Error(`${type.label} : ${links.map(l => l.name).join(" et ")} attendu(s) (${term})`);
  }
  const allowed = new Set(type.sequence.map(s => s.term));
  const extra = f.powerTypes.flatMap(t => t.sequence.map(s => s.term)).filter(t => !allowed.has(t) && values[t]?.length);
  if (extra.length) throw new Error(`${type.label} : ${[...new Set(extra)].join(", ")} hors de la séquence`);
}
