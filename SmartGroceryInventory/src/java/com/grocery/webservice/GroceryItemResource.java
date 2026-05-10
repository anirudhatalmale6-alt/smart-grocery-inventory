package com.grocery.webservice;

import com.grocery.entity.GroceryItem;
import com.grocery.session.GroceryItemFacadeLocal;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("groceryitems")
public class GroceryItemResource {

    @EJB
    private GroceryItemFacadeLocal groceryItemFacade;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllItems() {
        List<GroceryItem> items = groceryItemFacade.findAll();
        StringBuilder json = new StringBuilder("[");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        for (int i = 0; i < items.size(); i++) {
            GroceryItem item = items.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"itemId\":").append(item.getItemId()).append(",");
            json.append("\"itemName\":\"").append(escapeJson(item.getItemName())).append("\",");
            json.append("\"brand\":\"").append(escapeJson(item.getBrand())).append("\",");
            json.append("\"category\":\"").append(escapeJson(item.getCategory())).append("\",");
            json.append("\"quantity\":").append(item.getQuantity()).append(",");
            json.append("\"price\":").append(item.getPrice()).append(",");
            json.append("\"expiryDate\":\"").append(item.getExpiryDate() != null ? sdf.format(item.getExpiryDate()) : "").append("\",");
            json.append("\"supplier\":\"").append(escapeJson(item.getSupplier() != null ? item.getSupplier() : "")).append("\",");
            json.append("\"description\":\"").append(escapeJson(item.getDescription() != null ? item.getDescription() : "")).append("\"");
            json.append("}");
        }

        json.append("]");
        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getItem(@PathParam("id") Integer id) {
        GroceryItem item = groceryItemFacade.find(id);
        if (item == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Grocery item not found\"}").build();
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder json = new StringBuilder("{");
        json.append("\"itemId\":").append(item.getItemId()).append(",");
        json.append("\"itemName\":\"").append(escapeJson(item.getItemName())).append("\",");
        json.append("\"brand\":\"").append(escapeJson(item.getBrand())).append("\",");
        json.append("\"category\":\"").append(escapeJson(item.getCategory())).append("\",");
        json.append("\"quantity\":").append(item.getQuantity()).append(",");
        json.append("\"price\":").append(item.getPrice()).append(",");
        json.append("\"expiryDate\":\"").append(item.getExpiryDate() != null ? sdf.format(item.getExpiryDate()) : "").append("\",");
        json.append("\"supplier\":\"").append(escapeJson(item.getSupplier() != null ? item.getSupplier() : "")).append("\",");
        json.append("\"description\":\"").append(escapeJson(item.getDescription() != null ? item.getDescription() : "")).append("\"");
        json.append("}");

        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("count")
    @Produces(MediaType.TEXT_PLAIN)
    public Response getCount() {
        int count = groceryItemFacade.count();
        return Response.ok(String.valueOf(count)).build();
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
