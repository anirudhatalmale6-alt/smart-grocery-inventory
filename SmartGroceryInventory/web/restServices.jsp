<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>REST Web Services - Smart Grocery Inventory</title>
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
        .endpoint-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 12px;
            border-left: 4px solid #2d6a4f;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
        }
        .endpoint-card .method {
            display: inline-block;
            background: #2d6a4f;
            color: white;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 700;
            font-family: monospace;
            margin-right: 10px;
        }
        .endpoint-card .url {
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 14px;
            color: #1b4332;
            font-weight: 600;
        }
        .endpoint-card .desc {
            color: #6c757d;
            font-size: 13px;
            width: 100%;
            margin-top: 5px;
        }
        .test-btn {
            padding: 6px 16px;
            background-color: #0077b6;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s;
        }
        .test-btn:hover {
            background-color: #005f8a;
            color: white;
        }
        .response-area {
            background: #1b4332;
            color: #d8f3dc;
            border-radius: 10px;
            padding: 20px;
            margin-top: 15px;
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 13px;
            max-height: 400px;
            overflow-y: auto;
            white-space: pre-wrap;
            word-break: break-word;
            display: none;
        }
        .response-area.visible {
            display: block;
        }
        .response-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .response-header .status {
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 4px;
        }
        .status-ok { background: #40916c; color: white; }
        .status-err { background: #e63946; color: white; }
        .arch-diagram {
            background: #f0f7ff;
            border: 2px solid #0077b6;
            border-radius: 12px;
            padding: 25px;
            margin: 20px 0;
            text-align: center;
        }
        .arch-diagram .layer {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 12px 20px;
            margin: 8px auto;
            max-width: 400px;
            font-weight: 600;
            font-size: 14px;
        }
        .arch-diagram .arrow {
            color: #0077b6;
            font-size: 20px;
            margin: 4px 0;
        }
        .arch-diagram .layer.highlight {
            border-color: #2d6a4f;
            background: #d8f3dc;
            color: #1b4332;
        }
        .input-row {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            align-items: center;
        }
        .input-row input {
            padding: 8px 12px;
            border: 2px solid #d8f3dc;
            border-radius: 6px;
            font-size: 13px;
            width: 80px;
        }
        .input-row input:focus {
            outline: none;
            border-color: #2d6a4f;
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
                <a href="WebServiceServlet">Web Services</a>
                <a href="restServices.jsp" class="active">REST API</a>
            </div>
        </div>
    </nav>

    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <h1>&#128268; REST Web Services API</h1>
            <p>Access grocery inventory data through RESTful web service endpoints. These services expose your application data as JSON for external applications to consume.</p>
        </div>

        <!-- Architecture Diagram -->
        <div class="service-section">
            <h2>&#127959; Service Architecture</h2>
            <p class="subtitle">How the REST web services fit into the application architecture.</p>

            <div class="arch-diagram">
                <div class="layer">&#128241; Mobile App (Kivy) / External Client</div>
                <div class="arrow">&#8595; HTTP Request / &#8593; JSON Response</div>
                <div class="layer highlight">&#128268; JAX-RS REST Web Services (api/*)</div>
                <div class="arrow">&#8595; &#8593;</div>
                <div class="layer">&#128188; EJB Session Facades (Business Logic)</div>
                <div class="arrow">&#8595; &#8593;</div>
                <div class="layer">&#128451; JPA Entities (Database Layer)</div>
                <div class="arrow">&#8595; &#8593;</div>
                <div class="layer">&#128206; Apache Derby Database</div>
            </div>
        </div>

        <!-- Grocery Items Endpoints -->
        <div class="service-section">
            <h2>&#127822; Grocery Items API</h2>
            <p class="subtitle">Endpoints to retrieve grocery item data from the inventory.</p>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/groceryitems</span>
                    <div class="desc">Returns all grocery items in the database as a JSON array.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/groceryitems', 'groceryResponse')">Test It</button>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/groceryitems/{id}</span>
                    <div class="desc">Returns a single grocery item by its ID.</div>
                </div>
                <div class="input-row">
                    <label>ID:</label>
                    <input type="number" id="groceryId" value="1" min="1">
                    <button class="test-btn" onclick="testEndpoint('api/groceryitems/' + document.getElementById('groceryId').value, 'groceryResponse')">Test It</button>
                </div>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/groceryitems/count</span>
                    <div class="desc">Returns the total number of grocery items.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/groceryitems/count', 'groceryResponse')">Test It</button>
            </div>

            <div class="response-area" id="groceryResponse"></div>
        </div>

        <!-- Suppliers Endpoints -->
        <div class="service-section">
            <h2>&#128666; Suppliers API</h2>
            <p class="subtitle">Endpoints to retrieve supplier information.</p>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/suppliers</span>
                    <div class="desc">Returns all suppliers as a JSON array.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/suppliers', 'supplierResponse')">Test It</button>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/suppliers/{id}</span>
                    <div class="desc">Returns a single supplier by their ID.</div>
                </div>
                <div class="input-row">
                    <label>ID:</label>
                    <input type="number" id="supplierId" value="1" min="1">
                    <button class="test-btn" onclick="testEndpoint('api/suppliers/' + document.getElementById('supplierId').value, 'supplierResponse')">Test It</button>
                </div>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/suppliers/count</span>
                    <div class="desc">Returns the total number of suppliers.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/suppliers/count', 'supplierResponse')">Test It</button>
            </div>

            <div class="response-area" id="supplierResponse"></div>
        </div>

        <!-- Categories Endpoints -->
        <div class="service-section">
            <h2>&#128193; Categories API</h2>
            <p class="subtitle">Endpoints to retrieve product category data.</p>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/categories</span>
                    <div class="desc">Returns all categories as a JSON array.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/categories', 'categoryResponse')">Test It</button>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/categories/{id}</span>
                    <div class="desc">Returns a single category by its ID.</div>
                </div>
                <div class="input-row">
                    <label>ID:</label>
                    <input type="number" id="categoryId" value="1" min="1">
                    <button class="test-btn" onclick="testEndpoint('api/categories/' + document.getElementById('categoryId').value, 'categoryResponse')">Test It</button>
                </div>
            </div>

            <div class="endpoint-card">
                <div>
                    <span class="method">GET</span>
                    <span class="url">/api/categories/count</span>
                    <div class="desc">Returns the total number of categories.</div>
                </div>
                <button class="test-btn" onclick="testEndpoint('api/categories/count', 'categoryResponse')">Test It</button>
            </div>

            <div class="response-area" id="categoryResponse"></div>
        </div>

    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>Smart Grocery Inventory Management System &copy; 2026 | Enterprise-Wide Computing</p>
    </footer>

    <script>
        function testEndpoint(url, responseAreaId) {
            var responseArea = document.getElementById(responseAreaId);
            responseArea.className = 'response-area visible';
            responseArea.textContent = 'Loading...';

            var xhr = new XMLHttpRequest();
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    var statusText = xhr.status + ' ' + xhr.statusText;
                    var statusClass = xhr.status === 200 ? 'status-ok' : 'status-err';
                    var header = 'Endpoint: ' + url + '\n'
                            + 'Status: ' + statusText + '\n'
                            + '──────────────────────────────────────\n';

                    var body = xhr.responseText;
                    // Try to format JSON
                    try {
                        var parsed = JSON.parse(body);
                        body = JSON.stringify(parsed, null, 2);
                    } catch (e) {
                        // Not JSON, show as-is
                    }

                    responseArea.textContent = header + body;
                }
            };
            xhr.send();
        }
    </script>

</body>
</html>
