package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.BookingDAO;
import com.project.DAO.PaymentDAO;
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
import java.util.List;

@WebServlet("/SellerDashboardServlet")
public class SellerDashboardServlet extends HttpServlet {

    private ApartmentDAO apartmentDAO;
    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.apartmentDAO = new ApartmentDAO();
        this.bookingDAO = new BookingDAO();
        this.paymentDAO = new PaymentDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"seller".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if this is an AJAX request for real-time data
        String ajaxRequest = request.getParameter("ajax");
        if ("true".equals(ajaxRequest)) {
            try {
                // Get seller ID
                String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
                if (sellerId == null) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\": \"Seller profile not found\"}");
                    return;
                }

                // Get seller statistics
                int totalApartments = apartmentDAO.getApartmentCountBySeller(sellerId);
                int totalBookings = bookingDAO.getBookingCountBySeller(sellerId);
                int pendingBookings = bookingDAO.getPendingBookingCountBySeller(sellerId);
                int totalPayments = paymentDAO.getPaymentCountBySeller(sellerId);
                double totalEarnings = paymentDAO.getTotalEarningsBySeller(sellerId);

                // Return JSON response
                response.setContentType("application/json");
                response.getWriter().write(String.format(
                    "{\"totalApartments\": %d, \"totalBookings\": %d, \"pendingBookings\": %d, \"totalPayments\": %d, \"totalEarnings\": %.2f}",
                    totalApartments, totalBookings, pendingBookings, totalPayments, totalEarnings
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
            // Get seller ID
            String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            if (sellerId == null) {
                request.setAttribute("errorMessage", "Seller profile not found.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Get seller statistics
            int totalApartments = apartmentDAO.getApartmentCountBySeller(sellerId);
            int totalBookings = bookingDAO.getBookingCountBySeller(sellerId);
            int pendingBookings = bookingDAO.getPendingBookingCountBySeller(sellerId);
            int totalPayments = paymentDAO.getPaymentCountBySeller(sellerId);
            double totalEarnings = paymentDAO.getTotalEarningsBySeller(sellerId);

            // Get recent apartments (latest 5)
            List<Apartment> recentApartments = apartmentDAO.getRecentApartmentsBySeller(sellerId, 5);

            // Set attributes for the dashboard
            request.setAttribute("totalApartments", totalApartments);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("totalPayments", totalPayments);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("recentApartments", recentApartments);

            // Forward to seller dashboard
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
        }
    }
}
