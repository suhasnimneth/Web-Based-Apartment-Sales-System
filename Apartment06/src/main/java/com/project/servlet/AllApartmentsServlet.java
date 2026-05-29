package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AllApartmentsServlet")
public class AllApartmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get search parameters from URL
            String location = request.getParameter("location");
            String city = request.getParameter("city");
            String propertyType = request.getParameter("propertyType");
            String bedrooms = request.getParameter("bedrooms");
            String bathrooms = request.getParameter("bathrooms");
            String priceRange = request.getParameter("priceRange");
            String status = request.getParameter("status");

            // Parse price range
            Double minPrice = null;
            Double maxPrice = null;

            if (priceRange != null && !priceRange.trim().isEmpty()) {
                if (priceRange.equals("0-100000")) {
                    minPrice = 0.0;
                    maxPrice = 100000.0;
                } else if (priceRange.equals("100000-200000")) {
                    minPrice = 100000.0;
                    maxPrice = 200000.0;
                } else if (priceRange.equals("200000+")) {
                    minPrice = 200000.0;
                    maxPrice = null;
                }
            }

            // Get apartments
            List<Apartment> apartments = null;
            try {
                com.project.service.ApartmentService apartmentService = new com.project.service.ApartmentService();

                // Check if any filters are active
                boolean hasFilters = (location != null && !location.trim().isEmpty()) ||
                        (city != null && !city.trim().isEmpty()) ||
                        (propertyType != null && !propertyType.trim().isEmpty()) ||
                        (bedrooms != null && !bedrooms.trim().isEmpty()) ||
                        (bathrooms != null && !bathrooms.trim().isEmpty()) ||
                        minPrice != null || maxPrice != null ||
                        (status != null && !status.trim().isEmpty());

                if (!hasFilters) {
                    // No filters - get all apartments
                    apartments = apartmentService.getAllApartments();
                } else {
                    // Apply filters
                    apartments = apartmentService.searchApartments(
                            location, city,
                            minPrice != null ? String.valueOf(minPrice) : null,
                            maxPrice != null ? String.valueOf(maxPrice) : null,
                            propertyType, bedrooms, bathrooms,
                            status
                    );
                }
            } catch (Exception e) {
                e.printStackTrace();
                apartments = new java.util.ArrayList<>();
            }
            
            // Set apartments data for the listing view
            request.setAttribute("apartments", apartments);
            request.getRequestDispatcher("apartments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            
            // Determine redirect based on user role
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String userRole = (String) session.getAttribute("userRole");
            
            String redirectPage = "index.jsp"; // Default fallback
            
            if (user != null && "buyer".equalsIgnoreCase(userRole)) {
                redirectPage = "buyerdashboard.jsp";
            } else if (user != null && "seller".equalsIgnoreCase(userRole)) {
                redirectPage = "sellerdashboard.jsp";
            }
            
            request.setAttribute("errorMessage", "An error occurred while loading apartments: " + e.getMessage());
            request.getRequestDispatcher(redirectPage).forward(request, response);
        }
    }
}
