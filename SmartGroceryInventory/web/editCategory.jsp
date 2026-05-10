<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category - Smart Grocery Inventory</title>
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
                <a href="addGroceryItem.jsp">Grocery Items</a>
                <a href="addSupplier.jsp">Suppliers</a>
                <a href="addCategory.jsp">Categories</a>
                <a href="GroceryItemServlet?action=list">View Items</a>
                <a href="SupplierServlet?action=list">View Suppliers</a>
                <a href="CategoryServlet?action=list" class="active">View Categories</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#9998; Edit Category</h1>
            <p>Update the details of the selected product category.</p>
        </div>

        <!-- Edit Form -->
        <div class="card">
            <h2>Edit Category Information</h2>
            <form action="CategoryServlet" method="POST" id="editCategoryForm" onsubmit="return validateCategoryForm()">

                <!-- Hidden fields -->
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="categoryId" value="${category.categoryId}">

                <div class="form-row">
                    <div class="form-group">
                        <label for="categoryName">Category Name <span class="required">*</span></label>
                        <input type="text" id="categoryName" name="categoryName" class="form-control"
                               value="${category.categoryName}" placeholder="e.g., Dairy Products" required>
                        <div class="error-text" id="categoryNameError">Please enter the category name.</div>
                    </div>
                    <div class="form-group">
                        <label for="aisleNumber">Aisle Number <span class="required">*</span></label>
                        <input type="number" id="aisleNumber" name="aisleNumber" class="form-control"
                               value="${category.aisleNumber}" placeholder="e.g., 5" min="1" max="50" required>
                        <div class="error-text" id="aisleNumberError">Please enter a valid aisle number (1-50).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="storageType">Storage Type <span class="required">*</span></label>
                        <select id="storageType" name="storageType" class="form-control" required>
                            <option value="">-- Select Storage Type --</option>
                            <option value="Room Temperature" ${category.storageType == 'Room Temperature' ? 'selected' : ''}>Room Temperature (Ambient)</option>
                            <option value="Refrigerated" ${category.storageType == 'Refrigerated' ? 'selected' : ''}>Refrigerated (32-40&deg;F)</option>
                            <option value="Frozen" ${category.storageType == 'Frozen' ? 'selected' : ''}>Frozen (0&deg;F or below)</option>
                            <option value="Cool and Dry" ${category.storageType == 'Cool and Dry' ? 'selected' : ''}>Cool &amp; Dry Storage</option>
                            <option value="Climate Controlled" ${category.storageType == 'Climate Controlled' ? 'selected' : ''}>Climate Controlled</option>
                        </select>
                        <div class="error-text" id="storageTypeError">Please select a storage type.</div>
                    </div>
                    <div class="form-group">
                        <label for="shelfLife">Typical Shelf Life <span class="required">*</span></label>
                        <select id="shelfLife" name="shelfLife" class="form-control" required>
                            <option value="">-- Select Shelf Life --</option>
                            <option value="1-3 Days" ${category.shelfLife == '1-3 Days' ? 'selected' : ''}>1-3 Days (Very Short)</option>
                            <option value="1 Week" ${category.shelfLife == '1 Week' ? 'selected' : ''}>Up to 1 Week</option>
                            <option value="2-4 Weeks" ${category.shelfLife == '2-4 Weeks' ? 'selected' : ''}>2-4 Weeks</option>
                            <option value="1-3 Months" ${category.shelfLife == '1-3 Months' ? 'selected' : ''}>1-3 Months</option>
                            <option value="3-6 Months" ${category.shelfLife == '3-6 Months' ? 'selected' : ''}>3-6 Months</option>
                            <option value="6-12 Months" ${category.shelfLife == '6-12 Months' ? 'selected' : ''}>6-12 Months</option>
                            <option value="Over 1 Year" ${category.shelfLife == 'Over 1 Year' ? 'selected' : ''}>Over 1 Year</option>
                        </select>
                        <div class="error-text" id="shelfLifeError">Please select a shelf life.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Category Description <span class="required">*</span></label>
                    <textarea id="description" name="description" class="form-control"
                              placeholder="Describe the types of products that belong to this category..." required>${category.description}</textarea>
                    <div class="error-text" id="descriptionError">Please enter a description for this category.</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="isPerishable">Perishable?</label>
                        <select id="isPerishable" name="isPerishable" class="form-control">
                            <option value="Yes" ${category.isPerishable == 'Yes' ? 'selected' : ''}>Yes</option>
                            <option value="No" ${category.isPerishable == 'No' ? 'selected' : ''}>No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="minStockLevel">Minimum Stock Level</label>
                        <input type="number" id="minStockLevel" name="minStockLevel" class="form-control"
                               value="${category.minStockLevel}" placeholder="e.g., 20" min="0">
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Update Category</button>
                    <a href="CategoryServlet?action=list" class="btn btn-secondary">Cancel</a>
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
