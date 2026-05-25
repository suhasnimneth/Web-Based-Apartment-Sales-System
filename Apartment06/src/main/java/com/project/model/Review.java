package com.project.model;

import java.time.LocalDateTime;

public class Review {
    private String reviewId;        // R001, R002, etc.
    private String buyerId;         // B001, B002, etc.
    private int rating;             // 1-5 stars
    private String title;           // Review title
    private String reviewText;      // Review content
    private boolean isVisible;      // Whether review is visible
    private LocalDateTime createdAt; // When review was created
    private LocalDateTime updatedAt; // When review was last updated
    
    // Additional fields for display
    private String buyerName;       // Buyer's name for display
    private String buyerEmail;      // Buyer's email for display

    // Constructors
    public Review() {}

    public Review(String buyerId, int rating, String title, String reviewText) {
        this.buyerId = buyerId;
        this.rating = rating;
        this.title = title;
        this.reviewText = reviewText;
        this.isVisible = true;
    }

    // Getters and Setters
    public String getReviewId() { return reviewId; }
    public void setReviewId(String reviewId) { this.reviewId = reviewId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public boolean isVisible() { return isVisible; }
    public void setVisible(boolean visible) { isVisible = visible; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }

    public String getBuyerEmail() { return buyerEmail; }
    public void setBuyerEmail(String buyerEmail) { this.buyerEmail = buyerEmail; }

    // Helper methods
    public String getStarRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    public String getRatingText() {
        switch (rating) {
            case 1: return "Poor";
            case 2: return "Fair";
            case 3: return "Good";
            case 4: return "Very Good";
            case 5: return "Excellent";
            default: return "Unknown";
        }
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId='" + reviewId + '\'' +
                ", buyerId='" + buyerId + '\'' +
                ", rating=" + rating +
                ", title='" + title + '\'' +
                ", reviewText='" + reviewText + '\'' +
                ", isVisible=" + isVisible +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
