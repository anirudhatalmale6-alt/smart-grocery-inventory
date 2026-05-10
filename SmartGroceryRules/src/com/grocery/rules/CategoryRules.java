package com.grocery.rules;

/**
 * Business rules for Categories.
 *
 * Rule enforced:
 * 5. Category Storage Consistency - Perishable items must use appropriate storage,
 *    aisle range validation, minimum stock constraints
 */
public class CategoryRules {

    private static final int MIN_AISLE = 1;
    private static final int MAX_AISLE = 50;
    private static final int MIN_STOCK_FLOOR = 1;
    private static final int MAX_STOCK_CEILING = 1000;

    /**
     * BUSINESS RULE 5: Category Storage and Constraint Validation
     * - Aisle number must be between 1 and 50
     * - Minimum stock level must be between 1 and 1000
     * - Perishable items MUST use Refrigerated or Frozen storage (not Room Temperature)
     * - Non-perishable items should not use Frozen storage (warning)
     * - Category name must be at least 2 characters
     */
    public static ValidationResult validateCategoryConstraints(String categoryName,
            int aisleNumber, String storageType, String isPerishable, int minStockLevel) {

        ValidationResult result = new ValidationResult();

        // Category name
        if (categoryName == null || categoryName.trim().length() < 2) {
            result.addError("Category name must be at least 2 characters long.");
        }

        // Aisle number range
        if (aisleNumber < MIN_AISLE || aisleNumber > MAX_AISLE) {
            result.addError("Aisle number must be between " + MIN_AISLE + " and " + MAX_AISLE
                    + ". The store has " + MAX_AISLE + " aisles.");
        }

        // Minimum stock level range
        if (minStockLevel < MIN_STOCK_FLOOR) {
            result.addError("Minimum stock level must be at least " + MIN_STOCK_FLOOR
                    + ". A value of zero means you would never reorder.");
        } else if (minStockLevel > MAX_STOCK_CEILING) {
            result.addError("Minimum stock level cannot exceed " + MAX_STOCK_CEILING
                    + ". This seems unreasonably high for a reorder threshold.");
        }

        // Storage consistency with perishable flag
        boolean perishable = "Yes".equalsIgnoreCase(isPerishable);
        if (storageType != null) {
            String storage = storageType.trim();

            if (perishable) {
                // Perishable items must be refrigerated or frozen
                if (storage.equalsIgnoreCase("Room Temperature")
                        || storage.equalsIgnoreCase("Cool and Dry")) {
                    result.addError("Perishable items must be stored in 'Refrigerated' or "
                            + "'Frozen' storage, not '" + storage + "'. "
                            + "This ensures food safety and compliance.");
                }
            } else {
                // Non-perishable in frozen is unusual
                if (storage.equalsIgnoreCase("Frozen")) {
                    result.addWarning("Non-perishable items stored in 'Frozen' storage is "
                            + "unusual. Verify this is correct or change to a more "
                            + "appropriate storage type.");
                }
            }
        }

        // High min stock warning
        if (minStockLevel > 500) {
            result.addWarning("Minimum stock level of " + minStockLevel
                    + " is quite high. This will trigger frequent reorder alerts.");
        }

        return result;
    }

    /**
     * Convenience method: validate all category rules.
     */
    public static ValidationResult validateAll(String categoryName, int aisleNumber,
            String storageType, String isPerishable, int minStockLevel) {
        return validateCategoryConstraints(categoryName, aisleNumber, storageType,
                isPerishable, minStockLevel);
    }
}
