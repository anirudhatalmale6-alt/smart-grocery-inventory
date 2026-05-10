<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Supplier - Smart Grocery Inventory</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-inner">
            <a href="index.jsp" class="brand">
                <span class="icon">&#127819;</span>
                Smart Grocery Inventory
            </a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="addGroceryItem.jsp">Add Item</a>
                <a href="addSupplier.jsp" class="active">Add Supplier</a>
                <a href="addCategory.jsp">Add Category</a>
                <a href="GroceryItemServlet?action=list">View Items</a>
                <a href="SupplierServlet?action=list">View Suppliers</a>
                <a href="CategoryServlet?action=list">View Categories</a>
                <a href="WebServiceServlet">Web Services</a>
                <a href="restServices.jsp">REST API</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#128666; Add Supplier</h1>
            <p>Register a new supplier to track your grocery product sources and contacts.</p>
        </div>

        <%-- Display success message --%>
        <%
            String success = request.getParameter("success");
            if ("true".equals(success)) {
        %>
        <div class="alert-success">
            <span class="icon">&#9989;</span>
            Supplier has been successfully submitted!
        </div>
        <% } %>

        <%-- Display business rule errors --%>
        <%
            String ruleError = request.getParameter("ruleError");
            if (ruleError != null && !ruleError.isEmpty()) {
                String decodedError = java.net.URLDecoder.decode(ruleError, "UTF-8");
        %>
        <div class="alert-error" style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <span class="icon">&#9888;</span>
            <strong>Business Rule Violation:</strong><br>
            <pre style="white-space: pre-wrap; font-family: inherit; margin: 5px 0 0 0;"><%= decodedError %></pre>
        </div>
        <% } %>

        <%-- Display business rule warnings --%>
        <%
            String warning = request.getParameter("warning");
            if (warning != null && !warning.isEmpty()) {
                String decodedWarning = java.net.URLDecoder.decode(warning, "UTF-8");
        %>
        <div class="alert-warning" style="background-color: #fff3cd; color: #856404; border: 1px solid #ffeaa8; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <span class="icon">&#9888;</span>
            <strong>Warning:</strong><br>
            <pre style="white-space: pre-wrap; font-family: inherit; margin: 5px 0 0 0;"><%= decodedWarning %></pre>
        </div>
        <% } %>

        <!-- Supplier Form -->
        <div class="card">
            <h2>Supplier Information</h2>
            <form action="SupplierServlet" method="POST" id="supplierForm" onsubmit="return validateSupplierForm()">

                <div class="form-row">
                    <div class="form-group">
                        <label for="supplierName">Supplier Name <span class="required">*</span></label>
                        <input type="text" id="supplierName" name="supplierName" class="form-control"
                               placeholder="e.g., Fresh Farm Distributors" required>
                        <div class="error-text" id="supplierNameError">Please enter the supplier name.</div>
                    </div>
                    <div class="form-group">
                        <label for="contactPerson">Contact Person <span class="required">*</span></label>
                        <input type="text" id="contactPerson" name="contactPerson" class="form-control"
                               placeholder="e.g., John Smith" required>
                        <div class="error-text" id="contactPersonError">Please enter the contact person name.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="e.g., john@freshfarm.com" required>
                        <div class="error-text" id="emailError">Please enter a valid email address.</div>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               placeholder="e.g., (555) 123-4567" required>
                        <div class="error-text" id="phoneError">Please enter a phone number.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Business Address <span class="required">*</span></label>
                    <input type="text" id="address" name="address" class="form-control"
                           placeholder="e.g., 123 Market Street, Suite 100, New York, NY 10001" required>
                    <div class="error-text" id="addressError">Please enter the business address.</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="productsSupplied">Products Supplied <span class="required">*</span></label>
                        <select id="productsSupplied" name="productsSupplied" class="form-control" required>
                            <option value="">-- Select Product Type --</option>
                            <option value="Dairy Products">Dairy Products</option>
                            <option value="Fresh Produce">Fresh Produce (Fruits &amp; Vegetables)</option>
                            <option value="Bakery Items">Bakery Items</option>
                            <option value="Meat and Poultry">Meat &amp; Poultry</option>
                            <option value="Seafood">Seafood</option>
                            <option value="Beverages">Beverages</option>
                            <option value="Packaged Foods">Packaged &amp; Canned Foods</option>
                            <option value="Frozen Foods">Frozen Foods</option>
                            <option value="Condiments">Condiments &amp; Sauces</option>
                            <option value="Multiple Categories">Multiple Categories</option>
                        </select>
                        <div class="error-text" id="productsSuppliedError">Please select the product type supplied.</div>
                    </div>
                    <div class="form-group">
                        <label for="deliverySchedule">Delivery Schedule</label>
                        <select id="deliverySchedule" name="deliverySchedule" class="form-control">
                            <option value="">-- Select Schedule --</option>
                            <option value="Daily">Daily</option>
                            <option value="Twice a Week">Twice a Week</option>
                            <option value="Weekly">Weekly</option>
                            <option value="Bi-Weekly">Bi-Weekly</option>
                            <option value="Monthly">Monthly</option>
                            <option value="On Demand">On Demand</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="notes">Additional Notes</label>
                    <textarea id="notes" name="notes" class="form-control"
                              placeholder="Any special agreements, delivery instructions, or notes about this supplier..."></textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Add Supplier</button>
                    <button type="reset" class="btn btn-secondary" onclick="clearErrors()">Clear Form</button>
                </div>
            </form>
        </div>

    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 Smart Grocery Inventory Management System | Enterprise-Wide Computing Project
    </div>

    <script>
        function validateSupplierForm() {
            let isValid = true;
            clearErrors();

            // Supplier Name
            const supplierName = document.getElementById('supplierName');
            if (supplierName.value.trim() === '') {
                showError('supplierName', 'supplierNameError');
                isValid = false;
            }

            // Contact Person
            const contactPerson = document.getElementById('contactPerson');
            if (contactPerson.value.trim() === '') {
                showError('contactPerson', 'contactPersonError');
                isValid = false;
            }

            // Email
            const email = document.getElementById('email');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email.value)) {
                showError('email', 'emailError');
                isValid = false;
            }

            // Phone
            const phone = document.getElementById('phone');
            if (phone.value.trim() === '') {
                showError('phone', 'phoneError');
                isValid = false;
            }

            // Address
            const address = document.getElementById('address');
            if (address.value.trim() === '') {
                showError('address', 'addressError');
                isValid = false;
            }

            // Products Supplied
            const productsSupplied = document.getElementById('productsSupplied');
            if (productsSupplied.value === '') {
                showError('productsSupplied', 'productsSuppliedError');
                isValid = false;
            }

            return isValid;
        }

        function showError(fieldId, errorId) {
            document.getElementById(fieldId).classList.add('error');
            document.getElementById(errorId).style.display = 'block';
        }

        function clearErrors() {
            const fields = document.querySelectorAll('.form-control');
            fields.forEach(f => f.classList.remove('error'));
            const errors = document.querySelectorAll('.error-text');
            errors.forEach(e => e.style.display = 'none');
        }
    </script>

</body>
</html>
