// Disposition des concepts d'EcoSpace (« bulles conceptuelles ») : capsules d'axe horizontal est-ouest (x), cylindre
// fermé par deux demi-sphères, sous la grille. Rien n'est saisi à la main : la hiérarchie vient d'Omeka S (skos:narrower /
// skos:broader) et la géométrie en est calculée. Une bulle sans enfant est dimensionnée par son titre ; une bulle parent
// par la place de ses enfants, rangés sur une ligne le long de son axe et décalés en diagonale vers le bas et le sud,
// la bande opposée (haut-nord) portant son titre : les titres restent séparés vus de côté comme de dessous. Les frères
// (enfants d'un même parent, ou racines de l'écosystème) sont répartis de façon équilibrée : ordre alphabétique,
// espacements égaux, ensemble centré ; les racines forment une grille presque carrée centrée sous la grille hexagonale
export interface ConceptNode { item: number; title: string; parent: number | null }
export interface LayoutParams {
  S: number;            // taille d'un hexagone (m) : les paramètres suivants en sont des fractions
  charWidth: number;    // largeur d'un caractère du titre
  labelHeight: number;  // hauteur du titre
  leafRadius: number;   // rayon d'une bulle sans enfant
  padding: number;      // marge intérieure d'un parent et écart entre enfants
  spacing: number;      // écart entre bulles racines
  topDepth: number;     // profondeur du sommet des bulles racines sous la grille
  maxLabel: number;     // nombre maximal de caractères affichés
}
export interface Bubble {
  item: number; parent: number | null; children: number[]; level: number;
  label: string; chars: number; labelY: number; labelZ: number;  // titre affiché, nombre de caractères, position relative au centre
  x: number; y: number; z: number; radius: number; length: number;
}

const byTitle = (a: { title: string }, b: { title: string }) => a.title.localeCompare(b.title, "fr", { sensitivity: "base", numeric: true });
// titre affiché dans la bulle (tronqué au-delà de max caractères)
export const conceptLabel = (title: string, max = 40) => { const t = [...String(title ?? "")]; return t.length > max ? t.slice(0, max - 2).join("") + "…" : t.join(""); };

export function layoutConcepts(nodes: ConceptNode[], p: LayoutParams): Map<number, Bubble> {
  const S = p.S, cw = p.charWidth * S, lh = p.labelHeight * S, pad = p.padding * S;
  const byId = new Map(nodes.map(n => [n.item, n]));
  // parent retenu seulement s'il est disposé et sans cycle (sinon le concept devient racine)
  const parentOf = (n: ConceptNode) => {
    if (n.parent == null || !byId.has(n.parent) || n.parent === n.item) return null;
    const seen = new Set([n.item]);
    for (let q: number | null = n.parent; q != null; q = byId.get(q)?.parent ?? null) { if (seen.has(q)) return null; seen.add(q); }
    return n.parent;
  };
  const parent = new Map(nodes.map(n => [n.item, parentOf(n)]));
  const kids = new Map<number, ConceptNode[]>(nodes.map(n => [n.item, []]));
  for (const n of nodes) { const q = parent.get(n.item); if (q != null) kids.get(q)!.push(n); }
  for (const l of kids.values()) l.sort(byTitle);
  const out = new Map<number, Bubble>();

  // taille (de bas en haut) : rayon et longueur, positions des enfants relatives au centre du parent
  const size = (n: ConceptNode, level: number): Bubble => {
    const label = conceptLabel(n.title, p.maxLabel), chars = [...label].length, cs = kids.get(n.item)!.map(c => size(c, level + 1));
    const b: Bubble = { item: n.item, parent: parent.get(n.item) ?? null, children: cs.map(c => c.item), level, label, chars, labelY: 0, labelZ: 0, x: 0, y: 0, z: 0, radius: 0, length: 0 };
    if (!cs.length) {
      b.radius = Math.max(p.leafRadius * S, lh / 2 + pad);
      b.length = 2 * b.radius + chars * cw;
    } else {
      // enfants sur une ligne, décalés d'une demi-hauteur de titre vers le bas-sud (diagonale du plan nord-sud) ; le
      // titre du parent dans la bande opposée, au haut-nord
      const rc = Math.max(...cs.map(c => c.radius)), row = cs.reduce((s, c) => s + c.length, 0) + (cs.length - 1) * pad;
      const o = lh / 2, d = Math.SQRT1_2;
      b.radius = rc + o + pad;
      const l = b.radius - pad / 2 - lh / 2;
      b.labelY = l * d; b.labelZ = -l * d;
      b.length = Math.max(row + 2 * pad, chars * cw) + 2 * b.radius;
      let x = -row / 2;
      for (const c of cs) { c.x = x + c.length / 2; c.y = -o * d; c.z = o * d; x += c.length + pad; }
    }
    out.set(n.item, b);
    return b;
  };
  // positions absolues (de haut en bas) : x, y, z d'un enfant sont encore relatifs au centre de son parent
  const place = (b: Bubble, x: number, y: number, z: number) => {
    Object.assign(b, { x, y, z });
    for (const id of b.children) { const c = out.get(id)!; place(c, x + c.x, y + c.y, z + c.z); }
  };

  // racines : grille de ceil(√n) colonnes, lignes centrées en x, lignes centrées ensemble en z
  const roots = nodes.filter(n => parent.get(n.item) == null).sort(byTitle).map(n => size(n, 0));
  const cols = Math.max(1, Math.ceil(Math.sqrt(roots.length))), gap = p.spacing * S;
  const rows: Bubble[][] = [];
  for (let i = 0; i < roots.length; i += cols) rows.push(roots.slice(i, i + cols));
  const depthOf = (r: Bubble[]) => 2 * Math.max(...r.map(b => b.radius));
  const total = rows.reduce((s, r) => s + depthOf(r), 0) + Math.max(0, rows.length - 1) * gap;
  let z = -total / 2;
  for (const r of rows) {
    const d = depthOf(r), width = r.reduce((s, b) => s + b.length, 0) + (r.length - 1) * gap;
    let x = -width / 2;
    for (const b of r) { place(b, x + b.length / 2, -(p.topDepth * S + b.radius), z + d / 2); x += b.length + gap; }
    z += d + gap;
  }
  return out;
}

// intériorité d'un actant (pouvoirs de raisonner et de résonner) : concepts déplacés dans sa sphère, bulles sans
// enfant empilées de haut en bas par ordre alphabétique, centrées sur le centre de la sphère ; la sphère grandit pour
// les contenir (au moins baseRadius) ; positions relatives au centre de la sphère
export function interiorLayout(nodes: { item: number; title: string }[], p: LayoutParams, baseRadius: number) {
  const S = p.S, cw = p.charWidth * S, lh = p.labelHeight * S, pad = p.padding * S;
  const bs: Bubble[] = [...nodes].sort(byTitle).map(n => {
    const label = conceptLabel(n.title, p.maxLabel), chars = [...label].length, radius = Math.max(p.leafRadius * S, lh / 2 + pad);
    return { item: n.item, parent: null, children: [], level: 0, label, chars, labelY: 0, labelZ: 0, x: 0, y: 0, z: 0, radius, length: 2 * radius + chars * cw };
  });
  const height = bs.reduce((s, b) => s + 2 * b.radius, 0) + Math.max(0, bs.length - 1) * pad;
  let y = height / 2;
  for (const b of bs) { b.y = y - b.radius; y -= 2 * b.radius + pad; }
  // point le plus éloigné d'une capsule : extrémité de son axe + rayon
  const need = bs.reduce((m, b) => Math.max(m, Math.hypot(b.length / 2 - b.radius, Math.abs(b.y)) + b.radius), 0);
  return { radius: Math.max(baseRadius, need + pad), bubbles: bs };
}
