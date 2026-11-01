// Contrôles propres aux pouvoirs existentiels saisis par formulaire : intensité de -100 à 100, type du pouvoir et
// maillons de sa séquence (physique → crible → actant → concept, concept → actant → concept…)
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import type { FormValue, TemplateForm } from "../omeka/templateForm";

export const formTitle = (form: TemplateForm, values: Record<string, FormValue[]>) => String(values[form.titleTerm]?.[0]?.value ?? "").trim();

export function checkPower(values: Record<string, FormValue[]>, config: OntoEthiqueConfig) {
  const f = config.omekaForms;
  const raw = String(values[f.intensity.term]?.[0]?.value ?? "").trim();
  const intensity = Number(raw);
  if (!/^[+-]?\d+$/.test(raw) || intensity < f.intensity.min || intensity > f.intensity.max) throw new Error(`Intensité du pouvoir : entier de ${f.intensity.min} à ${f.intensity.max} attendu`);
  const label = String(values[f.powerTypeTerm]?.[0]?.value ?? "");
  const type = f.powerTypes.find(t => t.label === label);
  if (!type) throw new Error(`Type de pouvoir attendu : ${f.powerTypes.map(t => t.label).join(", ")}`);
  // un même terme peut servir deux maillons (concept source et destination) : l'ordre des valeurs porte la séquence
  for (const term of new Set(type.sequence.map(s => s.term))) {
    const links = type.sequence.filter(s => s.term === term);
    if ((values[term]?.length ?? 0) !== links.length) throw new Error(`${type.label} : ${links.map(l => l.name).join(" et ")} attendu(s) (${term})`);
  }
  const allowed = new Set(type.sequence.map(s => s.term));
  const extra = f.powerTypes.flatMap(t => t.sequence.map(s => s.term)).filter(t => !allowed.has(t) && values[t]?.length);
  if (extra.length) throw new Error(`${type.label} : ${[...new Set(extra)].join(", ")} hors de la séquence`);
}
