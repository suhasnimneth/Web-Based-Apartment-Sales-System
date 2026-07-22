<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    @SuppressWarnings("unchecked")
    Map<String, Object> userStats = (Map<String, Object>) request.getAttribute("userStats");
    @SuppressWarnings("unchecked")
    Map<String, Object> apartmentStats = (Map<String, Object>) request.getAttribute("apartmentStats");
    @SuppressWarnings("unchecked")
    Map<String, Object> reviewStats = (Map<String, Object>) request.getAttribute("reviewStats");
    @SuppressWarnings("unchecked")
    Map<String, Object> bookingStats = (Map<String, Object>) request.getAttribute("bookingStats");
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> recentActivity = (List<Map<String, Object>>) request.getAttribute("recentActivity");
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.US);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reports & Analytics - ApartmentX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #333;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .admin-sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            padding: 30px 0;
            box-shadow: 2px 0 20px rgba(0, 0, 0, 0.1);
        }

        .admin-header {
            text-align: center;
            padding: 0 30px 30px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .admin-header h2 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            font-weight: 700;
            color: #e63946;
        }

        .admin-header p {
            color: #666;
            font-size: 0.9rem;
        }

        .admin-nav {
            padding: 0 20px;
        }

        .admin-nav ul {
            list-style: none;
        }

        .admin-nav li {
            margin-bottom: 8px;
        }

        .admin-nav a {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #555;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .admin-nav a:hover,
        .admin-nav a.active {
            background: rgba(230,57,70,0.1);
            color: #e63946;
            border-left-color: #e63946;
        }

        .admin-nav i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .logout-section {
            padding: 20px;
            margin-top: auto;
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(230, 57, 70, 0.3);
        }

        /* Main Content */
        .admin-main {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .page-header p {
            color: #666;
            font-size: 1.1rem;
        }

        /* Reports Section */
        .reports-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .section-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .section-header h2 {
            color: #333;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .section-header p {
            color: #666;
            font-size: 1rem;
        }

        /* Statistics Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .stat-card.users {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .stat-card.apartments {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .stat-card.bookings {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .stat-card.reviews {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Charts Section */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .chart-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .chart-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .chart-header h3 {
            color: #333;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .chart-content {
            min-height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 15px;
        }

        .chart-placeholder {
            color: #666;
            font-size: 1.1rem;
            text-align: center;
        }

        .chart-placeholder i {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        /* Data Tables */
        .data-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .table-header {
            background: linear-gradient(135deg, #e63946 0%, #d62828 100%);
            color: white;
            padding: 20px;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .table-content {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        tr:hover {
            background: #f8f9fa;
        }

        /* Recent Activity */
        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: #f8f9fa;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
        }

        .activity-icon.user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .activity-icon.apartment {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .activity-icon.review {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .activity-description {
            color: #666;
            font-size: 0.9rem;
        }

        .activity-date {
            color: #999;
            font-size: 0.8rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .admin-container {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                height: auto;
            }

            .admin-main {
                padding: 20px;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .charts-grid {
                grid-template-columns: 1fr;
            }

            .table-content {
                font-size: 0.9rem;
            }

            th, td {
                padding: 10px 15px;
            }
        }

        /* Loading and Messages */
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="admin-header">
                <h2>Admin Panel</h2>
                <p>Welcome back, <%= admin.getFirstName() %>!</p>
            </div>
            
            <nav class="admin-nav">
                <ul>
                    <li><a href="AdminDashboardServlet"><i class="fa-solid fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="AdminManagementServlet"><i class="fa-solid fa-user-shield"></i> Manage Admins</a></li>
                    <li><a href="AdminUserManagementServlet"><i class="fa-solid fa-users"></i> Manage Users</a></li>
                    <li><a href="AdminApartmentManagementServlet"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
                    <li><a href="AdminReviewManagementServlet"><i class="fa-solid fa-star"></i> Manage Reviews</a></li>
                    <li><a href="AdminReportsServlet" class="active"><i class="fa-solid fa-chart-bar"></i> Reports & Analytics</a></li>
                    <li><a href="AdminSettingsServlet"><i class="fa-solid fa-cog"></i> System Settings</a></li>
                </ul>
            </nav>
            
            <div class="logout-section">
                <button class="logout-btn" onclick="logout()">
                    <i class="fa-solid fa-sign-out-alt"></i> Logout
                </button>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <div class="page-header">
                <h1><i class="fa-solid fa-chart-bar"></i> Reports & Analytics</h1>
                <p>Comprehensive insights and statistics for your apartment management system</p>
            </div>

            <!-- Overall Statistics -->
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-chart-pie"></i> Overall Statistics</h2>
                    <p>Key metrics and performance indicators</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card users">
                        <div class="stat-icon">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="stat-number"><%= stats != null ? stats.getOrDefault("totalUsers", 0) : 0 %></div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    
                    <div class="stat-card apartments">
                        <div class="stat-icon">
                            <i class="fa-solid fa-building"></i>
                        </div>
                        <div class="stat-number"><%= stats != null ? stats.getOrDefault("totalApartments", 0) : 0 %></div>
                        <div class="stat-label">Total Apartments</div>
                    </div>
                    
                    <div class="stat-card bookings">
                        <div class="stat-icon">
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                        <div class="stat-number"><%= stats != null ? stats.getOrDefault("totalBookings", 0) : 0 %></div>
                        <div class="stat-label">Total Bookings</div>
                    </div>
                    
                    <div class="stat-card reviews">
                        <div class="stat-icon">
                            <i class="fa-solid fa-star"></i>
                        </div>
                        <div class="stat-number"><%= stats != null ? stats.getOrDefault("totalReviews", 0) : 0 %></div>
                        <div class="stat-label">Total Reviews</div>
                    </div>
                </div>
            </div>

            <!-- User Analytics -->
            <% if (userStats != null) { %>
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-users"></i> User Analytics</h2>
                    <p>User registration trends and role distribution</p>
                </div>

                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Users by Role</h3>
                        </div>
                        <div class="chart-content">
                            <div class="chart-placeholder">
                                <i class="fa-solid fa-chart-pie"></i>
                                <p>Role Distribution Chart</p>
                                <small>Buyers: <%= userStats.getOrDefault("users_buyer", 0) %> | Sellers: <%= userStats.getOrDefault("users_seller", 0) %></small>
                            </div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>New Users This Month</h3>
                        </div>
                        <div class="chart-content">
                            <div class="stat-number" style="color: #e63946; font-size: 2.5rem;">
                                <%= userStats.getOrDefault("newUsersThisMonth", 0) %>
                            </div>
                            <div class="stat-label">New Registrations</div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Apartment Analytics -->
            <% if (apartmentStats != null) { %>
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-building"></i> Apartment Analytics</h2>
                    <p>Property listings and market insights</p>
                </div>

                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Apartments by City</h3>
                        </div>
                        <div class="chart-content">
                            <div class="chart-placeholder">
                                <i class="fa-solid fa-map-marked-alt"></i>
                                <p>Geographic Distribution</p>
                                <small>Average Price: <%= apartmentStats.get("averagePrice") != null ? currencyFormat.format((Double) apartmentStats.get("averagePrice")) : "$0" %></small>
                            </div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>New Listings This Month</h3>
                        </div>
                        <div class="chart-content">
                            <div class="stat-number" style="color: #e63946; font-size: 2.5rem;">
                                <%= apartmentStats.getOrDefault("newApartmentsThisMonth", 0) %>
                            </div>
                            <div class="stat-label">New Apartments</div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Review Analytics -->
            <% if (reviewStats != null) { %>
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-star"></i> Review Analytics</h2>
                    <p>Customer satisfaction and feedback analysis</p>
                </div>

                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Average Rating</h3>
                        </div>
                        <div class="chart-content">
                            <div class="stat-number" style="color: #ffc107; font-size: 2.5rem;">
                                <%= reviewStats.get("averageRating") != null ? String.format("%.1f", (Double) reviewStats.get("averageRating")) : "0.0" %>
                            </div>
                            <div class="stat-label">Out of 5 Stars</div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Review Visibility</h3>
                        </div>
                        <div class="chart-content">
                            <div class="chart-placeholder">
                                <i class="fa-solid fa-eye"></i>
                                <p>Visibility Status</p>
                                <small>Visible: <%= reviewStats.getOrDefault("visibleReviews", 0) %> | Hidden: <%= reviewStats.getOrDefault("hiddenReviews", 0) %></small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Recent Activity -->
            <% if (recentActivity != null && !recentActivity.isEmpty()) { %>
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-clock"></i> Recent Activity</h2>
                    <p>Latest updates and user actions</p>
                </div>

                <div class="data-table">
                    <div class="table-header">
                        <i class="fa-solid fa-list"></i> Activity Feed
                    </div>
                    <div class="table-content">
                        <% for (Map<String, Object> activity : recentActivity) { %>
                            <div class="activity-item">
                                <div class="activity-icon <%= activity.get("type").toString().toLowerCase() %>">
                                    <% if ("user".equals(activity.get("type"))) { %>
                                        <i class="fa-solid fa-user"></i>
                                    <% } else if ("apartment".equals(activity.get("type"))) { %>
                                        <i class="fa-solid fa-building"></i>
                                    <% } else if ("review".equals(activity.get("type"))) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } else { %>
                                        <i class="fa-solid fa-circle"></i>
                                    <% } %>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title">
                                        <%= activity.get("type").toString().equals("user") ? "New User Registration" : 
                                            activity.get("type").toString().equals("apartment") ? "New Apartment Listing" : 
                                            activity.get("type").toString().equals("review") ? "New Review Posted" : "Activity" %>
                                    </div>
                                    <div class="activity-description">
                                        <%= activity.get("name") %>
                                    </div>
                                </div>
                                <div class="activity-date">
                                    <%= activity.get("date") %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Export Options -->
            <div class="reports-section">
                <div class="section-header">
                    <h2><i class="fa-solid fa-download"></i> Export Reports</h2>
                    <p>Download detailed reports and data exports</p>
                </div>

                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Export Options</h3>
                        </div>
                        <div class="chart-content">
                            <div class="chart-placeholder">
                                <i class="fa-solid fa-file-excel"></i>
                                <p>Data Export</p>
                                <small>CSV formats</small>
                                <div style="margin-top:15px; display:flex; gap:10px; flex-wrap:wrap; justify-content:center;">
                                    <a class="btn" href="AdminReportsServlet?action=export&dataset=users" style="background:#2563eb;color:#fff;border-radius:8px;padding:8px 12px;text-decoration:none;">Export Users</a>
                                    <a class="btn" href="AdminReportsServlet?action=export&dataset=apartments" style="background:#10b981;color:#fff;border-radius:8px;padding:8px 12px;text-decoration:none;">Export Apartments</a>
                                    <a class="btn" href="AdminReportsServlet?action=export&dataset=reviews" style="background:#f59e0b;color:#fff;border-radius:8px;padding:8px 12px;text-decoration:none;">Export Reviews</a>
                                    <a class="btn" href="AdminReportsServlet?action=export&dataset=bookings" style="background:#ef4444;color:#fff;border-radius:8px;padding:8px 12px;text-decoration:none;">Export Bookings</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Report Generation</h3>
                        </div>
                        <div class="chart-content">
                            <div class="chart-placeholder">
                                <i class="fa-solid fa-chart-line"></i>
                                <p>Custom Reports</p>
                                <small>Generate quick summary report</small>
                                <div style="margin-top:15px;">
                                    <a class="btn" href="AdminReportsServlet?action=custom_report" style="background:#7c3aed;color:#fff;border-radius:8px;padding:10px 14px;text-decoration:none;">Download Summary CSV</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        // Auto-refresh data every 5 minutes
        setInterval(function() {
            // You can implement auto-refresh here if needed
            console.log('Reports data refreshed');
        }, 300000);
    </script>
</body>
</html>
