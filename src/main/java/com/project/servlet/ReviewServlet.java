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

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== ReviewServlet.doPost() called ===");
        
        // Check if user is logged in and is a buyer
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        System.out.println("Session user: " + (user != null ? user.getEmail() : "null"));
        System.out.println("User role: " + userRole);
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            System.out.println("User not authorized - user: " + (user != null) + ", role: " + userRole);
            response.getWriter().write("unauthorized");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        // Debug: Log all parameters
        System.out.println("=== All Request Parameters ===");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println(paramName + ": " + paramValue);
        }
        System.out.println("=== End Parameters ===");

        try {
            // Get buyer ID for the current user
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            System.out.println("User ID: " + user.getUserId());
            System.out.println("Buyer ID: " + buyerId);
            
            if (buyerId == null) {
                System.out.println("Buyer ID is null - user might not be a buyer");
                response.getWriter().write("error: User not registered as buyer");
                return;
            }

            if ("add".equals(action)) {
                handleAddReview(request, response, buyerId);
            } else if ("update".equals(action)) {
                handleUpdateReview(request, response, buyerId);
            } else if ("delete".equals(action)) {
                handleDeleteReview(request, response, buyerId);
            } else {
                System.out.println("Invalid action received: " + action);
                response.getWriter().write("error: Invalid action. Received: " + (action != null ? action : "null"));
            }

        } catch (Exception e) {
            System.err.println("Review error: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== ReviewServlet.doGet() called ===");
        
        // Check if this is a test request
        String test = request.getParameter("test");
        if ("true".equals(test)) {
            response.setContentType("text/plain");
            response.getWriter().write("ReviewServlet is working! Parameters received:\n");
            
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                response.getWriter().write(paramName + " = " + paramValue + "\n");
            }
            return;
        }
        
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

            // Check if buyer already has a review
            Review existingReview = reviewDAO.getReviewByBuyerId(buyerId);
            
            if (existingReview != null) {
                // Redirect to update review page
                response.sendRedirect("updatereview.jsp?reviewId=" + existingReview.getReviewId());
            } else {
                // Redirect to add review page
                response.sendRedirect("addreview.jsp");
            }

        } catch (Exception e) {
            System.err.println("Error in ReviewServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("addreview.jsp");
        }
    }

    private void handleAddReview(HttpServletRequest request, HttpServletResponse response, String buyerId) 
            throws IOException {
        
        String ratingStr = request.getParameter("rating");
        String title = request.getParameter("title");
        String reviewText = request.getParameter("reviewText");

        System.out.println("Received parameters:");
        System.out.println("  rating: " + ratingStr);
        System.out.println("  title: " + title);
        System.out.println("  reviewText: " + reviewText);

        if (ratingStr == null || ratingStr.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            reviewText == null || reviewText.trim().isEmpty()) {
            System.out.println("Missing required parameters");
            response.getWriter().write("error: Missing required parameters");
            return;
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            
            if (rating < 1 || rating > 5) {
                response.getWriter().write("error: Rating must be between 1 and 5");
                return;
            }

            // Check if buyer already has a review
            Review existingReview = reviewDAO.getReviewByBuyerId(buyerId);
            if (existingReview != null) {
                response.getWriter().write("error: You already have a review. Please update it instead.");
                return;
            }

            // Create new review
            Review review = new Review(buyerId, rating, title, reviewText);
            String reviewId = reviewDAO.createReview(review);
            
            if (reviewId != null) {
                System.out.println("✅ Review created successfully with ID: " + reviewId);
                response.getWriter().write("success");
            } else {
                System.out.println("❌ Review creation failed");
                response.getWriter().write("error: Failed to create review");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("error: Invalid rating format");
        }
    }

    private void handleUpdateReview(HttpServletRequest request, HttpServletResponse response, String buyerId) 
            throws IOException {
        
        String reviewId = request.getParameter("reviewId");
        String ratingStr = request.getParameter("rating");
        String title = request.getParameter("title");
        String reviewText = request.getParameter("reviewText");

        System.out.println("Update parameters:");
        System.out.println("  reviewId: " + reviewId);
        System.out.println("  rating: " + ratingStr);
        System.out.println("  title: " + title);
        System.out.println("  reviewText: " + reviewText);

        if (reviewId == null || reviewId.trim().isEmpty() ||
            ratingStr == null || ratingStr.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            reviewText == null || reviewText.trim().isEmpty()) {
            System.out.println("Missing required parameters for update");
            response.getWriter().write("error: Missing required parameters");
            return;
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            
            if (rating < 1 || rating > 5) {
                response.getWriter().write("error: Rating must be between 1 and 5");
                return;
            }

            // Verify the review belongs to this buyer
            Review existingReview = reviewDAO.getReviewById(reviewId);
            if (existingReview == null || !existingReview.getBuyerId().equals(buyerId)) {
                response.getWriter().write("error: Review not found or you don't have permission to update it");
                return;
            }

            // Update review
            existingReview.setRating(rating);
            existingReview.setTitle(title);
            existingReview.setReviewText(reviewText);
            
            boolean success = reviewDAO.updateReview(existingReview);
            
            if (success) {
                System.out.println("✅ Review updated successfully");
                response.getWriter().write("success");
            } else {
                System.out.println("❌ Review update failed");
                response.getWriter().write("error: Failed to update review");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("error: Invalid rating format");
        }
    }

    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response, String buyerId) 
            throws IOException {
        
        String reviewId = request.getParameter("reviewId");

        System.out.println("Delete parameters:");
        System.out.println("  reviewId: " + reviewId);
        System.out.println("  buyerId: " + buyerId);

        if (reviewId == null || reviewId.trim().isEmpty()) {
            System.out.println("Missing reviewId parameter for delete");
            response.getWriter().write("error: Missing review ID");
            return;
        }

        try {
            // Verify the review belongs to this buyer
            Review existingReview = reviewDAO.getReviewById(reviewId);
            if (existingReview == null) {
                response.getWriter().write("error: Review not found");
                return;
            }
            
            if (!existingReview.getBuyerId().equals(buyerId)) {
                response.getWriter().write("error: You don't have permission to delete this review");
                return;
            }

            // Delete review
            boolean success = reviewDAO.deleteReview(reviewId);
            
            if (success) {
                System.out.println("✅ Review deleted successfully");
                response.getWriter().write("success");
            } else {
                System.out.println("❌ Review deletion failed");
                response.getWriter().write("error: Failed to delete review");
            }

        } catch (Exception e) {
            System.err.println("Error deleting review: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
}