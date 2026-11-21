FROM mcr.microsoft.com/playwright:v1.58.0-noble

WORKDIR /app

# Enable pnpm via corepack
RUN corepack enable pnpm

# Install n8n globally
RUN npm install -g n8n

# Copy source code (includes package.json, pnpm-lock.yaml, and any postinstall scripts)
COPY . .

# Install dependencies using pnpm (without --frozen-lockfile in case lockfile is slightly outdated)
RUN pnpm install --no-frozen-lockfile

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
