package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;
import com.project.model.User;
import com.project.service.FavouriteService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/FavouriteServlet")
public class FavouriteServlet extends HttpServlet {

    private FavouriteService favouriteService;
    private UserDAO userDAO;
    private ApartmentDAO apartmentDAO;

    @Override
    public void init() throws ServletException {
        favouriteService = new FavouriteService();
        userDAO = new UserDAO();
        apartmentDAO = new ApartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a buyer
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.getWriter().write("unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String apartmentId = request.getParameter("apartmentId");

        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            response.getWriter().write("error");
            return;
        }

        try {
            // Get buyer ID for the current user
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                response.getWriter().write("error");
                return;
            }

            if ("check".equals(action)) {
                // Check if apartment is in favorites
                boolean isFavourite = favouriteService.isFavourite(buyerId, apartmentId);
                response.getWriter().write(String.valueOf(isFavourite));
                return;
            }

            boolean success = false;

            if ("add".equals(action)) {
                // Prevent favouriting sold apartments
                Apartment ap = apartmentDAO.getApartmentById(apartmentId);
                if (ap != null && ap.getStatus() != null && ap.getStatus().equalsIgnoreCase("Sold")) {
                    response.getWriter().write("error");
                    return;
                }
                String favouriteId = favouriteService.addFavourite(buyerId, apartmentId);
                success = favouriteId != null;
            } else if ("remove".equals(action)) {
                success = favouriteService.removeFavourite(buyerId, apartmentId);
            } else {
                response.getWriter().write("error");
                return;
            }

            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
