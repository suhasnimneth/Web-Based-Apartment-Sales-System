<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.Payment" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Make sure user is logged in
    Object user = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");

    if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payments | Apartment X</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/buyerdashboard.css">
    <style>
        .main-content {
            padding: 80px 30px 30px 30px;
            min-height: 100vh;
            position: relative;
        }

        .payments-container {
            max-width: 100%;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            overflow: hidden;
        }
        
        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin-bottom: 30px;
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

        .page-header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 700;
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-header h1 i {
            font-size: 2rem;
        }

        .page-header p {
            margin: 10px 0 0 0;
            font-size: 1.2rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }
        
        .payments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        /* Ensure at least 3 columns on larger screens */
        @media (min-width: 1200px) {
            .payments-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        
        /* 4 columns on very large screens */
        @media (min-width: 1600px) {
            .payments-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        /* 2 columns on medium screens */
        @media (max-width: 1199px) and (min-width: 768px) {
            .payments-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        /* Single column on small screens */
        @media (max-width: 767px) {
            .payments-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .payment-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
            height: fit-content;
            display: flex;
            flex-direction: column;
        }

        .payment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .payment-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .payment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
            flex-shrink: 0;
        }
        
        .payment-id {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .payment-status {
            font-size: 0.85rem;
            opacity: 0.9;
        }
        
        .payment-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .payment-amount {
            font-size: 1.8rem;
            font-weight: 700;
            color: #28a745;
            text-align: center;
            margin-bottom: 20px;
            flex-shrink: 0;
        }
        
        .payment-details {
            margin-bottom: 15px;
            flex-grow: 1;
        }
        
        .payment-details h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
            flex-shrink: 0;
            min-width: 80px;
        }
        
        .detail-value {
            color: #333;
            text-align: right;
            word-break: break-word;
        }
        
        .apartment-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-top: 15px;
            flex-shrink: 0;
        }
        
        .seller-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 10px;
            margin-top: 10px;
            flex-shrink: 0;
        }
        
        .apartment-info h4,
        .seller-info h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .apartment-info h4 i,
        .seller-info h4 i {
            color: #e63946;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-failed {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-refunded {
            background: #cce5ff;
            color: #004085;
        }
        
        .no-payments {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .no-payments h3 {
            margin-bottom: 10px;
            color: #333;
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
    </style>
</head>
<body>
    <div class="main-content">
        <a href="buyerdashboard.jsp" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="payments-container">
                
                <div class="page-header">
                    <h1><i class="fa-solid fa-credit-card"></i> My Payments</h1>
                    <p>Track all your apartment payments and transactions</p>
                </div>

                <%
                    List<Map<String, Object>> paymentDetails = (List<Map<String, Object>>) request.getAttribute("paymentDetails");
                    if (paymentDetails != null && !paymentDetails.isEmpty()) {
                %>
                    <div class="payments-grid">
                        <%
                            for (Map<String, Object> paymentDetail : paymentDetails) {
                                Payment payment = (Payment) paymentDetail.get("payment");
                                Apartment apartment = (Apartment) paymentDetail.get("apartment");
                                User seller = (User) paymentDetail.get("seller");
                        %>
                            <div class="payment-card">
                                <div class="payment-header">
                                    <div class="payment-id"><%= payment.getPaymentId() %></div>
                                    <div class="payment-status">
                                        <span class="status-badge status-<%= payment.getStatus().toLowerCase() %>">
                                            <%= payment.getStatus() %>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="payment-body">
                                    <div class="payment-amount">Rs.<%= payment.getAmount() %></div>
                                    
                                    <div class="payment-details">
                                        <h4>Payment Details</h4>
                                        <div class="detail-row">
                                            <span class="detail-label">Type:</span>
                                            <span class="detail-value"><%= payment.getPaymentType() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Date:</span>
                                            <span class="detail-value"><%= payment.getPaymentDate() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Description:</span>
                                            <span class="detail-value"><%= payment.getDescription() != null ? payment.getDescription() : "N/A" %></span>
                                        </div>
                                    </div>
                                    
                                    <% if (apartment != null) { %>
                                    <div class="apartment-info">
                                        <h4><i class="fa-solid fa-home"></i> Apartment Details</h4>
                                        <div class="detail-row">
                                            <span class="detail-label">Title:</span>
                                            <span class="detail-value"><%= apartment.getTitle() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Location:</span>
                                            <span class="detail-value"><%= apartment.getAddress() %>, <%= apartment.getCity() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Total Price:</span>
                                            <span class="detail-value">Rs. <%= apartment.getPrice() %></span>
                                        </div>
                                    </div>
                                    <% } %>
                                    
                                    <% if (seller != null) { %>
                                    <div class="seller-info">
                                        <h4><i class="fa-solid fa-user"></i> Seller Information</h4>
                                        <div class="detail-row">
                                            <span class="detail-label">Name:</span>
                                            <span class="detail-value"><%= seller.getFirstName() %> <%= seller.getLastName() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Email:</span>
                                            <span class="detail-value"><%= seller.getEmail() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Contact:</span>
                                            <span class="detail-value"><%= seller.getContactNumber() %></span>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>
                <%
                    } else {
                %>
                    <div class="no-payments">
                        <h3>No Payments Found</h3>
                        <p>You haven't made any payments yet. Start by browsing apartments and making your first payment!</p>
                    </div>
                <%
                    }
                %>
            </div>
    </div>
</body>
</html>
