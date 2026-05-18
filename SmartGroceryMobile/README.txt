Smart Grocery Mobile Interface Project

Purpose:
This Kivy mobile interface reads Smart Grocery Inventory data from the REST web service created in the previous assignment.

Features:
- Three tabs: Grocery Items, Suppliers, Categories
- Load All: fetches all records from the REST endpoint
- Get Count: retrieves the total number of records
- Find by ID: looks up a single record by its ID
- Professional card-based display with color coding
- Configurable server URL

How to run:
1. Open NetBeans.
2. Run the SmartGroceryInventory project on GlassFish.
3. Confirm this REST endpoint works in a browser:
   http://localhost:8080/SmartGroceryInventory/api/groceryitems
4. Open Command Prompt.
5. Go to this folder.
6. Run:
   pip install kivy
   python SmartGroceryMobile.py
7. When the Kivy window opens, use the tabs and buttons to browse data.

REST Endpoints Used:
  GET /api/groceryitems       - All grocery items
  GET /api/groceryitems/{id}  - Single item by ID
  GET /api/groceryitems/count - Item count
  GET /api/suppliers          - All suppliers
  GET /api/suppliers/{id}     - Single supplier
  GET /api/suppliers/count    - Supplier count
  GET /api/categories         - All categories
  GET /api/categories/{id}    - Single category
  GET /api/categories/count   - Category count

Note:
The mobile app only reads data from the web service, which matches the assignment requirement.
