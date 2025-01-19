# Stage 1: Build the application
FROM node:lts-alpine AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy only package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies (both production and dev for build)
RUN npm ci

# Copy the rest of the application code
COPY . .

# Install TypeScript globally and build the application
RUN npm install -g typescript
RUN npm run build

# Remove development dependencies
RUN npm prune --production

# Stage 2: Create a minimal runtime image
FROM node:lts-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy only the production build and required dependencies from the build stage
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

# Expose the application port (adjust as necessary)
EXPOSE 3000

# Command to run the application
CMD ["node", "dist/index.js"]
