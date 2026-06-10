<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "dashboard";
%>
<!-- Admin Sidebar -->
<aside class="admin-sidebar">
    <div class="admin-header">
        <h2>Admin Panel</h2>
        <p>Welcome back, <%= admin.getFirstName() %>!</p>
    </div>
    
    <div class="admin-info">
        <div class="admin-badge">
            <i class="fa-solid fa-user-shield"></i> Administrator
        </div>
    </div>
    
    <nav class="admin-nav">
        <ul>
            <li><a href="AdminDashboardServlet" class="<%= "dashboard".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="AdminManagementServlet" class="<%= "admins".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-user-shield"></i> Manage Admins</a></li>
            <li><a href="AdminUserManagementServlet" class="<%= "users".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-users"></i> Manage Users</a></li>
            <li><a href="AdminApartmentManagementServlet" class="<%= "apartments".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
            <li><a href="AdminReviewManagementServlet" class="<%= "reviews".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-star"></i> Manage Reviews</a></li>
            <li><a href="AdminReportsServlet" class="<%= "reports".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-chart-bar"></i> Reports & Analytics</a></li>
            <li><a href="AdminSettingsServlet" class="<%= "settings".equals(currentPage) ? "active" : "" %>"><i class="fa-solid fa-cog"></i> System Settings</a></li>
        </ul>
    </nav>
    
    <div class="logout-section">
        <button class="logout-btn" onclick="logout()">
            <i class="fa-solid fa-sign-out-alt"></i> Logout
        </button>
    </div>
</aside>
