// Historique des positions géographiques des éléments d'EcoSpace (actants, physiques, personnes) : une FeatureCollection
// GeoJSON par item, un point par position successive (toutes les écosystèmes de l'item), une entité sans géométrie quand
// l'élément est retiré d'un espace
export interface GeoPoint { lon: number; lat: number; alt: number }
export interface PositionFeature {
  type: "Feature";
  geometry: { type: "Point"; coordinates: [number, number, number] } | null;
  properties: { eco: number; at: string; event: "placé" | "déplacé" | "retiré"; shape: string; address?: string; q?: number; r?: number; s?: number; actant?: number; sub?: { q: number; r: number } };
}
export interface PositionHistory { type: "FeatureCollection"; item: number; title?: string; features: PositionFeature[] }

export const emptyHistory = (item: number): PositionHistory => ({ type: "FeatureCollection", item, features: [] });
// deux positions identiques au centimètre près (et, pour une personne, sur le même sous-hexagone) ; un changement
// d'hexagone sans changement de lieu (grille recalculée) n'est pas un déplacement
export const samePosition = (a: { lon: number; lat: number; alt: number; q?: number; r?: number; sub?: any }, b: typeof a) =>
  Math.abs(a.lon - b.lon) < 1e-7 && Math.abs(a.lat - b.lat) < 1e-7 && Math.abs(a.alt - b.alt) < 0.01 && JSON.stringify(a.sub ?? null) === JSON.stringify(b.sub ?? null);
export const pointFeature = (p: GeoPoint, props: PositionFeature["properties"]): PositionFeature =>
  ({ type: "Feature", geometry: { type: "Point", coordinates: [p.lon, p.lat, p.alt] }, properties: props });
