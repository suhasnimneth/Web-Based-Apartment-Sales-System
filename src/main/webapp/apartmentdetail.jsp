<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.ApartmentImage" %>
<%@ page import="java.util.List" %>

<%
    Apartment apartment = (Apartment) request.getAttribute("apartment");
    if (apartment == null) {
        response.sendRedirect("apartments.jsp");
        return;
    }
    
    List<ApartmentImage> images = apartment.getImages();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= apartment.getTitle() %> - Apartment Details</title>
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

        .apartment-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .apartment-header::before {
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

        .apartment-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
        }

        .price-section {
            background: white;
            padding: 30px;
            text-align: center;
            border-bottom: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
        }

        .apartment-price {
            font-size: 3rem;
            font-weight: 700;
            color: #e63946;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .price-icon {
            font-size: 2.5rem;
            color: #f77f00;
        }

        .address-section {
            background: #f8f9fa;
            padding: 25px 30px;
            border-bottom: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
        }

        .apartment-address {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin: 0;
        }

        .address-icon {
            color: #e63946;
            font-size: 1.2rem;
        }

        .apartment-location {
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
            z-index: 2;
        }

        .apartment-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            padding: 30px;
            align-items: start;
        }

        .main-content {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .image-gallery {
            background: #f9fafb;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }

        .main-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 5px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .thumbnail-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            justify-content: flex-start;
        }

        .thumbnail {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .thumbnail:hover {
            border-color: #dc2626;
            transform: scale(1.05);
        }

        .thumbnail.active {
            border-color: #dc2626;
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.2);
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(230, 57, 70, 0.1);
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }

        .section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: #e63946;
        }

        .description {
            color: #4b5563;
            font-size: 1rem;
            line-height: 1.7;
        }

        .amenities-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .amenity-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f9fafb;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        .amenity-icon {
            font-size: 1.5rem;
        }

        .amenity-name {
            font-weight: 500;
            color: #374151;
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
            position: sticky;
            top: 20px;
        }

        .details-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(230, 57, 70, 0.1);
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }

        .details-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .detail-item {
            text-align: center;
            padding: 15px;
            background: #f9fafb;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        .detail-icon {
            font-size: 2rem;
            margin-bottom: 8px;
        }

        .detail-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #dc2626;
            margin-bottom: 5px;
        }

        .detail-label {
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .contact-section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(230, 57, 70, 0.1);
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }

        .contact-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .contact-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 15px;
        }

        .contact-details {
            margin-bottom: 20px;
        }

        .contact-details p {
            margin-bottom: 8px;
            color: #4b5563;
        }

        .contact-btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .contact-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .action-btn {
            padding: 15px 20px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            justify-content: center;
            background: white;
            color: #374151;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .favourite-btn:hover {
            background: #ffebee;
            color: #e63946;
            border: 2px solid #e63946;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.2);
        }

        .favourite-btn.active {
            background: #e63946;
            color: white;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .booking-btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .booking-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .payment-btn {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        .payment-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.4);
        }

        .btn-icon {
            font-size: 1.1rem;
        }

        .btn-text {
            font-weight: 500;
        }

        .alert {
            padding: 12px 16px;
            margin: 15px 0;
            border-radius: 6px;
            font-weight: 500;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        @media (max-width: 768px) {
            .apartment-content {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px;
            }
            
            .apartment-title {
                font-size: 2rem;
            }
            
            .apartment-price {
                font-size: 1.5rem;
            }
            
            .details-grid {
                grid-template-columns: 1fr;
            }
            
            .amenities-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="main-content">
    <a href="javascript:history.back()" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back
    </a>
    <div class="container">

    <div class="apartment-header">
        <h1 class="apartment-title"><%= apartment.getTitle() %></h1>
    </div>

    <!-- Price Section -->
    <div class="price-section">
        <div class="apartment-price">
            Rs. <%= apartment.getPrice() != null ? apartment.getPrice() : 0 %>
        </div>
    </div>

    <!-- Address Section -->
    <div class="address-section">
        <div class="apartment-address">
            <i class="fa-solid fa-location-dot address-icon"></i>
            <%= apartment.getAddress() %>, <%= apartment.getCity() %>
        </div>
    </div>

    <div class="apartment-content">
        <div class="main-content">
            <!-- Image Gallery -->
            <div class="image-gallery">
                <% if (images != null && !images.isEmpty()) { %>
                <img id="mainImage" src="image?file=<%= images.get(0).getImageUrl().replace("/resources/images/", "") %>" alt="<%= apartment.getTitle() %>" class="main-image">
                <div class="thumbnail-grid">
                    <% for (int i = 0; i < images.size(); i++) { %>
                    <img src="image?file=<%= images.get(i).getImageUrl().replace("/resources/images/", "") %>" 
                         alt="<%= apartment.getTitle() %>" 
                         class="thumbnail <%= i == 0 ? "active" : "" %>"
                         onclick="changeMainImage('image?file=<%= images.get(i).getImageUrl().replace("/resources/images/", "") %>', this)">
                    <% } %>
                </div>
                <% } else { %>
                <img src="https://via.placeholder.com/800x400/f3f4f6/9ca3af?text=No+Images+Available" 
                     alt="<%= apartment.getTitle() %>" 
                     class="main-image">
                <% } %>
            </div>

            <!-- Description -->
            <div class="section">
                <h2 class="section-title"><i class="fa-solid fa-file-text"></i> Description</h2>
                <div class="description">
                    <%= apartment.getDescription() != null ? apartment.getDescription() : "No description available." %>
                </div>
            </div>

            <!-- Amenities -->
            <div class="section">
                <h2 class="section-title"><i class="fa-solid fa-home"></i> Property Features</h2>
                <div class="amenities-grid">
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-bed"></i></div>
                        <div class="amenity-name"><%= apartment.getBedrooms() != null ? apartment.getBedrooms() : "N/A" %> Bedrooms</div>
                    </div>
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-bath"></i></div>
                        <div class="amenity-name"><%= apartment.getBathrooms() != null ? apartment.getBathrooms() : "N/A" %> Bathrooms</div>
                    </div>
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-ruler-combined"></i></div>
                        <div class="amenity-name"><%= apartment.getAreaSqFt() != null ? apartment.getAreaSqFt() : "N/A" %> Sq Ft</div>
                    </div>
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-building"></i></div>
                        <div class="amenity-name">Apartment</div>
                    </div>
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-map-marker-alt"></i></div>
                        <div class="amenity-name"><%= apartment.getCity() %></div>
                    </div>
                    <div class="amenity-item">
                        <div class="amenity-icon"><i class="fa-solid fa-dollar-sign"></i></div>
                        <div class="amenity-name">Rs. <%= apartment.getPrice() != null ? apartment.getPrice() : 0 %></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="sidebar">
            <!-- Property Details -->
            <div class="details-card">
                <h2 class="section-title"><i class="fa-solid fa-info-circle"></i> Property Details</h2>
                <div class="details-grid">
                    <div class="detail-item">
                        <div class="detail-icon"><i class="fa-solid fa-bed"></i></div>
                        <div class="detail-value"><%= apartment.getBedrooms() != null ? apartment.getBedrooms() : "N/A" %></div>
                        <div class="detail-label">Bedrooms</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon"><i class="fa-solid fa-bath"></i></div>
                        <div class="detail-value"><%= apartment.getBathrooms() != null ? apartment.getBathrooms() : "N/A" %></div>
                        <div class="detail-label">Bathrooms</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon"><i class="fa-solid fa-ruler-combined"></i></div>
                        <div class="detail-value"><%= apartment.getAreaSqFt() != null ? apartment.getAreaSqFt() : "N/A" %></div>
                        <div class="detail-label">Area (Sq Ft)</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon"><i class="fa-solid fa-building"></i></div>
                        <div class="detail-value">Apartment</div>
                        <div class="detail-label">Property Type</div>
                    </div>
                </div>
            </div>

            <!-- Contact Section -->
            <div class="contact-section">
                <h2 class="contact-title"><i class="fa-solid fa-phone"></i> Contact Information</h2>
                <div class="contact-details">
                    <p><strong>Contact Number:</strong> <%= request.getAttribute("sellerContact") != null ? request.getAttribute("sellerContact") : "N/A" %></p>
                    <p><strong>Email:</strong> <%= request.getAttribute("sellerEmail") != null ? request.getAttribute("sellerEmail") : "N/A" %></p>
                </div>
                <a href="mailto:<%= request.getAttribute("sellerEmail") != null ? request.getAttribute("sellerEmail") : "seller@example.com" %>?subject=Inquiry about <%= apartment.getTitle() %>" class="contact-btn">
                    <i class="fa-solid fa-envelope"></i>
                    Contact Seller
                </a>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <% boolean isSold = apartment.getStatus() != null && apartment.getStatus().equalsIgnoreCase("Sold"); %>
                <button class="action-btn favourite-btn" onclick="<%= isSold ? "showMessage('This apartment is sold. Action not allowed.','error')" : ("toggleFavourite('" + apartment.getApartmentId() + "')") %>" <%= isSold ? "disabled" : "" %>>
                    <i class="fa-solid fa-heart"></i>
                    <span class="btn-text"><%= isSold ? "Unavailable" : "Add to Favourites" %></span>
                </button>
                <a href="<%= isSold ? "#" : ("BookingFormServlet?apartmentId=" + apartment.getApartmentId()) %>" class="action-btn booking-btn" <%= isSold ? "onclick=\"showMessage('This apartment is sold. Booking not allowed.','error');return false;\"" : "" %>>
                    <i class="fa-solid fa-calendar-check"></i>
                    <span class="btn-text"><%= isSold ? "Sold - Booking Closed" : "Book Viewing" %></span>
                </a>
                <a href="<%= isSold ? "#" : ("PaymentServlet?apartmentId=" + apartment.getApartmentId()) %>" class="action-btn payment-btn" <%= isSold ? "onclick=\"showMessage('This apartment is sold. Payment not allowed.','error');return false;\"" : "" %>>
                    <i class="fa-solid fa-credit-card"></i>
                    <span class="btn-text"><%= isSold ? "Sold - Payment Closed" : "Make Payment" %></span>
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    // Check favorite status on page load
    window.addEventListener('load', function() {
        checkFavoriteStatus('<%= apartment.getApartmentId() %>');
    });

    function checkFavoriteStatus(apartmentId) {
        fetch('FavouriteServlet?action=check&apartmentId=' + apartmentId)
        .then(response => response.text())
        .then(data => {
            if (data === 'true') {
                const btn = document.querySelector('.favourite-btn');
                if (btn) {
                    btn.classList.add('active');
                    btn.querySelector('.btn-text').textContent = 'Remove from Favourites';
                }
            }
        })
        .catch(error => {
            console.error('Error checking favorite status:', error);
        });
    }

    // Toggle favourite functionality
    function toggleFavourite(apartmentId) {
        const btn = document.querySelector('.favourite-btn');
        const isFavourite = btn.classList.contains('active');
        const action = isFavourite ? 'remove' : 'add';

        fetch('FavouriteServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=' + action + '&apartmentId=' + apartmentId
        })
        .then(response => response.text())
        .then(data => {
            if (data === 'success') {
                if (isFavourite) {
                    btn.classList.remove('active');
                    btn.querySelector('.btn-text').textContent = 'Add to Favourites';
                    showMessage('Removed from favourites!', 'success');
                } else {
                    btn.classList.add('active');
                    btn.querySelector('.btn-text').textContent = 'Remove from Favourites';
                    showMessage('Added to favourites!', 'success');
                }
            } else {
                showMessage('Failed to update favourites', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Error updating favourites', 'error');
        });
    }

    // Change main image
    function changeMainImage(imageSrc, thumbnail) {
        document.getElementById('mainImage').src = imageSrc;
        
        // Update active thumbnail
        document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
        thumbnail.classList.add('active');
    }

    function showMessage(message, type) {
        // Remove existing alerts
        const existingAlerts = document.querySelectorAll('.alert');
        existingAlerts.forEach(alert => alert.remove());
        
        // Create new alert
        const alert = document.createElement('div');
        alert.className = 'alert alert-' + type;
        alert.textContent = message;
        
        // Insert at top of container
        const container = document.querySelector('.container');
        container.insertBefore(alert, container.firstChild);
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            alert.remove();
        }, 5000);
    }
</script>
</div>
</body>
</html>