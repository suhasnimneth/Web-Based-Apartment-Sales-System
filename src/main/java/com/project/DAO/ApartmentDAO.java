package com.project.DAO;

import com.project.model.Apartment;
import com.project.model.ApartmentImage;
import com.project.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApartmentDAO {

    // Insert apartment, return generated apartmentId (Axxx)
    public String insertApartment(Apartment apartment) {
        String sql = "INSERT INTO apartments (sellerId, title, description, address, city, state, postalCode, contactNumber, propertyType, status, price, bedrooms, bathrooms, areaSqFt) OUTPUT INSERTED.apartmentId VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, apartment.getSellerId());
            stmt.setString(2, apartment.getTitle());
            stmt.setString(3, apartment.getDescription());
            stmt.setString(4, apartment.getAddress());
            stmt.setString(5, apartment.getCity());
            stmt.setString(6, apartment.getState());
            stmt.setString(7, apartment.getPostalCode());
            stmt.setString(8, apartment.getContactNumber());
            stmt.setString(9, apartment.getPropertyType());
            stmt.setString(10, apartment.getStatus());
            stmt.setBigDecimal(11, apartment.getPrice());

            if (apartment.getBedrooms() != null) stmt.setInt(12, apartment.getBedrooms()); else stmt.setNull(12, Types.INTEGER);
            if (apartment.getBathrooms() != null) stmt.setInt(13, apartment.getBathrooms()); else stmt.setNull(13, Types.INTEGER);
            if (apartment.getAreaSqFt() != null) {
                stmt.setInt(14, apartment.getAreaSqFt());
                System.out.println("ApartmentDAO - Setting areaSqFt to: " + apartment.getAreaSqFt());
            } else {
                stmt.setNull(14, Types.INTEGER);
                System.out.println("ApartmentDAO - areaSqFt is null, setting to NULL");
            }

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

    // Update apartment status (e.g., Available -> Sold)
    public boolean updateApartmentStatus(String apartmentId, String status) {
        String sql = "UPDATE apartments SET status = ? WHERE apartmentId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, apartmentId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Insert multiple images for an apartment
    public boolean insertApartmentImages(String apartmentId, List<String> imageUrls) {
        if (imageUrls == null || imageUrls.isEmpty()) return true;

        String sql = "INSERT INTO apartment_images (apartmentId, imageUrl) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (String url : imageUrls) {
                stmt.setString(1, apartmentId);
                stmt.setString(2, url);
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            return results.length == imageUrls.size();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // List apartments for a seller with primary image (first image)
    public List<Apartment> listApartmentsBySeller(String sellerId) {
        String sql = "SELECT a.apartmentId, a.title, a.description, a.address, a.city, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, (SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage FROM apartments a WHERE a.sellerId = ? ORDER BY a.createdAt DESC";

        List<Apartment> apartments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Apartment a = new Apartment();
                a.setApartmentId(rs.getString("apartmentId"));
                a.setSellerId(sellerId);
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setAddress(rs.getString("address"));
                a.setCity(rs.getString("city"));
                a.setPrice(rs.getBigDecimal("price"));
                a.setStatus(rs.getString("status"));
                a.setBedrooms((Integer) rs.getObject("bedrooms"));
                a.setBathrooms((Integer) rs.getObject("bathrooms"));
                a.setAreaSqFt((Integer) rs.getObject("areaSqFt"));
                // We can attach images later if needed
                apartments.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }

    // Load images for an apartment
    public List<ApartmentImage> getApartmentImages(String apartmentId) {
        String sql = "SELECT imageId, apartmentId, imageUrl, createdAt FROM apartment_images WHERE apartmentId = ? ORDER BY createdAt";
        List<ApartmentImage> images = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, apartmentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ApartmentImage img = new ApartmentImage();
                img.setImageId(rs.getString("imageId"));
                img.setApartmentId(rs.getString("apartmentId"));
                img.setImageUrl(rs.getString("imageUrl"));
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) img.setCreatedAt(ts.toLocalDateTime());
                images.add(img);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    // Get apartment by ID with all details
    public Apartment getApartmentById(String apartmentId) {
        System.out.println("=== ApartmentDAO.getApartmentById ===");
        System.out.println("Looking for apartment with ID: " + apartmentId);
        
        String sql = "SELECT a.apartmentId, a.sellerId, a.title, a.description, a.address, a.city, a.state, a.postalCode, a.contactNumber, a.propertyType, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, a.createdAt, " +
                   "(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage " +
                   "FROM apartments a WHERE a.apartmentId = ?";
        
        System.out.println("SQL Query: " + sql);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("Database connection established successfully");
            
            stmt.setString(1, apartmentId);
            System.out.println("Parameter set: apartmentId = " + apartmentId);
            
            ResultSet rs = stmt.executeQuery();
            System.out.println("Query executed successfully");
            
            if (rs.next()) {
                System.out.println("✅ Apartment found in database");
                
                Apartment apartment = new Apartment();
                apartment.setApartmentId(rs.getString("apartmentId"));
                apartment.setSellerId(rs.getString("sellerId"));
                apartment.setTitle(rs.getString("title"));
                apartment.setDescription(rs.getString("description"));
                apartment.setAddress(rs.getString("address"));
                apartment.setCity(rs.getString("city"));
                apartment.setState(rs.getString("state"));
                apartment.setPostalCode(rs.getString("postalCode"));
                apartment.setContactNumber(rs.getString("contactNumber"));
                apartment.setPropertyType(rs.getString("propertyType"));
                apartment.setStatus(rs.getString("status"));
                apartment.setPrice(rs.getBigDecimal("price"));
                apartment.setBedrooms((Integer) rs.getObject("bedrooms"));
                apartment.setBathrooms((Integer) rs.getObject("bathrooms"));
                apartment.setAreaSqFt((Integer) rs.getObject("areaSqFt"));
                
                // Set primary image URL
                String primaryImageUrl = rs.getString("primaryImage");
                apartment.setPrimaryImageUrl(primaryImageUrl);
                System.out.println("ApartmentDAO.getApartmentById - Setting primary image for " + apartment.getApartmentId() + ": " + primaryImageUrl);
                
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) apartment.setCreatedAt(ts.toLocalDateTime());
                
                System.out.println("✅ Apartment object created successfully:");
                System.out.println("  - Apartment ID: " + apartment.getApartmentId());
                System.out.println("  - Title: " + apartment.getTitle());
                System.out.println("  - Seller ID: " + apartment.getSellerId());
                System.out.println("  - Price: " + apartment.getPrice());
                
                return apartment;
            } else {
                System.out.println("❌ No apartment found with ID: " + apartmentId);
            }
        } catch (SQLException e) {
            System.err.println("❌ SQL Exception in getApartmentById:");
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Stack trace: " + java.util.Arrays.toString(e.getStackTrace()));
        }
        return null;
    }

    // Update apartment details
    public boolean updateApartment(Apartment apartment) {
        String sql = "UPDATE apartments SET title = ?, description = ?, price = ?, bedrooms = ?, bathrooms = ?, areaSqFt = ?, contactNumber = ? WHERE apartmentId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, apartment.getTitle());
            stmt.setString(2, apartment.getDescription());
            stmt.setBigDecimal(3, apartment.getPrice());
            
            if (apartment.getBedrooms() != null) stmt.setInt(4, apartment.getBedrooms()); else stmt.setNull(4, Types.INTEGER);
            if (apartment.getBathrooms() != null) stmt.setInt(5, apartment.getBathrooms()); else stmt.setNull(5, Types.INTEGER);
            if (apartment.getAreaSqFt() != null) stmt.setInt(6, apartment.getAreaSqFt()); else stmt.setNull(6, Types.INTEGER);
            stmt.setString(7, apartment.getContactNumber());
            
            stmt.setString(8, apartment.getApartmentId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete apartment and all its related records (handles foreign key constraints)
    public boolean deleteApartment(String apartmentId) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try {
                // Delete all payments for this apartment (NO ACTION constraint - must delete manually)
                String deletePaymentsSql = "DELETE FROM payments WHERE apartmentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deletePaymentsSql)) {
                    stmt.setString(1, apartmentId);
                    stmt.executeUpdate();
                }
                
                // Delete all favourites for this apartment (NO ACTION constraint - must delete manually)
                String deleteFavouritesSql = "DELETE FROM favourites WHERE apartmentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteFavouritesSql)) {
                    stmt.setString(1, apartmentId);
                    stmt.executeUpdate();
                }
                
                // Delete all bookings for this apartment (no foreign key constraints in current schema)
                String deleteBookingsSql = "DELETE FROM bookings WHERE apartmentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteBookingsSql)) {
                    stmt.setString(1, apartmentId);
                    stmt.executeUpdate();
                }
                
                // Delete all images for this apartment (CASCADE constraint)
                String deleteImagesSql = "DELETE FROM apartment_images WHERE apartmentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteImagesSql)) {
                    stmt.setString(1, apartmentId);
                    stmt.executeUpdate();
                }
                
                // Finally delete the apartment
                String deleteApartmentSql = "DELETE FROM apartments WHERE apartmentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteApartmentSql)) {
                    stmt.setString(1, apartmentId);
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        conn.commit(); // Commit transaction
                        return true;
                    } else {
                        conn.rollback(); // Rollback if no apartment found
                        return false;
                    }
                }
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all apartments (for public listing)
    public List<Apartment> getAllApartments() {
        String sql = "SELECT a.apartmentId, a.sellerId, a.title, a.description, a.address, a.city, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, a.createdAt, " +
                   "(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage " +
                   "FROM apartments a ORDER BY a.createdAt DESC";

        List<Apartment> apartments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Apartment apartment = new Apartment();
                apartment.setApartmentId(rs.getString("apartmentId"));
                apartment.setSellerId(rs.getString("sellerId"));
                apartment.setTitle(rs.getString("title"));
                apartment.setDescription(rs.getString("description"));
                apartment.setAddress(rs.getString("address"));
                apartment.setCity(rs.getString("city"));
                apartment.setPrice(rs.getBigDecimal("price"));
                apartment.setStatus(rs.getString("status"));
                apartment.setBedrooms((Integer) rs.getObject("bedrooms"));
                apartment.setBathrooms((Integer) rs.getObject("bathrooms"));
                apartment.setAreaSqFt((Integer) rs.getObject("areaSqFt"));
                
                // Set primary image URL
                String primaryImageUrl = rs.getString("primaryImage");
                apartment.setPrimaryImageUrl(primaryImageUrl);
                System.out.println("ApartmentDAO - Setting primary image for " + apartment.getApartmentId() + ": " + primaryImageUrl);
                
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) apartment.setCreatedAt(ts.toLocalDateTime());
                
                apartments.add(apartment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }

    // Check if apartment belongs to seller
    public boolean isApartmentOwnedBySeller(String apartmentId, String sellerId) {
        String sql = "SELECT COUNT(*) FROM apartments WHERE apartmentId = ? AND sellerId = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, apartmentId);
            stmt.setString(2, sellerId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Apartment> searchApartments(String location, String city, String minPrice, String maxPrice, 
                                          String propertyType, String bedrooms, String bathrooms, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.apartmentId, a.sellerId, a.title, a.description, a.address, a.city, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, a.createdAt, ");
        sql.append("(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage ");
        sql.append("FROM apartments a WHERE 1=1");
        
        List<Object> parameters = new java.util.ArrayList<>();
        
        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND a.address LIKE ?");
            parameters.add("%" + location + "%");
        }
        
        if (city != null && !city.trim().isEmpty()) {
            sql.append(" AND a.city LIKE ?");
            parameters.add("%" + city + "%");
        }
        
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            sql.append(" AND a.price >= ?");
            parameters.add(Double.parseDouble(minPrice));
        }
        
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            sql.append(" AND a.price <= ?");
            parameters.add(Double.parseDouble(maxPrice));
        }
        
        if (bedrooms != null && !bedrooms.trim().isEmpty()) {
            sql.append(" AND a.bedrooms = ?");
            parameters.add(Integer.parseInt(bedrooms));
        }
        
        if (bathrooms != null && !bathrooms.trim().isEmpty()) {
            sql.append(" AND a.bathrooms = ?");
            parameters.add(Integer.parseInt(bathrooms));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.status = ?");
            parameters.add(status);
        }
        
        sql.append(" ORDER BY a.createdAt DESC");

        List<Apartment> apartments = new java.util.ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Apartment apartment = new Apartment();
                apartment.setApartmentId(rs.getString("apartmentId"));
                apartment.setSellerId(rs.getString("sellerId"));
                apartment.setTitle(rs.getString("title"));
                apartment.setDescription(rs.getString("description"));
                apartment.setAddress(rs.getString("address"));
                apartment.setCity(rs.getString("city"));
                apartment.setPrice(rs.getBigDecimal("price"));
                apartment.setStatus(rs.getString("status"));
                apartment.setBedrooms((Integer) rs.getObject("bedrooms"));
                apartment.setBathrooms((Integer) rs.getObject("bathrooms"));
                apartment.setAreaSqFt((Integer) rs.getObject("areaSqFt"));

                // Set primary image URL
                String primaryImageUrl = rs.getString("primaryImage");
                apartment.setPrimaryImageUrl(primaryImageUrl);

                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) apartment.setCreatedAt(ts.toLocalDateTime());

                apartments.add(apartment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }
    
    // Get apartment count by seller
    public int getApartmentCountBySeller(String sellerId) {
        String sql = "SELECT COUNT(*) FROM apartments WHERE sellerId = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get recent apartments by seller (latest N apartments)
    public List<Apartment> getRecentApartmentsBySeller(String sellerId, int limit) {
        String sql = "SELECT TOP (?) a.apartmentId, a.sellerId, a.title, a.description, a.address, a.city, a.state, a.postalCode, a.contactNumber, a.propertyType, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, a.createdAt, " +
                   "(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage " +
                   "FROM apartments a WHERE a.sellerId = ? ORDER BY a.createdAt DESC";
        
        List<Apartment> apartments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setString(2, sellerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Apartment apartment = new Apartment();
                apartment.setApartmentId(rs.getString("apartmentId"));
                apartment.setSellerId(rs.getString("sellerId"));
                apartment.setTitle(rs.getString("title"));
                apartment.setDescription(rs.getString("description"));
                apartment.setAddress(rs.getString("address"));
                apartment.setCity(rs.getString("city"));
                apartment.setState(rs.getString("state"));
                apartment.setPostalCode(rs.getString("postalCode"));
                apartment.setContactNumber(rs.getString("contactNumber"));
                apartment.setPropertyType(rs.getString("propertyType"));
                apartment.setStatus(rs.getString("status"));
                apartment.setPrice(rs.getBigDecimal("price"));
                apartment.setBedrooms((Integer) rs.getObject("bedrooms"));
                apartment.setBathrooms((Integer) rs.getObject("bathrooms"));
                apartment.setAreaSqFt((Integer) rs.getObject("areaSqFt"));
                
                String primaryImageUrl = rs.getString("primaryImage");
                apartment.setPrimaryImageUrl(primaryImageUrl);
                
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) apartment.setCreatedAt(ts.toLocalDateTime());
                
                apartments.add(apartment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }

    // Get suggested apartments (random apartments for buyers)
    public List<Apartment> getSuggestedApartments(int limit) {
        String sql = "SELECT TOP (?) a.apartmentId, a.sellerId, a.title, a.description, a.address, a.city, a.state, a.postalCode, a.contactNumber, a.propertyType, a.status, a.price, a.bedrooms, a.bathrooms, a.areaSqFt, a.createdAt, " +
                   "(SELECT TOP 1 imageUrl FROM apartment_images i WHERE i.apartmentId = a.apartmentId ORDER BY i.createdAt ASC) as primaryImage " +
                   "FROM apartments a WHERE a.status = 'Available' ORDER BY NEWID()";
        
        List<Apartment> apartments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Apartment apartment = new Apartment();
                apartment.setApartmentId(rs.getString("apartmentId"));
                apartment.setSellerId(rs.getString("sellerId"));
                apartment.setTitle(rs.getString("title"));
                apartment.setDescription(rs.getString("description"));
                apartment.setAddress(rs.getString("address"));
                apartment.setCity(rs.getString("city"));
                apartment.setState(rs.getString("state"));
                apartment.setPostalCode(rs.getString("postalCode"));
                apartment.setContactNumber(rs.getString("contactNumber"));
                apartment.setPropertyType(rs.getString("propertyType"));
                apartment.setStatus(rs.getString("status"));
                apartment.setPrice(rs.getBigDecimal("price"));
                apartment.setBedrooms((Integer) rs.getObject("bedrooms"));
                apartment.setBathrooms((Integer) rs.getObject("bathrooms"));
                apartment.setAreaSqFt((Integer) rs.getObject("areaSqFt"));
                
                String primaryImageUrl = rs.getString("primaryImage");
                apartment.setPrimaryImageUrl(primaryImageUrl);
                
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) apartment.setCreatedAt(ts.toLocalDateTime());
                
                apartments.add(apartment);
            }
        } catch (SQLException e) {
            System.err.println("ApartmentDAO.getSuggestedApartments - SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return apartments;
    }
}

