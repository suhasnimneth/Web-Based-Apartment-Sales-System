<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="com.project.model.Apartment" %>
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
    List<Apartment> apartments = (List<Apartment>) request.getAttribute("apartments");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "LK"));
    double averagePriceValue = (apartments != null && !apartments.isEmpty())
            ? apartments.stream().mapToDouble(a -> a.getPrice().doubleValue()).average().orElse(0.0)
            : 0.0;
    String averagePriceFormatted = currencyFormat.format(averagePriceValue);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Apartment Management - ApartmentX</title>
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

        /* Apartment Management */
        .apartment-management {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .management-header {
            display: flex;
            justify-content: space-between;
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

        /* Apartment Grid */
        .apartments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .apartment-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .apartment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .apartment-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            position: relative;
            overflow: hidden;
        }

        .apartment-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .apartment-image .no-image {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .apartment-content {
            padding: 20px;
        }

        .apartment-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
            line-height: 1.3;
        }

        .apartment-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #e63946;
            margin-bottom: 15px;
        }

        .apartment-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 15px;
        }

        .detail-item {
            text-align: center;
            padding: 8px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .detail-label {
            font-size: 0.8rem;
            color: #666;
            margin-bottom: 3px;
        }

        .detail-value {
            font-weight: 600;
            color: #333;
        }

        .apartment-location {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .apartment-seller {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
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
            flex: 1;
            justify-content: center;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
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

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
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

            .apartments-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
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
                    <li><a href="AdminApartmentManagementServlet" class="active"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
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
                <h1><i class="fa-solid fa-building"></i> Apartment Management</h1>
                <p>Manage all apartment listings in the system</p>
            </div>

            <div class="apartment-management">
                <div class="management-header">
                    <h2><i class="fa-solid fa-list"></i> All Apartments</h2>
                </div>

                <% if (apartments != null && !apartments.isEmpty()) { %>
                    <!-- Statistics Summary -->
                    <div class="stats-summary">
                        <div class="stat-card">
                            <div class="stat-number"><%= apartments.size() %></div>
                            <div class="stat-label">Total Apartments</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= averagePriceFormatted %></div>
                            <div class="stat-label">Average Price</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= apartments.stream().map(Apartment::getCity).distinct().count() %></div>
                            <div class="stat-label">Cities</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= apartments.stream().map(Apartment::getSellerId).distinct().count() %></div>
                            <div class="stat-label">Active Sellers</div>
                        </div>
                    </div>

                    <!-- Apartments Grid -->
                    <div class="apartments-grid">
                        <% for (Apartment apartment : apartments) { %>
                            <div class="apartment-card">
                                <div class="apartment-image">
                                    <% if (apartment.getPrimaryImageUrl() != null && !apartment.getPrimaryImageUrl().isEmpty()) { 
                                        // Extract filename from the full path (same logic as other JSP files)
                                        String filename = apartment.getPrimaryImageUrl().replace("/resources/images/", "");
                                        System.out.println("AdminApartmentManagement - Image path: " + apartment.getPrimaryImageUrl() + ", Filename: " + filename);
                                    %>
                                        <img src="image?file=<%= filename %>" alt="<%= apartment.getTitle() %>" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="no-image" style="display: none;">
                                            <i class="fa-solid fa-building"></i>
                                            <span>Image Error</span>
                                        </div>
                                    <% } else { %>
                                        <div class="no-image">
                                            <i class="fa-solid fa-building"></i>
                                            <span>No Image</span>
                                        </div>
                                    <% } %>
                                </div>
                                
                                <div class="apartment-content">
                                    <h3 class="apartment-title"><%= apartment.getTitle() %></h3>
                                    <div class="apartment-price"><%= currencyFormat.format(apartment.getPrice()) %></div>
                                    
                                    <div class="apartment-details">
                                        <% if (apartment.getBedrooms() != null) { %>
                                            <div class="detail-item">
                                                <div class="detail-label">Bedrooms</div>
                                                <div class="detail-value"><%= apartment.getBedrooms() %></div>
                                            </div>
                                        <% } %>
                                        <% if (apartment.getBathrooms() != null) { %>
                                            <div class="detail-item">
                                                <div class="detail-label">Bathrooms</div>
                                                <div class="detail-value"><%= apartment.getBathrooms() %></div>
                                            </div>
                                        <% } %>
                                        <% if (apartment.getAreaSqFt() != null) { %>
                                            <div class="detail-item">
                                                <div class="detail-label">Area (sq ft)</div>
                                                <div class="detail-value"><%= apartment.getAreaSqFt() %></div>
                                            </div>
                                        <% } %>
                                    </div>
                                    
                                    <div class="apartment-location">
                                        <i class="fa-solid fa-map-marker-alt"></i>
                                        <%= apartment.getAddress() %>, <%= apartment.getCity() %>
                                    </div>
                                    
                                    <div class="apartment-seller">
                                        <i class="fa-solid fa-user"></i>
                                        Seller: <%= apartment.getSellerName() != null ? apartment.getSellerName() : "Unknown" %>
                                    </div>
                                    
                                    <div class="action-buttons">
                                        <button class="btn btn-primary" onclick="viewApartment('<%= apartment.getApartmentId() %>')">
                                            <i class="fa-solid fa-eye"></i> View
                                        </button>
                                        <button class="btn btn-warning" onclick="editApartment('<%= apartment.getApartmentId() %>')">
                                            <i class="fa-solid fa-edit"></i> Edit
                                        </button>
                                        <button class="btn btn-danger" onclick="deleteApartment('<%= apartment.getApartmentId() %>')">
                                            <i class="fa-solid fa-trash"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="loading">
                        <i class="fa-solid fa-circle-info" style="color:#6b7280;"></i>
                        <p>No apartments found yet.</p>
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

        function viewApartment(apartmentId) {
            window.open('ViewApartmentServlet?apartmentId=' + apartmentId, '_blank');
        }

        function editApartment(apartmentId) {
            // Show edit modal or redirect to edit page
            const newTitle = prompt('Enter new title:', '');
            const newDescription = prompt('Enter new description:', '');
            const newAddress = prompt('Enter new address:', '');
            const newCity = prompt('Enter new city:', '');
            const newPrice = prompt('Enter new price:', '');

            if (newTitle && newAddress && newCity && newPrice) {
                const formData = new URLSearchParams();
                formData.append('action', 'update');
                formData.append('apartmentId', apartmentId);
                formData.append('title', newTitle);
                formData.append('description', newDescription);
                formData.append('address', newAddress);
                formData.append('city', newCity);
                formData.append('price', newPrice);

                fetch('AdminApartmentManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('Apartment updated successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('Failed to update apartment. Error: ' + data.substring(6));
                    } else {
                        alert('Failed to update apartment. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating apartment. Please try again.');
                });
            }
        }

        function deleteApartment(apartmentId) {
            if (confirm('Are you sure you want to delete this apartment? This action cannot be undone and will also delete associated images.')) {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('apartmentId', apartmentId);

                fetch('AdminApartmentManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('Apartment deleted successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('Failed to delete apartment. Error: ' + data.substring(6));
                    } else {
                        alert('Failed to delete apartment. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting apartment. Please try again.');
                });
            }
        }
    </script>
</body>
</html>
