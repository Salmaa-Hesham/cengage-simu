<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cengage.library.model.Publication" %>
<%
    Publication pub = (Publication) request.getAttribute("publication");
    String appColor = (String) request.getAttribute("appColor");
    if (appColor == null) appColor = "blue";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (pub != null) ? pub.getTitle() : "Reader" %> - Cengage Reader</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="theme-<%= appColor %>">

    <header class="navbar">
        <a href="<%= request.getContextPath() %>/" class="brand">
            📚 Cengage Digital Learning Hub
        </a>
        <a href="<%= request.getContextPath() %>/catalog" class="btn" style="background: rgba(255,255,255,0.2); color: #fff;">
            ← Back to Library
        </a>
    </header>

    <div class="container">
        <% if (pub != null) { %>
            <article class="reader-container">
                <div class="reader-header">
                    <span class="card-badge badge-textbook"><%= pub.getType() %></span>
                    <h1 style="margin: 0.5rem 0;"><%= pub.getTitle() %></h1>
                    <div style="color: var(--text-muted); font-size: 1.05rem;">
                        Author: <strong><%= pub.getAuthor() %></strong> &bull; Category: <em><%= pub.getCategory() %></em>
                    </div>
                    <% if (pub.getIsbn() != null && !pub.getIsbn().isEmpty()) { %>
                        <div style="font-size: 0.85rem; color: #888; margin-top: 0.3rem;">
                            Identifier: <%= pub.getIsbn() %>
                        </div>
                    <% } %>
                </div>

                <div class="reader-content">
                    <%-- Display the formatted content lines --%>
                    <%= pub.getContent().replace("\n", "<br><br>") %>
                </div>

                <div style="margin-top: 3rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                    <span style="color: #28a745; font-weight: 600;">
                        ✓ Reading progress synced to User Database (DB 1)
                    </span>
                    <a href="<%= request.getContextPath() %>/catalog" class="btn btn-primary">
                        Done Reading
                    </a>
                </div>
            </article>
        <% } else { %>
            <div style="text-align: center; margin-top: 4rem;">
                <h2>Publication not found</h2>
                <a href="<%= request.getContextPath() %>/catalog" class="btn btn-primary">Return to Catalog</a>
            </div>
        <% } %>
    </div>

</body>
</html>

