-- =============================================================
-- Section 1 : Database Setup
-- Purpose   : Create the database for sales analysis.
-- =============================================================

CREATE DATABASE Sales;

-- =============================================================
-- Section 2 : Data Import Validation
-- Purpose   : Confirm that the sale table was imported correctly.
-- =============================================================

USE Sales;

SELECT COUNT(*) as total_record FROM sales_analysis;

DESCRIBE sales_analysis;

SELECT * FROM sales_analysis;

-- =============================================================
-- Section 3 : Overall Busisness Performance
-- Purpose   : Calculate key business KPIs
-- =============================================================

SELECT COUNT(*) as total_record,
	   COUNT(DISTINCT transaction_id) as total_orders,
       COUNT(DISTINCT customer_id) as total_customers,
       ROUND(SUM(total_sale),2) as total_sales,
       ROUND(SUM(profit),2) as total_profit,
       ROUND(SUM(quantity), 2) as total_quantity,
       ROUND(SUM(cogs), 2) as total_cogs,
       ROUND(AVG(total_sale),2) as average_order_value,
       ROUND(SUM(profit) / NULLIF(SUM(total_sale), 0) * 100,
       2) AS profit_margin_pct
FROM sales_analysis;

-- =============================================================
-- Section 4 : Monthly Sales and Profit Trend
-- Purpose   : Analyze performance month by month
-- =============================================================

SELECT 
	YEAR, MONTH, month_name,
	ROUND(SUM(total_sale), 2) as monthly_sale,
    ROUND(SUM(profit), 2) as monthly_profit,  
    COUNT(DISTINCT transaction_id) as total_orders
FROM sales_analysis
GROUP BY YEAR, MONTH, month_name
ORDER BY YEAR,MONTH;

-- =============================================================
-- Section 5 : Category Performance Analysis
-- Purpose   : Compare Sales and profit by category
-- =============================================================

SELECT
	category, 
    COUNT(DISTINCT transaction_id) as total_orders,
    SUM(quantity) as total_quantity_sold,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(total_sale), 0) * 100,
    2) AS profit_margin_pct
FROM sales_analysis
GROUP BY category
ORDER BY total_sales desc;    

-- =============================================================
-- Section 6 : Regional Sales Performance
-- Purpose   : Compare business performence by region
-- =============================================================

SELECT 
	region,
    COUNT(DISTINCT transaction_id) as total_orders,
    COUNT(DISTINCT customer_id) as total_customers,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit
FROM sales_analysis
GROUP BY region
ORDER BY total_sales DESC;

-- ==============================================================
-- Section 7 : Saled Channel Analysis
-- Purpose   : Compare Performance Across channels
-- ==============================================================

SELECT 
	sales_channel,
    COUNT(DISTINCT transaction_id) as total_orders,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(AVG(total_sale), 2) as average_order_value
FROM sales_analysis
GROUP BY sales_channel
ORDER BY total_sales DESC;

-- ===============================================================
-- Section 8 : Top 10 Product by Sales
-- Purpose   : Identify the highest-revenue products
-- ===============================================================

SELECT
	product, category,
    SUM(quantity) as total_quantity_sold,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit
FROM sales_analysis
GROUP BY product, category
ORDER BY total_sales DESC
LIMIT 10;

-- ===============================================================
-- Section 9 : Top 10 Product by Profit
-- Purpose   : Identify the most profitable products
-- ===============================================================

SELECT
	product, category,
    SUM(quantity) as total_quantity_sold,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit
FROM sales_analysis
GROUP BY product, category
ORDER BY total_profit DESC
LIMIT 10;

-- ===============================================================
-- Section 10 : Top 10 Customers by Sales
-- Purpose    : Identify the highest-value customers
-- ===============================================================

SELECT
	customer_id,
    COUNT(DISTINCT transaction_id) as total_oreder,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(AVG(total_sale), 2) average_order_value
FROM sales_analysis
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

-- ===============================================================
-- Section 11 : Payment Method Analysis
-- Purpose    : Analyze Sales by Payment Method
-- ===============================================================

SELECT 
	payment_method, 
    COUNT(DISTINCT transaction_id) as total_orders,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(AVG(total_sale), 2) as average_order_value
FROM sales_analysis
GROUP BY payment_method
ORDER BY total_sales DESC;

-- ===============================================================
-- Section 12 : Discount Impact Analysis
-- Purpose    : Analyze Sales and profit by discount level
-- ===============================================================

SELECT 
	CASE
		WHEN discount_pct = 0 THEN "No Discount"
        WHEN discount_pct <= 5 THEN "Low Discount (0-5%) "
        WHEN discount_pct <= 10 THEN "Medium Discount (5-10%)"
        ELSE "High Discount (Above 10%)"
	END as discount_level,
    
    COUNT(DISTINCT transaction_id) as total_orders,
    ROUND(SUM(discount_amount), 2) as total_discount,
    ROUND(SUM(total_sale), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit
FROM sales_analysis
GROUP BY discount_level
ORDER BY total_sales DESC;
