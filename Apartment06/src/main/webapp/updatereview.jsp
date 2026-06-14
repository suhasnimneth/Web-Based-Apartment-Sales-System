<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Review" %>
<%@ page import="com.project.DAO.ReviewDAO" %>

<%
    String reviewId = request.getParameter("reviewId");
    Review review = null;
    
    if (reviewId != null && !reviewId.trim().isEmpty()) {
        ReviewDAO reviewDAO = new ReviewDAO();
        review = reviewDAO.getReviewById(reviewId);
    }
    
    if (review == null) {
        response.sendRedirect("addreview.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Review - Apartment Management System</title>
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
            padding: 20px;
        }

        .main-content {
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .back-btn {
            display: inline-block;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2.5rem;
            margin: 0 0 10px 0;
            font-weight: 700;
        }

        .page-header p {
            font-size: 1.2rem;
            margin: 0;
            opacity: 0.9;
        }

        .content {
            padding: 40px;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .nav-link {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
        }

        .review-form {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #6c757d;
            box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .rating-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .star-rating {
            display: flex;
            gap: 5px;
        }

        .star {
            font-size: 2rem;
            color: #e9ecef;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .star:hover,
        .star.active {
            color: #ffc107;
            transform: scale(1.1);
        }

        .rating-text {
            font-size: 1.1rem;
            font-weight: 600;
            color: #6c757d;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary {
            background: #e9ecef;
            color: #495057;
        }

        .btn-secondary:hover {
            background: #dee2e6;
            transform: translateY(-2px);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .review-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #6c757d;
        }

        .review-info h3 {
            color: #333;
            margin-bottom: 10px;
        }

        .review-info p {
            color: #666;
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
            }
            
            .content {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .nav-links {
                flex-direction: column;
            }
            
            .rating-group {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="container">
            <a href="buyerdashboard.jsp" class="back-btn"> Back to Dashboard</a>
            
            <div class="page-header">
                <h1>✏️ Update Review</h1>
                <p>Modify your review and rating</p>
            </div>

            <div class="content">


            <div class="review-info">
                <h3>📝 Update Your Review</h3>
                <p>• You can modify your rating, title, and review text</p>
                <p>• Changes will be reflected immediately</p>
                <p>• Your updated review will be visible to all users</p>
            </div>

            <div class="review-form">
                <form id="reviewForm" onsubmit="submitReview(event)">
                    <input type="hidden" id="reviewId" name="reviewId" value="<%= review.getReviewId() %>">
                    
                    <div class="form-group">
                        <label for="rating">Overall Rating:</label>
                        <div class="rating-group">
                            <div class="star-rating">
                                <span class="star" data-rating="1" onclick="setRating(1)">☆</span>
                                <span class="star" data-rating="2" onclick="setRating(2)">☆</span>
                                <span class="star" data-rating="3" onclick="setRating(3)">☆</span>
                                <span class="star" data-rating="4" onclick="setRating(4)">☆</span>
                                <span class="star" data-rating="5" onclick="setRating(5)">☆</span>
                            </div>
                            <span class="rating-text" id="ratingText">Select a rating</span>
                        </div>
                        <input type="hidden" id="rating" name="rating" required>
                    </div>

                    <div class="form-group">
                        <label for="title">Review Title:</label>
                        <input type="text" id="title" name="title" required 
                               value="<%= review.getTitle() %>" maxlength="200">
                    </div>

                    <div class="form-group">
                        <label for="reviewText">Your Review:</label>
                        <textarea id="reviewText" name="reviewText" required 
                                  maxlength="1000"><%= review.getReviewText() %></textarea>
                        <small style="color: #666; font-size: 0.9rem;">
                            <span id="charCount">0</span>/1000 characters
                        </small>
                    </div>

                    <div class="form-actions">
                        <a href="buyerreviewmanagement.jsp" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Update Review</button>
                    </div>
                </form>
            </div>
        </div>
        </div>
    </div>
</div>

    <script>
        let selectedRating = <%= review.getRating() %>;

        // Initialize the form with existing data
        document.addEventListener('DOMContentLoaded', function() {
            setRating(selectedRating);
            updateCharCount();
        });

        function setRating(rating) {
            selectedRating = rating;
            document.getElementById('rating').value = rating;
            
            // Update star display
            const stars = document.querySelectorAll('.star');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.textContent = '★';
                    star.classList.add('active');
                } else {
                    star.textContent = '☆';
                    star.classList.remove('active');
                }
            });
            
            // Update rating text
            const ratingTexts = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
            document.getElementById('ratingText').textContent = ratingTexts[rating] + ' (' + rating + ' star' + (rating > 1 ? 's' : '') + ')';
        }

        function submitReview(event) {
            event.preventDefault();
            
            // Get form values directly
            const reviewId = document.getElementById('reviewId').value;
            const rating = document.getElementById('rating').value;
            const title = document.getElementById('title').value;
            const reviewText = document.getElementById('reviewText').value;
            
            // Create URLSearchParams for form data
            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('reviewId', reviewId);
            formData.append('rating', rating);
            formData.append('title', title);
            formData.append('reviewText', reviewText);
            
            // Validate required fields
            if (!reviewId || !rating || !title || !reviewText) {
                showMessage('Please fill in all required fields', 'error');
                return;
            }
            
            if (selectedRating < 1 || selectedRating > 5) {
                showMessage('Please select a rating', 'error');
                return;
            }
            
            console.log('Updating review:', {
                action: 'update',
                reviewId: reviewId,
                rating: rating,
                title: title,
                reviewText: reviewText
            });
            
            fetch('ReviewServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                console.log('Review response:', data);
                if (data === 'success') {
                    showMessage('Review updated successfully! Thank you for your feedback.', 'success');
                    setTimeout(() => {
                        window.location.href = 'buyerdashboard.jsp';
                    }, 2000);
                } else if (data === 'unauthorized') {
                    showMessage('You must be logged in as a buyer to update reviews.', 'error');
                } else if (data.startsWith('error:')) {
                    showMessage('Failed to update review. Error: ' + data.substring(6), 'error');
                } else {
                    showMessage('Failed to update review. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error updating review. Please try again.', 'error');
            });
        }

        function showMessage(message, type) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert');
            existingAlerts.forEach(alert => alert.remove());
            
            // Create new alert
            const alert = document.createElement('div');
            alert.className = 'alert alert-' + type;
            alert.textContent = message;
            
            // Insert at top of content
            const content = document.querySelector('.content');
            content.insertBefore(alert, content.firstChild);
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                alert.remove();
            }, 5000);
        }

        function updateCharCount() {
            const textarea = document.getElementById('reviewText');
            const charCount = textarea.value.length;
            document.getElementById('charCount').textContent = charCount;
        }

        // Character counter for review text
        document.getElementById('reviewText').addEventListener('input', function() {
            const charCount = this.value.length;
            document.getElementById('charCount').textContent = charCount;
            
            if (charCount > 1000) {
                this.value = this.value.substring(0, 1000);
                document.getElementById('charCount').textContent = 1000;
            }
        });
    </script>
</body>
</html>
