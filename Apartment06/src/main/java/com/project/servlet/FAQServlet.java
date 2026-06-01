// src/main/java/com/project/servlet/FAQServlet.java
package com.project.servlet;

import com.project.model.FAQ;
import com.project.service.FAQService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/faq")
public class FAQServlet extends HttpServlet {
    private FAQService faqService = new FAQService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String category = request.getParameter("category");
            List<FAQ> faqs;

            if (category != null && !category.trim().isEmpty()) {
                // Get FAQs by specific category
                faqs = faqService.getFAQsByCategory(category);
            } else {
                // Get all active FAQs
                faqs = faqService.getAllActiveFAQs();
            }

            // Get all categories for filter
            List<String> categories = faqService.getCategories();

            request.setAttribute("faqs", faqs);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", category);

            request.getRequestDispatcher("faq.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading FAQs");
        }
    }
}