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

@WebServlet("/ListApartmentsServlet")
public class ListApartmentsServlet extends HttpServlet {
    
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
        out.println("<html><head><title>Available Apartments</title></head><body>");
        out.println("<h1>Available Apartments for Booking</h1>");
        
        try {
            List<Apartment> apartments = apartmentDAO.getAllApartments();
            
            if (apartments.isEmpty()) {
                out.println("<p style='color: red;'>❌ No apartments found in database!</p>");
                out.println("<p><a href='SetupApartmentDataServlet'>Create Sample Apartments</a></p>");
            } else {
                out.println("<p style='color: green;'>✅ Found " + apartments.size() + " apartments</p>");
                out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                out.println("<tr style='background-color: #f0f0f0;'>");
                out.println("<th style='padding: 10px;'>Apartment ID</th>");
                out.println("<th style='padding: 10px;'>Title</th>");
                out.println("<th style='padding: 10px;'>Address</th>");
                out.println("<th style='padding: 10px;'>City</th>");
                out.println("<th style='padding: 10px;'>Price</th>");
                out.println("<th style='padding: 10px;'>Action</th>");
                out.println("</tr>");
                
                for (Apartment apt : apartments) {
                    out.println("<tr>");
                    out.println("<td style='padding: 10px;'>" + apt.getApartmentId() + "</td>");
                    out.println("<td style='padding: 10px;'>" + apt.getTitle() + "</td>");
                    out.println("<td style='padding: 10px;'>" + apt.getAddress() + "</td>");
                    out.println("<td style='padding: 10px;'>" + apt.getCity() + "</td>");
                    out.println("<td style='padding: 10px;'>Rs. " + apt.getPrice() + "</td>");
                    out.println("<td style='padding: 10px;'>");
                    out.println("<a href='BookingFormServlet?apartmentId=" + apt.getApartmentId() + "' style='background: #dc2626; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px;'>Book Viewing</a>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>" + java.util.Arrays.toString(e.getStackTrace()) + "</pre>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='apartments.jsp'>Back to Apartments Page</a></p>");
        out.println("<p><a href='SetupApartmentDataServlet'>Setup Sample Data</a></p>");
        
        out.println("</body></html>");
    }
}
