# Database Integration Project: Shoppo, LaLaZa & NeverReach Express

A comprehensive database integration project that unifies three independent e-commerce and logistics systems into a single Global Conceptual Schema (GCS). This project demonstrates advanced database design principles, handling of heterogeneity issues, and schema consolidation strategies.

## 📊 Project Overview

This project integrates three separate relational database systems:
- **Shoppo** - E-commerce retailer system (products, orders, payments)
- **LaLaZa** - API-based online marketplace (users, promotions, shopping cart)
- **NeverReach Express** - Logistics and delivery tracking system (shipments, packages, delivery)

**Key Achievement:** Successfully resolved structural and semantic heterogeneity to create a normalized, scalable global schema supporting all business operations.

## 📁 Project Structure

```
├── Parallel_and_Distributed_Databases_Project[2].pdf    # Full project report
├── Parallel_and_Distributed_Databases_Project[2].docx   # Editable report
├── shoppo.sql                                           # Shoppo database schema
├── lalaza.sql                                           # LaLaZa database schema
├── neverreach.sql                                       # NeverReach Express schema
├── global_schema.sql                                    # Unified global schema
└── README.md                                            # This file
```

## 🎯 Project Objectives

1. **Translate ER models** to relational schemas for all three systems
2. **Identify integration issues** (structural and semantic heterogeneity)
3. **Design a Global Conceptual Schema** that unifies all systems
4. **Maintain referential integrity** across the integrated database
5. **Support cross-functional operations** and centralized analytics

## 🔍 Integration Challenges Addressed

### Structural Heterogeneity
- **Schema Design Conflicts** - Different table structures for similar concepts (Orders vs Purchases)
- **Key Strategy Differences** - Composite keys vs surrogate keys
- **Normalization Disparities** - Varying levels of normalization across systems
- **Implicit Relationships** - Unenforced foreign key constraints

### Semantic Heterogeneity
- **Naming Conflicts** - Customers vs Users, Orders vs Purchases
- **Attribute Synonyms** - phone_number vs mobile, base_price vs unit_price
- **Field Interpretation** - Different business meanings for similar fields
- **Temporal Variations** - Inconsistent timestamp naming conventions
- **Category Representation** - Plain text vs normalized category tables

## 🗄️ Global Schema Design

### Core Entities

**Customer & User Management:**
- Users
- Addresses

**Product & Inventory:**
- Categories
- Products
- Inventory

**Orders & Transactions:**
- Orders
- Order_Items
- Payments

**Promotions:**
- Promotions
- PromoCodes
- UserPromotions

**Logistics & Delivery:**
- Warehouses
- Employees
- Shipments
- Packages
- Delivery_Tracking
- Delivery_Assignments
- Vehicles

### Key Design Decisions

1. **Entity Unification** - Merged Customers/Users into single Users entity
2. **Normalization** - Created Categories table for product classification
3. **Address Separation** - Multi-address support via Addresses table
4. **Promotion Integration** - Preserved LaLaZa's flexible promotion system
5. **Standardized Naming** - Consistent attribute names across all tables
6. **Foreign Key Enforcement** - Explicit referential integrity constraints

## 🛠️ Technologies & Concepts

- **Relational Database Design**
- **Database Integration Techniques**
- **Schema Normalization (3NF)**
- **Foreign Key Constraints**
- **ER-to-Relational Mapping**
- **Heterogeneity Resolution**

## 📈 Database Schema Files

### Individual Schemas
- `shoppo.sql` - Original Shoppo database structure
- `lalaza.sql` - Original LaLaZa database structure  
- `neverreach.sql` - Original NeverReach Express structure

### Integrated Schema
- `global_schema.sql` - Complete unified schema with all constraints

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0+ or PostgreSQL 12+
- Database client (MySQL Workbench, pgAdmin, or DBeaver)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/YOUR-USERNAME/REPO-NAME.git
cd REPO-NAME
```

2. **Create database**
```sql
CREATE DATABASE integrated_ecommerce;
USE integrated_ecommerce;
```

3. **Import global schema**
```bash
mysql -u username -p integrated_ecommerce < global_schema.sql
```

Or for individual schemas:
```bash
mysql -u username -p shoppo_db < shoppo.sql
mysql -u username -p lalaza_db < lalaza.sql
mysql -u username -p neverreach_db < neverreach.sql
```

## 📊 Key Features

✅ Unified customer/user management across platforms  
✅ Centralized product catalog with normalized categories  
✅ Integrated order processing system  
✅ Flexible promotion and discount management  
✅ Complete logistics and delivery tracking  
✅ Multi-warehouse inventory management  
✅ Cross-system referential integrity  

## 🎓 Academic Context

**Course:** CCS 2253 - Parallel and Distributed Databases  
**Institution:** School of Computing and Informatics  
**Semester:** 2 - 2024/2025  
**Lecturer:** Dr. Mozaherul Hoque Abul Hasanat  

**Team Members:**
- Abdulmajeed Abdullah Ahmed Mith Al-Ashwal (AIU22102303)
- Samia Hassan Haron Hamid (AIU22102352)

## 📝 Documentation

For detailed information about:
- ER-to-Relational translation process
- Complete heterogeneity analysis
- Design decisions and justifications
- Key constraints and relationships

Please refer to `Parallel_and_Distributed_Databases_Project[2].pdf`

## 🔮 Future Enhancements

- Implement stored procedures for common operations
- Add triggers for automated inventory management
- Create views for cross-system reporting
- Develop data migration scripts from source systems
- Add indexing strategy for performance optimization

## 📄 License

This project is developed for academic purposes as part of the CCS 2253 course curriculum.

## 🙏 Acknowledgments

- Dr. Mozaherul Hoque Abul Hasanat for project guidance
- School of Computing and Informatics
- Course materials and database integration resources
