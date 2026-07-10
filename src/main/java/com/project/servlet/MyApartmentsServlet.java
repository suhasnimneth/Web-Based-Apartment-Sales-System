package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;
import com.project.service.ApartmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/MyApartmentsServlet")
public class MyApartmentsServlet extends HttpServlet {

    private ApartmentService apartmentService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        apartmentService = new ApartmentService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = String.valueOf(session.getAttribute("userRole")).toLowerCase();
        if (!"seller".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        // sellerId: pass via session or request; otherwise require hidden input
        String sellerId = request.getParameter("sellerId");
        if (sellerId == null || sellerId.trim().isEmpty()) {
            Object sid = session.getAttribute("sellerId");
            if (sid != null) sellerId = sid.toString();
        }
        if (sellerId == null || sellerId.trim().isEmpty()) {
            User user = (User) session.getAttribute("user");
            if (user != null) sellerId = userDAO.getSellerIdByUserId(user.getUserId());
            if (sellerId != null) session.setAttribute("sellerId", sellerId);
        }
        if (sellerId == null || sellerId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing sellerId.");
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
            return;
        }

        request.setAttribute("apartments", apartmentService.listBySeller(sellerId));
        request.getRequestDispatcher("myapartments.jsp").forward(request, response);
    }
}


