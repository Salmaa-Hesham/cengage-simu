package com.cengage.library.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class CatalogDbManager {
    private static HikariDataSource dataSource;

    static {
        try {
            String host = System.getenv().getOrDefault("CATALOG_DB_HOST", "catalog-db-service");
            String port = System.getenv().getOrDefault("CATALOG_DB_PORT", "5432");
            String dbName = System.getenv().getOrDefault("CATALOG_DB_NAME", "catalog_db");
            String user = System.getenv().getOrDefault("CATALOG_DB_USER", "postgres");
            String pass = System.getenv().getOrDefault("CATALOG_DB_PASS", "postgres123");

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:postgresql://" + host + ":" + port + "/" + dbName);
            config.setUsername(user);
            config.setPassword(pass);
            config.setMaximumPoolSize(20); // Higher pool for content browsing
            config.setMinimumIdle(5);
            config.setConnectionTimeout(3000);

            dataSource = new HikariDataSource(config);
            System.out.println("[CatalogDbManager] Initialized connection pool for Catalog DB");
        } catch (Exception e) {
            System.err.println("[CatalogDbManager] Connection initialization error: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static boolean isHealthy() {
        if (dataSource == null) return false;
        try (Connection conn = getConnection()) {
            return conn.isValid(2);
        } catch (Exception e) {
            return false;
        }
    }
}