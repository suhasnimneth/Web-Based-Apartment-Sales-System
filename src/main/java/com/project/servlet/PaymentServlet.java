package com.project.servlet;

import com.project.model.User;
import com.project.model.Apartment;
import com.project.model.BuyerCard;
import com.project.service.PaymentService;
import com.project.service.ApartmentService;
import com.project.service.BuyerCardService;
import com.project.DAO.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private PaymentService paymentService;
    private ApartmentService apartmentService;
    private BuyerCardService buyerCardService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.paymentService = new PaymentService();
        this.apartmentService = new ApartmentService();
        this.buyerCardService = new BuyerCardService();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== PaymentServlet GET Request ===");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        System.out.println("User: " + (user != null ? user.getFirstName() + " " + user.getLastName() : "null"));
        System.out.println("UserRole: " + userRole);

        // Check if user is logged in and is a buyer
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            System.out.println("User not logged in or not a buyer, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        String apartmentId = request.getParameter("apartmentId");
        System.out.println("ApartmentId: " + apartmentId);
        
        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            System.out.println("Missing apartmentId parameter");
            request.setAttribute("errorMessage", "Apartment ID is required");
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
            return;
        }

        try {
            // Get apartment details
            Apartment apartment = apartmentService.getApartmentById(apartmentId);
            System.out.println("Apartment found: " + (apartment != null));
            if (apartment == null) {
                System.out.println("Apartment not found for ID: " + apartmentId);
                request.setAttribute("errorMessage", "Apartment not found");
                request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
                return;
            }
            // Block payment if apartment is sold
            if (apartment.getStatus() != null && apartment.getStatus().equalsIgnoreCase("Sold")) {
                request.setAttribute("errorMessage", "This apartment is already sold. Payments are not allowed.");
                request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
                return;
            }

            // Get buyer's cards
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            System.out.println("BuyerId: " + buyerId);
            
            if (buyerId == null) {
                System.out.println("Buyer profile not found for user: " + user.getUserId());
                request.setAttribute("errorMessage", "Buyer profile not found. Please contact administrator.");
                request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
                return;
            }
            
            List<BuyerCard> buyerCards = buyerCardService.getCardsByBuyerId(buyerId);
            System.out.println("BuyerCards count: " + buyerCards.size());
            
            if (buyerCards.isEmpty()) {
                System.out.println("No payment cards found for buyer: " + buyerId);
                response.sendRedirect("BuyerCardServlet?message=" + 
                    java.net.URLEncoder.encode("Please add a payment card first to make payments", "UTF-8"));
                return;
            }

            // Get seller details
            User seller = userDAO.getUserById(userDAO.getUserIdBySellerId(apartment.getSellerId()));
            System.out.println("Seller found: " + (seller != null));
            
            // Calculate payment amounts for each type
            BigDecimal advanceAmount = paymentService.calculatePaymentAmount("advance", apartment.getPrice());
            BigDecimal installmentAmount = paymentService.calculatePaymentAmount("installment", apartment.getPrice());
            BigDecimal halfAmount = paymentService.calculatePaymentAmount("half", apartment.getPrice());
            
            System.out.println("Apartment price: " + apartment.getPrice());
            System.out.println("Advance amount: " + advanceAmount);
            System.out.println("Installment amount: " + installmentAmount);
            System.out.println("Half amount: " + halfAmount);

            // Set request attributes
            request.setAttribute("apartment", apartment);
            request.setAttribute("buyerCards", buyerCards);
            request.setAttribute("seller", seller);
            request.setAttribute("advanceAmount", advanceAmount);
            request.setAttribute("installmentAmount", installmentAmount);
            request.setAttribute("halfAmount", halfAmount);

            System.out.println("Forwarding to buyerpaymentsform.jsp");
            request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Exception occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading payment form: " + e.getMessage());
            request.getRequestDispatcher("buyerdashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== PaymentServlet POST Request ===");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        // Check if user is logged in and is a buyer
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String apartmentId = request.getParameter("apartmentId");
        String buyerCardId = request.getParameter("buyerCardId");
        String paymentType = request.getParameter("paymentType");

        System.out.println("ApartmentId: " + apartmentId);
        System.out.println("BuyerCardId: " + buyerCardId);
        System.out.println("PaymentType: " + paymentType);

        try {
            // Get buyer ID
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());

            // Validate payment data
            String validationError = paymentService.validatePaymentData(buyerId, apartmentId, buyerCardId, paymentType);
            if (validationError != null) {
                System.out.println("Validation error: " + validationError);
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);
                return;
            }

            // Double check sold status on POST
            Apartment apartment = apartmentService.getApartmentById(apartmentId);
            if (apartment != null && apartment.getStatus() != null && apartment.getStatus().equalsIgnoreCase("Sold")) {
                request.setAttribute("errorMessage", "This apartment is already sold. Payments are not allowed.");
                request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);
                return;
            }

            // Process payment
            String result = paymentService.processPayment(buyerId, apartmentId, buyerCardId, paymentType);
            System.out.println("Payment result: " + result);
            
            if (result.contains("successfully")) {
                // Payment successful - stay on payment form with success message
                System.out.println("Payment successful, staying on payment form with success message");
                request.setAttribute("paymentSuccess", result);
                request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);
            } else {
                // Payment failed - stay on payment form with error message
                System.out.println("Payment failed, staying on payment form");
                request.setAttribute("errorMessage", result);
                request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Payment processing failed: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Payment processing failed: " + e.getMessage());
            request.getRequestDispatcher("buyerpaymentsform.jsp").forward(request, response);
        }
    }
}