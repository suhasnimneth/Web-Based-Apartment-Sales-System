<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Apartment X</title>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
<div class="page-wrapper">
    <!-- Left side: form -->
    <div class="form-wrapper">
        <a href="index.jsp" class="back-btn">Back</a>
        <h2>Create an Account</h2>
        <form action="RegisterServlet" method="post" onsubmit="return validateForm()">
            <div class="form-row">
                <input type="text" id="firstName" name="firstName" placeholder="First Name" required
                       value="<%= request.getAttribute("firstName") != null ? request.getAttribute("firstName") : "" %>">
                <input type="text" id="lastName" name="lastName" placeholder="Last Name" required
                       value="<%= request.getAttribute("lastName") != null ? request.getAttribute("lastName") : "" %>">
            </div>
            <input type="tel" id="contactNumber" name="contactNumber" placeholder="Contact Number" required
                   value="<%= request.getAttribute("contactNumber") != null ? request.getAttribute("contactNumber") : "" %>">
            <input type="text" id="address" name="address" placeholder="Address" required
                   value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
            <input type="email" id="email" name="email" placeholder="Email" required
                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
            <input type="password" id="password" name="password" placeholder="Password" required
                   value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>">

            <div class="form-group">
                <label for="dateOfBirth">Date of Birth</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth" required
                       value="<%= request.getAttribute("dateOfBirth") != null ? request.getAttribute("dateOfBirth") : "" %>">
            </div>

            <select id="role" name="role" required onchange="toggleAdditionalFields()">
                <option value="" disabled <%= request.getAttribute("role") == null ? "selected" : "" %>>Select Role</option>
                <option value="buyer" <%= "buyer".equals(request.getAttribute("role")) ? "selected" : "" %>>Buyer</option>
                <option value="seller" <%= "seller".equals(request.getAttribute("role")) ? "selected" : "" %>>Seller</option>
            </select>

            <!-- Buyer fields -->
            <div id="buyerFields" style="display: <%= "buyer".equals(request.getAttribute("role")) ? "block" : "none" %>;">
                <input type="text" name="preferredLocation" placeholder="Preferred Location"
                       value="<%= request.getAttribute("preferredLocation") != null ? request.getAttribute("preferredLocation") : "" %>">
                <input type="number" name="budgetRange" placeholder="Budget Range" step="0.01"
                       value="<%= request.getAttribute("budgetRange") != null ? request.getAttribute("budgetRange") : "" %>">
                <input type="text" name="purchaseTimeline" placeholder="Purchase Timeline"
                       value="<%= request.getAttribute("purchaseTimeline") != null ? request.getAttribute("purchaseTimeline") : "" %>">
            </div>

            <!-- Seller fields -->
            <div id="sellerFields" style="display: <%= "seller".equals(request.getAttribute("role")) ? "block" : "none" %>;">
                <input type="text" name="businessRegistrationNumber" placeholder="Business Registration Number"
                       value="<%= request.getAttribute("businessRegistrationNumber") != null ? request.getAttribute("businessRegistrationNumber") : "" %>">
                <input type="text" name="companyName" placeholder="Company Name"
                       value="<%= request.getAttribute("companyName") != null ? request.getAttribute("companyName") : "" %>">
                <input type="text" name="licenseNumber" placeholder="License Number"
                       value="<%= request.getAttribute("licenseNumber") != null ? request.getAttribute("licenseNumber") : "" %>">
            </div>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message" style="color: red; margin: 10px 0;">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <button type="submit" class="cta-btn">Register</button>
        </form>

        <p class="login-text">Already have an account? <a href="login.jsp">Login</a></p>
    </div>

    <!-- Right side: image banner -->
    <div class="image-banner">
        <img src="https://doudapartmenthomes.com/wp-content/uploads/2023/12/sidekix-media-LFlbLb8vJls-unsplash-scaled.jpg  " alt="Apartment" class="banner-image active">
        <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg  " alt="Apartment" class="banner-image">
        <img src="https://www.rustomjee.com/blog/wp-content/uploads/2024/10/Defining-Luxury-in-the-Context-of-Apartments-scaled-1.jpg  " alt="Apartment" class="banner-image">
    </div>
</div>

<script src="js/register.js"></script>
<script>
    function toggleAdditionalFields() {
        const role = document.getElementById('role').value;
        const buyerFields = document.getElementById('buyerFields');
        const sellerFields = document.getElementById('sellerFields');

        // Hide all
        buyerFields.style.display = 'none';
        sellerFields.style.display = 'none';

        // Show appropriate fields
        if (role === 'buyer') {
            buyerFields.style.display = 'block';
        } else if (role === 'seller') {
            sellerFields.style.display = 'block';
        }
    }

    // Initialize the form state based on the selected role when page loads
    window.onload = function() {
        const roleSelect = document.getElementById('role');
        if (roleSelect.value) {
            toggleAdditionalFields();
        }
    };

    function validateForm() {
        const firstName = document.getElementById('firstName').value;
        const lastName = document.getElementById('lastName').value;
        const contactNumber = document.getElementById('contactNumber').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const dateOfBirth = document.getElementById('dateOfBirth').value;
        const role = document.getElementById('role').value;

        // Name validation (letters only, 2-50 characters)
        const nameRegex = /^[a-zA-Z]{2,50}$/;
        if (!nameRegex.test(firstName)) {
            alert('First name must contain only letters and be 2-50 characters long');
            document.getElementById('firstName').focus();
            return false;
        }
        if (!nameRegex.test(lastName)) {
            alert('Last name must contain only letters and be 2-50 characters long');
            document.getElementById('lastName').focus();
            return false;
        }

        // Contact number validation (exactly 10 digits)
        const contactRegex = /^\d{10}$/;
        if (!contactRegex.test(contactNumber)) {
            alert('Contact number must be exactly 10 digits');
            document.getElementById('contactNumber').focus();
            return false;
        }

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert('Please enter a valid email address');
            document.getElementById('email').focus();
            return false;
        }

        // Password validation (strong password)
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (!passwordRegex.test(password)) {
            alert('Password must be at least 8 characters long and contain:\n- One uppercase letter\n- One lowercase letter\n- One number\n- One special character');
            document.getElementById('password').focus();
            return false;
        }

        // Date of birth validation (not in future)
        const today = new Date().toISOString().split('T')[0];
        if (dateOfBirth > today) {
            alert('Date of birth cannot be in the future');
            document.getElementById('dateOfBirth').focus();
            return false;
        }

        // Role validation
        if (!role) {
            alert('Please select a role');
            document.getElementById('role').focus();
            return false;
        }

        return true;
    }

    function goBack() {
        window.history.back();
    }
</script>
</body>
</html>