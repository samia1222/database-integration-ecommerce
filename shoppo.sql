CREATE DATABASE shoppo_db;
USE shoppo_db;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    home_address TEXT
);

CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY,
    discount_amount DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    product_id INT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    weight_kg DECIMAL(6,2),
    product_category VARCHAR(50),
    base_price DECIMAL(10,2),
    discount_id INT,
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    total_weight DECIMAL(6,2),
    shipping_cost DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    paid_date DATE,
    total_paid DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Inventory_Stock (
    product_id INT,
    warehouse_id INT,
    quantity_available INT,
    reorder_threshold INT,
    PRIMARY KEY (product_id, warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- Insertion DATA

USE shoppo_db;

INSERT INTO Customers VALUES
(1, 'Alice Smith', 'alice@example.com', '1234567890', '123 Maple Street'),
(2, 'Bob Johnson', 'bob@example.com', '0987654321', '456 Oak Avenue');

INSERT INTO Discounts VALUES
(1, 10.00, NULL, NULL, '2025-01-01', '2025-12-31');

INSERT INTO Products VALUES
(101, 'Wireless Mouse', 'Ergonomic mouse', 0.25, 'Electronics', 25.00, 1),
(102, 'Laptop Stand', 'Aluminum stand', 1.5, 'Accessories', 45.00, NULL);

INSERT INTO Orders VALUES
(1001, 1, '2025-06-20', 70.00, 1.75, 5.00),
(1002, 2, '2025-06-21', 25.00, 0.25, 3.00);

INSERT INTO OrderDetails VALUES
(5001, 1001, 101, 2, 25.00),
(5002, 1001, 102, 1, 45.00);

INSERT INTO Payments VALUES
(3001, 1001, 'Credit Card', '2025-06-20', 75.00),
(3002, 1002, 'PayPal', '2025-06-21', 28.00);

INSERT INTO Inventory_Stock VALUES
(101, 1, 50, 10),
(102, 1, 30, 5);
