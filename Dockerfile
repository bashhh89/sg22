FROM node:18-alpine AS deps

# Install dependencies only when needed
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install --frozen-lockfile

# Debugging: Check what's in the directory after install
RUN echo "Contents after dependency installation:" && ls -la

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

# Debugging: List all directories to verify app directory exists
RUN echo "Contents of /app directory:" && \
    ls -la && \
    echo "Does app directory exist?" && \
    if [ -d "app" ]; then echo "YES - app directory exists"; else echo "NO - app directory is missing"; fi && \
    echo "Contents of app directory (if it exists):" && \
    if [ -d "app" ]; then ls -la app; else echo "Cannot list app directory contents because it doesn't exist"; fi

# Force Next.js to use the standalone output mode
RUN echo "module.exports = { ...require('./next.config.js'), output: 'standalone' }" > next.config.wrapper.js
RUN if [ -f "next.config.js" ]; then mv next.config.wrapper.js next.config.js; else echo "module.exports = { output: 'standalone' };" > next.config.js; fi

# Debugging: Show next.config.js content
RUN echo "Content of next.config.js:" && cat next.config.js

# Build the application
RUN pnpm build

# Debugging: Check the build output
RUN echo "Build output:" && \
    ls -la .next && \
    echo "Does standalone directory exist?" && \
    if [ -d ".next/standalone" ]; then echo "YES - standalone directory exists"; else echo "NO - standalone directory is missing"; fi

# -----------------------------------------------
FROM node:18-alpine AS runner

WORKDIR /app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Create necessary directories
RUN mkdir -p /app/logs

# Copy necessary files from the build stage
# If standalone output exists, use it
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Debugging: Check what's in the final image
RUN echo "Contents of final image:" && \
    ls -la && \
    echo "Contents of .next directory:" && \
    ls -la .next || echo ".next directory doesn't exist"

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"] 