<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.BuyerCard" %>
<%@ page import="com.project.model.User" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment - Apartment Portal</title>
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
            max-width: 1200px;
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

        .page-header h1 {
            font-size: 2.5rem;
            margin: 0 0 10px 0;
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
            font-size: 1.2rem;
            margin: 0;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .content-section {
            padding: 30px;
        }

        .info-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .info-card h3 {
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-card h3 i {
            color: #e63946;
        }

        .info-detail {
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-detail:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .info-detail strong {
            color: #333;
            font-weight: 600;
            display: inline-block;
            min-width: 100px;
        }

        .info-detail span {
            color: #666;
        }

        .payment-type {
            background: white;
            border: 2px solid #e0e0e0;
            padding: 20px;
            margin: 15px 0;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .payment-type:hover {
            border-color: #e63946;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.15);
        }

        .payment-type.selected {
            border-color: #e63946;
            background: linear-gradient(135deg, rgba(230, 57, 70, 0.05) 0%, rgba(247, 127, 0, 0.05) 100%);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.2);
        }

        .payment-type.selected::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .payment-type input[type="radio"] {
            margin-right: 15px;
            transform: scale(1.2);
        }

        .payment-type label {
            font-weight: 600;
            color: #333;
            cursor: pointer;
            font-size: 1.1rem;
        }

        .card-item {
            background: white;
            border: 2px solid #e0e0e0;
            padding: 20px;
            margin: 15px 0;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card-item:hover {
            border-color: #e63946;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.15);
        }

        .card-item input[type="radio"]:checked + label {
            color: #e63946;
        }

        .card-item input[type="radio"] {
            margin-right: 15px;
            transform: scale(1.2);
        }

        .card-item label {
            font-weight: 600;
            color: #333;
            cursor: pointer;
            line-height: 1.5;
        }

        .btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .error {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            border-left: 4px solid #e63946;
            font-weight: 500;
        }

        .success {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            border-left: 4px solid #4caf50;
            font-weight: 500;
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        /* Payment Success Popup Modal */
        .popup-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease-out;
        }

        .popup-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            max-width: 400px;
            width: 90%;
            animation: slideInScale 0.3s ease-out;
        }

        .popup-header {
            background: #d4edda;
            padding: 20px;
            border-radius: 12px 12px 0 0;
            text-align: center;
            border-bottom: 1px solid #c3e6cb;
        }

        .popup-header .success-icon {
            font-size: 48px;
            margin-bottom: 10px;
            display: block;
        }

        .popup-header h3 {
            margin: 0;
            color: #155724;
            font-size: 20px;
            font-weight: 600;
        }

        .popup-body {
            padding: 20px;
            text-align: center;
        }

        .popup-body p {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 16px;
            line-height: 1.5;
        }

        .redirect-timer {
            font-size: 14px !important;
            color: #6c757d !important;
            font-style: italic;
            margin-top: 10px !important;
        }

        #countdown {
            font-weight: bold;
            color: #e63946;
            font-size: 16px;
        }

        .popup-footer {
            padding: 15px 20px;
            text-align: center;
            border-top: 1px solid #eee;
        }

        .close-popup-btn {
            background: #e63946;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.2s;
        }

        .close-popup-btn:hover {
            background: #c82333;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInScale {
            from {
                transform: scale(0.8) translateY(-20px);
                opacity: 0;
            }
            to {
                transform: scale(1) translateY(0);
                opacity: 1;
            }
        }

        /* Insufficient Balance Popup Styles */
        .insufficient-balance-popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease-out;
        }

        .insufficient-balance-popup .popup-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            max-width: 400px;
            width: 90%;
            animation: slideInScale 0.3s ease-out;
        }

        .insufficient-balance-popup .error-header {
            background: #f8d7da;
            color: #721c24;
            border-bottom: 1px solid #f5c6cb;
        }

        .insufficient-balance-popup .error-icon {
            font-size: 48px;
            margin-bottom: 10px;
            display: block;
        }

        .insufficient-balance-popup .popup-body p {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 16px;
            line-height: 1.5;
        }

        .insufficient-balance-popup .redirect-timer {
            font-size: 14px !important;
            color: #6c757d !important;
            font-style: italic;
            margin-top: 10px !important;
        }

        .insufficient-balance-popup #countdown {
            font-weight: bold;
            color: #dc3545;
            font-size: 16px;
        }
    </style>
</head>
<body>

<!-- Payment Success Popup Modal -->
<%
    String paymentSuccess = (String) request.getAttribute("paymentSuccess");
    boolean isPaymentSuccess = paymentSuccess != null && !paymentSuccess.trim().isEmpty();
    if (isPaymentSuccess) {
%>
<div class="popup-modal" id="paymentSuccessModal">
    <div class="popup-content">
        <div class="popup-header">
            <span class="success-icon">✅</span>
            <h3>Payment Successful!</h3>
        </div>
        <div class="popup-body">
            <p><%= paymentSuccess %></p>
            <p class="redirect-timer">Redirecting to dashboard in <span id="countdown">2</span> seconds...</p>
        </div>
        <div class="popup-footer">
            <button class="close-popup-btn" onclick="closePopupAndRedirect()">Close</button>
        </div>
    </div>
</div>
<script>
    // Auto-close popup after 2 seconds and redirect to dashboard
    let countdown = 2;
    const countdownElement = document.getElementById('countdown');
    const popupModal = document.getElementById('paymentSuccessModal');

    function updateCountdown() {
        countdownElement.textContent = countdown;
        countdown--;

        if (countdown < 0) {
            closePopup();
            // Redirect to buyer dashboard after popup closes
            setTimeout(function() {
                window.location.href = 'buyerdashboard.jsp';
            }, 300); // Small delay to allow popup to close smoothly
        } else {
            setTimeout(updateCountdown, 1000);
        }
    }

    function closePopup() {
        if (popupModal) {
            popupModal.style.display = 'none';
        }
    }

    function closePopupAndRedirect() {
        closePopup();
        // Redirect to buyer dashboard immediately when close button is clicked
        setTimeout(function() {
            window.location.href = 'buyerdashboard.jsp';
        }, 300);
    }

    // Start countdown when page loads
    setTimeout(updateCountdown, 1000);
</script>
<%
    }
%>
    <div class="main-content">
        <div class="container" <% if (isPaymentSuccess) { %>style="display: none;"<% } %>>
            <a href="javascript:history.back()" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back
            </a>

            <div class="page-header">
                <h1><i class="fa-solid fa-credit-card"></i> Make Payment</h1>
                <p>Complete your apartment purchase</p>
            </div>

            <div class="content-section">
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    String successMessage = (String) request.getAttribute("successMessage");
                    boolean isInsufficientBalance = errorMessage != null && 
                        (errorMessage.toLowerCase().contains("insufficient") || 
                         errorMessage.toLowerCase().contains("balance"));
                    
                    if (errorMessage != null && !isInsufficientBalance) {
                %>
                <div class="error">
                    <i class="fa-solid fa-exclamation-triangle"></i> Error: <%= errorMessage %>
                </div>
                <%
                    }
                    if (successMessage != null) {
                %>
                <div class="success">
                    <i class="fa-solid fa-check-circle"></i> Success: <%= successMessage %>
                </div>
                <%
                    }
                %>

                <!-- Insufficient Balance Popup -->
                <% if (isInsufficientBalance) { %>
                <div class="insufficient-balance-popup" id="insufficientBalancePopup">
                    <div class="popup-content">
                        <div class="popup-header error-header">
                            <div class="error-icon">⚠️</div>
                            <h3>Insufficient Balance</h3>
                        </div>
                        <div class="popup-body">
                            <p><%= errorMessage %></p>
                            <p class="redirect-timer">Redirecting to apartment details in <span id="countdown">1.5</span> seconds...</p>
                        </div>
                    </div>
                </div>
                <% } %>

                <%
                    Apartment apartment = (Apartment) request.getAttribute("apartment");
                    List<BuyerCard> buyerCards = (List<BuyerCard>) request.getAttribute("buyerCards");
                    User seller = (User) request.getAttribute("seller");
                    BigDecimal advanceAmount = (BigDecimal) request.getAttribute("advanceAmount");
                    BigDecimal installmentAmount = (BigDecimal) request.getAttribute("installmentAmount");
                    BigDecimal halfAmount = (BigDecimal) request.getAttribute("halfAmount");
                %>

                <%
                    if (apartment != null) {
                %>
                <div class="info-card">
                    <h3><i class="fa-solid fa-home"></i> Apartment Details</h3>
                    <div class="info-detail">
                        <strong>Title:</strong> <span><%= apartment.getTitle() %></span>
                    </div>
                    <div class="info-detail">
                        <strong>Price:</strong> <span>Rs. <%= String.format("%.2f", apartment.getPrice()) %></span>
                    </div>
                    <div class="info-detail">
                        <strong>Location:</strong> <span><%= apartment.getAddress() %></span>
                    </div>
                    <div class="info-detail">
                        <strong>City:</strong> <span><%= apartment.getCity() %></span>
                    </div>
                </div>
                <%
                    }
                %>

                <%
                    if (seller != null) {
                %>
                <div class="info-card">
                    <h3><i class="fa-solid fa-user"></i> Seller Information</h3>
                    <div class="info-detail">
                        <strong>Name:</strong> <span><%= seller.getFirstName() %> <%= seller.getLastName() %></span>
                    </div>
                    <div class="info-detail">
                        <strong>Email:</strong> <span><%= seller.getEmail() %></span>
                    </div>
                </div>
                <%
                    }
                %>

                <form action="PaymentServlet" method="post">
                    <input type="hidden" name="apartmentId" value="<%= apartment != null ? apartment.getApartmentId() : "" %>">

                    <div class="info-card">
                        <h3><i class="fa-solid fa-credit-card"></i> Select Payment Type</h3>
                        
                        <div class="payment-type" onclick="selectPaymentType('advance')">
                            <input type="radio" name="paymentType" value="advance" id="advance" required>
                            <label for="advance"><strong>Advance Payment (10%)</strong> - Rs. <%= advanceAmount != null ? String.format("%.2f", advanceAmount) : "0.00" %></label>
                        </div>

                        <div class="payment-type" onclick="selectPaymentType('installment')">
                            <input type="radio" name="paymentType" value="installment" id="installment" required>
                            <label for="installment"><strong>Monthly Installment (1/12)</strong> - Rs. <%= installmentAmount != null ? String.format("%.2f", installmentAmount) : "0.00" %></label>
                        </div>

                        <div class="payment-type" onclick="selectPaymentType('half')">
                            <input type="radio" name="paymentType" value="half" id="half" required>
                            <label for="half"><strong>Half Payment (50%)</strong> - Rs. <%= halfAmount != null ? String.format("%.2f", halfAmount) : "0.00" %></label>
                        </div>
                    </div>

                    <div class="info-card">
                        <h3><i class="fa-solid fa-wallet"></i> Select Payment Card</h3>
                        <%
                            if (buyerCards != null && !buyerCards.isEmpty()) {
                                for (BuyerCard card : buyerCards) {
                        %>
                        <div class="card-item">
                            <input type="radio" name="buyerCardId" value="<%= card.getBuyerCardId() %>" id="card-<%= card.getBuyerCardId() %>" required>
                            <label for="card-<%= card.getBuyerCardId() %>">
                                <strong><%= card.getCardholderName() %></strong><br>
                                Card: <%= card.getMaskedCardNumber() %><br>
                                Balance: Rs. <%= String.format("%.2f", card.getAmountInCard()) %>
                            </label>
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <p>No payment cards available. Please add a card first.</p>
                        <%
                            }
                        %>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn">
                            <i class="fa-solid fa-credit-card"></i> Process Payment
                        </button>
                    </div>
                </form>
            </div>
        </div>

    <script>
        function selectPaymentType(type) {
            // Remove selected class from all payment types
            document.querySelectorAll('.payment-type').forEach(el => {
                el.classList.remove('selected');
            });

            // Add selected class to clicked type
            event.currentTarget.classList.add('selected');
            
            // Also check the radio button
            const radioButton = document.getElementById(type);
            if (radioButton) {
                radioButton.checked = true;
            }
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const paymentType = document.querySelector('input[name="paymentType"]:checked');
            const cardId = document.querySelector('input[name="buyerCardId"]:checked');

            if (!paymentType || !cardId) {
                e.preventDefault();
                alert('Please select both payment type and payment card');
                return false;
            }

            const selectedPaymentType = document.querySelector('.payment-type.selected');
            if (selectedPaymentType) {
                const amount = selectedPaymentType.querySelector('label').textContent.split('Rs. ')[1];
                if (!confirm(`Confirm payment of Rs. ${amount}?`)) {
                    e.preventDefault();
                    return false;
                }
            }
        });

        // Insufficient Balance Popup Auto-redirect
        document.addEventListener('DOMContentLoaded', function() {
            const insufficientBalancePopup = document.getElementById('insufficientBalancePopup');
            if (insufficientBalancePopup) {
                let countdown = 1.5;
                const countdownElement = document.getElementById('countdown');
                
                function updateCountdown() {
                    countdownElement.textContent = countdown.toFixed(1);
                    countdown -= 0.1;
                    
                    if (countdown <= 0) {
                        // Redirect to apartment detail page
                        const apartmentId = '<%= request.getParameter("apartmentId") %>';
                        if (apartmentId) {
                            window.location.href = 'apartmentdetail.jsp?id=' + apartmentId;
                        } else {
                            // Fallback to apartments listing if no apartment ID
                            window.location.href = 'apartments.jsp';
                        }
                    } else {
                        setTimeout(updateCountdown, 100);
                    }
                }
                
                // Start countdown immediately
                updateCountdown();
            }
        });
    </script>
</body>
</html>