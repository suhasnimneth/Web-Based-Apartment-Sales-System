<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - Apartment Portal</title>
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

        .content-section {
            padding: 30px;
        }

        .nav-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .nav-link {
            color: #e63946;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 25px;
            transition: all 0.3s ease;
            font-weight: 600;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 1rem;
        }

        .nav-link:hover {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .nav-link.active {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .nav-link.active:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .bookings-grid {
            display: grid;
            gap: 25px;
        }

        .booking-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
            overflow: hidden;
            opacity: 1;
            transform: scale(1);
        }

        .booking-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .booking-card[style*="display: none"] {
            opacity: 0;
            transform: scale(0.95);
        }

        .booking-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .booking-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-confirmed {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
        }

        .detail-label {
            font-size: 0.85rem;
            color: #666;
            font-weight: 500;
            margin-bottom: 4px;
        }

        .detail-value {
            font-size: 1rem;
            color: #333;
            font-weight: 600;
        }

        .booking-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
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

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
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
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .empty-state a:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 10px;
            }
            
            .bookings-container {
                padding: 20px;
            }
            
            .page-header {
                padding: 30px 20px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
            
            .booking-actions {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <a href="BuyerDashboardServlet" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="container">
            <div class="page-header">
                <h1 class="page-title"><i class="fa-solid fa-calendar-check"></i> My Bookings</h1>
                <p class="page-subtitle">Track your apartment viewing appointments</p>
            </div>

            <div class="content-section">
                <div class="nav-links">
                    <button class="nav-link active" data-status="all">All Bookings</button>
                    <button class="nav-link" data-status="Pending">Pending</button>
                    <button class="nav-link" data-status="Confirmed">Confirmed</button>
                    <button class="nav-link" data-status="Cancelled">Cancelled</button>
                </div>

                <%
                List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                if (bookings == null || bookings.isEmpty()) {
                %>
                    <div class="empty-state">
                        <h2>No Bookings Found</h2>
                        <p>You haven't made any apartment viewing bookings yet.</p>
                        <a href="AllApartmentsServlet">
                            <i class="fa-solid fa-building"></i>
                            Browse Apartments
                        </a>
                    </div>
                <%
                } else {
                %>
                    <div class="bookings-grid">
                        <%
                        for (Booking booking : bookings) {
                            String statusClass = "status-" + booking.getStatus().toLowerCase();
                        %>
                            <div class="booking-card" data-status="<%= booking.getStatus() %>">
                                <div class="booking-header">
                                    <div>
                                        <div class="booking-title">Apartment Viewing</div>
                                        <div class="booking-id">ID: <%= booking.getBookingId() %></div>
                                    </div>
                                    <span class="status-badge <%= statusClass %>"><%= booking.getStatus() %></span>
                                </div>

                                <div class="booking-details">
                                    <div class="detail-item">
                                        <span class="detail-label">Date</span>
                                        <span class="detail-value"><%= booking.getBookingDate() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Time</span>
                                        <span class="detail-value"><%= booking.getBookingTime() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Apartment ID</span>
                                        <span class="detail-value"><%= booking.getApartmentId() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Created</span>
                                        <span class="detail-value"><%= booking.getCreatedAt() != null ? booking.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "N/A" %></span>
                                    </div>
                                </div>

                                <div class="booking-actions">
                                    <a href="ViewApartmentServlet?id=<%= booking.getApartmentId() %>" class="btn btn-primary">
                                        <i class="fa-solid fa-eye"></i>
                                        View Apartment
                                    </a>
                                    <% if ("Pending".equals(booking.getStatus()) || "Confirmed".equals(booking.getStatus())) { %>
                                        <button onclick="console.log('Button clicked, bookingId:', '<%= booking.getBookingId() %>'); cancelBooking('<%= booking.getBookingId() %>', this)" class="btn btn-danger">
                                            <i class="fa-solid fa-times"></i>
                                            Cancel Booking
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                        <%
                        }
                        %>
                    </div>
                <%
                }
                %>
            </div>
        </div>
    </div>

    <script>
        function cancelBooking(bookingId, buttonElement) {
            console.log('cancelBooking function called with bookingId:', bookingId);
            
            // Create a more detailed confirmation dialog
            const confirmationMessage = `Are you sure you want to cancel this booking?\n\nThis action will:\n• Update the booking status to "Cancelled"\n• Remove it from your active bookings\n• Notify the seller about the cancellation\n\nThis action cannot be undone.`;
            
            if (confirm(confirmationMessage)) {
                console.log('User confirmed cancellation');
                // Show loading state
                const cancelBtn = buttonElement;
                const originalText = cancelBtn.textContent;
                cancelBtn.textContent = 'Cancelling...';
                cancelBtn.disabled = true;
                
                fetch('BuyerBookingsServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&bookingId=' + bookingId
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        // Show success message
                        alert('✅ Booking cancelled successfully!');
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('❌ Failed to cancel booking: ' + data.substring(6));
                    } else {
                        alert('❌ Failed to cancel booking. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('❌ Error cancelling booking. Please try again.');
                })
                .finally(() => {
                    // Restore button state
                    cancelBtn.textContent = originalText;
                    cancelBtn.disabled = false;
                });
            }
        }

        // Filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.nav-link');
            const bookingCards = document.querySelectorAll('.booking-card');
            const bookingsGrid = document.querySelector('.bookings-grid');

            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Get the status to filter by
                    const status = this.getAttribute('data-status');
                    
                    // Filter booking cards
                    let visibleCount = 0;
                    bookingCards.forEach(card => {
                        const cardStatus = card.getAttribute('data-status');
                        
                        if (status === 'all' || cardStatus === status) {
                            card.style.display = 'block';
                            visibleCount++;
                        } else {
                            card.style.display = 'none';
                        }
                    });
                    
                    // Show/hide no bookings message
                    const noBookingsMsg = document.querySelector('.empty-state');
                    if (visibleCount === 0) {
                        if (!noBookingsMsg) {
                            const noBookingsDiv = document.createElement('div');
                            noBookingsDiv.className = 'empty-state';
                            noBookingsDiv.innerHTML = `
                                <h2>No ${status === 'all' ? '' : status} Bookings Found</h2>
                                <p>You don't have any ${status === 'all' ? '' : status.toLowerCase()} bookings at the moment.</p>
                                <a href="AllApartmentsServlet">
                                    <i class="fa-solid fa-building"></i>
                                    Browse Apartments
                                </a>
                            `;
                            bookingsGrid.appendChild(noBookingsDiv);
                        } else {
                            noBookingsMsg.querySelector('h2').textContent = `No ${status === 'all' ? '' : status} Bookings Found`;
                            noBookingsMsg.querySelector('p').textContent = `You don't have any ${status === 'all' ? '' : status.toLowerCase()} bookings at the moment.`;
                            noBookingsMsg.style.display = 'block';
                        }
                    } else {
                        if (noBookingsMsg) {
                            noBookingsMsg.style.display = 'none';
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>