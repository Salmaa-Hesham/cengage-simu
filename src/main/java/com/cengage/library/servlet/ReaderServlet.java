package com.cengage.library.servlet;

import com.cengage.library.db.CatalogDbManager;
import com.cengage.library.db.UserDbManager;
import com.cengage.library.model.Publication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "ReaderServlet", urlPatterns = {"/read"})
public class ReaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/catalog");
            return;
        }

        int publicationId = Integer.parseInt(idParam);

        // 1. Fetch Content from DATABASE 2 (Catalog DB)
        Publication pub = fetchPublicationById(publicationId);
        if (pub == null) {
            resp.sendRedirect(req.getContextPath() + "/catalog");
            return;
        }
        req.setAttribute("publication", pub);

        // 2. Update reading history in DATABASE 1 (Users DB)
        updateReadingHistory(1, publicationId);

        String appColor = System.getenv().getOrDefault("APP_COLOR", "blue");
        req.setAttribute("appColor", appColor);

        req.getRequestDispatcher("/reader.jsp").forward(req, resp);
    }

    private Publication fetchPublicationById(int id) {
        String sql = "SELECT * FROM publications WHERE id = ?";
        try (Connection conn = CatalogDbManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Publication(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("type"),
                        rs.getString("category"),
                        rs.getString("isbn"),
                        rs.getString("summary"),
                        rs.getString("content"),
                        rs.getString("cover_url")
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("[ReaderServlet] Error fetching content from DB 2: " + e.getMessage());
        }
        return null;
    }

    private void updateReadingHistory(int userId, int publicationId) {
        String sql = "UPDATE users SET last_read_id = ?, last_active = NOW() WHERE id = ?";
        try (Connection conn = UserDbManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, publicationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("[ReaderServlet] Error updating reading history in DB 1: " + e.getMessage());
        }
    }
}