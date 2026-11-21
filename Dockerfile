FROM mcr.microsoft.com/playwright:v1.58.0-noble

WORKDIR /app

# Enable pnpm via corepack
RUN corepack enable pnpm

# Install n8n globally
RUN npm install -g n8n

# Copy package files and pnpm lockfile
COPY package.json pnpm-lock.yaml ./

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
