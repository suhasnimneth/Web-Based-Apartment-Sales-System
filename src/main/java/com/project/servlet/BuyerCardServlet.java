package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;
import com.project.model.BuyerCard;
import com.project.service.BuyerCardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/BuyerCardServlet")
public class BuyerCardServlet extends HttpServlet {

    private BuyerCardService buyerCardService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        buyerCardService = new BuyerCardService();
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
                request.setAttribute("errorMessage", "Buyer profile not found");
                request.getRequestDispatcher("buyercard.jsp").forward(request, response);
                return;
            }

            // Get all cards for this buyer
            List<BuyerCard> buyerCards = buyerCardService.getCardsByBuyerId(buyerId);

            // Check for message parameter
            String message = request.getParameter("message");
            if (message != null && !message.trim().isEmpty()) {
                request.setAttribute("infoMessage", message);
            }

            request.setAttribute("buyerCards", buyerCards);
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading cards");
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a buyer
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            // Get buyer ID for the current user
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                request.setAttribute("errorMessage", "Buyer profile not found");
                request.getRequestDispatcher("buyercard.jsp").forward(request, response);
                return;
            }

            if ("add".equals(action)) {
                handleAddCard(request, response, buyerId);
            } else if ("update".equals(action)) {
                handleUpdateCard(request, response, buyerId);
            } else if ("delete".equals(action)) {
                handleDeleteCard(request, response, buyerId);
            } else {
                request.setAttribute("errorMessage", "Invalid action");
                request.getRequestDispatcher("buyercard.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);
        }
    }

    private void handleAddCard(HttpServletRequest request, HttpServletResponse response, String buyerId)
            throws ServletException, IOException {
        
        String cardholderName = request.getParameter("cardholderName");
        String cardNumber = request.getParameter("cardNumber");
        String cvv = request.getParameter("cvv");
        String expiryDateStr = request.getParameter("expiryDate");
        String amountStr = request.getParameter("amountInCard");

        try {
            // Parse expiry date
            LocalDate expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
                expiryDate = LocalDate.parse(expiryDateStr);
            }
            
            // Parse amount
            BigDecimal amount = BigDecimal.ZERO;
            if (amountStr != null && !amountStr.trim().isEmpty()) {
                amount = new BigDecimal(amountStr);
            }

            // Comprehensive validation
            String validationError = buyerCardService.validateCardData(cardholderName, cardNumber, cvv, expiryDate, amount);
            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("buyercard.jsp").forward(request, response);
                return;
            }

            // Add the card
            String buyerCardId = buyerCardService.addBuyerCard(buyerId, cardholderName, cardNumber, cvv, expiryDate, amount);
            
            if (buyerCardId != null) {
                request.setAttribute("successMessage", "Card added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add card. Please check your information.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid amount format. Please enter a valid number.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding card: " + e.getMessage());
        }

        // Redirect to GET to reload the page
        response.sendRedirect("BuyerCardServlet");
    }

    private void handleUpdateCard(HttpServletRequest request, HttpServletResponse response, String buyerId)
            throws ServletException, IOException {
        
        String buyerCardId = request.getParameter("buyerCardId");
        String cardholderName = request.getParameter("cardholderName");
        String cardNumber = request.getParameter("cardNumber");
        String cvv = request.getParameter("cvv");
        String expiryDateStr = request.getParameter("expiryDate");
        String amountStr = request.getParameter("amountInCard");

        // Check if card belongs to buyer first
        if (!buyerCardService.isCardOwnedByBuyer(buyerCardId, buyerId)) {
            request.setAttribute("errorMessage", "Card not found or access denied");
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);
            return;
        }

        try {
            // Parse expiry date
            LocalDate expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
                expiryDate = LocalDate.parse(expiryDateStr);
            }
            
            // Parse amount
            BigDecimal amount = BigDecimal.ZERO;
            if (amountStr != null && !amountStr.trim().isEmpty()) {
                amount = new BigDecimal(amountStr);
            }

            // Comprehensive validation
            String validationError = buyerCardService.validateCardData(cardholderName, cardNumber, cvv, expiryDate, amount);
            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("buyercard.jsp").forward(request, response);
                return;
            }

            // Update the card
            boolean success = buyerCardService.updateBuyerCard(buyerCardId, cardholderName, cardNumber, cvv, expiryDate, amount);
            
            if (success) {
                request.setAttribute("successMessage", "Card updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update card. Please check your information.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid amount format. Please enter a valid number.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating card: " + e.getMessage());
        }

        // Redirect to GET to reload the page
        response.sendRedirect("BuyerCardServlet");
    }

    private void handleDeleteCard(HttpServletRequest request, HttpServletResponse response, String buyerId)
            throws ServletException, IOException {
        
        String buyerCardId = request.getParameter("buyerCardId");

        if (buyerCardId == null || buyerCardId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Card ID is required");
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);
            return;
        }

        // Check if card belongs to buyer
        if (!buyerCardService.isCardOwnedByBuyer(buyerCardId, buyerId)) {
            request.setAttribute("errorMessage", "Card not found or access denied");
            request.getRequestDispatcher("buyercard.jsp").forward(request, response);
            return;
        }

        try {
            // Delete the card
            boolean success = buyerCardService.deleteBuyerCard(buyerCardId);
            
            if (success) {
                request.setAttribute("successMessage", "Card deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete card.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting card: " + e.getMessage());
        }

        // Redirect to GET to reload the page
        response.sendRedirect("BuyerCardServlet");
    }
}
