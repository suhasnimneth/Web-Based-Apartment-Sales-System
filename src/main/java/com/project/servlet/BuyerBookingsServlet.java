package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.Booking;
import com.project.model.User;
import com.project.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/BuyerBookingsServlet")
public class BuyerBookingsServlet extends HttpServlet {
    
    private BookingService bookingService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== BuyerBookingsServlet.doGet() called ===");
        
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
        
        if (!"buyer".equalsIgnoreCase(userRole)) {
            System.out.println("❌ User not authorized - role: " + userRole);
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("✅ User authorization validated for: " + user.getEmail());
        
        try {
            // Get buyer ID for the current user
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            
            if (buyerId == null) {
                System.out.println("❌ Buyer ID not found for user: " + user.getUserId());
                request.setAttribute("errorMessage", "You are not registered as a buyer.");
                request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
                return;
            }
            
            System.out.println("✅ Buyer ID found: " + buyerId);
            
            // Get all bookings for this buyer
            List<Booking> bookings = bookingService.getBookingsByBuyer(buyerId);
            
            System.out.println("✅ Retrieved " + bookings.size() + " bookings for buyer: " + buyerId);
            
            // Set bookings in request attributes
            request.setAttribute("bookings", bookings);
            request.setAttribute("buyerId", buyerId);
            
            // Forward to buyer bookings page
            System.out.println("Forwarding to buyerbookings.jsp");
            request.getRequestDispatcher("buyerbookings.jsp").forward(request, response);
            System.out.println("✅ Successfully forwarded to buyerbookings.jsp");
            
        } catch (Exception e) {
            System.err.println("❌ Error in BuyerBookingsServlet: " + e.getMessage());
            System.err.println("Exception type: " + e.getClass().getSimpleName());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
            
            request.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== BuyerBookingsServlet.doPost() called ===");
        
        // Handle booking cancellation
        String action = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");
        
        if ("cancel".equals(action) && bookingId != null && !bookingId.trim().isEmpty()) {
            System.out.println("Processing booking cancellation for ID: " + bookingId);
            
            try {
                // Check if user is logged in
                HttpSession session = request.getSession(false);
                if (session == null) {
                    response.getWriter().write("error: No session found");
                    return;
                }
                
                User user = (User) session.getAttribute("user");
                String userRole = (String) session.getAttribute("userRole");
                
                if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
                    response.getWriter().write("error: Unauthorized");
                    return;
                }
                
                // Get buyer ID
                String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
                if (buyerId == null) {
                    response.getWriter().write("error: Buyer not found");
                    return;
                }
                
                // Verify the booking belongs to this buyer
                Booking booking = bookingService.getBookingById(bookingId);
                if (booking == null) {
                    response.getWriter().write("error: Booking not found");
                    return;
                }
                
                if (!booking.getBuyerId().equals(buyerId)) {
                    response.getWriter().write("error: Unauthorized to cancel this booking");
                    return;
                }
                
                // Allow cancelling both Pending and Confirmed bookings
                if (!"Pending".equals(booking.getStatus()) && !"Confirmed".equals(booking.getStatus())) {
                    response.getWriter().write("error: Cannot cancel booking with status: " + booking.getStatus());
                    return;
                }
                
                // Cancel the booking by updating status to Cancelled
                boolean success = bookingService.updateBookingStatus(bookingId, "Cancelled");
                
                if (success) {
                    System.out.println("✅ Booking cancelled successfully: " + bookingId);
                    response.getWriter().write("success");
                } else {
                    System.out.println("❌ Failed to cancel booking: " + bookingId);
                    response.getWriter().write("error: Failed to cancel booking");
                }
                
            } catch (Exception e) {
                System.err.println("❌ Error cancelling booking: " + e.getMessage());
                System.err.println("Exception type: " + e.getClass().getSimpleName());
                System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
                response.getWriter().write("error: " + e.getMessage());
            }
        } else {
            System.out.println("❌ Invalid action or booking ID");
            response.getWriter().write("error: Invalid request");
        }
    }
}
