<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration - ApartmentX</title>
    <link rel="stylesheet" href="css/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Admin-specific styling */
        .register-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .register-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            position: relative;
            overflow: hidden;
        }
        
        .register-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .admin-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .admin-header h1 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .admin-header .admin-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .admin-header p {
            color: #666;
            font-size: 1rem;
            margin: 0;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-group input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 1.1rem;
        }
        
        .register-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .register-btn:active {
            transform: translateY(0);
        }
        
        .error-message {
            background: #fee;
            color: #c33;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
            font-size: 0.95rem;
        }
        
        .success-message {
            background: #efe;
            color: #3c3;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3c3;
            font-size: 0.95rem;
        }
        
        .back-to-login {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-to-login a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .back-to-login a:hover {
            color: #764ba2;
        }
        
        .admin-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
            border-left: 4px solid #667eea;
        }
        
        .admin-info h4 {
            color: #333;
            margin: 0 0 10px 0;
            font-size: 1rem;
        }
        
        .admin-info p {
            color: #666;
            margin: 5px 0;
            font-size: 0.9rem;
        }
        
        .admin-info strong {
            color: #333;
        }
        
        @media (max-width: 480px) {
            .register-card {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .admin-header h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-card">
            <div class="admin-header">
                <h1><i class="fa-solid fa-user-plus"></i> Admin Registration</h1>
                <div class="admin-badge">
                    <i class="fa-solid fa-user-shield"></i> Create Administrator Account
                </div>
                <p>Register a new administrator for the system</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message">
                    <i class="fa-solid fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form action="AdminRegistrationServlet" method="post" id="adminRegistrationForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">
                            <i class="fa-solid fa-user"></i> First Name
                        </label>
                        <input type="text" id="firstName" name="firstName" required 
                               placeholder="Enter first name"
                               value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName">
                            <i class="fa-solid fa-user"></i> Last Name
                        </label>
                        <input type="text" id="lastName" name="lastName" required 
                               placeholder="Enter last name"
                               value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="username">
                        <i class="fa-solid fa-at"></i> Username
                    </label>
                    <input type="text" id="username" name="username" required 
                           placeholder="Choose a username"
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="email">
                        <i class="fa-solid fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" required 
                           placeholder="Enter email address"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="phone">
                        <i class="fa-solid fa-phone"></i> Phone Number (Optional)
                    </label>
                    <input type="tel" id="phone" name="phone" 
                           placeholder="Enter phone number"
                           value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">
                            <i class="fa-solid fa-lock"></i> Password
                        </label>
                        <input type="password" id="password" name="password" required 
                               placeholder="Enter password (min 6 characters)">
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">
                            <i class="fa-solid fa-lock"></i> Confirm Password
                        </label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               placeholder="Confirm password">
                    </div>
                </div>
                
                <button type="submit" class="register-btn">
                    <i class="fa-solid fa-user-plus"></i> Register Admin
                </button>
            </form>
            
            <div class="admin-info">
                <h4><i class="fa-solid fa-info-circle"></i> Admin Registration Info</h4>
                <p><strong>Username:</strong> Must be unique across all admins</p>
                <p><strong>Email:</strong> Must be unique and valid email format</p>
                <p><strong>Password:</strong> Minimum 6 characters required</p>
                <p><strong>Access:</strong> Full administrative privileges</p>
            </div>
            
            <div class="back-to-login">
                <a href="adminlogin.jsp">
                    <i class="fa-solid fa-arrow-left"></i> Back to Admin Login
                </a>
            </div>
        </div>
    </div>
    
    <script>
        // Form validation and enhancement
        document.getElementById('adminRegistrationForm').addEventListener('submit', function(e) {
            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            
            if (!firstName || !lastName || !username || !email || !password || !confirmPassword) {
                e.preventDefault();
                alert('Please fill in all required fields');
                return false;
            }
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long');
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('.register-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Registering...';
            submitBtn.disabled = true;
            
            // Re-enable button after 5 seconds (in case of error)
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 5000);
        });
        
        // Auto-focus on first name field
        document.getElementById('firstName').focus();
        
        // Real-time password confirmation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#e1e5e9';
            }
        });
        
        console.log('Admin Registration Page Loaded');
    </script>
</body>
</html>
