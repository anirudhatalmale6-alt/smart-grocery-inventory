package com.grocery.rules;

/**
 * Business rules for Suppliers.
 *
 * Rule enforced:
 * 4. Supplier Contact Validation - Email format, phone length, name length
 */
public class SupplierRules {

    private static final int MIN_PHONE_LENGTH = 10;
    private static final int MIN_NAME_LENGTH = 2;

    /**
     * BUSINESS RULE 4: Supplier Contact Information Validation
     * - Email must contain '@' and a valid domain (at least one '.' after '@')
     * - Phone number must be at least 10 characters
     * - Supplier name must be at least 2 characters
     * - Contact person name must be at least 2 characters
     * - Address must not be empty
     */
    public static ValidationResult validateSupplierContact(String supplierName,
            String contactPerson, String email, String phone, String address) {

        ValidationResult result = new ValidationResult();

        // Supplier name length
        if (supplierName == null || supplierName.trim().length() < MIN_NAME_LENGTH) {
            result.addError("Supplier name must be at least " + MIN_NAME_LENGTH
                    + " characters long.");
        }

        // Contact person length
        if (contactPerson == null || contactPerson.trim().length() < MIN_NAME_LENGTH) {
            result.addError("Contact person name must be at least " + MIN_NAME_LENGTH
                    + " characters long.");
        }

        // Email validation - must have @ and domain with dot
        if (email == null || email.trim().isEmpty()) {
            result.addError("Email address is required.");
        } else {
            String trimmedEmail = email.trim();
            int atIndex = trimmedEmail.indexOf('@');
            if (atIndex <= 0) {
                result.addError("Email address must contain '@' with a valid username before it. "
                        + "Example: contact@supplier.com");
            } else {
                String domain = trimmedEmail.substring(atIndex + 1);
                if (!domain.contains(".") || domain.startsWith(".") || domain.endsWith(".")) {
                    result.addError("Email domain is invalid. Must have a valid domain like "
                            + "'supplier.com'. Example: contact@supplier.com");
                }
            }

            // Warning for common typos
            if (trimmedEmail.contains("..") || trimmedEmail.contains("@@")) {
                result.addWarning("Email address contains unusual characters (.."
                        + " or @@). Please verify the email is correct.");
            }
        }

        // Phone validation - at least 10 digits
        if (phone == null || phone.trim().isEmpty()) {
            result.addError("Phone number is required.");
        } else {
            String digitsOnly = phone.replaceAll("[^0-9]", "");
            if (digitsOnly.length() < MIN_PHONE_LENGTH) {
                result.addError("Phone number must contain at least " + MIN_PHONE_LENGTH
                        + " digits. Current: " + digitsOnly.length() + " digits. "
                        + "Include area code and full number.");
            }
        }

        // Address validation
        if (address == null || address.trim().isEmpty()) {
            result.addError("Supplier address is required for delivery coordination.");
        } else if (address.trim().length() < 5) {
            result.addWarning("Address seems very short. Make sure it includes "
                    + "street, city, and state/zip for accurate deliveries.");
        }

        return result;
    }

    /**
     * Convenience method: validate all supplier rules.
     */
    public static ValidationResult validateAll(String supplierName, String contactPerson,
            String email, String phone, String address) {
        return validateSupplierContact(supplierName, contactPerson, email, phone, address);
    }
}
