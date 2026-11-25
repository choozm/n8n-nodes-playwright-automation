FROM mcr.microsoft.com/playwright:v1.58.0-noble

WORKDIR /app

# Pin n8n: an unpinned install re-resolves `latest` whenever the build cache is
# cold and can jump releases behind the runner's back. N8N_VERSION is also what
# tags the images in n8n-playwright/docker-compose.yml - bump both together.
ARG N8N_VERSION=2.48.7
RUN npm install -g "n8n@${N8N_VERSION}" && npm ls -g n8n --depth=0

# Copy manifests first so dependency installation is cached between source changes
COPY package.json package-lock.json ./

# --ignore-scripts: Playwright browsers are already baked into the base image,
# and a dev dependency's preinstall hook (only-allow) rejects npm installs.
RUN npm ci --ignore-scripts

# Copy source code
COPY . .

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
