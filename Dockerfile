# mvn clean package
# mvn package docker:build


#Start with a base image containing Java runtime
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container at /app
COPY target/micro-configserver-0.0.1-SNAPSHOT.jar /app/

EXPOSE 8071

# Specify the command to run on container startup
CMD ["java", "-jar", "micro-configserver-0.0.1-SNAPSHOT.jar"]

# para usar docker compose, usamos: docker-compose up
# primero necesitamos la imagen creada, y teniendola invocamos todas las que necesitamos