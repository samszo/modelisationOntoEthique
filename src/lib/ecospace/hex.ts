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

// hexagone libre le plus proche d'un hexagone donné (duplication d'un élément), null si la grille est pleine
export function nearestFree(g: GridSpec, from: Hex, taken: Set<string>) {
  return gridHexes(g).filter(h => !taken.has(hexKey(h))).sort((a, b) => cubeDistance(from, a) - cubeDistance(from, b))[0] ?? null;
}

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
