<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Grocery Items - Smart Grocery Inventory</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Table Styles */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 14px;
        }
        .data-table thead th {
            background: linear-gradient(135deg, #2d6a4f, #40916c);
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
        }
        .data-table thead th:first-child {
            border-radius: 8px 0 0 0;
        }
        .data-table thead th:last-child {
            border-radius: 0 8px 0 0;
        }
        .data-table tbody td {
            padding: 11px 15px;
            border-bottom: 1px solid #e8f5e9;
            color: #333;
        }
        .data-table tbody tr:nth-child(even) {
            background-color: #f1f8e9;
        }
        .data-table tbody tr:nth-child(odd) {
            background-color: #ffffff;
        }
        .data-table tbody tr:hover {
            background-color: #dcedc8;
            transition: background-color 0.2s ease;
        }
        .data-table tbody tr:last-child td:first-child {
            border-radius: 0 0 0 8px;
        }
        .data-table tbody tr:last-child td:last-child {
            border-radius: 0 0 8px 0;
        }
        .action-links a {
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 600;
            margin-right: 5px;
            display: inline-block;
            transition: all 0.2s ease;
        }
        .action-links .edit-link {
            background-color: #e3f2fd;
            color: #1565c0;
            border: 1px solid #bbdefb;
        }
        .action-links .edit-link:hover {
            background-color: #1565c0;
            color: white;
        }
        .action-links .delete-link {
            background-color: #fce4ec;
            color: #c62828;
            border: 1px solid #f8bbd0;
        }
        .action-links .delete-link:hover {
            background-color: #c62828;
            color: white;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        .record-count {
            color: #666;
            font-size: 14px;
        }
        .record-count strong {
            color: #2d6a4f;
        }
        .no-records {
            text-align: center;
            padding: 40px 20px;
            color: #888;
            font-size: 16px;
        }
        .no-records .no-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 10px;
        }
        .price-cell {
            font-weight: 600;
            color: #2d6a4f;
        }
    </style>
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
            <h1>&#128230; Grocery Items Inventory</h1>
            <p>View, edit, and manage all grocery items in your inventory system.</p>
        </div>

        <%-- Success/Status Messages --%>
        <c:if test="${param.success == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Grocery item has been successfully added!
            </div>
        </c:if>
        <c:if test="${param.deleted == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Grocery item has been successfully deleted!
            </div>
        </c:if>
        <c:if test="${param.updated == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Grocery item has been successfully updated!
            </div>
        </c:if>

        <%-- Display business rule errors --%>
        <%
            String ruleError = request.getParameter("ruleError");
            if (ruleError != null && !ruleError.isEmpty()) {
                String decodedError = java.net.URLDecoder.decode(ruleError, "UTF-8");
        %>
        <div style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            <span class="icon">&#9888;</span>
            <strong>Business Rule Violation:</strong><br>
            <pre style="white-space: pre-wrap; font-family: inherit; margin: 5px 0 0 0;"><%= decodedError %></pre>
        </div>
        <% } %>

        <!-- Items Table -->
        <div class="card">
            <div class="table-header">
                <h2>All Grocery Items</h2>
                <a href="addGroceryItem.jsp" class="btn btn-primary">&#43; Add New Item</a>
            </div>

            <c:choose>
                <c:when test="${not empty groceryItems}">
                    <p class="record-count">Showing <strong>${groceryItems.size()}</strong> record(s)</p>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Item Name</th>
                                <th>Brand</th>
                                <th>Category</th>
                                <th>Qty</th>
                                <th>Price</th>
                                <th>Expiry Date</th>
                                <th>Supplier</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${groceryItems}">
                                <tr>
                                    <td>${item.itemId}</td>
                                    <td><strong>${item.itemName}</strong></td>
                                    <td>${item.brand}</td>
                                    <td>${item.category}</td>
                                    <td>${item.quantity}</td>
                                    <td class="price-cell"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>${item.expiryDate}</td>
                                    <td>${item.supplier}</td>
                                    <td class="action-links">
                                        <a href="GroceryItemServlet?action=edit&id=${item.itemId}" class="edit-link">&#9998; Edit</a>
                                        <a href="GroceryItemServlet?action=delete&id=${item.itemId}" class="delete-link" onclick="return confirm('Are you sure you want to delete this item?')">&#128465; Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-records">
                        <span class="no-icon">&#128230;</span>
                        No grocery items found. Start by adding a new item!
                        <br><br>
                        <a href="addGroceryItem.jsp" class="btn btn-primary">&#43; Add First Item</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 Smart Grocery Inventory Management System | Enterprise-Wide Computing Project
    </div>

</body>
</html>
