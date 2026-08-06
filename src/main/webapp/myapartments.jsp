<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.ApartmentImage" %>
<%@ page import="com.project.service.ApartmentService" %>
<%@ page import="com.project.model.User" %>
<%@ page import="java.util.UUID" %>

<%
    // Check if user is logged in and is a seller
    Object userObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
    if (userObj == null || !"seller".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    User user = (User) userObj;
    String userId = user.getUserId(); // Uxxx
    // Resolve sellerId in servlet; here we assume MyApartmentsServlet forwards with 'apartments'
    List<Apartment> apartments = (List<Apartment>) request.getAttribute("apartments");
    if (apartments == null) {
        apartments = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Apartments - Seller Dashboard</title>
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
            line-height: 1.6;
        }

        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            padding: 12px 24px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            z-index: 10;
        }

        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            border-radius: 20px;
            padding: 40px;
            color: white;
            text-align: center;
            margin-bottom: 30px;
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
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-title i {
            font-size: 2rem;
        }

        .welcome-text {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.2rem;
            position: relative;
            z-index: 2;
        }

        /* Apartments Grid */
        .apartments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .apt-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
        }

        .apt-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .apt-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-bottom: 1px solid #e9ecef;
        }

        .card-content {
            padding: 25px;
        }

        .card-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
            line-height: 1.3;
        }

        .card-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #e63946;
            margin-bottom: 8px;
        }

        .card-location {
            color: #666;
            font-size: 1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .card-details {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px 0;
            border-top: 1px solid #ecf0f1;
            border-bottom: 1px solid #ecf0f1;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .detail-value {
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        .detail-label {
            font-size: 0.8rem;
            color: #7f8c8d;
            margin-top: 4px;
        }

        .button-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .card-btn {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .card-btn.edit {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }

        .card-btn.edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.3);
        }

        .card-btn.delete {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
        }

        .card-btn.delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.3);
        }

        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-available {
            background: #27ae60;
            color: white;
        }

        .status-sold {
            background: #e74c3c;
            color: white;
        }

        .status-reserved {
            background: #f39c12;
            color: white;
        }

        .status-maintenance {
            background: #95a5a6;
            color: white;
        }

        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .no-results h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #2c3e50;
        }

        .no-results p {
            margin-bottom: 25px;
            font-size: 1.1rem;
        }

        .add-first-btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .add-first-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        /* Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            font-weight: 500;
            text-align: center;
        }

        .alert-success {
            background: #d5f4e6;
            color: #27ae60;
            border: 1px solid #a3e4d7;
        }

        .alert-error {
            background: #fadbd8;
            color: #c0392b;
            border: 1px solid #f5b7b1;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }

            .apartments-grid {
                grid-template-columns: 1fr;
            }

            .page-title {
                font-size: 2rem;
            }

            .button-group {
                flex-direction: column;
            }

            .card-btn {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 15px;
            }

            .page-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<div class="main-content">
    <a href="sellerdashboard.jsp" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

    <div class="page-header">
        <h1 class="page-title">
            <i class="fa-solid fa-building"></i> My Listed Apartments
        </h1>
        <p class="welcome-text">Welcome, <%= user.getFirstName() %> <%= user.getLastName() %>!</p>
    </div>

    <!-- Success/Error Messages -->
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        String urlMessage = request.getParameter("message");
    %>
    <% if (successMessage != null) { %>
    <div class="alert alert-success" id="successMessage">
        ✅ <%= successMessage %>
    </div>
    <% } %>
    <% if (errorMessage != null) { %>
    <div class="alert alert-error" id="errorMessage">
        ❌ <%= errorMessage %>
    </div>
    <% } %>
    <% if (urlMessage != null) { %>
    <div class="alert alert-success" id="urlMessage">
        ✅ <%= urlMessage %>
    </div>
    <% } %>

    <!-- Apartments Grid -->
    <div class="apartments-grid">
        <% if (apartments != null && !apartments.isEmpty()) { %>
        <%
            ApartmentService serviceInstance = new ApartmentService();
            for (Apartment apartment : apartments) {
                List<ApartmentImage> apartmentImages = serviceInstance.getApartmentImages(apartment.getApartmentId());
                String primaryImageUrl = null;
                if (apartmentImages != null && !apartmentImages.isEmpty()) {
                    primaryImageUrl = apartmentImages.get(0).getImageUrl();
                    if (primaryImageUrl != null && primaryImageUrl.startsWith("/")) {
                        primaryImageUrl = request.getContextPath() + primaryImageUrl;
                    }
                }
        %>
        <div class="apt-card">
            <!-- Status Badge -->
            <% String status = apartment.getStatus() != null ? apartment.getStatus() : "Available"; %>
            <span class="status-badge <%= getStatusClass(status) %>"><%= status.toUpperCase() %></span>

            <!-- Apartment Image -->
            <img src="<%= primaryImageUrl != null ? primaryImageUrl : "https://via.placeholder.com/400x250/cccccc/666666?text=No+Image+Available" %>"
                 alt="<%= apartment.getTitle() %>"
                 class="card-image"
                 onerror="this.src='https://via.placeholder.com/400x250/cccccc/666666?text=Image+Not+Found'">

            <div class="card-content">
                <!-- Single Title Display -->
                <h3 class="card-title"><%= apartment.getTitle() %></h3>

                <div class="card-price">Rs. <%= apartment.getPrice() != null ? apartment.getPrice() : 0 %></div>

                <div class="card-location">
                    <i class="fa-solid fa-location-dot"></i> <%= apartment.getCity() %>
                </div>

                <div class="card-details">
                    <div class="detail-item">
                        <span class="detail-value"><%= apartment.getBedrooms() %></span>
                        <span class="detail-label">Beds</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-value"><%= apartment.getBathrooms() %></span>
                        <span class="detail-label">Baths</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-value"><%= apartment.getAreaSqFt() %></span>
                        <span class="detail-label">Sq Ft</span>
                    </div>
                </div>

                <div class="button-group">
                    <a href="EditApartmentServlet?id=<%= apartment.getApartmentId() %>" class="card-btn edit">
                        <i class="fa-solid fa-edit"></i> Edit
                    </a>
                    <button class="card-btn delete"
                            onclick="confirmDelete('<%= apartment.getApartmentId() %>', '<%= apartment.getTitle().replace("'", "\\'") %>')">
                        <i class="fa-solid fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="no-results">
            <h3>No Apartments Listed Yet</h3>
            <p>Start by adding your first apartment to showcase it to potential buyers.</p>
            <a href="addapartment.jsp" class="add-first-btn">
                <i class="fa-solid fa-plus"></i> Add Your First Apartment
            </a>
        </div>
        <% } %>
    </div>
</div>

<script>
    // Confirm deletion
    function confirmDelete(apartmentId, apartmentTitle) {
        if (confirm('Are you sure you want to delete "' + apartmentTitle + '"? This action cannot be undone.')) {
            // Create a form and submit it
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'DeleteApartmentServlet';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'apartmentId';
            input.value = apartmentId;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Auto-hide messages after 5 seconds
    setTimeout(function() {
        const successMsg = document.getElementById('successMessage');
        const errorMsg = document.getElementById('errorMessage');
        const urlMsg = document.getElementById('urlMessage');

        if (successMsg) successMsg.style.display = 'none';
        if (errorMsg) errorMsg.style.display = 'none';
        if (urlMsg) urlMsg.style.display = 'none';
    }, 5000);
</script>
</body>
</html>

<%!
    // Helper method to get CSS class for status badge
    private String getStatusClass(String status) {
        if (status == null) return "status-available";

        switch (status.toLowerCase()) {
            case "available":
                return "status-available";
            case "sold":
                return "status-sold";
            case "reserved":
                return "status-reserved";
            case "under maintenance":
                return "status-maintenance";
            default:
                return "status-available";
        }
    }
%>