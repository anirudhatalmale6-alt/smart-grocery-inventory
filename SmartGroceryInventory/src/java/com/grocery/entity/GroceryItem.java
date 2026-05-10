package com.grocery.entity;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Entity class for Grocery Item.
 * Maps to the GROCERY_ITEM table in the Derby database.
 */
@Entity
@Table(name = "GROCERY_ITEM")
@NamedQueries({
    @NamedQuery(name = "GroceryItem.findAll", query = "SELECT g FROM GroceryItem g"),
    @NamedQuery(name = "GroceryItem.findByItemId", query = "SELECT g FROM GroceryItem g WHERE g.itemId = :itemId"),
    @NamedQuery(name = "GroceryItem.findByItemName", query = "SELECT g FROM GroceryItem g WHERE g.itemName = :itemName"),
    @NamedQuery(name = "GroceryItem.findByCategory", query = "SELECT g FROM GroceryItem g WHERE g.category = :category")
})
public class GroceryItem implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ITEM_ID")
    private Integer itemId;

    @Basic(optional = false)
    @Column(name = "ITEM_NAME")
    private String itemName;

    @Basic(optional = false)
    @Column(name = "BRAND")
    private String brand;

    @Basic(optional = false)
    @Column(name = "CATEGORY")
    private String category;

    @Basic(optional = false)
    @Column(name = "QUANTITY")
    private int quantity;

    @Basic(optional = false)
    @Column(name = "PRICE")
    private double price;

    @Basic(optional = false)
    @Column(name = "EXPIRY_DATE")
    @Temporal(TemporalType.DATE)
    private Date expiryDate;

    @Column(name = "SUPPLIER")
    private String supplier;

    @Column(name = "DESCRIPTION")
    private String description;

    public GroceryItem() {
    }

    public GroceryItem(Integer itemId) {
        this.itemId = itemId;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public int hashCode() {
        return (itemId != null ? itemId.hashCode() : 0);
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof GroceryItem)) {
            return false;
        }
        GroceryItem other = (GroceryItem) object;
        return (this.itemId != null || other.itemId == null) && (this.itemId == null || this.itemId.equals(other.itemId));
    }

    @Override
    public String toString() {
        return "com.grocery.entity.GroceryItem[ itemId=" + itemId + " ]";
    }
}
