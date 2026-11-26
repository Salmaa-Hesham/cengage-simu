FROM postgres:16-alpine

# Environment defaults
ENV POSTGRES_DB=user_db
ENV POSTGRES_USER=postgres

# Copy initialization script directly into the entrypoint directory
COPY init.sql /docker-entrypoint-initdb.d/