package com.grocery.rules;

import java.util.ArrayList;
import java.util.List;

/**
 * Holds the result of business rule validation.
 * Contains lists of errors (blocking) and warnings (informational).
 */
public class ValidationResult {

    private List<String> errors;
    private List<String> warnings;

    public ValidationResult() {
        this.errors = new ArrayList<>();
        this.warnings = new ArrayList<>();
    }

    public void addError(String message) {
        errors.add(message);
    }

    public void addWarning(String message) {
        warnings.add(message);
    }

    public boolean isValid() {
        return errors.isEmpty();
    }

    public boolean hasWarnings() {
        return !warnings.isEmpty();
    }

    public List<String> getErrors() {
        return errors;
    }

    public List<String> getWarnings() {
        return warnings;
    }

    public String getErrorMessage() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < errors.size(); i++) {
            if (i > 0) sb.append("\n");
            sb.append("- ").append(errors.get(i));
        }
        return sb.toString();
    }

    public String getWarningMessage() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < warnings.size(); i++) {
            if (i > 0) sb.append("\n");
            sb.append("- ").append(warnings.get(i));
        }
        return sb.toString();
    }

    public void merge(ValidationResult other) {
        this.errors.addAll(other.getErrors());
        this.warnings.addAll(other.getWarnings());
    }
}
