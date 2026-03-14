
# SQL Data Warehouse & Advanced Sales Analytics Project

## Overview

This project demonstrates the design and implementation of a **modern SQL-based data warehouse and analytics layer** using **Medallion Architecture**. The goal of the project is to simulate a real-world **data engineering and analytics workflow**, transforming raw operational data into structured analytical insights.

The project includes:

- Building a **multi-layer data warehouse**
- Cleaning and transforming raw data
- Creating **dimensional models**
- Performing **advanced SQL analytics**
- Developing **customer and product analytical reports**

The final output provides a **business-ready analytics layer** that enables data analysts, business teams, and BI dashboards to extract insights efficiently.

---

# Architecture

This project follows the **Medallion Architecture**, which organizes data into progressive layers of refinement.

```
Source Systems (CRM + ERP)
        │
        ▼
Bronze Layer (Raw Data)
        │
        ▼
Silver Layer (Cleaned & Transformed Data)
        │
        ▼
Gold Layer (Business Analytics & Reporting)
```

Each layer serves a different purpose in the data pipeline.

---

# Bronze Layer — Raw Data Ingestion

The **Bronze Layer** stores raw data ingested directly from source systems without transformation. This layer acts as the **single source of truth for raw data**.

### Source Systems

The project simulates two operational systems:

**CRM System**
- Customer information
- Product details
- Sales transactions

**ERP System**
- Additional customer information
- Product categories
- Location data

### Example Bronze Tables

```
crm_cust_info
crm_prd_info
crm_sales_details

erp_cust_az12
erp_loc_a101
erp_px_cat_g1v2
```

These tables preserve the original structure of incoming data.

---

# Silver Layer — Data Cleaning & Transformation

The **Silver Layer** transforms raw data into **clean, standardized, and reliable datasets**.

Data processing steps performed:

### Data Cleaning

- Removal of duplicate records
- Handling missing values
- Trimming whitespace
- Standardizing data formats
- Resolving inconsistent values
- Correcting invalid dates

### Data Validation

Several validation techniques were applied:

- Null checks
- Duplicate detection
- Referential integrity validation
- Data type corrections

### SQL Techniques Used

The transformation pipeline uses several SQL features:

- `ROW_NUMBER()` for duplicate detection
- `CASE` statements for conditional logic
- `TRIM()` for text cleaning
- `ISNULL()` for null handling
- Window functions
- Data standardization logic

A stored procedure was created to automate loading:

```
silver.load_silver
```

This procedure performs the **entire transformation pipeline** for the silver layer.

---

# Gold Layer — Analytical Data Model

The **Gold Layer** contains analytics-ready tables designed using **Dimensional Modeling** principles.

The goal is to make the data easy for analysts and BI tools to query.

The model follows a **Star Schema**.

### Fact Table

```
gold.fact_sales
```

Contains measurable business events such as sales transactions.

Example fields:

```
order_number
customer_key
product_key
order_date
sales_amount
quantity
price
```

### Dimension Tables

```
gold.dim_customers
gold.dim_products
```

These provide descriptive context for the fact table.

Example customer attributes:

```
customer_key
first_name
last_name
country
gender
birthdate
```

Example product attributes:

```
product_key
product_name
category
subcategory
cost
```

---

# Exploratory Data Analysis (EDA)

After building the warehouse, exploratory analysis was performed using SQL.

The EDA phase focused on understanding:

- Data distributions
- Key business metrics
- Customer demographics
- Product categories
- Time coverage of sales data

Example query:

```sql
SELECT DISTINCT country
FROM gold.dim_customers;
```

---

# Business Metrics Analysis

Key performance indicators were calculated to evaluate business performance.

### Metrics Calculated

- Total Sales
- Total Orders
- Total Quantity Sold
- Total Customers
- Total Products
- Average Selling Price

Example metric query:

```sql
SELECT
SUM(sales_amount) AS total_sales
FROM gold.fact_sales;
```

---

# Time-Based Analysis

Time-based analysis helps identify **sales trends and seasonality**.

Example monthly sales analysis:

```sql
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date);
```

---

# Cumulative Analysis

Cumulative analysis tracks **running totals of business metrics**.

Example:

```sql
SUM(total_sales)
OVER(PARTITION BY YEAR(order_date) ORDER BY order_date)
```

This allows monitoring **revenue growth over time**.

---

# Performance Analysis

Product performance was evaluated by comparing:

- Current sales
- Average product sales
- Previous year sales

Techniques used:

- Window Functions
- `LAG()`
- `PARTITION BY`

This helps identify:

- High-performing products
- Declining products
- Year-over-year changes

---

# Part-to-Whole Analysis

Part-to-whole analysis determines how much each category contributes to total revenue.

Formula:

```
Category Revenue / Total Revenue * 100
```

This helps identify **major revenue drivers**.

---

# Customer Segmentation

Customers were segmented based on **spending behavior and relationship duration**.

| Segment | Description |
|--------|-------------|
| VIP | High spending and long relationship |
| Regular | Moderate spending and long relationship |
| New | Recently acquired customers |

Segmentation helps businesses:

- target high-value customers
- design marketing campaigns
- improve customer retention

---

# Product Segmentation

Products were categorized based on revenue performance.

| Segment | Criteria |
|--------|----------|
| High Performer | Revenue > 50,000 |
| Mid Range | Revenue ≥ 10,000 |
| Low Performer | Revenue < 10,000 |

This helps identify:

- top-performing products
- underperforming inventory

---

# Customer Analytics Report

A reusable analytical view was created:

```
gold.customers_report
```

Key metrics include:

- total_orders
- total_sales
- avg_order_value
- avg_monthly_spend
- recency
- lifespan

This report can be used by **BI dashboards and marketing teams**.

---

# Product Analytics Report

Another analytical view was created:

```
gold.products_report
```

Metrics include:

- total_sales
- total_orders
- total_customers
- avg_selling_price
- avg_order_revenue
- avg_monthly_revenue
- product_segment

---

# Key Data Engineering Concepts Demonstrated

### Data Warehousing
- Star schema modeling
- Fact and dimension tables

### Data Transformation
- Data cleaning pipelines
- Standardization processes

### Analytical SQL
- Window functions
- Aggregations
- CTE pipelines
- Time-based analysis

### Business Analytics
- Customer segmentation
- Product performance analysis
- KPI generation
- Revenue contribution analysis

---

# Technologies Used

- SQL Server
- T-SQL
- Dimensional Modeling
- Medallion Architecture
- Window Functions
- Analytical SQL

---

# Project Structure

```
sql-data-warehouse-project
│
├── datasets
│
├── sql
│   ├── bronze_layer.sql
│   ├── silver_layer.sql
│   ├── gold_layer.sql
│   ├── exploratory_analysis.sql
│   ├── advanced_analysis.sql
│
├── reports
│   ├── customers_report.sql
│   └── products_report.sql
│
└── README.md
```

---

# Key Outcomes

- Built a **SQL-based data warehouse**
- Transformed raw data into **analytics-ready datasets**
- Extracted business insights using **advanced SQL**
- Created reusable **customer and product reports**

---

# Future Improvements

- Add profit and margin analysis
- Build Power BI dashboards
- Automate ETL pipelines
- Implement data quality monitoring

---

# Author

**Vatsalya Prasad**  
Computer Science Graduate | Aspiring Data Engineer / Data Analyst

GitHub:  
https://github.com/fridady0/Data-WareHouse-Project---Sql
