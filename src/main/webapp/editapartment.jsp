<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.Apartment" %>

<%
    // Check if user is logged in and has seller role
    Object userObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");

    if (userObj == null || !"seller".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get apartment data
    Apartment apartment = (Apartment) request.getAttribute("apartment");
    if (apartment == null) {
        response.sendRedirect("myapartments.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Apartment - Apartment Portal</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            line-height: 1.6;
        }

        .main-content {
            padding: 80px 30px 30px 30px;
            min-height: 100vh;
            position: relative;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            overflow: hidden;
        }

        .back-btn {
            position: absolute;
            top: 30px;
            left: 30px;
            background: transparent;
            border: 2px solid #e63946;
            color: #e63946;
            padding: 12px 24px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .page-header h1 {
            font-size: 2.5rem;
            margin: 0 0 10px 0;
            font-weight: 700;
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-header h1 i {
            font-size: 2rem;
        }

        .page-header p {
            font-size: 1.2rem;
            margin: 0;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .content-section {
            padding: 30px;
        }

        /* Form Styles */
        .form-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }

        .form-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
        }

        .section-title {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #e63946;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .required::after {
            content: " *";
            color: #e63946;
        }

        input[type="text"],
        input[type="number"],
        input[type="tel"],
        textarea,
        select {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            font-family: inherit;
        }

        input:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #e63946;
            background: white;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }

        input.error,
        textarea.error,
        select.error {
            border-color: #e63946;
            background: #fdf2f2;
        }

        textarea {
            height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        /* Messages */
        .error-message {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            border-left: 4px solid #e63946;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success-message {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            border-left: 4px solid #4caf50;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
            flex-wrap: wrap;
        }

        .btn {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-primary:hover {
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
        }

        .validation-error {
            color: #e63946;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .readonly-note {
            color: #6c757d;
            font-size: 12px;
            margin-top: 5px;
            font-style: italic;
        }

        input[readonly], select[disabled] {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
        }

        input[readonly]:focus, select[disabled]:focus {
            outline: none;
            border-color: #dee2e6;
            box-shadow: none;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                padding: 80px 15px 15px 15px;
            }

            .content-section {
                padding: 20px;
            }

            .form-section {
                padding: 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .page-header h1 {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 80px 10px 10px 10px;
            }

            .content-section {
                padding: 15px;
            }

            .form-section {
                padding: 15px;
            }

            .page-header h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="container">
            <a href="sellerdashboard.jsp" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>

            <div class="page-header">
                <h1><i class="fa-solid fa-edit"></i> Edit Apartment</h1>
                <p>Update your apartment details and information</p>
            </div>

            <div class="content-section">
                <!-- Display Messages -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message" id="errorMessage">
                    <i class="fa-solid fa-exclamation-triangle"></i> <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message" id="successMessage">
                    <i class="fa-solid fa-check-circle"></i> <%= request.getAttribute("successMessage") %>
                </div>
                <% } %>

    <form id="editApartmentForm" action="EditApartmentServlet" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="apartmentId" value="<%= apartment.getApartmentId() %>">
        
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fa-solid fa-info-circle"></i> Basic Information
                    </h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="title" class="required">Apartment Title</label>
                    <input type="text" id="title" name="title" placeholder="e.g., Luxury 3-Bedroom Apartment" 
                           value="<%= apartment.getTitle() != null ? apartment.getTitle() : "" %>" required>
                    <div class="validation-error" id="titleError">Please enter a title</div>
                </div>
                <div class="form-group">
                    <label for="price" class="required">Price (Rs.)</label>
                    <input type="number" id="price" name="price" step="0.01" min="1" placeholder="Enter price" 
                           value="<%= apartment.getPrice() != null ? apartment.getPrice() : "" %>" required>
                    <div class="validation-error" id="priceError">Price must be greater than 0</div>
                </div>
            </div>

            <div class="form-group full-width">
                <label for="description" class="required">Description</label>
                <textarea id="description" name="description" placeholder="Describe the apartment features, amenities, location advantages, etc." required><%= apartment.getDescription() != null ? apartment.getDescription() : "" %></textarea>
                <div class="validation-error" id="descriptionError">Please enter a description</div>
            </div>
        </div>

                <!-- Property Details Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fa-solid fa-home"></i> Property Details
                    </h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="bedrooms" class="required">Bedrooms</label>
                    <input type="number" id="bedrooms" name="bedrooms" min="1" max="20" placeholder="Number of bedrooms" 
                           value="<%= apartment.getBedrooms() != null ? apartment.getBedrooms() : "" %>" required>
                    <div class="validation-error" id="bedroomsError">Must be between 1-20</div>
                </div>
                <div class="form-group">
                    <label for="bathrooms" class="required">Bathrooms</label>
                    <input type="number" id="bathrooms" name="bathrooms" min="1" max="20" placeholder="Number of bathrooms" 
                           value="<%= apartment.getBathrooms() != null ? apartment.getBathrooms() : "" %>" required>
                    <div class="validation-error" id="bathroomsError">Must be between 1-20</div>
                </div>
                <div class="form-group">
                    <label for="areaSqft">Area (sqft)</label>
                    <input type="number" id="areaSqft" name="areaSqft" min="1" max="100000" step="0.01" placeholder="Area in square feet" 
                           value="<%= apartment.getAreaSqFt() != null ? apartment.getAreaSqFt() : "" %>">
                    <div class="validation-error" id="areaError">Must be between 1-100,000 sqft</div>
                </div>
            </div>
        </div>

                <!-- Location Information Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fa-solid fa-map-marker-alt"></i> Location Information
                    </h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="location">Location/Area</label>
                    <input type="text" id="location" name="location" placeholder="e.g., Colombo 7" 
                           value="<%= apartment.getLocation() != null ? apartment.getLocation() : "Not specified" %>" readonly>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" placeholder="e.g., Colombo" 
                           value="<%= apartment.getCity() != null ? apartment.getCity() : "" %>" readonly>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
                <div class="form-group">
                    <label for="state">State/Province</label>
                    <input type="text" id="state" name="state" placeholder="e.g., Western Province" 
                           value="<%= apartment.getState() != null ? apartment.getState() : "Not specified" %>" readonly>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group full-width">
                    <label for="address">Full Address</label>
                    <input type="text" id="address" name="address" placeholder="Enter complete address" 
                           value="<%= apartment.getAddress() != null ? apartment.getAddress() : "" %>" readonly>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
                <div class="form-group">
                    <label for="postalCode">Postal Code</label>
                    <input type="text" id="postalCode" name="postalCode" placeholder="e.g., 00700" 
                           value="<%= apartment.getPostalCode() != null ? apartment.getPostalCode() : "Not specified" %>" readonly>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
            </div>
        </div>

                <!-- Contact Information Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fa-solid fa-phone"></i> Contact Information
                    </h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="contactNumber">Contact Number</label>
                    <input type="tel" id="contactNumber" name="contactNumber" placeholder="e.g., 0771234567" pattern="[0-9]{10}" 
                           value="<%= apartment.getContactNumber() != null ? apartment.getContactNumber() : "" %>">
                    <div class="validation-error" id="contactError">Please enter a valid 10-digit phone number</div>
                </div>
                <div class="form-group">
                    <label for="propertyType">Property Type</label>
                    <select id="propertyType" name="propertyType" disabled>
                        <option value="Luxury Apartment" <%= "Luxury Apartment".equals(apartment.getPropertyType()) ? "selected" : "" %>>Luxury Apartment</option>
                        <option value="Modern Studio" <%= "Modern Studio".equals(apartment.getPropertyType()) ? "selected" : "" %>>Modern Studio</option>
                        <option value="Family Apartment" <%= "Family Apartment".equals(apartment.getPropertyType()) ? "selected" : "" %>>Family Apartment</option>
                        <option value="City View Flat" <%= "City View Flat".equals(apartment.getPropertyType()) ? "selected" : "" %>>City View Flat</option>
                        <option value="Penthouse" <%= "Penthouse".equals(apartment.getPropertyType()) ? "selected" : "" %>>Penthouse</option>
                        <option value="Duplex" <%= "Duplex".equals(apartment.getPropertyType()) ? "selected" : "" %>>Duplex</option>
                        <option value="Loft" <%= "Loft".equals(apartment.getPropertyType()) ? "selected" : "" %>>Loft</option>
                        <option value="Condominium" <%= "Condominium".equals(apartment.getPropertyType()) ? "selected" : "" %>>Condominium</option>
                        <option value="Not specified" <%= apartment.getPropertyType() == null || apartment.getPropertyType().isEmpty() ? "selected" : "" %>>Not specified</option>
                    </select>
                    <div class="readonly-note">This field cannot be updated</div>
                </div>
            </div>
        </div>

                <!-- Maintenance Status Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fa-solid fa-screwdriver-wrench"></i> Maintenance
                    </h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="underMaintenance">Under Maintenance</label>
                            <input type="checkbox" id="underMaintenance" name="underMaintenance"
                                   <%= apartment.getStatus() != null && ("Under Maintenance".equalsIgnoreCase(apartment.getStatus()) || "Maintenance".equalsIgnoreCase(apartment.getStatus())) ? "checked" : "" %> >
                            <div class="readonly-note">If checked, this apartment will be marked as "Under Maintenance" mode.</div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> Update Apartment
                    </button>
                    <a href="sellerdashboard.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Enhanced form validation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('editApartmentForm');

        // Real-time validation (exclude readonly fields)
        const inputs = form.querySelectorAll('input[required]:not([readonly]), textarea[required], select[required]:not([disabled])');
        inputs.forEach(input => {
            input.addEventListener('blur', validateField);
            input.addEventListener('input', clearError);
        });

        // Special validation for numeric fields
        const numericFields = form.querySelectorAll('input[type="number"]');
        numericFields.forEach(field => {
            field.addEventListener('input', validateNumericField);
        });

        // Form submission validation
        form.addEventListener('submit', validateFormSubmission);

        // Auto-hide messages after 5 seconds
        autoHideMessages();

        // Validation functions
        function validateField(e) {
            const field = e.target;
            const value = field.value.trim();
            const fieldName = field.name;
            const errorElement = document.getElementById(fieldName + 'Error');

            if (!errorElement) return;

            let isValid = true;
            let errorMessage = '';

            switch (fieldName) {
                case 'title':
                    if (value.length === 0) {
                        errorMessage = 'Title is required';
                        isValid = false;
                    } else if (value.length > 255) {
                        errorMessage = 'Title cannot exceed 255 characters';
                        isValid = false;
                    }
                    break;

                case 'price':
                    if (value.length === 0) {
                        errorMessage = 'Price is required';
                        isValid = false;
                    } else if (parseFloat(value) <= 0) {
                        errorMessage = 'Price must be greater than 0';
                        isValid = false;
                    } else if (parseFloat(value) > 1000000000) {
                        errorMessage = 'Price is too high';
                        isValid = false;
                    }
                    break;

                case 'description':
                    if (value.length === 0) {
                        errorMessage = 'Description is required';
                        isValid = false;
                    } else if (value.length > 4000) {
                        errorMessage = 'Description is too long';
                        isValid = false;
                    }
                    break;

                case 'bedrooms':
                    if (value.length > 0) {
                        if (parseInt(value) <= 0) {
                            errorMessage = 'Bedrooms must be greater than 0';
                            isValid = false;
                        } else if (parseInt(value) > 20) {
                            errorMessage = 'Bedrooms cannot exceed 20';
                            isValid = false;
                        }
                    }
                    break;

                case 'bathrooms':
                    if (value.length > 0) {
                        if (parseInt(value) <= 0) {
                            errorMessage = 'Bathrooms must be greater than 0';
                            isValid = false;
                        } else if (parseInt(value) > 20) {
                            errorMessage = 'Bathrooms cannot exceed 20';
                            isValid = false;
                        }
                    }
                    break;

                case 'areaSqft':
                    if (value.length > 0) {
                        if (parseFloat(value) <= 0) {
                            errorMessage = 'Area must be greater than 0';
                            isValid = false;
                        } else if (parseFloat(value) > 100000) {
                            errorMessage = 'Area cannot exceed 100,000 sqft';
                            isValid = false;
                        }
                    }
                    break;

                case 'contactNumber':
                    if (value.length === 0) {
                        errorMessage = 'Contact number is required';
                        isValid = false;
                    } else if (!/^[0-9]{10}$/.test(value)) {
                        errorMessage = 'Please enter a valid 10-digit phone number';
                        isValid = false;
                    }
                    break;
            }

            if (!isValid) {
                field.classList.add('error');
                errorElement.textContent = errorMessage;
                errorElement.style.display = 'block';
            } else {
                field.classList.remove('error');
                errorElement.style.display = 'none';
            }
        }

        function validateNumericField(e) {
            const field = e.target;
            const value = field.value;

            // Prevent negative values
            if (value < 0) {
                field.value = '';
            }

            // Prevent decimal values for bedrooms and bathrooms
            if (field.name === 'bedrooms' || field.name === 'bathrooms') {
                if (value.includes('.')) {
                    field.value = Math.floor(value);
                }
            }
        }

        function clearError(e) {
            const field = e.target;
            const fieldName = field.name;
            const errorElement = document.getElementById(fieldName + 'Error');

            if (errorElement) {
                errorElement.style.display = 'none';
                field.classList.remove('error');
            }
        }

        function validateFormSubmission(e) {
            let isValid = true;

            // Validate all required fields (exclude readonly/disabled)
            const editableInputs = form.querySelectorAll('input[required]:not([readonly]), textarea[required], select[required]:not([disabled])');
            editableInputs.forEach(input => {
                const event = new Event('blur');
                input.dispatchEvent(event);

                if (input.classList.contains('error')) {
                    isValid = false;
                }
            });

            if (!isValid) {
                e.preventDefault();

                // Scroll to first error
                const firstError = form.querySelector('.error');
                if (firstError) {
                    firstError.scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                    firstError.focus();
                }

                // Show summary message
                showTemporaryMessage('Please fix the errors in the form before submitting.', 'error');
            } else {
                // Show loading state
                const submitBtn = form.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '⏳ Updating Apartment...';
                submitBtn.disabled = true;

                // Re-enable after 5 seconds if still on page (form submission failed)
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 5000);
            }

            return isValid;
        }

        function showTemporaryMessage(message, type) {
            const messageDiv = document.createElement('div');
            messageDiv.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 10px;
                color: white;
                font-weight: 600;
                z-index: 10000;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                animation: slideIn 0.3s ease;
            `;

            if (type === 'error') {
                messageDiv.style.background = 'linear-gradient(135deg, #e74c3c, #c0392b)';
            } else {
                messageDiv.style.background = 'linear-gradient(135deg, #27ae60, #229954)';
            }

            messageDiv.textContent = message;
            document.body.appendChild(messageDiv);

            // Remove after 5 seconds
            setTimeout(() => {
                messageDiv.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.parentNode.removeChild(messageDiv);
                    }
                }, 300);
            }, 5000);
        }

        function autoHideMessages() {
            const messages = document.querySelectorAll('.error-message, .success-message');
            messages.forEach(message => {
                setTimeout(() => {
                    message.style.opacity = '0';
                    message.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => {
                        if (message.parentNode) {
                            message.parentNode.removeChild(message);
                        }
                    }, 500);
                }, 8000); // Hide after 8 seconds
            });
        }

        // Add CSS animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    });

    // Basic form validation function for form submission
    function validateForm() {
        const title = document.getElementById('title').value.trim();
        const price = document.getElementById('price').value.trim();
        const description = document.getElementById('description').value.trim();
        const bedrooms = document.getElementById('bedrooms').value.trim();
        const bathrooms = document.getElementById('bathrooms').value.trim();
        const contactNumber = document.getElementById('contactNumber').value.trim();

        if (!title || !price || !description || !bedrooms || !bathrooms) {
            alert('Please fill in all required fields');
            return false;
        }

        if (parseFloat(price) <= 0) {
            alert('Price must be greater than 0');
            return false;
        }

        if (parseInt(bedrooms) <= 0 || parseInt(bedrooms) > 20) {
            alert('Bedrooms must be between 1 and 20');
            return false;
        }

        if (parseInt(bathrooms) <= 0 || parseInt(bathrooms) > 20) {
            alert('Bathrooms must be between 1 and 20');
            return false;
        }

        // Contact number is optional, but if provided, must be valid
        if (contactNumber && !/^[0-9]{10}$/.test(contactNumber)) {
            alert('Please enter a valid 10-digit phone number');
            return false;
        }

        return true;
    }
</script>
</body>
</html>