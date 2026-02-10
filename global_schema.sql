-- 1. Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

-- 2. Customer Addresses (FK → users)
CREATE TABLE customeraddresses (
    address_id INT PRIMARY KEY,
    user_id INT,
    address TEXT,
    additional_info TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 3. Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- 4. Products (FK → categories)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    weight_kg DECIMAL(6,2),
    category_id INT,
    unit_price DECIMAL(10,2),
    shipping_fee DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 5. Employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

-- 6. Warehouses (FK → employees)
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100),
    capacity INT,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- 7. Inventory (FK → products, warehouses)
CREATE TABLE inventory (
    product_id INT,
    warehouse_id INT,
    quantity_available INT,
    reorder_threshold INT,
    PRIMARY KEY (product_id, warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 8. Orders (FK → users)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    total_weight DECIMAL(6,2),
    shipping_cost DECIMAL(10,2),
    promo_code VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 9. Order Details (FK → orders, products)
CREATE TABLE orderdetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 10. Payments (FK → orders)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_date DATE,
    total_paid DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 11. Promotions
CREATE TABLE promotions (
    promo_id INT PRIMARY KEY,
    promo_name VARCHAR(100),
    discount_type VARCHAR(20),
    discount_value DECIMAL(10,2)
);

-- 12. Promo Codes (FK → promotions)
CREATE TABLE promocodes (
    promo_code VARCHAR(50) PRIMARY KEY,
    promo_id INT,
    minimum_purchase DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    redeemed TINYINT(1),
    FOREIGN KEY (promo_id) REFERENCES promotions(promo_id)
);

-- 13. Update Orders to link promo_code
ALTER TABLE orders
ADD FOREIGN KEY (promo_code) REFERENCES promocodes(promo_code);

-- 14. Customer Promotions (FK → users, promotions, promocodes)
CREATE TABLE customerpromotions (
    user_id INT,
    promo_id INT,
    promo_code VARCHAR(50),
    redeemed TINYINT(1),
    PRIMARY KEY (user_id, promo_id, promo_code),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (promo_id) REFERENCES promotions(promo_id),
    FOREIGN KEY (promo_code) REFERENCES promocodes(promo_code)
);

-- 15. Shipments (FK → warehouses x2)
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    origin_warehouse_id INT,
    destination_warehouse_id INT,
    address TEXT,
    departure_time DATETIME,
    arrival_time DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (origin_warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 16. Packages (FK → shipments, orders)
CREATE TABLE packages (
    package_id INT PRIMARY KEY,
    shipment_id INT,
    order_id INT,
    weight_kg DECIMAL(6,2),
    dimensions VARCHAR(100),
    fragile_flag TINYINT(1),
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 17. Delivery Tracking (FK → packages)
CREATE TABLE deliverytracking (
    tracking_id INT PRIMARY KEY,
    package_id INT,
    status_update_time DATETIME,
    location VARCHAR(100),
    status_note TEXT,
    FOREIGN KEY (package_id) REFERENCES packages(package_id)
);

-- 18. Delivery Assignments (FK → employees, packages)
CREATE TABLE deliveryassignments (
    assignment_id INT PRIMARY KEY,
    driver_id INT,
    package_id INT,
    assigned_date DATE,
    delivery_status VARCHAR(50),
    FOREIGN KEY (driver_id) REFERENCES employees(employee_id),
    FOREIGN KEY (package_id) REFERENCES packages(package_id)
);

-- 19. Vehicles (FK → employees)
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    license_plate VARCHAR(100),
    type VARCHAR(50),
    capacity INT,
    assigned_driver_id INT,
    FOREIGN KEY (assigned_driver_id) REFERENCES employees(employee_id)
);






-- Use the global schema
USE global_schema;

-- 1. USERS (Shoppo + LaLaZa)
INSERT IGNORE INTO users (user_id, full_name, email, phone_number)
SELECT customer_id, full_name, email, phone_number FROM shoppo_db.Customers;

INSERT IGNORE INTO users (user_id, full_name, email, phone_number)
SELECT user_id, name, email_address, mobile FROM lalaza_db.Users
WHERE user_id NOT IN (SELECT user_id FROM users);

-- 2. CUSTOMER ADDRESSES
INSERT IGNORE INTO customeraddresses (address_id, user_id, address, additional_info)
SELECT address_id, user_id, address, additional_info FROM lalaza_db.Address;

-- 3. CATEGORIES
INSERT IGNORE INTO categories (category_id, category_name)
SELECT category_id, category_title FROM lalaza_db.Categories;

-- 4. PRODUCTS (Shoppo + LaLaZa)
INSERT IGNORE INTO products (product_id, name, description, weight_kg, category_id, unit_price, shipping_fee)
SELECT product_id, name, description, weight_kg, NULL, base_price, NULL FROM shoppo_db.Products;

INSERT IGNORE INTO products (product_id, name, description, weight_kg, category_id, unit_price, shipping_fee)
SELECT item_id, title, summary, weight, category_id, unit_price, shipping_fee
FROM lalaza_db.Items
WHERE item_id NOT IN (SELECT product_id FROM products);

-- 5. EMPLOYEES
INSERT IGNORE INTO employees (employee_id, name, position, email, phone_number)
SELECT employee_id, name, position, email, phone_number FROM neverreach_db.Employees;

-- 6. WAREHOUSES (Real + From Shoppo)
INSERT IGNORE INTO warehouses (warehouse_id, location, capacity, manager_id)
SELECT warehouse_id, location, capacity, manager_id FROM neverreach_db.Warehouses;

INSERT IGNORE INTO warehouses (warehouse_id, location, capacity, manager_id)
SELECT DISTINCT warehouse_id, 'Imported from Shoppo', 100, NULL
FROM shoppo_db.Inventory_Stock
WHERE warehouse_id NOT IN (SELECT warehouse_id FROM warehouses);

-- 7. INVENTORY
INSERT IGNORE INTO inventory (product_id, warehouse_id, quantity_available, reorder_threshold)
SELECT product_id, warehouse_id, quantity_available, reorder_threshold
FROM shoppo_db.Inventory_Stock;

-- 8. PROMOTIONS
INSERT IGNORE INTO promotions (promo_id, promo_name, discount_type, discount_value)
SELECT promo_id, promo_name, discount_type, discount_value FROM lalaza_db.Promotions;

-- 9. PROMO CODES
INSERT IGNORE INTO promocodes (promo_code, promo_id, minimum_purchase, start_date, end_date, redeemed)
SELECT promo_code, promo_id, minimum_purchase, start_date, end_date, redeemed
FROM lalaza_db.PromoCodes;

-- 10. ORDERS
INSERT IGNORE INTO orders (order_id, user_id, order_date, total_amount, total_weight, shipping_cost, promo_code)
SELECT order_id, customer_id, order_date, total_amount, total_weight, shipping_cost, NULL
FROM shoppo_db.Orders;

-- 11. ORDER DETAILS
INSERT IGNORE INTO orderdetails (order_detail_id, order_id, product_id, quantity, price_per_unit)
SELECT order_detail_id, order_id, product_id, quantity, price_per_unit FROM shoppo_db.OrderDetails;

-- 12. PAYMENTS
INSERT IGNORE INTO payments (payment_id, order_id, payment_method, payment_date, total_paid)
SELECT payment_id, order_id, payment_method, paid_date, total_paid FROM shoppo_db.Payments;

-- 13. CUSTOMER PROMOTIONS
INSERT IGNORE INTO customerpromotions (user_id, promo_id, promo_code, redeemed)
SELECT user_id, promo_id, promo_code, redeemed FROM lalaza_db.UserPromotions;

-- 14. SHIPMENTS
INSERT IGNORE INTO shipments (shipment_id, origin_warehouse_id, destination_warehouse_id, address, departure_time, arrival_time, status)
SELECT shipment_id, origin_warehouse_id, destination_warehouse_id, address, departure_time, arrival_time, status
FROM neverreach_db.Shipments;

-- 15. PACKAGES
INSERT IGNORE INTO packages (package_id, shipment_id, order_id, weight_kg, dimensions, fragile_flag)
SELECT package_id, shipment_id, order_id, weight, dimensions, fragile_flag FROM neverreach_db.Packages;

-- 16. DELIVERY TRACKING
INSERT IGNORE INTO deliverytracking (tracking_id, package_id, status_update_time, location, status_note)
SELECT tracking_id, package_id, status_update_time, location, status_note FROM neverreach_db.Delivery_Tracking;

-- 17. DELIVERY ASSIGNMENTS
INSERT IGNORE INTO deliveryassignments (assignment_id, driver_id, package_id, assigned_date, delivery_status)
SELECT assignment_id, driver_id, package_id, assigned_date, delivery_status FROM neverreach_db.Delivery_Assignments;

-- 18. VEHICLES
INSERT IGNORE INTO vehicles (vehicle_id, license_plate, type, capacity, assigned_driver_id)
SELECT vehicle_id, license_plate, type, capacity, assigned_driver_id FROM neverreach_db.Vehicles;
