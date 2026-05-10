package com.grocery.servlets;

import com.grocery.entity.Supplier;
import com.grocery.rules.SupplierRules;
import com.grocery.rules.ValidationResult;
import com.grocery.session.SupplierFacadeLocal;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to handle Supplier CRUD operations.
 * Flow: JSP Form -> Servlet -> Business Rules -> SupplierFacade -> Entity -> Database
 *
 * Business Rules Applied (from SmartGroceryRules shared library):
 * 4. Supplier Contact Validation - email format, phone length, name validation
 */
@WebServlet(name = "SupplierServlet", urlPatterns = {"/SupplierServlet"})
public class SupplierServlet extends HttpServlet {

    @EJB
    private SupplierFacadeLocal supplierFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createSupplier(request, response);
                break;
            case "update":
                updateSupplier(request, response);
                break;
            case "delete":
                deleteSupplier(request, response);
                break;
            default:
                response.sendRedirect("addSupplier.jsp");
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
                listSuppliers(request, response);
                break;
            case "edit":
                editSupplier(request, response);
                break;
            case "delete":
                deleteSupplier(request, response);
                break;
            default:
                response.sendRedirect("addSupplier.jsp");
        }
    }

    private void createSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String supplierName = request.getParameter("supplierName");
        String contactPerson = request.getParameter("contactPerson");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String productsSupplied = request.getParameter("productsSupplied");
        String deliverySchedule = request.getParameter("deliverySchedule");
        String notes = request.getParameter("notes");

        // ========== APPLY BUSINESS RULES (from shared library) ==========
        ValidationResult result = SupplierRules.validateAll(
                supplierName, contactPerson, email, phone, address);

        if (!result.isValid()) {
            System.out.println(">> BUSINESS RULE VIOLATION:");
            System.out.println(result.getErrorMessage());
            String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
            response.sendRedirect("addSupplier.jsp?ruleError=" + errorMsg);
            return;
        }

        if (result.hasWarnings()) {
            System.out.println(">> BUSINESS RULE WARNING:");
            System.out.println(result.getWarningMessage());
        }
        // ================================================================

        // Create entity and populate using setters
        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName);
        supplier.setContactPerson(contactPerson);
        supplier.setEmail(email);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setProductsSupplied(productsSupplied);
        supplier.setDeliverySchedule(deliverySchedule);
        supplier.setNotes(notes);

        // Print to server console for troubleshooting
        System.out.println("==============================================");
        System.out.println("   SAVING SUPPLIER TO DATABASE");
        System.out.println("==============================================");
        System.out.println("Supplier Name    : " + supplierName);
        System.out.println("Contact Person   : " + contactPerson);
        System.out.println("Email            : " + email);
        System.out.println("Phone            : " + phone);
        System.out.println("Address          : " + address);
        System.out.println("Products Supplied: " + productsSupplied);

        // Call the facade create() method to insert into database
        supplierFacade.create(supplier);

        System.out.println(">> SUCCESS: Supplier saved to database!");
        System.out.println("==============================================");

        if (result.hasWarnings()) {
            String warnMsg = java.net.URLEncoder.encode(result.getWarningMessage(), "UTF-8");
            response.sendRedirect("addSupplier.jsp?success=true&warning=" + warnMsg);
        } else {
            response.sendRedirect("addSupplier.jsp?success=true");
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierFacade.findAll();
        System.out.println(">> Retrieving all suppliers. Count: " + suppliers.size());
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("viewSuppliers.jsp").forward(request, response);
    }

    private void editSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierFacade.find(id);
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("editSupplier.jsp").forward(request, response);
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("supplierId"));
        Supplier supplier = supplierFacade.find(id);

        String supplierName = request.getParameter("supplierName");
        String contactPerson = request.getParameter("contactPerson");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // ========== APPLY BUSINESS RULES ON UPDATE ==========
        ValidationResult result = SupplierRules.validateAll(
                supplierName, contactPerson, email, phone, address);

        if (!result.isValid()) {
            System.out.println(">> BUSINESS RULE VIOLATION on update:");
            System.out.println(result.getErrorMessage());
            String errorMsg = java.net.URLEncoder.encode(result.getErrorMessage(), "UTF-8");
            response.sendRedirect("SupplierServlet?action=list&ruleError=" + errorMsg);
            return;
        }
        // =====================================================

        supplier.setSupplierName(supplierName);
        supplier.setContactPerson(contactPerson);
        supplier.setEmail(email);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setProductsSupplied(request.getParameter("productsSupplied"));
        supplier.setDeliverySchedule(request.getParameter("deliverySchedule"));
        supplier.setNotes(request.getParameter("notes"));

        System.out.println(">> UPDATING Supplier ID: " + id + " - " + supplier.getSupplierName());
        supplierFacade.edit(supplier);
        System.out.println(">> SUCCESS: Supplier updated in database!");

        response.sendRedirect("SupplierServlet?action=list&updated=true");
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierFacade.find(id);

        System.out.println(">> DELETING Supplier ID: " + id + " - " + supplier.getSupplierName());
        supplierFacade.remove(supplier);
        System.out.println(">> SUCCESS: Supplier deleted from database!");

        response.sendRedirect("SupplierServlet?action=list&deleted=true");
    }
}
