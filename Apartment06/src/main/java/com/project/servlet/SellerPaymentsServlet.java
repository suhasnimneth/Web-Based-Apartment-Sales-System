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

@WebServlet("/SellerPaymentsServlet")
public class SellerPaymentsServlet extends HttpServlet {
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

        // Check if user is logged in and is a seller
        if (user == null || !"seller".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get seller ID
            String sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            if (sellerId == null) {
                request.setAttribute("errorMessage", "Seller profile not found. Please contact administrator.");
                request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
                return;
            }

            // Get all payments for this seller
            List<Payment> payments = paymentService.getPaymentsBySellerId(sellerId);
            
            // Create a list to store payment details with apartment and buyer info
            List<Map<String, Object>> paymentDetails = new ArrayList<>();
            
            for (Payment payment : payments) {
                Map<String, Object> paymentDetail = new HashMap<>();
                paymentDetail.put("payment", payment);
                
                // Get apartment details
                Apartment apartment = apartmentService.getApartmentById(payment.getApartmentId());
                paymentDetail.put("apartment", apartment);
                
                // Get buyer details
                String buyerUserId = userDAO.getUserIdByBuyerId(payment.getBuyerId());
                System.out.println("Payment ID: " + payment.getPaymentId() + ", Buyer ID: " + payment.getBuyerId() + ", Buyer User ID: " + buyerUserId);
                User buyer = userDAO.getUserById(buyerUserId);
                System.out.println("Buyer User: " + (buyer != null ? buyer.getFirstName() + " " + buyer.getLastName() : "NULL"));
                paymentDetail.put("buyer", buyer);
                
                paymentDetails.add(paymentDetail);
            }

            // Set request attributes
            request.setAttribute("paymentDetails", paymentDetails);
            request.setAttribute("payments", payments);

            // Forward to JSP
            request.getRequestDispatcher("sellerpayments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading payment details: " + e.getMessage());
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
        }
    }
}
