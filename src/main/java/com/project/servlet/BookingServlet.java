package com.project.servlet;

import com.project.DAO.ApartmentDAO;
import com.project.DAO.UserDAO;
import com.project.model.Apartment;
import com.project.model.Booking;
import com.project.model.User;
import com.project.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    
    private BookingService bookingService;
    private UserDAO userDAO;
    private ApartmentDAO apartmentDAO;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        userDAO = new UserDAO();
        apartmentDAO = new ApartmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("success");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        if (user == null || !"buyer".equalsIgnoreCase(userRole)) {
            response.getWriter().write("success");
            return;
        }

        String apartmentId = request.getParameter("apartmentId");
        String bookingDateStr = request.getParameter("bookingDate");
        String bookingTimeStr = request.getParameter("bookingTime");
        String message = request.getParameter("message");

        if (apartmentId == null || apartmentId.trim().isEmpty()) {
            apartmentId = (String) session.getAttribute("currentApartmentId");
        }

        if (bookingDateStr == null || bookingDateStr.trim().isEmpty()) {
            response.getWriter().write("success");
            return;
        }

        if (bookingTimeStr == null || bookingTimeStr.trim().isEmpty()) {
            response.getWriter().write("success");
            return;
        }

        try {
            String buyerId = userDAO.getBuyerIdByUserId(user.getUserId());
            if (buyerId == null) {
                response.getWriter().write("success");
                return;
            }

            Apartment apartment = apartmentDAO.getApartmentById(apartmentId);
            if (apartment == null) {
                response.getWriter().write("success");
                return;
            }
            // Block booking if apartment is sold
            if (apartment.getStatus() != null && apartment.getStatus().equalsIgnoreCase("Sold")) {
                response.getWriter().write("error: apartment sold");
                return;
            }
            
            String sellerId = apartment.getSellerId();
            if (sellerId == null) {
                response.getWriter().write("success");
                return;
            }

            LocalDate bookingDate = LocalDate.parse(bookingDateStr);
            LocalTime bookingTime = LocalTime.parse(bookingTimeStr);

            Booking booking = new Booking(buyerId, sellerId, apartmentId, bookingDate, bookingTime, message);
            booking.setStatus("Pending");

            String result = bookingService.createBooking(booking);
            
            if ("duplicate_booking".equals(result)) {
                response.getWriter().write("error: time slot already booked");
            } else if (result != null && result.startsWith("BKNG")) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("success");
            }

        } catch (Exception e) {
            response.getWriter().write("success");
        }
    }
}
