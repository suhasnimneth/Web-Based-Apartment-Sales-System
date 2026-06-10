<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.model.FAQ" %>
<%
    List<FAQ> faqs = (List<FAQ>) request.getAttribute("faqs");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");

    if (faqs == null) {
        response.sendRedirect("faq");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Frequently Asked Questions | Apartment X</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: #f8f8f8;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .page-header {
            background: linear-gradient(135deg, #fff, #fef2f2);
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .page-header h1 {
            margin: 0;
            color: #333;
            font-size: 2.5rem;
        }
        .page-header span {
            color: #e63946;
        }
        .page-header p {
            margin-top: 10px;
            color: #666;
            font-size: 1.1rem;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            left: 20px;
            top: 20px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
        }

        /* Main Container */
        .faq-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Category Filter */
        .category-filter {
            text-align: center;
            margin-bottom: 40px;
        }

        .category-buttons {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .category-btn {
            background: white;
            border: 2px solid #e63946;
            color: #e63946;
            padding: 8px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .category-btn:hover,
        .category-btn.active {
            background: #e63946;
            color: white;
        }

        /* FAQ List */
        .faq-list {
            max-width: 900px;
            margin: 0 auto;
        }

        .faq-item {
            background: white;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .faq-question {
            padding: 20px;
            cursor: pointer;
            display: flex;
            justify-content: between;
            align-items: center;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background 0.3s ease;
        }

        .faq-question:hover {
            background: #f8f8f8;
        }

        .faq-question::after {
            content: '+';
            font-size: 1.5rem;
            font-weight: 300;
            transition: transform 0.3s ease;
        }

        .faq-item.active .faq-question::after {
            content: '−';
        }

        .faq-answer {
            padding: 0 20px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
            background: #f8f8f8;
        }

        .faq-item.active .faq-answer {
            padding: 20px;
            max-height: 500px;
        }

        .faq-category {
            display: inline-block;
            background: #e63946;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            margin-left: 10px;
            vertical-align: middle;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        /* Search Box */
        .search-box {
            max-width: 500px;
            margin: 0 auto 30px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        .search-box input:focus {
            outline: none;
            border-color: #e63946;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 20px;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .faq-container {
                padding: 20px 15px;
            }

            .faq-question {
                padding: 15px;
                font-size: 1rem;
            }

            .category-buttons {
                justify-content: flex-start;
                overflow-x: auto;
                padding-bottom: 10px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="page-header">
    <a href="index.jsp" class="back-btn"> Back</a>
    <h1>Frequently Asked <span>Questions</span></h1>
    <p>Find answers to common questions about Apartment X</p>
</header>

<!-- Main Content -->
<div class="faq-container">
    <!-- Search Box -->
    <div class="search-box">
        <input type="text" id="searchInput" placeholder="Search FAQs...">
    </div>

    <!-- Category Filter -->
    <div class="category-filter">
        <div class="category-buttons">
            <button class="category-btn <%= selectedCategory == null ? "active" : "" %>"
                    onclick="filterByCategory('')">All FAQs</button>
            <% for (String category : categories) { %>
            <button class="category-btn <%= category.equals(selectedCategory) ? "active" : "" %>"
                    onclick="filterByCategory('<%= category %>')"><%= category %></button>
            <% } %>
        </div>
    </div>

    <!-- FAQ List -->
    <div class="faq-list" id="faqList">
        <% if (faqs != null && !faqs.isEmpty()) { %>
        <% for (FAQ faq : faqs) { %>
        <div class="faq-item" data-category="<%= faq.getCategory() %>">
            <div class="faq-question">
                <%= faq.getQuestion() %>
                <span class="faq-category"><%= faq.getCategory() %></span>
            </div>
            <div class="faq-answer">
                <p><%= faq.getAnswer() %></p>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="no-results">
            <p>No FAQs found for the selected category.</p>
        </div>
        <% } %>
    </div>
</div>

<script>
    // FAQ Accordion Functionality
    document.querySelectorAll('.faq-question').forEach(question => {
        question.addEventListener('click', () => {
            const faqItem = question.parentElement;
            faqItem.classList.toggle('active');
        });
    });

    // Category Filter
    function filterByCategory(category) {
        if (category === '') {
            window.location.href = 'faq';
        } else {
            window.location.href = 'faq?category=' + encodeURIComponent(category);
        }
    }

    // Search Functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const faqItems = document.querySelectorAll('.faq-item');

        faqItems.forEach(item => {
            const question = item.querySelector('.faq-question').textContent.toLowerCase();
            const answer = item.querySelector('.faq-answer').textContent.toLowerCase();

            if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });

    // Open FAQ if URL has hash
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const search = urlParams.get('search');
        if (search) {
            document.getElementById('searchInput').value = search;
            document.getElementById('searchInput').dispatchEvent(new Event('input'));
        }
    });
</script>
</body>
</html>