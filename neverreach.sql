CREATE DATABASE neverreach_db;
USE neverreach_db;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100),
    capacity INT,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    origin_warehouse_id INT,
    destination_warehouse_id INT,
    address TEXT,
    departure_time DATETIME,
    arrival_time DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (origin_warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (destination_warehouse_id) REFERENCES Warehouses(warehouse_id)
);

CREATE TABLE Packages (
    package_id INT PRIMARY KEY,
    shipment_id INT,
    order_id INT,
    weight DECIMAL(6,2),
    dimensions VARCHAR(100),
    fragile_flag TINYINT(1),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id)
    -- order_id is assumed to reference external Shoppo
);

CREATE TABLE Delivery_Tracking (
    tracking_id INT PRIMARY KEY,
    package_id INT,
    status_update_time DATETIME,
    location VARCHAR(100),
    status_note TEXT,
    FOREIGN KEY (package_id) REFERENCES Packages(package_id)
);

CREATE TABLE Delivery_Assignments (
    assignment_id INT PRIMARY KEY,
    driver_id INT,
    package_id INT,
    assigned_date DATE,
    delivery_status VARCHAR(50),
    FOREIGN KEY (driver_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (package_id) REFERENCES Packages(package_id)
);

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,
    license_plate VARCHAR(50),
    type VARCHAR(50),
    capacity INT,
    assigned_driver_id INT,
    FOREIGN KEY (assigned_driver_id) REFERENCES Employees(employee_id)
);




-- Insertion DATA


USE neverreach_db;

INSERT INTO Employees VALUES
(1, 'Ethan Hunt', 'Driver', 'ethan@example.com', '1119998888'),
(2, 'Grace Liu', 'Warehouse Manager', 'grace@example.com', '2227776666');

INSERT INTO Warehouses VALUES
(1, 'Central Depot', 500, 2);

INSERT INTO Shipments VALUES
(701, 1, 1, '78 Pine Lane', '2025-06-20 09:00:00', '2025-06-20 12:00:00', 'In Transit');

INSERT INTO Packages VALUES
(801, 701, 1001, 1.75, '30x20x10 cm', 0);

INSERT INTO Delivery_Tracking VALUES
(901, 801, '2025-06-20 10:30:00', 'City Center', 'On the way');

INSERT INTO Delivery_Assignments VALUES
(1001, 1, 801, '2025-06-20', 'Assigned');

INSERT INTO Vehicles VALUES
(1101, 'ABC123', 'Van', 1000, 1);
