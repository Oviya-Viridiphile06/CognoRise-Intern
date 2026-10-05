# 🛒 E-Commerce Customer & Sales Analytics

### MySQL | Power BI | DAX | Excel / CSV

> An end-to-end e-commerce sales analytics project focused on SQL-based data preparation, sales and product analysis, customer and regional insights, and interactive Power BI dashboard development.

## 📌 Project Overview

This project focuses on analyzing e-commerce data using **MySQL and Power BI** to understand sales performance, product and category behavior, customer segments, regional patterns, pricing, shipping, and returns.

The project follows an end-to-end analytics workflow:

> Raw Dataset → SQL Data Preparation → SQL Analysis → Analytical Dataset → Power BI Dashboard → Business Insights

---

## 🎯 Objectives

The main objectives of this project were to:

- Use SQL to extract, clean, transform, and analyze e-commerce data.
- Calculate sales-related and customer-level metrics available in the dataset.
- Analyze performance across **products, categories, regions, and seasonality**.
- Analyze customer segments using available customer attributes.
- Identify high-value products and investigate factors affecting their performance.
- Build an interactive **Power BI dashboard** using the SQL analytical dataset.
- Present findings and recommendations to support better sales and operational decisions.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL 8.0** | Data storage, transformation, validation, and analysis |
| **MySQL Workbench** | SQL query development and execution |
| **Power BI** | Interactive dashboard and data visualization |
| **Excel** | Dataset inspection and supporting data preparation |
| **GitHub** | Project documentation and version control |

---

## 📂 Dataset

The project uses a diversified e-commerce dataset containing:

- **1,000,000 records**
- **16 attributes**
- **9,000 unique product IDs**

### Dataset Attributes

- Product ID
- Product Name
- Category
- Price
- Discount
- Tax Rate
- Stock Level
- Supplier ID
- Customer Age Group
- Customer Location
- Customer Gender
- Shipping Cost
- Shipping Method
- Return Rate
- Seasonality
- Popularity Index

The dataset was imported into the MySQL database:

**Database:** `ecommerce_analytics`

**Main Table:** `ecommerce_data`

---

# 🔄 Data Preparation & SQL Analysis

## 1. Data Import & Validation

The raw CSV dataset was imported into MySQL and validated before analysis.

The validation process included:

- Checking the total number of records
- Checking missing values
- Checking unique product IDs
- Reviewing category distribution
- Validating price, discount, tax, and shipping fields
- Reviewing return-rate values
- Checking customer-segment fields

After validation, the dataset contained **1,000,000 records and 9,000 unique products**.

---

## 2. Data Transformation

SQL was used to transform the raw pricing and product information into an analytical dataset.

### Discount Amount

```text
Discount Amount = Price × Discount / 100
```

### Selling Price
```text
Selling Price = Price − Discount Amount
 ```

### Tax Amount
```text
Tax Amount = Selling Price × Tax Rate / 100
```

### Estimated Sales Value
```text
Estimated Sales Value = Selling Price
```

### Estimated Net Value
```text
Estimated Net Value = Selling Price + Tax Amount − Shipping Cost
```

These calculated fields were organized into SQL analytical views and used as the source for Power BI.

A separate `Product Performance` table was also created for product-level analysis.

---

# 📊 SQL Business Analysis

### 💰 Sales & Pricing Analysis
The analysis covered:
* Estimated Sales Value
* Selling Price
* Discount Amount
* Tax Amount
* Estimated Net Value
* Average price by category
* Discount patterns

This helped evaluate how pricing and discounts affect the estimated sales value of products.

---

### 📦 Product & Category Analysis
Product and category performance was analyzed using:
* Product-level estimated sales value
* Category-level performance
* Product popularity
* Product pricing
* Discount levels
* Return rates
* Estimated net value

This helped identify products and categories requiring further business attention.

---

### 👥 Customer Analysis
Customer-related analysis was performed using the customer attributes available in the dataset:
* Customer Age Group
* Customer Gender
* Customer Location

These attributes were used to understand customer-segment distribution and regional behavior.

---

### 🌍 Regional Analysis
Regional performance was analyzed using customer location.

The analysis included:
* Estimated Sales Value by Location
* Product distribution by Location
* Return Rate by Location
* Shipping Cost by Location

This helped identify differences in sales value, returns, and shipping requirements across locations.

---

### 🚚 Shipping & Operations Analysis
Shipping-related analysis included:
* Shipping Method
* Shipping Cost
* Shipping Cost by Location
* Shipping Cost by Shipping Method
* Relationship between Shipping Cost and Return Rate

This provided an operational view of delivery costs and return behavior.

---

### 🌦️ Seasonality Analysis
The dataset does not contain transaction dates, so monthly or yearly sales trends could not be calculated.

Instead, the available **Seasonality** attribute was analyzed to understand seasonal product patterns.

---

# 📊 Power BI Dashboard
The final Power BI report contains three analytical pages, each designed for a specific business perspective.

### 📄 Page 1: Executive Overview

<div align="center">
  <img src="images/Executive Overview.png" alt="Executive Overview" width="85%" />
  <br/>
  <ins><b>Executive Overview</b></ins>
</div>

The Executive Overview page provides a high-level summary of the overall e-commerce dataset and key performance indicators.

* **Key Focus Areas:** 
  * Estimated Sales Value
  * Estimated Net Value
  * Product and category distribution
  * Pricing and discount performance
  * Overall product performance
  * High-level business comparisons
* **Purpose:** This page provides a quick overview of overall performance and allows users to identify important patterns before moving into detailed product and customer analysis.

---

### 📄 Page 2: Product Performance

<div align="center">
  <img src="images/Product Performance.png" alt="Product Performance.png" width="85%" />
  <br/>
  <ins><b>Product Performance</b></ins>
</div>

The Product Performance page focuses on product and category-level performance.

* **Key Focus Areas:**
  * Estimated Sales Value by Product and Category
  * Product-level performance comparison
  * Price and discount patterns
  * Popularity Index
  * Return Rate
  * Product-level summary metrics
* **Purpose:** This page helps identify products and categories with comparatively strong estimated sales value and understand the factors associated with their performance. Products with comparatively high return rates can also be identified for further investigation.

---

### 📄 Page 3: Customer & Regional Insights

<div align="center">
  <img src="images/Customer & Regional Insights.png" alt="Customer & Regional Insights" width="85%" />
  <br/>
  <ins><b>Customer & Regional Insights</b></ins>
</div>

The Customer & Regional Insights page focuses on customer segments, locations, shipping, and return behavior.

#### Visuals Included

| Visualization | Purpose |
| :--- | :--- |
| **Estimated Sales Value by Location** | Compare estimated sales value across customer locations |
| **Product Records by Customer Age Group** | Understand product-record distribution across age segments |
| **Shipping Cost by Shipping Method** | Compare shipping costs across delivery methods |
| **Return Rate by Customer Location** | Analyze return-rate patterns across locations |
| **Shipping Cost vs Return Rate** | Examine the relationship between shipping cost and return rate |
| **Location & Shipping Details** | Review detailed location and shipping metrics |

* **Purpose:** This page helps understand how customer segments, locations, shipping methods, and return behavior vary across the dataset. The shipping-cost and return-rate comparison also provides an operational perspective for identifying areas that may require further investigation.

<p align="center">
  <video src="https://github.com" width="100%" controls>
    Your browser does not support the video tag.
  </video>
</p>

---

# 🔍 Key Findings

The analysis provided the following important insights:
* The dataset contains **1 million e-commerce records** covering **9,000 unique products**.
* Product and category performance varies based on estimated sales value, pricing, discounts, popularity, and return rates.
* Customer records show different distributions across age groups, genders, and locations.
* Estimated sales value varies across customer locations.
* Shipping methods have different associated shipping costs.
* Return rates vary across products and locations.
* Products with high estimated sales value and comparatively high return rates can be prioritized for further investigation.
* Pricing and discount patterns provide useful information for evaluating product performance.
* Seasonality provides an additional dimension for understanding product patterns.

# 💡 Business Recommendations

### 📦 Product & Category Strategy
* **Focus on Performance:** Focus on products and categories showing stronger estimated sales performance.
* **Investigate Returns:** Review products with relatively high return rates to identify possible product or customer-experience issues.
* **Dual Metrics:** Consider popularity and return rate together when evaluating product performance.

---

### 💰 Pricing Strategy
* **Discount Alignment:** Compare discount levels with estimated sales value.
* **Review Underperformers:** Review products receiving relatively high discounts without corresponding performance.
* **Data-Driven Pricing:** Use pricing and discount analysis to support better product-level decisions.

---

### 👥 Customer & Regional Strategy
* **Segment Profiling:** Use age-group, gender, and location patterns to understand available customer segments.
* **Target High-Value Regions:** Identify locations with stronger estimated sales performance.
* **Strategic Planning:** Use regional patterns to support future marketing and operational planning.

---

### 🚚 Shipping & Operations
* **Cost Comparison:** Compare shipping costs across available shipping methods.
* **Logistics Review:** Investigate locations with comparatively high shipping costs.
* **Operational Monitoring:** Monitor the relationship between shipping cost and return-rate patterns.

---

# 📌 Cognorise Task Coverage

| Cognorise Requirement | Project Implementation |
| :--- | :--- |
| **Extract and transform e-commerce data using SQL** | ✅ MySQL data import, validation, transformation, and analytical views |
| **Calculate revenue and sales metrics** | ✅ Estimated Sales Value, Selling Price, Discount Amount, Tax Amount, and Estimated Net Value |
| **Calculate order volume and AOV** | ⚠️ Order ID and transaction-level order fields are not available in the dataset |
| **Calculate customer-level metrics** | ✅ Customer age group, gender, and location analysis |
| **Analyze products and categories** | ✅ Product and category performance analysis |
| **Analyze regions** | ✅ Customer location and regional performance analysis |
| **Analyze time** | ⚠️ Transaction dates are unavailable; Seasonality was analyzed instead |
| **Identify new vs. repeat customers** | ⚠️ Customer IDs and transaction history are not available |
| **Analyze purchase frequency** | ⚠️ Individual customer transaction history is not available |
| **Identify high-revenue / low-profit products** | ⚠️ Actual product cost and profit fields are unavailable; high-value products were evaluated using return rate, discount, popularity, and shipping cost |
| **Build Power BI dashboard** | ✅ Three-page interactive Power BI dashboard |
| **Present findings and strategies** | ✅ Product, pricing, customer, regional, shipping, and return-rate recommendations |

> ℹ️ **Note:** The project uses *Estimated Sales Value* rather than claiming actual revenue or profit because the available dataset does not contain order-level revenue, product cost, or profit fields.

# ✅ Project Outcome

This project demonstrates an end-to-end SQL and Power BI data analytics workflow, from raw e-commerce data preparation and validation to SQL-based business analysis and interactive dashboard development.

### 📌 Core Dashboards Focus Areas
* **Sales Value**
* **Products & Categories**
* **Customers & Regions**
* **Pricing, Shipping & Returns**

### 🎯 Key Takeaway
The project demonstrates how SQL transformation and Power BI visualization can convert a large e-commerce dataset into meaningful business insights and support data-driven product, pricing, customer, and operational decisions.

### 📌 Final Project Summary

This project demonstrates an end-to-end **E-Commerce Sales Analytics** workflow using **MySQL and Power BI**. A large e-commerce dataset was cleaned, validated, transformed, and analyzed using SQL to generate meaningful sales, product, customer, regional, pricing, shipping, and return-related insights. The resulting analytical data was then used to build an interactive **three-page Power BI dashboard** covering **Executive Overview, Product Performance, and Customer & Regional Insights**.

The project demonstrates how SQL-based data analysis and Power BI visualization can transform raw e-commerce data into clear business insights and support **data-driven product, pricing, customer, regional, and operational decisions**.
