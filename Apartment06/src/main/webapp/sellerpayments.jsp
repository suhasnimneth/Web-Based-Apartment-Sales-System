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

    if (user == null || !"seller".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Received | Apartment X</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .payments-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
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
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            z-index: 10;
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
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
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
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .payment-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .payment-id {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .payment-status {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .payment-body {
            padding: 20px;
        }
        
        .payment-amount {
            font-size: 2rem;
            font-weight: 700;
            color: #28a745;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .payment-details {
            margin-bottom: 15px;
        }
        
        .payment-details h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        
        .detail-value {
            color: #333;
        }
        
        .apartment-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-top: 15px;
        }
        
        .buyer-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 10px;
            margin-top: 10px;
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
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            text-align: center;
            border: 1px solid rgba(230, 57, 70, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            border-radius: 20px 20px 0 0;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .summary-card h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.1rem;
        }
        
        .summary-card .amount {
            font-size: 2rem;
            font-weight: 700;
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="payments-container">
            <a href="sellerdashboard.jsp" class="back-btn">
                 Back
            </a>
            
            <div class="page-header">
                <h1><i class="fa-solid fa-money-bill-wave"></i> Payments Received</h1>
                <p>Track all payments received for your apartments</p>
            </div>

                <%
                    List<Map<String, Object>> paymentDetails = (List<Map<String, Object>>) request.getAttribute("paymentDetails");
                    if (paymentDetails != null && !paymentDetails.isEmpty()) {
                        
                        // Calculate summary statistics
                        double totalAmount = 0;
                        int completedPayments = 0;
                        int pendingPayments = 0;
                        
                        for (Map<String, Object> paymentDetail : paymentDetails) {
                            Payment payment = (Payment) paymentDetail.get("payment");
                            totalAmount += payment.getAmount().doubleValue();
                            if ("Completed".equals(payment.getStatus())) {
                                completedPayments++;
                            } else if ("Pending".equals(payment.getStatus())) {
                                pendingPayments++;
                            }
                        }
                %>
                    <!-- Summary Cards -->
                    <div class="summary-cards">
                        <div class="summary-card">
                            <h3>Total Received</h3>
                            <div class="amount">Rs.<%= String.format("%.2f", totalAmount) %></div>
                        </div>
                        <div class="summary-card">
                            <h3>Completed</h3>
                            <div class="amount" style="color: #28a745;"><%= completedPayments %></div>
                        </div>
                        <div class="summary-card">
                            <h3>Pending</h3>
                            <div class="amount" style="color: #ffc107;"><%= pendingPayments %></div>
                        </div>
                        <div class="summary-card">
                            <h3>Total Payments</h3>
                            <div class="amount" style="color: #6c757d;"><%= paymentDetails.size() %></div>
                        </div>
                    </div>

                    <div class="payments-grid">
                        <%
                            for (Map<String, Object> paymentDetail : paymentDetails) {
                                Payment payment = (Payment) paymentDetail.get("payment");
                                Apartment apartment = (Apartment) paymentDetail.get("apartment");
                                User buyer = (User) paymentDetail.get("buyer");
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
                                        <h4><i class="fa-solid fa-building"></i> Apartment Details</h4>
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
                                            <span class="detail-value">Rs.<%= apartment.getPrice() %></span>
                                        </div>
                                    </div>
                                    <% } %>
                                    
                                    <% if (buyer != null) { %>
                                    <div class="buyer-info">
                                        <h4><i class="fa-solid fa-user"></i> Buyer Information</h4>
                                        <div class="detail-row">
                                            <span class="detail-label">Name:</span>
                                            <span class="detail-value"><%= buyer.getFirstName() %> <%= buyer.getLastName() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Email:</span>
                                            <span class="detail-value"><%= buyer.getEmail() %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="detail-label">Contact:</span>
                                            <span class="detail-value"><%= buyer.getContactNumber() %></span>
                                        </div>
                                    </div>
                                    <% } else { %>
                                    <div class="buyer-info" style="background-color: #ffebee; color: #c62828;">
                                        <h4><i class="fa-solid fa-exclamation-triangle"></i> Buyer Information Not Available</h4>
                                        <p>Buyer details could not be loaded for this payment.</p>
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
                        <h3><i class="fa-solid fa-money-bill-wave"></i> No Payments Received</h3>
                        <p>You haven't received any payments yet. Start by listing your apartments and wait for buyers to make payments!</p>
                    </div>
                <%
                    }
                %>
            </div>
    </div>
</body>
</html>
