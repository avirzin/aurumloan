# Use Node.js as the base image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose Hardhat's default port
EXPOSE 8545

# Command to run Hardhat node
CMD ["npx", "hardhat", "node"]