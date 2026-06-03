package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;
import com.project.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/SetupApartmentDataServlet")
public class SetupApartmentDataServlet extends HttpServlet {
    
    private ApartmentDAO apartmentDAO;
    
    @Override
    public void init() throws ServletException {
        apartmentDAO = new ApartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.println("<html><head><title>Setup Apartment Data</title></head><body>");
        out.println("<h1>Setup Apartment Data for Testing</h1>");
        
        try {
            // Step 1: Check database connection
            out.println("<h2>Step 1: Database Connection Test</h2>");
            Connection conn = DBUtil.getConnection();
            if (conn != null) {
                out.println("<p style='color: green;'>✅ Database connection successful</p>");
                conn.close();
            } else {
                out.println("<p style='color: red;'>❌ Database connection failed</p>");
                return;
            }
            
            // Step 2: Check if apartments exist
            out.println("<h2>Step 2: Check Existing Apartments</h2>");
            String countSql = "SELECT COUNT(*) FROM apartments";
            try (Connection conn2 = DBUtil.getConnection();
                 PreparedStatement stmt = conn2.prepareStatement(countSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    int apartmentCount = rs.getInt(1);
                    out.println("<p>Existing apartments: " + apartmentCount + "</p>");
                    
                    if (apartmentCount == 0) {
                        out.println("<p style='color: orange;'>⚠️ No apartments found. Creating sample data...</p>");
                        createSampleData(out);
                    } else {
                        out.println("<p style='color: green;'>✅ Apartments exist in database</p>");
                    }
                }
            }
            
            // Step 3: Test apartment retrieval
            out.println("<h2>Step 3: Test Apartment Retrieval</h2>");
            String testApartmentId = "A001";
            Apartment testApartment = apartmentDAO.getApartmentById(testApartmentId);
            
            if (testApartment != null) {
                out.println("<p style='color: green;'>✅ Successfully retrieved apartment " + testApartmentId + "</p>");
                out.println("<p><strong>Apartment Details:</strong></p>");
                out.println("<ul>");
                out.println("<li>ID: " + testApartment.getApartmentId() + "</li>");
                out.println("<li>Title: " + testApartment.getTitle() + "</li>");
                out.println("<li>Seller ID: " + testApartment.getSellerId() + "</li>");
                out.println("<li>Price: " + testApartment.getPrice() + "</li>");
                out.println("</ul>");
            } else {
                out.println("<p style='color: red;'>❌ Failed to retrieve apartment " + testApartmentId + "</p>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>" + java.util.Arrays.toString(e.getStackTrace()) + "</pre>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='ApartmentTestServlet'>View All Apartments</a></p>");
        out.println("<p><a href='BookingFormServlet?apartmentId=A001'>Test Booking Form with A001</a></p>");
        out.println("<p><a href='apartments.jsp'>Back to Apartments</a></p>");
        
        out.println("</body></html>");
    }
    
    private void createSampleData(PrintWriter out) {
        try {
            // First, check if we have a seller
            String sellerCheckSql = "SELECT TOP 1 sellerId FROM sellers";
            String sellerId = null;
            
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sellerCheckSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    sellerId = rs.getString("sellerId");
                    out.println("<p>Using existing seller: " + sellerId + "</p>");
                } else {
                    out.println("<p style='color: red;'>❌ No sellers found. Cannot create apartments without a seller.</p>");
                    out.println("<p>Please create a seller account first.</p>");
                    return;
                }
            }
            
            // Create sample apartments
            String[] apartmentIds = {"A001", "A002", "A003", "A008"};
            String[] titles = {"Modern Downtown Apartment", "Cozy Suburban Home", "Luxury Penthouse", "Sliit Apartment"};
            String[] descriptions = {"Beautiful modern apartment in downtown area", "Cozy home perfect for families", "Luxury penthouse with city views", "Modern apartment near university"};
            String[] addresses = {"123 Main St", "456 Oak Ave", "789 Sky Tower", "sdsdsdds"};
            String[] cities = {"New York", "Boston", "Chicago", "Matara"};
            BigDecimal[] prices = {new BigDecimal("2500.00"), new BigDecimal("1800.00"), new BigDecimal("4500.00"), new BigDecimal("2000.00")};
            
            for (int i = 0; i < apartmentIds.length; i++) {
                // Check if apartment already exists
                String checkSql = "SELECT COUNT(*) FROM apartments WHERE apartmentId = ?";
                try (Connection conn = DBUtil.getConnection();
                     PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    
                    checkStmt.setString(1, apartmentIds[i]);
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            out.println("<p>Apartment " + apartmentIds[i] + " already exists, skipping...</p>");
                            continue;
                        }
                    }
                }
                
                // Insert apartment
                String insertSql = "INSERT INTO apartments (apartmentId, sellerId, title, description, address, city, state, postalCode, contactNumber, propertyType, status, price, bedrooms, bathrooms, areaSqFt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (Connection conn = DBUtil.getConnection();
                     PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    
                    insertStmt.setString(1, apartmentIds[i]);
                    insertStmt.setString(2, sellerId);
                    insertStmt.setString(3, titles[i]);
                    insertStmt.setString(4, descriptions[i]);
                    insertStmt.setString(5, addresses[i]);
                    insertStmt.setString(6, cities[i]);
                    insertStmt.setString(7, "NY");
                    insertStmt.setString(8, "10001");
                    insertStmt.setString(9, "555-0123");
                    insertStmt.setString(10, "Apartment");
                    insertStmt.setString(11, "Available");
                    insertStmt.setBigDecimal(12, prices[i]);
                    
                    // Set different bedroom/bathroom/area values for different apartments
                    if (i == 3) { // A008 - Sliit Apartment
                        insertStmt.setInt(13, 1); // 1 bedroom
                        insertStmt.setInt(14, 2); // 2 bathrooms
                        insertStmt.setInt(15, 10); // 10 sq ft
                    } else {
                        insertStmt.setInt(13, 2); // 2 bedrooms
                        insertStmt.setInt(14, 1); // 1 bathroom
                        insertStmt.setInt(15, 1200); // 1200 sq ft
                    }
                    
                    int rowsAffected = insertStmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<p style='color: green;'>✅ Created apartment " + apartmentIds[i] + ": " + titles[i] + "</p>");
                    } else {
                        out.println("<p style='color: red;'>❌ Failed to create apartment " + apartmentIds[i] + "</p>");
                    }
                }
            }
            
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ SQL Error creating sample data: " + e.getMessage() + "</p>");
            out.println("<pre>" + java.util.Arrays.toString(e.getStackTrace()) + "</pre>");
        }
    }
}
