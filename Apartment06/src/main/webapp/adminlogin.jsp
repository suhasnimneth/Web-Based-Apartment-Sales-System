<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - ApartmentX</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Admin-specific styling */
        .login-container {
            background: #f8f8f8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            position: relative;
            overflow: hidden;
        }
        
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: #e63946;
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
            background: #e63946;
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
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
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
            border-color: #e63946;
            background: white;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }
        
        .form-group i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 1.1rem;
        }
        
        .login-btn {
            width: 100%;
            padding: 15px;
            background: #e63946;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(230, 57, 70, 0.3);
            background: #d62828;
        }
        
        .login-btn:active {
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
        
        .back-to-home {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-to-home a {
            color: #e63946;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .back-to-home a:hover {
            color: #d62828;
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
            .login-card {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .admin-header h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="admin-header">
                <h1><i class="fa-solid fa-shield-halved"></i> Admin Portal</h1>
                <div class="admin-badge">
                    <i class="fa-solid fa-user-shield"></i> Administrator Access
                </div>
                <p>Sign in to access the admin dashboard</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="AdminLoginServlet" method="post" id="adminLoginForm">
                <div class="form-group">
                    <label for="username">
                        <i class="fa-solid fa-user"></i> Username or Email
                    </label>
                    <input type="text" id="username" name="username" required 
                           placeholder="Enter your username or email"
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="password">
                        <i class="fa-solid fa-lock"></i> Password
                    </label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Enter your password">
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fa-solid fa-sign-in-alt"></i> Sign In as Admin
                </button>
            </form>
            
            <div class="back-to-home">
                <a href="index.jsp">
                    <i class="fa-solid fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </div>
    </div>
    
    <script>
        // Form validation and enhancement
        document.getElementById('adminLoginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!username || !password) {
                e.preventDefault();
                alert('Please fill in all fields');
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('.login-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Signing In...';
            submitBtn.disabled = true;
            
            // Re-enable button after 3 seconds (in case of error)
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 3000);
        });
        
        // Auto-focus on username field
        document.getElementById('username').focus();
        
        // Enter key handling
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('adminLoginForm').submit();
            }
        });
        
        console.log('Admin Login Page Loaded');
    </script>
</body>
</html>
