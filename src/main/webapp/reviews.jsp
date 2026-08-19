<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Get reviews data from request attributes
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double averageRating = (Double) request.getAttribute("averageRating");
    Integer totalReviews = (Integer) request.getAttribute("totalReviews");
    
    if (reviews == null) {
        reviews = new java.util.ArrayList<>();
    }
    if (averageRating == null) {
        averageRating = 0.0;
    }
    if (totalReviews == null) {
        totalReviews = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reviews - Apartment Management System</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: #f8f8f8;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .page-header {
            background: linear-gradient(135deg, #fff, #fef2f2);
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
        }
        .page-header h1 {
            margin: 0;
            color: #333;
            font-size: 2.5rem;
        }
        .page-header span {
            color: #e63946;
        }
        .page-header p {
            margin-top: 10px;
            color: #666;
            font-size: 1.1rem;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            left: 20px;
            top: 20px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
        }

        .reviews-page {
            padding: 1rem 0;
            background: #f8f8f8;
            min-height: calc(100vh - 200px);
        }

        /* Footer Styles */
        .footer {
            background: #333;
            color: white;
            padding: 3rem 0 1rem;
            margin-top: 2rem;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .footer-col h3 {
            color: #e63946;
            margin-bottom: 1rem;
        }

        .footer-col h4 {
            color: white;
            margin-bottom: 1rem;
        }

        .footer-col p {
            color: #ccc;
            margin-bottom: 0.5rem;
        }

        .footer-col ul {
            list-style: none;
            padding: 0;
        }

        .footer-col ul li {
            margin-bottom: 0.5rem;
        }

        .footer-col ul li a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-col ul li a:hover {
            color: #e63946;
        }

        .social-links {
            display: flex;
            gap: 1rem;
        }

        .social-links a {
            color: #ccc;
            font-size: 1.5rem;
            transition: color 0.3s ease;
        }

        .social-links a:hover {
            color: #e63946;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid #555;
            margin-top: 2rem;
            color: #ccc;
        }

        .stats-overview {
            display: flex;
            justify-content: center;
            gap: 3rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            min-width: 150px;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-size: 1rem;
        }

        .rating-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .rating-stars {
            display: flex;
            gap: 3px;
        }

        .rating-stars i {
            color: #ffc107;
            font-size: 1.5rem;
        }

        .rating-score {
            font-size: 2rem;
            font-weight: bold;
            color: #6c757d;
        }

        .reviews-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .review-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .reviewer-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .reviewer-details h4 {
            color: #333;
            font-size: 1.2rem;
            margin-bottom: 0.25rem;
            font-weight: 600;
        }

        .reviewer-details .review-date {
            color: #666;
            font-size: 0.9rem;
        }

        .review-rating {
            display: flex;
            gap: 2px;
        }

        .review-rating i {
            color: #ffc107;
            font-size: 1.1rem;
        }

        .review-content h5 {
            color: #333;
            font-size: 1.3rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .review-content p {
            color: #666;
            line-height: 1.6;
            font-size: 1rem;
        }

        .no-reviews {
            text-align: center;
            padding: 2rem 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin: 1rem 0;
        }

        .no-reviews i {
            font-size: 3rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .no-reviews h3 {
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .no-reviews p {
            color: #666;
            margin-bottom: 1.5rem;
            font-size: 1rem;
        }

        .write-review-btn {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            padding: 1rem 2rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .write-review-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
        }

        .reviews-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .review-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .reviewer-info h4 {
            color: #333;
            margin-bottom: 0.5rem;
        }

        .review-date {
            color: #666;
            font-size: 0.9rem;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .rating-stars {
            display: flex;
            gap: 2px;
        }

        .rating-stars i {
            color: #ffc107;
            font-size: 1rem;
        }

        .rating-number {
            color: #666;
            font-weight: 600;
        }

        .review-content h5 {
            color: #e63946;
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .review-content p {
            color: #555;
            line-height: 1.6;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 20px;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .stats-overview {
                flex-direction: column;
                gap: 1rem;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
            }

            .review-header {
                flex-direction: column;
                gap: 1rem;
            }

            .rating-display {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="page-header">
    <a href="index.jsp" class="back-btn"> Back</a>
    <h1>Customer <span>Reviews</span></h1>
    <p>See what our customers say about their apartment experiences</p>
</header>

<!-- Main Content -->
<div class="reviews-page">
    <div class="reviews-container">
        <!-- Overall Statistics -->
        <div class="stats-overview">
            <div class="stat-card">
                <div class="rating-display">
                    <div class="rating-score"><%= String.format("%.1f", averageRating) %></div>
                    <div class="rating-stars">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <% if (i <= Math.round(averageRating)) { %>
                                <i class="fa-solid fa-star"></i>
                            <% } else { %>
                                <i class="fa-regular fa-star"></i>
                            <% } %>
                        <% } %>
                    </div>
                </div>
                <div class="stat-label">Average Rating</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-number"><%= totalReviews %></div>
                <div class="stat-label">Total Reviews</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-number">
                    <% if (totalReviews > 0) { %>
                        <%= Math.round((double) totalReviews / 5 * 100) %>%
                    <% } else { %>
                        0%
                    <% } %>
                </div>
                <div class="stat-label">Satisfaction Rate</div>
            </div>
        </div>

        <% if (reviews.isEmpty()) { %>
            <div class="no-reviews">
                <i class="fa-solid fa-comment-dots"></i>
                <h3>No Reviews Yet</h3>
                <p>Be the first to share your experience with our apartment management system!</p>
                <a href="ReviewServlet" class="write-review-btn">Write First Review</a>
            </div>
        <% } else { %>
            <% 
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
            %>
            <div class="reviews-grid">
                <% for (Review review : reviews) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    <i class="fa-solid fa-user"></i>
                                </div>
                                <div class="reviewer-details">
                                    <h4><%= review.getBuyerName() %></h4>
                                    <span class="review-date"><%= review.getCreatedAt().format(dateFormatter) %></span>
                                </div>
                            </div>
                            <div class="review-rating">
                                <% for (int j = 1; j <= 5; j++) { %>
                                    <% if (j <= review.getRating()) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } else { %>
                                        <i class="fa-regular fa-star"></i>
                                    <% } %>
                                <% } %>
                            </div>
                        </div>
                        <div class="review-content">
                            <h5><%= review.getTitle() %></h5>
                            <p><%= review.getReviewText() %></p>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</div>

    <!-- Footer Section -->
    <footer class="footer">
        <div class="footer-container">
            <!-- About -->
            <div class="footer-col">
                <h3>Apartment <span>X</span></h3>
                <p>Your trusted platform to find, compare, and book the best apartments in town.</p>
            </div>

            <!-- Quick Links -->
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="apartments.jsp">Listings</a></li>
                    <li><a href="ReviewsServlet">Reviews</a></li>
                    <li><a href="contact.jsp">Contact</a></li>
                </ul>
            </div>

            <!-- Contact -->
            <div class="footer-col">
                <h4>Contact</h4>
                <p><i class="fa-solid fa-phone"></i> +94 77 123 4567</p>
                <p><i class="fa-solid fa-envelope"></i> support@apartmentx.com</p>
                <p><i class="fa-solid fa-location-dot"></i> Colombo, Sri Lanka</p>
            </div>

            <!-- Socials -->
            <div class="footer-col">
                <h4>Follow Us</h4>
                <div class="social-links">
                    <a href="#"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin"></i></a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <p>© 2025 Apartment X. All Rights Reserved.</p>
        </div>
    </footer>

    <script src="js/script.js"></script>
</body>
</html>
