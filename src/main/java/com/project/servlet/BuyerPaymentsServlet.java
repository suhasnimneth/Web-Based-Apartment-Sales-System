package com.project.servlet;

import com.project.model.Payment;
import com.project.model.Apartment;
import com.project.model.User;
import com.project.service.PaymentService;
import com.project.service.ApartmentService;
import com.project.DAO.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/BuyerPaymentsServlet")
public class BuyerPaymentsServlet extends HttpServlet {
    private PaymentService paymentService;
    private ApartmentService apartmentService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.paymentService = new PaymentService();
        this.apartmentService = new ApartmentService();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        // Check if user is logged in and is a buyer
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get buyer ID
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                request.setAttribute("errorMessage", "Buyer profile not found. Please contact administrator.");
                request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
                return;
            }

            // Get all payments for this buyer
            List<Payment> payments = paymentService.getPaymentsByBuyerId(buyerId);
            
            // Create a list to store payment details with apartment and seller info
            List<Map<String, Object>> paymentDetails = new ArrayList<>();
            
            for (Payment payment : payments) {
                Map<String, Object> paymentDetail = new HashMap<>();
                paymentDetail.put("payment", payment);
                
                // Get apartment details
                Apartment apartment = apartmentService.getApartmentById(payment.getApartmentId());
                paymentDetail.put("apartment", apartment);
                
                // Get seller details
                if (apartment != null) {
                    String sellerUserId = userDAO.getUserIdBySellerId(apartment.getSellerId());
                    User seller = userDAO.getUserById(sellerUserId);
                    paymentDetail.put("seller", seller);
                }
                
                paymentDetails.add(paymentDetail);
            }

            // Set request attributes
            request.setAttribute("paymentDetails", paymentDetails);
            request.setAttribute("payments", payments);

            // Forward to JSP
            request.getRequestDispatcher("buyerpayments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading payment details: " + e.getMessage());
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
        }
    }
}
