package com.grocery.rules;

import java.util.Date;
import java.util.Calendar;

/**
 * Business rules for Grocery Items.
 *
 * Rules enforced:
 * 1. Expiry Date Rule - Items cannot have past expiry dates; warns if expiring within 7 days
 * 2. Inventory Limits Rule - Quantity 1-10000, Price $0.01-$9999.99, total value cap $50,000
 * 3. Duplicate Prevention Rule - Same item name + brand combination is not allowed
 */
public class GroceryItemRules {

    private static final double MAX_PRICE = 9999.99;
    private static final double MIN_PRICE = 0.01;
    private static final int MAX_QUANTITY = 10000;
    private static final int MIN_QUANTITY = 1;
    private static final double MAX_TOTAL_VALUE = 50000.00;
    private static final int EXPIRY_WARNING_DAYS = 7;

    /**
     * BUSINESS RULE 1: Expiry Date Validation
     * - Expiry date cannot be in the past
     * - Warning if item expires within 7 days
     * - Perishable category items must not have expiry date more than 1 year out
     */
    public static ValidationResult validateExpiryDate(Date expiryDate, String category) {
        ValidationResult result = new ValidationResult();

        if (expiryDate == null) {
            result.addError("Expiry date is required.");
            return result;
        }

        // Get today's date at midnight for fair comparison
        Calendar today = Calendar.getInstance();
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MILLISECOND, 0);

        // Rule: Cannot add items with past expiry dates
        if (expiryDate.before(today.getTime())) {
            result.addError("Cannot add an item that has already expired. "
                    + "The expiry date must be today or a future date.");
            return result;
        }

        // Warning: Item expires within 7 days
        Calendar warningDate = (Calendar) today.clone();
        warningDate.add(Calendar.DAY_OF_MONTH, EXPIRY_WARNING_DAYS);
        if (expiryDate.before(warningDate.getTime())) {
            result.addWarning("This item expires within " + EXPIRY_WARNING_DAYS
                    + " days. Consider marking it for quick sale or discount.");
        }

        // Rule: Perishable categories should not have expiry > 1 year
        if (isPerishableCategory(category)) {
            Calendar oneYearOut = (Calendar) today.clone();
            oneYearOut.add(Calendar.YEAR, 1);
            if (expiryDate.after(oneYearOut.getTime())) {
                result.addError("Perishable items (category: " + category
                        + ") cannot have an expiry date more than 1 year from today.");
            }
        }

        return result;
    }

    /**
     * BUSINESS RULE 2: Inventory Limits Validation
     * - Quantity must be between 1 and 10,000
     * - Price must be between $0.01 and $9,999.99
     * - Total inventory value (quantity x price) cannot exceed $50,000
     */
    public static ValidationResult validateInventoryLimits(int quantity, double price) {
        ValidationResult result = new ValidationResult();

        // Quantity range check
        if (quantity < MIN_QUANTITY) {
            result.addError("Quantity must be at least " + MIN_QUANTITY
                    + ". Cannot stock zero or negative items.");
        } else if (quantity > MAX_QUANTITY) {
            result.addError("Quantity cannot exceed " + MAX_QUANTITY
                    + " units per item entry. Split into multiple entries if needed.");
        }

        // Price range check
        if (price < MIN_PRICE) {
            result.addError("Price must be at least $" + String.format("%.2f", MIN_PRICE)
                    + ". Free items are not allowed in inventory.");
        } else if (price > MAX_PRICE) {
            result.addError("Price cannot exceed $" + String.format("%.2f", MAX_PRICE)
                    + " per unit.");
        }

        // Total value cap
        if (quantity > 0 && price > 0) {
            double totalValue = quantity * price;
            if (totalValue > MAX_TOTAL_VALUE) {
                result.addError("Total inventory value ($" + String.format("%.2f", totalValue)
                        + ") exceeds the maximum of $" + String.format("%.2f", MAX_TOTAL_VALUE)
                        + " per item. Reduce quantity or price.");
            }
        }

        // Warning for large orders
        if (quantity > 5000 && price > 0) {
            result.addWarning("Large quantity order (" + quantity
                    + " units). Please verify this is correct.");
        }

        return result;
    }

    /**
     * BUSINESS RULE 3: Duplicate Item Prevention
     * - Cannot have two items with the same name AND brand
     * Returns true if a duplicate exists (i.e., validation fails)
     */
    public static ValidationResult checkDuplicate(String itemName, String brand,
            String existingItemName, String existingBrand) {
        ValidationResult result = new ValidationResult();

        if (itemName != null && brand != null
                && existingItemName != null && existingBrand != null
                && itemName.trim().equalsIgnoreCase(existingItemName.trim())
                && brand.trim().equalsIgnoreCase(existingBrand.trim())) {
            result.addError("A grocery item with the name '" + itemName
                    + "' and brand '" + brand + "' already exists in the inventory. "
                    + "Update the existing entry instead of creating a duplicate.");
        }

        return result;
    }

    /**
     * Convenience method: validate all grocery item rules at once.
     */
    public static ValidationResult validateAll(String itemName, String brand,
            String category, int quantity, double price, Date expiryDate) {
        ValidationResult result = new ValidationResult();

        // Basic required fields
        if (itemName == null || itemName.trim().isEmpty()) {
            result.addError("Item name is required.");
        }
        if (brand == null || brand.trim().isEmpty()) {
            result.addError("Brand is required.");
        }
        if (category == null || category.trim().isEmpty()) {
            result.addError("Category is required.");
        }

        // Apply business rules
        result.merge(validateExpiryDate(expiryDate, category));
        result.merge(validateInventoryLimits(quantity, price));

        return result;
    }

    /**
     * Helper: determine if a category is perishable
     */
    private static boolean isPerishableCategory(String category) {
        if (category == null) return false;
        String cat = category.toLowerCase().trim();
        return cat.equals("dairy") || cat.equals("fruits") || cat.equals("vegetables")
                || cat.equals("meat") || cat.equals("seafood") || cat.equals("bakery");
    }
}
