package com.project.servlet;

import com.project.util.PasswordMigrationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/PasswordMigrationServlet")
public class PasswordMigrationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Password Migration</title></head><body>");
        out.println("<h2>Password Migration Tool</h2>");
        out.println("<p>This tool migrates existing plain text passwords to hashed passwords.</p>");
        out.println("<p><strong>Warning:</strong> This should only be run once!</p>");
        
        try {
            int migratedCount = PasswordMigrationUtil.migratePasswords();
            out.println("<h3>Migration Results:</h3>");
            out.println("<p style='color: green;'>Successfully migrated " + migratedCount + " passwords.</p>");
            
            if (migratedCount == 0) {
                out.println("<p>No plain text passwords found. All passwords are already hashed.</p>");
            }
            
        } catch (Exception e) {
            out.println("<h3>Migration Error:</h3>");
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<p><a href='login.jsp'>Go to Login</a></p>");
        out.println("<p><a href='register.jsp'>Go to Registration</a></p>");
        out.println("</body></html>");
    }
}
