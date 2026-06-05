package com.project.util;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/DatabaseTestServlet")
public class DatabaseTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Connection Test</title></head><body>");
        out.println("<h2>Database Connection Test</h2>");
        
        try {
            // Test database connection
            Connection conn = DBUtil.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p style='color: green;'>✅ Database connection successful!</p>");
                out.println("<p>Connection URL: " + "jdbc:sqlserver://localhost:1433;databaseName=Apartment_06;encrypt=true;trustServerCertificate=true" + "</p>");
                conn.close();
            } else {
                out.println("<p style='color: red;'>❌ Database connection failed - connection is null or closed</p>");
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ Database connection failed with SQLException:</p>");
            out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>SQL State:</strong> " + e.getSQLState() + "</p>");
            out.println("<p><strong>Error Code:</strong> " + e.getErrorCode() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Database connection failed with Exception:</p>");
            out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>Exception Type:</strong> " + e.getClass().getSimpleName() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<br><a href='login.jsp'>Back to Login</a>");
        out.println("</body></html>");
    }
}
