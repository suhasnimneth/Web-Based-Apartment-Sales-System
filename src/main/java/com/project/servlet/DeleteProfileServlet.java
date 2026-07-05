package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.User;
import com.project.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteProfileServlet")
public class DeleteProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get current user from session
            User currentUser = (User) session.getAttribute("user");
            String userId = currentUser.getUserId();
            String currentRole = (String) session.getAttribute("userRole");

            // Get form parameters
            String confirmPassword = request.getParameter("confirmPassword");
            String deleteReason = request.getParameter("deleteReason");

            // Validate password
            if (!validatePassword(userId, confirmPassword)) {
                request.setAttribute("errorMessage", "Incorrect password. Please try again.");
                request.getRequestDispatcher("deleteprofile.jsp").forward(request, response);
                return;
            }

            // Delete user account (this will cascade delete from Buyer/Seller tables)
            boolean success = deleteUserAccount(userId);

            if (success) {
                // Invalidate session and redirect to index
                session.invalidate();
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to delete account. Please try again.");
                request.getRequestDispatcher("deleteprofile.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while deleting your account: " + e.getMessage());
            request.getRequestDispatcher("deleteprofile.jsp").forward(request, response);
        }
    }

    private boolean validatePassword(String userId, String password) {
        String sql = "SELECT password FROM users WHERE userId = ?";

        try (Connection conn = com.project.util.DBUtil.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            java.sql.ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                return storedPassword != null && storedPassword.equals(password);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean deleteUserAccount(String userId) {
        String sql = "DELETE FROM users WHERE userId = ?";

        try (Connection conn = com.project.util.DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}