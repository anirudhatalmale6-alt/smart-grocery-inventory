<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Categories - Smart Grocery Inventory</title>
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
        .badge-yes {
            background-color: #ffcdd2;
            color: #c62828;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-no {
            background-color: #c8e6c9;
            color: #2e7d32;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
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
                <a href="GroceryItemServlet?action=list">View Items</a>
                <a href="SupplierServlet?action=list">View Suppliers</a>
                <a href="CategoryServlet?action=list" class="active">View Categories</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#128193; Category Management</h1>
            <p>View, edit, and manage all product categories in the inventory system.</p>
        </div>

        <%-- Success/Status Messages --%>
        <c:if test="${param.success == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Category has been successfully added!
            </div>
        </c:if>
        <c:if test="${param.deleted == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Category has been successfully deleted!
            </div>
        </c:if>
        <c:if test="${param.updated == 'true'}">
            <div class="alert-success">
                <span class="icon">&#9989;</span>
                Category has been successfully updated!
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

        <!-- Categories Table -->
        <div class="card">
            <div class="table-header">
                <h2>All Categories</h2>
                <a href="addCategory.jsp" class="btn btn-primary">&#43; Add New Category</a>
            </div>

            <c:choose>
                <c:when test="${not empty categories}">
                    <p class="record-count">Showing <strong>${categories.size()}</strong> record(s)</p>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Aisle #</th>
                                <th>Storage Type</th>
                                <th>Shelf Life</th>
                                <th>Perishable</th>
                                <th>Min Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}">
                                <tr>
                                    <td>${category.categoryId}</td>
                                    <td><strong>${category.categoryName}</strong></td>
                                    <td>${category.aisleNumber}</td>
                                    <td>${category.storageType}</td>
                                    <td>${category.shelfLife}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${category.isPerishable == 'Yes'}">
                                                <span class="badge-yes">Yes</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-no">No</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${category.minStockLevel}</td>
                                    <td class="action-links">
                                        <a href="CategoryServlet?action=edit&id=${category.categoryId}" class="edit-link">&#9998; Edit</a>
                                        <a href="CategoryServlet?action=delete&id=${category.categoryId}" class="delete-link" onclick="return confirm('Are you sure you want to delete this category?')">&#128465; Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-records">
                        <span class="no-icon">&#128193;</span>
                        No categories found. Start by adding a new category!
                        <br><br>
                        <a href="addCategory.jsp" class="btn btn-primary">&#43; Add First Category</a>
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
