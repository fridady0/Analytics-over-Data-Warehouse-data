/* ============================================================
PROJECT: Sales Analytics using SQL
AUTHOR: Vatsalya Prasad
LAYER: Gold Layer (Data Warehouse)

PURPOSE
-------
This SQL script performs exploratory and analytical queries
on the sales data warehouse to extract business insights.

The analysis focuses on understanding:

• Sales trends over time
• Customer behaviour
• Product performance
• Category contribution to revenue
• Customer segmentation


---------------------------------------------------------------
IMPORTANT CONCEPTS USED IN THIS ANALYSIS
---------------------------------------------------------------

DIMENSIONS
----------
Dimensions are descriptive attributes used to group,
filter, or categorize data.

They answer questions like:
• WHO bought the product?
• WHAT product was sold?
• WHERE was it sold?
• WHEN was it sold?

Examples in this dataset:

Customer Dimension:
    customer_key
    first_name
    last_name
    country
    gender
    birthdate

Product Dimension:
    product_key
    product_name
    category
    subcategory
    cost

Date Dimension:
    order_date
    order_year
    order_month


MEASURES
--------
Measures are numeric values that can be aggregated
(SUM, AVG, COUNT, etc.) to analyze business performance.

They answer questions like:
• How much revenue was generated?
• How many products were sold?
• How many customers placed orders?

Examples in this dataset:

sales_amount   → revenue generated
quantity       → number of items sold
price          → selling price of product


FACT TABLE
----------
The fact table contains the measurable business events.

In this project:
    gold.fact_sales

Each row represents a sales transaction and contains
measures and foreign keys to dimensions.


FACT TABLE STRUCTURE

fact_sales
-----------
order_number
order_date
customer_key
product_key
sales_amount
quantity
price


DIMENSION TABLES

dim_customers
--------------
customer_key
first_name
last_name
country
gender
birthdate


dim_products
-------------
product_key
product_name
category
subcategory
cost


ANALYSIS FRAMEWORK USED
-----------------------

1. Initial Data Exploration
2. Dimension Analysis
3. Measure Analysis
4. Change Over Time Analysis
5. Cumulative Analysis
6. Performance Analysis
7. Part-to-Whole Analysis
8. Segmentation Analysis


============================================================ */

/* ============================================================
OBJECTIVE
---------
Perform advanced analytical queries to understand:

• Sales trends over time
• Cumulative revenue performance
• Product performance benchmarking
• Category contribution to overall revenue
• Product segmentation by cost
• Customer segmentation by spending behaviour

This analysis demonstrates advanced SQL techniques including:
• Window functions
• CTEs
• Running totals
• Year-over-year comparison
• Data segmentation
============================================================ */

/* ============================================================
SECTION 1 — CHANGE OVER TIME ANALYSIS
Analyze how business metrics evolve over time

Formula:
Aggregate(Measure) BY Date Dimension
============================================================ */

-- Analyze monthly sales performance including
-- revenue, customers, and quantity sold

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,

    -- Format date for easier human-readable reporting
    FORMAT(order_date , 'yyyy-MMM') AS order_date,

    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(quantity) AS total_quantity

FROM gold.fact_sales

WHERE order_date IS NOT NULL

GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    FORMAT(order_date , 'yyyy-MMM')

ORDER BY
    order_year,
    order_month,
    order_date;

/* ============================================================
SECTION 2 — CUMULATIVE ANALYSIS
Analyze how metrics accumulate over time

Formula:
Running Total = SUM(measure) OVER (ORDER BY date)
============================================================ */

-- Calculate monthly sales and cumulative running total

SELECT
    order_date,
    total_sales,

    -- Running cumulative sales within each year
    SUM(total_sales) OVER(
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
    ) AS running_total_sales

FROM
(
    SELECT 
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales

    WHERE order_date IS NOT NULL

    GROUP BY DATETRUNC(month, order_date)
) t;

/* ============================================================
SECTION 3 — PERFORMANCE ANALYSIS
Compare current performance against benchmarks

Two comparisons performed:
1. Sales vs Product Average
2. Year-over-Year (YoY) comparison
============================================================ */

WITH yearly_product_sales AS
(
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(sales_amount) AS current_sales

    FROM gold.fact_sales f

    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key

    WHERE f.order_date IS NOT NULL

    GROUP BY
        YEAR(f.order_date),
        p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,

    -- Average sales per product across years
    AVG(current_sales) OVER(
        PARTITION BY product_name
    ) AS avg_sales,

    -- Difference from product average
    current_sales -
    AVG(current_sales) OVER(
        PARTITION BY product_name
    ) AS diff_avg,

    -- Performance classification vs average
    CASE 
        WHEN current_sales -
             AVG(current_sales) OVER(PARTITION BY product_name) > 0
             THEN 'Above Avg'

        WHEN current_sales -
             AVG(current_sales) OVER(PARTITION BY product_name) < 0
             THEN 'Below Avg'

        ELSE 'Average'
    END AS avg_change,



    /* ==============================
       Year-over-Year Analysis
       ============================== */

    -- Previous year's sales
    LAG(current_sales) OVER(
        PARTITION BY product_name
        ORDER BY order_year
    ) AS previous_year_sales,

    -- Sales difference from previous year
    current_sales -
    LAG(current_sales) OVER(
        PARTITION BY product_name
        ORDER BY order_year
    ) AS diff_sales,

    -- Performance classification vs previous year
    CASE
        WHEN current_sales -
             LAG(current_sales) OVER(
                PARTITION BY product_name
                ORDER BY order_year
             ) > 0
             THEN 'Increase'

        WHEN current_sales -
             LAG(current_sales) OVER(
                PARTITION BY product_name
                ORDER BY order_year
             ) < 0
             THEN 'Decrease'

        ELSE 'No Change'
    END AS yoy_change

FROM yearly_product_sales

ORDER BY
    product_name,
    order_year;



/* ============================================================
SECTION 4 — PART-TO-WHOLE ANALYSIS
Determine how much each category contributes to total revenue

Formula:
Category Revenue / Total Revenue * 100
============================================================ */

WITH category_sales AS
(
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales

    FROM gold.fact_sales f

    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key

    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Overall sales across all categories
    SUM(total_sales) OVER() AS overall_sales,

    -- Percentage contribution to total revenue
    CONCAT(
        ROUND(
            (CAST(total_sales AS FLOAT) /
             SUM(total_sales) OVER()) * 100,
        2),
        '%'
    ) AS percentage_total

FROM category_sales

ORDER BY total_sales DESC;



/* ============================================================
SECTION 5 — DATA SEGMENTATION
Group data into meaningful ranges or categories
============================================================ */

-- Segment products into cost ranges

WITH product_segments AS
(
    SELECT
        product_key,
        product_name,
        cost,

        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
            ELSE 'Above 1000'
        END AS cost_range

    FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products

FROM product_segments

GROUP BY cost_range

ORDER BY total_products DESC;



/* ============================================================
SECTION 6 — CUSTOMER SEGMENTATION
Classify customers based on spending behavior

Segments:
VIP      → Spending > 5000 and lifespan ≥ 12 months
Regular  → Spending ≤ 5000 and lifespan ≥ 12 months
New      → Lifespan < 12 months
============================================================ */

WITH customer_spending AS
(
    SELECT
        c.customer_key,

        SUM(f.sales_amount) AS total_spending,

        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,

        -- Customer lifecycle duration
        DATEDIFF(
            MONTH,
            MIN(f.order_date),
            MAX(f.order_date)
        ) AS lifespan

    FROM gold.fact_sales f

    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key

    GROUP BY c.customer_key
)

SELECT
    customer_segments,
    COUNT(customer_key) AS total_customers

FROM
(
    SELECT
        customer_key,

        CASE
            WHEN total_spending > 5000 AND lifespan > 12
                THEN 'VIP'

            WHEN total_spending <= 5000 AND lifespan >= 12
                THEN 'Regular'

            ELSE 'New'
        END AS customer_segments

    FROM customer_spending
) t

GROUP BY customer_segments

ORDER BY total_customers DESC;