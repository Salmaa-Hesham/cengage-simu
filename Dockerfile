# -------------------------------------------------------------
# Stage 1: Build the Java application using Maven & Java 17
# -------------------------------------------------------------
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Cache dependencies layer
COPY pom.xml .
RUN mvn dependency:go-offline -B || true

# Copy source code and build the WAR file
COPY src ./src
RUN mvn clean package -DskipTests

# -------------------------------------------------------------
# Stage 2: Production Runtime with Apache Tomcat 10 (Jakarta EE 10)
# -------------------------------------------------------------
FROM tomcat:10.1-jdk17-temurin

# Remove default sample apps (docs, examples, manager, etc.)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled ROOT.war from the builder stage
# Mounting as ROOT.war ensures the app is served at the root URL (/)
COPY --from=builder /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Application environment defaults
ENV APP_VERSION="v1.0.0"
ENV APP_COLOR="blue"

# Database 1 (User DB) defaults
ENV USER_DB_HOST="user-db-service"
ENV USER_DB_PORT="5432"
ENV USER_DB_NAME="user_db"
ENV USER_DB_USER="postgres"

# Database 2 (Catalog DB) defaults
ENV CATALOG_DB_HOST="catalog-db-service"
ENV CATALOG_DB_PORT="5432"
ENV CATALOG_DB_NAME="catalog_db"
ENV CATALOG_DB_USER="postgres"

# Tomcat HTTP Port
EXPOSE 8080

# Run Tomcat foreground process
CMD ["catalina.sh", "run"]