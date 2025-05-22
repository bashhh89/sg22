FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy the entire project except files in .dockerignore
COPY . .

# Debug: List directories to verify app directory exists
RUN echo "Current directory structure:" && \
    ls -la && \
    echo "App directory contents:" && \
    ls -la app || echo "No app directory found - creating it" && mkdir -p app

# Build the application
RUN pnpm build

# Expose the port
EXPOSE 3006

# Start the application
CMD ["pnpm", "start"] 