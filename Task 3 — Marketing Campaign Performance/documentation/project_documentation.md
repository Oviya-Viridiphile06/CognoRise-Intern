# 📊 Marketing Campaign Performance Analysis

### MySQL | SQL | Power BI | DAX

> **An end-to-end marketing analytics project focused on data cleaning, campaign performance analysis, KPI development, and interactive Power BI dashboard creation.**

## 📌 1. Project Overview

This project was completed as **Task 3 — Marketing Campaign Performance**, an advanced internship project.

The objective was to analyze marketing campaign data across channels, companies, campaign types, audiences, and customer segments to understand campaign effectiveness and identify opportunities for optimization.

The project covers:

* Cleaning and preparing campaign performance data using SQL.
* Analyzing impressions, clicks, conversion rates, acquisition costs, and ROI.
* Comparing campaign performance across channels, companies, locations, and customer segments.
* Investigating relationships between acquisition cost, conversion, engagement, and ROI.
* Identifying campaign performance patterns for further investigation.
* Developing an interactive three-page Power BI dashboard.
* Presenting data-driven insights to support marketing decisions.

## 🛠️ 2. Tools and Technologies

* **MySQL** — Data storage, cleaning, and transformation.
* **SQL** — Exploratory data analysis, aggregations, and business analysis.
* **Power BI Desktop** — Interactive dashboards and data visualization.
* **DAX** — KPI and analytical measure creation.
* **GitHub** — Project documentation and portfolio presentation.

## 🗃️ 3. Dataset Overview

**Dataset:** [Marketing Campaign Performance Dataset — Kaggle](https://www.kaggle.com/datasets/manishabhatt22/marketing-campaign-performance-dataset)

**File:** `marketing_campaign_data.csv`

* Approximately **200,000 records**
* **16 columns**

### Dataset Columns

| Column           | Description                          |
| ---------------- | ------------------------------------ |
| Campaign_ID      | Campaign record identifier           |
| Company          | Company associated with the campaign |
| Campaign_Type    | Marketing campaign category          |
| Target_Audience  | Intended target audience             |
| Duration         | Campaign duration                    |
| Channel_Used     | Marketing channel                    |
| Conversion_Rate  | Recorded conversion rate             |
| Acquisition_Cost | Customer acquisition cost            |
| ROI              | Return on investment metric          |
| Location         | Campaign location                    |
| Language         | Campaign language                    |
| Clicks           | Number of clicks                     |
| Impressions      | Number of impressions                |
| Engagement_Score | Campaign engagement score            |
| Customer_Segment | Customer segment                     |
| Date             | Campaign date                        |

## 🧹 4. Data Cleaning and Preparation — SQL

Data cleaning and preparation were performed using MySQL.

### Work Completed

* Imported the CSV dataset into MySQL.
* Created a structured table for cleaned campaign data.
* Converted campaign duration from text into numeric days.
* Removed currency symbols and thousands separators from acquisition cost.
* Converted acquisition cost into a numeric decimal format.
* Assigned appropriate data types to analytical columns.
* Validated the cleaned dataset before analysis.

These steps prepared the data for consistent SQL calculations and Power BI reporting.

## 🔍 5. SQL Analysis

SQL was used to explore campaign performance and investigate business-related questions.

### Analysis Performed

* **Exploratory Data Analysis (EDA):** Examined the dataset structure, campaign attributes, and numerical metrics.
* **Campaign Distribution:** Analyzed campaign records by company, campaign type, channel, location, and customer segment.
* **Performance Analysis:** Evaluated average ROI, conversion rate, acquisition cost, and engagement.
* **Campaign Reach:** Analyzed total clicks and impressions.
* **Comparative Analysis:** Compared campaign performance across different business categories.
* **Advanced SQL Analysis:** Used aggregations and grouped queries to investigate campaign performance patterns.
* **Business Analysis:** Prepared SQL queries to support marketing performance evaluation and identify areas for further investigation.

## 🧮 6. Power BI DAX Measures

The following DAX measures were created to calculate the main dashboard KPIs.

### Total Campaigns

```dax
Total Campaigns =
COUNTROWS('marketing_campaign_analytics marketing_campaign_clean')
```

Counts the records in the cleaned dataset.

### Average ROI

```dax
Average ROI =
AVERAGE('marketing_campaign_analytics marketing_campaign_clean'[ROI])
```

Calculates the average recorded ROI.

### Average Conversion Rate

```dax
Average Conversion Rate =
AVERAGE('marketing_campaign_analytics marketing_campaign_clean'[Conversion_Rate])
```

Calculates the average conversion rate.

### Total Clicks

```dax
Total Clicks =
SUM('marketing_campaign_analytics marketing_campaign_clean'[Clicks])
```

Calculates the total recorded clicks.

### Total Impressions

```dax
Total Impressions =
SUM('marketing_campaign_analytics marketing_campaign_clean'[Impressions])
```

Calculates the total recorded impressions.

### Average Acquisition Cost

```dax
Average Acquisition Cost =
AVERAGE('marketing_campaign_analytics marketing_campaign_clean'[Acquisition_Cost])
```

Calculates the average acquisition cost.

### Average Engagement

```dax
Average Engagement =
AVERAGE('marketing_campaign_analytics marketing_campaign_clean'[Engagement_Score])
```

Calculates the average engagement score.

## 📊 7. Power BI Dashboard

The report contains **three interactive dashboard pages**, each serving a different analytical purpose.

### 📄 Page 1 — Marketing Campaign Performance Dashboard

**Objective:** Provide an overall summary of marketing campaign performance.

**KPI Cards**

* Total Campaigns
* Average ROI
* Average Conversion Rate
* Total Clicks
* Total Impressions
* Average Acquisition Cost

**Visualizations**

| Visualization                             | Chart Type     | Purpose                                                 |
| ----------------------------------------- | -------------- | ------------------------------------------------------- |
| Campaign Type Efficiency: Cost vs ROI     | Scatter chart  | Compare acquisition cost and ROI across campaign types  |
| ROI by Customer Segment and Campaign Type | Matrix heatmap | Compare ROI across customer segments and campaign types |
| Campaign Mix by Type                      | Donut chart    | Show the distribution of campaign records by type       |
| Channel Portfolio and ROI                 | Treemap        | Compare campaign volume and average ROI by channel      |

**Business Purpose:** Offers a high-level view of campaign volume, recorded ROI, conversion, reach, and acquisition cost.

<div align="center">
  <img src="screenshots/dashboard_overview.png" alt="Marketing Campaign Performance Dashboard — Page 1" width="90%">
  <br>
  <b>Page 1 — Marketing Campaign Performance Dashboard</b>
</div>

### 📄 Page 2 — Campaign & Channel Analysis

**Objective:** Compare campaign performance across companies, channels, locations, and customer segments.

**Interactive Filters**

* Company
* Campaign Type
* Channel
* Customer Segment

**Visualizations**

| Visualization                             | Chart Type                      | Purpose                                                             |
| ----------------------------------------- | ------------------------------- | ------------------------------------------------------------------- |
| Company Performance — Average ROI         | Horizontal bar chart            | Compare average ROI across companies                                |
| Location Performance — Conversion Rate    | Horizontal bar chart            | Compare conversion rates across locations                           |
| Channel Volume & ROI                      | Line and clustered column chart | Compare campaign volume and average ROI by channel                  |
| Customer Engagement vs Conversion         | Scatter chart                   | Explore engagement and conversion patterns across customer segments |
| Acquisition Cost vs Conversion            | Scatter chart                   | Examine acquisition cost and conversion rate across campaign types  |
| Campaign Type × Company — ROI Performance | Matrix heatmap                  | Compare average ROI for campaign-type and company combinations      |

**Business Purpose:** Supports comparative analysis to investigate differences in campaign efficiency and performance across business categories.

<div align="center">
  <img src="screenshots/campaign_analysis.png" alt="Campaign and Channel Analysis Dashboard — Page 2" width="90%">
  <br>
  <b>Page 2 — Campaign & Channel Analysis</b>
</div>

### 📄 Page 3 — Campaign Performance & Insights

**Objective:** Investigate campaign efficiency, conversion, engagement, and individual campaign records.

**Interactive Filters**

* Company
* Campaign Type
* Channel
* Customer Segment

**Visualizations**

| Visualization                     | Chart Type    | Purpose                                                       |
| --------------------------------- | ------------- | ------------------------------------------------------------- |
| Campaign Performance by Type      | Column chart  | Compare performance across campaign types                     |
| Campaign Efficiency — Cost vs ROI | Scatter chart | Explore the relationship between acquisition cost and ROI     |
| Conversion vs Engagement          | Scatter chart | Examine the relationship between conversion and engagement    |
| Campaign Performance Details      | Table         | Inspect campaign identifiers and selected performance metrics |

**Detailed Campaign Table Fields**

* Campaign ID
* Campaign Type
* Company
* Channel Used
* ROI
* Acquisition Cost
* Conversion Rate
* Engagement Score
* Clicks

**Business Purpose:** Provides a detailed view of campaign records and performance patterns to support further investigation of strong and weak results.

<div align="center">
  <img src="screenshots/campaign_insights.png" alt="Campaign Performance and Insights Dashboard — Page 3" width="90%">
  <br>
  <b>Page 3 — Campaign Performance & Insights</b>
</div>

## 💡 8. Key Business Questions

The project was designed to investigate the following questions:

1. How do marketing campaigns perform in terms of ROI and conversion rate?
2. How does campaign performance vary across companies?
3. Which channels account for different levels of campaign volume and clicks?
4. How do conversion rates vary across locations and campaign types?
5. How are acquisition cost and ROI related?
6. Do customer segments show different engagement and conversion patterns?
7. How does ROI vary across campaign-type and company combinations?
8. Which campaign records should be investigated for optimization opportunities?

## 🚀 9. Business Recommendations

The analysis can support the following data-driven actions, subject to validation against the actual results:

* **Optimize marketing spend:** Investigate campaigns with relatively high acquisition costs and low ROI.
* **Evaluate channel effectiveness:** Compare campaign volume, clicks, conversion, and ROI before reallocating budgets.
* **Improve conversion performance:** Examine campaign types and locations with comparatively low conversion rates.
* **Understand customer engagement:** Investigate differences in engagement and conversion across customer segments.
* **Review campaign outliers:** Validate unusually high or low campaign metrics against the underlying records.
* **Monitor performance consistently:** Use common KPI definitions and appropriate aggregations across all dashboard pages.

## ⚠️ 10. Dataset Limitations

* ROI and conversion-rate definitions should be interpreted according to the source dataset's documentation.
* The uniqueness of `Campaign_ID` should be verified before treating each record as a distinct campaign.
* The dataset does not, from the listed fields alone, establish actual revenue or profit values.
* Relationships between acquisition cost, engagement, conversion, and ROI do not establish causation.
* Budget allocation recommendations should be validated using the underlying data and relevant business context.

## 🏆 11. Project Outcome

Completed an end-to-end marketing campaign analytics project by preparing campaign data using SQL, conducting exploratory and comparative analysis, creating DAX measures, and developing a three-page interactive Power BI dashboard.

The project demonstrates practical skills in:

* SQL data cleaning and transformation
* Exploratory and advanced SQL analysis
* KPI development using DAX
* Marketing performance analysis
* Power BI dashboard design
* Interactive data visualization
* Business-focused analytical reporting

## 🎯 Project Summary

**Data Cleaning → SQL Analysis → DAX Measures → KPI Development → Power BI Dashboards → Business Insights**

This project demonstrates how data analytics tools can transform raw marketing campaign records into structured performance analysis to support more informed marketing decisions.
