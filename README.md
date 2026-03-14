
# 📊 SQL Exploratory Data Analysis (EDA) & Business Analytics Project

## Overview

This project performs **Exploratory Data Analysis (EDA)** and **advanced analytical queries** using SQL on a sales dataset.

The objective of this project is to explore business data, analyze patterns, and extract insights using **analytical SQL techniques** such as:

- Aggregations
- Window functions
- Segmentation
- Time-series analysis
- Customer analytics
- Product performance analysis

The dataset used in this project comes from a previously built **data warehouse**, but the focus of this project is strictly **data analysis and business insights using SQL**.

This project demonstrates how SQL can be used as a powerful tool for **data exploration, business intelligence, and analytical reporting**.

---

# 🎯 Objectives

The main goals of this project are:

- Perform **initial exploratory analysis**
- Understand **business metrics and trends**
- Analyze **dimensions and measures**
- Perform **time-series analysis**
- Identify **high-performing products and customers**
- Create **analytical reports for business decision making**

---

# 📂 Dataset

The dataset consists of **sales transaction data** with supporting **customer and product information**.

### Fact Table

```
gold.fact_sales
```

Contains transactional sales records.

Example fields:

```
order_number
order_date
customer_key
product_key
sales_amount
quantity
price
```

### Dimension Tables

```
gold.dim_customers
gold.dim_products
```

These tables provide descriptive information about customers and products.

---

# 🧠 Key Analytical Concepts Used

## Dimensions

Dimensions are descriptive attributes used to categorize and group data.

Examples:

```
customer_key
customer_name
country
product_name
category
subcategory
order_date
```

Dimensions help answer questions like:

- Who bought the product?
- What product was sold?
- Which category generated revenue?
- When did sales occur?

---

## Measures

Measures are **numeric metrics** that represent business performance and can be aggregated.

Examples:

```
sales_amount
quantity
price
total_sales
total_orders
avg_order_value
```

Measures help answer questions like:

- How much revenue was generated?
- How many products were sold?
- What is the average selling price?

---

# 🔎 Initial Data Exploration

The first phase of analysis focuses on understanding the dataset.

Key analyses performed:

- Explore available tables and columns
- Identify distinct values
- Understand product hierarchy
- Identify customer distribution
- Analyze date ranges of sales data

Example query:

```sql
SELECT DISTINCT country
FROM gold.dim_customers;
```

This helps understand the geographic distribution of customers.

---

# 📊 Business Metrics Analysis

Core business metrics were calculated to evaluate overall performance.

Metrics calculated include:

- Total sales
- Total orders
- Total quantity sold
- Total number of customers
- Total number of products
- Average selling price

Example:

```sql
SELECT
SUM(sales_amount) AS total_sales
FROM gold.fact_sales;
```

These metrics provide a **high-level overview of business performance**.

---

# 📊 Dimension Analysis

Dimension analysis examines how metrics vary across different categories.

Examples of dimensions analyzed:

- Country
- Gender
- Product category
- Product subcategory

Example query:

```sql
SELECT
category,
COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category;
```

This helps identify **how data is distributed across business entities**.

---

# 📊 Measure Analysis

Measure analysis focuses on analyzing **numerical business metrics**.

Examples:

- Total revenue
- Quantity sold
- Average price
- Number of orders

Example:

```sql
SELECT
SUM(quantity) AS total_items_sold
FROM gold.fact_sales;
```

This helps understand **overall business performance**.

---

# 📈 Time-Series Analysis

Time-based analysis was performed to identify **sales trends over time**.

Example analysis:

- Sales by year
- Sales by month
- Customer activity over time

Example query:

```sql
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date);
```

This helps identify **seasonality and growth patterns**.

---

# 📈 Cumulative Analysis

Cumulative analysis tracks the **running total of business metrics over time**.

Example:

```sql
SUM(total_sales)
OVER(PARTITION BY YEAR(order_date) ORDER BY order_date)
```

This allows monitoring **revenue growth trends**.

---

# 📊 Performance Analysis

Product performance was analyzed by comparing:

- Current year sales
- Historical averages
- Previous year performance

SQL features used:

- Window functions
- `LAG()`
- `PARTITION BY`

This helps identify:

- High-performing products
- Declining products
- Sales growth patterns

---

# 📊 Part-to-Whole Analysis

This analysis determines how much each category contributes to total sales.

Formula:

```
Category Sales / Total Sales × 100
```

This helps identify **key revenue-driving product categories**.

---

# 📊 Data Segmentation

Segmentation divides data into meaningful groups for deeper insights.

## Product Segmentation

Products were grouped based on revenue performance.

| Segment | Criteria |
|--------|----------|
| High Performer | Revenue > 50,000 |
| Mid Range | Revenue ≥ 10,000 |
| Low Performer | Revenue < 10,000 |

---

## Customer Segmentation

Customers were grouped based on spending behavior and relationship duration.

| Segment | Description |
|--------|-------------|
| VIP | High spending + long customer relationship |
| Regular | Moderate spending |
| New | Recently acquired customers |

This helps identify **valuable customers and purchasing behavior**.

---

# 📊 Customer Analytics Report

A reusable analytical report was created:

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
- customer_segments

This report can be used for:

- customer analytics
- marketing campaigns
- retention strategies

---

# 📊 Product Analytics Report

A product analytics report was also created:

```
gold.report_products
```

Metrics include:

- total_sales
- total_orders
- total_customers
- avg_selling_price
- avg_order_revenue
- avg_monthly_revenue
- product_segment

This report helps evaluate **product performance and demand**.

---

# 🛠 Technologies Used

- SQL Server
- T-SQL
- Window Functions
- Common Table Expressions (CTEs)
- Analytical SQL

---

# 📂 Project Structure

```
sql-eda-sales-analysis
│
├── sql
│   ├── 01_initial_exploration.sql
│   ├── 02_dimension_measure_analysis.sql
│   ├── 03_advanced_analytics.sql
│
├── reports
│   ├── customers_report.sql
│   └── products_report.sql
│
└── README.md
```

---

# 🚀 Key Skills Demonstrated

This project demonstrates skills in:

- SQL data exploration
- Analytical SQL
- Business metrics analysis
- Window functions
- Segmentation analysis
- Time-series analysis
- Customer analytics
- Product performance analysis

---

# 👨‍💻 Author

**Vatsalya Prasad**

Computer Science Graduate | Aspiring Data Analyst / Data Engineer

GitHub:
https://github.com/fridady0/Data-WareHouse-Project---Sql
