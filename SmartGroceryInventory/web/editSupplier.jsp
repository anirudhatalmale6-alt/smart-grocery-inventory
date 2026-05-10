<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Supplier - Smart Grocery Inventory</title>
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
                <a href="SupplierServlet?action=list" class="active">View Suppliers</a>
                <a href="CategoryServlet?action=list">View Categories</a>
                <a href="WebServiceServlet">Web Services</a>
                <a href="restServices.jsp">REST API</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#9998; Edit Supplier</h1>
            <p>Update the details of the selected supplier.</p>
        </div>

        <!-- Edit Form -->
        <div class="card">
            <h2>Edit Supplier Information</h2>
            <form action="SupplierServlet" method="POST" id="editSupplierForm" onsubmit="return validateSupplierForm()">

                <!-- Hidden fields -->
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="supplierId" value="${supplier.supplierId}">

                <div class="form-row">
                    <div class="form-group">
                        <label for="supplierName">Supplier Name <span class="required">*</span></label>
                        <input type="text" id="supplierName" name="supplierName" class="form-control"
                               value="${supplier.supplierName}" placeholder="e.g., Fresh Farm Distributors" required>
                        <div class="error-text" id="supplierNameError">Please enter the supplier name.</div>
                    </div>
                    <div class="form-group">
                        <label for="contactPerson">Contact Person <span class="required">*</span></label>
                        <input type="text" id="contactPerson" name="contactPerson" class="form-control"
                               value="${supplier.contactPerson}" placeholder="e.g., John Smith" required>
                        <div class="error-text" id="contactPersonError">Please enter the contact person name.</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" class="form-control"
                               value="${supplier.email}" placeholder="e.g., john@freshfarm.com" required>
                        <div class="error-text" id="emailError">Please enter a valid email address.</div>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="${supplier.phone}" placeholder="e.g., (555) 123-4567" required>
                        <div class="error-text" id="phoneError">Please enter a phone number.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Business Address <span class="required">*</span></label>
                    <input type="text" id="address" name="address" class="form-control"
                           value="${supplier.address}" placeholder="e.g., 123 Market Street, Suite 100, New York, NY 10001" required>
                    <div class="error-text" id="addressError">Please enter the business address.</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="productsSupplied">Products Supplied <span class="required">*</span></label>
                        <select id="productsSupplied" name="productsSupplied" class="form-control" required>
                            <option value="">-- Select Product Type --</option>
                            <option value="Dairy Products" ${supplier.productsSupplied == 'Dairy Products' ? 'selected' : ''}>Dairy Products</option>
                            <option value="Fresh Produce" ${supplier.productsSupplied == 'Fresh Produce' ? 'selected' : ''}>Fresh Produce (Fruits &amp; Vegetables)</option>
                            <option value="Bakery Items" ${supplier.productsSupplied == 'Bakery Items' ? 'selected' : ''}>Bakery Items</option>
                            <option value="Meat and Poultry" ${supplier.productsSupplied == 'Meat and Poultry' ? 'selected' : ''}>Meat &amp; Poultry</option>
                            <option value="Seafood" ${supplier.productsSupplied == 'Seafood' ? 'selected' : ''}>Seafood</option>
                            <option value="Beverages" ${supplier.productsSupplied == 'Beverages' ? 'selected' : ''}>Beverages</option>
                            <option value="Packaged Foods" ${supplier.productsSupplied == 'Packaged Foods' ? 'selected' : ''}>Packaged &amp; Canned Foods</option>
                            <option value="Frozen Foods" ${supplier.productsSupplied == 'Frozen Foods' ? 'selected' : ''}>Frozen Foods</option>
                            <option value="Condiments" ${supplier.productsSupplied == 'Condiments' ? 'selected' : ''}>Condiments &amp; Sauces</option>
                            <option value="Multiple Categories" ${supplier.productsSupplied == 'Multiple Categories' ? 'selected' : ''}>Multiple Categories</option>
                        </select>
                        <div class="error-text" id="productsSuppliedError">Please select the product type supplied.</div>
                    </div>
                    <div class="form-group">
                        <label for="deliverySchedule">Delivery Schedule</label>
                        <select id="deliverySchedule" name="deliverySchedule" class="form-control">
                            <option value="">-- Select Schedule --</option>
                            <option value="Daily" ${supplier.deliverySchedule == 'Daily' ? 'selected' : ''}>Daily</option>
                            <option value="Twice a Week" ${supplier.deliverySchedule == 'Twice a Week' ? 'selected' : ''}>Twice a Week</option>
                            <option value="Weekly" ${supplier.deliverySchedule == 'Weekly' ? 'selected' : ''}>Weekly</option>
                            <option value="Bi-Weekly" ${supplier.deliverySchedule == 'Bi-Weekly' ? 'selected' : ''}>Bi-Weekly</option>
                            <option value="Monthly" ${supplier.deliverySchedule == 'Monthly' ? 'selected' : ''}>Monthly</option>
                            <option value="On Demand" ${supplier.deliverySchedule == 'On Demand' ? 'selected' : ''}>On Demand</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="notes">Additional Notes</label>
                    <textarea id="notes" name="notes" class="form-control"
                              placeholder="Any special agreements, delivery instructions, or notes about this supplier...">${supplier.notes}</textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Update Supplier</button>
                    <a href="SupplierServlet?action=list" class="btn btn-secondary">Cancel</a>
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
