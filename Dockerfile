FROM mcr.microsoft.com/playwright:v1.58.0-noble

WORKDIR /app

# Install n8n globally
RUN npm install -g n8n

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
