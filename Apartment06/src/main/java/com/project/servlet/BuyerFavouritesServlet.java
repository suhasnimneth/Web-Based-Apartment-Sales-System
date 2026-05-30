package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;
import com.project.model.Apartment;
import com.project.service.FavouriteService;
import com.project.service.ApartmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/BuyerFavouritesServlet")
public class BuyerFavouritesServlet extends HttpServlet {

    private FavouriteService favouriteService;
    private ApartmentService apartmentService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        favouriteService = new FavouriteService();
        apartmentService = new ApartmentService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a buyer
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get buyer ID for the current user
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                request.setAttribute("error", "Buyer profile not found");
                request.getRequestDispatcher("buyerfavourites.jsp").forward(request, response);
                return;
            }

            // Get all favourites for this buyer
            List<com.project.model.Favourite> favourites = favouriteService.getFavouritesByBuyer(buyerId);
            
            // Get apartment details for each favourite
            List<Apartment> favouriteApartments = new java.util.ArrayList<>();
            for (com.project.model.Favourite favourite : favourites) {
                Apartment apartment = apartmentService.getApartmentById(favourite.getApartmentId());
                if (apartment != null) {
                    favouriteApartments.add(apartment);
                }
            }

            request.setAttribute("favouriteApartments", favouriteApartments);
            request.setAttribute("favourites", favourites);
            request.getRequestDispatcher("buyerfavourites.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading favourites");
            request.getRequestDispatcher("buyerfavourites.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
