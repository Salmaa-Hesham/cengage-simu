package com.cengage.library.servlet;

import com.cengage.library.db.CatalogDbManager;
import com.cengage.library.db.UserDbManager;
import com.cengage.library.model.Publication;
import com.cengage.library.model.UserSubscription;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CatalogServlet", urlPatterns = {"", "/catalog"})
public class CatalogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String filterType = req.getParameter("type");
        String searchQuery = req.getParameter("q");

        // 1. Fetch User & License info from DATABASE 1 (Users DB)
        UserSubscription userSub = fetchUserSubscription(1); // Default student demo account (ID: 1)
        req.setAttribute("userSub", userSub);

        // 2. Fetch Catalog items from DATABASE 2 (Catalog DB)
        List<Publication> publications = fetchPublications(filterType, searchQuery);
        req.setAttribute("publications", publications);
        req.setAttribute("activeFilter", filterType != null ? filterType : "ALL");

        // 3. Inject App Version & Theme color (for Blue/Green deployment!)
        String appVersion = System.getenv().getOrDefault("APP_VERSION", "v1.0.0");
        String appColor = System.getenv().getOrDefault("APP_COLOR", "blue"); // "blue" or "green"
        req.setAttribute("appVersion", appVersion);
        req.setAttribute("appColor", appColor);

        // Forward to JSP view
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private UserSubscription fetchUserSubscription(int userId) {
        String sql = "SELECT u.id, u.username, u.full_name, u.institution, " +
                     "s.plan_name, s.is_active, u.last_read_id " +
                     "FROM users u " +
                     "LEFT JOIN subscriptions s ON u.id = s.user_id " +
                     "WHERE u.id = ?";
        try (Connection conn = UserDbManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserSubscription(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("institution"),
                        rs.getString("plan_name"),
                        rs.getBoolean("is_active"),
                        rs.getInt("last_read_id")
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("[CatalogServlet] Error querying Database 1: " + e.getMessage());
        }
        return new UserSubscription(1, "guest", "Guest Student", "Open Access", "Free Trial", true, 0);
    }

    private List<Publication> fetchPublications(String type, String query) {
        List<Publication> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM publications WHERE 1=1 ");
        
        if (type != null && !type.trim().isEmpty() && !type.equalsIgnoreCase("ALL")) {
            sql.append("AND type = ? ");
        }
        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ? OR LOWER(category) LIKE ?) ");
        }
        sql.append("ORDER BY id ASC");

        try (Connection conn = CatalogDbManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (type != null && !type.trim().isEmpty() && !type.equalsIgnoreCase("ALL")) {
                ps.setString(paramIndex++, type.toUpperCase());
            }
            if (query != null && !query.trim().isEmpty()) {
                String searchPattern = "%" + query.toLowerCase() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Publication(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("type"),
                        rs.getString("category"),
                        rs.getString("isbn"),
                        rs.getString("summary"),
                        rs.getString("content"),
                        rs.getString("cover_url")
                    ));
                }
            }
        } catch (Exception e) {
            System.err.println("[CatalogServlet] Error querying Database 2: " + e.getMessage());
        }
        return list;
    }
}