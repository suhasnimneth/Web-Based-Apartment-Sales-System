<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.model.Apartment" %>
<%
    // Check if user is logged in and has seller role
    Object userObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");

    if (userObj == null || !"seller".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get user information
    com.project.model.User user = (com.project.model.User) userObj;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apartment X | Seller Dashboard</title>
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

        .card-icon.apartments { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card-icon.add { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
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


        /* Success Popup Styles */
        .success-popup {
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(39, 174, 96, 0.3);
            z-index: 10000;
            animation: slideInRight 0.3s ease-out;
            max-width: 350px;
        }

        .success-content {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success-icon {
            font-size: 20px;
            flex-shrink: 0;
        }

        .success-text {
            font-weight: 600;
            font-size: 14px;
        }

        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }

        .success-popup.hide {
            animation: slideOutRight 0.3s ease-in forwards;
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
                        <li class="active"><a href="SellerDashboardServlet"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
                        <li><a href="editprofile.jsp"><i class="fa-solid fa-user-edit"></i>Edit Profile</a></li>
                        <li><a href="MyApartmentsServlet"><i class="fa-solid fa-building"></i>My Apartments</a></li>
                        <li><a href="addapartment.jsp"><i class="fa-solid fa-plus"></i>Add Apartment</a></li>
                        <li><a href="SellerBookingsServlet"><i class="fa-solid fa-calendar-check"></i>Bookings</a></li>
                        <li><a href="SellerPaymentsServlet"><i class="fa-solid fa-credit-card"></i>Payments</a></li>
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
            <!-- Success Message -->
            <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success-popup" id="successPopup">
                <div class="success-content">
                    <div class="success-icon">✅</div>
                    <div class="success-text"><%= request.getAttribute("successMessage") %></div>
                </div>
            </div>
            <% } %>

            <!-- Modern Hero Banner -->
            <div class="hero-banner">
                <div class="hero-text">
                    <h1>Welcome Back, <%= user.getFirstName() %> <%= user.getLastName() %>!</h1>
                    <p>Manage your listings, check payments, and track bookings all here.</p>
                </div>
            </div>

            <!-- Modern Dashboard Cards -->
            <section id="content-area" class="grid-layout">
                <div class="card">
                    <div class="card-header">
                        <div class="card-icon apartments">
                            <i class="fa-solid fa-building"></i>
                        </div>
                        <h3 class="card-title">My Apartments</h3>
                    </div>
                    <div class="card-content">
                        <div class="card-stats">
                            <div class="stat-item">
                                <span class="stat-label">Total Listings</span>
                                <span class="stat-value" id="total-apartments">
                                    <%= request.getAttribute("totalApartments") != null ? request.getAttribute("totalApartments") : "0" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <a href="MyApartmentsServlet" class="card-action-btn">
                        View All
                    </a>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-icon add">
                            <i class="fa-solid fa-plus"></i>
                        </div>
                        <h3 class="card-title">Add New Apartment</h3>
                    </div>
                    <div class="card-content">
                        <p style="color: #666; margin-bottom: 15px;">List a new property</p>
                    </div>
                    <a href="addapartment.jsp" class="card-action-btn">
                        Add Now
                    </a>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-icon bookings">
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                        <h3 class="card-title">Bookings</h3>
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
                    <a href="SellerBookingsServlet" class="card-action-btn">
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
                                <span class="stat-label">Total Earnings</span>
                                <span class="stat-value highlight" id="total-earnings">
                                    Rs. <%= request.getAttribute("totalEarnings") != null ? String.format("%.2f", request.getAttribute("totalEarnings")) : "0.00" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    <a href="SellerPaymentsServlet" class="card-action-btn">
                        View All
                    </a>
                </div>
            </section>

            <!-- Modern Apartment Preview Section -->
            <section class="apartment-preview">
                <h2><i class="fa-solid fa-home"></i>My Latest Apartments</h2>
                <div class="apartment-grid">
                    <%
                        List<Apartment> recentApartments = (List<Apartment>) request.getAttribute("recentApartments");
                        if (recentApartments != null && !recentApartments.isEmpty()) {
                            for (Apartment apartment : recentApartments) {
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
                            <p>Rs. <%= String.format("%.0f", apartment.getPrice()) %> | <%= apartment.getCity() %></p>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="apt-card">
                        <img src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80" alt="No apartments">
                        <div class="apt-card-content">
                            <h4>No Apartments Yet</h4>
                            <p>Start by adding your first property</p>
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
            fetch('SellerDashboardServlet?ajax=true')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        console.error('Error updating dashboard:', data.error);
                        return;
                    }
                    
                    // Update the dashboard elements with new data
                    document.getElementById('total-apartments').textContent = data.totalApartments;
                    document.getElementById('total-bookings').textContent = data.totalBookings;
                    document.getElementById('pending-bookings').textContent = data.pendingBookings;
                    document.getElementById('total-payments').textContent = data.totalPayments;
                    document.getElementById('total-earnings').textContent = 'Rs. ' + data.totalEarnings.toFixed(2);
                    
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

        // Auto-hide success popup after 2 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const successPopup = document.getElementById('successPopup');
            if (successPopup) {
                // Show popup for 2 seconds, then hide it
                setTimeout(function() {
                    successPopup.classList.add('hide');
                    // Remove from DOM after animation completes
                    setTimeout(function() {
                        if (successPopup.parentNode) {
                            successPopup.parentNode.removeChild(successPopup);
                        }
                    }, 300); // Wait for slideOutRight animation to complete
                }, 2000); // Show for 2 seconds
            }
        });
    </script>
</body>
</html>