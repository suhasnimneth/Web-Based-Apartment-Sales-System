<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="java.util.Map" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (admin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    Admin currentAdmin = (Admin) request.getAttribute("currentAdmin");
    if (currentAdmin == null) {
        currentAdmin = admin;
    }
    
    @SuppressWarnings("unchecked")
    Map<String, Object> systemSettings = (Map<String, Object>) request.getAttribute("systemSettings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings - ApartmentX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #333;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .admin-sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            padding: 30px 0;
            box-shadow: 2px 0 20px rgba(0, 0, 0, 0.1);
        }

        .admin-header {
            text-align: center;
            padding: 0 30px 30px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .admin-header h2 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            font-weight: 700;
            color: #e63946;
        }

        .admin-header p {
            color: #666;
            font-size: 0.9rem;
        }

        .admin-nav {
            padding: 0 20px;
        }

        .admin-nav ul {
            list-style: none;
        }

        .admin-nav li {
            margin-bottom: 8px;
        }

        .admin-nav a {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #555;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .admin-nav a:hover,
        .admin-nav a.active {
            background: rgba(230,57,70,0.1);
            color: #e63946;
            border-left-color: #e63946;
        }

        .admin-nav i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .logout-section {
            padding: 20px;
            margin-top: auto;
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(230, 57, 70, 0.3);
        }

        /* Main Content */
        .admin-main {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .page-header p {
            color: #666;
            font-size: 1.1rem;
        }

        /* Settings Sections */
        .settings-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
        }

        .settings-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .section-header h2 {
            color: #333;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .section-header p {
            color: #666;
            font-size: 0.9rem;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #e63946;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
        }

        .btn-primary {
            background: #e63946;
            color: white;
        }

        .btn-primary:hover {
            background: #d62828;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(230, 57, 70, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 53, 69, 0.3);
        }

        /* Profile Section */
        .profile-info {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .profile-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e63946 0%, #d62828 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 700;
            margin-right: 20px;
        }

        .profile-details h3 {
            color: #333;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .profile-details p {
            color: #666;
            font-size: 0.9rem;
        }

        /* System Settings */
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .setting-item:last-child {
            border-bottom: none;
        }

        .setting-info h4 {
            color: #333;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .setting-info p {
            color: #666;
            font-size: 0.9rem;
        }

        .setting-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .toggle-switch {
            position: relative;
            width: 50px;
            height: 25px;
            background: #ccc;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .toggle-switch.active {
            background: #e63946;
        }

        .toggle-switch::before {
            content: '';
            position: absolute;
            width: 21px;
            height: 21px;
            background: white;
            border-radius: 50%;
            top: 2px;
            left: 2px;
            transition: all 0.3s ease;
        }

        .toggle-switch.active::before {
            transform: translateX(25px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .admin-container {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                height: auto;
            }

            .admin-main {
                padding: 20px;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .settings-container {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .profile-info {
                flex-direction: column;
                text-align: center;
            }

            .profile-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
        }

        /* Loading and Messages */
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="admin-header">
                <h2>Admin Panel</h2>
                <p>Welcome back, <%= admin.getFirstName() %>!</p>
            </div>
            
            <nav class="admin-nav">
                <ul>
                    <li><a href="AdminDashboardServlet"><i class="fa-solid fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="AdminManagementServlet"><i class="fa-solid fa-user-shield"></i> Manage Admins</a></li>
                    <li><a href="AdminUserManagementServlet"><i class="fa-solid fa-users"></i> Manage Users</a></li>
                    <li><a href="AdminApartmentManagementServlet"><i class="fa-solid fa-building"></i> Manage Apartments</a></li>
                    <li><a href="AdminReviewManagementServlet"><i class="fa-solid fa-star"></i> Manage Reviews</a></li>
                    <li><a href="AdminReportsServlet"><i class="fa-solid fa-chart-bar"></i> Reports & Analytics</a></li>
                    <li><a href="AdminSettingsServlet" class="active"><i class="fa-solid fa-cog"></i> System Settings</a></li>
                </ul>
            </nav>
            
            <div class="logout-section">
                <button class="logout-btn" onclick="logout()">
                    <i class="fa-solid fa-sign-out-alt"></i> Logout
                </button>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <div class="page-header">
                <h1><i class="fa-solid fa-cog"></i> System Settings</h1>
                <p>Manage your profile and system configuration</p>
            </div>

            <div class="settings-container">
                <!-- Profile Settings -->
                <div class="settings-section">
                    <div class="section-header">
                        <h2><i class="fa-solid fa-user"></i> Profile Settings</h2>
                        <p>Update your personal information</p>
                    </div>

                    <div class="profile-info">
                        <div class="profile-avatar">
                            <%= currentAdmin.getFirstName().charAt(0) %><%= currentAdmin.getLastName().charAt(0) %>
                        </div>
                        <div class="profile-details">
                            <h3><%= currentAdmin.getFirstName() %> <%= currentAdmin.getLastName() %></h3>
                            <p><%= currentAdmin.getEmail() %></p>
                            <p>Admin ID: <%= currentAdmin.getAdminId() %></p>
                        </div>
                    </div>

                    <form id="profileForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <input type="text" id="firstName" name="firstName" value="<%= currentAdmin.getFirstName() %>" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text" id="lastName" name="lastName" value="<%= currentAdmin.getLastName() %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= currentAdmin.getEmail() %>" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<%= currentAdmin.getPhone() != null ? currentAdmin.getPhone() : "" %>">
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save"></i> Update Profile
                        </button>
                    </form>
                </div>

                <!-- Password Settings -->
                <div class="settings-section">
                    <div class="section-header">
                        <h2><i class="fa-solid fa-lock"></i> Password Settings</h2>
                        <p>Change your account password</p>
                    </div>

                    <form id="passwordForm">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" required minlength="6">
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-key"></i> Change Password
                        </button>
                    </form>
                </div>

                <!-- System Settings -->
                <div class="settings-section">
                    <div class="section-header">
                        <h2><i class="fa-solid fa-cogs"></i> System Configuration</h2>
                        <p>Configure system-wide settings</p>
                    </div>

                    <% if (systemSettings != null) { %>
                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Site Name</h4>
                                <p>Display name for the website</p>
                            </div>
                            <div class="setting-control">
                                <input type="text" value="<%= systemSettings.get("siteName") %>" style="width: 200px;">
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Site Description</h4>
                                <p>Brief description of the website</p>
                            </div>
                            <div class="setting-control">
                                <input type="text" value="<%= systemSettings.get("siteDescription") %>" style="width: 200px;">
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Max File Size</h4>
                                <p>Maximum file upload size</p>
                            </div>
                            <div class="setting-control">
                                <input type="text" value="<%= systemSettings.get("maxFileSize") %>" style="width: 200px;">
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Enable Registration</h4>
                                <p>Allow new user registrations</p>
                            </div>
                            <div class="setting-control">
                                <div class="toggle-switch <%= (Boolean) systemSettings.get("enableRegistration") ? "active" : "" %>" onclick="toggleSetting(this)"></div>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Maintenance Mode</h4>
                                <p>Put the site in maintenance mode</p>
                            </div>
                            <div class="setting-control">
                                <div class="toggle-switch <%= (Boolean) systemSettings.get("maintenanceMode") ? "active" : "" %>" onclick="toggleSetting(this)"></div>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Email Notifications</h4>
                                <p>Send email notifications</p>
                            </div>
                            <div class="setting-control">
                                <div class="toggle-switch <%= (Boolean) systemSettings.get("emailNotifications") ? "active" : "" %>" onclick="toggleSetting(this)"></div>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Auto Approve Reviews</h4>
                                <p>Automatically approve new reviews</p>
                            </div>
                            <div class="setting-control">
                                <div class="toggle-switch <%= (Boolean) systemSettings.get("autoApproveReviews") ? "active" : "" %>" onclick="toggleSetting(this)"></div>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Max Apartments Per Seller</h4>
                                <p>Maximum apartments a seller can list</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" value="<%= systemSettings.get("maxApartmentsPerSeller") %>" style="width: 200px;">
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h4>Max Images Per Apartment</h4>
                                <p>Maximum images per apartment listing</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" value="<%= systemSettings.get("maxImagesPerApartment") %>" style="width: 200px;">
                            </div>
                        </div>
                    <% } %>

                    <button type="button" class="btn btn-primary" onclick="saveSystemSettings()">
                        <i class="fa-solid fa-save"></i> Save System Settings
                    </button>
                </div>

                <!-- Security Settings -->
                <div class="settings-section">
                    <div class="section-header">
                        <h2><i class="fa-solid fa-shield-alt"></i> Security Settings</h2>
                        <p>Manage security and access controls</p>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Two-Factor Authentication</h4>
                            <p>Enable 2FA for enhanced security</p>
                        </div>
                        <div class="setting-control">
                            <div class="toggle-switch" onclick="toggleSetting(this)"></div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Session Timeout</h4>
                            <p>Auto-logout after inactivity</p>
                        </div>
                        <div class="setting-control">
                            <select style="width: 200px;">
                                <option value="30">30 minutes</option>
                                <option value="60" selected>1 hour</option>
                                <option value="120">2 hours</option>
                                <option value="480">8 hours</option>
                            </select>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <h4>Login Attempts</h4>
                            <p>Max failed login attempts before lockout</p>
                        </div>
                        <div class="setting-control">
                            <input type="number" value="5" min="3" max="10" style="width: 200px;">
                        </div>
                    </div>

                    <button type="button" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> Save Security Settings
                    </button>
                </div>
            </div>
        </main>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        function toggleSetting(element) {
            element.classList.toggle('active');
        }

        // Profile form submission
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new URLSearchParams();
            formData.append('action', 'updateProfile');
            formData.append('firstName', document.getElementById('firstName').value);
            formData.append('lastName', document.getElementById('lastName').value);
            formData.append('email', document.getElementById('email').value);
            formData.append('phone', document.getElementById('phone').value);

            fetch('AdminSettingsServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Profile updated successfully!');
                    location.reload();
                } else if (data.startsWith('error:')) {
                    alert('Failed to update profile. Error: ' + data.substring(6));
                } else {
                    alert('Failed to update profile. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile. Please try again.');
            });
        });

        // Password form submission
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                alert('New passwords do not match!');
                return;
            }
            
            const formData = new URLSearchParams();
            formData.append('action', 'changePassword');
            formData.append('currentPassword', document.getElementById('currentPassword').value);
            formData.append('newPassword', newPassword);
            formData.append('confirmPassword', confirmPassword);

            fetch('AdminSettingsServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Password changed successfully!');
                    document.getElementById('passwordForm').reset();
                } else if (data.startsWith('error:')) {
                    alert('Failed to change password. Error: ' + data.substring(6));
                } else {
                    alert('Failed to change password. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error changing password. Please try again.');
            });
        });

        function saveSystemSettings() {
            const formData = new URLSearchParams();
            formData.append('action', 'updateSystemSettings');
            formData.append('siteName', 'ApartmentX');
            formData.append('siteDescription', 'Professional Apartment Management System');
            formData.append('maxFileSize', '10MB');
            formData.append('enableRegistration', 'true');

            fetch('AdminSettingsServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('System settings saved successfully!');
                } else if (data.startsWith('error:')) {
                    alert('Failed to save settings. Error: ' + data.substring(6));
                } else {
                    alert('Failed to save settings. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error saving settings. Please try again.');
            });
        }
    </script>
</body>
</html>
