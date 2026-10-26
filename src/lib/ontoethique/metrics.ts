// Mesure des fluctuations : statistiques des quatre pouvoirs par existence et par genre, affects (joie, tristesse),
// complexité ontologique, indicateurs de symbiose et alertes, trajectoire en spirale conique de Pappus
import type { OntoEthiqueConfig } from "../../config/ontoethique";
import { trajectory, type OntoModel } from "./model";

export interface PowerStats {
  count: number;
  mean: number | null;
  sum: number;
  // somme des augmentations (scores > 0) et des diminutions (scores < 0)
  increase: number;
  decrease: number;
  min: number | null;
  max: number | null;
  // état de la grille des affects d'après la moyenne : diminution, neutre, augmentation
  state: "negative" | "neutral" | "positive" | null;
  stateName: string | null;
}

export interface SpiralPoint { x: number; y: number; z: number; pulsation: string | null }
export interface Spiral {
  // dilatation rhizomatique (Σ augmentations de Résonner), altitude (Σ augmentations d'Agir),
  // déplacement topographique (Σ Discerner + Raisonner) et nombre de tours correspondant
  dilation: number;
  altitude: number;
  displacement: number;
  turns: number;
  ratio: number | null;
  shape: string;
  points: SpiralPoint[];
}

export interface ExistenceMetrics {
  id: string;
  name: string;
  kind: string;
  pulsations: number;
  powers: Record<string, PowerStats>;
  // moyenne de tous les scores (valence) et des écarts à 0 (intensité de la fluctuation)
  valence: number | null;
  intensity: number | null;
  affect: "joie" | "tristesse" | "indifférence" | null;
  values: Record<string, number | null>;
  complexity: { counts: Record<string, number>; elements: number; entropy: number; index: number };
  spiral: Spiral;
}

export interface Alert { type: string; level: "info" | "attention" | "alerte"; existence?: string; message: string }

const round = (x: number, d = 1) => Math.round(x * 10 ** d) / 10 ** d;
const mean = (xs: number[]) => (xs.length ? xs.reduce((a, b) => a + b, 0) / xs.length : null);

function powerStats(scores: number[], power: OntoEthiqueConfig["powers"][number]): PowerStats {
  const m = mean(scores);
  const state = m === null ? null : m < -0.5 ? "negative" : m > 0.5 ? "positive" : "neutral";
  return {
    count: scores.length, mean: m === null ? null : round(m), sum: scores.reduce((a, b) => a + b, 0),
    increase: scores.filter(s => s > 0).reduce((a, b) => a + b, 0), decrease: scores.filter(s => s < 0).reduce((a, b) => a + b, 0),
    min: scores.length ? Math.min(...scores) : null, max: scores.length ? Math.max(...scores) : null,
    state, stateName: state ? power[state].name : null,
  };
}

// complexité ontologique (proposition d'opérationnalisation) : répartition des éléments entre les quatre dimensions
// (entropie normalisée : 1 = dimensions également constituées) pondérée par le nombre d'éléments (log2(1 + n))
function complexity(dimensions: Record<string, string[]>, config: OntoEthiqueConfig) {
  const counts = Object.fromEntries(config.dimensions.map(d => [d.id, (dimensions[d.id] ?? []).length]));
  const n = Object.values(counts).reduce((a, b) => a + b, 0);
  const k = config.dimensions.length;
  const entropy = n && k > 1 ? -Object.values(counts).filter(c => c > 0).reduce((s, c) => s + (c / n) * Math.log(c / n), 0) / Math.log(k) : 0;
  return { counts, elements: n, entropy: round(entropy, 2), index: round(entropy * Math.log2(1 + n), 2) };
}

// trajectoire : à chaque pulsation, le rayon croît des augmentations de Résonner, l'altitude de celles d'Agir, l'angle
// tourne de Discerner + Raisonner (sens inverse si la somme est négative) ; points interpolés entre deux pulsations
function spiral(model: OntoModel, existenceId: string, config: OntoEthiqueConfig): Spiral {
  const s = config.spiral;
  const points: SpiralPoint[] = [{ x: 0, y: 0, z: 0, pulsation: null }];
  let r = 0, z = 0, t = 0;
  const radii: number[] = [0], heights: number[] = [0];
  for (const p of trajectory(model, existenceId)) {
    const sc = (id: string) => p.evaluations[id]?.score ?? 0;
    const r1 = r + Math.max(0, sc("resonner")), z1 = z + Math.max(0, sc("agir")), t1 = t + sc("discerner") + sc("raisonner");
    for (let i = 1; i <= s.stepsPerPulsation; i++) {
      const f = i / s.stepsPerPulsation;
      const rr = r + (r1 - r) * f, theta = (2 * Math.PI * (t + (t1 - t) * f)) / s.pointsPerTurn;
      points.push({ x: round(rr * Math.cos(theta), 2), y: round(rr * Math.sin(theta), 2), z: round(z + (z1 - z) * f, 2), pulsation: i === s.stepsPerPulsation ? p.id : null });
    }
    r = r1; z = z1; t = t1;
    radii.push(r); heights.push(z);
  }
  const ratio = z > 0 ? round(r / z, 2) : null;
  // forme : élargissement négligeable sur la seconde moitié alors que l'altitude progresse → tube
  const half = Math.floor((radii.length - 1) / 2);
  const tube = radii.length > 2 && r > 0 && (r - radii[half]!) / r < s.tubeGrowth && z > 0 && (z - heights[half]!) / z > 0.3;
  const shape = !r && !z ? "point (aucune augmentation)" : !z ? "disque (résonance sans trace)" : tube ? "tube" : ratio! > s.flaredRatio ? "cône évasé" : ratio! < s.slenderRatio ? "flèche (cône élancé)" : "cône équilibré";
  return { dilation: r, altitude: z, displacement: t, turns: round(t / s.pointsPerTurn, 2), ratio, shape, points };
}

export function computeMetrics(model: OntoModel, config: OntoEthiqueConfig) {
  const th = config.symbiosis;
  const existences: ExistenceMetrics[] = model.existences.map(e => {
    const list = model.pulsations.filter(p => p.existence === e.id);
    const all: number[] = [];
    const powers = Object.fromEntries(config.powers.map(pw => {
      const scores = list.map(p => p.evaluations[pw.id]?.score).filter((v): v is number => typeof v === "number");
      all.push(...scores);
      return [pw.id, powerStats(scores, pw)];
    }));
    const valence = mean(all), intensity = mean(all.map(Math.abs));
    const values = Object.fromEntries(config.values.map(v => {
      const xs = list.map(p => p.values?.[v.id]).filter((x): x is number => typeof x === "number");
      return [v.id, xs.length ? round(mean(xs)!) : null];
    }));
    return {
      id: e.id, name: e.name, kind: e.kind, pulsations: list.length, powers,
      valence: valence === null ? null : round(valence), intensity: intensity === null ? null : round(intensity),
      affect: valence === null ? null : valence > 0.5 ? "joie" : valence < -0.5 ? "tristesse" : "indifférence",
      values, complexity: complexity(e.dimensions ?? {}, config), spiral: spiral(model, e.id, config),
    };
  });

  // moyennes par genre d'existence (comparaison humains / agents / environnement)
  const byKind = Object.fromEntries(config.kinds.map(k => {
    const xs = existences.filter(e => e.kind === k.id);
    const pm = (id: string) => { const v = xs.map(e => e.powers[id]?.mean).filter((x): x is number => x !== null && x !== undefined); return v.length ? round(mean(v)!) : null; };
    const val = xs.map(e => e.valence).filter((x): x is number => x !== null);
    return [k.id, { label: k.label, existences: xs.length, powers: Object.fromEntries(config.powers.map(p => [p.id, pm(p.id)])), valence: val.length ? round(mean(val)!) : null }];
  }));

  // symbiose : valence moyenne de l'écosystème (de -1 à 1) et équilibre entre les genres (1 = mêmes fluctuations)
  const valences = existences.map(e => e.valence).filter((x): x is number => x !== null);
  const kindValences = Object.values(byKind).map(k => k.valence).filter((x): x is number => x !== null);
  const index = valences.length ? round(mean(valences)! / 100, 2) : null;
  const balance = kindValences.length > 1 ? round(1 - (Math.max(...kindValences) - Math.min(...kindValences)) / 200, 2) : null;
  const interpretation = index === null ? "aucune évaluation"
    : index > 0.2 ? (balance === null || balance > 0.6 ? "symbiose mutuellement profitable" : "croissance déséquilibrée : profit asymétrique entre les genres d'existences")
    : index < -0.2 ? "diminution des puissances (tristesse) : l'agencement appauvrit les existences" : "indifférence ou stase : l'activité change peu les puissances";

  const alerts: Alert[] = [];
  const kindLabel = (k: string) => config.kinds.find(x => x.id === k)?.label ?? k;
  const m = (e: ExistenceMetrics, id: string) => e.powers[id]?.mean ?? null;
  const agentsActing = existences.filter(e => e.kind !== "humain" && (m(e, "agir") ?? -Infinity) >= th.highThreshold);
  for (const e of existences) {
    if (e.kind === "humain" && (m(e, "raisonner") ?? 0) <= th.lowThreshold && (m(e, "resonner") ?? 0) <= th.lowThreshold && agentsActing.length) {
      alerts.push({ type: "misere-symbolique", level: "alerte", existence: e.id,
        message: `Risque de misère symbolique pour ${e.name} : Raisonner (${m(e, "raisonner")}) et Résonner (${m(e, "resonner")}) diminuent alors que ${agentsActing.map(a => a.name).join(", ")} agi${agentsActing.length > 1 ? "ssent" : "t"} fortement (Agir ≥ ${th.highThreshold}).` });
    }
    if ((m(e, "discerner") ?? 0) <= th.lowThreshold) alerts.push({ type: "cecite-cognitive", level: "attention", existence: e.id, message: `Cécité cognitive de ${e.name} (Discerner ${m(e, "discerner")}) : revoir les cribles qui filtrent l'information.` });
    if ((m(e, "raisonner") ?? 0) <= th.lowThreshold && e.kind !== "humain") alerts.push({ type: "alienation-logique", level: "attention", existence: e.id, message: `Aliénation logique de ${e.name} (${kindLabel(e.kind)}, Raisonner ${m(e, "raisonner")}) : incohérences ou biais à vérifier.` });
    if ((e.values.verite ?? 0) <= th.indignationThreshold) alerts.push({ type: "indignation", level: "alerte", existence: e.id, message: `Indignation : la valeur-vérité accordée par ou à ${e.name} s'effondre (${e.values.verite}) ; la croyance bascule en défiance.` });
    if ((m(e, "agir") ?? 1) === 0 && e.powers.agir?.count) alerts.push({ type: "geste-blanc", level: "info", existence: e.id, message: `Geste blanc de ${e.name} : actions sans trace dans l'écosystème.` });
  }
  // une évaluation humaine qui attribue une résonance à un genre qui n'y a pas accès conteste l'hypothèse du métamodèle
  const noResonance = new Set(config.kinds.filter(k => k.resonance === false).map(k => k.id));
  for (const p of model.pulsations) {
    const ex = model.existences.find(e => e.id === p.existence);
    const ev = p.evaluations.resonner;
    if (ex && noResonance.has(ex.kind) && ev?.validated && ev.origin !== "regle" && config.rules.noResonanceScore !== null && ev.score !== config.rules.noResonanceScore) {
      alerts.push({ type: "barriere-contestee", level: "info", existence: ex.id, message: `Pulsation ${p.id} : une évaluation humaine de Résonner (${ev.score}) pour ${ex.name} s'écarte de la barrière numérique (${config.rules.noResonanceScore}) — hypothèse du métamodèle à discuter.` });
    }
  }
  if (balance !== null && balance <= 0.6) alerts.push({ type: "desequilibre", level: "attention", message: `Déséquilibre entre les genres d'existences (équilibre ${balance}) : les fluctuations profitent surtout à ${Object.values(byKind).filter(k => k.valence !== null).sort((a, b) => b.valence! - a.valence!)[0]?.label}.` });

  const complexities = existences.map(e => e.complexity.index);
  return {
    computedAt: new Date().toISOString(),
    totals: { existences: existences.length, pulsations: model.pulsations.length, evaluations: model.pulsations.reduce((n, p) => n + Object.values(p.evaluations).filter(e => e.score !== null).length, 0),
      validated: model.pulsations.reduce((n, p) => n + Object.values(p.evaluations).filter(e => e.validated).length, 0) },
    existences,
    byKind,
    symbiosis: { index, balance, interpretation },
    complexity: { mean: complexities.length ? round(mean(complexities)!, 2) : null, max: complexities.length ? Math.max(...complexities) : null },
    alerts,
  };
}
export type Metrics = ReturnType<typeof computeMetrics>;
