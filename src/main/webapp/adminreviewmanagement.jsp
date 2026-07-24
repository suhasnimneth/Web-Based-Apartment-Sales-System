<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="com.project.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    
    Double averageRating = (Double) request.getAttribute("averageRating");
    Integer totalReviews = (Integer) request.getAttribute("totalReviews");
    Integer visibleReviews = (Integer) request.getAttribute("visibleReviews");
    Integer hiddenReviews = (Integer) request.getAttribute("hiddenReviews");
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Review Management - ApartmentX</title>
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

        /* Review Management */
        .review-management {
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

        /* Reviews List */
        .reviews-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .review-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #e63946;
        }

        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        .review-card.hidden {
            border-left-color: #6c757d;
            opacity: 0.7;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .review-info {
            flex: 1;
        }

        .review-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .review-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            color: #666;
            font-size: 0.9rem;
        }

        .review-rating {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .stars {
            color: #ffc107;
            font-size: 1.1rem;
        }

        .review-author {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .review-date {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .review-content {
            margin-bottom: 20px;
        }

        .review-text {
            color: #555;
            line-height: 1.6;
            font-size: 1rem;
        }

        .review-actions {
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

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .visibility-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .visible {
            background: #d4edda;
            color: #155724;
        }

        .hidden {
            background: #f8d7da;
            color: #721c24;
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

            .review-header {
                flex-direction: column;
                gap: 15px;
            }

            .review-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .review-actions {
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
                    <li><a href="AdminApartmentManagementServlet"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
                    <li><a href="AdminReviewManagementServlet" class="active"><i class="fa-solid fa-star"></i> Manage Reviews</a></li>
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
                <h1><i class="fa-solid fa-star"></i> Review Management</h1>
                <p>Manage all customer reviews and ratings</p>
            </div>

            <div class="review-management">
                <div class="management-header">
                    <h2><i class="fa-solid fa-list"></i> All Reviews</h2>
                </div>

                <% if (reviews != null && !reviews.isEmpty()) { %>
                    <!-- Statistics Summary -->
                    <div class="stats-summary">
                        <div class="stat-card">
                            <div class="stat-number"><%= totalReviews != null ? totalReviews : reviews.size() %></div>
                            <div class="stat-label">Total Reviews</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= averageRating != null ? String.format("%.1f", averageRating) : "0.0" %></div>
                            <div class="stat-label">Average Rating</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= visibleReviews != null ? visibleReviews : reviews.stream().mapToInt(r -> r.isVisible() ? 1 : 0).sum() %></div>
                            <div class="stat-label">Visible Reviews</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= hiddenReviews != null ? hiddenReviews : reviews.stream().mapToInt(r -> r.isVisible() ? 0 : 1).sum() %></div>
                            <div class="stat-label">Hidden Reviews</div>
                        </div>
                    </div>

                    <!-- Reviews List -->
                    <div class="reviews-list">
                        <% for (Review review : reviews) { %>
                            <div class="review-card <%= review.isVisible() ? "" : "hidden" %>">
                                <div class="review-header">
                                    <div class="review-info">
                                        <h3 class="review-title"><%= review.getTitle() %></h3>
                                        <div class="review-meta">
                                            <div class="review-rating">
                                                <span class="stars"><%= review.getStarRating() %></span>
                                                <span>(<%= review.getRating() %>/5)</span>
                                            </div>
                                            <div class="review-author">
                                                <i class="fa-solid fa-user"></i>
                                                <%= review.getBuyerName() != null ? review.getBuyerName() : "Anonymous" %>
                                            </div>
                                            <div class="review-date">
                                                <i class="fa-solid fa-calendar"></i>
                                                <%= review.getCreatedAt().format(dateFormatter) %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="visibility-badge <%= review.isVisible() ? "visible" : "hidden" %>">
                                        <%= review.isVisible() ? "Visible" : "Hidden" %>
                                    </div>
                                </div>
                                
                                <div class="review-content">
                                    <p class="review-text"><%= review.getReviewText() %></p>
                                </div>
                                
                                <div class="review-actions">
                                    <button class="btn btn-primary" onclick="viewReview('<%= review.getReviewId() %>')">
                                        <i class="fa-solid fa-eye"></i> View Details
                                    </button>
                                    <!--<button class="btn btn-warning" onclick="editReview('<%= review.getReviewId() %>')">
                                        <i class="fa-solid fa-edit"></i> Edit
                                    </button> -->
                                    <button class="btn <%= review.isVisible() ? "btn-warning" : "btn-success" %>" onclick="toggleReview('<%= review.getReviewId() %>')">
                                        <i class="fa-solid fa-toggle-<%= review.isVisible() ? "on" : "off" %>"></i>
                                        <%= review.isVisible() ? "Hide" : "Show" %>
                                    </button>
                                    <button class="btn btn-danger" onclick="deleteReview('<%= review.getReviewId() %>')">
                                        <i class="fa-solid fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="loading">
                        <i class="fa-solid fa-circle-info" style="color:#6b7280;"></i>
                        <p>No reviews found yet.</p>
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

        function viewReview(reviewId) {
            alert('View review details for: ' + reviewId);
            // Implement view review functionality
        }

        function editReview(reviewId) {
            const newTitle = prompt('Enter new title:', '');
            const newText = prompt('Enter new review text:', '');
            const newRating = prompt('Enter new rating (1-5):', '');

            if (newTitle && newText && newRating) {
                const rating = parseInt(newRating);
                if (rating >= 1 && rating <= 5) {
                    const formData = new URLSearchParams();
                    formData.append('action', 'update');
                    formData.append('reviewId', reviewId);
                    formData.append('title', newTitle);
                    formData.append('reviewText', newText);
                    formData.append('rating', newRating);

                    fetch('AdminReviewManagementServlet', {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data === 'success') {
                            alert('Review updated successfully!');
                            location.reload();
                        } else if (data.startsWith('error:')) {
                            alert('Failed to update review. Error: ' + data.substring(6));
                        } else {
                            alert('Failed to update review. Please try again.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error updating review. Please try again.');
                    });
                } else {
                    alert('Rating must be between 1 and 5');
                }
            }
        }

        function toggleReview(reviewId) {
            const formData = new URLSearchParams();
            formData.append('action', 'toggle');
            formData.append('reviewId', reviewId);

            fetch('AdminReviewManagementServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Review visibility toggled successfully!');
                    location.reload();
                } else if (data.startsWith('error:')) {
                    alert('Failed to toggle review visibility. Error: ' + data.substring(6));
                } else {
                    alert('Failed to toggle review visibility. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error toggling review visibility. Please try again.');
            });
        }

        function deleteReview(reviewId) {
            if (confirm('Are you sure you want to delete this review? This action cannot be undone.')) {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('reviewId', reviewId);

                fetch('AdminReviewManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('Review deleted successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('Failed to delete review. Error: ' + data.substring(6));
                    } else {
                        alert('Failed to delete review. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting review. Please try again.');
                });
            }
        }
    </script>
</body>
</html>
