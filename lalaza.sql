CREATE DATABASE lalaza_db;
USE lalaza_db;

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email_address VARCHAR(100),
    mobile VARCHAR(20),
    address TEXT
);

CREATE TABLE Address (
    address_id INT PRIMARY KEY,
    user_id INT,
    address TEXT,
    additional_info TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_title VARCHAR(100)
);

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    title VARCHAR(100),
    summary TEXT,
    weight DECIMAL(6,2),
    category_id INT,
    unit_price DECIMAL(10,2),
    quantity_available INT,
    shipping_fee DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    purchase_timestamp DATETIME,
    subtotal DECIMAL(10,2),
    delivery_charge DECIMAL(10,2),
    promo_code VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY,
    purchase_id INT,
    item_id INT,
    qty INT,
    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

CREATE TABLE Transactions (
    txn_id INT PRIMARY KEY,
    purchase_ref INT,
    payment_method VARCHAR(50),
    txn_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (purchase_ref) REFERENCES Purchases(purchase_id)
);

CREATE TABLE Promotions (
    promo_id INT PRIMARY KEY,
    promo_name VARCHAR(100),
    discount_type VARCHAR(20),
    discount_value DECIMAL(10,2)
);

CREATE TABLE PromoCodes (
    promo_code VARCHAR(50) PRIMARY KEY,
    promo_id INT,
    minimum_purchase DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    redeemed TINYINT(1),
    FOREIGN KEY (promo_id) REFERENCES Promotions(promo_id)
);

CREATE TABLE UserPromotions (
    user_id INT,
    promo_id INT,
    promo_code VARCHAR(50),
    redeemed TINYINT(1),
    PRIMARY KEY (user_id, promo_id, promo_code),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (promo_id) REFERENCES Promotions(promo_id),
    FOREIGN KEY (promo_code) REFERENCES PromoCodes(promo_code)
);



-- Insertion DATA


USE lalaza_db;

INSERT INTO Users VALUES
(1, 'Charlie Lee', 'charlie@example.com', '1112223333', '78 Pine Lane'),
(2, 'Dana White', 'dana@example.com', '4445556666', '90 Elm Blvd');

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books');

INSERT INTO Items VALUES
(201, 'Bluetooth Speaker', 'Portable speaker', 0.8, 1, 60.00, 100, 7.00),
(202, 'Hardcover Notebook', 'Lined journal', 0.5, 2, 15.00, 200, 2.00);

INSERT INTO Purchases VALUES
(301, 1, '2025-06-18 14:00:00', 60.00, 7.00, NULL),
(302, 2, '2025-06-19 10:30:00', 15.00, 2.00, NULL);

INSERT INTO Cart VALUES
(401, 301, 201, 1),
(402, 302, 202, 1);

INSERT INTO Transactions VALUES
(601, 301, 'Credit Card', '2025-06-18', 67.00),
(602, 302, 'PayPal', '2025-06-19', 17.00);

INSERT INTO Promotions VALUES
(1, 'Summer Sale', 'percentage', 10.00);

INSERT INTO PromoCodes VALUES
('SUMMER10', 1, 50.00, '2025-06-01', '2025-07-01', 0);

INSERT INTO UserPromotions VALUES
(1, 1, 'SUMMER10', 0);
