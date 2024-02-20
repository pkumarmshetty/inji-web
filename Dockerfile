# Use an official Node.js runtime as the base image
FROM node:14 as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app
RUN npm run build

# Use an official Nginx image as the final production image
FROM nginx:latest

# Copy the built React app from the build container to the Nginx container
COPY --from=build /app/build /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
# EXPOSE 80

# The main command to start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]