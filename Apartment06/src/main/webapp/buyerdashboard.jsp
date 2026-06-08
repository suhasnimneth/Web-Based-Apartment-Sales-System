<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Apartment" %>
<%
    // Make sure user is logged in - using correct session attribute names
    Object user = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole"); // Changed from "role" to "userRole"

    if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    com.project.model.User userModel = (com.project.model.User) user;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apartment X | Buyer Dashboard</title>
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
            color: #333;
        }

        .dashboard-container {
            display: grid;
            grid-template-columns: 280px 1fr;
            min-height: 100vh;
        }

        /* Modern Sidebar */
        .sidebar {
            background: linear-gradient(180deg, #ffffff 0%, #f8f9fa 100%);
            padding: 20px 20px 20px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-right: 1px solid rgba(230, 57, 70, 0.1);
            box-shadow: 4px 0 20px rgba(0,0,0,0.05);
            height: 100vh;
        }

        .logo {
            color: #333;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 0;
            text-align: center;
            padding: 15px 15px 5px 15px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo span {
            color: #e63946;
        }

        .sidebar-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .sidebar nav ul {
            list-style: none;
            padding: 0;
        }

        .sidebar nav ul li {
            margin: 2px 0;
            border-radius: 12px;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .sidebar nav ul li a {
            text-decoration: none;
            color: #666;
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-radius: 12px;
            transition: all 0.3s ease;
            font-weight: 500;
            position: relative;
        }

        .sidebar nav ul li a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }

        .sidebar nav ul li:hover a,
        .sidebar nav ul li.active a {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .logout-btn {
            padding: 15px 20px;
            border: 2px solid #e63946;
            border-radius: 12px;
            background: transparent;
            color: #e63946;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .logout-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 57, 70, 0.3);
        }

        /* Main Content */
        .main-content {
            padding: 30px;
            display: flex;
            flex-direction: column;
            gap: 30px;
            overflow-y: auto;
        }

        /* Modern Hero Banner */
        .hero-banner {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            border-radius: 20px;
            padding: 40px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .hero-banner::before {
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

        .hero-text {
            position: relative;
            z-index: 2;
        }

        .hero-text h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .hero-text p {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 400;
        }

        /* Modern Dashboard Cards */
        .grid-layout {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(230, 57, 70, 0.1);
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.5rem;
            color: white;
        }

        .card-icon.browse { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card-icon.favourites { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .card-icon.bookings { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .card-icon.payments { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }

        .card-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin: 0;
        }

        .card-content {
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .card-stats {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .stat-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .stat-item:last-child {
            border-bottom: none;
        }

        .stat-label {
            color: #666;
            font-weight: 500;
        }

        .stat-value {
            color: #333;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .stat-value.highlight {
            color: #e63946;
            font-size: 1.3rem;
        }

        .card-action-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            justify-content: center;
        }

        .card-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.3);
            color: white;
        }

        /* Apartment Preview Section */
        .apartment-preview {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
        }

        .apartment-preview h2 {
            margin-bottom: 25px;
            color: #333;
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .apartment-preview h2 i {
            color: #e63946;
        }

        .apartment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .apt-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            display: flex;
            flex-direction: column;
        }

        .apt-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .apt-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .apt-card-content {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .apt-card h4 {
            margin-bottom: 10px;
            color: #333;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .apt-card p {
            color: #666;
            font-weight: 500;
            margin: 0;
        }

        .apt-location {
            margin: 5px 0;
            color: #666;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .apt-price {
            margin: 10px 0;
            color: #e63946;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .apt-details {
            display: flex;
            gap: 15px;
            margin: 15px 0;
            flex-wrap: wrap;
        }

        .apt-details span {
            color: #666;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .apt-btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: auto;
        }

        .apt-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }


        /* Responsive Design */
        @media (max-width: 768px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                display: none;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .hero-text h1 {
                font-size: 2rem;
            }
            
            .grid-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #e63946;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
        <!-- Modern Sidebar -->
    <aside class="sidebar">
        <h2 class="logo">Apartment <span>X</span></h2>
        <div class="sidebar-content">
        <nav>
            <ul>
                    <li class="active"><a href="BuyerDashboardServlet"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
                    <li><a href="AllApartmentsServlet"><i class="fa-solid fa-building"></i>Apartments</a></li>
                    <li><a href="editprofile.jsp"><i class="fa-solid fa-user-edit"></i>Edit Profile</a></li>
                    <li><a href="BuyerFavouritesServlet"><i class="fa-solid fa-heart"></i>Favourites</a></li>
                    <li><a href="BuyerBookingsServlet"><i class="fa-solid fa-calendar-check"></i>Bookings</a></li>
                    <li><a href="BuyerPaymentsServlet"><i class="fa-solid fa-credit-card"></i>Payments</a></li>
                    <li><a href="BuyerReviewServlet"><i class="fa-solid fa-star"></i>My Review</a></li>
                    <li><a href="BuyerCardServlet"><i class="fa-solid fa-plus"></i>Add New Card</a></li>
                    <li><a href="deleteprofile.jsp"><i class="fa-solid fa-trash"></i>Delete Account</a></li>
            </ul>
        </nav>
            <a href="LogoutServlet" class="logout-btn">
                <i class="fa-solid fa-sign-out-alt"></i>Logout
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
            <!-- Modern Hero Banner -->
        <div class="hero-banner">
            <div class="hero-text">
                <h1>Welcome Back, <%= userModel.getFirstName() %> <%= userModel.getLastName() %>!</h1>
                <p>Manage your bookings, payments, and favourite apartments all in one place.</p>
            </div>
        </div>

            <!-- Modern Dashboard Cards -->
        <section id="content-area" class="grid-layout">
            <div class="card">
                    <div class="card-header">
                        <div class="card-icon browse">
                            <i class="fa-solid fa-building"></i>
                        </div>
                        <h3 class="card-title">Browse Apartments</h3>
                    </div>
                    <div class="card-content">
                        <p style="color: #666; margin-bottom: 15px;">Find your dream home</p>
                    </div>
                    <a href="AllApartmentsServlet" class="card-action-btn">
                        View All
                    </a>
            </div>

            <div class="card">
                    <div class="card-header">
                        <div class="card-icon favourites">
                            <i class="fa-solid fa-heart"></i>
                        </div>
                        <h3 class="card-title">Favourites</h3>
                    </div>
                    <div class="card-content">
                        <div class="card-stats">
                            <div class="stat-item">
                                <span class="stat-label">Apartments Saved</span>
                                <span class="stat-value" id="favourites-count">
                                    <%= request.getAttribute("totalFavourites") != null ? request.getAttribute("totalFavourites") : "0" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <a href="BuyerFavouritesServlet" class="card-action-btn">
                        View All
                    </a>
            </div>

            <div class="card">
                    <div class="card-header">
                        <div class="card-icon bookings">
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                        <h3 class="card-title">My Bookings</h3>
                    </div>
                    <div class="card-content">
                        <div class="card-stats">
                            <div class="stat-item">
                                <span class="stat-label">Total Bookings</span>
                                <span class="stat-value" id="total-bookings">
                                    <%= request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : "0" %>
                                </span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">Pending</span>
                                <span class="stat-value highlight" id="pending-bookings">
                                    <%= request.getAttribute("pendingBookings") != null ? request.getAttribute("pendingBookings") : "0" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <a href="BuyerBookingsServlet" class="card-action-btn">
                        View All
                    </a>
            </div>

            <div class="card">
                    <div class="card-header">
                        <div class="card-icon payments">
                            <i class="fa-solid fa-credit-card"></i>
                        </div>
                        <h3 class="card-title">Payments</h3>
                    </div>
                    <div class="card-content">
                        <div class="card-stats">
                            <div class="stat-item">
                                <span class="stat-label">Transactions</span>
                                <span class="stat-value" id="total-payments">
                                    <%= request.getAttribute("totalPayments") != null ? request.getAttribute("totalPayments") : "0" %>
                                </span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">Total Spent</span>
                                <span class="stat-value highlight" id="total-spent">
                                    Rs. <%= request.getAttribute("totalSpent") != null ? String.format("%.2f", request.getAttribute("totalSpent")) : "0.00" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <a href="BuyerPaymentsServlet" class="card-action-btn">
                        View All
                    </a>
            </div>
        </section>

            <!-- Modern Apartment Preview Section -->
        <section class="apartment-preview">
                <h2><i class="fa-solid fa-home"></i>Suggested Apartments</h2>
            <div class="apartment-grid">
                <%
                    List<Apartment> suggestedApartments = (List<Apartment>) request.getAttribute("suggestedApartments");
                    if (suggestedApartments != null && !suggestedApartments.isEmpty()) {
                        for (Apartment apartment : suggestedApartments) {
                %>
                <div class="apt-card">
                    <% String primaryImage = apartment.getPrimaryImageUrl(); %>
                    <% if (primaryImage != null && !primaryImage.trim().isEmpty()) { %>
                    <img src="image?file=<%= primaryImage.replace("/resources/images/", "") %>"
                         alt="<%= apartment.getTitle() %>"
                         onerror="this.src='https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80'">
                    <% } else { %>
                    <img src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80" alt="<%= apartment.getTitle() %>">
                    <% } %>
                    <div class="apt-card-content">
                    <h4><%= apartment.getTitle() %></h4>
                        <p class="apt-location"><i class="fa-solid fa-location-dot"></i> <%= apartment.getCity() %>, <%= apartment.getState() %></p>
                        <p class="apt-price">Rs. <%= String.format("%.0f", apartment.getPrice()) %></p>
                        <div class="apt-details">
                            <% if (apartment.getBedrooms() != null) { %>
                            <span><i class="fa-solid fa-bed"></i> <%= apartment.getBedrooms() %> bed</span>
                            <% } %>
                            <% if (apartment.getBathrooms() != null) { %>
                            <span><i class="fa-solid fa-bath"></i> <%= apartment.getBathrooms() %> bath</span>
                            <% } %>
                            <% if (apartment.getAreaSqFt() != null) { %>
                            <span><i class="fa-solid fa-ruler-combined"></i> <%= apartment.getAreaSqFt() %> sq ft</span>
                            <% } %>
                        </div>
                        <a href="ViewApartmentServlet?id=<%= apartment.getApartmentId() %>" class="apt-btn">View Details</a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="apt-card">
                    <img src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80" alt="No apartments">
                        <div class="apt-card-content">
                    <h4>No Apartments Available</h4>
                    <p>Check back later for new listings</p>
                        </div>
                </div>
                <%
                    }
                %>
            </div>
        </section>
    </main>
</div>

    <script>
        // Real-time data updating
        function updateDashboardData() {
            fetch('BuyerDashboardServlet?ajax=true')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        console.error('Error updating dashboard:', data.error);
                        return;
                    }
                    
                    // Update the dashboard elements with new data
                    document.getElementById('favourites-count').textContent = data.totalFavourites;
                    document.getElementById('total-bookings').textContent = data.totalBookings;
                    document.getElementById('pending-bookings').textContent = data.pendingBookings;
                    document.getElementById('total-payments').textContent = data.totalPayments;
                    document.getElementById('total-spent').textContent = 'Rs. ' + data.totalSpent.toFixed(2);
                    
                    console.log('Dashboard data updated successfully');
                })
                .catch(error => {
                    console.error('Error updating dashboard:', error);
                });
        }

        // Update data immediately when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateDashboardData();
        });

        // Update data every 1 second for real-time feel
        setInterval(updateDashboardData, 1000);

        // Update data when page becomes visible again
        document.addEventListener('visibilitychange', function() {
            if (!document.hidden) {
                updateDashboardData();
            }
        });

        // Add loading states to buttons
        document.querySelectorAll('.card-action-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const originalText = this.innerHTML;
                this.innerHTML = '<div class="loading"></div> Loading...';
                
                // Reset after 2 seconds (in case of slow navigation)
                setTimeout(() => {
                    this.innerHTML = originalText;
                }, 2000);
            });
        });

        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';

        // Add hover effects to cards
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Add click animations to apartment cards
        document.querySelectorAll('.apt-card').forEach(card => {
            card.addEventListener('click', function() {
                this.style.transform = 'scale(0.98)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 150);
            });
        });
    </script>
</body>
</html>