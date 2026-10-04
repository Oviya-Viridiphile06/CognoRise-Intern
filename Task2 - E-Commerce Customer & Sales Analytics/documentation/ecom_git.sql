-- ============================================================
-- E-COMMERCE CUSTOMER & SALES ANALYTICS
-- Cognorise Internship | Task 2
-- Database: ecommerce_analytics
-- Tool: MySQL 8.0
-- ============================================================


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

SELECT DATABASE();


-- ============================================================
-- 2. SOURCE TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS ecommerce_data (
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    discount INT,
    tax_rate INT,
    stock_level INT,
    supplier_id VARCHAR(20),
    customer_age_group VARCHAR(30),
    customer_location VARCHAR(100),
    customer_gender VARCHAR(30),
    shipping_cost DECIMAL(10,2),
    shipping_method VARCHAR(30),
    return_rate DECIMAL(5,2),
    seasonality VARCHAR(20),
    popularity_index INT
);

DESCRIBE ecommerce_data;


-- ============================================================
-- 3. CSV DATA IMPORT
-- ONE-TIME OPERATION
--
-- The import is commented out to prevent duplicate records.
-- Uncomment only when importing into an empty source table.
-- ============================================================

/*

LOAD DATA LOCAL INFILE
'C:/Users/oviya/OneDrive/PERSONAL/Project/Cognorise/Task2_E-Commerce/diversified_ecommerce_dataset.csv'
INTO TABLE ecommerce_data
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    product_id,
    product_name,
    category,
    price,
    discount,
    tax_rate,
    stock_level,
    supplier_id,
    customer_age_group,
    customer_location,
    customer_gender,
    shipping_cost,
    shipping_method,
    return_rate,
    seasonality,
    popularity_index
);

*/


-- ============================================================
-- 4. DATA OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT category) AS unique_categories
FROM ecommerce_data;

SELECT *
FROM ecommerce_data
LIMIT 10;


-- ============================================================
-- 5. DATA QUALITY CHECKS
-- ============================================================

-- Missing values

SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL OR TRIM(product_id) = '') AS missing_product_id,
    SUM(product_name IS NULL OR TRIM(product_name) = '') AS missing_product_name,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(price IS NULL) AS missing_price,
    SUM(discount IS NULL) AS missing_discount,
    SUM(tax_rate IS NULL) AS missing_tax_rate,
    SUM(stock_level IS NULL) AS missing_stock_level,
    SUM(supplier_id IS NULL OR TRIM(supplier_id) = '') AS missing_supplier_id,
    SUM(customer_age_group IS NULL OR TRIM(customer_age_group) = '') AS missing_age_group,
    SUM(customer_location IS NULL OR TRIM(customer_location) = '') AS missing_location,
    SUM(customer_gender IS NULL OR TRIM(customer_gender) = '') AS missing_gender,
    SUM(shipping_cost IS NULL) AS missing_shipping_cost,
    SUM(shipping_method IS NULL OR TRIM(shipping_method) = '') AS missing_shipping_method,
    SUM(return_rate IS NULL) AS missing_return_rate,
    SUM(seasonality IS NULL OR TRIM(seasonality) = '') AS missing_seasonality,
    SUM(popularity_index IS NULL) AS missing_popularity_index
FROM ecommerce_data;


-- Invalid numeric values

SELECT
    SUM(price < 0) AS invalid_price,
    SUM(discount < 0 OR discount > 100) AS invalid_discount,
    SUM(tax_rate < 0 OR tax_rate > 100) AS invalid_tax_rate,
    SUM(stock_level < 0) AS invalid_stock_level,
    SUM(shipping_cost < 0) AS invalid_shipping_cost,
    SUM(return_rate < 0 OR return_rate > 100) AS invalid_return_rate,
    SUM(popularity_index < 0 OR popularity_index > 100) AS invalid_popularity_index
FROM ecommerce_data;


-- Repeated product IDs
-- Repeated IDs do not necessarily mean duplicate records.

SELECT
    product_id,
    COUNT(*) AS record_count
FROM ecommerce_data
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 20;


-- ============================================================
-- 6. DESCRIPTIVE STATISTICS
-- ============================================================

-- Category distribution

SELECT
    category,
    COUNT(*) AS record_count
FROM ecommerce_data
GROUP BY category
ORDER BY record_count DESC;


-- Price analysis

SELECT
    ROUND(MIN(price), 2) AS minimum_price,
    ROUND(MAX(price), 2) AS maximum_price,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(SUM(price), 2) AS total_listed_value
FROM ecommerce_data;


-- Discount analysis

SELECT
    ROUND(MIN(discount), 2) AS minimum_discount,
    ROUND(MAX(discount), 2) AS maximum_discount,
    ROUND(AVG(discount), 2) AS average_discount
FROM ecommerce_data;


-- Return-rate analysis

SELECT
    ROUND(MIN(return_rate), 2) AS minimum_return_rate,
    ROUND(MAX(return_rate), 2) AS maximum_return_rate,
    ROUND(AVG(return_rate), 2) AS average_return_rate
FROM ecommerce_data;


-- ============================================================
-- 7. ANALYSIS VIEW AND CALCULATED FIELDS
-- ============================================================

CREATE OR REPLACE VIEW vw_ecommerce_analysis AS
SELECT
    product_id,
    product_name,
    category,
    price,
    discount,
    tax_rate,
    stock_level,
    supplier_id,
    customer_age_group,
    customer_location,
    customer_gender,
    shipping_cost,
    shipping_method,
    return_rate,
    seasonality,
    popularity_index,

    ROUND(price * discount / 100, 2) AS discount_amount,

    ROUND(
        price - (price * discount / 100),
        2
    ) AS selling_price,

    ROUND(
        (price - (price * discount / 100)) * tax_rate / 100,
        2
    ) AS tax_amount,

    ROUND(
        (price - (price * discount / 100))
        + ((price - (price * discount / 100)) * tax_rate / 100)
        - shipping_cost,
        2
    ) AS estimated_net_value

FROM ecommerce_data;


SELECT *
FROM vw_ecommerce_analysis
LIMIT 10;


-- ============================================================
-- 8. CATEGORY ANALYSIS
-- ============================================================

SELECT
    category,
    COUNT(*) AS record_count,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY estimated_sales_value DESC;


-- Estimated sales share by category

SELECT
    category,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(
        SUM(selling_price) * 100 /
        (SELECT SUM(selling_price)
         FROM vw_ecommerce_analysis),
        2
    ) AS sales_share_percent
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY estimated_sales_value DESC;


-- ============================================================
-- 9. PRODUCT PERFORMANCE ANALYSIS
-- ============================================================

-- Top products by estimated sales value

SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    COUNT(*) AS record_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(AVG(popularity_index), 2) AS avg_popularity
FROM vw_ecommerce_analysis
GROUP BY product_id
ORDER BY estimated_sales_value DESC
LIMIT 20;


-- Products with higher return rates

SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(AVG(discount), 2) AS avg_discount
FROM vw_ecommerce_analysis
GROUP BY product_id
HAVING AVG(return_rate) >= 10
ORDER BY estimated_sales_value DESC
LIMIT 20;


-- ============================================================
-- 10. CUSTOMER SEGMENT ANALYSIS
-- ============================================================

-- Customer age group

SELECT
    customer_age_group,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY customer_age_group
ORDER BY estimated_sales_value DESC;


-- Customer gender

SELECT
    customer_gender,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY customer_gender
ORDER BY estimated_sales_value DESC;


-- ============================================================
-- 11. REGIONAL ANALYSIS
-- ============================================================

SELECT
    customer_location,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM vw_ecommerce_analysis
GROUP BY customer_location
ORDER BY estimated_sales_value DESC;


-- ============================================================
-- 12. SHIPPING ANALYSIS
-- ============================================================

SELECT
    shipping_method,
    COUNT(*) AS record_count,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_cost,
    ROUND(AVG(return_rate), 2) AS avg_return_rate
FROM vw_ecommerce_analysis
GROUP BY shipping_method
ORDER BY avg_shipping_cost DESC;


-- ============================================================
-- 13. RETURN-RATE ANALYSIS
-- ============================================================

SELECT
    category,
    COUNT(*) AS record_count,
    ROUND(AVG(return_rate), 2) AS average_return_rate
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY average_return_rate DESC;


-- ============================================================
-- 14. DISCOUNT ANALYSIS
-- ============================================================

SELECT
    discount,
    COUNT(*) AS record_count,
    ROUND(AVG(price), 2) AS avg_original_price,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount
FROM vw_ecommerce_analysis
GROUP BY discount
ORDER BY discount;


-- ============================================================
-- 15. SEASONALITY ANALYSIS
-- ============================================================

SELECT
    seasonality,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate
FROM vw_ecommerce_analysis
GROUP BY seasonality
ORDER BY estimated_sales_value DESC;


-- ============================================================
-- 16. POPULARITY ANALYSIS
-- ============================================================

SELECT
    category,
    ROUND(AVG(popularity_index), 2) AS avg_popularity,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY avg_popularity DESC;


-- ============================================================
-- 17. POWER BI DATA VIEW
-- Main detailed view used by the Power BI report.
-- ============================================================

CREATE OR REPLACE VIEW vw_powerbi_ecommerce AS
SELECT
    product_id,
    product_name,
    category,
    price,
    discount,
    tax_rate,
    stock_level,
    supplier_id,
    customer_age_group,
    customer_location,
    customer_gender,
    shipping_cost,
    shipping_method,
    return_rate,
    seasonality,
    popularity_index,
    discount_amount,
    selling_price,
    tax_amount,
    estimated_net_value
FROM vw_ecommerce_analysis;


-- View validation

SELECT COUNT(*) AS view_records
FROM vw_powerbi_ecommerce;


-- ============================================================
-- 18. PRODUCT PERFORMANCE SUMMARY TABLE
-- This table was created and populated for product-level
-- analysis. Do not run the INSERT again on the existing table.
-- ============================================================

CREATE TABLE IF NOT EXISTS product_performance (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    record_count BIGINT,
    avg_price DECIMAL(12,2),
    avg_discount DECIMAL(10,2),
    estimated_sales_value DECIMAL(18,2),
    avg_return_rate DECIMAL(10,2),
    avg_shipping_cost DECIMAL(12,2),
    avg_popularity DECIMAL(10,2),
    avg_estimated_net_value DECIMAL(18,2)
);


/*
-- ONE-TIME INSERT ONLY
-- Already populated in the existing project.

INSERT INTO product_performance (
    product_id,
    product_name,
    category,
    record_count,
    avg_price,
    avg_discount,
    estimated_sales_value,
    avg_return_rate,
    avg_shipping_cost,
    avg_popularity,
    avg_estimated_net_value
)
SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    COUNT(*) AS record_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(AVG(popularity_index), 2) AS avg_popularity,
    ROUND(AVG(estimated_net_value), 2) AS avg_estimated_net_value
FROM vw_ecommerce_analysis
GROUP BY product_id;

*/


-- Summary table validation

SELECT COUNT(*) AS product_count
FROM product_performance;

SELECT
    COUNT(*) AS product_summary_rows,
    SUM(record_count) AS source_records_in_summary
FROM product_performance;


-- ============================================================
-- 19. FINAL VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS unique_products
FROM ecommerce_data;

SELECT
    COUNT(*) AS powerbi_view_records
FROM vw_powerbi_ecommerce;


-- ============================================================
-- END OF SQL ANALYSIS
-- E-Commerce Customer & Sales Analytics
-- ============================================================
