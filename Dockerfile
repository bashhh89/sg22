FROM node:18-alpine AS deps

# Install dependencies only when needed
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install --frozen-lockfile

# -----------------------------------------------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install pnpm in this stage too
RUN npm install -g pnpm

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json

# Copy source files - CRITICAL: This must include the app directory
COPY . .

# Verify app directory exists
RUN if [ ! -d "app" ]; then echo "ERROR: app directory is missing!" && exit 1; fi
RUN echo "App directory exists with the following contents:" && ls -la app

# Ensure next.config.js exists with standalone output
RUN if [ ! -f "next.config.js" ]; then \
      echo "Creating next.config.js with standalone output"; \
      echo "/** @type {import('next').NextConfig} */\nconst nextConfig = {\n  output: 'standalone',\n  reactStrictMode: true,\n  swcMinify: true,\n};\n\nmodule.exports = nextConfig;" > next.config.js; \
    else \
      echo "Ensuring next.config.js has standalone output"; \
      sed -i 's/module.exports = {/module.exports = {\n  output: "standalone",/g' next.config.js; \
    fi

# Verify next.config.js content
RUN echo "Content of next.config.js:" && cat next.config.js

# Build the application
RUN pnpm build

# -----------------------------------------------
FROM node:18-alpine AS runner

WORKDIR /app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Create necessary directories
RUN mkdir -p /app/logs
RUN mkdir -p /app/public

# Copy necessary files from the build stage
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Handle public directory (may not exist)
RUN mkdir -p ./public

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"] 