# Use Node.js 20 base image
FROM node:20

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json for deterministic installs
COPY package.json package-lock.json ./

# Install dependencies with npm
RUN npm install

# Copy the rest of your project files
COPY . .

# Expose port 3000 (if your app serves HTTP)
EXPOSE 3000

# Start your app/indexer
CMD ["npm", "run", "indexer"]
