package com.grocery.webservice;

import com.grocery.entity.Supplier;
import com.grocery.session.SupplierFacadeLocal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("suppliers")
public class SupplierResource {

    @EJB
    private SupplierFacadeLocal supplierFacade;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllSuppliers() {
        List<Supplier> suppliers = supplierFacade.findAll();
        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < suppliers.size(); i++) {
            Supplier s = suppliers.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"supplierId\":").append(s.getSupplierId()).append(",");
            json.append("\"supplierName\":\"").append(escapeJson(s.getSupplierName())).append("\",");
            json.append("\"contactPerson\":\"").append(escapeJson(s.getContactPerson())).append("\",");
            json.append("\"email\":\"").append(escapeJson(s.getEmail())).append("\",");
            json.append("\"phone\":\"").append(escapeJson(s.getPhone())).append("\",");
            json.append("\"address\":\"").append(escapeJson(s.getAddress())).append("\",");
            json.append("\"productsSupplied\":\"").append(escapeJson(s.getProductsSupplied())).append("\",");
            json.append("\"deliverySchedule\":\"").append(escapeJson(s.getDeliverySchedule() != null ? s.getDeliverySchedule() : "")).append("\",");
            json.append("\"notes\":\"").append(escapeJson(s.getNotes() != null ? s.getNotes() : "")).append("\"");
            json.append("}");
        }

        json.append("]");
        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSupplier(@PathParam("id") Integer id) {
        Supplier s = supplierFacade.find(id);
        if (s == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Supplier not found\"}").build();
        }

        StringBuilder json = new StringBuilder("{");
        json.append("\"supplierId\":").append(s.getSupplierId()).append(",");
        json.append("\"supplierName\":\"").append(escapeJson(s.getSupplierName())).append("\",");
        json.append("\"contactPerson\":\"").append(escapeJson(s.getContactPerson())).append("\",");
        json.append("\"email\":\"").append(escapeJson(s.getEmail())).append("\",");
        json.append("\"phone\":\"").append(escapeJson(s.getPhone())).append("\",");
        json.append("\"address\":\"").append(escapeJson(s.getAddress())).append("\",");
        json.append("\"productsSupplied\":\"").append(escapeJson(s.getProductsSupplied())).append("\",");
        json.append("\"deliverySchedule\":\"").append(escapeJson(s.getDeliverySchedule() != null ? s.getDeliverySchedule() : "")).append("\",");
        json.append("\"notes\":\"").append(escapeJson(s.getNotes() != null ? s.getNotes() : "")).append("\"");
        json.append("}");

        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("count")
    @Produces(MediaType.TEXT_PLAIN)
    public Response getCount() {
        int count = supplierFacade.count();
        return Response.ok(String.valueOf(count)).build();
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
