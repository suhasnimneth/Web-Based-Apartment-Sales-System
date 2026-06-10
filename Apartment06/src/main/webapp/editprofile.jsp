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
    <title>Edit Profile - Apartment X</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: #f5f5f5;
        }

        .main-content {
            padding: 80px 30px 30px 30px;
            max-width: 900px;
            margin: 0 auto;
            position: relative;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            border: 1px solid rgba(230, 57, 70, 0.1);
        }

        .back-btn {
            position: fixed;
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
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            padding: 40px;
            border-radius: 20px;
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
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0 0 10px 0;
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

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="date"],
        input[type="password"],
        textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 16px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        input[type="date"]:focus,
        input[type="password"]:focus,
        textarea:focus {
            outline: none;
            border-color: #e63946;
            background: white;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .btn {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            margin-right: 15px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(67, 233, 123, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 233, 123, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(149, 165, 166, 0.4);
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
            color: #ff003b;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
<div class="main-content">
    <a href="<%= "buyer".equals(userRole) ? "buyerdashboard.jsp" : "sellerdashboard.jsp" %>" class="back-btn">
         Back
    </a>
    
    <div class="container">
        <div class="page-header">
            <h1><i class="fa-solid fa-user-edit"></i> Edit Profile</h1>
            <p>Update your personal information and account settings</p>
        </div>

        <!-- Display error/success messages -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success-message"><%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form id="editProfileForm" action="UpdateProfileServlet" method="post">
        <div class="form-row">
            <div class="form-group">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName" value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName" name="lastName" value="<%= user.getLastName() != null ? user.getLastName() : "" %>" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="contactNumber">Contact Number</label>
            <input type="tel" id="contactNumber" name="contactNumber" value="<%= user.getContactNumber() != null ? user.getContactNumber() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
        </div>

        <!-- Fixed: Proper date conversion -->
        <div class="form-group">
            <label for="dateOfBirth">Date of Birth</label>
            <input type="date" id="dateOfBirth" name="dateOfBirth"
                   value="<%= user.getDateOfBirth() != null ? user.getDateOfBirth() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="newPassword">New Password (leave blank to keep current)</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Leave blank to keep current password">
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
        </div>

        <button type="submit" class="btn">
            <i class="fa-solid fa-save"></i> Update Profile
        </button>
        <a href="<%= "buyer".equals(userRole) ? "buyerdashboard.jsp" : "sellerdashboard.jsp" %>" class="btn btn-secondary">
            <i class="fa-solid fa-times"></i> Cancel
        </a>
    </form>
</div>
</div>

<script>
    document.getElementById('editProfileForm').addEventListener('submit', function(e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword && newPassword !== confirmPassword) {
            e.preventDefault();
            alert('New password and confirmation do not match.');
            return false;
        }
    });
</script>
</body>
</html>