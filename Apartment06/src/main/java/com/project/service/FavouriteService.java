package com.project.service;

import com.project.DAO.FavouriteDAO;
import com.project.model.Favourite;

import java.util.List;

public class FavouriteService {
    private FavouriteDAO favouriteDAO;

    public FavouriteService() {
        this.favouriteDAO = new FavouriteDAO();
    }

    public String addFavourite(String buyerId, String apartmentId) {
        // Check if already in favourites
        if (favouriteDAO.isFavourite(buyerId, apartmentId)) {
            return null; // Already in favourites
        }

        Favourite favourite = new Favourite(buyerId, apartmentId);
        return favouriteDAO.addFavourite(favourite);
    }

    public boolean removeFavourite(String buyerId, String apartmentId) {
        return favouriteDAO.removeFavourite(buyerId, apartmentId);
    }

    public boolean isFavourite(String buyerId, String apartmentId) {
        return favouriteDAO.isFavourite(buyerId, apartmentId);
    }

    public List<Favourite> getFavouritesByBuyer(String buyerId) {
        return favouriteDAO.getFavouritesByBuyer(buyerId);
    }

    public int getFavouriteCount(String apartmentId) {
        return favouriteDAO.getFavouriteCount(apartmentId);
    }
}
