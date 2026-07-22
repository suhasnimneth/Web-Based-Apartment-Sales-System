<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Apartment" %>
<%@ page import="com.project.model.User" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Apartment Viewing - Apartment Portal</title>
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

        .apartment-info {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }

        .apartment-info::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .apartment-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }

        .apartment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .detail-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
        }

        .detail-value {
            color: #333;
            font-size: 1rem;
        }

        .booking-form {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            position: relative;
            overflow: hidden;
        }

        .booking-form::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 1rem;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fff;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #6c757d;
            box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }

        .time-slot {
            padding: 10px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .time-slot:hover {
            border-color: #6c757d;
            background: #f8f9fa;
        }

        .time-slot.selected {
            border-color: #495057;
            background: #6c757d;
            color: white;
        }

        .time-slot input[type="radio"] {
            display: none;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
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

        .alert {
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 8px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        /* Popup Message Styles */
        .popup-message {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 20px 40px;
            border-radius: 25px;
            font-size: 1.2rem;
            font-weight: 600;
            box-shadow: 0 8px 30px rgba(230, 57, 70, 0.4);
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: popupFadeIn 0.3s ease-out;
        }

        .popup-message i {
            font-size: 1.3rem;
        }

        @keyframes popupFadeIn {
            0% {
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.8);
            }
            100% {
                opacity: 1;
                transform: translate(-50%, -50%) scale(1);
            }
        }

        @keyframes popupFadeOut {
            0% {
                opacity: 1;
                transform: translate(-50%, -50%) scale(1);
            }
            100% {
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.8);
            }
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }

            .content {
                padding: 20px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .apartment-details {
                grid-template-columns: 1fr;
            }

            .time-slots {
                grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
            }

            .form-actions {
                flex-direction: column;
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
                <h1 class="page-title"><i class="fa-solid fa-calendar-check"></i> Book Apartment Viewing</h1>
                <p class="page-subtitle">Schedule your visit to see this amazing apartment</p>
            </div>

            <div class="content-section">

            <% if (request.getAttribute("apartment") != null) { %>
                <% Apartment apartment = (Apartment) request.getAttribute("apartment"); %>
                <div class="apartment-info">
                    <h3><i class="fa-solid fa-home"></i> <%= apartment.getTitle() %></h3>
                    <div class="apartment-details">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-location-dot"></i> Address:</span>
                            <span class="detail-value"><%= apartment.getAddress() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-building"></i> City:</span>
                            <span class="detail-value"><%= apartment.getCity() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-dollar-sign"></i> Price:</span>
                            <span class="detail-value">Rs. <%= apartment.getPrice() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-bed"></i> Bedrooms:</span>
                            <span class="detail-value"><%= apartment.getBedrooms() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-bath"></i> Bathrooms:</span>
                            <span class="detail-value"><%= apartment.getBathrooms() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-ruler-combined"></i> Area:</span>
                            <span class="detail-value"><%= apartment.getAreaSqFt() %> sq ft</span>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <div class="apartment-info">
                    <h3><i class="fa-solid fa-home"></i> Apartment Information</h3>
                    <div class="apartment-details">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-location-dot"></i> Address:</span>
                            <span class="detail-value">Apartment details will be loaded</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-building"></i> City:</span>
                            <span class="detail-value">City information</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa-solid fa-dollar-sign"></i> Price:</span>
                            <span class="detail-value">Price information</span>
                        </div>
                    </div>
                </div>
            <% } %>

            <div class="booking-form">
                <form id="bookingForm" onsubmit="submitBooking(event)">
                    <!-- Hidden field for apartment ID -->
                    <input type="hidden" name="apartmentId" value="<%= request.getAttribute("apartment") != null ? ((Apartment) request.getAttribute("apartment")).getApartmentId() : "" %>">
                    
                    <div class="form-group">
                        <label for="bookingDate">Preferred Visit Date:</label>
                        <input type="date" id="bookingDate" name="bookingDate" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="bookingTime">Preferred Visit Time:</label>
                        <div class="time-slots">
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="07:00:00" required>
                                7:00 AM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="08:00:00" required>
                                8:00 AM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="09:00:00" required>
                                9:00 AM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="10:00:00" required>
                                10:00 AM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="11:00:00" required>
                                11:00 AM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="12:00:00" required>
                                12:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="13:00:00" required>
                                1:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="14:00:00" required>
                                2:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="15:00:00" required>
                                3:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="16:00:00" required>
                                4:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="17:00:00" required>
                                5:00 PM
                            </label>
                            <label class="time-slot">
                                <input type="radio" name="bookingTime" value="18:00:00" required>
                                6:00 PM
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Additional Notes (Optional):</label>
                        <textarea id="message" name="message" placeholder="Any special requests or questions..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="BuyerDashboardServlet" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-left"></i>
                            Go Back to Dashboard
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-calendar-check"></i>
                            Book Viewing
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Set minimum date to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('bookingDate').min = today;
        });

        // Handle time slot selection
        document.querySelectorAll('input[name="bookingTime"]').forEach(radio => {
            radio.addEventListener('change', function() {
                // Remove selected class from all time slots
                document.querySelectorAll('.time-slot').forEach(slot => {
                    slot.classList.remove('selected');
                });
                
                // Add selected class to the clicked time slot
                if (this.checked) {
                    this.closest('.time-slot').classList.add('selected');
                }
            });
        });

        function submitBooking(event) {
            event.preventDefault();
            
            // Get form data
            const form = document.getElementById('bookingForm');
            const formData = new FormData(form);
            
            // Get apartment ID from hidden field
            const apartmentId = formData.get('apartmentId');
            
            // Check if apartment ID is empty and try to get it from URL or session
            if (!apartmentId || apartmentId.trim() === '') {
                const urlParams = new URLSearchParams(window.location.search);
                const urlApartmentId = urlParams.get('apartmentId');
                
                if (urlApartmentId) {
                    formData.set('apartmentId', urlApartmentId);
                }
            }

            // Show "Request sent" popup immediately
            showPopupMessage('Request sent', 'success');

            // Convert FormData to URLSearchParams for proper handling
            const params = new URLSearchParams();
            for (let [key, value] of formData) {
                params.append(key, value);
            }

            fetch('BookingServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    showMessage('Viewing booked successfully! You will receive a confirmation soon.', 'success');
                    setTimeout(() => {
                        window.location.href = 'BuyerBookingsServlet';
                    }, 2000);
                } else if (data && data.startsWith('error:')) {
                    const msg = data.substring(6).trim();
                    // Normalize duplicate message text
                    const display = msg.toLowerCase().includes('time slot') || msg.toLowerCase().includes('duplicate')
                        ? 'time slot already booked'
                        : msg || 'An error occurred';
                    showMessage(display, 'error');
                } else {
                    showMessage('An unexpected response was received. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Booking error:', error);
                showMessage('An error occurred while processing your request. Please try again.', 'error');
            });
        }

        function showPopupMessage(message, type) {
            // Remove existing popup messages
            const existingPopups = document.querySelectorAll('.popup-message');
            existingPopups.forEach(popup => popup.remove());
            
            // Create new popup message
            const popup = document.createElement('div');
            popup.className = 'popup-message';
            popup.innerHTML = `
                <i class="fa-solid fa-check-circle"></i>
                ${message}
            `;
            
            // Add to body
            document.body.appendChild(popup);
            
            // Auto-hide after 1 second
            setTimeout(() => {
                popup.style.animation = 'popupFadeOut 0.3s ease-out';
                setTimeout(() => {
                    popup.remove();
                }, 300);
            }, 1000);
        }

        function showMessage(message, type) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert');
            existingAlerts.forEach(alert => alert.remove());
            
            // Create new alert
            const alert = document.createElement('div');
            alert.className = 'alert alert-' + type;
            alert.textContent = message;
            
            // Insert at top of content
            const content = document.querySelector('.content-section');
            content.insertBefore(alert, content.firstChild);
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                alert.remove();
            }, 5000);
        }
    </script>
</body>
</html>
