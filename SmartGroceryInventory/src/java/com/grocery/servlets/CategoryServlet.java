package com.grocery.servlets;

import com.grocery.entity.Category;
import com.grocery.rules.CategoryRules;
import com.grocery.rules.ValidationResult;
import com.grocery.session.CategoryFacadeLocal;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to handle Category CRUD operations.
 * Flow: JSP Form -> Servlet -> Business Rules -> CategoryFacade -> Entity -> Database
 *
 * Business Rules Applied (from SmartGroceryRules shared library):
 * 5. Category Storage Consistency - perishable storage rules, aisle range, stock constraints
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/CategoryServlet"})
public class CategoryServlet extends HttpServlet {

    @EJB
    private CategoryFacadeLocal categoryFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect("addCategory.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listCategories(request, response);
                break;
            case "edit":
                editCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect("addCategory.jsp");
        }
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryName = request.getParameter("categoryName");
        int aisleNumber = Integer.parseInt(request.getParameter("aisleNumber"));
        String storageType = request.getParameter("storageType");
        String shelfLife = request.getParameter("shelfLife");
        String description = request.getParameter("description");
        String isPerishable = request.getParameter("isPerishable");
        String minStockStr = request.getParameter("minStockLevel");
        int minStockLevel = (minStockStr != null && !minStockStr.isEmpty()) ? Integer.parseInt(minStockStr) : 10;

        // ========== APPLY BUSINESS RULES (from shared library) ==========
        ValidationResult result = CategoryRules.validateAll(
                categoryName, aisleNumber, storageType, isPerishable, minStockLevel);

        if (!result.isValid()) {
            System.out.println(">> BUSINESS RULE VIOLATION:");
            System.out.println(result.getErrorMessage());
            String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
            response.sendRedirect("addCategory.jsp?ruleError=" + errorMsg);
            return;
        }

        if (result.hasWarnings()) {
            System.out.println(">> BUSINESS RULE WARNING:");
            System.out.println(result.getWarningMessage());
        }
        // ================================================================

        // Create entity and populate using setters
        Category category = new Category();
        category.setCategoryName(categoryName);
        category.setAisleNumber(aisleNumber);
        category.setStorageType(storageType);
        category.setShelfLife(shelfLife);
        category.setDescription(description);
        category.setIsPerishable(isPerishable);
        category.setMinStockLevel(minStockLevel);

        // Print to server console for troubleshooting
        System.out.println("==============================================");
        System.out.println("   SAVING CATEGORY TO DATABASE");
        System.out.println("==============================================");
        System.out.println("Category Name   : " + categoryName);
        System.out.println("Aisle Number    : " + aisleNumber);
        System.out.println("Storage Type    : " + storageType);
        System.out.println("Shelf Life      : " + shelfLife);
        System.out.println("Description     : " + description);

        // Call the facade create() method to insert into database
        categoryFacade.create(category);

        System.out.println(">> SUCCESS: Category saved to database!");
        System.out.println("==============================================");

        if (result.hasWarnings()) {
            String warnMsg = java.net.URLEncoder.encode(result.getWarningMessage(), "UTF-8");
            response.sendRedirect("addCategory.jsp?success=true&warning=" + warnMsg);
        } else {
            response.sendRedirect("addCategory.jsp?success=true");
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryFacade.findAll();
        System.out.println(">> Retrieving all categories. Count: " + categories.size());
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("viewCategories.jsp").forward(request, response);
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Category category = categoryFacade.find(id);
        request.setAttribute("category", category);
        request.getRequestDispatcher("editCategory.jsp").forward(request, response);
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("categoryId"));
        Category category = categoryFacade.find(id);

        String categoryName = request.getParameter("categoryName");
        int aisleNumber = Integer.parseInt(request.getParameter("aisleNumber"));
        String storageType = request.getParameter("storageType");
        String isPerishable = request.getParameter("isPerishable");
        String minStockStr = request.getParameter("minStockLevel");
        int minStockLevel = (minStockStr != null && !minStockStr.isEmpty()) ? Integer.parseInt(minStockStr) : 10;

        // ========== APPLY BUSINESS RULES ON UPDATE ==========
        ValidationResult result = CategoryRules.validateAll(
                categoryName, aisleNumber, storageType, isPerishable, minStockLevel);

        if (!result.isValid()) {
            System.out.println(">> BUSINESS RULE VIOLATION on update:");
            System.out.println(result.getErrorMessage());
            String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
            response.sendRedirect("CategoryServlet?action=list&ruleError=" + errorMsg);
            return;
        }
        // =====================================================

        category.setCategoryName(categoryName);
        category.setAisleNumber(aisleNumber);
        category.setStorageType(storageType);
        category.setShelfLife(request.getParameter("shelfLife"));
        category.setDescription(request.getParameter("description"));
        category.setIsPerishable(isPerishable);
        category.setMinStockLevel(minStockLevel);

        System.out.println(">> UPDATING Category ID: " + id + " - " + category.getCategoryName());
        categoryFacade.edit(category);
        System.out.println(">> SUCCESS: Category updated in database!");

        response.sendRedirect("CategoryServlet?action=list&updated=true");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Category category = categoryFacade.find(id);

        System.out.println(">> DELETING Category ID: " + id + " - " + category.getCategoryName());
        categoryFacade.remove(category);
        System.out.println(">> SUCCESS: Category deleted from database!");

        response.sendRedirect("CategoryServlet?action=list&deleted=true");
    }
}
