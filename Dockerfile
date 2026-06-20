# Etapa 1: Construcción (Multi-stage build)
# Cambiamos también a Temurin para mantener la consistencia en Java 21
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución con imagen ligera Alpine de Eclipse Temurin
# Usamos 'jre' en lugar de 'jdk' para reducir drásticamente el tamaño de la imagen
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/eureka-server-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]