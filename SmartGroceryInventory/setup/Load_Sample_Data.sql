-- =====================================================
-- Smart Grocery Inventory Management System
-- Sample Data Script for Apache Derby
-- =====================================================

-- Categories
INSERT INTO CATEGORY (CATEGORY_NAME, AISLE_NUMBER, STORAGE_TYPE, SHELF_LIFE, DESCRIPTION, IS_PERISHABLE, MIN_STOCK_LEVEL)
VALUES ('Dairy Products', 5, 'Refrigerated', '2-4 Weeks', 'Includes milk, cheese, yogurt, butter, cream, and other dairy-based products that require refrigeration.', 'Yes', 20);

INSERT INTO CATEGORY (CATEGORY_NAME, AISLE_NUMBER, STORAGE_TYPE, SHELF_LIFE, DESCRIPTION, IS_PERISHABLE, MIN_STOCK_LEVEL)
VALUES ('Fresh Produce', 1, 'Refrigerated', '1 Week', 'Fresh fruits and vegetables sourced from local and regional farms.', 'Yes', 30);

INSERT INTO CATEGORY (CATEGORY_NAME, AISLE_NUMBER, STORAGE_TYPE, SHELF_LIFE, DESCRIPTION, IS_PERISHABLE, MIN_STOCK_LEVEL)
VALUES ('Canned Goods', 8, 'Room Temperature', 'Over 1 Year', 'Canned fruits, vegetables, soups, beans, and other preserved food items.', 'No', 15);

INSERT INTO CATEGORY (CATEGORY_NAME, AISLE_NUMBER, STORAGE_TYPE, SHELF_LIFE, DESCRIPTION, IS_PERISHABLE, MIN_STOCK_LEVEL)
VALUES ('Bakery', 3, 'Room Temperature', '1-3 Days', 'Fresh baked bread, rolls, pastries, cakes, and other bakery items.', 'Yes', 25);

INSERT INTO CATEGORY (CATEGORY_NAME, AISLE_NUMBER, STORAGE_TYPE, SHELF_LIFE, DESCRIPTION, IS_PERISHABLE, MIN_STOCK_LEVEL)
VALUES ('Frozen Foods', 10, 'Frozen', '3-6 Months', 'Frozen meals, vegetables, ice cream, and other frozen food products.', 'Yes', 20);

-- Suppliers
INSERT INTO SUPPLIER (SUPPLIER_NAME, CONTACT_PERSON, EMAIL, PHONE, ADDRESS, PRODUCTS_SUPPLIED, DELIVERY_SCHEDULE, NOTES)
VALUES ('Fresh Farm Distributors', 'John Smith', 'john@freshfarm.com', '(555) 123-4567', '123 Market Street, Suite 100, New York, NY 10001', 'Fresh Produce', 'Daily', 'Preferred supplier for organic produce. Delivers before 6 AM.');

INSERT INTO SUPPLIER (SUPPLIER_NAME, CONTACT_PERSON, EMAIL, PHONE, ADDRESS, PRODUCTS_SUPPLIED, DELIVERY_SCHEDULE, NOTES)
VALUES ('Dairy Direct Inc.', 'Sarah Johnson', 'sarah@dairydirect.com', '(555) 234-5678', '456 Farmland Avenue, Madison, WI 53703', 'Dairy Products', 'Twice a Week', 'Supplies organic and conventional dairy. Monday and Thursday deliveries.');

INSERT INTO SUPPLIER (SUPPLIER_NAME, CONTACT_PERSON, EMAIL, PHONE, ADDRESS, PRODUCTS_SUPPLIED, DELIVERY_SCHEDULE, NOTES)
VALUES ('Golden Grain Foods', 'Mike Wilson', 'mike@goldengrain.com', '(555) 345-6789', '789 Industrial Blvd, Chicago, IL 60601', 'Packaged Foods', 'Weekly', 'Bulk order discounts available for orders over $500.');

INSERT INTO SUPPLIER (SUPPLIER_NAME, CONTACT_PERSON, EMAIL, PHONE, ADDRESS, PRODUCTS_SUPPLIED, DELIVERY_SCHEDULE, NOTES)
VALUES ('Sunrise Bakery Supply', 'Lisa Chen', 'lisa@sunrisebakery.com', '(555) 456-7890', '321 Baker Lane, Portland, OR 97201', 'Bakery Items', 'Daily', 'Fresh baked goods delivered every morning at 5 AM.');

INSERT INTO SUPPLIER (SUPPLIER_NAME, CONTACT_PERSON, EMAIL, PHONE, ADDRESS, PRODUCTS_SUPPLIED, DELIVERY_SCHEDULE, NOTES)
VALUES ('Arctic Freeze Co.', 'Tom Brown', 'tom@arcticfreeze.com', '(555) 567-8901', '654 Cold Storage Road, Denver, CO 80201', 'Frozen Foods', 'Bi-Weekly', 'Refrigerated trucks ensure product quality during transport.');

-- Grocery Items
INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Organic Whole Milk', 'Horizon Organic', 'Dairy', 50, 4.99, '2025-06-15', 'Dairy Direct Inc.', 'Fresh organic whole milk from grass-fed cows. 1 gallon.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Sourdough Bread', 'Artisan Bakes', 'Bakery', 30, 5.49, '2025-04-05', 'Sunrise Bakery Supply', 'Freshly baked sourdough bread loaf. Made with natural starter.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Baby Spinach', 'Earthbound Farm', 'Fruits', 45, 3.99, '2025-04-08', 'Fresh Farm Distributors', 'Pre-washed organic baby spinach. 5 oz container.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Canned Black Beans', 'Goya', 'Canned', 100, 1.29, '2026-12-31', 'Golden Grain Foods', 'Premium quality canned black beans. 15.5 oz can.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Frozen Mixed Vegetables', 'Birds Eye', 'Frozen', 60, 2.79, '2026-03-15', 'Arctic Freeze Co.', 'Steam-fresh mixed vegetables. Corn, peas, carrots, and green beans. 10 oz bag.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Greek Yogurt', 'Chobani', 'Dairy', 75, 1.49, '2025-05-01', 'Dairy Direct Inc.', 'Non-fat plain Greek yogurt. High protein. 5.3 oz cup.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Banana Bunch', 'Dole', 'Fruits', 200, 0.69, '2025-04-10', 'Fresh Farm Distributors', 'Fresh yellow bananas. Price per pound.');

INSERT INTO GROCERY_ITEM (ITEM_NAME, BRAND, CATEGORY, QUANTITY, PRICE, EXPIRY_DATE, SUPPLIER, DESCRIPTION)
VALUES ('Chicken Noodle Soup', 'Campbell''s', 'Canned', 80, 1.99, '2027-01-15', 'Golden Grain Foods', 'Classic chicken noodle soup. 10.75 oz can.');
