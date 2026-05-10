package com.grocery.webservice;

import com.grocery.entity.Category;
import com.grocery.session.CategoryFacadeLocal;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("categories")
public class CategoryResource {

    @EJB
    private CategoryFacadeLocal categoryFacade;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllCategories() {
        List<Category> categories = categoryFacade.findAll();
        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < categories.size(); i++) {
            Category c = categories.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"categoryId\":").append(c.getCategoryId()).append(",");
            json.append("\"categoryName\":\"").append(escapeJson(c.getCategoryName())).append("\",");
            json.append("\"aisleNumber\":").append(c.getAisleNumber()).append(",");
            json.append("\"storageType\":\"").append(escapeJson(c.getStorageType())).append("\",");
            json.append("\"shelfLife\":\"").append(escapeJson(c.getShelfLife())).append("\",");
            json.append("\"description\":\"").append(escapeJson(c.getDescription())).append("\",");
            json.append("\"isPerishable\":\"").append(escapeJson(c.getIsPerishable() != null ? c.getIsPerishable() : "")).append("\",");
            json.append("\"minStockLevel\":").append(c.getMinStockLevel() != null ? c.getMinStockLevel() : 0);
            json.append("}");
        }

        json.append("]");
        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCategory(@PathParam("id") Integer id) {
        Category c = categoryFacade.find(id);
        if (c == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Category not found\"}").build();
        }

        StringBuilder json = new StringBuilder("{");
        json.append("\"categoryId\":").append(c.getCategoryId()).append(",");
        json.append("\"categoryName\":\"").append(escapeJson(c.getCategoryName())).append("\",");
        json.append("\"aisleNumber\":").append(c.getAisleNumber()).append(",");
        json.append("\"storageType\":\"").append(escapeJson(c.getStorageType())).append("\",");
        json.append("\"shelfLife\":\"").append(escapeJson(c.getShelfLife())).append("\",");
        json.append("\"description\":\"").append(escapeJson(c.getDescription())).append("\",");
        json.append("\"isPerishable\":\"").append(escapeJson(c.getIsPerishable() != null ? c.getIsPerishable() : "")).append("\",");
        json.append("\"minStockLevel\":").append(c.getMinStockLevel() != null ? c.getMinStockLevel() : 0);
        json.append("}");

        return Response.ok(json.toString()).build();
    }

    @GET
    @Path("count")
    @Produces(MediaType.TEXT_PLAIN)
    public Response getCount() {
        int count = categoryFacade.count();
        return Response.ok(String.valueOf(count)).build();
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
