<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.project.model.Booking" %>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Bookings</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 0; 
            background: #f5f5f5; 
        }
        
        .main-content {
            padding: 20px;
        }
        
        .bookings-container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
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
        
        .booking-card { 
            background: white; 
            margin: 15px 0; 
            padding: 25px; 
            border-radius: 20px; 
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .booking-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            border-radius: 20px 20px 0 0;
        }
        
        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        .status { 
            padding: 5px 10px; 
            border-radius: 5px; 
            font-weight: bold; 
        }
        .pending { 
            background: #fff3cd; 
            color: #856404; 
        }
        .confirmed { 
            background: #d4edda; 
            color: #155724; 
        }
        .cancelled { 
            background: #f8d7da; 
            color: #721c24; 
        }
        .rejected { 
            background: #f8d7da; 
            color: #721c24; 
        }
        .btn { 
            padding: 12px 24px; 
            margin: 5px; 
            border: none; 
            border-radius: 25px; 
            cursor: pointer; 
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-confirm { 
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white; 
            box-shadow: 0 4px 15px rgba(67, 233, 123, 0.3);
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.4);
        }
        .btn-reject { 
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white; 
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }
        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }
        .no-bookings { 
            text-align: center; 
            padding: 40px; 
            color: #666; 
        }
        
        /* Success Popup Styles */
        .success-popup {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
            z-index: 10000;
            text-align: center;
            font-size: 18px;
            font-weight: 600;
            animation: popupFadeIn 0.3s ease-out;
        }
        
        .success-popup .icon {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
        }
        
        @keyframes popupFadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.8);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%) scale(1);
            }
        }
        
        @keyframes popupFadeOut {
            from {
                opacity: 1;
                transform: translate(-50%, -50%) scale(1);
            }
            to {
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.8);
            }
        }
        
        .success-popup.hide {
            animation: popupFadeOut 0.3s ease-in forwards;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="bookings-container">
            <a href="SellerDashboardServlet" class="back-btn">
                 Back
            </a>
            
            <div class="page-header">
                <h1><i class="fa-solid fa-calendar-check"></i> Seller Bookings</h1>
                <p>Manage apartment viewing appointments</p>
            </div>
        
        <%
        List<Map<String, Object>> bookingDetails = (List<Map<String, Object>>) request.getAttribute("bookingDetails");
        if (bookingDetails == null || bookingDetails.isEmpty()) {
        %>
            <div class="no-bookings">
                <h3>No Bookings Yet</h3>
                <p>You don't have any apartment viewing bookings yet.</p>

        <%
        } else {
            for (Map<String, Object> bookingDetail : bookingDetails) {
                Booking booking = (Booking) bookingDetail.get("booking");
                Apartment apartment = (Apartment) bookingDetail.get("apartment");
                User buyer = (User) bookingDetail.get("buyer");
        %>
            <div class="booking-card">
                <h3><%= apartment != null ? apartment.getTitle() : "Apartment" %></h3>
                <p><strong>Booking ID:</strong> <%= booking.getBookingId() %></p>
                <p><strong>Status:</strong> <span class="status <%= booking.getStatus().toLowerCase() %>"><%= booking.getStatus() %></span></p>
                <p><strong>Date:</strong> <%= booking.getBookingDate() %></p>
                <p><strong>Time:</strong> <%= booking.getBookingTime() %></p>
                
                <% if (buyer != null) { %>
                <p><strong>Buyer:</strong> <%= buyer.getFirstName() %> <%= buyer.getLastName() %> (<%= buyer.getEmail() %>)</p>
                <% } %>
                
                <% if (apartment != null) { %>
                <p><strong>Address:</strong> <%= apartment.getAddress() %></p>
                <p><strong>Price:</strong> Rs. <%= String.format("%.0f", apartment.getPrice()) %></p>
                <% } %>
                
                <% if ("Pending".equals(booking.getStatus())) { %>
                <button type="button" class="btn btn-confirm" onclick="updateBookingStatus('<%= booking.getBookingId() %>', 'Confirmed')">
                    <i class="fa-solid fa-check"></i> Confirm
                </button>
                <button type="button" class="btn btn-reject" onclick="updateBookingStatus('<%= booking.getBookingId() %>', 'Cancelled')">
                    <i class="fa-solid fa-times"></i> Reject
                </button>
                <% } %>
            </div>
        <%
            }
        }
        %>
        </div>
    </div>

    <script>
        function updateBookingStatus(bookingId, status) {
            const action = status === 'Confirmed' ? 'confirm' : 'reject';
            const message = status === 'Confirmed' ? 'confirm this booking' : 'reject this booking';
            
            if (confirm('Are you sure you want to ' + message + '?')) {
                fetch('SellerBookingsServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=updateStatus&bookingId=' + bookingId + '&status=' + status
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        if (status === 'Confirmed') {
                            // Show success popup for 1 second, then redirect to dashboard
                            showSuccessPopup('Booking confirmed successfully!', () => {
                                window.location.href = 'SellerDashboardServlet';
                            });
                        } else {
                            // For reject, just reload the page
                            location.reload();
                        }
                    } else if (data.startsWith('error:')) {
                        alert('Failed to ' + action + ' booking: ' + data.substring(6));
                    } else {
                        alert('Failed to ' + action + ' booking. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating booking status. Please try again.');
                });
            }
        }

        function showSuccessPopup(message, callback) {
            // Create popup element
            const popup = document.createElement('div');
            popup.className = 'success-popup';
            popup.innerHTML = '<span class="icon"><i class="fa-solid fa-check-circle"></i></span>' + message;
            
            // Add to page
            document.body.appendChild(popup);
            
            // Show for 1 second, then hide and execute callback
            setTimeout(() => {
                popup.classList.add('hide');
                setTimeout(() => {
                    document.body.removeChild(popup);
                    if (callback) callback();
                }, 300); // Wait for fade out animation
            }, 1000); // Show for 1 second
        }
    </script>
</body>
</html>