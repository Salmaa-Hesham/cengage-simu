package com.cengage.library.servlet;

import com.cengage.library.db.CatalogDbManager;
import com.cengage.library.db.UserDbManager;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "HealthServlet", urlPatterns = {"/health", "/api/health"})
public class HealthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        boolean userDbOk = UserDbManager.isHealthy();
        boolean catalogDbOk = CatalogDbManager.isHealthy();
        boolean overallHealthy = userDbOk && catalogDbOk;

        JsonObject json = new JsonObject();
        json.addProperty("status", overallHealthy ? "UP" : "DOWN");
        json.addProperty("version", System.getenv().getOrDefault("APP_VERSION", "v1.0.0"));
        
        JsonObject dbStatus = new JsonObject();
        dbStatus.addProperty("user_database", userDbOk ? "CONNECTED" : "DISCONNECTED");
        dbStatus.addProperty("catalog_database", catalogDbOk ? "CONNECTED" : "DISCONNECTED");
        json.add("databases", dbStatus);

        if (!overallHealthy) {
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE); // 503 for Kubernetes probe
        } else {
            resp.setStatus(HttpServletResponse.SC_OK); // 200 OK
        }

        resp.getWriter().write(json.toString());
    }
}