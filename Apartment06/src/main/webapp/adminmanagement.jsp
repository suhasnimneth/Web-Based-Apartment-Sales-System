<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Admin" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("admin");
    String userRole = (String) session.getAttribute("userRole");
    
    if (currentAdmin == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Management - ApartmentX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin-sidebar.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Poppins", sans-serif;
            background: #f8f8f8;
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
            background: #fff;
            box-shadow: 4px 0 15px rgba(0,0,0,0.05);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            border-right: 1px solid rgba(0,0,0,0.1);
        }
        
        .admin-header {
            padding: 30px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #fff, #fef2f2);
        }
        
        .admin-header h2 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            font-weight: 700;
            color: #e63946;
        }
        
        .admin-header p {
            color: #666;
            font-size: 0.95rem;
        }
        
        .admin-info {
            padding: 20px 25px;
            background: #f8f9fa;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .admin-info h3 {
            color: #333;
            font-size: 1.1rem;
            margin-bottom: 8px;
        }
        
        .admin-info p {
            color: #666;
            font-size: 0.9rem;
            margin: 3px 0;
        }
        
        .admin-info .admin-badge {
            display: inline-block;
            background: #e63946;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 10px;
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
            margin-left: 280px;
            padding: 30px;
        }
        
        .page-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        
        .page-header h1 {
            color: #333;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .page-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        /* Admin Management */
        .admin-management {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .management-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .management-header h3 {
            color: #333;
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .add-admin-btn {
            background: #e63946;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .add-admin-btn:hover {
            background: #d62828;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(230, 57, 70, 0.3);
        }
        
        /* Admin Table */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .admin-table th,
        .admin-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e1e5e9;
        }
        
        .admin-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .admin-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .btn-edit {
            background: #007bff;
            color: white;
        }
        
        .btn-edit:hover {
            background: #0056b3;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
        
        .btn-toggle {
            background: #ffc107;
            color: #212529;
        }
        
        .btn-toggle:hover {
            background: #e0a800;
        }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .modal-header h3 {
            color: #333;
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #e63946;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #e63946;
        }
        
        .modal-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .btn-primary {
            background: #e63946;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: #d62828;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .admin-main {
                margin-left: 0;
                padding: 20px;
            }
            
            .admin-table {
                font-size: 0.9rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Admin Sidebar -->
        <jsp:include page="includes/admin-sidebar.jsp">
            <jsp:param name="currentPage" value="admins"/>
        </jsp:include>
        
        <!-- Main Content -->
        <main class="admin-main">
            <div class="page-header">
                <h1><i class="fa-solid fa-user-shield"></i> Admin Management</h1>
                <p>Manage administrator accounts and permissions</p>
            </div>
            
            <div class="admin-management">
                <div class="management-header">
                    <h3><i class="fa-solid fa-users-cog"></i> Administrator Accounts</h3>
                    <button class="add-admin-btn" onclick="openAddModal()">
                        <i class="fa-solid fa-plus"></i> Add New Admin
                    </button>
                </div>
                
                <% if (admins != null && !admins.isEmpty()) { %>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Admin ID</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Last Login</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Admin admin : admins) { %>
                                <tr>
                                    <td><%= admin.getAdminId() %></td>
                                    <td><%= admin.getFullName() %></td>
                                    <td><%= admin.getUsername() %></td>
                                    <td><%= admin.getEmail() %></td>
                                    <td>
                                        <span class="status-badge <%= admin.isActive() ? "status-active" : "status-inactive" %>">
                                            <%= admin.isActive() ? "Active" : "Inactive" %>
                                        </span>
                                    </td>
                                    <td><%= admin.getCreatedAt().format(dateFormatter) %></td>
                                    <td>
                                        <%= admin.getLastLogin() != null ? admin.getLastLogin().format(dateFormatter) : "Never" %>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-edit" onclick="openEditModal('<%= admin.getAdminId() %>', '<%= admin.getUsername() %>', '<%= admin.getEmail() %>', '<%= admin.getFirstName() %>', '<%= admin.getLastName() %>', '<%= admin.getPhone() != null ? admin.getPhone() : "" %>')">
                                                <i class="fa-solid fa-edit"></i> Edit
                                            </button>
                                            <button class="btn btn-toggle" onclick="toggleAdmin('<%= admin.getAdminId() %>', <%= admin.isActive() %>)">
                                                <i class="fa-solid fa-toggle-<%= admin.isActive() ? "on" : "off" %>"></i>
                                                <%= admin.isActive() ? "Deactivate" : "Activate" %>
                                            </button>
                                            <% if (!admin.getAdminId().equals(currentAdmin.getAdminId())) { %>
                                                <button class="btn btn-delete" onclick="deleteAdmin('<%= admin.getAdminId() %>', '<%= admin.getFullName() %>')">
                                                    <i class="fa-solid fa-trash"></i> Delete
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa-solid fa-user-shield" style="font-size: 3rem; margin-bottom: 15px;"></i>
                        <h3>No Admins Found</h3>
                        <p>No administrator accounts found in the system.</p>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <!-- Add Admin Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-user-plus"></i> Add New Admin</h3>
                <span class="close" onclick="closeModal('addModal')">&times;</span>
            </div>
            <form id="addAdminForm">
                <div class="form-group">
                    <label for="addFirstName">First Name</label>
                    <input type="text" id="addFirstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="addLastName">Last Name</label>
                    <input type="text" id="addLastName" name="lastName" required>
                </div>
                <div class="form-group">
                    <label for="addUsername">Username</label>
                    <input type="text" id="addUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="addEmail">Email</label>
                    <input type="email" id="addEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="addPhone">Phone (Optional)</label>
                    <input type="tel" id="addPhone" name="phone">
                </div>
                <div class="form-group">
                    <label for="addPassword">Password</label>
                    <input type="password" id="addPassword" name="password" required minlength="6">
                </div>
                <div class="modal-buttons">
                    <button type="button" class="btn-secondary" onclick="closeModal('addModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Add Admin</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Edit Admin Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-edit"></i> Edit Admin</h3>
                <span class="close" onclick="closeModal('editModal')">&times;</span>
            </div>
            <form id="editAdminForm">
                <input type="hidden" id="editAdminId" name="adminId">
                <div class="form-group">
                    <label for="editFirstName">First Name</label>
                    <input type="text" id="editFirstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="editLastName">Last Name</label>
                    <input type="text" id="editLastName" name="lastName" required>
                </div>
                <div class="form-group">
                    <label for="editUsername">Username</label>
                    <input type="text" id="editUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="editEmail">Email</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editPhone">Phone (Optional)</label>
                    <input type="tel" id="editPhone" name="phone">
                </div>
                <div class="modal-buttons">
                    <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn-primary">Update Admin</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }
        
        function openAddModal() {
            document.getElementById('addModal').style.display = 'block';
            document.getElementById('addAdminForm').reset();
        }
        
        function openEditModal(adminId, username, email, firstName, lastName, phone) {
            document.getElementById('editModal').style.display = 'block';
            document.getElementById('editAdminId').value = adminId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editPhone').value = phone;
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        function toggleAdmin(adminId, isActive) {
            const action = isActive ? 'deactivate' : 'activate';
            if (confirm(`Are you sure you want to ${action} this admin?`)) {
                const formData = new URLSearchParams();
                formData.append('action', 'toggle');
                formData.append('adminId', adminId);
                
                fetch('AdminManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert(`Admin ${action}d successfully!`);
                        location.reload();
                    } else {
                        alert(`Failed to ${action} admin. Error: ${data}`);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error occurred. Please try again.');
                });
            }
        }
        
        function deleteAdmin(adminId, adminName) {
            if (confirm(`Are you sure you want to delete admin "${adminName}"? This action cannot be undone.`)) {
                const formData = new URLSearchParams();
                formData.append('action', 'delete');
                formData.append('adminId', adminId);
                
                fetch('AdminManagementServlet', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        alert('Admin deleted successfully!');
                        location.reload();
                    } else {
                        alert(`Failed to delete admin. Error: ${data}`);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error occurred. Please try again.');
                });
            }
        }
        
        // Add Admin Form
        document.getElementById('addAdminForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('firstName', document.getElementById('addFirstName').value);
            formData.append('lastName', document.getElementById('addLastName').value);
            formData.append('username', document.getElementById('addUsername').value);
            formData.append('email', document.getElementById('addEmail').value);
            formData.append('phone', document.getElementById('addPhone').value);
            formData.append('password', document.getElementById('addPassword').value);
            
            fetch('AdminManagementServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Admin added successfully!');
                    closeModal('addModal');
                    location.reload();
                } else {
                    alert(`Failed to add admin. Error: ${data}`);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error occurred. Please try again.');
            });
        });
        
        // Edit Admin Form
        document.getElementById('editAdminForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('adminId', document.getElementById('editAdminId').value);
            formData.append('firstName', document.getElementById('editFirstName').value);
            formData.append('lastName', document.getElementById('editLastName').value);
            formData.append('username', document.getElementById('editUsername').value);
            formData.append('email', document.getElementById('editEmail').value);
            formData.append('phone', document.getElementById('editPhone').value);
            
            fetch('AdminManagementServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Admin updated successfully!');
                    closeModal('editModal');
                    location.reload();
                } else {
                    alert(`Failed to update admin. Error: ${data}`);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error occurred. Please try again.');
            });
        });
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const addModal = document.getElementById('addModal');
            const editModal = document.getElementById('editModal');
            if (event.target === addModal) {
                addModal.style.display = 'none';
            }
            if (event.target === editModal) {
                editModal.style.display = 'none';
            }
        }
        
        console.log('Admin Management Page Loaded');
    </script>
</body>
</html>
