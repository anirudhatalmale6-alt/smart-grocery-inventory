package com.grocery.session;

import com.grocery.entity.Supplier;
import java.util.List;
import javax.ejb.Local;

/**
 * Local interface for Supplier Session Facade.
 */
@Local
public interface SupplierFacadeLocal {

    void create(Supplier supplier);

    void edit(Supplier supplier);

    void remove(Supplier supplier);

    Supplier find(Object id);

    List<Supplier> findAll();

    int count();
}
