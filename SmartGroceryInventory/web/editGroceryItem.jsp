<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Grocery Item - Smart Grocery Inventory</title>
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
                <a href="GroceryItemServlet?action=list" class="active">View Items</a>
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
            <h1>&#9998; Edit Grocery Item</h1>
            <p>Update the details of the selected grocery item.</p>
        </div>

        <!-- Edit Form -->
        <div class="card">
            <h2>Edit Item Details</h2>
            <form action="GroceryItemServlet" method="POST" id="editGroceryForm" onsubmit="return validateGroceryForm()">

                <!-- Hidden fields -->
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="itemId" value="${item.itemId}">

                <div class="form-row">
                    <div class="form-group">
                        <label for="itemName">Item Name <span class="required">*</span></label>
                        <input type="text" id="itemName" name="itemName" class="form-control"
                               value="${item.itemName}" placeholder="e.g., Organic Whole Milk" required>
                        <div class="error-text" id="itemNameError">Please enter the item name.</div>
                    </div>
                    <div class="form-group">
                        <label for="brand">Brand <span class="required">*</span></label>
                        <input type="text" id="brand" name="brand" class="form-control"
                               value="${item.brand}" placeholder="e.g., Horizon Organic" required>
                        <div class="error-text" id="brandError">Please enter the brand name.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="category">Category <span class="required">*</span></label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="">-- Select Category --</option>
                            <option value="Dairy" ${item.category == 'Dairy' ? 'selected' : ''}>Dairy</option>
                            <option value="Fruits" ${item.category == 'Fruits' ? 'selected' : ''}>Fruits</option>
                            <option value="Vegetables" ${item.category == 'Vegetables' ? 'selected' : ''}>Vegetables</option>
                            <option value="Bakery" ${item.category == 'Bakery' ? 'selected' : ''}>Bakery</option>
                            <option value="Meat" ${item.category == 'Meat' ? 'selected' : ''}>Meat &amp; Poultry</option>
                            <option value="Seafood" ${item.category == 'Seafood' ? 'selected' : ''}>Seafood</option>
                            <option value="Beverages" ${item.category == 'Beverages' ? 'selected' : ''}>Beverages</option>
                            <option value="Snacks" ${item.category == 'Snacks' ? 'selected' : ''}>Snacks</option>
                            <option value="Frozen" ${item.category == 'Frozen' ? 'selected' : ''}>Frozen Foods</option>
                            <option value="Canned" ${item.category == 'Canned' ? 'selected' : ''}>Canned Goods</option>
                            <option value="Condiments" ${item.category == 'Condiments' ? 'selected' : ''}>Condiments &amp; Sauces</option>
                            <option value="Grains" ${item.category == 'Grains' ? 'selected' : ''}>Grains &amp; Cereals</option>
                        </select>
                        <div class="error-text" id="categoryError">Please select a category.</div>
                    </div>
                    <div class="form-group">
                        <label for="quantity">Quantity <span class="required">*</span></label>
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               value="${item.quantity}" placeholder="e.g., 50" min="0" required>
                        <div class="error-text" id="quantityError">Please enter a valid quantity (0 or more).</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="price">Unit Price ($) <span class="required">*</span></label>
                        <input type="number" id="price" name="price" class="form-control"
                               value="${item.price}" placeholder="e.g., 4.99" min="0.01" step="0.01" required>
                        <div class="error-text" id="priceError">Please enter a valid price.</div>
                    </div>
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date <span class="required">*</span></label>
                        <input type="date" id="expiryDate" name="expiryDate" class="form-control"
                               value="<fmt:formatDate value='${item.expiryDate}' pattern='yyyy-MM-dd'/>" required>
                        <div class="error-text" id="expiryDateError">Please select an expiry date.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="supplier">Supplier</label>
                    <input type="text" id="supplier" name="supplier" class="form-control"
                           value="${item.supplier}" placeholder="e.g., Fresh Farm Distributors">
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control"
                              placeholder="Enter any additional details about this grocery item...">${item.description}</textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Update Grocery Item</button>
                    <a href="GroceryItemServlet?action=list" class="btn btn-secondary">Cancel</a>
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
