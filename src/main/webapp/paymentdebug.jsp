<%@ page import="com.project.model.User" %>
<%@ page import="com.project.model.BuyerCard" %>
<%@ page import="com.project.service.BuyerCardService" %>
<%@ page import="com.project.DAO.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Debug</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-info { background: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .error { background: #ffebee; color: #c62828; }
        .success { background: #e8f5e8; color: #2e7d32; }
        .btn { padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 5px; }
    </style>
</head>
<body>
    <h1>Payment Flow Debug</h1>
    
    <%
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
    %>
    
    <div class="debug-info">
        <h3>Session Information:</h3>
        <p><strong>User:</strong> <%= user != null ? user.getFirstName() + " " + user.getLastName() : "Not logged in" %></p>
        <p><strong>User Role:</strong> <%= userRole != null ? userRole : "Not set" %></p>
        <p><strong>User ID:</strong> <%= user != null ? user.getUserId() : "N/A" %></p>
    </div>
    
    <%
        if (user != null && "buyer".equalsIgnoreCase(userRole)) {
            try {
                UserDAO userDAO = new UserDAO();
                String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
                
                if (buyerId != null) {
                    BuyerCardService buyerCardService = new BuyerCardService();
                    java.util.List<BuyerCard> buyerCards = buyerCardService.getCardsByBuyerId(buyerId);
    %>
    
    <div class="debug-info">
        <h3>Buyer Information:</h3>
        <p><strong>Buyer ID:</strong> <%= buyerId %></p>
        <p><strong>Number of Cards:</strong> <%= buyerCards.size() %></p>
    </div>
    
    <%
                    if (buyerCards.isEmpty()) {
    %>
    <div class="debug-info error">
        <h3>⚠️ No Payment Cards Found</h3>
        <p>You need to add a payment card before making payments.</p>
        <a href="BuyerCardServlet" class="btn">Add Payment Card</a>
    </div>
    <%
                    } else {
    %>
    <div class="debug-info success">
        <h3>✅ Payment Cards Available</h3>
        <p>You have <%= buyerCards.size() %> payment card(s). You can make payments.</p>
        <%
                            for (BuyerCard card : buyerCards) {
        %>
        <p><strong>Card:</strong> <%= card.getMaskedCardNumber() %> - Balance: Rs. <%= card.getAmountInCard() %></p>
        <%
                            }
        %>
    </div>
    <%
                    }
                } else {
    %>
    <div class="debug-info error">
        <h3>❌ Buyer Profile Not Found</h3>
        <p>Your user account is not linked to a buyer profile.</p>
    </div>
    <%
                }
            } catch (Exception e) {
    %>
    <div class="debug-info error">
        <h3>❌ Error</h3>
        <p>Error: <%= e.getMessage() %></p>
    </div>
    <%
            }
        } else {
    %>
    <div class="debug-info error">
        <h3>❌ Not Logged In as Buyer</h3>
        <p>Please log in as a buyer to access payment functionality.</p>
        <a href="login.jsp" class="btn">Login</a>
    </div>
    <%
        }
    %>
    
    <div class="debug-info">
        <h3>Test Payment Links:</h3>
        <p>Try these test links (replace A001 with actual apartment ID):</p>
        <a href="PaymentServlet?apartmentId=A001" class="btn">Test Payment A001</a>
        <a href="PaymentServlet?apartmentId=A002" class="btn">Test Payment A002</a>
        <a href="PaymentServlet?apartmentId=A003" class="btn">Test Payment A003</a>
    </div>
    
    <div class="debug-info">
        <h3>Navigation:</h3>
        <a href="buyerdashboard.jsp" class="btn">Buyer Dashboard</a>
        <a href="BuyerCardServlet" class="btn">Manage Cards</a>
        <a href="AllApartmentsServlet" class="btn">View Apartments</a>
    </div>
</body>
</html>
