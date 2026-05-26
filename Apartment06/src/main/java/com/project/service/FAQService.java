// src/main/java/com/project/service/FAQService.java
package com.project.service;

import com.project.DAO.FAQDAO;
import com.project.model.FAQ;
import java.util.List;

public class FAQService {
    private FAQDAO faqDAO = new FAQDAO();

    public List<FAQ> getAllActiveFAQs() throws Exception {
        return faqDAO.getAllActiveFAQs();
    }

    public List<FAQ> getFAQsByCategory(String category) throws Exception {
        return faqDAO.getFAQsByCategory(category);
    }

    public List<String> getCategories() throws Exception {
        return faqDAO.getCategories();
    }

    // Admin methods
    public List<FAQ> getAllFAQs() throws Exception {
        return faqDAO.getAllFAQs();
    }

    public void addFAQ(FAQ faq) throws Exception {
        faqDAO.addFAQ(faq);
    }

    public void updateFAQ(FAQ faq) throws Exception {
        faqDAO.updateFAQ(faq);
    }

    public void deleteFAQ(int faqId) throws Exception {
        faqDAO.deleteFAQ(faqId);
    }
}