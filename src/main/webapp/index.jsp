<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cengage.library.model.Publication" %>
<%@ page import="com.cengage.library.model.UserSubscription" %>
<%
    UserSubscription userSub = (UserSubscription) request.getAttribute("userSub");
    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
    String activeFilter = (String) request.getAttribute("activeFilter");
    String appVersion = (String) request.getAttribute("appVersion");
    String appColor = (String) request.getAttribute("appColor");
    if (appColor == null) appColor = "blue";
    if (appVersion == null) appVersion = "v1.0.0";
    if (activeFilter == null) activeFilter = "ALL";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cengage Digital Learning & Publication Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="theme-<%= appColor %>">

    <!-- Top Navigation Bar -->
    <header class="navbar">
        <a href="<%= request.getContextPath() %>/" class="brand">
            📚 Cengage Digital Learning Hub
            <span class="version-pill"><%= appVersion %> (<%= appColor %>)</span>
        </a>
        <div class="user-badge">
            👤 <%= (userSub != null) ? userSub.getFullName() : "Guest" %> | 
            🏛️ <%= (userSub != null) ? userSub.getInstitution() : "Open Access" %> |
            ⭐ <strong><%= (userSub != null) ? userSub.getPlanName() : "Unlimited" %></strong>
        </div>
    </header>

    <div class="container">
        <!-- Search and Filters Section -->
        <section class="search-filter-section">
            <form action="<%= request.getContextPath() %>/catalog" method="GET" class="search-form">
                <input type="hidden" name="type" value="<%= activeFilter %>">
                <input type="text" name="q" class="search-input" placeholder="Search textbooks, newspapers, topics, authors..." 
                       value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>

            <div class="filter-buttons">
                <a href="<%= request.getContextPath() %>/catalog?type=ALL" class="filter-btn <%= "ALL".equals(activeFilter) ? "active" : "" %>">All</a>
                <a href="<%= request.getContextPath() %>/catalog?type=TEXTBOOK" class="filter-btn <%= "TEXTBOOK".equals(activeFilter) ? "active" : "" %>">Textbooks</a>
                <a href="<%= request.getContextPath() %>/catalog?type=NEWSPAPER" class="filter-btn <%= "NEWSPAPER".equals(activeFilter) ? "active" : "" %>">Newspapers</a>
                <a href="<%= request.getContextPath() %>/catalog?type=RESEARCH_PAPER" class="filter-btn <%= "RESEARCH_PAPER".equals(activeFilter) ? "active" : "" %>">Research</a>
            </div>
        </section>

        <!-- Publications Grid -->
        <main class="publications-grid">
            <% if (publications != null && !publications.isEmpty()) { 
                for (Publication pub : publications) { 
                    String badgeClass = "badge-textbook";
                    if ("NEWSPAPER".equalsIgnoreCase(pub.getType())) badgeClass = "badge-newspaper";
                    if ("RESEARCH_PAPER".equalsIgnoreCase(pub.getType())) badgeClass = "badge-research";
            %>
                <article class="card">
                    <img src="<%= pub.getCoverUrl() != null && !pub.getCoverUrl().isEmpty() ? pub.getCoverUrl() : "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80" %>" 
                         alt="<%= pub.getTitle() %>" class="card-img" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80'">
                    <div class="card-body">
                        <span class="card-badge <%= badgeClass %>"><%= pub.getType() %></span>
                        <h2 class="card-title"><%= pub.getTitle() %></h2>
                        <div class="card-author">By <%= pub.getAuthor() %> • <em><%= pub.getCategory() %></em></div>
                        <p class="card-summary"><%= pub.getSummary() %></p>
                        <a href="<%= request.getContextPath() %>/read?id=<%= pub.getId() %>" class="btn btn-primary">Read Now</a>
                    </div>
                </article>
            <%   } 
               } else { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 3rem; background: #fff; border-radius: 8px;">
                    <h3>No publications found</h3>
                    <p>Database 2 (Catalog DB) is empty or seeding is pending. Try searching another category or reset filters.</p>
                </div>
            <% } %>
        </main>

        <!-- System Architecture Diagnostic Bar -->
        <footer class="diagnostic-bar">
            <div>
                <strong>Connected Architecture:</strong> 
                User Subscriptions (DB 1) &bull; Publication Catalog (DB 2) &bull; Apache Tomcat
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/health" target="_blank" style="color: #0d6efd; font-weight: 600; text-decoration: none;">
                    🔍 Check K8s Health Probe JSON (/health)
                </a>
            </div>
        </footer>
    </div>

</body>
</html>

