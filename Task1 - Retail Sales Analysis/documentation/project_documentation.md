# 🛍️ Retail Sales Analysis — Project Documentation

### Power BI | Power Query | DAX | Excel / CSV

> **An end-to-end retail sales analytics project focused on data cleaning, KPI development, business analysis, and interactive Power BI dashboard development.**

## 📌 1. Project Overview

This project analyzes retail sales transactions for the year **2023** using Power BI.

The main objectives are to:

- Clean and validate the retail transaction data
- Calculate key sales KPIs
- Analyze sales by product category, city, store type and month
- Analyze delivery and high-value orders
- Identify important sales patterns and fluctuations
- Build an interactive Power BI dashboard
- Generate business insights and recommendations

### Tools Used

- Power BI Desktop
- Power Query
- DAX
- Excel / CSV
- GitHub

## 2. Dataset Overview

The original dataset contains **1,000 retail transactions** recorded during 2023 with **16 columns**.

After data cleaning and removing redundant or unnecessary fields, the final analysis dataset contains **14 columns**.

### Final Analysis Columns

| Column | Description |
|---|---|
| Order ID | Unique order identifier |
| Date | Transaction date |
| Customer ID | Customer identifier |
| Gender | Customer gender |
| Age | Customer age |
| Product Category | Clothing, Electronics or Beauty |
| Payment Method | Payment method used |
| City | Customer/order city |
| Store Type | Type of store |
| Quantity | Number of units purchased |
| Price per Unit | Price of one unit |
| Total Amount | Total transaction amount |
| Delivery Status | Completed or Pending |
| High Value Order | Indicates whether the order is high value |

### Columns Removed

| Column | Reason |
|---|---|
| Total Price | Duplicated `Total Amount` across all records |
| Sales Rep E-mail | Not required for sales analysis and excluded from the public analysis dataset |

## 3. Data Cleaning and Validation

Data preparation was performed using **Power Query in Power BI**.

### 3.1 Date Conversion

The `Date` column was initially stored as text.

It was converted to the **Date** data type using the correct day/month/year interpretation.

Example: `31/12/2023 → 31 December 2023`

## 4. Dataset Limitations

The dataset does not contain:

- Product Name
- Cost / COGS
- Profit
- Profit Margin
- Discount
- Marketing Spend

Therefore, profit and profit margin were not calculated because the required cost information was unavailable.
Individual product-level analysis was also not performed because only Product Category is available.

## 5. Power BI DAX Measures
### Total Revenue
```dax
Total Revenue = 
SUM(Retail_Sales[Total Amount])        // Result: $476,160
```

### Total Orders
```dax
Total Orders =
DISTINCTCOUNT(Retail_Sales[Order ID])        // Result: 1,000
```

### Total Quantity
```dax
Total Quantity =
SUM(Retail_Sales[Quantity])        // Result: 2,632
```

### Average Order Value
```dax
Average Order Value =
DIVIDE(
    [Total Revenue],
    [Total Orders]        // Result: $476.16
)
```

### Average Units per Order
```dax
Average Units per Order =
DIVIDE(
    [Total Quantity],
    [Total Orders]        // Result: 2.63
)
```

### Completed Orders
```dax
Completed Orders =
CALCULATE(
    [Total Orders],
    Retail_Sales[Delivery Status] = "Completed"        // Result: 649
)
```

### Pending Orders
```dax
Pending Orders =
CALCULATE(
    [Total Orders],
    Retail_Sales[Delivery Status] = "Pending"        // Result: 351
)
```

### Delivery Completion Rate
```dax
Delivery Completion Rate =
DIVIDE(
    [Completed Orders],
    [Total Orders]        // Result: 64.90%
)
```

### High Value Orders
```dax
High Value Orders =
CALCULATE(
    [Total Orders],
    Retail_Sales[High Value Order] = "Yes"        // Result: 299
)
```

### High Value Order Rate
```dax
High Value Order Rate =
DIVIDE(
    [High Value Orders],
    [Total Orders]        // Result: 29.90%
)
```

## 6. KPI Summary

| KPI                      |   Result |
| ------------------------ | -------: |
| Total Revenue            | $476,160 |
| Total Orders             |    1,000 |
| Total Quantity           |    2,632 |
| Average Order Value      |  $476.16 |
| Average Units per Order  |     2.63 |
| Completed Orders         |      649 |
| Pending Orders           |      351 |
| Delivery Completion Rate |   64.90% |
| High Value Orders        |      299 |
| High Value Order Rate    |   29.90% |

## 7. Sales Analysis

### Product Category
| Category    |  Revenue | Quantity | Orders |     AOV |
| ----------- | -------: | -------: | -----: | ------: |
| Electronics | $166,955 |      882 |    342 | $488.17 |
| Clothing    | $158,965 |      939 |    351 | $452.89 |
| Beauty      | $150,240 |      811 |    307 | $489.38 |

### Key Findings
 - Electronics generated the highest revenue: $166,955
 - Clothing had the highest quantity: 939 units
 - Clothing had the highest number of orders: 351
 - Beauty had the highest AOV: $489.38

### City Analysis
 - San Francisco: approximately $71K
 - Miami: approximately $54K
 - Chicago: approximately $50K
 - New York: approximately $34K
 - Atlanta: approximately $38K
 - Los Angeles: approximately $39K

`San Francisco` recorded the highest city-level revenue in the dataset.

### Store Type Analysis
Revenue was analyzed across:

 - Convenience Store
 - Department Store
 - Specialty Store
 - Supermarket
 - Pharmacy
 - Warehouse Club
   
`Convenience Store` recorded the highest revenue, while `Warehouse Club` recorded the lowest.

### Monthly Revenue
 - Highest month: June — approximately $56K
 - Lowest month: October — approximately $25K

The data shows noticeable monthly fluctuations during 2023.
Since only one year of data is available, these should not be treated as confirmed seasonal trends.

## 8. Delivery Analysis

| Delivery Status |    Orders | Percentage |
| --------------- | --------: | ---------: |
| Completed       |       649 |      64.9% |
| Pending         |       351 |      35.1% |
| **Total**       | **1,000** |   **100%** |

## 9. High Value Order Analysis

| Order Type |    Orders | Percentage |
| ---------- | --------: | ---------: |
| High Value |       299 |      29.9% |
| Standard   |       701 |      70.1% |
| **Total**  | **1,000** |   **100%** |

## 10. Dashboard

### Page 1 — Sales Analysis

The Sales Analysis dashboard includes:

 - Revenue by Product Category
 - Revenue by City
 - Revenue by Store Type
 - Quantity by Product Category
 - Category Revenue vs Quantity
 - Monthly Revenue Trend
 - Delivery Status
 - High Value Order Distribution
 - Category Performance Table

### Page 2 — Executive Dashboard

The Executive Dashboard provides a high-level summary through interactive filters, KPI cards and charts.

**Filters**
 - Product Category
 - City
 - Gender
 - Delivery Status
   
**KPI Cards**
 - Total Revenue
 - Total Orders
 - Total Quantity
 - Average Order Value
 - Delivery Completion Rate
   
**Visuals**
 - Monthly Revenue Trend
 - Revenue by City
 - Revenue by Product Category
 - Revenue by Store Type

**Key Takeaways**
 - **Revenue Leader:** Electronics
 - **Top City:** San Francisco
 - **Peak Month:** June
 - **Lowest Month:** October


## 11. Key Business Insights
### 1. Electronics leads revenue
Electronics generated **$166,955**, the highest revenue among the three product categories.

### 2. Clothing leads sales volume
Clothing recorded **939 units** and **351 orders**, the highest transaction volume among the categories.

### 3. Beauty has the highest category AOV
Beauty recorded an AOV of approximately **$489.38**, slightly higher than Electronics at approximately **$488.17**.

### 4. San Francisco has the highest city revenue
San Francisco generated approximately **$71K**, the highest city-level revenue in the dataset.

### 5. Monthly revenue fluctuates
June recorded the highest monthly revenue at approximately **$56K**, while October recorded the lowest at approximately **$25K**.

### 6. Delivery status requires monitoring
Out of 1,000 orders:
 - 649 were completed
 - 351 were pending

The resulting delivery completion rate was **64.9%**.

### 7. High-value orders represent 29.9% of transactions
There were **299 high-value orders**, representing approximately **29.9%** of total orders.

## 12. Business Recommendations
### 1. Strengthen Electronics Sales Strategies
Since Electronics generated the highest revenue, businesses can examine inventory availability, product assortment and promotional strategies for this category.

### 2. Increase Beauty Order Volume
Beauty has a relatively high AOV but lower order volume. Targeted promotions, bundles and cross-selling could be explored to increase transaction volume.

### 3. Investigate City-Level Performance
Differences between higher- and lower-revenue cities can be investigated further using additional information such as store count, customer traffic, marketing expenditure and regional demand.

### 4. Investigate the October Revenue Decline
The October decline can be investigated using additional business information such as promotions, inventory availability, holidays and customer demand.

### 5. Monitor Pending Deliveries
The **35.1% pending-order proportion** can be monitored regularly to identify delivery bottlenecks and improve order completion.

## 13. Project Limitations
 - The dataset contains only one year of data, so long-term trends and confirmed seasonality cannot be established.
 - Product names are not available, so individual product-level performance cannot be analyzed.
 - Cost and profit fields are not available, so profit and profit margin were not calculated.
 - Customer IDs are unique across the transaction records, limiting repeat-customer analysis.
 - Marketing expenditure, store count, inventory levels and customer traffic are not available, so causal explanations for sales differences cannot be established.
 - The analysis is based on the fields available in the provided dataset.

## 14. Project Outcome

The project transformed raw retail transaction data into a structured and validated analysis dataset and developed an interactive Power BI dashboard for business analysis.

The final dashboard enables users to:

 - Monitor revenue and order KPIs
 - Compare product categories
 - Analyze city-level sales
 - Compare store types
 - Track monthly revenue
 - Monitor delivery completion
 - Identify high-value orders
 - Filter results using interactive slicers
