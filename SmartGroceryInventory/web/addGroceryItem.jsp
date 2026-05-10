<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Grocery Item - Smart Grocery Inventory</title>
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
                <a href="addGroceryItem.jsp" class="active">Add Item</a>
                <a href="addSupplier.jsp">Add Supplier</a>
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
            <h1>&#127822; Add Grocery Item</h1>
            <p>Enter the details of the grocery product to add it to the inventory system.</p>
        </div>

        <%-- Display success message if redirected back after submission --%>
        <%
            String success = request.getParameter("success");
            if ("true".equals(success)) {
        %>
        <div class="alert-success">
            <span class="icon">&#9989;</span>
            Grocery item has been successfully submitted!
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

        <!-- Grocery Item Form -->
        <div class="card">
            <h2>Grocery Item Details</h2>
            <form action="GroceryItemServlet" method="POST" id="groceryForm" onsubmit="return validateGroceryForm()">

                <div class="form-row">
                    <div class="form-group">
                        <label for="itemName">Item Name <span class="required">*</span></label>
                        <input type="text" id="itemName" name="itemName" class="form-control"
                               placeholder="e.g., Organic Whole Milk" required>
                        <div class="error-text" id="itemNameError">Please enter the item name.</div>
                    </div>
                    <div class="form-group">
                        <label for="brand">Brand <span class="required">*</span></label>
                        <input type="text" id="brand" name="brand" class="form-control"
                               placeholder="e.g., Horizon Organic" required>
                        <div class="error-text" id="brandError">Please enter the brand name.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="category">Category <span class="required">*</span></label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="">-- Select Category --</option>
                            <option value="Dairy">Dairy</option>
                            <option value="Fruits">Fruits</option>
                            <option value="Vegetables">Vegetables</option>
                            <option value="Bakery">Bakery</option>
                            <option value="Meat">Meat &amp; Poultry</option>
                            <option value="Seafood">Seafood</option>
                            <option value="Beverages">Beverages</option>
                            <option value="Snacks">Snacks</option>
                            <option value="Frozen">Frozen Foods</option>
                            <option value="Canned">Canned Goods</option>
                            <option value="Condiments">Condiments &amp; Sauces</option>
                            <option value="Grains">Grains &amp; Cereals</option>
                        </select>
                        <div class="error-text" id="categoryError">Please select a category.</div>
                    </div>
                    <div class="form-group">
                        <label for="quantity">Quantity <span class="required">*</span></label>
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               placeholder="e.g., 50" min="0" required>
                        <div class="error-text" id="quantityError">Please enter a valid quantity (0 or more).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="price">Unit Price ($) <span class="required">*</span></label>
                        <input type="number" id="price" name="price" class="form-control"
                               placeholder="e.g., 4.99" min="0.01" step="0.01" required>
                        <div class="error-text" id="priceError">Please enter a valid price.</div>
                    </div>
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date <span class="required">*</span></label>
                        <input type="date" id="expiryDate" name="expiryDate" class="form-control" required>
                        <div class="error-text" id="expiryDateError">Please select an expiry date.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="supplier">Supplier</label>
                    <input type="text" id="supplier" name="supplier" class="form-control"
                           placeholder="e.g., Fresh Farm Distributors">
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control"
                              placeholder="Enter any additional details about this grocery item..."></textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Add Grocery Item</button>
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
        function validateGroceryForm() {
            let isValid = true;
            clearErrors();

            // Item Name
            const itemName = document.getElementById('itemName');
            if (itemName.value.trim() === '') {
                showError('itemName', 'itemNameError');
                isValid = false;
            }

            // Brand
            const brand = document.getElementById('brand');
            if (brand.value.trim() === '') {
                showError('brand', 'brandError');
                isValid = false;
            }

            // Category
            const category = document.getElementById('category');
            if (category.value === '') {
                showError('category', 'categoryError');
                isValid = false;
            }

            // Quantity
            const quantity = document.getElementById('quantity');
            if (quantity.value === '' || parseInt(quantity.value) < 0) {
                showError('quantity', 'quantityError');
                isValid = false;
            }

            // Price
            const price = document.getElementById('price');
            if (price.value === '' || parseFloat(price.value) <= 0) {
                showError('price', 'priceError');
                isValid = false;
            }

            // Expiry Date
            const expiryDate = document.getElementById('expiryDate');
            if (expiryDate.value === '') {
                showError('expiryDate', 'expiryDateError');
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
