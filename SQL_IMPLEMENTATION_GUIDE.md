# SQL Implementation Guide

This guide explains how to set up and use the database schemas for the integration project.

## 📊 Database Files Overview

### Individual Database Schemas
1. **shoppo.sql** - Shoppo e-commerce database (customers, products, orders)
2. **lalaza.sql** - LaLaZa marketplace database (users, items, promotions)
3. **neverreach.sql** - NeverReach Express logistics database (shipments, deliveries)

### Integrated Schema
4. **global_schema.sql** - Unified global schema with data migration scripts

## 🗄️ Schema Structures

### Shoppo Database (shoppo_db)
**Tables:**
- `Customers` - Customer information
- `Products` - Product catalog with categories
- `Discounts` - Discount rules
- `Orders` - Order transactions
- `OrderDetails` - Order line items
- `Payments` - Payment records
- `Inventory_Stock` - Warehouse inventory

**Sample Data:** Includes 2 customers, 2 products, 2 orders

### LaLaZa Database (lalaza_db)
**Tables:**
- `Users` - User accounts
- `Address` - Multiple addresses per user
- `Categories` - Product categories
- `Items` - Product catalog
- `Purchases` - Purchase transactions
- `Cart` - Shopping cart items
- `Transactions` - Payment transactions
- `Promotions` - Promotion campaigns
- `PromoCodes` - Promo code details
- `UserPromotions` - User-specific promotions

**Sample Data:** Includes 2 users, 2 categories, 2 items, 2 purchases

### NeverReach Express Database (neverreach_db)
**Tables:**
- `Employees` - Employee records
- `Warehouses` - Warehouse locations
- `Shipments` - Shipment tracking
- `Packages` - Package details
- `Delivery_Tracking` - Real-time tracking updates
- `Delivery_Assignments` - Driver assignments
- `Vehicles` - Fleet management

**Sample Data:** Includes 2 employees, 1 warehouse, 1 shipment, 1 package

### Global Unified Schema (global_schema)
**Consolidated Tables (18 total):**

**User Management:**
- `users` - Unified customer/user table
- `customeraddresses` - Multiple addresses per user

**Product & Inventory:**
- `categories` - Product categories
- `products` - Unified product catalog
- `inventory` - Multi-warehouse inventory

**Orders & Payments:**
- `orders` - Unified order transactions
- `orderdetails` - Order line items
- `payments` - Payment records

**Promotions:**
- `promotions` - Promotion campaigns
- `promocodes` - Promo codes
- `customerpromotions` - User-promo relationships

**Logistics:**
- `employees` - Warehouse & delivery staff
- `warehouses` - Warehouse locations
- `shipments` - Shipment tracking
- `packages` - Package details
- `deliverytracking` - Tracking updates
- `deliveryassignments` - Delivery assignments
- `vehicles` - Fleet management

## 🚀 Quick Setup

### Option 1: Set Up Individual Databases (For Testing)

```sql
-- Create and populate Shoppo database
source shoppo.sql

-- Create and populate LaLaZa database
source lalaza.sql

-- Create and populate NeverReach database
source neverreach.sql
```

### Option 2: Set Up Global Integrated Schema (Recommended)

```sql
-- First, create individual databases (they're needed for migration)
source shoppo.sql
source lalaza.sql
source neverreach.sql

-- Then create and populate the global schema
CREATE DATABASE global_schema;
source global_schema.sql
```

## 📝 Detailed Setup Instructions

### Prerequisites
- MySQL 8.0+ or MariaDB 10.5+
- MySQL Workbench, phpMyAdmin, or command-line client
- Database user with CREATE, INSERT, UPDATE privileges

### Step 1: Create Individual Databases

```bash
# Using MySQL command line
mysql -u root -p

# Or specify user and password
mysql -u your_username -p your_password
```

Then execute:
```sql
-- Create Shoppo database
source /path/to/shoppo.sql;

-- Create LaLaZa database
source /path/to/lalaza.sql;

-- Create NeverReach database
source /path/to/neverreach.sql;

-- Verify databases were created
SHOW DATABASES;
```

### Step 2: Create Global Schema

```sql
-- Create global schema database
CREATE DATABASE global_schema;

-- Run the global schema script
source /path/to/global_schema.sql;

-- Verify tables were created
USE global_schema;
SHOW TABLES;
```

### Step 3: Verify Data Migration

```sql
-- Check user migration
SELECT COUNT(*) as total_users FROM global_schema.users;

-- Check product migration
SELECT COUNT(*) as total_products FROM global_schema.products;

-- Check order migration
SELECT COUNT(*) as total_orders FROM global_schema.orders;

-- Check shipment migration
SELECT COUNT(*) as total_shipments FROM global_schema.shipments;
```

## 🔍 Sample Queries

### Query Unified Customer Data
```sql
USE global_schema;

-- Get all users with their addresses
SELECT u.user_id, u.full_name, u.email, 
       ca.address, ca.additional_info
FROM users u
LEFT JOIN customeraddresses ca ON u.user_id = ca.user_id;
```

### Query Orders with Products
```sql
-- Get order details with product information
SELECT o.order_id, u.full_name, p.name as product_name,
       od.quantity, od.price_per_unit, 
       (od.quantity * od.price_per_unit) as line_total
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN orderdetails od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;
```

### Query Inventory Across Warehouses
```sql
-- Check product availability across warehouses
SELECT p.name, w.location, i.quantity_available, i.reorder_threshold
FROM products p
JOIN inventory i ON p.product_id = i.product_id
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
ORDER BY p.name, w.location;
```

### Track Package Delivery
```sql
-- Track package delivery status
SELECT pkg.package_id, o.order_id, u.full_name,
       s.status as shipment_status,
       dt.location, dt.status_note, dt.status_update_time
FROM packages pkg
JOIN orders o ON pkg.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN shipments s ON pkg.shipment_id = s.shipment_id
LEFT JOIN deliverytracking dt ON pkg.package_id = dt.package_id
ORDER BY dt.status_update_time DESC;
```

## 🔧 Troubleshooting

### Foreign Key Constraint Errors
If you get foreign key errors when running global_schema.sql:
```sql
-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS=0;
source global_schema.sql;
SET FOREIGN_KEY_CHECKS=1;
```

### Character Encoding Issues
Set proper character encoding:
```sql
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
```

### Permission Issues
Grant necessary permissions:
```sql
GRANT ALL PRIVILEGES ON shoppo_db.* TO 'your_username'@'localhost';
GRANT ALL PRIVILEGES ON lalaza_db.* TO 'your_username'@'localhost';
GRANT ALL PRIVILEGES ON neverreach_db.* TO 'your_username'@'localhost';
GRANT ALL PRIVILEGES ON global_schema.* TO 'your_username'@'localhost';
FLUSH PRIVILEGES;
```

## 📊 Database Diagram

The global schema includes:
- **18 tables** with proper relationships
- **25+ foreign key constraints** ensuring referential integrity
- **Composite primary keys** for junction tables
- **Normalized structure** (3NF) to reduce redundancy

Refer to `Parallel_and_Distributed_Databases_Project[2].pdf` for the complete ERD.

## 🎯 Key Integration Features

✅ **Unified User Management** - Customers and Users merged into single table  
✅ **Normalized Categories** - Consistent product categorization  
✅ **Multi-Warehouse Support** - Inventory tracking across locations  
✅ **Flexible Promotions** - Advanced promo code system  
✅ **Complete Logistics** - End-to-end delivery tracking  
✅ **Cross-System Links** - Orders linked to packages and shipments  

## 📚 Additional Resources

- **Full Documentation:** See `Parallel_and_Distributed_Databases_Project[2].pdf`
- **Schema Constraints:** Detailed in Section 4.3 of the report
- **Integration Issues:** Documented in Section 3 of the report

## 💡 Tips

1. **Always create individual databases first** before running global_schema.sql
2. **Use transactions** when modifying production data
3. **Regular backups** - Use `mysqldump` for backups
4. **Index optimization** - Add indexes on frequently queried columns
5. **Test queries** on development database first

## 🤝 Contributing

This is an academic project. For questions or improvements, contact the project team.

---

**Project Team:**  
- Abdulmajeed Abdullah Ahmed Mith Al-Ashwal (AIU22102303)  
- Samia Hassan Haron Hamid (AIU22102352)

**Course:** CCS 2253 - Parallel and Distributed Databases  
**Lecturer:** Dr. Mozaherul Hoque Abul Hasanat
