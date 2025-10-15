FROM node:18-alpine

WORKDIR /app

# Copy backend package files
COPY tripsync-backend/package*.json ./

# Install dependencies
RUN npm install --production

# Copy backend source code
COPY tripsync-backend/ ./

# Expose port
EXPOSE $PORT

# Start the application
CMD ["npm", "start"]
