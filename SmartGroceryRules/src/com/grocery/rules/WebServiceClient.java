package com.grocery.rules;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

/**
 * Web Service Client for external API integration.
 * Calls OpenFoodFacts API for product nutrition lookup
 * and 7Timer API for weather/delivery forecast.
 *
 * This class is part of the shared SmartGroceryRules library
 * and is used by both the Web and Desktop applications.
 */
public class WebServiceClient {

    private static final String FOOD_API_BASE = "https://world.openfoodfacts.org/api/v2/search";
    private static final String WEATHER_API_BASE = "https://www.7timer.info/bin/api.pl";
    private static final int TIMEOUT_MS = 10000;

    /**
     * Search for food products by name using the OpenFoodFacts API.
     * Returns product info including nutrition data.
     */
    public static List<String[]> searchFoodProduct(String searchTerm) {
        List<String[]> results = new ArrayList<>();

        try {
            String encoded = URLEncoder.encode(searchTerm, "UTF-8");
            String urlStr = FOOD_API_BASE
                    + "?search_terms=" + encoded
                    + "&page_size=5"
                    + "&fields=product_name,brands,categories,nutriments,image_url";

            String json = fetchUrl(urlStr);

            // Parse JSON manually (no external library needed)
            String[] products = splitJsonArray(json, "products");
            for (String product : products) {
                String name = extractJsonValue(product, "product_name");
                String brand = extractJsonValue(product, "brands");
                String categories = extractJsonValue(product, "categories");

                // Extract nutriment values
                String calories = extractNestedValue(product, "nutriments", "energy-kcal_100g");
                String fat = extractNestedValue(product, "nutriments", "fat_100g");
                String protein = extractNestedValue(product, "nutriments", "proteins_100g");
                String carbs = extractNestedValue(product, "nutriments", "carbohydrates_100g");
                String sugar = extractNestedValue(product, "nutriments", "sugars_100g");
                String salt = extractNestedValue(product, "nutriments", "salt_100g");

                if (name != null && !name.isEmpty()) {
                    results.add(new String[]{
                            name,
                            brand != null ? brand : "N/A",
                            categories != null ? categories : "N/A",
                            calories != null ? calories : "N/A",
                            fat != null ? fat : "N/A",
                            protein != null ? protein : "N/A",
                            carbs != null ? carbs : "N/A",
                            sugar != null ? sugar : "N/A",
                            salt != null ? salt : "N/A"
                    });
                }
            }

            System.out.println(">> Web Service: Found " + results.size()
                    + " products for '" + searchTerm + "'");

        } catch (Exception e) {
            System.out.println(">> Web Service ERROR: " + e.getMessage());
        }

        return results;
    }

    /**
     * Get weather forecast for a location using the 7Timer API.
     * Useful for delivery/supply chain planning.
     */
    public static List<String[]> getWeatherForecast(double latitude, double longitude) {
        List<String[]> results = new ArrayList<>();

        try {
            String urlStr = WEATHER_API_BASE
                    + "?lon=" + longitude
                    + "&lat=" + latitude
                    + "&product=civil&output=json";

            String json = fetchUrl(urlStr);
            System.out.println("Weather API URL: " + urlStr);
            System.out.println("Weather API Response: " + json);

            String init = extractJsonValue(json, "init");
            String[] entries = splitJsonArray(json, "dataseries");
            System.out.println("Weather dataseries count: " + entries.length);
            int count = 0;
            for (String entry : entries) {
                if (count >= 8) break;

                String timepoint = extractJsonValue(entry, "timepoint");
                String temp = extractJsonValue(entry, "temp2m");
                String humidity = extractJsonValue(entry, "rh2m");
                String weather = extractJsonValue(entry, "weather");
                String precType = extractJsonValue(entry, "prec_type");
                String cloudcover = extractJsonValue(entry, "cloudcover");

                // Extract wind info
                String windDir = extractJsonValue(entry, "direction");
                String windSpeed = extractJsonValue(entry, "speed");

                String weatherDesc = decodeWeather(weather);
                String windInfo = (windDir != null ? windDir : "") + " "
                        + decodeWindSpeed(windSpeed);

                results.add(new String[]{
                        "+" + timepoint + "h",
                        temp != null ? temp + "°C" : "N/A",
                        humidity != null ? humidity : "N/A",
                        weatherDesc,
                        precType != null ? precType : "none",
                        windInfo.trim(),
                        cloudcover != null ? decodeCloudCover(cloudcover) : "N/A"
                });

                count++;
            }

            System.out.println(">> Web Service: Retrieved " + results.size()
                    + " weather forecast entries (init: " + init + ")");

        } catch (Exception e) {
            System.out.println(">> Web Service ERROR: " + e.getMessage());
        }

        return results;
    }

    /**
     * Make an HTTP GET request and return the response body as a string.
     */
    private static String fetchUrl(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(TIMEOUT_MS);
        conn.setReadTimeout(TIMEOUT_MS);
        conn.setRequestProperty("User-Agent", "SmartGroceryInventory/1.0");

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new Exception("HTTP error code: " + responseCode);
        }

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        reader.close();
        conn.disconnect();

        String result = sb.toString();
        result = result.replace("\t", "");
        result = result.replaceAll("\" :", "\":");
        return result;
    }

    /**
     * Extract a simple JSON string value by key.
     */
    private static String extractJsonValue(String json, String key) {
        if (json == null) return null;

        String searchKey = "\"" + key + "\":";
        int keyIndex = json.indexOf(searchKey);
        if (keyIndex < 0) return null;

        int valueStart = keyIndex + searchKey.length();
        // Skip whitespace
        while (valueStart < json.length() && json.charAt(valueStart) == ' ') {
            valueStart++;
        }

        if (valueStart >= json.length()) return null;

        char firstChar = json.charAt(valueStart);

        if (firstChar == '"') {
            // String value
            int strStart = valueStart + 1;
            int strEnd = strStart;
            while (strEnd < json.length()) {
                if (json.charAt(strEnd) == '"' && json.charAt(strEnd - 1) != '\\') {
                    break;
                }
                strEnd++;
            }
            return json.substring(strStart, strEnd);
        } else if (firstChar == '{' || firstChar == '[') {
            return null;
        } else {
            // Number or literal
            int numEnd = valueStart;
            while (numEnd < json.length()
                    && json.charAt(numEnd) != ','
                    && json.charAt(numEnd) != '}'
                    && json.charAt(numEnd) != ']') {
                numEnd++;
            }
            String val = json.substring(valueStart, numEnd).trim();
            if ("null".equals(val)) return null;
            return val;
        }
    }

    /**
     * Extract a nested JSON value (one level deep).
     */
    private static String extractNestedValue(String json, String parentKey, String childKey) {
        if (json == null) return null;

        String searchKey = "\"" + parentKey + "\":";
        int keyIndex = json.indexOf(searchKey);
        if (keyIndex < 0) return null;

        int braceStart = json.indexOf('{', keyIndex);
        if (braceStart < 0) return null;

        // Find matching closing brace
        int depth = 1;
        int braceEnd = braceStart + 1;
        while (braceEnd < json.length() && depth > 0) {
            if (json.charAt(braceEnd) == '{') depth++;
            if (json.charAt(braceEnd) == '}') depth--;
            braceEnd++;
        }

        String nested = json.substring(braceStart, braceEnd);
        return extractJsonValue(nested, childKey);
    }

    /**
     * Split a JSON array by key name into individual object strings.
     */
    private static String[] splitJsonArray(String json, String arrayKey) {
        if (json == null) return new String[0];

        String searchKey = "\"" + arrayKey + "\":";
        int keyIndex = json.indexOf(searchKey);
        if (keyIndex < 0) return new String[0];

        int arrayStart = json.indexOf('[', keyIndex);
        if (arrayStart < 0) return new String[0];

        // Find each top-level object in the array
        List<String> objects = new ArrayList<>();
        int pos = arrayStart + 1;
        while (pos < json.length()) {
            // Find next object start
            int objStart = json.indexOf('{', pos);
            if (objStart < 0) break;

            // Find matching close
            int depth = 1;
            int objEnd = objStart + 1;
            while (objEnd < json.length() && depth > 0) {
                if (json.charAt(objEnd) == '{') depth++;
                if (json.charAt(objEnd) == '}') depth--;
                objEnd++;
            }

            objects.add(json.substring(objStart, objEnd));
            pos = objEnd;

            // Check if we've hit the end of the array
            int nextChar = pos;
            while (nextChar < json.length()
                    && (json.charAt(nextChar) == ' ' || json.charAt(nextChar) == ',')) {
                nextChar++;
            }
            if (nextChar >= json.length() || json.charAt(nextChar) == ']') break;
        }

        return objects.toArray(new String[0]);
    }

    /**
     * Decode 7Timer weather code to human-readable description.
     */
    private static String decodeWeather(String code) {
        if (code == null) return "Unknown";
        switch (code) {
            case "clearday": case "clearnight": return "Clear";
            case "pcloudyday": case "pcloudynight": return "Partly Cloudy";
            case "mcloudyday": case "mcloudynight": return "Mostly Cloudy";
            case "cloudyday": case "cloudynight": return "Cloudy";
            case "humidday": case "humidnight": return "Humid";
            case "lightrainday": case "lightrainnight": return "Light Rain";
            case "oshowerday": case "oshowernight": return "Occasional Showers";
            case "ishowerday": case "ishowernight": return "Isolated Showers";
            case "lightsnowday": case "lightsnownight": return "Light Snow";
            case "rainday": case "rainnight": return "Rain";
            case "snowday": case "snownight": return "Snow";
            case "rainsnowday": case "rainsnownight": return "Rain/Snow Mix";
            case "tsday": case "tsnight": return "Thunderstorm";
            case "tsrainday": case "tsrainnight": return "Thunderstorm w/ Rain";
            default: return code;
        }
    }

    /**
     * Decode 7Timer wind speed code.
     */
    private static String decodeWindSpeed(String code) {
        if (code == null) return "";
        switch (code) {
            case "1": return "Calm (<0.3 m/s)";
            case "2": return "Light (0.3-3.4 m/s)";
            case "3": return "Moderate (3.4-8.0 m/s)";
            case "4": return "Fresh (8.0-10.8 m/s)";
            case "5": return "Strong (10.8-17.2 m/s)";
            case "6": return "Gale (17.2-24.5 m/s)";
            case "7": return "Storm (24.5-32.6 m/s)";
            case "8": return "Hurricane (>32.6 m/s)";
            default: return code;
        }
    }

    /**
     * Decode 7Timer cloud cover value.
     */
    private static String decodeCloudCover(String value) {
        if (value == null) return "Unknown";
        try {
            int cover = Integer.parseInt(value);
            int percent = (cover * 100) / 9;
            return percent + "%";
        } catch (NumberFormatException e) {
            return value;
        }
    }
}
