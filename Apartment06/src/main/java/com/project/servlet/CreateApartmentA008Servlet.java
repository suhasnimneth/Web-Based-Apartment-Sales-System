package com.project.servlet;

import com.project.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/CreateApartmentA008Servlet")
public class CreateApartmentA008Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.println("<html><head><title>Create Apartment A008</title></head><body>");
        out.println("<h1>Create Apartment A008 (Sliit Apartment)</h1>");
        
        try {
            // Check if apartment A008 already exists
            String checkSql = "SELECT COUNT(*) FROM apartments WHERE apartmentId = 'A008'";
            boolean apartmentExists = false;
            
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(checkSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    apartmentExists = rs.getInt(1) > 0;
                }
            }
            
            if (apartmentExists) {
                out.println("<p style='color: green;'>✅ Apartment A008 already exists!</p>");
            } else {
                // Get a seller ID to use
                String sellerId = null;
                String getSellerSql = "SELECT TOP 1 sellerId FROM sellers";
                
                try (Connection conn = DBUtil.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(getSellerSql);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    if (rs.next()) {
                        sellerId = rs.getString("sellerId");
                    }
                }
                
                if (sellerId == null) {
                    out.println("<p style='color: red;'>❌ No sellers found. Cannot create apartment without a seller.</p>");
                    out.println("<p>Please create a seller account first.</p>");
                } else {
                    // Create apartment A008
                    String insertSql = "INSERT INTO apartments (apartmentId, sellerId, title, description, address, city, state, postalCode, contactNumber, propertyType, status, price, bedrooms, bathrooms, areaSqFt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    
                    try (Connection conn = DBUtil.getConnection();
                         PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                        
                        stmt.setString(1, "A008");
                        stmt.setString(2, sellerId);
                        stmt.setString(3, "Sliit");
                        stmt.setString(4, "Modern apartment near university");
                        stmt.setString(5, "sdsdsdds");
                        stmt.setString(6, "Matara");
                        stmt.setString(7, "Southern Province");
                        stmt.setString(8, "81000");
                        stmt.setString(9, "555-0123");
                        stmt.setString(10, "Apartment");
                        stmt.setString(11, "Available");
                        stmt.setBigDecimal(12, new java.math.BigDecimal("2000.00"));
                        stmt.setInt(13, 1); // 1 bedroom
                        stmt.setInt(14, 2); // 2 bathrooms
                        stmt.setInt(15, 10); // 10 sq ft
                        
                        int rowsAffected = stmt.executeUpdate();
                        if (rowsAffected > 0) {
                            out.println("<p style='color: green;'>✅ Apartment A008 created successfully!</p>");
                            out.println("<p><strong>Apartment Details:</strong></p>");
                            out.println("<ul>");
                            out.println("<li>ID: A008</li>");
                            out.println("<li>Title: Sliit</li>");
                            out.println("<li>Address: sdsdsdds</li>");
                            out.println("<li>City: Matara</li>");
                            out.println("<li>Price: Rs. 2000.00</li>");
                            out.println("<li>Bedrooms: 1</li>");
                            out.println("<li>Bathrooms: 2</li>");
                            out.println("<li>Area: 10 sq ft</li>");
                            out.println("</ul>");
                        } else {
                            out.println("<p style='color: red;'>❌ Failed to create apartment A008</p>");
                        }
                    }
                }
            }
            
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ SQL Error: " + e.getMessage() + "</p>");
            out.println("<pre>" + java.util.Arrays.toString(e.getStackTrace()) + "</pre>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='BookingFormServlet?apartmentId=A008'>Test Booking Form with A008</a></p>");
        out.println("<p><a href='apartments.jsp'>Back to Apartments</a></p>");
        
        out.println("</body></html>");
    }
}