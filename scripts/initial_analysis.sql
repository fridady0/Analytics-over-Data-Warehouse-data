/* ============================================================
PROJECT: Exploratory Data Analysis
AUTHOR: Vatsalya Prasad
DATA LAYER: Gold Layer (Data Warehouse)

OBJECTIVE
---------
Perform exploratory data analysis on the sales warehouse to:
• Understand dataset structure
• Explore customer and product dimensions
• Identify key business metrics
• Analyze sales distribution
• Rank products and customers by performance
============================================================ */


/* ============================================================
SECTION 1 — DATABASE METADATA EXPLORATION
Understand available tables and schema structure
============================================================ */

-- View all tables available in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;


-- View all columns for a specific table
-- Helpful for understanding schema attributes
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';



/* ============================================================
SECTION 2 — UNIQUE VALUE EXPLORATION
Identify distinct values to understand categorical dimensions
============================================================ */

-- Inspect unique sales values for sanity checking
SELECT DISTINCT
    sales_amount
FROM gold.fact_sales;


-- Explore countries customers belong to
SELECT DISTINCT
    country
FROM gold.dim_customers;


-- Explore product categories (high-level divisions)
SELECT DISTINCT
    category
FROM gold.dim_products;


-- Explore product hierarchy:
-- Category → Subcategory → Product
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY
    category,
    subcategory,
    product_name;



/* ============================================================
SECTION 3 — DATE RANGE ANALYSIS
Determine the time coverage of sales data
============================================================ */

-- Identify the earliest and latest order date
-- Calculate the total number of years of sales data
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;



/* ============================================================
SECTION 4 — CUSTOMER AGE ANALYSIS
Determine the age range of customers
============================================================ */

SELECT
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age,

    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age
FROM gold.dim_customers;



/* ============================================================
SECTION 5 — CORE BUSINESS METRICS
Calculate high-level KPIs for business performance
============================================================ */

-- Total revenue generated
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


-- Total quantity of items sold
SELECT
    SUM(quantity) AS total_items_sold
FROM gold.fact_sales;


-- Average selling price
SELECT
    AVG(price) AS average_selling_price
FROM gold.fact_sales;


-- Total number of orders
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


-- Total number of products available
SELECT
    COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;


-- Total number of registered customers
SELECT
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;


-- Number of customers who placed at least one order
SELECT
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;



/* ============================================================
SECTION 6 — CONSOLIDATED KPI REPORT
Combine key metrics into a single result set
============================================================ */

SELECT 'Total Sales' AS measure_name,
       SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT 'Total Quantity',
       SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT 'Average Selling Price',
       AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT 'Total Orders',
       COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT 'Total Products',
       COUNT(DISTINCT product_key)
FROM gold.dim_products

UNION ALL

SELECT 'Customers With Orders',
       COUNT(DISTINCT customer_key)
FROM gold.dim_customers;



/* ============================================================
SECTION 7 — MAGNITUDE ANALYSIS
Analyze how metrics vary across dimensions
============================================================ */

-- Customer distribution by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


-- Customer distribution by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


-- Product distribution by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;


-- Average product cost per category
SELECT
    category,
    AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;


-- Revenue contribution by product category
SELECT
    p.category,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Revenue generated by each customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue_by_customer
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue_by_customer DESC;


-- Distribution of sold items across countries
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;



/* ============================================================
SECTION 8 — PRODUCT PERFORMANCE RANKING
Identify best and worst performing products
============================================================ */

-- Top 5 products generating the highest revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- Bottom 5 products based on revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;



/* ============================================================
SECTION 9 — CUSTOMER REVENUE RANKING
Identify the highest revenue-generating customers
============================================================ */

SELECT *
FROM (
        SELECT
            c.customer_key,
            c.first_name,
            c.last_name,
            SUM(f.sales_amount) AS total_revenue,
            ROW_NUMBER() OVER (
                ORDER BY SUM(f.sales_amount) DESC
            ) AS rankings
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_customers c
            ON c.customer_key = f.customer_key
        GROUP BY
            c.customer_key,
            c.first_name,
            c.last_name
     ) t
WHERE rankings <= 10
ORDER BY total_revenue DESC;



/* ============================================================
SECTION 10 — RAW TABLE INSPECTION
Used for quick manual inspection of base tables
============================================================ */

SELECT * FROM gold.dim_customers;
SELECT * FROM gold.fact_sales;
SELECT * FROM gold.dim_products;