# Use OpenJDK 11 slim image as base
FROM openjdk:11-jre-slim

# Copy the JAR file into the container
COPY target/microservice-1.0-SNAPSHOT.jar /app.jar

# Expose port 8080 for the application
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app.jar"]
