<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web Services - Smart Grocery Inventory</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .service-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .service-section h2 {
            color: #1b4332;
            margin-bottom: 5px;
        }
        .service-section p.subtitle {
            color: #6c757d;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .search-form input, .search-form select {
            padding: 10px 15px;
            border: 2px solid #d8f3dc;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Segoe UI', sans-serif;
        }
        .search-form input:focus {
            outline: none;
            border-color: #2d6a4f;
        }
        .search-form button {
            padding: 10px 25px;
            background-color: #2d6a4f;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .search-form button:hover {
            background-color: #1b4332;
        }
        .result-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 18px;
            margin-bottom: 12px;
            border-left: 4px solid #2d6a4f;
        }
        .result-card h3 {
            color: #1b4332;
            margin: 0 0 8px 0;
            font-size: 16px;
        }
        .result-card .brand {
            color: #2d6a4f;
            font-weight: 600;
            font-size: 13px;
        }
        .nutrition-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 8px;
            margin-top: 12px;
        }
        .nutrition-item {
            background: white;
            padding: 8px 12px;
            border-radius: 6px;
            text-align: center;
            border: 1px solid #e0e0e0;
        }
        .nutrition-item .label {
            font-size: 11px;
            color: #6c757d;
            text-transform: uppercase;
        }
        .nutrition-item .value {
            font-size: 16px;
            font-weight: 700;
            color: #2d6a4f;
        }
        .weather-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
        }
        .weather-table thead th {
            background-color: #0077b6;
            color: white;
            padding: 12px 10px;
            text-align: center;
            font-size: 13px;
        }
        .weather-table tbody td {
            padding: 10px;
            text-align: center;
            font-size: 13px;
            border-bottom: 1px solid #eee;
        }
        .weather-table tbody tr:nth-child(even) {
            background-color: #f0f7ff;
        }
        .weather-table tbody tr:hover {
            background-color: #dbeafe;
        }
        .api-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 8px;
        }
        .api-badge.food { background: #d8f3dc; color: #1b4332; }
        .api-badge.weather { background: #dbeafe; color: #1e40af; }
        .no-results {
            text-align: center;
            color: #6c757d;
            padding: 30px;
            font-style: italic;
        }
        .location-presets {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .location-presets button {
            padding: 6px 14px;
            border: 2px solid #0077b6;
            background: white;
            color: #0077b6;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .location-presets button:hover {
            background: #0077b6;
            color: white;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-inner">
            <a href="index.jsp" class="brand">
                <span class="icon">&#127819;</span>
                Smart Grocery Inventory
            </a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="addGroceryItem.jsp">Add Item</a>
                <a href="addSupplier.jsp">Add Supplier</a>
                <a href="addCategory.jsp">Add Category</a>
                <a href="GroceryItemServlet?action=list">View Items</a>
                <a href="SupplierServlet?action=list">View Suppliers</a>
                <a href="CategoryServlet?action=list">View Categories</a>
                <a href="WebServiceServlet" class="active">Web Services</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#127760; External Web Services</h1>
            <p>Integrate real-time data from external APIs into your grocery inventory system.</p>
        </div>

        <!-- SECTION 1: Food Product Lookup -->
        <div class="service-section">
            <h2>&#127822; Food Product Lookup <span class="api-badge food">OpenFoodFacts API</span></h2>
            <p class="subtitle">Search the world's largest open food database for product nutrition information, ingredients, and details.</p>

            <form action="WebServiceServlet" method="GET" class="search-form">
                <input type="hidden" name="action" value="searchFood">
                <input type="text" name="searchTerm" placeholder="Search for a product (e.g., milk, bread, cereal)..."
                       value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>"
                       style="flex: 1; min-width: 250px;" required>
                <button type="submit">&#128269; Search Products</button>
            </form>

            <%
                List<String[]> foodResults = (List<String[]>) request.getAttribute("foodResults");
                if (foodResults != null && !foodResults.isEmpty()) {
            %>
                <p style="color: #2d6a4f; font-weight: 600; margin-bottom: 15px;">
                    Found <%= foodResults.size() %> product(s) for "<%= request.getAttribute("searchTerm") %>"
                </p>
                <% for (String[] product : foodResults) { %>
                    <div class="result-card">
                        <h3><%= product[0] %></h3>
                        <span class="brand">Brand: <%= product[1] %></span>
                        <div class="nutrition-grid">
                            <div class="nutrition-item">
                                <div class="label">Calories</div>
                                <div class="value"><%= product[3] %></div>
                                <div class="label">kcal/100g</div>
                            </div>
                            <div class="nutrition-item">
                                <div class="label">Fat</div>
                                <div class="value"><%= product[4] %></div>
                                <div class="label">g/100g</div>
                            </div>
                            <div class="nutrition-item">
                                <div class="label">Protein</div>
                                <div class="value"><%= product[5] %></div>
                                <div class="label">g/100g</div>
                            </div>
                            <div class="nutrition-item">
                                <div class="label">Carbs</div>
                                <div class="value"><%= product[6] %></div>
                                <div class="label">g/100g</div>
                            </div>
                            <div class="nutrition-item">
                                <div class="label">Sugar</div>
                                <div class="value"><%= product[7] %></div>
                                <div class="label">g/100g</div>
                            </div>
                            <div class="nutrition-item">
                                <div class="label">Salt</div>
                                <div class="value"><%= product[8] %></div>
                                <div class="label">g/100g</div>
                            </div>
                        </div>
                    </div>
                <% } %>
            <%
                } else if (request.getAttribute("searchTerm") != null) {
            %>
                <div class="no-results">No products found for "<%= request.getAttribute("searchTerm") %>". Try a different search term.</div>
            <% } %>
        </div>

        <!-- SECTION 2: Weather Forecast -->
        <div class="service-section">
            <h2>&#9925; Delivery Weather Forecast <span class="api-badge weather">7Timer API</span></h2>
            <p class="subtitle">Check weather conditions for delivery planning and supply chain logistics. Helps determine optimal delivery windows.</p>

            <div class="location-presets">
                <span style="font-size: 13px; color: #6c757d; padding: 6px 0;">Quick locations:</span>
                <button type="button" onclick="setLocation('New York, NY', 40.7128, -74.0060)">New York</button>
                <button type="button" onclick="setLocation('Los Angeles, CA', 34.0522, -118.2437)">Los Angeles</button>
                <button type="button" onclick="setLocation('Chicago, IL', 41.8781, -87.6298)">Chicago</button>
                <button type="button" onclick="setLocation('Houston, TX', 29.7604, -95.3698)">Houston</button>
                <button type="button" onclick="setLocation('Miami, FL', 25.7617, -80.1918)">Miami</button>
                <button type="button" onclick="setLocation('London, UK', 51.5074, -0.1278)">London</button>
            </div>

            <form action="WebServiceServlet" method="GET" class="search-form" id="weatherForm">
                <input type="hidden" name="action" value="weather">
                <input type="text" name="locationName" id="locationName" placeholder="Location name"
                       value="<%= request.getAttribute("locationName") != null ? request.getAttribute("locationName") : "" %>"
                       style="min-width: 150px;">
                <input type="text" name="latitude" id="latitude" placeholder="Latitude (e.g., 40.7128)"
                       value="<%= request.getAttribute("latitude") != null ? request.getAttribute("latitude") : "" %>"
                       style="width: 140px;">
                <input type="text" name="longitude" id="longitude" placeholder="Longitude (e.g., -74.006)"
                       value="<%= request.getAttribute("longitude") != null ? request.getAttribute("longitude") : "" %>"
                       style="width: 140px;">
                <button type="submit">&#9925; Get Forecast</button>
            </form>

            <%
                List<String[]> weatherResults = (List<String[]>) request.getAttribute("weatherResults");
                if (weatherResults != null && !weatherResults.isEmpty()) {
                    String locName = (String) request.getAttribute("locationName");
            %>
                <p style="color: #0077b6; font-weight: 600; margin-bottom: 15px;">
                    Weather forecast for <%= locName %>
                </p>
                <div style="overflow-x: auto;">
                    <table class="weather-table">
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>Temp</th>
                                <th>Humidity</th>
                                <th>Weather</th>
                                <th>Precipitation</th>
                                <th>Wind</th>
                                <th>Cloud Cover</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (String[] entry : weatherResults) { %>
                            <tr>
                                <td><strong><%= entry[0] %></strong></td>
                                <td><%= entry[1] %></td>
                                <td><%= entry[2] %></td>
                                <td><%= entry[3] %></td>
                                <td><%= entry[4] %></td>
                                <td><%= entry[5] %></td>
                                <td><%= entry[6] %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>Smart Grocery Inventory Management System &copy; 2026 | Enterprise-Wide Computing</p>
    </footer>

    <script>
        function setLocation(name, lat, lon) {
            document.getElementById('locationName').value = name;
            document.getElementById('latitude').value = lat;
            document.getElementById('longitude').value = lon;
            document.getElementById('weatherForm').submit();
        }
    </script>

</body>
</html>
