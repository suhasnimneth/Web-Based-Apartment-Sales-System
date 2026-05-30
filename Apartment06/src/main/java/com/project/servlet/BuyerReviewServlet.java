package com.project.servlet;

import com.project.DAO.ReviewDAO;
import com.project.DAO.UserDAO;
import com.project.model.Review;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/BuyerReviewServlet")
public class BuyerReviewServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== BuyerReviewServlet.doGet() called ===");
        
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
                response.sendRedirect("login.jsp");
                return;
            }

            // Forward to review management page
            request.getRequestDispatcher("buyerreviewmanagement.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in BuyerReviewServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("addreview.jsp");
        }
    }
}
