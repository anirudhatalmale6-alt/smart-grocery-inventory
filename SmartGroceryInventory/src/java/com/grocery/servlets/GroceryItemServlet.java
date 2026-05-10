package com.grocery.servlets;

import com.grocery.entity.GroceryItem;
import com.grocery.rules.GroceryItemRules;
import com.grocery.rules.ValidationResult;
import com.grocery.session.GroceryItemFacadeLocal;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to handle Grocery Item CRUD operations.
 * Flow: JSP Form -> Servlet -> Business Rules -> GroceryItemFacade -> Entity -> Database
 *
 * Business Rules Applied (from SmartGroceryRules shared library):
 * 1. Expiry Date Rule - no past dates, warn if expiring within 7 days
 * 2. Inventory Limits Rule - quantity/price ranges, total value cap
 * 3. Duplicate Prevention Rule - no same name+brand combo
 */
@WebServlet(name = "GroceryItemServlet", urlPatterns = {"/GroceryItemServlet"})
public class GroceryItemServlet extends HttpServlet {

    @EJB
    private GroceryItemFacadeLocal groceryItemFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createItem(request, response);
                break;
            case "update":
                updateItem(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            default:
                response.sendRedirect("addGroceryItem.jsp");
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
                listItems(request, response);
                break;
            case "edit":
                editItem(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            default:
                response.sendRedirect("addGroceryItem.jsp");
        }
    }

    private void createItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve form data from the JSP
            String itemName = request.getParameter("itemName");
            String brand = request.getParameter("brand");
            String category = request.getParameter("category");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            String expiryDateStr = request.getParameter("expiryDate");
            String supplier = request.getParameter("supplier");
            String description = request.getParameter("description");

            // Parse the expiry date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expiryDate = sdf.parse(expiryDateStr);

            // ========== APPLY BUSINESS RULES (from shared library) ==========
            ValidationResult result = GroceryItemRules.validateAll(
                    itemName, brand, category, quantity, price, expiryDate);

            // Business Rule 3: Check for duplicate item (same name + brand)
            List<GroceryItem> existingItems = groceryItemFacade.findAll();
            for (GroceryItem existing : existingItems) {
                ValidationResult dupCheck = GroceryItemRules.checkDuplicate(
                        itemName, brand, existing.getItemName(), existing.getBrand());
                result.merge(dupCheck);
            }

            // If business rules fail, redirect with error
            if (!result.isValid()) {
                System.out.println(">> BUSINESS RULE VIOLATION:");
                System.out.println(result.getErrorMessage());
                String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
                response.sendRedirect("addGroceryItem.jsp?ruleError=" + errorMsg);
                return;
            }

            // Log warnings if any
            if (result.hasWarnings()) {
                System.out.println(">> BUSINESS RULE WARNING:");
                System.out.println(result.getWarningMessage());
            }
            // ================================================================

            // Create entity object and populate using setters
            GroceryItem item = new GroceryItem();
            item.setItemName(itemName);
            item.setBrand(brand);
            item.setCategory(category);
            item.setQuantity(quantity);
            item.setPrice(price);
            item.setExpiryDate(expiryDate);
            item.setSupplier(supplier);
            item.setDescription(description);

            // Print to server console for troubleshooting
            System.out.println("==============================================");
            System.out.println("   SAVING GROCERY ITEM TO DATABASE");
            System.out.println("==============================================");
            System.out.println("Item Name     : " + itemName);
            System.out.println("Brand         : " + brand);
            System.out.println("Category      : " + category);
            System.out.println("Quantity      : " + quantity);
            System.out.println("Unit Price ($): " + price);
            System.out.println("Expiry Date   : " + expiryDateStr);
            System.out.println("Supplier      : " + (supplier != null && !supplier.isEmpty() ? supplier : "N/A"));
            System.out.println("Description   : " + (description != null && !description.isEmpty() ? description : "N/A"));

            // Call the facade create() method to insert into database
            groceryItemFacade.create(item);

            System.out.println(">> SUCCESS: Grocery item saved to database!");
            System.out.println("==============================================");

            // Pass warning to success page if any
            if (result.hasWarnings()) {
                String warnMsg = java.net.URLEncoder.encode(result.getWarningMessage(), "UTF-8");
                response.sendRedirect("addGroceryItem.jsp?success=true&warning=" + warnMsg);
            } else {
                response.sendRedirect("addGroceryItem.jsp?success=true");
            }

        } catch (ParseException e) {
            System.out.println(">> ERROR: Invalid date format - " + e.getMessage());
            response.sendRedirect("addGroceryItem.jsp?error=true");
        } catch (NumberFormatException e) {
            System.out.println(">> ERROR: Invalid number format - " + e.getMessage());
            response.sendRedirect("addGroceryItem.jsp?error=true");
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<GroceryItem> items = groceryItemFacade.findAll();
        System.out.println(">> Retrieving all grocery items. Count: " + items.size());
        request.setAttribute("groceryItems", items);
        request.getRequestDispatcher("viewGroceryItems.jsp").forward(request, response);
    }

    private void editItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        GroceryItem item = groceryItemFacade.find(id);
        request.setAttribute("item", item);
        request.getRequestDispatcher("editGroceryItem.jsp").forward(request, response);
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("itemId"));
            GroceryItem item = groceryItemFacade.find(id);

            String itemName = request.getParameter("itemName");
            String brand = request.getParameter("brand");
            String category = request.getParameter("category");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expiryDate = sdf.parse(request.getParameter("expiryDate"));

            // ========== APPLY BUSINESS RULES ON UPDATE ==========
            ValidationResult result = GroceryItemRules.validateAll(
                    itemName, brand, category, quantity, price, expiryDate);

            // Check duplicate (exclude current item)
            List<GroceryItem> existingItems = groceryItemFacade.findAll();
            for (GroceryItem existing : existingItems) {
                if (!existing.getItemId().equals(id)) {
                    ValidationResult dupCheck = GroceryItemRules.checkDuplicate(
                            itemName, brand, existing.getItemName(), existing.getBrand());
                    result.merge(dupCheck);
                }
            }

            if (!result.isValid()) {
                System.out.println(">> BUSINESS RULE VIOLATION on update:");
                System.out.println(result.getErrorMessage());
                String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
                response.sendRedirect("GroceryItemServlet?action=list&ruleError=" + errorMsg);
                return;
            }
            // =====================================================

            item.setItemName(itemName);
            item.setBrand(brand);
            item.setCategory(category);
            item.setQuantity(quantity);
            item.setPrice(price);
            item.setExpiryDate(expiryDate);
            item.setSupplier(request.getParameter("supplier"));
            item.setDescription(request.getParameter("description"));

            System.out.println(">> UPDATING Grocery Item ID: " + id + " - " + item.getItemName());
            groceryItemFacade.edit(item);
            System.out.println(">> SUCCESS: Grocery item updated in database!");

            response.sendRedirect("GroceryItemServlet?action=list&updated=true");

        } catch (ParseException e) {
            System.out.println(">> ERROR updating item: " + e.getMessage());
            response.sendRedirect("GroceryItemServlet?action=list&error=true");
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        GroceryItem item = groceryItemFacade.find(id);

        System.out.println(">> DELETING Grocery Item ID: " + id + " - " + item.getItemName());
        groceryItemFacade.remove(item);
        System.out.println(">> SUCCESS: Grocery item deleted from database!");

        response.sendRedirect("GroceryItemServlet?action=list&deleted=true");
    }
}
