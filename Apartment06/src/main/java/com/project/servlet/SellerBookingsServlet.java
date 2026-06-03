package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.Booking;
import com.project.model.User;
import com.project.model.Apartment;
import com.project.service.BookingService;
import com.project.service.ApartmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/SellerBookingsServlet")
public class SellerBookingsServlet extends HttpServlet {
    
    private BookingService bookingService;
    private ApartmentService apartmentService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        apartmentService = new ApartmentService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== SellerBookingsServlet.doGet() called ===");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("❌ No session found, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null) {
            System.out.println("❌ User not found in session, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (!"seller".equalsIgnoreCase(userRole)) {
            System.out.println("❌ User not authorized - role: " + userRole);
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("✅ User authorization validated for: " + user.getEmail());
        
        try {
            // Get seller ID for the current user
            String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            
            if (sellerId == null) {
                System.out.println("❌ Seller ID not found for user: " + user.getUserId());
                request.setAttribute("errorMessage", "You are not registered as a seller.");
                request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
                return;
            }
            
            System.out.println("✅ Seller ID found: " + sellerId);
            
            // Get all bookings for this seller
            List<Booking> bookings = bookingService.getBookingsBySeller(sellerId);
            
            System.out.println("✅ Retrieved " + bookings.size() + " bookings for seller: " + sellerId);
            
            // Create a list to store booking details with apartment and buyer info
            List<Map<String, Object>> bookingDetails = new ArrayList<>();
            
            for (Booking booking : bookings) {
                Map<String, Object> bookingDetail = new HashMap<>();
                bookingDetail.put("booking", booking);
                
                // Get apartment details
                Apartment apartment = apartmentService.getApartmentById(booking.getApartmentId());
                bookingDetail.put("apartment", apartment);
                
                // Get buyer details
                String buyerUserId = userDAO.getUserIdByBuyerId(booking.getBuyerId());
                User buyer = userDAO.getUserById(buyerUserId);
                bookingDetail.put("buyer", buyer);
                
                bookingDetails.add(bookingDetail);
            }
            
            // Set bookings in request attributes
            request.setAttribute("bookingDetails", bookingDetails);
            request.setAttribute("bookings", bookings);
            request.setAttribute("sellerId", sellerId);
            
            // Forward to seller bookings page
            System.out.println("Forwarding to sellerbookings.jsp");
            try {
                request.getRequestDispatcher("sellerbookings.jsp").forward(request, response);
                System.out.println("✅ Successfully forwarded to sellerbookings.jsp");
            } catch (Exception jspException) {
                System.err.println("❌ JSP compilation error: " + jspException.getMessage());
                // Fallback: provide HTML response directly
                response.setContentType("text/html");
                response.getWriter().println("<html><head><title>Seller Bookings</title>");
                response.getWriter().println("<style>body{font-family:Arial,sans-serif;margin:20px;background:#f5f5f5;}");
                response.getWriter().println(".container{max-width:1200px;margin:0 auto;}");
                response.getWriter().println(".header{background:#667eea;color:white;padding:20px;border-radius:10px;text-align:center;margin-bottom:20px;}");
                response.getWriter().println(".booking-card{background:white;margin:15px 0;padding:20px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);}");
                response.getWriter().println(".no-bookings{text-align:center;padding:40px;color:#666;}");
                response.getWriter().println("</style></head><body>");
                response.getWriter().println("<div class='container'>");
                response.getWriter().println("<div class='header'>");
                response.getWriter().println("<h1>📋 Seller Bookings</h1>");
                response.getWriter().println("<p>Manage apartment viewing appointments</p>");
                response.getWriter().println("</div>");
                response.getWriter().println("<a href='SellerDashboardServlet' style='background:#667eea;color:white;padding:10px 20px;text-decoration:none;border-radius:5px;'>← Back to Dashboard</a>");
                
                if (bookings.isEmpty()) {
                    response.getWriter().println("<div class='no-bookings'>");
                    response.getWriter().println("<h3>No Bookings Yet</h3>");
                    response.getWriter().println("<p>You don't have any apartment viewing bookings yet.</p>");
                    response.getWriter().println("<a href='MyApartmentsServlet' style='background:#667eea;color:white;padding:10px 20px;text-decoration:none;border-radius:5px;'>View My Apartments</a>");
                    response.getWriter().println("</div>");
                } else {
                    response.getWriter().println("<p>Found " + bookings.size() + " bookings for seller: " + sellerId + "</p>");
                    for (Booking booking : bookings) {
                        response.getWriter().println("<div class='booking-card'>");
                        response.getWriter().println("<h3>Booking ID: " + booking.getBookingId() + "</h3>");
                        response.getWriter().println("<p><strong>Status:</strong> " + booking.getStatus() + "</p>");
                        response.getWriter().println("<p><strong>Date:</strong> " + booking.getBookingDate() + "</p>");
                        response.getWriter().println("<p><strong>Time:</strong> " + booking.getBookingTime() + "</p>");
                        response.getWriter().println("</div>");
                    }
                }
                
                response.getWriter().println("</div></body></html>");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in SellerBookingsServlet: " + e.getMessage());
            System.err.println("Exception type: " + e.getClass().getSimpleName());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            
            request.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== SellerBookingsServlet.doPost() called ===");
        
        // Handle booking status updates
        String action = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");
        String status = request.getParameter("status");
        
        if ("updateStatus".equals(action) && bookingId != null && !bookingId.trim().isEmpty() && status != null) {
            System.out.println("Processing booking status update for ID: " + bookingId + " to status: " + status);
            
            try {
                // Check if user is logged in
                HttpSession session = request.getSession(false);
                if (session == null) {
                    response.getWriter().write("error: No session found");
                    return;
                }
                
                User user = (User) session.getAttribute("user");
                String userRole = (String) session.getAttribute("userRole");
                
                if (user == null || !"seller".equalsIgnoreCase(userRole)) {
                    response.getWriter().write("error: Unauthorized");
                    return;
                }
                
                // Get seller ID
                String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
                if (sellerId == null) {
                    response.getWriter().write("error: Seller not found");
                    return;
                }
                
                // Verify the booking belongs to this seller
                Booking booking = bookingService.getBookingById(bookingId);
                if (booking == null) {
                    response.getWriter().write("error: Booking not found");
                    return;
                }
                
                if (!booking.getSellerId().equals(sellerId)) {
                    response.getWriter().write("error: Unauthorized to update this booking");
                    return;
                }
                
                // Update the booking status
                boolean success = bookingService.updateBookingStatus(bookingId, status);
                
                if (success) {
                    System.out.println("✅ Booking status updated successfully: " + bookingId + " to " + status);
                    response.getWriter().write("success");
                } else {
                    System.out.println("❌ Failed to update booking status: " + bookingId);
                    response.getWriter().write("error: Failed to update booking status");
                }
                
            } catch (Exception e) {
                System.err.println("❌ Error updating booking status: " + e.getMessage());
                System.err.println("Exception type: " + e.getClass().getSimpleName());
                System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
                response.getWriter().write("error: " + e.getMessage());
            }
        } else {
            System.out.println("❌ Invalid action or parameters");
            response.getWriter().write("error: Invalid request");
        }
    }
}
