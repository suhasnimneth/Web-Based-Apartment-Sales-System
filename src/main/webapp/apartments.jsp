<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.ApartmentImage" %>

<%
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
    <title>All Apartments - Apartment Portal</title>
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

        .search-section {
            background: white;
            padding: 40px;
            border-bottom: 1px solid rgba(230, 57, 70, 0.1);
        }

        .search-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 25px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 1rem;
        }

        .form-group input,
        .form-group select {
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #e63946;
            background: white;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }

        .search-btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
            width: 100%;
            min-width: 120px;
            font-size: 1rem;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .clear-btn {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
            width: 100%;
            min-width: 120px;
            font-size: 1rem;
        }

        .clear-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.4);
        }

        .results-section {
            padding: 30px;
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .results-count {
            color: #6b7280;
            font-size: 1rem;
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

        .status-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            z-index: 5;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 700;
            color: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .status-available { background: #10b981; }
        .status-reserved { background: #f59e0b; }
        .status-maintenance { background: #6b7280; }
        .status-sold { background: #ef4444; }

        .apartment-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
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

        .card-actions .btn {
            flex: 1;
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

        .btn-icon {
            font-size: 1rem;
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
            background: #dc2626;
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .empty-state a:hover {
            background: #b91c1c;
        }

        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }

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
            <h1 class="page-title"><i class="fa-solid fa-building"></i> Available Apartments</h1>
            <p class="page-subtitle">Discover your perfect home from our curated collection</p>
        </div>

        <!-- Search Filters -->
        <div class="search-section">
            <form method="GET" action="AllApartmentsServlet" class="search-form">
                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" placeholder="Enter city" value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>">
                </div>

                <div class="form-group">
                    <label for="priceRange">Price Range</label>
                    <select id="priceRange" name="priceRange">
                        <option value="">Any Price</option>
                        <option value="0-100000" <%= "0-100000".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Rs. 0 - 100,000</option>
                        <option value="100000-200000" <%= "100000-200000".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Rs. 100,000 - 200,000</option>
                        <option value="200000+" <%= "200000+".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Rs. 200,000+</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="" <%= request.getParameter("status") == null || request.getParameter("status").isEmpty() ? "selected" : "" %>>Any Status</option>
                        <option value="Available" <%= "Available".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Available</option>
                        <option value="Reserved" <%= "Reserved".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Reserved</option>
                        <option value="Under Maintenance" <%= "Under Maintenance".equalsIgnoreCase(request.getParameter("status")) || "Maintenance".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Under Maintenance</option>
                        <option value="Sold" <%= "Sold".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Sold</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="bedrooms">Bedrooms</label>
                    <select id="bedrooms" name="bedrooms">
                        <option value="">Any</option>
                        <option value="1" <%= "1".equals(request.getParameter("bedrooms")) ? "selected" : "" %>>1</option>
                        <option value="2" <%= "2".equals(request.getParameter("bedrooms")) ? "selected" : "" %>>2</option>
                        <option value="3" <%= "3".equals(request.getParameter("bedrooms")) ? "selected" : "" %>>3</option>
                        <option value="4" <%= "4".equals(request.getParameter("bedrooms")) ? "selected" : "" %>>4+</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="bathrooms">Bathrooms</label>
                    <select id="bathrooms" name="bathrooms">
                        <option value="">Any</option>
                        <option value="1" <%= "1".equals(request.getParameter("bathrooms")) ? "selected" : "" %>>1</option>
                        <option value="2" <%= "2".equals(request.getParameter("bathrooms")) ? "selected" : "" %>>2</option>
                        <option value="3" <%= "3".equals(request.getParameter("bathrooms")) ? "selected" : "" %>>3</option>
                        <option value="4" <%= "4".equals(request.getParameter("bathrooms")) ? "selected" : "" %>>4</option>
                    </select>
                </div>

                <div class="form-group">
                    <button type="submit" class="search-btn">
                        <i class="fa-solid fa-search"></i>
                        Search
                    </button>
                </div>

                <div class="form-group">
                    <a href="AllApartmentsServlet" class="clear-btn">
                        <i class="fa-solid fa-trash"></i>
                        Clear
                    </a>
                </div>
            </form>
        </div>

        <!-- Results Section -->
        <div class="results-section">
            <div class="results-header">
                <div class="results-count">
                    Found <%= apartments.size() %> apartment<%= apartments.size() != 1 ? "s" : "" %>
                </div>
            </div>

            <% if (apartments.isEmpty()) { %>
            <div class="empty-state">
                <h2>No Apartments Found</h2>
                <p>Try adjusting your search criteria or browse all available apartments.</p>
                <a href="AllApartmentsServlet">View All Apartments</a>
            </div>
            <% } else { %>
            <div class="apartments-grid">
                <% for (Apartment apartment : apartments) { %>
                <div class="apartment-card">
                    <% String status = apartment.getStatus() != null ? apartment.getStatus() : "Available"; %>
                    <% String statusClass = "status-available"; %>
                    <% if ("Sold".equalsIgnoreCase(status)) { statusClass = "status-sold"; } else if ("Reserved".equalsIgnoreCase(status)) { statusClass = "status-reserved"; } else if ("Under Maintenance".equalsIgnoreCase(status) || "Maintenance".equalsIgnoreCase(status)) { statusClass = "status-maintenance"; } %>
                    <span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span>
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
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function showMessage(message, type) {
        // Remove existing alerts
        const existingAlerts = document.querySelectorAll('.alert');
        existingAlerts.forEach(alert => alert.remove());

        // Create new alert
        const alert = document.createElement('div');
        alert.className = 'alert alert-' + type;
        alert.textContent = message;
        alert.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 16px;
            border-radius: 6px;
            font-weight: 500;
            z-index: 1000;
            ${type == 'success' ? 'background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0;' : 'background: #fee2e2; color: #991b1b; border: 1px solid #fecaca;'}
        `;

        document.body.appendChild(alert);

        // Auto-hide after 3 seconds
        setTimeout(() => {
            alert.remove();
        }, 3000);
    }

    // Auto-load all apartments when page loads directly
    document.addEventListener('DOMContentLoaded', function() {
        const apartmentsGrid = document.querySelector('.apartments-grid');
        const emptyState = document.querySelector('.empty-state');

        // Check if we're on apartments.jsp directly (not from servlet)
        // If there are no apartments and no search parameters, load all apartments
        const urlParams = new URLSearchParams(window.location.search);
        const hasSearchParams = urlParams.has('city') ||
            urlParams.has('propertyType') || urlParams.has('bedrooms') ||
            urlParams.has('bathrooms') || urlParams.has('priceRange');

        if (!hasSearchParams && (apartmentsGrid === null || emptyState !== null)) {
            // Load all apartments by redirecting to AllApartmentsServlet
            window.location.href = 'AllApartmentsServlet';
        }
    });
</script>

</body>
</html>