<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category - Smart Grocery Inventory</title>
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
                <a href="addSupplier.jsp">Add Supplier</a>
                <a href="addCategory.jsp" class="active">Add Category</a>
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
            <h1>&#128193; Add Category</h1>
            <p>Create a new product category to organize your grocery inventory effectively.</p>
        </div>

        <%-- Display success message --%>
        <%
            String success = request.getParameter("success");
            if ("true".equals(success)) {
        %>
        <div class="alert-success">
            <span class="icon">&#9989;</span>
            Category has been successfully submitted!
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

        <!-- Category Form -->
        <div class="card">
            <h2>Category Information</h2>
            <form action="CategoryServlet" method="POST" id="categoryForm" onsubmit="return validateCategoryForm()">

                <div class="form-row">
                    <div class="form-group">
                        <label for="categoryName">Category Name <span class="required">*</span></label>
                        <input type="text" id="categoryName" name="categoryName" class="form-control"
                               placeholder="e.g., Dairy Products" required>
                        <div class="error-text" id="categoryNameError">Please enter the category name.</div>
                    </div>
                    <div class="form-group">
                        <label for="aisleNumber">Aisle Number <span class="required">*</span></label>
                        <input type="number" id="aisleNumber" name="aisleNumber" class="form-control"
                               placeholder="e.g., 5" min="1" max="50" required>
                        <div class="error-text" id="aisleNumberError">Please enter a valid aisle number (1-50).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="storageType">Storage Type <span class="required">*</span></label>
                        <select id="storageType" name="storageType" class="form-control" required>
                            <option value="">-- Select Storage Type --</option>
                            <option value="Room Temperature">Room Temperature (Ambient)</option>
                            <option value="Refrigerated">Refrigerated (32-40&deg;F)</option>
                            <option value="Frozen">Frozen (0&deg;F or below)</option>
                            <option value="Cool and Dry">Cool &amp; Dry Storage</option>
                            <option value="Climate Controlled">Climate Controlled</option>
                        </select>
                        <div class="error-text" id="storageTypeError">Please select a storage type.</div>
                    </div>
                    <div class="form-group">
                        <label for="shelfLife">Typical Shelf Life <span class="required">*</span></label>
                        <select id="shelfLife" name="shelfLife" class="form-control" required>
                            <option value="">-- Select Shelf Life --</option>
                            <option value="1-3 Days">1-3 Days (Very Short)</option>
                            <option value="1 Week">Up to 1 Week</option>
                            <option value="2-4 Weeks">2-4 Weeks</option>
                            <option value="1-3 Months">1-3 Months</option>
                            <option value="3-6 Months">3-6 Months</option>
                            <option value="6-12 Months">6-12 Months</option>
                            <option value="Over 1 Year">Over 1 Year</option>
                        </select>
                        <div class="error-text" id="shelfLifeError">Please select a shelf life.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Category Description <span class="required">*</span></label>
                    <textarea id="description" name="description" class="form-control"
                              placeholder="Describe the types of products that belong to this category..." required></textarea>
                    <div class="error-text" id="descriptionError">Please enter a description for this category.</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="isPerishable">Perishable?</label>
                        <select id="isPerishable" name="isPerishable" class="form-control">
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="minStockLevel">Minimum Stock Level</label>
                        <input type="number" id="minStockLevel" name="minStockLevel" class="form-control"
                               placeholder="e.g., 20" min="0" value="10">
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Add Category</button>
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
        function validateCategoryForm() {
            let isValid = true;
            clearErrors();

            // Category Name
            const categoryName = document.getElementById('categoryName');
            if (categoryName.value.trim() === '') {
                showError('categoryName', 'categoryNameError');
                isValid = false;
            }

            // Aisle Number
            const aisleNumber = document.getElementById('aisleNumber');
            if (aisleNumber.value === '' || parseInt(aisleNumber.value) < 1 || parseInt(aisleNumber.value) > 50) {
                showError('aisleNumber', 'aisleNumberError');
                isValid = false;
            }

            // Storage Type
            const storageType = document.getElementById('storageType');
            if (storageType.value === '') {
                showError('storageType', 'storageTypeError');
                isValid = false;
            }

            // Shelf Life
            const shelfLife = document.getElementById('shelfLife');
            if (shelfLife.value === '') {
                showError('shelfLife', 'shelfLifeError');
                isValid = false;
            }

            // Description
            const description = document.getElementById('description');
            if (description.value.trim() === '') {
                showError('description', 'descriptionError');
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
