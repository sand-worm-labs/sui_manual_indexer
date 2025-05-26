# Use Node.js base image
FROM node:20

# Enable and prepare pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Set working directory inside container
WORKDIR /app

# Copy only package.json first (no pnpm-lock.yaml)
COPY package.json ./

# Install dependencies
RUN pnpm install --ignore-workspace

# Copy the rest of the project files
COPY . .

# Expose the port (optional, if your app serves something)
EXPOSE 3000

# Start database setup and app
CMD ["sh", "-c", "pnpm db:setup:dev && pnpm dev"]
