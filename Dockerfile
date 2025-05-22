FROM node:18-alpine AS base

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package.json and pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy the rest of the code
COPY . .

# Build the application
RUN pnpm build

# Expose the port
EXPOSE 3006

# Start the application
CMD ["pnpm", "start"] 