package com.project.servlet;

import com.project.DAO.ReviewDAO;
import com.project.model.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminReviewManagementServlet")
public class AdminReviewManagementServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminReviewManagementServlet.doGet() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Object admin = session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            System.out.println("Admin not logged in, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        try {
            // Get all reviews
            List<Review> reviews = reviewDAO.getAllReviews();
            
            // Calculate statistics
            double averageRating = reviewDAO.getAverageRating();
            int totalReviews = reviewDAO.getTotalReviews();
            int visibleReviews = (int) reviews.stream().filter(Review::isVisible).count();
            int hiddenReviews = totalReviews - visibleReviews;
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("visibleReviews", visibleReviews);
            request.setAttribute("hiddenReviews", hiddenReviews);
            
            // Forward to review management page
            request.getRequestDispatcher("adminreviewmanagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminReviewManagementServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load review management page");
            request.getRequestDispatcher("admindashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminReviewManagementServlet.doPost() called ===");
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Object admin = session.getAttribute("admin");
        String userRole = (String) session.getAttribute("userRole");
        
        if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        try {
            if ("toggle".equals(action)) {
                handleToggleReview(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteReview(request, response);
            } else if ("update".equals(action)) {
                handleUpdateReview(request, response);
            } else {
                System.out.println("Invalid action: " + action);
                response.getWriter().write("error: Invalid action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminReviewManagementServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void handleToggleReview(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String reviewId = request.getParameter("reviewId");
        
        System.out.println("Toggling review visibility - ID: " + reviewId);
        
        if (reviewId == null || reviewId.trim().isEmpty()) {
            response.getWriter().write("error: Review ID is required");
            return;
        }
        
        // Get existing review
        Review review = reviewDAO.getReviewById(reviewId);
        if (review == null) {
            response.getWriter().write("error: Review not found");
            return;
        }
        
        // Toggle visibility
        review.setVisible(!review.isVisible());
        
        // Update review
        boolean success = reviewDAO.updateReview(review);
        
        if (success) {
            System.out.println("✅ Review visibility toggled successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Review visibility toggle failed");
            response.getWriter().write("error: Failed to toggle review visibility");
        }
    }
    
    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String reviewId = request.getParameter("reviewId");
        
        System.out.println("Deleting review - ID: " + reviewId);
        
        if (reviewId == null || reviewId.trim().isEmpty()) {
            response.getWriter().write("error: Review ID is required");
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
    }
    
    private void handleUpdateReview(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String reviewId = request.getParameter("reviewId");
        String title = request.getParameter("title");
        String reviewText = request.getParameter("reviewText");
        String ratingStr = request.getParameter("rating");
        
        System.out.println("Updating review - ID: " + reviewId);
        
        if (reviewId == null || reviewId.trim().isEmpty()) {
            response.getWriter().write("error: Review ID is required");
            return;
        }
        
        // Get existing review
        Review review = reviewDAO.getReviewById(reviewId);
        if (review == null) {
            response.getWriter().write("error: Review not found");
            return;
        }
        
        // Update fields if provided
        if (title != null && !title.trim().isEmpty()) {
            review.setTitle(title.trim());
        }
        if (reviewText != null && !reviewText.trim().isEmpty()) {
            review.setReviewText(reviewText.trim());
        }
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                int rating = Integer.parseInt(ratingStr);
                if (rating >= 1 && rating <= 5) {
                    review.setRating(rating);
                } else {
                    response.getWriter().write("error: Rating must be between 1 and 5");
                    return;
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("error: Invalid rating format");
                return;
            }
        }
        
        // Update review
        boolean success = reviewDAO.updateReview(review);
        
        if (success) {
            System.out.println("✅ Review updated successfully");
            response.getWriter().write("success");
        } else {
            System.out.println("❌ Review update failed");
            response.getWriter().write("error: Failed to update review");
        }
    }
}
