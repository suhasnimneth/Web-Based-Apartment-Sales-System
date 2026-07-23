<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.User" %>
<%@ page import="com.project.model.BuyerCard" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in and is a buyer
    User user = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
    if (session == null || user == null || !"buyer".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payment Cards - Apartment Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        }

        .main-content {
            padding: 80px 30px 30px 30px;
            min-height: 100vh;
            position: relative;
        }

        .cards-container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
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

        .content {
            padding: 30px;
        }

        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: 500;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .success {
            background-color: #d1fae5;
            color: #065f46;
            border-left: 4px solid #059669;
        }

        .info {
            background-color: #dbeafe;
            color: #1e40af;
            border-left: 4px solid #3b82f6;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #dc3545;
        }

        .btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 57, 70, 0.4);
        }

        .cards-list {
            margin-top: 30px;
        }

        .card-item {
            background: white;
            border: 1px solid rgba(230, 57, 70, 0.1);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .card-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .card-item h4 {
            color: #e63946;
            margin-bottom: 15px;
            font-size: 1.3rem;
            font-weight: 700;
        }

        .card-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-bottom: 15px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #e63946;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
        }

        .info-value {
            color: #e63946;
            font-weight: 600;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-update {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-update:hover {
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #e74c3c 100%);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }

        .btn-delete:hover {
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }

        .btn-save {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .btn-save:hover {
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-cancel:hover {
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
        }

        .update-form {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-top: 15px;
        }

        .update-form h5 {
            color: #dc3545;
            margin-bottom: 15px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <a href="buyerdashboard.jsp" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="cards-container">

            <div class="page-header">
                <h1><i class="fa-solid fa-credit-card"></i> My Payment Cards</h1>
                <p>Welcome, <%= user.getFirstName() %> <%= user.getLastName() %>!</p>
            </div>

            <div class="content">
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successMessage = (String) request.getAttribute("successMessage");
                String infoMessage = (String) request.getAttribute("infoMessage");
                
                if (errorMessage != null) {
            %>
            <div class="message error">Error: <%= errorMessage %></div>
            <%
                }
                if (successMessage != null) {
            %>
            <div class="message success">Success: <%= successMessage %></div>
            <%
                }
                if (infoMessage != null) {
            %>
            <div class="message info">Info: <%= infoMessage %></div>
            <%
                }
            %>

            <h3>Add New Payment Card</h3>
            <form action="BuyerCardServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="cardholderName">Cardholder Name:</label>
                    <input type="text" id="cardholderName" name="cardholderName" required>
                </div>

                <div class="form-group">
                    <label for="cardNumber">Card Number:</label>
                    <input type="text" id="cardNumber" name="cardNumber" maxlength="19" placeholder="1234 5678 9012 3456" required pattern="[0-9\s]{19}" title="Card number must be exactly 16 digits">
                </div>

                <div class="form-group">
                    <label for="cvv">CVV:</label>
                    <input type="text" id="cvv" name="cvv" maxlength="4" required pattern="[0-9]{3,4}" title="CVV must be 3 or 4 digits">
                </div>

                <div class="form-group">
                    <label for="expiryDate">Expiry Date:</label>
                    <input type="date" id="expiryDate" name="expiryDate" required min="<%= java.time.LocalDate.now().toString() %>" title="Expiry date must be a future date">
                </div>

                <div class="form-group">
                    <label for="amountInCard">Initial Balance (Required):</label>
                    <input type="number" step="0.01" id="amountInCard" name="amountInCard" min="0" required placeholder="0.00" title="Balance cannot be negative">
                </div>

                <button type="submit" class="btn">Add Card</button>
            </form>

            <div class="cards-list">
                <h3>My Cards</h3>
                <%
                    List<BuyerCard> buyerCards = (List<BuyerCard>) request.getAttribute("buyerCards");
                    if (buyerCards != null && !buyerCards.isEmpty()) {
                        for (BuyerCard card : buyerCards) {
                %>
                <div class="card-item">
                    <h4><%= card.getCardholderName() %></h4>
                    <div class="card-info">
                        <div class="info-item">
                            <span class="info-label">Card Number:</span>
                            <span class="info-value"><%= card.getMaskedCardNumber() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">CVV:</span>
                            <span class="info-value"><%= card.getCvv() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Expiry:</span>
                            <span class="info-value"><%= card.getExpiryDate() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Balance:</span>
                            <span class="info-value">Rs. <%= card.getAmountInCard() %></span>
                        </div>
                    </div>
                    
                    <div class="card-actions">
                        <button class="btn btn-update" onclick="toggleUpdateForm('<%= card.getBuyerCardId() %>')">Update Card</button>
                        <form action="BuyerCardServlet" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="buyerCardId" value="<%= card.getBuyerCardId() %>">
                            <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this card?')">Delete Card</button>
                        </form>
                    </div>
                    
                    <!-- Update Form (Hidden by default) -->
                    <div id="update-form-<%= card.getBuyerCardId() %>" class="update-form" style="display: none;">
                        <h5>Update Card Details</h5>
                        <form action="BuyerCardServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="buyerCardId" value="<%= card.getBuyerCardId() %>">
                            
                            <div class="form-group">
                                <label>Cardholder Name:</label>
                                <input type="text" name="cardholderName" value="<%= card.getCardholderName() %>" required>
                            </div>
                            
                            <div class="form-group">
                                <label>Card Number:</label>
                                <input type="text" name="cardNumber" value="<%= card.getCardNumber() %>" maxlength="19" placeholder="1234 5678 9012 3456" required pattern="[0-9\s]{19}" title="Card number must be exactly 16 digits">
                            </div>
                            
                            <div class="form-group">
                                <label>CVV:</label>
                                <input type="text" name="cvv" value="<%= card.getCvv() %>" maxlength="4" required pattern="[0-9]{3,4}" title="CVV must be 3 or 4 digits">
                            </div>
                            
                            <div class="form-group">
                                <label>Expiry Date:</label>
                                <input type="date" name="expiryDate" value="<%= card.getExpiryDate() %>" required min="<%= java.time.LocalDate.now().toString() %>" title="Expiry date must be a future date">
                            </div>
                            
                            <div class="form-group">
                                <label>Balance:</label>
                                <input type="number" step="0.01" name="amountInCard" value="<%= card.getAmountInCard() %>" min="0" required title="Balance cannot be negative">
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-save">Save Changes</button>
                                <button type="button" class="btn btn-cancel" onclick="toggleUpdateForm('<%= card.getBuyerCardId() %>')">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p>No cards found. Add your first payment card above.</p>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script>
        // Format card number input
        document.getElementById('cardNumber').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formattedValue;
        });

        // Format CVV input
        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
        });

        // Toggle update form visibility
        function toggleUpdateForm(cardId) {
            const updateForm = document.getElementById('update-form-' + cardId);
            if (updateForm.style.display === 'none') {
                updateForm.style.display = 'block';
            } else {
                updateForm.style.display = 'none';
            }
        }

        // Format card number input in update forms
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listeners to all card number inputs in update forms
            const updateCardNumberInputs = document.querySelectorAll('.update-form input[name="cardNumber"]');
            updateCardNumberInputs.forEach(input => {
                input.addEventListener('input', function(e) {
                    let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                    let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                    e.target.value = formattedValue;
                });
            });

            // Add event listeners to all CVV inputs in update forms
            const updateCvvInputs = document.querySelectorAll('.update-form input[name="cvv"]');
            updateCvvInputs.forEach(input => {
                input.addEventListener('input', function(e) {
                    e.target.value = e.target.value.replace(/[^0-9]/g, '');
                });
            });
        });
    </script>
        </div>
    </div>
</body>
</html>
