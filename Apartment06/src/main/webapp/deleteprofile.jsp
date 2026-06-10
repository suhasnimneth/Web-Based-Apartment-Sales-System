<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in - using correct session attribute names
    Object userObj = session.getAttribute("user"); // Changed from "loggedInUser" to "user"
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    com.project.model.User user = (com.project.model.User) userObj; // Changed from "loggedInUser" to userObj
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Profile - Apartment X</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #dc3545;
            text-align: center;
            margin-bottom: 20px;
        }

        .warning-message {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .profile-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .profile-info h3 {
            margin-top: 0;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        input[type="password"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }

        textarea {
            height: 80px;
            resize: vertical;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #545b62;
        }

        .error-message {
            color: red;
            margin: 10px 0;
            text-align: center;
        }

        .success-message {
            color: green;
            margin: 10px 0;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff0000;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .confirm-section {
            display: none;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
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

    </style>
</head>
<body>
<div class="container">
    <button class="back-btn"
            onclick="window.location.href='<%= "buyer".equals(userRole) ? "buyerdashboard.jsp" : "sellerdashboard.jsp" %>'">
        Back
    </button>

    <h2>Delete Profile</h2>

    <!-- Display error/success messages -->
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="success-message"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <div class="warning-message">
        <strong>⚠️ Warning: This action cannot be undone!</strong><br>
        Deleting your profile will permanently remove all your data from our system.
    </div>

    <div class="profile-info">
        <h3>Your Profile Information</h3>
        <p><strong>Name:</strong> <%= user.getFirstName() %> <%= user.getLastName() %></p>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Role:</strong> <%= user.getRole().toUpperCase() %></p>
        <p><strong>Registration Date:</strong> <%= user.getRegistrationDate() != null ? user.getRegistrationDate() : "N/A" %></p>
    </div>

    <form id="deleteProfileForm" action="DeleteProfileServlet" method="post" onsubmit="return confirmDeletion(event)">
        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Enter your current password" required>
        </div>

        <div class="form-group">
            <label for="deleteReason">Reason for Deletion (Optional)</label>
            <textarea id="deleteReason" name="deleteReason" placeholder="Why are you deleting your account?"></textarea>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" id="confirmCheckbox" required>
                I understand that this action is permanent and cannot be undone
            </label>
        </div>

        <button type="submit" class="btn btn-danger">Delete Profile</button>
        <a href="<%= "buyer".equals(userRole) ? "buyerdashboard.jsp" : "sellerdashboard.jsp" %>" class="btn btn-secondary">Cancel</a>
    </form>

    <div id="confirmSection" class="confirm-section">
        <h3>Are you absolutely sure?</h3>
        <p>This action cannot be undone. All your data will be permanently deleted.</p>
        <button type="button" class="btn btn-danger" onclick="submitForm()">Yes, Delete My Account</button>
        <button type="button" class="btn btn-secondary" onclick="cancelDeletion()">Cancel</button>
    </div>
</div>

<script>
    let formToSubmit = null;

    function confirmDeletion(event) {
        event.preventDefault();

        const password = document.getElementById('confirmPassword').value;
        const checkbox = document.getElementById('confirmCheckbox').checked;

        if (!password || !checkbox) {
            alert('Please fill in the password and confirm the deletion.');
            return false;
        }

        document.getElementById('confirmSection').style.display = 'block';
        formToSubmit = event.target;

        return false;
    }

    function submitForm() {
        if (formToSubmit) {
            formToSubmit.submit();
        }
    }

    function cancelDeletion() {
        document.getElementById('confirmSection').style.display = 'none';
    }
</script>
</body>
</html>