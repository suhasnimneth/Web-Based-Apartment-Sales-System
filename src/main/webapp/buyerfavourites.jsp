<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.Favourite" %>
<%@ page import="java.util.List" %>

<%
    List<Apartment> favouriteApartments = (List<Apartment>) request.getAttribute("favouriteApartments");
    List<Favourite> favourites = (List<Favourite>) request.getAttribute("favourites");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favourites - Apartment Portal</title>
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

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #fecaca;
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

        .apartments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .apartment-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
        }

        .apartment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .apartment-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 0;
        }

        .card-content {
            padding: 20px;
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .card-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #dc2626;
            margin-bottom: 10px;
        }

        .card-location {
            color: #6b7280;
            font-size: 0.95rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .detail-item {
            text-align: center;
            padding: 8px;
            background: #f9fafb;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        .detail-icon {
            font-size: 1.2rem;
            margin-bottom: 4px;
        }

        .detail-value {
            font-size: 0.9rem;
            font-weight: 600;
            color: #374151;
        }

        .detail-label {
            font-size: 0.75rem;
            color: #6b7280;
        }

        .card-actions {
            display: flex;
            gap: 10px;
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

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
        }

        .btn-icon {
            font-size: 1rem;
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
            .apartments-grid {
                grid-template-columns: 1fr;
            }

            .card-details {
                grid-template-columns: repeat(2, 1fr);
            }

            .card-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<div class="main-content">
    <a href="buyerdashboard.jsp" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back
    </a>
    <div class="container">
        <div class="page-header">
            <h1 class="page-title"><i class="fa-solid fa-heart"></i> My Favourites</h1>
            <p class="page-subtitle">Your saved apartment listings</p>
        </div>

        <div class="content-section">

            <% if (error != null) { %>
            <div class="error-message">
                <%= error %>
            </div>
            <% } %>

            <% if (favouriteApartments == null || favouriteApartments.isEmpty()) { %>
            <div class="empty-state">
                <h2>No Favourites Yet</h2>
                <p>You haven't added any apartments to your favourites yet.</p>
                <a href="AllApartmentsServlet">
                    <i class="fa-solid fa-building"></i>
                    Browse Apartments
                </a>
            </div>
            <% } else { %>
            <div class="apartments-grid">
                <% for (int i = 0; i < favouriteApartments.size(); i++) {
                    Apartment apartment = favouriteApartments.get(i);
                    Favourite favourite = favourites.get(i);
                %>
                <div class="apartment-card">
                    <% String primaryImage = apartment.getPrimaryImage(); %>
                    <% if (primaryImage != null && !primaryImage.trim().isEmpty()) { %>
                    <img src="image?file=<%= primaryImage.replace("/resources/images/", "") %>"
                         alt="<%= apartment.getTitle() %>"
                         class="card-image"
                         onerror="this.src='https://via.placeholder.com/400x200/f3f4f6/9ca3af?text=Image+Not+Found'">
                    <% } else { %>
                    <img src="https://via.placeholder.com/400x200/f3f4f6/9ca3af?text=No+Image+Available"
                         alt="<%= apartment.getTitle() %>"
                         class="card-image">
                    <% } %>

                    <div class="card-content">
                        <h3 class="card-title"><%= apartment.getTitle() %></h3>
                        <div class="card-price">Rs. <%= apartment.getPrice() != null ? apartment.getPrice() : 0 %></div>
                        <div class="card-location">
                            <i class="fa-solid fa-location-dot"></i> <%= apartment.getAddress() %>, <%= apartment.getCity() %>
                        </div>

                        <div class="card-details">
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
                                <div class="detail-label">Sq Ft</div>
                            </div>
                        </div>

                        <div class="card-actions">
                            <a href="ViewApartmentServlet?id=<%= apartment.getApartmentId() %>" class="btn btn-primary">
                                <i class="fa-solid fa-eye"></i>
                                View Details
                            </a>
                            <button onclick="removeFromFavourites('<%= apartment.getApartmentId() %>', this)" class="btn btn-danger">
                                <i class="fa-solid fa-heart-broken"></i>
                                Remove
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</div>
</div>

<script>
    function removeFromFavourites(apartmentId, button) {
        if (!confirm('Are you sure you want to remove this apartment from your favourites?')) {
            return;
        }

        fetch('FavouriteServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=remove&apartmentId=' + apartmentId
        })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    showMessage('Removed from favourites!', 'success');
                    // Remove the card from the page
                    button.closest('.apartment-card').style.opacity = '0.5';
                    setTimeout(() => {
                        button.closest('.apartment-card').remove();
                        // Check if no more cards, show empty state
                        if (document.querySelectorAll('.apartment-card').length === 0) {
                            location.reload();
                        }
                    }, 500);
                } else {
                    showMessage('Failed to remove from favourites', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error removing from favourites', 'error');
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

        // Insert at top of container
        const container = document.querySelector('.container');
        container.insertBefore(alert, container.firstChild);

        // Auto-hide after 5 seconds
        setTimeout(() => {
            alert.remove();
        }, 5000);
    }
</script>

</body>
</html>
