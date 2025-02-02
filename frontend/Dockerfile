# Use Node.js as the base image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Build the project
RUN npm run build

# Expose the frontend port (default React port)
EXPOSE 3000

# Start the frontend
CMD ["npm", "start"]