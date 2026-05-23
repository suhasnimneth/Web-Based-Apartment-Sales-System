package com.project.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Apartment {
    private String apartmentId; // e.g., A001
    private String sellerId;    // e.g., S001
    private String title;
    private String description;
    private String address;
    private String city;
    private String location;    // Location/Area
    private String state;       // State/Province
    private String postalCode;  // Postal Code
    private String contactNumber; // Contact Number
    private String propertyType; // Property Type
    private String status;      // Status (Available, Sold, Reserved, Under Maintenance)
    private BigDecimal price;
    private Integer bedrooms;
    private Integer bathrooms;
    private Integer areaSqFt;
    private LocalDateTime createdAt;
    private List<ApartmentImage> images;
    private String primaryImageUrl; // For listing pages
    private String sellerName; // Seller's name for display

    public String getApartmentId() { return apartmentId; }
    public void setApartmentId(String apartmentId) { this.apartmentId = apartmentId; }

    public String getSellerId() { return sellerId; }
    public void setSellerId(String sellerId) { this.sellerId = sellerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getPropertyType() { return propertyType; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getBedrooms() { return bedrooms; }
    public void setBedrooms(Integer bedrooms) { this.bedrooms = bedrooms; }

    public Integer getBathrooms() { return bathrooms; }
    public void setBathrooms(Integer bathrooms) { this.bathrooms = bathrooms; }

    public Integer getAreaSqFt() { return areaSqFt; }
    public void setAreaSqFt(Integer areaSqFt) { this.areaSqFt = areaSqFt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<ApartmentImage> getImages() { return images; }
    public void setImages(List<ApartmentImage> images) { this.images = images; }
    
    // Get primary image URL (first image)
    public String getPrimaryImage() {
        if (images != null && !images.isEmpty()) {
            String imageUrl = images.get(0).getImageUrl();
            System.out.println("Apartment.getPrimaryImage() - From images list: " + imageUrl);
            return imageUrl;
        }
        System.out.println("Apartment.getPrimaryImage() - From primaryImageUrl field: " + primaryImageUrl);
        return primaryImageUrl; // Fallback to primaryImageUrl field
    }
    
    public String getPrimaryImageUrl() { return primaryImageUrl; }
    public void setPrimaryImageUrl(String primaryImageUrl) { this.primaryImageUrl = primaryImageUrl; }
    
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
}



