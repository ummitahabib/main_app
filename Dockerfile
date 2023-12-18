# Use the specified Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set the working directory
WORKDIR /app

# Copy your Flutter project into the container
COPY . .

# Build the Flutter web project
RUN flutter pub get
#RUN flutter build web --base-href='/portal/'
RUN flutter build web

# Use nginx to serve the web files
FROM nginx:alpine

# Copy build output from previous stage to nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for HTTP
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
