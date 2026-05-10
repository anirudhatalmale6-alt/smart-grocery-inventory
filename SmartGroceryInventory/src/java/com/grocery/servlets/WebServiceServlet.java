package com.grocery.servlets;

import com.grocery.rules.WebServiceClient;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to handle external Web Service calls.
 * Integrates two APIs:
 * 1. OpenFoodFacts API - product nutrition lookup
 * 2. 7Timer API - weather forecast for delivery planning
 *
 * Uses WebServiceClient from the shared SmartGroceryRules library.
 */
@WebServlet(name = "WebServiceServlet", urlPatterns = {"/WebServiceServlet"})
public class WebServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "page";
        }

        switch (action) {
            case "searchFood":
                searchFood(request, response);
                break;
            case "weather":
                getWeather(request, response);
                break;
            default:
                request.getRequestDispatcher("webServices.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void searchFood(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("searchTerm");

        System.out.println("==============================================");
        System.out.println("   CALLING OPENFOODFACTS WEB SERVICE");
        System.out.println("==============================================");
        System.out.println("Search Term: " + searchTerm);

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            List<String[]> results = WebServiceClient.searchFoodProduct(searchTerm.trim());

            System.out.println(">> Results found: " + results.size());
            for (String[] product : results) {
                System.out.println("   - " + product[0] + " (" + product[1] + ")");
            }
            System.out.println("==============================================");

            request.setAttribute("foodResults", results);
            request.setAttribute("searchTerm", searchTerm);
        }

        request.getRequestDispatcher("webServices.jsp").forward(request, response);
    }

    private void getWeather(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String latStr = request.getParameter("latitude");
        String lonStr = request.getParameter("longitude");
        String locationName = request.getParameter("locationName");

        System.out.println("==============================================");
        System.out.println("   CALLING 7TIMER WEATHER WEB SERVICE");
        System.out.println("==============================================");

        double lat = 40.7128;
        double lon = -74.0060;
        if (locationName == null || locationName.isEmpty()) {
            locationName = "New York, NY";
        }

        try {
            if (latStr != null && !latStr.isEmpty()) {
                lat = Double.parseDouble(latStr);
            }
            if (lonStr != null && !lonStr.isEmpty()) {
                lon = Double.parseDouble(lonStr);
            }
        } catch (NumberFormatException e) {
            System.out.println(">> Invalid coordinates, using defaults");
        }

        System.out.println("Location: " + locationName + " (" + lat + ", " + lon + ")");

        List<String[]> forecast = WebServiceClient.getWeatherForecast(lat, lon);

        System.out.println(">> Forecast entries: " + forecast.size());
        System.out.println("==============================================");

        request.setAttribute("weatherResults", forecast);
        request.setAttribute("locationName", locationName);
        request.setAttribute("latitude", lat);
        request.setAttribute("longitude", lon);

        request.getRequestDispatcher("webServices.jsp").forward(request, response);
    }
}
