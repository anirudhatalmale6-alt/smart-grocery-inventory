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
 * Entity class for Supplier.
 * Maps to the SUPPLIER table in the Derby database.
 */
@Entity
@Table(name = "SUPPLIER")
@NamedQueries({
    @NamedQuery(name = "Supplier.findAll", query = "SELECT s FROM Supplier s"),
    @NamedQuery(name = "Supplier.findBySupplierId", query = "SELECT s FROM Supplier s WHERE s.supplierId = :supplierId"),
    @NamedQuery(name = "Supplier.findBySupplierName", query = "SELECT s FROM Supplier s WHERE s.supplierName = :supplierName")
})
public class Supplier implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SUPPLIER_ID")
    private Integer supplierId;

    @Basic(optional = false)
    @Column(name = "SUPPLIER_NAME")
    private String supplierName;

    @Basic(optional = false)
    @Column(name = "CONTACT_PERSON")
    private String contactPerson;

    @Basic(optional = false)
    @Column(name = "EMAIL")
    private String email;

    @Basic(optional = false)
    @Column(name = "PHONE")
    private String phone;

    @Basic(optional = false)
    @Column(name = "ADDRESS")
    private String address;

    @Basic(optional = false)
    @Column(name = "PRODUCTS_SUPPLIED")
    private String productsSupplied;

    @Column(name = "DELIVERY_SCHEDULE")
    private String deliverySchedule;

    @Column(name = "NOTES")
    private String notes;

    public Supplier() {
    }

    public Supplier(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getProductsSupplied() {
        return productsSupplied;
    }

    public void setProductsSupplied(String productsSupplied) {
        this.productsSupplied = productsSupplied;
    }

    public String getDeliverySchedule() {
        return deliverySchedule;
    }

    public void setDeliverySchedule(String deliverySchedule) {
        this.deliverySchedule = deliverySchedule;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public int hashCode() {
        return (supplierId != null ? supplierId.hashCode() : 0);
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Supplier)) {
            return false;
        }
        Supplier other = (Supplier) object;
        return (this.supplierId != null || other.supplierId == null) && (this.supplierId == null || this.supplierId.equals(other.supplierId));
    }

    @Override
    public String toString() {
        return "com.grocery.entity.Supplier[ supplierId=" + supplierId + " ]";
    }
}
