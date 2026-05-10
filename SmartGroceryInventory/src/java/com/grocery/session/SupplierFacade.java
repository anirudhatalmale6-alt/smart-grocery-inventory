package com.grocery.session;

import com.grocery.entity.Supplier;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * Session Facade for Supplier entity.
 * Provides CRUD operations via the AbstractFacade.
 */
@Stateless
public class SupplierFacade extends AbstractFacade<Supplier> implements SupplierFacadeLocal {

    @PersistenceContext(unitName = "SmartGroceryInventoryPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public SupplierFacade() {
        super(Supplier.class);
    }
}
