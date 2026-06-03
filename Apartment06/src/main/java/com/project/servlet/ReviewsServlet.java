package com.project.servlet;

import com.project.DAO.ReviewDAO;
import com.project.model.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReviewsServlet")
public class ReviewsServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== ReviewsServlet.doGet() called ===");
        
        try {
            // Get all visible reviews
            List<Review> reviews = reviewDAO.getAllVisibleReviews();
            System.out.println("Found " + reviews.size() + " visible reviews");
            
            // Get average rating
            double averageRating = reviewDAO.getAverageRating();
            System.out.println("Average rating: " + averageRating);
            
            // Get total review count
            int totalReviews = reviewDAO.getTotalReviewCount();
            System.out.println("Total reviews: " + totalReviews);
            
            // Set attributes for the JSP
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalReviews", totalReviews);
            
        } catch (Exception e) {
            System.err.println("Error in ReviewsServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading reviews: " + e.getMessage());
        }
        
        // Forward to reviews.jsp
        request.getRequestDispatcher("reviews.jsp").forward(request, response);
    }
}