<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Review" %>
<%@ page import="com.project.DAO.ReviewDAO" %>
<%@ page import="com.project.DAO.UserDAO" %>
<%@ page import="com.project.model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Check if user is logged in and is a buyer
    Object userObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
    
    if (userObj == null || !"buyer".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User user = (User) userObj;
    ReviewDAO reviewDAO = new ReviewDAO();
    UserDAO userDAO = new UserDAO();
    
    // Get buyer ID for the current user
    String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
    Review existingReview = null;
    
    if (buyerId != null) {
        existingReview = reviewDAO.getReviewByBuyerId(buyerId);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Review - Apartment Portal</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        .main-content {
            padding: 80px 30px 30px 30px;
            min-height: 100vh;
            position: relative;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            overflow: hidden;
        }

        .back-btn {
            position: absolute;
            top: 30px;
            left: 30px;
            background: transparent;
            border: 2px solid #e63946;
            color: #e63946;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            z-index: 1000;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            position: relative;
            z-index: 2;
        }

        .page-title i {
            font-size: 2rem;
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.2rem;
            margin: 0;
            position: relative;
            z-index: 2;
        }

        .content-section {
            padding: 30px;
        }

        .review-management {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }

        .review-management::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .review-header h2 {
            color: #333;
            font-size: 1.8rem;
            margin: 0;
        }

        .review-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-published {
            background: #d4edda;
            color: #155724;
        }

        .status-none {
            background: #f8d7da;
            color: #721c24;
        }

        .current-review {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid #6c757d;
        }

        .review-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
        }

        .info-value {
            color: #333;
            font-size: 1rem;
        }

        .review-rating {
            display: flex;
            gap: 3px;
            margin-bottom: 1rem;
        }

        .review-rating i {
            color: #ffc107;
            font-size: 1.2rem;
        }

        .review-rating i.fa-solid {
            color: #ffc107;
        }

        .review-rating i.fa-regular {
            color: #e0e0e0;
        }

        .review-content {
            margin-top: 1rem;
        }

        .review-content h4 {
            color: #333;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }

        .review-content p {
            color: #666;
            line-height: 1.6;
        }

        .review-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(67, 233, 123, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 60px 30px;
            color: #6b7280;
        }

        .empty-state h2 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #374151;
        }

        .empty-state p {
            margin-bottom: 25px;
        }

        .empty-state a {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .empty-state a:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .review-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .review-actions {
                flex-direction: column;
            }
            
            .review-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <a href="BuyerDashboardServlet" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="container">
            <div class="page-header">
                <h1 class="page-title"><i class="fa-solid fa-star"></i> My Review</h1>
                <p class="page-subtitle">Manage your review and rating for our apartment management system</p>
            </div>

            <div class="content-section">

        <div class="review-management">
            <div class="review-header">
                <h2>Review Management</h2>
                <% if (existingReview != null) { %>
                    <span class="review-status status-published">Review Published</span>
                <% } else { %>
                    <span class="review-status status-none">No Review Yet</span>
                <% } %>
            </div>

            <% if (existingReview != null) { %>
                <!-- Current Review Display -->
                <div class="current-review">
                    <div class="review-info">
                        <div class="info-item">
                            <span class="info-label">Review ID</span>
                            <span class="info-value"><%= existingReview.getReviewId() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Rating</span>
                            <div class="review-rating">
                                <% 
                                int rating = existingReview.getRating();
                                if (rating <= 0) rating = 0;
                                %>
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <% if (i <= rating) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } else { %>
                                        <i class="fa-regular fa-star"></i>
                                    <% } %>
                                <% } %>
                                <span style="margin-left: 8px; color: #666; font-size: 0.9rem;">
                                    (<%= rating %>/5)
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Created</span>
                            <span class="info-value"><%= existingReview.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Last Updated</span>
                            <span class="info-value"><%= existingReview.getUpdatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) %></span>
                        </div>
                    </div>
                    
                    <div class="review-content">
                        <h4><%= existingReview.getTitle() %></h4>
                        <p><%= existingReview.getReviewText() %></p>
                    </div>
                    
                    <div class="review-actions">
                        <a href="updatereview.jsp?reviewId=<%= existingReview.getReviewId() %>" class="btn btn-primary">
                            <i class="fa-solid fa-edit"></i> Update Review
                        </a>
                        <button onclick="deleteReview('<%= existingReview.getReviewId() %>')" class="btn btn-danger">
                            <i class="fa-solid fa-trash"></i> Delete Review
                        </button>
                    </div>
                </div>
            <% } else { %>
                <!-- No Review State -->
                <div class="empty-state">
                    <h2>No Review Yet</h2>
                    <p>Share your experience with our apartment management system and help other buyers make informed decisions.</p>
                    <a href="addreview.jsp">
                        <i class="fa-solid fa-plus"></i> Write Your First Review
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Review Statistics -->
        <div class="review-stats">
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Your Reviews</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <% if (existingReview != null) { %>
                        <%= existingReview.getRating() %>
                    <% } else { %>
                        0
                    <% } %>
                </div>
                <div class="stat-label">Your Rating</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <% if (existingReview != null) { %>
                        <%= existingReview.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM")) %>
                    <% } else { %>
                        --
                    <% } %>
                </div>
                <div class="stat-label">Review Month</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="review-management">
            <h3>Quick Actions</h3>
            <div class="review-actions">
                <% if (existingReview != null) { %>
                    <a href="updatereview.jsp?reviewId=<%= existingReview.getReviewId() %>" class="btn btn-primary">
                        <i class="fa-solid fa-edit"></i> Update Review
                    </a>
                    <button onclick="deleteReview('<%= existingReview.getReviewId() %>')" class="btn btn-danger">
                        <i class="fa-solid fa-trash"></i> Delete Review
                    </button>
                <% } else { %>
                    <a href="addreview.jsp" class="btn btn-success">
                        <i class="fa-solid fa-plus"></i> Write Review
                    </a>
                <% } %>
            </div>
            </div>
        </div>
    </div>

<script>
    function deleteReview(reviewId) {
        if (confirm('Are you sure you want to delete your review? This action cannot be undone.')) {
            console.log('Deleting review:', reviewId);
            
            const formData = new URLSearchParams();
            formData.append('action', 'delete');
            formData.append('reviewId', reviewId);
            
            fetch('ReviewServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                console.log('Delete response:', data);
                if (data === 'success') {
                    alert('Review deleted successfully!');
                    window.location.href = 'buyerdashboard.jsp';
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
    
    console.log('Buyer Review Management Page Loaded');
</script>
        </div>
    </div>
</body>
</html>
