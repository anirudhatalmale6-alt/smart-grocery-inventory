package com.grocery.entity;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * Entity class for Category.
 * Maps to the CATEGORY table in the Derby database.
 */
@Entity
@Table(name = "CATEGORY")
@NamedQueries({
    @NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c"),
    @NamedQuery(name = "Category.findByCategoryId", query = "SELECT c FROM Category c WHERE c.categoryId = :categoryId"),
    @NamedQuery(name = "Category.findByCategoryName", query = "SELECT c FROM Category c WHERE c.categoryName = :categoryName")
})
public class Category implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CATEGORY_ID")
    private Integer categoryId;

    @Basic(optional = false)
    @Column(name = "CATEGORY_NAME")
    private String categoryName;

    @Basic(optional = false)
    @Column(name = "AISLE_NUMBER")
    private int aisleNumber;

    @Basic(optional = false)
    @Column(name = "STORAGE_TYPE")
    private String storageType;

    @Basic(optional = false)
    @Column(name = "SHELF_LIFE")
    private String shelfLife;

    @Basic(optional = false)
    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "IS_PERISHABLE")
    private String isPerishable;

    @Column(name = "MIN_STOCK_LEVEL")
    private Integer minStockLevel;

    public Category() {
    }

    public Category(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getAisleNumber() {
        return aisleNumber;
    }

    public void setAisleNumber(int aisleNumber) {
        this.aisleNumber = aisleNumber;
    }

    public String getStorageType() {
        return storageType;
    }

    public void setStorageType(String storageType) {
        this.storageType = storageType;
    }

    public String getShelfLife() {
        return shelfLife;
    }

    public void setShelfLife(String shelfLife) {
        this.shelfLife = shelfLife;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIsPerishable() {
        return isPerishable;
    }

    public void setIsPerishable(String isPerishable) {
        this.isPerishable = isPerishable;
    }

    public Integer getMinStockLevel() {
        return minStockLevel;
    }

    public void setMinStockLevel(Integer minStockLevel) {
        this.minStockLevel = minStockLevel;
    }

    @Override
    public int hashCode() {
        return (categoryId != null ? categoryId.hashCode() : 0);
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Category)) {
            return false;
        }
        Category other = (Category) object;
        return (this.categoryId != null || other.categoryId == null) && (this.categoryId == null || this.categoryId.equals(other.categoryId));
    }

    @Override
    public String toString() {
        return "com.grocery.entity.Category[ categoryId=" + categoryId + " ]";
    }
}
