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

// grille à niveaux : hexagones de taille hexSize × factor^niveau ; le parent d'un hexagone est l'hexagone du niveau
// supérieur qui contient son centre (partition exacte : les hexagones ne s'emboîtent pas, on suit donc les centres de
// proche en proche depuis l'hexagone de base de chaque point) ; le niveau du haut est le plus petit dont maxRings
// anneaux autour de l'origine contiennent tous les points (au niveau 0 : au moins le rayon de la grille) ; un hexagone
// de niveau > 0 qui contient au moins un point (élément placé ou origine) est découpé en ses enfants, jusqu'au niveau 0
// où sont posés les éléments ; count = nombre d'éléments (sans l'origine)
export interface GridCell extends Hex { level: number; size: number; x: number; z: number; count: number; split: boolean; parent: string | null; key: string }
export const cellKey = (level: number, h: { q: number; r: number }) => `${level}:${h.q},${h.r}`;
export function adaptiveGrid(g: GridSpec, points: { x: number; z: number }[], factor = 10, maxRings = 8, maxLevels = 8) {
  const spec = (level: number): GridSpec => ({ ...g, hexSize: g.hexSize * factor ** level });
  const O = { q: 0, r: 0, s: 0 };
  const up = (level: number, h: Hex) => planeToHex(spec(level + 1), hexToPlane(spec(level), h)); // parent de h (niveau level)
  // chaîne des ancêtres de chaque point (origine comprise), du niveau 0 à maxLevels
  const chains = [{ x: 0, z: 0, origin: true }, ...points.map(p => ({ ...p, origin: false }))].map(p => {
    const chain = [planeToHex(spec(0), p)];
    for (let l = 0; l < maxLevels; l++) chain.push(up(l, chain[l]!));
    return { origin: p.origin, chain };
  });
  let top = 0;
  const ringsAt = (l: number) => Math.max(0, ...chains.map(c => cubeDistance(O, c.chain[l]!)));
  while (top < maxLevels && ringsAt(top) > (top === 0 ? Math.max(maxRings, g.radius) : maxRings)) top++;
  const counts = new Map<string, { all: number; items: number }>();
  for (const c of chains) c.chain.forEach((h, l) => { const k = cellKey(l, h), v = counts.get(k) ?? { all: 0, items: 0 }; v.all++; if (!c.origin) v.items++; counts.set(k, v); });
  const cells: GridCell[] = [];
  const childrenOf = (level: number, h: Hex) => {
    const P = spec(level), C = spec(level - 1), c = planeToHex(C, hexToPlane(P, h)), out: Hex[] = [];
    for (const k of gridHexes({ ...C, radius: Math.ceil(factor) + 1 })) {
      const cand = { q: c.q + k.q, r: c.r + k.r, s: -(c.q + k.q) - (c.r + k.r) || 0 }, back = up(level - 1, cand);
      if (back.q === h.q && back.r === h.r) out.push(cand);
    }
    return out;
  };
  const add = (level: number, h: Hex, parent: string | null) => {
    const key = cellKey(level, h), n = counts.get(key) ?? { all: 0, items: 0 }, split = level > 0 && n.all > 0;
    cells.push({ ...h, level, size: spec(level).hexSize, ...hexToPlane(spec(level), h), count: n.items, split, parent, key });
    if (split) for (const ch of childrenOf(level, h)) add(level - 1, ch, key);
  };
  const radius = top === 0 ? Math.max(g.radius, ringsAt(0)) : ringsAt(top) + 1;
  for (const h of gridHexes({ ...spec(top), radius })) add(top, h, null);
  return { top, factor, radius, cells };
}
