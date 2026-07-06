package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.UserDAO;
import com.project.model.Apartment;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/EditApartmentServlet")
public class EditApartmentServlet extends HttpServlet {

    private ApartmentDAO apartmentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        apartmentDAO = new ApartmentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a seller
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"seller".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String apartmentId = request.getParameter("id");
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Apartment ID is required.");
            request.getRequestDispatcher("myapartments.jsp").forward(request, response);
            return;
        }

        try {
            // Get the apartment details
            Apartment apartment = apartmentDAO.getApartmentById(apartmentId);
            if (apartment == null) {
                request.setAttribute("errorMessage", "Apartment not found.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Get seller ID for the current user
            String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            if (sellerId == null) {
                request.setAttribute("errorMessage", "Seller profile not found.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Verify that the apartment belongs to this seller
            if (!apartmentDAO.isApartmentOwnedBySeller(apartmentId, sellerId)) {
                request.setAttribute("errorMessage", "You don't have permission to edit this apartment.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Set apartment data for the edit form
            request.setAttribute("apartment", apartment);
            request.getRequestDispatcher("editapartment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading apartment details: " + e.getMessage());
            request.getRequestDispatcher("myapartments.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a seller
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"seller".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String apartmentId = request.getParameter("apartmentId");
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Apartment ID is required.");
            request.getRequestDispatcher("myapartments.jsp").forward(request, response);
            return;
        }

        try {
            // Get seller ID for the current user
            String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            if (sellerId == null) {
                request.setAttribute("errorMessage", "Seller profile not found.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Verify that the apartment belongs to this seller
            if (!apartmentDAO.isApartmentOwnedBySeller(apartmentId, sellerId)) {
                request.setAttribute("errorMessage", "You don't have permission to edit this apartment.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Get form parameters
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String contactNumber = request.getParameter("contactNumber");
            String priceStr = request.getParameter("price");
            String bedroomsStr = request.getParameter("bedrooms");
            String bathroomsStr = request.getParameter("bathrooms");
            String areaSqFtStr = request.getParameter("areaSqft");
            String underMaintenance = request.getParameter("underMaintenance");

            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Title is required.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }
            if (description == null || description.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Description is required.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Address is required.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }
            if (city == null || city.trim().isEmpty()) {
                request.setAttribute("errorMessage", "City is required.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Price is required.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }

            // Parse numeric values
            BigDecimal price;
            Integer bedrooms = null;
            Integer bathrooms = null;
            Integer areaSqFt = null;

            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("errorMessage", "Price must be greater than 0.");
                    request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid price format.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                return;
            }

            if (bedroomsStr != null && !bedroomsStr.trim().isEmpty()) {
                try {
                    bedrooms = Integer.parseInt(bedroomsStr);
                    if (bedrooms <= 0) {
                        request.setAttribute("errorMessage", "Bedrooms must be greater than 0.");
                        request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid bedrooms format.");
                    request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                    return;
                }
            }

            if (bathroomsStr != null && !bathroomsStr.trim().isEmpty()) {
                try {
                    bathrooms = Integer.parseInt(bathroomsStr);
                    if (bathrooms <= 0) {
                        request.setAttribute("errorMessage", "Bathrooms must be greater than 0.");
                        request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid bathrooms format.");
                    request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                    return;
                }
            }

            if (areaSqFtStr != null && !areaSqFtStr.trim().isEmpty()) {
                try {
                    areaSqFt = Integer.parseInt(areaSqFtStr);
                    if (areaSqFt <= 0) {
                        request.setAttribute("errorMessage", "Area must be greater than 0.");
                        request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid area format.");
                    request.getRequestDispatcher("editapartment.jsp").forward(request, response);
                    return;
                }
            }

            // Create apartment object with updated data
            Apartment apartment = new Apartment();
            apartment.setApartmentId(apartmentId);
            apartment.setSellerId(sellerId);
            apartment.setTitle(title.trim());
            apartment.setDescription(description.trim());
            apartment.setAddress(address.trim());
            apartment.setCity(city.trim());
            apartment.setContactNumber(contactNumber != null ? contactNumber.trim() : null);
            apartment.setPrice(price);
            apartment.setBedrooms(bedrooms);
            apartment.setBathrooms(bathrooms);
            apartment.setAreaSqFt(areaSqFt);

            // Update status based on maintenance checkbox
            if (underMaintenance != null) {
                apartment.setStatus("Under Maintenance");
            }

            // Update the apartment
            boolean success = apartmentDAO.updateApartment(apartment);

            // If maintenance toggled, persist status explicitly
            if (success && underMaintenance != null) {
                apartmentDAO.updateApartmentStatus(apartmentId, "Under Maintenance");
            } else if (success && underMaintenance == null) {
                // If unchecked and previously maintenance, optionally set back to Available
                // Only flip back if current status is Under Maintenance
                Apartment current = apartmentDAO.getApartmentById(apartmentId);
                if (current != null && current.getStatus() != null && current.getStatus().toLowerCase().contains("maintenance")) {
                    apartmentDAO.updateApartmentStatus(apartmentId, "Available");
                }
            }
            
            if (success) {
                // Set success message and redirect to seller dashboard
                request.setAttribute("successMessage", "Apartment updated successfully!");
                request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update apartment. Please try again.");
                request.getRequestDispatcher("editapartment.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating apartment: " + e.getMessage());
            request.getRequestDispatcher("editapartment.jsp").forward(request, response);
        }
    }
}
