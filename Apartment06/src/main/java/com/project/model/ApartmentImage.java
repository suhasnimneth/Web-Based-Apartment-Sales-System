package com.project.model;

import java.time.LocalDateTime;

public class ApartmentImage {
    private String imageId; // e.g., I001
    private String apartmentId; // e.g., A001
    private String imageUrl;
    private LocalDateTime createdAt;

    public String getImageId() { return imageId; }
    public void setImageId(String imageId) { this.imageId = imageId; }

    public String getApartmentId() { return apartmentId; }
    public void setApartmentId(String apartmentId) { this.apartmentId = apartmentId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

