// Page autonome des spirales coniques de Pappus (empreinte diagrammatique de chaque existence), dessinées avec Plotly
// (même rendu que l'onglet Diagrammes de l'application)
import type { Metrics } from "./metrics";

const esc = (s: string) => s.replace(/[&<>"]/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]!);
// une couleur par existence, dans l'ordre (même palette que la page)
const PALETTE = ["#2e7d5b", "#2f6db0", "#b8860b", "#c0392b", "#8a4fb8", "#1f8a8a", "#d0602e", "#c2477d", "#5d6d7e", "#7a8b1f"];

export function spiralHtml(metrics: Metrics, title: string): string {
  const traces = metrics.existences.map((e, i) => ({ e, color: PALETTE[i % PALETTE.length]! })).filter(({ e }) => e.spiral.points.length > 1).map(({ e, color }) => ({
    name: `${e.name} — ${e.spiral.shape}`, type: "scatter3d", mode: "lines",
    x: e.spiral.points.map(p => p.x), y: e.spiral.points.map(p => p.y), z: e.spiral.points.map(p => p.z),
    line: { width: 5, color },
    text: e.spiral.points.map(p => p.pulsation ?? ""), hovertemplate: "%{text}<br>x %{x} · y %{y} · altitude %{z}<extra>%{fullData.name}</extra>",
  }));
  const rows = metrics.existences.map(e =>
    `<tr><td>${esc(e.name)}</td><td>${esc(e.kind)}</td><td>${e.spiral.dilation}</td><td>${e.spiral.altitude}</td><td>${e.spiral.displacement} (${e.spiral.turns} tour(s))</td><td>${esc(e.spiral.shape)}</td></tr>`).join("");
  return `<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spirales de Pappus – ${esc(title)}</title>
<style>
  :root { --bg: #f6f5f1; --ink: #1d1f24; --muted: #6b6f78; --line: #e2e0d9; }
  @media (prefers-color-scheme: dark) { :root { --bg: #15171b; --ink: #e8e9ec; --muted: #9aa0aa; --line: #2e323a; } }
  body { margin: 0; padding: 16px; background: var(--bg); color: var(--ink); font: 15px/1.5 system-ui, sans-serif; }
  h1 { font-size: 18px; margin: 0 0 4px; } p { color: var(--muted); margin: 0 0 12px; font-size: 13.5px; }
  #plot { width: 100%; height: 72vh; }
  table { border-collapse: collapse; font-size: 13.5px; margin-top: 12px; width: 100%; }
  th, td { text-align: left; padding: 5px 8px; border-bottom: 1px solid var(--line); }
  th { color: var(--muted); font-size: 12px; }
</style>
</head>
<body>
<h1>Spirales coniques de Pappus – ${esc(title)}</h1>
<p>Rayon : somme des augmentations de Résonner (dilatation rhizomatique) · altitude : somme des augmentations d'Agir · rotation : somme de Discerner et Raisonner (déplacement topographique).</p>
<div id="plot"></div>
<table><thead><tr><th>Existence</th><th>Genre</th><th>Dilatation</th><th>Altitude</th><th>Déplacement</th><th>Forme</th></tr></thead><tbody>${rows}</tbody></table>
<script src="https://cdn.jsdelivr.net/npm/plotly.js-dist-min@2.35.2/plotly.min.js"></script>
<script>
  const dark = matchMedia("(prefers-color-scheme: dark)").matches;
  const axis = t => ({ title: t, color: dark ? "#9aa0aa" : "#6b6f78", gridcolor: dark ? "#2e323a" : "#e2e0d9" });
  Plotly.newPlot("plot", ${JSON.stringify(traces).replace(/</g, "\\u003c")}, {
    paper_bgcolor: "rgba(0,0,0,0)", font: { color: dark ? "#e8e9ec" : "#1d1f24" }, margin: { l: 0, r: 0, t: 0, b: 0 },
    legend: { orientation: "h" }, scene: { xaxis: axis("x"), yaxis: axis("y"), zaxis: axis("altitude (Agir)") },
  }, { responsive: true, displaylogo: false });
</script>
</body>
</html>
`;
}
