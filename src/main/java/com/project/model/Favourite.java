package com.project.model;

import java.time.LocalDateTime;

public class Favourite {
    private String favouriteId; // e.g., F001
    private String buyerId;     // e.g., B001
    private String apartmentId; // e.g., A001
    private LocalDateTime createdAt;

    // Constructors
    public Favourite() {}

    public Favourite(String buyerId, String apartmentId) {
        this.buyerId = buyerId;
        this.apartmentId = apartmentId;
        this.createdAt = LocalDateTime.now();
    }

    public Favourite(String favouriteId, String buyerId, String apartmentId, LocalDateTime createdAt) {
        this.favouriteId = favouriteId;
        this.buyerId = buyerId;
        this.apartmentId = apartmentId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public String getFavouriteId() { return favouriteId; }
    public void setFavouriteId(String favouriteId) { this.favouriteId = favouriteId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getApartmentId() { return apartmentId; }
    public void setApartmentId(String apartmentId) { this.apartmentId = apartmentId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
