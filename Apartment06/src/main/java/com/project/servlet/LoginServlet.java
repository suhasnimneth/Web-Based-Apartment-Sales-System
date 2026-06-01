package com.project.servlet;

import com.project.model.User;
import com.project.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Login attempt for email: " + email);
        
        try {
            System.out.println("Calling userService.authenticateUser...");
            User user = userService.authenticateUser(email, password);
            System.out.println("Authentication result: " + (user != null ? "User found" : "User not found"));
            if (user == null) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFirstName() + " " + user.getLastName());

            String role = user.getRole() != null ? user.getRole().toLowerCase() : "";
            if ("buyer".equals(role)) {
                response.sendRedirect("BuyerDashboardServlet");
            } else if ("seller".equals(role)) {
                response.sendRedirect("SellerDashboardServlet");
            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Log detailed error information
            System.err.println("Login error: " + e.getClass().getSimpleName() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}

