package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.UserDAO;
import com.project.model.Apartment;
import com.project.model.ApartmentImage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewApartmentServlet")
public class ViewApartmentServlet extends HttpServlet {

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
        
        String apartmentId = request.getParameter("id");
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Apartment ID is required.");
            request.getRequestDispatcher("apartments.jsp").forward(request, response);
            return;
        }

        try {
            // Get the apartment details
            Apartment apartment = apartmentDAO.getApartmentById(apartmentId);
            if (apartment == null) {
                request.setAttribute("errorMessage", "Apartment not found.");
                request.getRequestDispatcher("apartments.jsp").forward(request, response);
                return;
            }

            // Get apartment images
            List<ApartmentImage> images = apartmentDAO.getApartmentImages(apartmentId);
            apartment.setImages(images);

            // Get seller contact information
            String sellerUserId = userDAO.getUserIdBySellerId(apartment.getSellerId());
            if (sellerUserId != null) {
                com.project.model.User seller = userDAO.getUserById(sellerUserId);
                if (seller != null) {
                    request.setAttribute("sellerContact", seller.getContactNumber());
                    request.setAttribute("sellerEmail", seller.getEmail());
                }
            }

            // Set apartment data for the detail view
            request.setAttribute("apartment", apartment);
            request.getRequestDispatcher("apartmentdetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading apartment details: " + e.getMessage());
            request.getRequestDispatcher("apartments.jsp").forward(request, response);
        }
    }
}
