package com.project.servlet;

import com.project.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/PasswordTestServlet")
public class PasswordTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Password Hashing Test</title></head><body>");
        out.println("<h2>Password Hashing Test</h2>");
        
        // Test password hashing
        String testPassword = "TestPassword123!";
        out.println("<h3>Testing Password: " + testPassword + "</h3>");
        
        // Test password strength
        boolean isStrong = PasswordUtil.isPasswordStrong(testPassword);
        out.println("<p>Password Strength Check: " + (isStrong ? "PASS" : "FAIL") + "</p>");
        
        // Test password hashing
        String hashedPassword = PasswordUtil.hashPassword(testPassword);
        out.println("<p>Hashed Password: " + hashedPassword + "</p>");
        
        // Test password verification
        boolean isValid = PasswordUtil.verifyPassword(testPassword, hashedPassword);
        out.println("<p>Password Verification: " + (isValid ? "PASS" : "FAIL") + "</p>");
        
        // Test with wrong password
        boolean isWrongValid = PasswordUtil.verifyPassword("WrongPassword", hashedPassword);
        out.println("<p>Wrong Password Verification: " + (isWrongValid ? "FAIL" : "PASS") + "</p>");
        
        // Test weak password
        String weakPassword = "weak";
        boolean isWeakStrong = PasswordUtil.isPasswordStrong(weakPassword);
        out.println("<p>Weak Password Strength Check: " + (isWeakStrong ? "FAIL" : "PASS") + "</p>");
        
        out.println("<h3>Test Complete!</h3>");
        out.println("<p><a href='register.jsp'>Go to Registration</a></p>");
        out.println("</body></html>");
    }
}
