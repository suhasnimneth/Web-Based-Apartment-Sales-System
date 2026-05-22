package com.project.DAO;

import com.project.model.Favourite;
import com.project.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavouriteDAO {

    // Add apartment to favourites
    public String addFavourite(Favourite favourite) {
        String sql = "INSERT INTO favourites (buyerId, apartmentId) OUTPUT INSERTED.favouriteId VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, favourite.getBuyerId());
            stmt.setString(2, favourite.getApartmentId());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Remove apartment from favourites
    public boolean removeFavourite(String buyerId, String apartmentId) {
        String sql = "DELETE FROM favourites WHERE buyerId = ? AND apartmentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            stmt.setString(2, apartmentId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Remove all favourites for a specific apartment (when apartment is deleted)
    public boolean removeFavouritesByApartment(String apartmentId) {
        String sql = "DELETE FROM favourites WHERE apartmentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, apartmentId);
            int rowsAffected = stmt.executeUpdate();
            return true; // Return true even if no rows affected
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if apartment is in buyer's favourites
    public boolean isFavourite(String buyerId, String apartmentId) {
        String sql = "SELECT COUNT(*) FROM favourites WHERE buyerId = ? AND apartmentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            stmt.setString(2, apartmentId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all favourites for a buyer
    public List<Favourite> getFavouritesByBuyer(String buyerId) {
        String sql = "SELECT f.favouriteId, f.buyerId, f.apartmentId, f.createdAt, " +
                   "a.title, a.price, a.city, a.address, " +
                   "(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = f.apartmentId ORDER BY i.createdAt ASC) as primaryImage " +
                   "FROM favourites f " +
                   "JOIN apartments a ON f.apartmentId = a.apartmentId " +
                   "WHERE f.buyerId = ? " +
                   "ORDER BY f.createdAt DESC";

        List<Favourite> favourites = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Favourite favourite = new Favourite();
                favourite.setFavouriteId(rs.getString("favouriteId"));
                favourite.setBuyerId(rs.getString("buyerId"));
                favourite.setApartmentId(rs.getString("apartmentId"));
                
                Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) favourite.setCreatedAt(ts.toLocalDateTime());

                favourites.add(favourite);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return favourites;
    }

    // Get favourite count for an apartment
    public int getFavouriteCount(String apartmentId) {
        String sql = "SELECT COUNT(*) FROM favourites WHERE apartmentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, apartmentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get favourite count by buyer
    public int getFavouriteCountByBuyer(String buyerId) {
        String sql = "SELECT COUNT(*) FROM favourites WHERE buyerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, buyerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
