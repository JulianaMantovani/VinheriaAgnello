package com.vinheria.cloud;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Simple JDBC helper for connecting to a cloud database (e.g., AWS RDS MySQL).
 * Provide credentials via environment variables or Servlet context init params.
 *
 * Required env vars (recommended):
 *  DB_URL=jdbc:mysql://<host>:3306/<dbname>?useSSL=true&requireSSL=false&allowPublicKeyRetrieval=true
 *  DB_USER=<username>
 *  DB_PASS=<password>
 */
public class DBConnection {
    public static Connection getConnection() throws SQLException {
        String url  = getenvOrDefault("DB_URL",  System.getProperty("DB_URL"));
        String user = getenvOrDefault("DB_USER", System.getProperty("DB_USER"));
        String pass = getenvOrDefault("DB_PASS", System.getProperty("DB_PASS"));
        if (url == null || user == null) {
            throw new SQLException("Missing DB_URL/DB_USER environment variables or system properties.");
        }
        return DriverManager.getConnection(url, user, pass);
    }

    private static String getenvOrDefault(String key, String fallback) {
        String v = System.getenv(key);
        return (v != null && !v.isBlank()) ? v : fallback;
    }
}
