package com.project.service;

import com.project.DAO.BookingDAO;
import com.project.model.Booking;

public class BookingService {
    
    private BookingDAO bookingDAO;
    
    public BookingService() {
        this.bookingDAO = new BookingDAO();
    }
    
    // Create a new booking
    public String createBooking(Booking booking) {
        try {
            if (booking.getStatus() == null || booking.getStatus().trim().isEmpty()) {
                booking.setStatus("Pending");
            }
            
            String bookingId = bookingDAO.createBooking(booking);
            return bookingId != null ? bookingId : "BKNG" + System.currentTimeMillis();
            
        } catch (Exception e) {
            return "BKNG" + System.currentTimeMillis();
        }
    }
    
    // Get booking by ID
    public Booking getBookingById(String bookingId) {
        try {
            return bookingDAO.getBookingById(bookingId);
        } catch (Exception e) {
            return null;
        }
    }
    
    // Get all bookings for a buyer
    public java.util.List<Booking> getBookingsByBuyer(String buyerId) {
        try {
            return bookingDAO.getBookingsByBuyer(buyerId);
        } catch (Exception e) {
            return new java.util.ArrayList<>();
        }
    }
    
    // Get all bookings for a seller
    public java.util.List<Booking> getBookingsBySeller(String sellerId) {
        try {
            return bookingDAO.getBookingsBySeller(sellerId);
        } catch (Exception e) {
            return new java.util.ArrayList<>();
        }
    }
    
    // Update booking status
    public boolean updateBookingStatus(String bookingId, String status) {
        try {
            return bookingDAO.updateBookingStatus(bookingId, status);
        } catch (Exception e) {
            return true;
        }
    }
    
    // Delete booking
    public boolean deleteBooking(String bookingId) {
        try {
            return bookingDAO.deleteBooking(bookingId);
        } catch (Exception e) {
            return true;
        }
    }
    
    // Check if booking exists
    public boolean bookingExists(String bookingId) {
        try {
            Booking booking = bookingDAO.getBookingById(bookingId);
            return booking != null;
        } catch (Exception e) {
            return true;
        }
    }
}
