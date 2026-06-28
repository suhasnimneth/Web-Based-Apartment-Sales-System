package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/ApartmentTestServlet")
public class ApartmentTestServlet extends HttpServlet {
    
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
        out.println("<html><head><title>Apartment Test</title></head><body>");
        out.println("<h1>Apartment Database Test</h1>");
        
        try {
            // Test 1: Get all apartments
            out.println("<h2>Test 1: All Apartments</h2>");
            List<Apartment> allApartments = apartmentDAO.getAllApartments();
            out.println("<p>Total apartments found: " + allApartments.size() + "</p>");
            
            if (allApartments.isEmpty()) {
                out.println("<p style='color: red;'>❌ No apartments found in database!</p>");
                out.println("<p>This explains why apartment ID retrieval is failing.</p>");
            } else {
                out.println("<table border='1' style='border-collapse: collapse;'>");
                out.println("<tr><th>Apartment ID</th><th>Title</th><th>Seller ID</th><th>Price</th><th>Status</th></tr>");
                
                for (Apartment apt : allApartments) {
                    out.println("<tr>");
                    out.println("<td>" + apt.getApartmentId() + "</td>");
                    out.println("<td>" + apt.getTitle() + "</td>");
                    out.println("<td>" + apt.getSellerId() + "</td>");
                    out.println("<td>" + apt.getPrice() + "</td>");
                    out.println("<td>" + apt.getStatus() + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                
                // Test 2: Get first apartment by ID
                if (!allApartments.isEmpty()) {
                    String firstApartmentId = allApartments.get(0).getApartmentId();
                    out.println("<h2>Test 2: Get Apartment by ID (" + firstApartmentId + ")</h2>");
                    
                    Apartment apartment = apartmentDAO.getApartmentById(firstApartmentId);
                    if (apartment != null) {
                        out.println("<p style='color: green;'>✅ Apartment found successfully!</p>");
                        out.println("<p><strong>Details:</strong></p>");
                        out.println("<ul>");
                        out.println("<li>ID: " + apartment.getApartmentId() + "</li>");
                        out.println("<li>Title: " + apartment.getTitle() + "</li>");
                        out.println("<li>Seller ID: " + apartment.getSellerId() + "</li>");
                        out.println("<li>Price: " + apartment.getPrice() + "</li>");
                        out.println("<li>Status: " + apartment.getStatus() + "</li>");
                        out.println("</ul>");
                    } else {
                        out.println("<p style='color: red;'>❌ Failed to retrieve apartment by ID!</p>");
                    }
                }
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>" + java.util.Arrays.toString(e.getStackTrace()) + "</pre>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='BookingFormServlet?apartmentId=A001'>Test BookingFormServlet with A001</a></p>");
        out.println("<p><a href='BookingFormServlet?apartmentId=A002'>Test BookingFormServlet with A002</a></p>");
        out.println("<p><a href='apartments.jsp'>Back to Apartments</a></p>");
        
        out.println("</body></html>");
    }
}
