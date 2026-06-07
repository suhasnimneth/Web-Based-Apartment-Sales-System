<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Map" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
    
    // Get statistics from request attributes
    @SuppressWarnings("unchecked")
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    
    // Set default values if stats are null
    int totalUsers = stats != null ? (Integer) stats.getOrDefault("totalUsers", 0) : 0;
    int totalApartments = stats != null ? (Integer) stats.getOrDefault("totalApartments", 0) : 0;
    int totalBookings = stats != null ? (Integer) stats.getOrDefault("totalBookings", 0) : 0;
    int totalReviews = stats != null ? (Integer) stats.getOrDefault("totalReviews", 0) : 0;
    int recentUsers = stats != null ? (Integer) stats.getOrDefault("recentUsers", 0) : 0;
    int recentApartments = stats != null ? (Integer) stats.getOrDefault("recentApartments", 0) : 0;
    int recentBookings = stats != null ? (Integer) stats.getOrDefault("recentBookings", 0) : 0;
    int recentReviews = stats != null ? (Integer) stats.getOrDefault("recentReviews", 0) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ApartmentX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin-sidebar.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Poppins", sans-serif;
            background: #f8f8f8;
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
            background: #fff;
            box-shadow: 4px 0 15px rgba(0,0,0,0.05);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            border-right: 1px solid rgba(0,0,0,0.1);
        }
        
        .admin-header {
            padding: 30px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #fff, #fef2f2);
        }
        
        .admin-header h2 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            font-weight: 700;
            color: #e63946;
        }
        
        .admin-header p {
            color: #666;
            font-size: 0.95rem;
        }
        
        .admin-info {
            padding: 20px 25px;
            background: #f8f9fa;
            border-bottom: 1px solid #e1e5e9;
        }
        
        .admin-info h3 {
            color: #333;
            font-size: 1.1rem;
            margin-bottom: 8px;
        }
        
        .admin-info p {
            color: #666;
            font-size: 0.9rem;
            margin: 3px 0;
        }
        
        .admin-info .admin-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 10px;
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
        }
        
        /* Main Content */
        .admin-main {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }
        
        .dashboard-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .dashboard-header h1 {
            color: #333;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .dashboard-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .welcome-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        
        .welcome-text h2 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }
        
        .welcome-text p {
            color: #666;
            font-size: 1rem;
        }
        
        .admin-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: bold;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }
        
        .stat-icon.users { background: linear-gradient(135deg, #28a745, #20c997); }
        .stat-icon.apartments { background: linear-gradient(135deg, #007bff, #0056b3); }
        .stat-icon.bookings { background: linear-gradient(135deg, #ffc107, #e0a800); }
        .stat-icon.reviews { background: linear-gradient(135deg, #dc3545, #c82333); }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 1rem;
            font-weight: 500;
        }
        
        .stat-subtitle {
            color: #28a745;
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: 5px;
        }
        
        /* Quick Actions */
        .quick-actions {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .quick-actions h3 {
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border: none;
            border-radius: 12px;
            text-decoration: none;
            color: #333;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .action-btn i {
            margin-right: 12px;
            font-size: 1.2rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .admin-main {
                margin-left: 0;
                padding: 20px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Admin Sidebar -->
        <jsp:include page="includes/admin-sidebar.jsp">
            <jsp:param name="currentPage" value="dashboard"/>
        </jsp:include>
        
        <!-- Main Content -->
        <main class="admin-main">
            <div class="dashboard-header">
                <div class="welcome-section">
                    <div class="welcome-text">
                        <h2>Welcome back, <%= admin.getFirstName() %>!</h2>
                        <p>Here's what's happening with your apartment management system today.</p>
                    </div>
                    <div class="admin-avatar">
                        <%= admin.getFirstName().charAt(0) %><%= admin.getLastName().charAt(0) %>
                    </div>
                </div>
            </div>
            
            <!-- Statistics Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon users">
                            <i class="fa-solid fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="stat-label">Total Users</div>
                    <div class="stat-subtitle">+<%= recentUsers %> this week</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon apartments">
                            <i class="fa-solid fa-building"></i>
                        </div>
                    </div>
                    <div class="stat-number"><%= totalApartments %></div>
                    <div class="stat-label">Total Apartments</div>
                    <div class="stat-subtitle">+<%= recentApartments %> this week</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon bookings">
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                    </div>
                    <div class="stat-number"><%= totalBookings %></div>
                    <div class="stat-label">Total Bookings</div>
                    <div class="stat-subtitle">+<%= recentBookings %> this week</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon reviews">
                            <i class="fa-solid fa-star"></i>
                        </div>
                    </div>
                    <div class="stat-number"><%= totalReviews %></div>
                    <div class="stat-label">Total Reviews</div>
                    <div class="stat-subtitle">+<%= recentReviews %> this week</div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="quick-actions">
                <h3><i class="fa-solid fa-bolt"></i> Quick Actions</h3>
                <div class="actions-grid">
                    <a href="AdminManagementServlet" class="action-btn">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Add New Admin</span>
                    </a>
                    <a href="AdminUserManagementServlet" class="action-btn">
                        <i class="fa-solid fa-users"></i>
                        <span>Manage Users</span>
                    </a>
                    <a href="AdminApartmentManagementServlet" class="action-btn">
                        <i class="fa-solid fa-building"></i>
                        <span>Manage Apartments</span>
                    </a>
                    <a href="AdminReviewManagementServlet" class="action-btn">
                        <i class="fa-solid fa-star"></i>
                        <span>Manage Reviews</span>
                    </a>
                    <a href="AdminReportsServlet" class="action-btn">
                        <i class="fa-solid fa-chart-line"></i>
                        <span>View Reports</span>
                    </a>
                    <a href="AdminSettingsServlet" class="action-btn">
                        <i class="fa-solid fa-cog"></i>
                        <span>System Settings</span>
                    </a>
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
        
        // Add some interactivity
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Admin Dashboard Loaded');
            
            // Animate stat numbers (placeholder for future implementation)
            const statNumbers = document.querySelectorAll('.stat-number');
            statNumbers.forEach(stat => {
                // Future: Add counting animation here
            });
        });
        
        // Mobile menu toggle (for future implementation)
        function toggleSidebar() {
            const sidebar = document.querySelector('.admin-sidebar');
            sidebar.style.transform = sidebar.style.transform === 'translateX(0px)' ? 'translateX(-100%)' : 'translateX(0px)';
        }
    </script>
</body>
</html>
