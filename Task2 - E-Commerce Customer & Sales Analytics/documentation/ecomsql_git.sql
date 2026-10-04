
-- =====================================================
-- E-COMMERCE CUSTOMER & SALES ANALYTICS
-- Cognorise Internship - Task 2
-- Database: ecommerce_analytics
-- MySQL 8.0
-- =====================================================

-- 1. DATABASE AND TABLE

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

DESCRIBE ecommerce_data;


-- 2. DATA VALIDATION

-- Total records and unique products
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS unique_products
FROM ecommerce_data;

-- Sample data
SELECT *
FROM ecommerce_data
LIMIT 10;

-- Missing values
SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL OR TRIM(product_id) = '') AS missing_product_id,
    SUM(product_name IS NULL OR TRIM(product_name) = '') AS missing_product_name,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(price IS NULL) AS missing_price,
    SUM(discount IS NULL) AS missing_discount,
    SUM(tax_rate IS NULL) AS missing_tax_rate,
    SUM(stock_level IS NULL) AS missing_stock,
    SUM(supplier_id IS NULL OR TRIM(supplier_id) = '') AS missing_supplier,
    SUM(customer_age_group IS NULL OR TRIM(customer_age_group) = '') AS missing_age_group,
    SUM(customer_location IS NULL OR TRIM(customer_location) = '') AS missing_location,
    SUM(customer_gender IS NULL OR TRIM(customer_gender) = '') AS missing_gender,
    SUM(shipping_cost IS NULL) AS missing_shipping_cost,
    SUM(shipping_method IS NULL OR TRIM(shipping_method) = '') AS missing_shipping_method,
    SUM(return_rate IS NULL) AS missing_return_rate,
    SUM(seasonality IS NULL OR TRIM(seasonality) = '') AS missing_seasonality,
    SUM(popularity_index IS NULL) AS missing_popularity
FROM ecommerce_data;

-- Invalid numeric values
SELECT
    SUM(price < 0) AS invalid_price,
    SUM(discount < 0 OR discount > 100) AS invalid_discount,
    SUM(tax_rate < 0 OR tax_rate > 100) AS invalid_tax_rate,
    SUM(stock_level < 0) AS invalid_stock,
    SUM(shipping_cost < 0) AS invalid_shipping_cost,
    SUM(return_rate < 0 OR return_rate > 100) AS invalid_return_rate,
    SUM(popularity_index < 0 OR popularity_index > 100) AS invalid_popularity
FROM ecommerce_data;


-- 3. OVERALL DATA ANALYSIS

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT category) AS total_categories,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(AVG(discount), 2) AS average_discount,
    ROUND(AVG(return_rate), 2) AS average_return_rate,
    ROUND(AVG(popularity_index), 2) AS average_popularity
FROM ecommerce_data;


-- 4. CATEGORY ANALYSIS

SELECT
    category,
    COUNT(*) AS record_count,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(AVG(return_rate), 2) AS avg_return_rate
FROM ecommerce_data
GROUP BY category
ORDER BY record_count DESC;


-- 5. CREATE ANALYSIS VIEW

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

    ROUND(price * (1 - discount / 100), 2) AS selling_price,

    ROUND(
        price * (1 - discount / 100) * tax_rate / 100,
        2
    ) AS tax_amount,

    ROUND(
        price * (1 - discount / 100) *
        (1 + tax_rate / 100) - shipping_cost,
        2
    ) AS estimated_net_value

FROM ecommerce_data;


-- 6. CATEGORY SALES ANALYSIS

SELECT
    category,
    COUNT(*) AS record_count,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(
        100 * SUM(selling_price) /
        NULLIF(SUM(SUM(selling_price)) OVER (), 0),
        2
    ) AS sales_share_percent
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY estimated_sales_value DESC;


-- 7. TOP 20 PRODUCTS

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


-- 8. CUSTOMER AGE GROUP ANALYSIS

SELECT
    customer_age_group,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY customer_age_group
ORDER BY estimated_sales_value DESC;


-- 9. CUSTOMER GENDER ANALYSIS

SELECT
    customer_gender,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY customer_gender
ORDER BY estimated_sales_value DESC;


-- 10. CUSTOMER LOCATION ANALYSIS

SELECT
    customer_location,
    COUNT(*) AS record_count,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM vw_ecommerce_analysis
GROUP BY customer_location
ORDER BY estimated_sales_value DESC;


-- 11. SHIPPING ANALYSIS

SELECT
    shipping_method,
    COUNT(*) AS record_count,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_cost,
    ROUND(AVG(return_rate), 2) AS avg_return_rate
FROM vw_ecommerce_analysis
GROUP BY shipping_method
ORDER BY avg_shipping_cost DESC;


-- 12. RETURN RATE BY CATEGORY

SELECT
    category,
    COUNT(*) AS record_count,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY avg_return_rate DESC;


-- 13. DISCOUNT ANALYSIS

SELECT
    discount,
    COUNT(*) AS record_count,
    ROUND(AVG(price), 2) AS avg_original_price,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount
FROM vw_ecommerce_analysis
GROUP BY discount
ORDER BY discount;


-- 14. SEASONALITY ANALYSIS

SELECT
    seasonality,
    COUNT(*) AS record_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(return_rate), 2) AS avg_return_rate
FROM vw_ecommerce_analysis
GROUP BY seasonality
ORDER BY estimated_sales_value DESC;


-- 15. POPULARITY BY CATEGORY

SELECT
    category,
    ROUND(AVG(popularity_index), 2) AS avg_popularity,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value
FROM vw_ecommerce_analysis
GROUP BY category
ORDER BY avg_popularity DESC;


-- 16. PRODUCT PERFORMANCE: HIGH RETURNS

SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    ROUND(AVG(return_rate), 2) AS avg_return_rate,
    ROUND(SUM(selling_price), 2) AS estimated_sales_value,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM vw_ecommerce_analysis
GROUP BY product_id
HAVING AVG(return_rate) >= 10
ORDER BY avg_return_rate DESC
LIMIT 20;


-- 17. POWER BI DATA VIEW

CREATE OR REPLACE VIEW vw_powerbi_ecommerce AS
SELECT *
FROM vw_ecommerce_analysis;


-- 18. FINAL VALIDATION

SELECT COUNT(*) AS powerbi_view_records
FROM vw_powerbi_ecommerce;