package com.grocery.session;

import com.grocery.entity.Category;
import java.util.List;
import javax.ejb.Local;

/**
 * Local interface for Category Session Facade.
 */
@Local
public interface CategoryFacadeLocal {

    void create(Category category);

    void edit(Category category);

    void remove(Category category);

    Category find(Object id);

    List<Category> findAll();

    int count();
}
