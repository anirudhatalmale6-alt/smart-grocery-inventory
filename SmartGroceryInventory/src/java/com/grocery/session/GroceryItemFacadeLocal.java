package com.grocery.session;

import com.grocery.entity.GroceryItem;
import java.util.List;
import javax.ejb.Local;

/**
 * Local interface for GroceryItem Session Facade.
 */
@Local
public interface GroceryItemFacadeLocal {

    void create(GroceryItem groceryItem);

    void edit(GroceryItem groceryItem);

    void remove(GroceryItem groceryItem);

    GroceryItem find(Object id);

    List<GroceryItem> findAll();

    int count();
}
