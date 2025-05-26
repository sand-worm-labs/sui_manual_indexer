# Use a Node.js base image with pnpm pre-installed
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --ignore-workspace

# Copy the rest of the app
COPY . .

# Setup the database (adjust if you use external services or this runs only once)
RUN pnpm db:setup:dev

# Publish contracts and demo data — replace this with your actual script if needed
# RUN pnpm contract:publish && pnpm seed:demo

# Expose the port your app runs on
EXPOSE 3000

# Start the app and indexer (adjust if these are separate commands)
CMD ["pnpm", "dev"]
