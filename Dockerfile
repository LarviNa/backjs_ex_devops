FROM node:20-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy dependency definition
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy application files
COPY server.js ./

# Use non-root user for security hardening
USER node

# Expose port
EXPOSE 8081

# Command to run application
CMD [ "node", "server.js" ]
