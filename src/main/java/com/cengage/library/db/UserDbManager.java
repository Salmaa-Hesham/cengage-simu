package com.cengage.library.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class UserDbManager {
    private static HikariDataSource dataSource;

    static {
        try {
            String host = System.getenv().getOrDefault("USER_DB_HOST", "user-db-service");
            String port = System.getenv().getOrDefault("USER_DB_PORT", "5432");
            String dbName = System.getenv().getOrDefault("USER_DB_NAME", "user_db");
            String user = System.getenv().getOrDefault("USER_DB_USER", "postgres");
            String pass = System.getenv().getOrDefault("USER_DB_PASS", "postgres123");

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:postgresql://" + host + ":" + port + "/" + dbName);
            config.setUsername(user);
            config.setPassword(pass);
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(3000); // 3 seconds timeout

            dataSource = new HikariDataSource(config);
            System.out.println("[UserDbManager] Initialized connection pool for User/License DB");
        } catch (Exception e) {
            System.err.println("[UserDbManager] Connection initialization error: " + e.getMessage());
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