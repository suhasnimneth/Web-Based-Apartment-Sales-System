<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Login - Apartment X</title>
    <link rel="stylesheet" href="css/login.css?v=2">
</head>
<body>
<div class="page-wrapper">
    <!-- Left side: form -->
    <div class="form-wrapper">
        <a href="index.jsp" class="back-btn" id="loginBackBtn" style="background: transparent !important; color: #e63946 !important; border: 2px solid #e63946 !important; border-radius: 25px !important; padding: 0.8rem 1.5rem !important; text-decoration: none !important; font-weight: 600 !important; transition: all 0.3s ease !important;"> Back</a>
        <h2>Login</h2>

        <!-- Fixed: Use form with action and method -->
        <form id="loginForm" action="LoginServlet" method="post" onsubmit="return validateForm()">
            <input type="email" id="email" name="email" placeholder="Email" required>
            <input type="password" id="password" name="password" placeholder="Password" required>
            <button type="submit" class="cta-btn">Login</button>
        </form>

        <!-- Display error message if exists -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message" style="color: red; margin: 10px 0; text-align: center;">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- Display success message if present in session or query -->
        <% 
            String flashSuccess = (String) session.getAttribute("flashSuccess");
            if (flashSuccess != null) { 
                session.removeAttribute("flashSuccess");
        %>
        <div class="success-message" style="color: green; margin: 10px 0; text-align: center;">
            <%= flashSuccess %>
        </div>
        <% } else if (request.getParameter("success") != null) { %>
        <div class="success-message" style="color: green; margin: 10px 0; text-align: center;">
            Registration successful. Please login.
        </div>
        <% } else if (request.getParameter("message") != null) { %>
        <div class="success-message" style="color: green; margin: 10px 0; text-align: center;">
            <%= request.getParameter("message") %>
        </div>
        <% } %>

        <p class="login-text">Don't have an account ? <a href="register.jsp">Register</a></p>
    </div>

    <!-- Right side: image banner -->
    <div class="image-banner">
        <img src="https://doudapartmenthomes.com/wp-content/uploads/2023/12/sidekix-media-LFlbLb8vJls-unsplash-scaled.jpg  " alt="Apartment" class="banner-image active">
        <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg  " alt="Apartment" class="banner-image">
        <img src="https://www.rustomjee.com/blog/wp-content/uploads/2024/10/Defining-Luxury-in-the-Context-of-Apartments-scaled-1.jpg  " alt="Apartment" class="banner-image">
    </div>
</div>

<script>
    // Updated validation function (removed role validation)
    function validateForm() {
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        if (!email || !password) {
            alert('Please fill in all fields');
            return false;
        }

        return true; // Allow form submission
    }

    // Back button function
    function goBack() {
        window.history.back();
    }

    // Back button hover effect
    document.addEventListener('DOMContentLoaded', function() {
        const backBtn = document.getElementById('loginBackBtn');
        if (backBtn) {
            backBtn.addEventListener('mouseenter', function() {
                this.style.setProperty('background', '#e63946', 'important');
                this.style.setProperty('color', 'white', 'important');
                this.style.setProperty('transform', 'translateY(-2px)', 'important');
            });
            
            backBtn.addEventListener('mouseleave', function() {
                this.style.setProperty('background', 'transparent', 'important');
                this.style.setProperty('color', '#e63946', 'important');
                this.style.setProperty('transform', 'translateY(0)', 'important');
            });
        }

        // Auto-hide success banner after a few seconds
        const successEl = document.querySelector('.success-message');
        if (successEl) {
            setTimeout(function() {
                successEl.style.transition = 'opacity 0.5s ease';
                successEl.style.opacity = '0';
                setTimeout(function() {
                    if (successEl && successEl.parentNode) {
                        successEl.parentNode.removeChild(successEl);
                    }
                }, 600);
            }, 3000);
        }
    });
</script>
</body>
</html>