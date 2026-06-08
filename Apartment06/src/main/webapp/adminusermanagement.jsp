<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="com.project.servlet.AdminUserManagementServlet" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<AdminUserManagementServlet.UserWithRole> users = (List<AdminUserManagementServlet.UserWithRole>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin User Management - ApartmentX</title>
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

        /* User Management */
        .user-management {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .management-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .management-header h2 {
            color: #333;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        /* User Table */
        .users-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
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

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e63946 0%, #d62828 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 15px;
        }

        .user-details h4 {
            color: #333;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .user-details p {
            color: #666;
            font-size: 0.9rem;
        }

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .role-buyer {
            background: #e3f2fd;
            color: #1976d2;
        }

        .role-seller {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .role-user {
            background: #e8f5e8;
            color: #388e3c;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
        }

        .btn-info {
            background: #17a2b8;
            color: white;
        }

        .btn-info:hover {
            background: #138496;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.3);
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

            .stats-summary {
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
                    <li><a href="AdminUserManagementServlet" class="active"><i class="fa-solid fa-users"></i> Manage Users</a></li>
                    <li><a href="AdminApartmentManagementServlet"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
                    <li><a href="AdminReviewManagementServlet"><i class="fa-solid fa-star"></i> Manage Reviews</a></li>
                    <li><a href="AdminReportsServlet"><i class="fa-solid fa-chart-bar"></i> Reports & Analytics</a></li>
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
                <h1><i class="fa-solid fa-users"></i> User Management</h1>
                <p>Manage all users, buyers, and sellers in the system</p>
            </div>

            <div class="user-management">
                <div class="management-header">
                    <h2><i class="fa-solid fa-list"></i> All Users</h2>
                </div>

                <% if (users != null && !users.isEmpty()) { %>
                    <!-- Statistics Summary -->
                    <div class="stats-summary">
                        <div class="stat-card">
                            <div class="stat-number"><%= users.size() %></div>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= users.stream().filter(u -> "buyer".equals(u.getRole())).count() %></div>
                            <div class="stat-label">Buyers</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= users.stream().filter(u -> "seller".equals(u.getRole())).count() %></div>
                            <div class="stat-label">Sellers</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= users.stream().filter(u -> u.getRole() == null).count() %></div>
                            <div class="stat-label">Users Only</div>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="users-table">
                        <div class="table-header">
                            <i class="fa-solid fa-table"></i> User Directory
                        </div>
                        <div class="table-content">
                            <table>
                                <thead>
                                    <tr>
                                        <th>User</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Registration Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (AdminUserManagementServlet.UserWithRole userWithRole : users) { %>
                                        <tr>
                                            <td>
                                                <div class="user-info">
                                                    <div class="user-avatar">
                                                        <%= userWithRole.getUser().getFirstName().charAt(0) %><%= userWithRole.getUser().getLastName().charAt(0) %>
                                                    </div>
                                                    <div class="user-details">
                                                        <h4><%= userWithRole.getUser().getFirstName() %> <%= userWithRole.getUser().getLastName() %></h4>
                                                        <p>ID: <%= userWithRole.getUser().getUserId() %></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><%= userWithRole.getUser().getEmail() %></td>
                                            <td>
                                                <% if (userWithRole.getRole() != null) { %>
                                                    <span class="role-badge role-<%= userWithRole.getRole() %>">
                                                        <%= userWithRole.getRole().toUpperCase() %>
                                                    </span>
                                                    <br><small><%= userWithRole.getRoleId() %></small>
                                                <% } else { %>
                                                    <span class="role-badge role-user">USER ONLY</span>
                                                <% } %>
                                            </td>
                                            <td><%= userWithRole.getUser().getRegistrationDate() %></td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn btn-info" onclick="viewUser('<%= userWithRole.getUser().getUserId() %>')">
                                                        <i class="fa-solid fa-eye"></i> View
                                                    </button>
                                                    <button class="btn btn-danger" onclick="deleteUser('<%= userWithRole.getUser().getUserId() %>')">
                                                        <i class="fa-solid fa-trash"></i> Delete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="loading">
                        <i class="fa-solid fa-circle-info" style="color:#6b7280;"></i>
                        <p>No users found yet.</p>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        function viewUser(userId) {
            alert('View user details for: ' + userId);
            // Implement view user functionality
        }

        function toggleUser(userId) {
            if (confirm('Are you sure you want to toggle this user\'s status?')) {
                const formData = new URLSearchParams();
                formData.append('action', 'toggle');
                formData.append('userId', userId);

                fetch('AdminUserManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('User status toggled successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('Failed to toggle user status. Error: ' + data.substring(6));
                    } else {
                        alert('Failed to toggle user status. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error toggling user status. Please try again.');
                });
            }
        }

        function deleteUser(userId) {
            if (confirm('Are you sure you want to delete this user? This action cannot be undone and will also delete associated buyer/seller records.')) {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('userId', userId);

                fetch('AdminUserManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('User deleted successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('Failed to delete user. Error: ' + data.substring(6));
                    } else {
                        alert('Failed to delete user. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting user. Please try again.');
                });
            }
        }
    </script>
</body>
</html>
