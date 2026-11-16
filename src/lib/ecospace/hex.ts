// Grille hexagonale d'EcoSpace : coordonnées cube (q, r, s ; q + r + s = 0, cf. redblobgames.com/grids/hexagons),
// position dans la scène (x vers l'est, z vers le sud, y = altitude, en mètres) et coordonnées géographiques
export interface GridSpec {
  radius: number;
  hexSize: number;
  orientation: "pointy" | "flat";
  origin: { lon: number; lat: number; alt: number };
}
export interface Hex { q: number; r: number; s: number }

const M_PER_DEG = 111_320; // mètres par degré de latitude (approximation sphérique, suffisante à l'échelle d'un écosystème)

export const hexKey = (h: { q: number; r: number }) => `${h.q},${h.r}`;
export const cubeDistance = (a: Hex, b: Hex) => Math.max(Math.abs(a.q - b.q), Math.abs(a.r - b.r), Math.abs(a.s - b.s));
export const inGrid = (g: GridSpec, h: { q: number; r: number }) => cubeDistance({ q: 0, r: 0, s: 0 }, { q: h.q, r: h.r, s: -h.q - h.r }) <= g.radius;

// hexagones de la grille, anneau par anneau depuis le centre
export function gridHexes(g: GridSpec): Hex[] {
  const out: Hex[] = [];
  for (let q = -g.radius; q <= g.radius; q++) {
    for (let r = Math.max(-g.radius, -q - g.radius); r <= Math.min(g.radius, -q + g.radius); r++) out.push({ q, r, s: -q - r || 0 });
  }
  return out.sort((a, b) => cubeDistance({ q: 0, r: 0, s: 0 }, a) - cubeDistance({ q: 0, r: 0, s: 0 }, b));
}

// centre de l'hexagone dans le plan (mètres) : x vers l'est, z vers le sud
export function hexToPlane(g: GridSpec, h: { q: number; r: number }) {
  const S = g.hexSize, R3 = Math.sqrt(3);
  return g.orientation === "flat"
    ? { x: S * 1.5 * h.q, z: S * (R3 / 2 * h.q + R3 * h.r) }
    : { x: S * (R3 * h.q + R3 / 2 * h.r), z: S * 1.5 * h.r };
}

// position dans la scène → longitude, latitude, altitude (projection locale autour de l'origine de la grille)
export function planeToGeo(g: GridSpec, p: { x: number; z: number }, y = 0) {
  const lat = g.origin.lat + -p.z / M_PER_DEG;
  const lon = g.origin.lon + p.x / (M_PER_DEG * Math.cos(g.origin.lat * Math.PI / 180));
  return { lon: +lon.toFixed(7), lat: +lat.toFixed(7), alt: +(g.origin.alt + y).toFixed(3) };
}

// longitude, latitude → position dans la scène (inverse de planeToGeo) ; y = altitude au-dessus de l'origine
export function geoToPlane(g: GridSpec, geo: { lon: number; lat: number; alt?: number }) {
  return { x: (geo.lon - g.origin.lon) * M_PER_DEG * Math.cos(g.origin.lat * Math.PI / 180), z: -(geo.lat - g.origin.lat) * M_PER_DEG, y: (geo.alt ?? g.origin.alt) - g.origin.alt };
}

// hexagone libre le plus proche d'un hexagone donné (duplication, conflit de position), anneau par anneau autour de
// lui, sans limite de grille (la grille s'étend par niveaux) ; null au-delà de maxRings anneaux
const CUBE_DIRS = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]];
export function nearestFree(_g: GridSpec, from: Hex, taken: Set<string>, maxRings = 200): Hex | null {
  if (!taken.has(hexKey(from))) return { q: from.q, r: from.r, s: -from.q - from.r || 0 };
  for (let k = 1; k <= maxRings; k++) {
    let q = from.q + CUBE_DIRS[4]![0]! * k, r = from.r + CUBE_DIRS[4]![1]! * k;
    for (let side = 0; side < 6; side++) for (let i = 0; i < k; i++) {
      if (!taken.has(hexKey({ q, r }))) return { q, r, s: -q - r || 0 };
      q += CUBE_DIRS[side]![0]!; r += CUBE_DIRS[side]![1]!;
    }
  }
  return null;
}
// hexagone plausible (la grille n'est plus bornée par son rayon : seulement des coordonnées raisonnables)
export const validHex = (h: { q: number; r: number }) => Number.isInteger(h.q) && Number.isInteger(h.r) && Math.abs(h.q) < 1e8 && Math.abs(h.r) < 1e8;

// hexagone qui contient un point du plan (inverse de hexToPlane, arrondi cube)
export function planeToHex(g: GridSpec, p: { x: number; z: number }): Hex {
  const S = g.hexSize, R3 = Math.sqrt(3);
  const fq = g.orientation === "flat" ? (2 / 3 * p.x) / S : (R3 / 3 * p.x - 1 / 3 * p.z) / S;
  const fr = g.orientation === "flat" ? (-1 / 3 * p.x + R3 / 3 * p.z) / S : (2 / 3 * p.z) / S;
  const fs = -fq - fr;
  let q = Math.round(fq), r = Math.round(fr), s = Math.round(fs);
  const dq = Math.abs(q - fq), dr = Math.abs(r - fr), ds = Math.abs(s - fs);
  if (dq > dr && dq > ds) q = -r - s; else if (dr > ds) r = -q - s; else s = -q - r;
  return { q: q || 0, r: r || 0, s: -q - r || 0 };
}

// sous-grille d'un hexagone (personnes et agents d'un actant) : hexagones d'orientation inverse, rings anneaux autour
// du centre, à la plus grande taille qui les garde tous dans l'hexagone parent (× margin) ; slots dans l'ordre des
// anneaux depuis le centre, x et z relatifs au centre du parent
export function subGrid(parent: GridSpec, rings: number, margin = 1) {
  const orientation: GridSpec["orientation"] = parent.orientation === "pointy" ? "flat" : "pointy";
  const unit: GridSpec = { radius: rings, hexSize: 1, orientation, origin: parent.origin };
  // norme hexagonale du parent (1 sur son contour) : projection maximale sur ses apothèmes
  const a0 = parent.orientation === "pointy" ? 0 : 30;
  const norm = (x: number, z: number) => Math.max(...[0, 60, 120].map(d => { const t = (a0 + d) * Math.PI / 180; return Math.abs(x * Math.cos(t) + z * Math.sin(t)); })) / (Math.sqrt(3) / 2);
  let m = 0;
  for (const h of gridHexes(unit)) {
    const c = hexToPlane(unit, h);
    for (let i = 0; i < 6; i++) { const a = ((orientation === "pointy" ? 30 : 0) + 60 * i) * Math.PI / 180; m = Math.max(m, norm(c.x + Math.cos(a), c.z + Math.sin(a))); }
  }
  const size = parent.hexSize / m * margin, spec: GridSpec = { ...unit, hexSize: size };
  return { orientation, size, rings, slots: gridHexes(spec).map(h => ({ ...h, ...hexToPlane(spec, h) })) };
}
// nombre d'anneaux nécessaires pour n emplacements (au moins min)
export const ringsFor = (n: number, min: number) => { let k = Math.max(0, min); while (1 + 3 * k * (k + 1) < n) k++; return k; };

// hexagones recalculés d'après les positions géographiques de référence (après un changement d'origine ou de position) :
// dans l'ordre de placement, hexagone (de la taille de base) qui contient la position, sinon le libre le plus proche sur
// la même couche ; la grille n'est pas agrandie (grille à niveaux : adaptiveGrid) ; modifie q, r, s, renvoie les
// éléments qui changent d'hexagone
export function rehexPlacements<P extends { item: number; q: number; r: number; s: number; shape: string; placed?: string; pos?: { lon: number; lat: number; alt?: number } }>(
  g: GridSpec, placements: P[], layerOf: (shape: string) => string): number[] {
  const ps = placements.filter(p => p.pos).sort((a, b) => String(a.placed ?? "").localeCompare(String(b.placed ?? "")));
  const taken = new Map<string, Set<string>>(), moved: number[] = [];
  for (const p of ps) {
    const layer = layerOf(p.shape), set = taken.get(layer) ?? new Set<string>();
    taken.set(layer, set);
    const h = nearestFree(g, planeToHex(g, geoToPlane(g, p.pos!)), set);
    if (!h) continue;
    set.add(hexKey(h));
    if (h.q !== p.q || h.r !== p.r) { moved.push(p.item); Object.assign(p, { q: h.q, r: h.r, s: -h.q - h.r || 0 }); }
  }
  return moved;
}

// grille à niveaux, sur le modèle de H3 (Uber ; API H3 de TravelTime) : hiérarchie d'ouverture 7, chaque hexagone a
// exactement 7 enfants (son enfant central et les 6 voisins de celui-ci), de côté √7 fois plus petit et tournés de
// atan(√3/5) ≈ 19,1° ; parent et enfants se calculent sur les coordonnées (multiplication par 2 + ω dans le réseau
// hexagonal, ω = rotation de 60°), sans recherche géométrique, et chaque hexagone de base a un seul ancêtre par niveau
// (partition exacte). Coordonnées d'un niveau L : axiales dans le réseau de ce niveau ; centre = celui de son
// descendant central au niveau 0
const cubeRound = (fq: number, fr: number): Hex => {
  const fs = -fq - fr;
  let q = Math.round(fq), r = Math.round(fr), s = Math.round(fs);
  const dq = Math.abs(q - fq), dr = Math.abs(r - fr), ds = Math.abs(s - fs);
  if (dq > dr && dq > ds) q = -r - s; else if (dr > ds) r = -q - s; else s = -q - r;
  return { q: q || 0, r: r || 0, s: -q - r || 0 };
};
export const APERTURE = 7;
// enfant central (niveau L - 1) d'un hexagone du niveau L, et parent (niveau L + 1) d'un hexagone du niveau L
export const centerChild = (h: { q: number; r: number }): Hex => ({ q: 2 * h.q - h.r, r: h.q + 3 * h.r, s: -(2 * h.q - h.r) - (h.q + 3 * h.r) || 0 });
export const parentHex = (h: { q: number; r: number }): Hex => cubeRound((3 * h.q + h.r) / 7, (-h.q + 2 * h.r) / 7);
export const childHexes = (h: { q: number; r: number }): Hex[] => {
  const c = centerChild(h);
  return [c, ...CUBE_DIRS.map(([dq, dr]) => ({ q: c.q + dq!, r: c.r + dr!, s: -(c.q + dq!) - (c.r + dr!) || 0 }))];
};
// rang d'un enfant chez son parent (0 = central, 1 à 6 = direction), chiffre de l'index hiérarchique
const childDigit = (h: { q: number; r: number }) => {
  const c = centerChild(parentHex(h)), d = [h.q - c.q, h.r - c.r];
  return d[0] === 0 && d[1] === 0 ? 0 : CUBE_DIRS.findIndex(([a, b]) => a === d[0] && b === d[1]) + 1;
};
// descendant central au niveau 0 d'un hexagone du niveau level (centre de l'hexagone)
const baseOf = (level: number, h: { q: number; r: number }) => { let x: { q: number; r: number } = h; for (let l = 0; l < level; l++) x = centerChild(x); return x; };
export const levelCenter = (g: GridSpec, level: number, h: { q: number; r: number }) => hexToPlane(g, baseOf(level, h));
// taille (centre → sommet) et rotation (degrés, sens du plan) des hexagones d'un niveau
export const levelSize = (g: GridSpec, level: number) => g.hexSize * Math.sqrt(APERTURE) ** level;
export function levelAngle(g: GridSpec, level: number) {
  const a = hexToPlane(g, { q: 1, r: 0 }), b = levelCenter(g, level, { q: 1, r: 0 });
  return (Math.atan2(b.z, b.x) - Math.atan2(a.z, a.x)) * 180 / Math.PI;
}
// le niveau du haut est le plus petit dont maxRings anneaux autour de l'origine contiennent tous les points ; un hexagone
// de niveau > 0 qui contient un point (élément placé, origine ou hexagone du disque de rayon g.radius autour d'elle) est
// découpé en ses 7 enfants, jusqu'au niveau 0 où sont posés les éléments ; count = nombre d'éléments, kinds = nombre par
// type (comme les propriétés agrégées par cellule de l'API H3 de TravelTime) ; id = index hiérarchique (hexagone du
// haut puis chiffres des enfants, à la façon d'un index H3)
export interface GridCell extends Hex { level: number; size: number; angle: number; x: number; z: number; count: number; kinds: Record<string, number>; split: boolean; parent: string | null; key: string; id: string }
export const cellKey = (level: number, h: { q: number; r: number }) => `${level}:${h.q},${h.r}`;
export function adaptiveGrid(g: GridSpec, points: { x: number; z: number; kind?: string }[], maxRings = 8, maxLevels = 16) {
  const O = { q: 0, r: 0, s: 0 };
  const home = gridHexes(g).map(h => ({ ...hexToPlane(g, h), kind: undefined, home: true }));
  const chains = [...home, ...points.map(p => ({ ...p, home: false }))].map(p => {
    const chain: Hex[] = [planeToHex(g, p)];
    for (let l = 0; l < maxLevels; l++) chain.push(parentHex(chain[l]!));
    return { kind: p.kind, home: p.home, chain };
  });
  const ringsAt = (l: number) => Math.max(0, ...chains.map(c => cubeDistance(O, c.chain[l]!)));
  let top = 0;
  while (top < maxLevels && ringsAt(top) > (top === 0 ? Math.max(maxRings, g.radius) : maxRings)) top++;
  const counts = new Map<string, { all: number; kinds: Record<string, number> }>();
  for (const c of chains) c.chain.forEach((h, l) => {
    const k = cellKey(l, h), v = counts.get(k) ?? { all: 0, kinds: {} };
    v.all++;
    if (!c.home) v.kinds[c.kind ?? "élément"] = (v.kinds[c.kind ?? "élément"] ?? 0) + 1;
    counts.set(k, v);
  });
  const cells: GridCell[] = [], angles = Array.from({ length: top + 1 }, (_, l) => levelAngle(g, l));
  const add = (level: number, h: Hex, parent: string | null, id: string) => {
    const key = cellKey(level, h), n = counts.get(key) ?? { all: 0, kinds: {} }, split = level > 0 && n.all > 0;
    const count = Object.values(n.kinds).reduce((t, x) => t + x, 0);
    cells.push({ ...h, level, size: levelSize(g, level), angle: angles[level]!, ...levelCenter(g, level, h), count, kinds: n.kinds, split, parent, key, id });
    if (split) for (const ch of childHexes(h)) add(level - 1, ch, key, `${id}${childDigit(ch)}`);
  };
  const radius = top === 0 ? Math.max(g.radius, ringsAt(0)) : ringsAt(top) + 1;
  for (const h of gridHexes({ ...g, radius })) add(top, h, null, `${top}:${h.q},${h.r}/`);
  return { top, aperture: APERTURE, radius, cells };
}
