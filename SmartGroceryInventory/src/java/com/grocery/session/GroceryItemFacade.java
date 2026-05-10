package com.grocery.session;

import com.grocery.entity.GroceryItem;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * Session Facade for GroceryItem entity.
 * Provides CRUD operations via the AbstractFacade.
 */
@Stateless
public class GroceryItemFacade extends AbstractFacade<GroceryItem> implements GroceryItemFacadeLocal {

    @PersistenceContext(unitName = "SmartGroceryInventoryPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public GroceryItemFacade() {
        super(GroceryItem.class);
    }
}
