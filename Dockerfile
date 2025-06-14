# Multi-stage build for Vite React app (no TypeScript)
FROM node:22-slim AS build

WORKDIR /app

# Copy package files (make sure they exist)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the Vite React app
RUN npm run build

# Production stage - using nginx to serve static files
FROM nginx:alpine AS production

# Copy Vite build files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config for SPA routing (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
