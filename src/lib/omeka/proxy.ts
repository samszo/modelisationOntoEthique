// Mandataire (reverse proxy) vers l'interface web d'Omeka S, servi sous le même chemin que l'instance (ex. /omk_ontoethique/) :
// la page d'administration s'ouvre dans une iframe de même origine, le cookie de session (SameSite Lax par défaut) est
// transmis et la connexion (jeton CSRF) fonctionne
import http from "http";
import https from "https";

// base web de l'instance à partir de l'adresse de l'API : { origin, path } ; path vide = Omeka S à la racine du domaine
export function omekaWebBase(apiUrl: string | undefined) {
  if (!apiUrl) return null;
  try {
    const u = new URL(apiUrl.replace(/\/api\/?$/, ""));
    return { origin: u.origin, path: u.pathname.replace(/\/$/, "") };
  } catch { return null; }
}

// chemin de la requête servi par le mandataire : celui de l'instance, qui ne doit pas masquer les routes de l'application
export const isProxied = (pathname: string, basePath: string) => !!basePath && (pathname === basePath || pathname.startsWith(basePath + "/"));

export function proxyOmeka(req: http.IncomingMessage, res: http.ServerResponse, origin: string) {
  const target = new URL(req.url ?? "/", origin);
  const selfOrigin = `http://${req.headers.host}`;
  const headers: http.OutgoingHttpHeaders = { ...req.headers, host: target.host };
  // en-têtes d'origine réécrits vers l'instance (protections éventuelles d'Omeka S ou de ses modules)
  for (const h of ["origin", "referer"]) {
    const v = req.headers[h];
    if (typeof v === "string" && v.startsWith(selfOrigin)) headers[h] = origin + v.slice(selfOrigin.length);
  }
  const lib = target.protocol === "https:" ? https : http;
  const upstream = lib.request(target, { method: req.method, headers }, up => {
    const out: http.OutgoingHttpHeaders = { ...up.headers };
    // redirection absolue vers l'instance → chemin relatif (reste dans le mandataire)
    if (typeof up.headers.location === "string" && up.headers.location.startsWith(origin)) out.location = up.headers.location.slice(origin.length) || "/";
    // cookie posé pour l'hôte du mandataire : sans Domain, et sans Secure (le mandataire est servi en http local)
    if (up.headers["set-cookie"]) out["set-cookie"] = up.headers["set-cookie"].map(c => c.replace(/;\s*Domain=[^;]*/i, "").replace(/;\s*Secure/i, ""));
    res.writeHead(up.statusCode ?? 502, out);
    up.pipe(res);
  });
  upstream.on("error", e => {
    console.warn("⚠️ [OMEKA] mandataire :", e.message);
    if (!res.headersSent) res.writeHead(502, { "Content-Type": "text/plain; charset=utf-8" });
    res.end(`Omeka S injoignable : ${e.message}`);
  });
  req.pipe(upstream);
}
