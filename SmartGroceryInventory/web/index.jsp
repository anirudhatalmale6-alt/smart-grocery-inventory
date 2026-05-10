<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Grocery Inventory Management System</title>
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
                <a href="index.jsp" class="active">Home</a>
                <a href="addGroceryItem.jsp">Add Item</a>
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

        <!-- Hero Section -->
        <div class="hero">
            <span class="hero-icon">&#128722;</span>
            <h1>Smart Grocery Inventory Management</h1>
            <p>Efficiently manage your grocery inventory, suppliers, and product categories all in one place.</p>
        </div>

        <!-- Dashboard Cards - Add New -->
        <div class="card">
            <h2>Add New Records</h2>
        </div>
        <div class="dashboard-grid">
            <a href="addGroceryItem.jsp" class="dashboard-card grocery">
                <div class="card-icon">&#127822;</div>
                <h3>Add Grocery Item</h3>
                <p>Add new grocery products with name, category, quantity, price, and expiry date.</p>
            </a>

            <a href="addSupplier.jsp" class="dashboard-card supplier">
                <div class="card-icon">&#128666;</div>
                <h3>Add Supplier</h3>
                <p>Register a new supplier with contact details and product information.</p>
            </a>

            <a href="addCategory.jsp" class="dashboard-card category">
                <div class="card-icon">&#128193;</div>
                <h3>Add Category</h3>
                <p>Create a new product category with aisle location and storage details.</p>
            </a>
        </div>

        <!-- Dashboard Cards - View Records -->
        <div class="card">
            <h2>View &amp; Manage Records</h2>
        </div>
        <div class="dashboard-grid">
            <a href="GroceryItemServlet?action=list" class="dashboard-card grocery">
                <div class="card-icon">&#128203;</div>
                <h3>View Grocery Items</h3>
                <p>Browse, search, edit, and delete grocery items from the database.</p>
            </a>

            <a href="SupplierServlet?action=list" class="dashboard-card supplier">
                <div class="card-icon">&#128209;</div>
                <h3>View Suppliers</h3>
                <p>View all suppliers, update contact information, or remove records.</p>
            </a>

            <a href="CategoryServlet?action=list" class="dashboard-card category">
                <div class="card-icon">&#128196;</div>
                <h3>View Categories</h3>
                <p>Browse all categories, edit details, or remove unused categories.</p>
            </a>
        </div>

        <!-- Web Services Section -->
        <div class="card">
            <h2>External Web Services</h2>
        </div>
        <div class="dashboard-grid">
            <a href="WebServiceServlet" class="dashboard-card grocery" style="border-left: 4px solid #0077b6;">
                <div class="card-icon">&#127760;</div>
                <h3>Web Services</h3>
                <p>Look up food product nutrition data and check weather forecasts for delivery planning.</p>
            </a>

            <a href="restServices.jsp" class="dashboard-card supplier" style="border-left: 4px solid #2d6a4f;">
                <div class="card-icon">&#128268;</div>
                <h3>REST API</h3>
                <p>Access grocery data through RESTful web service endpoints. Test and explore the API.</p>
            </a>
        </div>

        <!-- Features Section -->
        <div class="card">
            <h2>System Features</h2>
            <div class="features">
                <div class="feature-item">
                    <span class="feat-icon">&#10133;</span>
                    <div>
                        <h4>Add Grocery Items</h4>
                        <p>Easily add new products with details like name, category, quantity, price, and expiry date.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <span class="feat-icon">&#128230;</span>
                    <div>
                        <h4>Track Inventory</h4>
                        <p>Monitor stock levels and keep your inventory data up to date at all times.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <span class="feat-icon">&#128100;</span>
                    <div>
                        <h4>Manage Suppliers</h4>
                        <p>Store and organize supplier contact details and the products they supply.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <span class="feat-icon">&#128197;</span>
                    <div>
                        <h4>Expiry Tracking</h4>
                        <p>Keep track of product expiry dates to reduce waste and ensure freshness.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 Smart Grocery Inventory Management System | Enterprise-Wide Computing Project
    </div>

</body>
</html>
