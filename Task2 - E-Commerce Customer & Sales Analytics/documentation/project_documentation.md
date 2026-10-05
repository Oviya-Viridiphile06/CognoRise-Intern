# 🛒 E-Commerce Customer & Sales Analytics

## 📌 Project Overview

The **E-Commerce Customer & Sales Analytics** project focuses on analyzing a large e-commerce dataset using **MySQL, Power BI, and Excel** to understand product performance, pricing patterns, customer segments, regional distribution, shipping costs, and return behavior.

The project uses SQL to clean, validate, transform, and aggregate data before connecting the analytical dataset to Power BI. An interactive three-page dashboard presents key performance indicators and business insights through visualizations and summary tables.

The analysis is designed to support data-driven decisions related to product strategy, pricing, customer segments, logistics, and operational performance.

---

## 🎯 Project Objectives

* Use SQL to extract, validate, and transform e-commerce product and customer-segment data.
* Calculate estimated sales value, discounted selling price, tax, and estimated net value.
* Analyze product and category performance using pricing, discounts, popularity, and return-rate metrics.
* Explore customer segments by age group, gender, and location.
* Examine shipping methods, shipping costs, and return-rate patterns.
* Build an interactive Power BI dashboard with three analytical pages.
* Present data-driven observations and recommendations to support business decisions.

---

## 🧰 Tools & Technologies

| Tool                   | Purpose                                                              |
| ---------------------- | -------------------------------------------------------------------- |
| **MySQL 8.0**          | Data validation, transformation, aggregation, and analytical queries |
| **MySQL Workbench**    | SQL development and database management                              |
| **Microsoft Power BI** | Interactive dashboards and data visualization                        |
| **Power Query**        | Data preparation and transformation where required                   |
| **Microsoft Excel**    | Dataset inspection and supporting analysis                           |
| **GitHub**             | Version control and project documentation                            |

---

## 📂 Dataset Description

The project uses the `diversified_ecommerce_dataset.csv` dataset containing **1,000,000 records and 16 columns**.

### Dataset columns

| Column               | Description                                    |
| -------------------- | ---------------------------------------------- |
| `product_id`         | Unique product identifier at the product level |
| `product_name`       | Name of the product                            |
| `category`           | Product category                               |
| `price`              | Original product price                         |
| `discount`           | Discount percentage                            |
| `tax_rate`           | Applicable tax percentage                      |
| `stock_level`        | Available stock level                          |
| `supplier_id`        | Supplier identifier                            |
| `customer_age_group` | Customer age segment                           |
| `customer_location`  | Customer location                              |
| `customer_gender`    | Customer gender segment                        |
| `shipping_cost`      | Shipping cost associated with the record       |
| `shipping_method`    | Shipping method                                |
| `return_rate`        | Product or record-level return-rate value      |
| `seasonality`        | Seasonal classification                        |
| `popularity_index`   | Product popularity indicator                   |

**Dataset considerations**

* The dataset contains repeated product IDs across records.
* The available columns do not include explicit order IDs, customer IDs, transaction dates, quantities sold, or product costs.
* Therefore, the analysis uses estimated sales value and record-level measures rather than claiming actual transaction revenue, order volume, customer retention, or profit.
* The dataset supports customer-segment comparisons, but it does not support identifying individual new and repeat customers.

---

## 🗄️ SQL Data Preparation & Analysis

The data was imported into MySQL under the database `ecommerce_analytics`, using the table `ecommerce_data`.

### 1. Data validation

SQL was used to inspect the imported dataset and verify its structure and quality.

Key validation steps included:

* Checking the total number of records.
* Reviewing sample rows and column structure.
* Checking missing values across the dataset.
* Inspecting distinct product IDs and category distribution.
* Reviewing pricing, discounts, tax rates, shipping costs, and return rates.
* Identifying potential duplicate records and repeated product identifiers.

The missing-value checks returned **zero missing values** for the checked columns.

### 2. Data transformation

A SQL analytical view was created to calculate derived pricing and value metrics.

| Metric              | Formula                                      |
| ------------------- | -------------------------------------------- |
| Discount Amount     | `price * discount / 100`                     |
| Selling Price       | `price - discount_amount`                    |
| Tax Amount          | `selling_price * tax_rate / 100`             |
| Estimated Net Value | `selling_price + tax_amount - shipping_cost` |

These calculations were used to create the analytical view `vw_ecommerce_analysis`.

A second view, `vw_powerbi_ecommerce`, was created as the prepared dataset for Power BI.

### 3. Product-level aggregation

A separate `product_performance` table was created to summarize product-level metrics, including:

* Product record count
* Average price
* Average discount
* Estimated sales value
* Average return rate
* Average shipping cost
* Average popularity index
* Average estimated net value

The aggregation uses product identifiers to consolidate repeated product records.

### 4. Analytical SQL queries

SQL queries were used to examine:

* Estimated sales value by category and location
* Product-level estimated sales performance
* Average discounts and selling prices
* Customer age-group and gender distributions
* Shipping cost by shipping method
* Return-rate patterns by location and category
* Seasonal product patterns
* Product popularity and stock levels

---

# 📊 Power BI Dashboard

The Power BI report contains **three pages**, each focusing on a different analytical perspective.

## 📄 Page 1: Executive Overview

<div align="center">
  <img src="images/Executive Overview.png" alt="Executive Overview" width="85%" />
  <br/>
  <ins><b>Executive Overview</b></ins>
</div>

The Executive Overview provides a high-level summary of the e-commerce dataset and its key performance indicators.

### Key focus areas

* Overall estimated sales value
* Product and category distribution
* Pricing and discount performance
* Estimated net value
* High-level comparisons across available business dimensions

### Purpose

This page provides a quick overview of the dataset and helps users identify important performance patterns before exploring product-level and customer-regional details.

---

## 📄 Page 2: Product Performance

<div align="center">
  <img src="images/Product Performance.png" alt="Product Performance.png" width="85%" />
  <br/>
  <ins><b>Product Performance</b></ins>
</div>


The Product Performance page focuses on understanding how products and categories differ in estimated value, pricing, popularity, and return behavior.

### Key focus areas

* Estimated sales value by product and category
* Product-level performance comparisons
* Price and discount patterns
* Popularity index analysis
* Return-rate comparisons
* Product-level summary metrics

### Purpose

This page helps identify products and categories with comparatively high estimated sales value, understand discount patterns, and investigate products with elevated return rates.

It supports product assortment and pricing discussions using the available product-level data.

---

## 📄 Page 3: Customer & Regional Insights

<div align="center">
  <img src="images/Customer & Regional Insights.png" alt="Customer & Regional Insights" width="85%" />
  <br/>
  <ins><b>Customer & Regional Insights</b></ins>
</div>

The Customer & Regional Insights page examines customer segments, geographic distribution, and shipping-related patterns.

### Visuals included

| Visualization                         | Analytical purpose                                             |
| ------------------------------------- | -------------------------------------------------------------- |
| Estimated Sales Value by Location     | Compare estimated value across customer locations              |
| Product Records by Customer Age Group | Understand the distribution of records across age segments     |
| Shipping Cost by Shipping Method      | Compare shipping costs across delivery methods                 |
| Return Rate by Customer Location      | Examine location-level return-rate patterns                    |
| Shipping Cost vs Return Rate          | Explore the relationship between shipping cost and return rate |
| Location & Shipping Details           | Review location and shipping metrics in a detailed table       |

### Purpose

This page helps explore how customer segments, locations, shipping methods, and return behavior vary across the dataset.

The shipping-cost and return-rate comparison can be used to identify patterns for further investigation. It does not, by itself, establish that shipping costs cause returns.

---

## 🔍 Key Analytical Observations

The SQL and Power BI analysis supports the following types of observations:

* **Category performance:** Compare categories using estimated sales value, product records, and pricing metrics.
* **Product performance:** Identify products with higher estimated value and examine their discounts, popularity, and return rates.
* **Customer segments:** Compare age groups and gender segments based on available records and estimated value.
* **Regional distribution:** Explore how estimated value and return rates vary by customer location.
* **Shipping patterns:** Compare shipping costs across methods and locations.
* **Return behavior:** Identify categories or locations with comparatively higher return-rate values.
* **Seasonality:** Examine seasonal classifications and their relationship with product performance.

These are analytical areas supported by the dataset. Specific numerical findings should be added only after confirming the corresponding Power BI visuals or SQL query results.

---

## 💡 Business Recommendations

Based on the available analytical dimensions, the following strategies can guide further investigation:

### 1. Improve product and category strategy

* Prioritize categories with comparatively higher estimated sales value.
* Review lower-performing products to understand their pricing, discount, and popularity patterns.
* Use product-level comparisons to support inventory and assortment decisions.

### 2. Review discount effectiveness

* Compare estimated sales value across discount levels.
* Identify products with high discounts but comparatively low estimated value.
* Evaluate whether discount strategies align with product performance.

### 3. Investigate return-rate patterns

* Review products and locations with higher return-rate values.
* Investigate product descriptions, quality, customer expectations, and delivery conditions where return rates are elevated.
* Monitor return behavior before making changes to product or logistics policies.

### 4. Optimize shipping decisions

* Compare shipping costs across available shipping methods.
* Investigate locations with relatively high shipping costs.
* Evaluate shipping options while considering delivery experience and return behavior.

### 5. Use customer-segment insights

* Compare age-group and gender distributions to understand the composition of the available records.
* Use segment-level patterns to guide future customer research and marketing analysis.
* Collect customer-level and transaction-level data to enable more precise customer behavior analysis.

---

## ⚠️ Limitations

The dataset does not contain several fields required for conventional transaction-level e-commerce analytics.

| Limitation                      | Impact                                                             |
| ------------------------------- | ------------------------------------------------------------------ |
| No order ID                     | Actual order volume and order frequency cannot be calculated       |
| No individual customer ID       | New vs. repeat customer analysis is not possible                   |
| No transaction date             | Monthly, quarterly, and year-over-year trends cannot be calculated |
| No quantity sold                | Units sold and conventional revenue calculations are unavailable   |
| No product cost or profit field | Actual profit and profit margin cannot be calculated               |
| Repeated product IDs            | Product records must be distinguished from unique products         |

The estimated sales value used in this project is calculated from the available product pricing and discount fields across records. It should not be interpreted as verified transaction revenue.

Similarly, estimated net value is a derived measure based on selling price, tax, and shipping cost. It is not equivalent to accounting profit.

---

## 📁 Project Structure

```text
Task2-E-Commerce-Customer-Sales-Analytics/
│
├── documentation/
│   ├── project_documentation.md
│   └── sql_queries.sql
│
├── images/
│   ├── executive_overview.png
│   ├── product_performance.png
│   └── customer_regional_insights.png
│
├── powerbi/
│   └── Ecommerce_Customer_Sales_Analytics.pbix
│
├── dataset/
│   └── diversified_ecommerce_dataset.csv
│
└── README.md
```

The dataset and Power BI file can be excluded from the repository if they are too large or subject to sharing restrictions. The SQL script and dashboard screenshots provide a lightweight record of the analysis.

---

## 🚀 Project Outcome

This project demonstrates an end-to-end analytical workflow involving:

* Large-dataset inspection and validation using MySQL
* SQL-based data transformation and aggregation
* Creation of analytical views for reporting
* Product, customer-segment, regional, and shipping analysis
* Development of a three-page interactive Power BI dashboard
* Communication of analytical observations and practical business recommendations

The project provides a foundation for more advanced e-commerce analytics when transaction-level, customer-level, and profitability data become available.

---

**Project:** E-Commerce Customer & Sales Analytics
**Internship:** Cognorise
**Tools:** MySQL, Power BI, Excel
**Focus:** SQL Analytics | Data Visualization | Business Intelligence
