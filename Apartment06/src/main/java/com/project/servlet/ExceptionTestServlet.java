package com.project.servlet;

import com.project.DAO.BookingDAO;
import com.project.model.Booking;
import com.project.service.BookingService;
import com.project.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/ExceptionTestServlet")
public class ExceptionTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Exception Handling Test</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }");
        out.println(".container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".success { color: #28a745; font-weight: bold; }");
        out.println(".error { color: #dc3545; font-weight: bold; }");
        out.println(".warning { color: #ffc107; font-weight: bold; }");
        out.println(".info { color: #17a2b8; font-weight: bold; }");
        out.println(".test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }");
        out.println(".test-section h3 { margin-top: 0; color: #333; }");
        out.println("pre { background-color: #f8f9fa; padding: 10px; border-radius: 5px; overflow-x: auto; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🧪 Exception Handling Test Suite</h1>");

        // Test 1: BookingDAO Exception Handling
        out.println("<div class='test-section'>");
        out.println("<h3>1. BookingDAO Exception Handling Tests</h3>");
        testBookingDAOExceptions(out);
        out.println("</div>");

        // Test 2: BookingService Exception Handling
        out.println("<div class='test-section'>");
        out.println("<h3>2. BookingService Exception Handling Tests</h3>");
        testBookingServiceExceptions(out);
        out.println("</div>");

        // Test 3: Database Constraint Tests
        out.println("<div class='test-section'>");
        out.println("<h3>3. Database Constraint Exception Tests</h3>");
        testDatabaseConstraintExceptions(out);
        out.println("</div>");

        out.println("<div class='test-section'>");
        out.println("<h3>📋 Exception Test Summary</h3>");
        out.println("<p class='info'>All exception handling scenarios have been tested.</p>");
        out.println("<p><a href='BookingDebugServlet'>🔍 Run Debug Analysis</a> | <a href='BookingSystemTestServlet'>🧪 Run Complete Test</a></p>");
        out.println("</div>");

        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void testBookingDAOExceptions(PrintWriter out) {
        BookingDAO bookingDAO = new BookingDAO();
        
        out.println("<h4>Test 1.1: Null Booking Object</h4>");
        try {
            String result = bookingDAO.createBooking(null);
            out.println("<p class='success'>✅ Null booking handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Null booking not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 1.2: Invalid Booking Data</h4>");
        try {
            Booking invalidBooking = new Booking(null, null, null, null, null, null);
            String result = bookingDAO.createBooking(invalidBooking);
            out.println("<p class='success'>✅ Invalid booking data handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Invalid booking data not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 1.3: Conflict Detection with Invalid Data</h4>");
        try {
            boolean hasConflict = bookingDAO.hasBookingConflict(null, null, null);
            out.println("<p class='success'>✅ Conflict detection with null data handled correctly: " + hasConflict + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Conflict detection with null data not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 1.4: Past Date Booking</h4>");
        try {
            Booking pastBooking = new Booking("B001", "S001", "A001", 
                LocalDate.now().minusDays(1), LocalTime.of(14, 0), "Past date test");
            String result = bookingDAO.createBooking(pastBooking);
            out.println("<p class='success'>✅ Past date booking handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Past date booking not handled: " + e.getMessage() + "</p>");
        }
    }

    private void testBookingServiceExceptions(PrintWriter out) {
        BookingService bookingService = new BookingService();
        
        out.println("<h4>Test 2.1: Service Validation</h4>");
        try {
            Booking invalidBooking = new Booking(null, "S001", "A001", 
                LocalDate.now().plusDays(1), LocalTime.of(14, 0), "Test");
            String result = bookingService.createBooking(invalidBooking);
            out.println("<p class='success'>✅ Service validation handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Service validation not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 2.2: Empty Apartment ID</h4>");
        try {
            Booking emptyApartmentBooking = new Booking("B001", "S001", "", 
                LocalDate.now().plusDays(1), LocalTime.of(14, 0), "Test");
            String result = bookingService.createBooking(emptyApartmentBooking);
            out.println("<p class='success'>✅ Empty apartment ID handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Empty apartment ID not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 2.3: Past Date Validation</h4>");
        try {
            Booking pastDateBooking = new Booking("B001", "S001", "A001", 
                LocalDate.now().minusDays(1), LocalTime.of(14, 0), "Test");
            String result = bookingService.createBooking(pastDateBooking);
            out.println("<p class='success'>✅ Past date validation handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Past date validation not handled: " + e.getMessage() + "</p>");
        }
    }

    private void testDatabaseConstraintExceptions(PrintWriter out) {
        out.println("<h4>Test 3.1: Foreign Key Constraint Violations</h4>");
        
        BookingDAO bookingDAO = new BookingDAO();
        
        // Test invalid buyer
        try {
            Booking invalidBuyerBooking = new Booking("INVALID_BUYER", "S001", "A001", 
                LocalDate.now().plusDays(1), LocalTime.of(14, 0), "Invalid buyer test");
            String result = bookingDAO.createBooking(invalidBuyerBooking);
            out.println("<p class='success'>✅ Invalid buyer constraint handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Invalid buyer constraint not handled: " + e.getMessage() + "</p>");
        }

        // Test invalid seller
        try {
            Booking invalidSellerBooking = new Booking("B001", "INVALID_SELLER", "A001", 
                LocalDate.now().plusDays(1), LocalTime.of(14, 0), "Invalid seller test");
            String result = bookingDAO.createBooking(invalidSellerBooking);
            out.println("<p class='success'>✅ Invalid seller constraint handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Invalid seller constraint not handled: " + e.getMessage() + "</p>");
        }

        // Test invalid apartment
        try {
            Booking invalidApartmentBooking = new Booking("B001", "S001", "INVALID_APARTMENT", 
                LocalDate.now().plusDays(1), LocalTime.of(14, 0), "Invalid apartment test");
            String result = bookingDAO.createBooking(invalidApartmentBooking);
            out.println("<p class='success'>✅ Invalid apartment constraint handled correctly: " + result + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Invalid apartment constraint not handled: " + e.getMessage() + "</p>");
        }

        out.println("<h4>Test 3.2: Database Connection Test</h4>");
        try (Connection conn = DBUtil.getConnection()) {
            if (conn != null) {
                out.println("<p class='success'>✅ Database connection successful</p>");
                
                // Test constraint violations directly
                try (Statement stmt = conn.createStatement()) {
                    // This should fail due to date constraint
                    stmt.executeUpdate("INSERT INTO bookings (buyerId, sellerId, apartmentId, bookingDate, bookingTime, message, status) " +
                        "SELECT TOP 1 buyerId, 'S001', 'A001', '2020-01-01', '14:00:00', 'Test', 'Pending' FROM buyers");
                    out.println("<p class='warning'>⚠️ Date constraint not enforced - this should have failed</p>");
                } catch (Exception e) {
                    if (e.getMessage().contains("CK_bookings_date")) {
                        out.println("<p class='success'>✅ Date constraint properly enforced</p>");
                    } else {
                        out.println("<p class='error'>❌ Unexpected constraint error: " + e.getMessage() + "</p>");
                    }
                }
            } else {
                out.println("<p class='error'>❌ Database connection failed</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>❌ Database connection test failed: " + e.getMessage() + "</p>");
        }
    }
}
