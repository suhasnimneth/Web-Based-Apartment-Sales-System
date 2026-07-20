<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in and has seller role - this is necessary for security
    Object userObj = session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");

    if (userObj == null || !"seller".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get user information if needed
    com.project.model.User user = (com.project.model.User) userObj;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Apartment - Apartment X</title>
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
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
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
            z-index: 10;
        }

        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .page-header {
            background: linear-gradient(135deg, #e63946 0%, #f77f00 100%);
            border-radius: 20px;
            padding: 40px;
            color: white;
            text-align: center;
            margin-bottom: 30px;
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

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-title i {
            font-size: 2rem;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
        }

        /* Form Styles */
        .form-section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #34495e;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ecf0f1;
            font-size: 1.4rem;
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
            color: #2c3e50;
            font-size: 14px;
        }

        .required::after {
            content: " *";
            color: #e74c3c;
        }

        input[type="text"],
        input[type="number"],
        input[type="tel"],
        textarea,
        select {
            width: 100%;
            padding: 15px;
            border: 2px solid #bdc3c7;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        input.error,
        textarea.error,
        select.error {
            border-color: #e74c3c;
            background: #fdf2f2;
        }

        textarea {
            height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        /* Image Upload */
        .image-upload {
            border: 3px dashed #bdc3c7;
            padding: 40px;
            text-align: center;
            border-radius: 15px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .image-upload:hover {
            border-color: #3498db;
            background: #fff;
        }

        .image-upload.drag-over {
            border-color: #27ae60;
            background: #e8f6f3;
        }

        .upload-icon {
            font-size: 3rem;
            color: #7f8c8d;
            margin-bottom: 15px;
        }

        .upload-text {
            margin-bottom: 20px;
            color: #7f8c8d;
            font-size: 16px;
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
            gap: 8px;
            box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            box-shadow: 0 4px 15px rgba(67, 233, 123, 0.3);
        }

        .btn-primary:hover {
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
        }

        .btn-secondary:hover {
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .btn-danger:hover {
            box-shadow: 0 8px 25px rgba(231, 76, 60, 0.4);
        }

        /* Messages */
        .error-message {
            color: #c0392b;
            background: #fadbd8;
            border: 1px solid #f5b7b1;
            padding: 15px 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            font-weight: 500;
        }

        .success-message {
            color: #27ae60;
            background: #d5f4e6;
            border: 1px solid #a3e4d7;
            padding: 15px 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            font-weight: 500;
        }

        /* Image Preview */
        #imagePreview {
            margin-top: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
        }

        .image-preview-item {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .image-preview-item:hover {
            transform: scale(1.05);
        }

        .image-preview-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            display: block;
        }

        .remove-image {
            position: absolute;
            top: 8px;
            right: 8px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .remove-image:hover {
            background: #c0392b;
            transform: scale(1.1);
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .validation-error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
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

            .page-title {
                font-size: 2rem;
            }

            .image-upload {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 15px;
            }

            .page-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<div class="main-content">
    <a href="sellerdashboard.jsp" class="back-btn">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

    <div class="page-header">
        <h1 class="page-title">
            <i class="fa-solid fa-plus"></i> Add New Apartment
        </h1>
    </div>

    <div class="container">

    <!-- Display Messages -->
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message" id="errorMessage"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="success-message" id="successMessage"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <form id="addApartmentForm" action="AddApartmentServlet" method="post" enctype="multipart/form-data">
        <!-- Basic Information Section -->
        <div class="form-section">
            <h2 class="section-title">Basic Information</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="title" class="required">Apartment Title</label>
                    <input type="text" id="title" name="title" placeholder="e.g., Luxury 3-Bedroom Apartment" required>
                    <div class="validation-error" id="titleError">Please enter a title</div>
                </div>
                <div class="form-group">
                    <label for="price" class="required">Price (Rs.)</label>
                    <input type="number" id="price" name="price" step="0.01" min="1" placeholder="Enter price" required>
                    <div class="validation-error" id="priceError">Price must be greater than 0</div>
                </div>
            </div>

            <div class="form-group full-width">
                <label for="description" class="required">Description</label>
                <textarea id="description" name="description" placeholder="Describe the apartment features, amenities, location advantages, etc." required></textarea>
                <div class="validation-error" id="descriptionError">Please enter a description</div>
            </div>
        </div>

        <!-- Property Details Section -->
        <div class="form-section">
            <h2 class="section-title">Property Details</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="bedrooms" class="required">Bedrooms</label>
                    <input type="number" id="bedrooms" name="bedrooms" min="1" placeholder="Number of bedrooms" required>
                    <div class="validation-error" id="bedroomsError">Must be at least 1</div>
                </div>
                <div class="form-group">
                    <label for="bathrooms" class="required">Bathrooms</label>
                    <input type="number" id="bathrooms" name="bathrooms" min="1" placeholder="Number of bathrooms" required>
                    <div class="validation-error" id="bathroomsError">Must be at least 1</div>
                </div>
                <div class="form-group">
                    <label for="areaSqFt" class="required">Area (sqft)</label>
                    <input type="number" id="areaSqFt" name="areaSqFt" min="1" max="100000" step="0.01" placeholder="Area in square feet" required>
                    <div class="validation-error" id="areaError">Must be between 1-100,000 sqft</div>
                </div>
            </div>
        </div>

        <!-- Location Information Section -->
        <div class="form-section">
            <h2 class="section-title">Location Information</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="location" class="required">Location/Area</label>
                    <input type="text" id="location" name="location" placeholder="e.g., Colombo 7" required>
                    <div class="validation-error" id="locationError">Please enter location</div>
                </div>
                <div class="form-group">
                    <label for="city" class="required">City</label>
                    <input type="text" id="city" name="city" placeholder="e.g., Colombo" required>
                    <div class="validation-error" id="cityError">Please enter city</div>
                </div>
                <div class="form-group">
                    <label for="state" class="required">State/Province</label>
                    <input type="text" id="state" name="state" placeholder="e.g., Western Province" required>
                    <div class="validation-error" id="stateError">Please enter state</div>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group full-width">
                    <label for="address" class="required">Full Address</label>
                    <input type="text" id="address" name="address" placeholder="Enter complete address" required>
                    <div class="validation-error" id="addressError">Please enter address</div>
                </div>
                <div class="form-group">
                    <label for="postalCode">Postal Code</label>
                    <input type="text" id="postalCode" name="postalCode" placeholder="e.g., 00700">
                </div>
            </div>
        </div>

        <!-- Contact Information Section -->
        <div class="form-section">
            <h2 class="section-title">Contact Information</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="contactNumber" class="required">Contact Number</label>
                    <input type="tel" id="contactNumber" name="contactNumber" placeholder="e.g., 0771234567" pattern="[0-9]{10}" required>
                    <div class="validation-error" id="contactError">Please enter a valid 10-digit phone number</div>
                </div>
                <div class="form-group">
                    <label for="propertyType">Property Type</label>
                    <select id="propertyType" name="propertyType">
                        <option value="Luxury Apartment">Luxury Apartment</option>
                        <option value="Modern Studio">Modern Studio</option>
                        <option value="Family Apartment">Family Apartment</option>
                        <option value="City View Flat">City View Flat</option>
                        <option value="Penthouse">Penthouse</option>
                        <option value="Duplex">Duplex</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Available">Available</option>
                        <option value="Sold">Sold</option>
                        <option value="Reserved">Reserved</option>
                        <option value="Under Maintenance">Under Maintenance</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Images Section -->
        <div class="form-section">
            <h2 class="section-title">Apartment Images</h2>
            <div class="image-upload" id="imageUploadArea">
                <div class="upload-icon">
                    <i class="fa-solid fa-camera"></i>
                </div>
                <p class="upload-text">Drag & drop images here or click to browse</p>
                <input type="file" id="images" name="images" accept="image/*" multiple required style="display: none;">
                <button type="button" onclick="document.getElementById('images').click()" class="btn">
                    <i class="fa-solid fa-folder-open"></i> Choose Images
                </button>
                <p style="margin-top: 10px; color: #7f8c8d; font-size: 14px;">
                    First image will be used as the primary display image. Maximum 10 images.
                </p>
            </div>
            <div id="imagePreview"></div>
            <div class="validation-error" id="imageError">Please select at least one image</div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-plus"></i> Add Apartment
            </button>
            <button type="reset" class="btn btn-secondary">
                <i class="fa-solid fa-rotate"></i> Reset Form
            </button>
            <a href="sellerdashboard.jsp" class="btn btn-danger">
                <i class="fa-solid fa-times"></i> Cancel
            </a>
        </div>
    </form>
    </div>
</div>

<script>
    // Enhanced form validation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('addApartmentForm');
        const fileInput = document.getElementById('images');
        const imageUploadArea = document.getElementById('imageUploadArea');
        const imagePreview = document.getElementById('imagePreview');
        const imageError = document.getElementById('imageError');

        // Real-time validation
        const inputs = form.querySelectorAll('input[required], textarea[required]');
        inputs.forEach(input => {
            input.addEventListener('blur', validateField);
            input.addEventListener('input', clearError);
        });

        // Special validation for numeric fields
        const numericFields = form.querySelectorAll('input[type="number"]');
        numericFields.forEach(field => {
            field.addEventListener('input', validateNumericField);
        });

        // Contact number validation
        const contactInput = document.getElementById('contactNumber');
        contactInput.addEventListener('input', validateContactNumber);

        // Image upload handling
        fileInput.addEventListener('change', handleImageSelection);

        // Drag and drop functionality
        setupDragAndDrop();

        // Form submission validation
        form.addEventListener('submit', validateFormSubmission);

        // Reset form handling
        form.addEventListener('reset', resetForm);

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
                    if (value.length === 0) {
                        errorMessage = 'Bedrooms is required';
                        isValid = false;
                    } else if (parseInt(value) <= 0) {
                        errorMessage = 'Bedrooms must be greater than 0';
                        isValid = false;
                    }
                    break;

                case 'bathrooms':
                    if (value.length === 0) {
                        errorMessage = 'Bathrooms is required';
                        isValid = false;
                    } else if (parseInt(value) <= 0) {
                        errorMessage = 'Bathrooms must be greater than 0';
                        isValid = false;
                    }
                    break;

                case 'areaSqFt':
                    if (value.length === 0) {
                        errorMessage = 'Area is required';
                        isValid = false;
                    } else if (parseFloat(value) <= 0) {
                        errorMessage = 'Area must be greater than 0';
                        isValid = false;
                    } else if (parseFloat(value) > 100000) {
                        errorMessage = 'Area cannot exceed 100,000 sqft';
                        isValid = false;
                    }
                    break;

                case 'location':
                    if (value.length === 0) {
                        errorMessage = 'Location is required';
                        isValid = false;
                    } else if (value.length > 255) {
                        errorMessage = 'Location is too long';
                        isValid = false;
                    }
                    break;

                case 'city':
                    if (value.length === 0) {
                        errorMessage = 'City is required';
                        isValid = false;
                    } else if (value.length > 100) {
                        errorMessage = 'City name is too long';
                        isValid = false;
                    }
                    break;

                case 'state':
                    if (value.length === 0) {
                        errorMessage = 'State is required';
                        isValid = false;
                    } else if (value.length > 100) {
                        errorMessage = 'State name is too long';
                        isValid = false;
                    }
                    break;

                case 'address':
                    if (value.length === 0) {
                        errorMessage = 'Address is required';
                        isValid = false;
                    } else if (value.length > 500) {
                        errorMessage = 'Address is too long';
                        isValid = false;
                    }
                    break;

                case 'contactNumber':
                    if (value.length === 0) {
                        errorMessage = 'Contact number is required';
                        isValid = false;
                    } else if (!isValidContactNumberFormat(value)) {
                        errorMessage = 'Contact number must be 10 digits';
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

            updateSubmitButton();
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

        function validateContactNumber(e) {
            const field = e.target;
            const value = field.value.replace(/\D/g, ''); // Remove non-digits
            field.value = value; // Update field with digits only

            // Limit to 10 digits
            if (value.length > 10) {
                field.value = value.substring(0, 10);
            }

            // Auto-validate if user has entered 10 digits
            if (value.length === 10) {
                validateField(e);
            }
        }

        function isValidContactNumberFormat(number) {
            return /^\d{10}$/.test(number);
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

        function handleImageSelection(e) {
            const files = e.target.files;
            imageError.style.display = 'none';

            if (files.length === 0) {
                imagePreview.innerHTML = '<p style="color: #7f8c8d; text-align: center; grid-column: 1 / -1;">No images selected</p>';
                return;
            }

            // Validate number of images
            if (files.length > 10) {
                imageError.textContent = 'Maximum 10 images allowed. Please select fewer images.';
                imageError.style.display = 'block';
                fileInput.value = '';
                imagePreview.innerHTML = '';
                return;
            }

            imagePreview.innerHTML = '';
            let validImages = 0;

            for (let i = 0; i < files.length; i++) {
                const file = files[i];

                // Validate file type
                if (!file.type.startsWith('image/')) {
                    continue;
                }

                // Validate file size (5MB max)
                if (file.size > 5 * 1024 * 1024) {
                    imageError.textContent = `Image "${file.name}" is too large. Maximum size is 5MB.`;
                    imageError.style.display = 'block';
                    continue;
                }

                validImages++;
                const reader = new FileReader();

                reader.onload = function(e) {
                    createImagePreview(e.target.result, file.name, i);
                };

                reader.readAsDataURL(file);
            }

            if (validImages === 0) {
                imageError.textContent = 'No valid images selected. Please select image files (JPEG, PNG, etc.) under 5MB.';
                imageError.style.display = 'block';
            }

            updateSubmitButton();
        }

        function createImagePreview(dataUrl, fileName, index) {
            const previewItem = document.createElement('div');
            previewItem.className = 'image-preview-item';
            previewItem.dataset.index = index;

            const img = document.createElement('img');
            img.src = dataUrl;
            img.alt = `Preview ${fileName}`;
            img.loading = 'lazy';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'remove-image';
            removeBtn.innerHTML = '×';
            removeBtn.title = 'Remove this image';
            removeBtn.onclick = function() {
                removeImageFromInput(index);
                previewItem.remove();
                updateImagePreviewLayout();
                updateSubmitButton();
            };

            const imageInfo = document.createElement('div');
            imageInfo.style.cssText = 'position: absolute; bottom: 0; left: 0; right: 0; background: rgba(0,0,0,0.7); color: white; padding: 5px; font-size: 10px; text-align: center;';
            imageInfo.textContent = fileName.length > 15 ? fileName.substring(0, 12) + '...' : fileName;

            previewItem.appendChild(img);
            previewItem.appendChild(removeBtn);
            previewItem.appendChild(imageInfo);
            imagePreview.appendChild(previewItem);

            updateImagePreviewLayout();
        }

        function removeImageFromInput(index) {
            const dt = new DataTransfer();
            const files = fileInput.files;

            for (let i = 0; i < files.length; i++) {
                if (i !== index) {
                    dt.items.add(files[i]);
                }
            }

            fileInput.files = dt.files;
        }

        function updateImagePreviewLayout() {
            const items = imagePreview.querySelectorAll('.image-preview-item');
            if (items.length === 0) {
                imagePreview.innerHTML = '<p style="color: #7f8c8d; text-align: center; grid-column: 1 / -1;">No images selected</p>';
            }
        }

        function setupDragAndDrop() {
            // Prevent default drag behaviors
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                imageUploadArea.addEventListener(eventName, preventDefaults, false);
                document.body.addEventListener(eventName, preventDefaults, false);
            });

            // Highlight drop area when item is dragged over it
            ['dragenter', 'dragover'].forEach(eventName => {
                imageUploadArea.addEventListener(eventName, highlight, false);
            });

            ['dragleave', 'drop'].forEach(eventName => {
                imageUploadArea.addEventListener(eventName, unhighlight, false);
            });

            // Handle dropped files
            imageUploadArea.addEventListener('drop', handleDrop, false);

            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }

            function highlight() {
                imageUploadArea.classList.add('drag-over');
            }

            function unhighlight() {
                imageUploadArea.classList.remove('drag-over');
            }

            function handleDrop(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                fileInput.files = files;
                handleImageSelection({ target: fileInput });
            }
        }

        function validateFormSubmission(e) {
            let isValid = true;
            const errorMessages = [];

            // Validate all required fields
            inputs.forEach(input => {
                const event = new Event('blur');
                input.dispatchEvent(event);

                if (input.classList.contains('error')) {
                    isValid = false;
                }
            });

            // Validate images
            if (fileInput.files.length === 0) {
                imageError.textContent = 'Please select at least one image';
                imageError.style.display = 'block';
                isValid = false;
            } else if (fileInput.files.length > 10) {
                imageError.textContent = 'Maximum 10 images allowed';
                imageError.style.display = 'block';
                isValid = false;
            }

            // Additional validation for contact number
            const contactNumber = document.getElementById('contactNumber').value;
            if (contactNumber && !isValidContactNumberFormat(contactNumber)) {
                const contactError = document.getElementById('contactNumberError');
                contactError.textContent = 'Contact number must be exactly 10 digits';
                contactError.style.display = 'block';
                document.getElementById('contactNumber').classList.add('error');
                isValid = false;
            }

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
                submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Adding Apartment...';
                submitBtn.disabled = true;

                // Re-enable after 5 seconds if still on page (form submission failed)
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 5000);
            }

            return isValid;
        }

        function resetForm() {
            // Clear all errors
            inputs.forEach(input => {
                input.classList.remove('error');
                const errorElement = document.getElementById(input.name + 'Error');
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
            });

            // Clear image preview
            imagePreview.innerHTML = '<p style="color: #7f8c8d; text-align: center; grid-column: 1 / -1;">No images selected</p>';
            imageError.style.display = 'none';

            // Clear file input
            fileInput.value = '';

            updateSubmitButton();

            // Show reset confirmation
            showTemporaryMessage('Form has been reset.', 'success');
        }

        function updateSubmitButton() {
            const submitBtn = form.querySelector('button[type="submit"]');
            const hasErrors = form.querySelectorAll('.error').length > 0;
            const hasImages = fileInput.files.length > 0;

            // You can add visual indicators here if needed
            // For now, we'll just return since the form validation will handle submission
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

            .pulse {
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(style);

        // Initialize image preview state
        updateImagePreviewLayout();
    });
</script>
</body>
</html>