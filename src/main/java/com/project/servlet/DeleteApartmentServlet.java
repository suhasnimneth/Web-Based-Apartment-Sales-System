package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.UserDAO;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteApartmentServlet")
public class DeleteApartmentServlet extends HttpServlet {

    private ApartmentDAO apartmentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        apartmentDAO = new ApartmentDAO();
        userDAO = new UserDAO();
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
                request.setAttribute("errorMessage", "You don't have permission to delete this apartment.");
                request.getRequestDispatcher("myapartments.jsp").forward(request, response);
                return;
            }

            // Delete the apartment (this will also delete all associated images)
            boolean success = apartmentDAO.deleteApartment(apartmentId);
            
            if (success) {
                response.sendRedirect("MyApartmentsServlet?message=Apartment deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete apartment. Please try again.");
                request.getRequestDispatcher("MyApartmentsServlet").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while deleting apartment: " + e.getMessage());
            request.getRequestDispatcher("MyApartmentsServlet").forward(request, response);
        }
    }
}