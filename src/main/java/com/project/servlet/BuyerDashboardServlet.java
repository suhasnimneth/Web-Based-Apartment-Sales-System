package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.BookingDAO;
import com.project.DAO.FavouriteDAO;
import com.project.DAO.PaymentDAO;
import com.project.DAO.UserDAO;
import com.project.model.Apartment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/BuyerDashboardServlet")
public class BuyerDashboardServlet extends HttpServlet {

    private ApartmentDAO apartmentDAO;
    private BookingDAO bookingDAO;
    private FavouriteDAO favouriteDAO;
    private PaymentDAO paymentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.apartmentDAO = new ApartmentDAO();
        this.bookingDAO = new BookingDAO();
        this.favouriteDAO = new FavouriteDAO();
        this.paymentDAO = new PaymentDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        com.project.model.User user = (com.project.model.User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if this is an AJAX request for real-time data
        String ajaxRequest = request.getParameter("ajax");
        if ("true".equals(ajaxRequest)) {
            try {
                // Get buyer ID
                String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
                if (buyerId == null) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\": \"Buyer profile not found\"}");
                    return;
                }

                // Get buyer statistics
                int totalFavourites = favouriteDAO.getFavouriteCountByBuyer(buyerId);
                int totalBookings = bookingDAO.getBookingCountByBuyer(buyerId);
                int pendingBookings = bookingDAO.getPendingBookingCountByBuyer(buyerId);
                int totalPayments = paymentDAO.getPaymentCountByBuyer(buyerId);
                double totalSpent = paymentDAO.getTotalSpentByBuyer(buyerId);
                
                // Get suggested apartments count for AJAX
                List<Apartment> suggestedApartments = apartmentDAO.getSuggestedApartments(5);
                int suggestedCount = suggestedApartments != null ? suggestedApartments.size() : 0;

                // Return JSON response
                response.setContentType("application/json");
                response.getWriter().write(String.format(
                    "{\"totalFavourites\": %d, \"totalBookings\": %d, \"pendingBookings\": %d, \"totalPayments\": %d, \"totalSpent\": %.2f, \"suggestedApartmentsCount\": %d}",
                    totalFavourites, totalBookings, pendingBookings, totalPayments, totalSpent, suggestedCount
                ));
                return;

            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Error loading dashboard data\"}");
                return;
            }
        }

        try {
            // Get buyer ID
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                request.setAttribute("errorMessage", "Buyer profile not found.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Get buyer statistics
            int totalFavourites = favouriteDAO.getFavouriteCountByBuyer(buyerId);
            int totalBookings = bookingDAO.getBookingCountByBuyer(buyerId);
            int pendingBookings = bookingDAO.getPendingBookingCountByBuyer(buyerId);
            int totalPayments = paymentDAO.getPaymentCountByBuyer(buyerId);
            double totalSpent = paymentDAO.getTotalSpentByBuyer(buyerId);

            // Get suggested apartments (up to 5 apartments)
            List<Apartment> suggestedApartments = apartmentDAO.getSuggestedApartments(5);

            // Set attributes for the dashboard
            request.setAttribute("totalFavourites", totalFavourites);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("totalPayments", totalPayments);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("suggestedApartments", suggestedApartments);

            // Forward to buyer dashboard
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
        }
    }
}
