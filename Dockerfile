# Écosystème d'agents IA pour la modélisation onto-éthique des existences informationnelles
# Image : code dans /app, données (connexions, configurations, historique, resultats/) dans le volume /data
FROM node:22-bookworm-slim

ENV NODE_ENV=production \
    RUNNING_IN_DOCKER=1 \
    HOST=0.0.0.0 \
    ONTOETHIQUE_PORT=7280 \
    TZ=Europe/Paris

WORKDIR /app

# dépendances (tsx, devDependency, exécute le TypeScript : on installe tout)
COPY package.json package-lock.json ./
RUN npm ci --include=dev --no-audit --no-fund && npm cache clean --force

# code et documentation
COPY tsconfig.json ./
COPY src ./src
COPY docs ./docs
COPY README.md ./

# point d'entrée : droits du volume /data, puis exécution en tant qu'utilisateur node
COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# commandes : interface web (workflow-ui, application choisie par WORKFLOW_APP ou en argument : ontoethique)
# et workflow en ligne de commande (workflow-ontoethique)
# (lancées en root, par exemple avec docker compose exec, elles passent aussi par le point d'entrée)
RUN printf '#!/bin/sh\nexec /usr/local/bin/docker-entrypoint.sh /app/node_modules/.bin/tsx /app/src/ui/server.ts "$@"\n' > /usr/local/bin/workflow-ui \
 && printf '#!/bin/sh\nexec /usr/local/bin/docker-entrypoint.sh /app/node_modules/.bin/tsx /app/src/runners/ontoethique.ts "$@"\n' > /usr/local/bin/workflow-ontoethique \
 && chmod +x /usr/local/bin/workflow-ui /usr/local/bin/workflow-ontoethique /usr/local/bin/docker-entrypoint.sh \
 && mkdir -p /data && chown node:node /data

# répertoire de données : .env (+ .env.ontoethique), fichiers de configuration, resultats/
WORKDIR /data
VOLUME ["/data"]
# le conteneur démarre en root le temps d'ajuster les droits de /data (docker/entrypoint.sh), puis passe en node

EXPOSE 7280
# port de l'application servie (WORKFLOW_APP=ontoethique : ONTOETHIQUE_PORT)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "const p = process.env.ONTOETHIQUE_PORT || 7280; fetch('http://127.0.0.1:' + p + '/api/run').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/app/node_modules/.bin/tsx", "/app/src/ui/server.ts"]
