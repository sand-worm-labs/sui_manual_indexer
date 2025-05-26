# Use Node.js 20 base image
FROM node:20

# Set working directory inside container
WORKDIR /app

# Copy package manifests (package.json and package-lock.json if present)
COPY package*.json ./

# Install dependencies with npm
RUN npm install

# Copy your Prisma schema and generate the client
# (ensure your schema lives at ./prisma/schema.prisma in the project)
COPY prisma ./prisma
RUN npx prisma generate

# Copy the rest of your project files
COPY . .

# Expose port 3000 (if your app serves HTTP)
EXPOSE 3000

# Start your indexer script
CMD ["npm", "run", "indexer"]
