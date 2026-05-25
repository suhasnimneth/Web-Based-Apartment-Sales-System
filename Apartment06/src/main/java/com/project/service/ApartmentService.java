package com.project.service;

import com.project.DAO.ApartmentDAO;
import com.project.model.Apartment;
import com.project.model.ApartmentImage;

import java.util.List;

public class ApartmentService {
    private final ApartmentDAO apartmentDAO;

    public ApartmentService() {
        this.apartmentDAO = new ApartmentDAO();
    }

    public String addApartment(Apartment apartment, List<String> imageUrls) {
        String apartmentId = apartmentDAO.insertApartment(apartment);
        if (apartmentId == null) return null;
        if (imageUrls != null && !imageUrls.isEmpty()) {
            boolean imagesOk = apartmentDAO.insertApartmentImages(apartmentId, imageUrls);
            if (!imagesOk) return null;
        }
        return apartmentId;
    }

    public List<com.project.model.Apartment> listBySeller(String sellerId) {
        return apartmentDAO.listApartmentsBySeller(sellerId);
    }

    public List<ApartmentImage> getApartmentImages(String apartmentId) {
        return apartmentDAO.getApartmentImages(apartmentId);
    }

    public Apartment getApartmentById(String apartmentId) {
        return apartmentDAO.getApartmentById(apartmentId);
    }

    public boolean updateApartment(Apartment apartment) {
        return apartmentDAO.updateApartment(apartment);
    }

    public boolean deleteApartment(String apartmentId) {
        return apartmentDAO.deleteApartment(apartmentId);
    }

    public List<Apartment> getAllApartments() {
        return apartmentDAO.getAllApartments();
    }

    public boolean isApartmentOwnedBySeller(String apartmentId, String sellerId) {
        return apartmentDAO.isApartmentOwnedBySeller(apartmentId, sellerId);
    }

    public List<Apartment> searchApartments(String location, String city, String minPrice, String maxPrice, 
                                          String propertyType, String bedrooms, String bathrooms, String status) {
        return apartmentDAO.searchApartments(location, city, minPrice, maxPrice, propertyType, bedrooms, bathrooms, status);
    }

    public boolean updateApartmentStatus(String apartmentId, String status) {
        return apartmentDAO.updateApartmentStatus(apartmentId, status);
    }
}

