<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Review - Apartment Management System</title>
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
        }

        .main-content {
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: transparent;
            border: 2px solid #e63946;
            color: #e63946;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(230, 57, 70, 0.3);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
        }

        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin: 0;
        }

        .content {
            padding: 40px;
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
        <a href="buyerdashboard.jsp" class="back-btn">Back</a>
        <div class="container">
            <div class="page-header">
                <h1><i class="fa-solid fa-star"></i> Add Review</h1>
                <p>Share your experience with our apartment management system</p>
            </div>

        <div class="content">

            <div class="review-info">
                <h3>📝 Review Guidelines</h3>
                <p>• Rate your overall experience with our website (1-5 stars)</p>
                <p>• Provide a clear title for your review</p>
                <p>• Share specific details about your experience</p>
                <p>• Be honest and constructive in your feedback</p>
                <p>• You can update your review anytime</p>
            </div>

            <div class="review-form">
                <form id="reviewForm" onsubmit="submitReview(event)">
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
                               placeholder="e.g., Great apartment hunting experience!" maxlength="200">
                    </div>

                    <div class="form-group">
                        <label for="reviewText">Your Review:</label>
                        <textarea id="reviewText" name="reviewText" required 
                                  placeholder="Please share your detailed experience with our apartment management system. This field is required." 
                                  maxlength="1000"></textarea>
                        <small style="color: #666; font-size: 0.9rem;">
                            <span id="charCount">0</span>/1000 characters
                        </small>
                    </div>

                    <div class="form-actions">
                        <a href="buyerdashboard.jsp" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Submit Review</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>

    <script>
        let selectedRating = 0;

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
            
            console.log('Form submission started');
            console.log('Selected rating:', selectedRating);
            
            // Get form values directly
            const rating = document.getElementById('rating').value;
            const title = document.getElementById('title').value;
            const reviewText = document.getElementById('reviewText').value;
            
            console.log('Form validation:');
            console.log('  rating:', rating);
            console.log('  title:', title);
            console.log('  reviewText:', reviewText);
            console.log('  selectedRating:', selectedRating);
            
            if (!rating || !title || !reviewText || reviewText.trim() === '') {
                showMessage('Please fill in all required fields including the review text', 'error');
                return;
            }
            
            if (selectedRating < 1 || selectedRating > 5) {
                showMessage('Please select a rating', 'error');
                return;
            }
            
            // Create URLSearchParams for form data
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('rating', rating);
            formData.append('title', title);
            formData.append('reviewText', reviewText);
            
            console.log('Submitting review:', {
                action: 'add',
                rating: rating,
                title: title,
                reviewText: reviewText
            });
            
            // Debug: Log all form data
            console.log('All form data:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
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
                    showMessage('Review submitted successfully! Thank you for your feedback.', 'success');
                    setTimeout(() => {
                        window.location.href = 'buyerdashboard.jsp';
                    }, 2000);
                } else if (data === 'unauthorized') {
                    showMessage('You must be logged in as a buyer to submit reviews.', 'error');
                } else if (data.startsWith('error:')) {
                    showMessage('Failed to submit review. Error: ' + data.substring(6), 'error');
                } else {
                    showMessage('Failed to submit review. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error submitting review. Please try again.', 'error');
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
