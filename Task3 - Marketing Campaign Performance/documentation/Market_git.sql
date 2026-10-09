-- ============================================================================
-- 01. DATABASE SETUP
-- Create and select the project database.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS marketing_campaign_analytics;

USE marketing_campaign_analytics;

SELECT DATABASE();

-- ============================================================================
-- 02. RAW TABLE CREATION
-- Create the staging table using the source CSV field formats.
-- ============================================================================

CREATE TABLE marketing_campaign_raw (
    Campaign_ID INT,
    Company VARCHAR(100),
    Campaign_Type VARCHAR(50),
    Target_Audience VARCHAR(50),
    Duration VARCHAR(20),
    Channel_Used VARCHAR(50),
    Conversion_Rate DECIMAL(10,4),
    Acquisition_Cost VARCHAR(30),
    ROI DECIMAL(10,2),
    Location VARCHAR(100),
    Language VARCHAR(50),
    Clicks INT,
    Impressions INT,
    Engagement_Score INT,
    Customer_Segment VARCHAR(100),
    Date DATE
);

-- ============================================================================
-- 03. RAW TABLE AND IMPORT CONFIGURATION CHECKS
-- Inspect the table definition and check local file import settings.
-- ============================================================================

DESCRIBE marketing_campaign_raw;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW SESSION VARIABLES LIKE 'local_infile';

-- ============================================================================
-- 04. CSV DATA IMPORT
-- Load the source CSV into the raw staging table.
-- ============================================================================

LOAD DATA LOCAL INFILE 'C:/Users/oviya/OneDrive/PERSONAL/Project/Cognorise/Task3_Market_campaign/marketing_campaign_data.csv'
INTO TABLE marketing_campaign_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ============================================================================
-- 05. INITIAL DATA VALIDATION
-- Check row count, sample records, and column count.
-- ============================================================================

SELECT COUNT(*) AS total_rows
FROM marketing_campaign_raw;

SELECT *
FROM marketing_campaign_raw
LIMIT 10;

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'marketing_campaign_raw';

-- ============================================================================
-- 06. EXPLORATORY DATA ANALYSIS — CATEGORY DISTRIBUTIONS
-- Explore campaign counts by type, company, audience, channel, segment, and location.
-- ============================================================================

SELECT Campaign_Type, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Campaign_Type
ORDER BY count DESC;

SELECT Company, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Company
ORDER BY count DESC;

SELECT Target_Audience, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Target_Audience
ORDER BY count DESC;

SELECT Channel_Used, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Channel_Used
ORDER BY count DESC;

SELECT Customer_Segment, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Customer_Segment
ORDER BY count DESC;

SELECT Location, COUNT(*) AS count
FROM marketing_campaign_raw
GROUP BY Location
ORDER BY count DESC;

-- ============================================================================
-- 07. RAW DATA QUALITY CHECKS
-- Check missing values, duplicate campaign IDs, numerical ranges, dates, and raw text formats.
-- ============================================================================

SELECT
    SUM(Campaign_ID IS NULL) AS Campaign_ID_nulls,
    SUM(Company IS NULL) AS Company_nulls,
    SUM(Campaign_Type IS NULL) AS Campaign_Type_nulls,
    SUM(Target_Audience IS NULL) AS Target_Audience_nulls,
    SUM(Duration IS NULL) AS Duration_nulls,
    SUM(Channel_Used IS NULL) AS Channel_Used_nulls,
    SUM(Conversion_Rate IS NULL) AS Conversion_Rate_nulls,
    SUM(Acquisition_Cost IS NULL) AS Acquisition_Cost_nulls,
    SUM(ROI IS NULL) AS ROI_nulls,
    SUM(Location IS NULL) AS Location_nulls,
    SUM(Language IS NULL) AS Language_nulls,
    SUM(Clicks IS NULL) AS Clicks_nulls,
    SUM(Impressions IS NULL) AS Impressions_nulls,
    SUM(Engagement_Score IS NULL) AS Engagement_Score_nulls,
    SUM(Customer_Segment IS NULL) AS Customer_Segment_nulls,
    SUM(Date IS NULL) AS Date_nulls
FROM marketing_campaign_raw;

SELECT 
    Campaign_ID,
    COUNT(*) AS occurrence_count
FROM marketing_campaign_raw
GROUP BY Campaign_ID
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

SELECT
    MIN(Conversion_Rate) AS min_conversion_rate,
    MAX(Conversion_Rate) AS max_conversion_rate,
    AVG(Conversion_Rate) AS avg_conversion_rate
FROM marketing_campaign_raw;

SELECT
    MIN(ROI) AS min_roi,
    MAX(ROI) AS max_roi,
    AVG(ROI) AS avg_roi
FROM marketing_campaign_raw;

SELECT
    MIN(Clicks) AS min_clicks,
    MAX(Clicks) AS max_clicks,
    AVG(Clicks) AS avg_clicks,
    MIN(Impressions) AS min_impressions,
    MAX(Impressions) AS max_impressions,
    AVG(Impressions) AS avg_impressions
FROM marketing_campaign_raw;

SELECT
    MIN(Engagement_Score) AS min_engagement,
    MAX(Engagement_Score) AS max_engagement,
    AVG(Engagement_Score) AS avg_engagement
FROM marketing_campaign_raw;

SELECT Acquisition_Cost
FROM marketing_campaign_raw
LIMIT 20;

SELECT
    MIN(Date) AS earliest_date,
    MAX(Date) AS latest_date
FROM marketing_campaign_raw;

SELECT
    YEAR(Date) AS year,
    COUNT(*) AS campaign_count
FROM marketing_campaign_raw
GROUP BY YEAR(Date)
ORDER BY year;

SELECT DISTINCT Duration
FROM marketing_campaign_raw
ORDER BY Duration;

SELECT DISTINCT Acquisition_Cost
FROM marketing_campaign_raw
ORDER BY Acquisition_Cost
LIMIT 50;

-- ============================================================================
-- 08. CLEAN TABLE CREATION
-- Create the analysis-ready table with appropriate numeric and date fields.
-- ============================================================================

CREATE TABLE marketing_campaign_clean (
    Campaign_ID INT,
    Company VARCHAR(100),
    Campaign_Type VARCHAR(50),
    Target_Audience VARCHAR(50),
    Duration_Days INT,
    Channel_Used VARCHAR(50),
    Conversion_Rate DECIMAL(10,4),
    Acquisition_Cost DECIMAL(12,2),
    ROI DECIMAL(10,2),
    Location VARCHAR(100),
    Language VARCHAR(50),
    Clicks INT,
    Impressions INT,
    Engagement_Score INT,
    Customer_Segment VARCHAR(100),
    Campaign_Date DATE
);

-- ============================================================================
-- 09. DATA CLEANING AND TRANSFORMATION
-- Convert duration text to days and remove currency symbols and separators from acquisition cost.
-- ============================================================================

INSERT INTO marketing_campaign_clean (
    Campaign_ID,
    Company,
    Campaign_Type,
    Target_Audience,
    Duration_Days,
    Channel_Used,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Location,
    Language,
    Clicks,
    Impressions,
    Engagement_Score,
    Customer_Segment,
    Campaign_Date
)
SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Target_Audience,

    CAST(REPLACE(Duration, ' days', '') AS UNSIGNED) AS Duration_Days,

    Channel_Used,
    Conversion_Rate,

    CAST(
        REPLACE(
            REPLACE(Acquisition_Cost, '$', ''),
            ',',
            ''
        ) AS DECIMAL(12,2)
    ) AS Acquisition_Cost,

    ROI,
    Location,
    Language,
    Clicks,
    Impressions,
    Engagement_Score,
    Customer_Segment,
    Date
FROM marketing_campaign_raw;

-- ============================================================================
-- 10. CLEANED DATA VALIDATION
-- Review cleaned records, compare row counts, and recheck data types, costs, and missing values.
-- ============================================================================

SELECT *
FROM marketing_campaign_clean
LIMIT 10;

SELECT COUNT(*) AS raw_rows
FROM marketing_campaign_raw;

SELECT COUNT(*) AS clean_rows
FROM marketing_campaign_clean;

SELECT DISTINCT Duration_Days
FROM marketing_campaign_clean
ORDER BY Duration_Days;

SELECT
    MIN(Acquisition_Cost) AS minimum_cost,
    MAX(Acquisition_Cost) AS maximum_cost,
    AVG(Acquisition_Cost) AS average_cost
FROM marketing_campaign_clean;

SELECT
    SUM(Campaign_ID IS NULL) AS Campaign_ID_nulls,
    SUM(Company IS NULL) AS Company_nulls,
    SUM(Campaign_Type IS NULL) AS Campaign_Type_nulls,
    SUM(Target_Audience IS NULL) AS Target_Audience_nulls,
    SUM(Duration_Days IS NULL) AS Duration_nulls,
    SUM(Channel_Used IS NULL) AS Channel_nulls,
    SUM(Conversion_Rate IS NULL) AS Conversion_Rate_nulls,
    SUM(Acquisition_Cost IS NULL) AS Acquisition_Cost_nulls,
    SUM(ROI IS NULL) AS ROI_nulls,
    SUM(Location IS NULL) AS Location_nulls,
    SUM(Language IS NULL) AS Language_nulls,
    SUM(Clicks IS NULL) AS Clicks_nulls,
    SUM(Impressions IS NULL) AS Impressions_nulls,
    SUM(Engagement_Score IS NULL) AS Engagement_nulls,
    SUM(Customer_Segment IS NULL) AS Customer_Segment_nulls,
    SUM(Campaign_Date IS NULL) AS Date_nulls
FROM marketing_campaign_clean;

-- ============================================================================
-- 11. OVERALL CAMPAIGN KPI SUMMARY
-- Calculate dataset-level campaign counts, average performance metrics, and total clicks and impressions.
-- ============================================================================

SELECT
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_acquisition_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    SUM(Clicks) AS total_clicks,
    SUM(Impressions) AS total_impressions,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score
FROM marketing_campaign_clean;

-- ============================================================================
-- 12. PERFORMANCE ANALYSIS BY BUSINESS DIMENSION
-- Compare metrics by company, campaign type, channel, customer segment, target audience, location, duration, language, and month.
-- ============================================================================

SELECT
    Company,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_acquisition_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Company
ORDER BY avg_roi DESC;

SELECT
    Campaign_Type,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_acquisition_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Campaign_Type
ORDER BY avg_roi DESC;

SELECT
    Channel_Used,
    COUNT(*) AS total_campaigns,
    SUM(Clicks) AS total_clicks,
    SUM(Impressions) AS total_impressions,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Channel_Used
ORDER BY avg_roi DESC;

SELECT
    Customer_Segment,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_acquisition_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Customer_Segment
ORDER BY avg_conversion_rate DESC;

SELECT
    Target_Audience,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Target_Audience
ORDER BY avg_roi DESC;

SELECT
    Location,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Location
ORDER BY avg_roi DESC;

SELECT
    Duration_Days,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Duration_Days
ORDER BY Duration_Days;

SELECT
    Language,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Language
ORDER BY avg_roi DESC;

SELECT
    YEAR(Campaign_Date) AS campaign_year,
    MONTH(Campaign_Date) AS campaign_month,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY
    YEAR(Campaign_Date),
    MONTH(Campaign_Date)
ORDER BY
    campaign_year,
    campaign_month;
    
-- ============================================================================
-- 13. TOP AND BOTTOM CAMPAIGN RECORDS
-- Retrieve records with the highest and lowest ROI, conversion rate, and engagement.
-- ============================================================================

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
ORDER BY ROI DESC
LIMIT 10;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
ORDER BY ROI ASC
LIMIT 10;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Conversion_Rate,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
ORDER BY Conversion_Rate DESC
LIMIT 10;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Engagement_Score,
    Conversion_Rate,
    ROI
FROM marketing_campaign_clean
ORDER BY Engagement_Score DESC
LIMIT 10;

-- ============================================================================
-- 14. CASE-BASED PERFORMANCE CATEGORIES
-- Classify ROI, conversion rate, and engagement into rule-based categories and summarize category counts.
-- ============================================================================

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI,
    CASE
        WHEN ROI >= 20 THEN 'High ROI'
        WHEN ROI >= 10 THEN 'Medium ROI'
        ELSE 'Low ROI'
    END AS ROI_Category
FROM marketing_campaign_clean
LIMIT 20;

SELECT
    CASE
        WHEN ROI >= 20 THEN 'High ROI'
        WHEN ROI >= 10 THEN 'Medium ROI'
        ELSE 'Low ROI'
    END AS ROI_Category,
    COUNT(*) AS campaign_count
FROM marketing_campaign_clean
GROUP BY ROI_Category
ORDER BY campaign_count DESC;

SELECT
    Campaign_ID,
    Conversion_Rate,
    CASE
        WHEN Conversion_Rate >= 0.10 THEN 'High Conversion'
        WHEN Conversion_Rate >= 0.05 THEN 'Medium Conversion'
        ELSE 'Low Conversion'
    END AS Conversion_Category
FROM marketing_campaign_clean
LIMIT 20;

SELECT
    CASE
        WHEN Conversion_Rate >= 0.10 THEN 'High Conversion'
        WHEN Conversion_Rate >= 0.05 THEN 'Medium Conversion'
        ELSE 'Low Conversion'
    END AS Conversion_Category,
    COUNT(*) AS campaign_count
FROM marketing_campaign_clean
GROUP BY Conversion_Category
ORDER BY campaign_count DESC;

SELECT
    Campaign_ID,
    Engagement_Score,
    CASE
        WHEN Engagement_Score >= 8 THEN 'High Engagement'
        WHEN Engagement_Score >= 5 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS Engagement_Category
FROM marketing_campaign_clean
LIMIT 20;

-- ============================================================================
-- 15. SUBQUERIES AND ABOVE-AVERAGE ANALYSIS
-- Compare company and campaign ROI against the overall average and identify maximum ROI records.
-- ============================================================================

SELECT AVG(ROI) AS overall_avg_roi
FROM marketing_campaign_clean;

SELECT
    Company,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS avg_roi
FROM marketing_campaign_clean
GROUP BY Company
HAVING AVG(ROI) > (
    SELECT AVG(ROI)
    FROM marketing_campaign_clean
)
ORDER BY avg_roi DESC;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI
FROM marketing_campaign_clean
WHERE ROI > (
    SELECT AVG(ROI)
    FROM marketing_campaign_clean
)
ORDER BY ROI DESC;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI
FROM marketing_campaign_clean
WHERE ROI = (
    SELECT MAX(ROI)
    FROM marketing_campaign_clean
);

-- ============================================================================
-- 16. CTE-BASED COMPANY PERFORMANCE
-- Use a common table expression to organize company-level performance metrics.
-- ============================================================================

WITH company_performance AS (
    SELECT
        Company,
        COUNT(*) AS campaign_count,
        AVG(ROI) AS avg_roi,
        AVG(Conversion_Rate) AS avg_conversion_rate,
        AVG(Engagement_Score) AS avg_engagement
    FROM marketing_campaign_clean
    GROUP BY Company
)
SELECT
    Company,
    campaign_count,
    ROUND(avg_roi, 2) AS avg_roi,
    ROUND(avg_conversion_rate, 4) AS avg_conversion_rate,
    ROUND(avg_engagement, 2) AS avg_engagement
FROM company_performance
ORDER BY avg_roi DESC;

-- ============================================================================
-- 17. WINDOW FUNCTIONS AND CAMPAIGN RANKING
-- Apply RANK, DENSE_RANK, PERCENT_RANK, and partitioned window calculations.
-- ============================================================================

SELECT
    Company,
    ROUND(AVG(ROI), 2) AS avg_roi,
    RANK() OVER (
        ORDER BY AVG(ROI) DESC
    ) AS roi_rank
FROM marketing_campaign_clean
GROUP BY Company;

SELECT
    Company,
    ROUND(AVG(ROI), 2) AS avg_roi,
    DENSE_RANK() OVER (
        ORDER BY AVG(ROI) DESC
    ) AS roi_rank
FROM marketing_campaign_clean
GROUP BY Company;

WITH campaign_type_performance AS (
    SELECT
        Campaign_Type,
        COUNT(*) AS campaign_count,
        AVG(ROI) AS avg_roi
    FROM marketing_campaign_clean
    GROUP BY Campaign_Type
)
SELECT
    Campaign_Type,
    campaign_count,
    ROUND(avg_roi, 2) AS avg_roi,
    DENSE_RANK() OVER (
        ORDER BY avg_roi DESC
    ) AS roi_rank
FROM campaign_type_performance;

WITH campaign_ranked AS (
    SELECT
        Campaign_ID,
        Company,
        Campaign_Type,
        ROI,
        PERCENT_RANK() OVER (
            ORDER BY ROI
        ) AS roi_percentile
    FROM marketing_campaign_clean
)
SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI,
    ROUND(roi_percentile, 2) AS roi_percentile
FROM campaign_ranked
ORDER BY ROI DESC
LIMIT 20;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI,
    ROUND(
        AVG(ROI) OVER (PARTITION BY Company),
        2
    ) AS company_avg_roi,
    ROUND(
        ROI - AVG(ROI) OVER (PARTITION BY Company),
        2
    ) AS difference_from_company_avg
FROM marketing_campaign_clean
LIMIT 20;

-- ============================================================================
-- 18. CROSS-DIMENSIONAL PERFORMANCE ANALYSIS
-- Compare company and channel combinations, campaign type and customer segment combinations, and potential optimization cases.
-- ============================================================================

SELECT
    Company,
    Channel_Used,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_acquisition_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY
    Company,
    Channel_Used
ORDER BY avg_roi DESC;

SELECT
    Campaign_Type,
    Customer_Segment,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY
    Campaign_Type,
    Customer_Segment
ORDER BY avg_roi DESC;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
WHERE ROI >= (
    SELECT AVG(ROI)
    FROM marketing_campaign_clean
)
AND Conversion_Rate < (
    SELECT AVG(Conversion_Rate)
    FROM marketing_campaign_clean
)
ORDER BY ROI DESC;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
WHERE Conversion_Rate >= (
    SELECT AVG(Conversion_Rate)
    FROM marketing_campaign_clean
)
AND ROI < (
    SELECT AVG(ROI)
    FROM marketing_campaign_clean
)
ORDER BY Conversion_Rate DESC;

-- ============================================================================
-- 19. ENGAGEMENT AND ACQUISITION-COST SEGMENTATION
-- Compare ROI and conversion metrics across engagement and acquisition-cost categories.
-- ============================================================================

SELECT
    CASE
        WHEN Engagement_Score >= 8 THEN 'High Engagement'
        WHEN Engagement_Score >= 5 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS Engagement_Category,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate
FROM marketing_campaign_clean
GROUP BY Engagement_Category
ORDER BY avg_roi DESC;

SELECT
    CASE
        WHEN Acquisition_Cost < 30000 THEN 'Low Cost'
        WHEN Acquisition_Cost < 60000 THEN 'Medium Cost'
        ELSE 'High Cost'
    END AS Cost_Category,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Acquisition_Cost), 2) AS avg_cost,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate
FROM marketing_campaign_clean
GROUP BY Cost_Category
ORDER BY avg_roi DESC;

-- ============================================================================
-- 20. BEST CAMPAIGNS WITHIN EACH GROUP
-- Rank campaigns within each company and campaign type.
-- ============================================================================

WITH ranked_campaigns AS (
    SELECT
        Campaign_ID,
        Company,
        Campaign_Type,
        Channel_Used,
        ROI,
        Conversion_Rate,
        Engagement_Score,
        ROW_NUMBER() OVER (
            PARTITION BY Company
            ORDER BY ROI DESC
        ) AS campaign_rank
    FROM marketing_campaign_clean
)
SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    ROI,
    Conversion_Rate,
    Engagement_Score
FROM ranked_campaigns
WHERE campaign_rank = 1
ORDER BY ROI DESC;

WITH ranked_campaigns AS (
    SELECT
        Campaign_ID,
        Campaign_Type,
        Company,
        Channel_Used,
        ROI,
        Conversion_Rate,
        ROW_NUMBER() OVER (
            PARTITION BY Campaign_Type
            ORDER BY ROI DESC
        ) AS campaign_rank
    FROM marketing_campaign_clean
)
SELECT
    Campaign_ID,
    Campaign_Type,
    Company,
    Channel_Used,
    ROI,
    Conversion_Rate,
    campaign_rank
FROM ranked_campaigns
WHERE campaign_rank <= 3
ORDER BY Campaign_Type, campaign_rank;

-- ============================================================================
-- 21. MULTI-METRIC COMPANY PERFORMANCE
-- Identify companies exceeding overall averages for both ROI and conversion rate.
-- ============================================================================

SELECT
    Company,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Conversion_Rate), 4) AS avg_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS avg_engagement
FROM marketing_campaign_clean
GROUP BY Company
HAVING AVG(ROI) > (
    SELECT AVG(ROI)
    FROM marketing_campaign_clean
)
AND AVG(Conversion_Rate) > (
    SELECT AVG(Conversion_Rate)
    FROM marketing_campaign_clean
)
ORDER BY avg_roi DESC;

-- ============================================================================
-- 22. CAMPAIGN PERFORMANCE SCORING
-- Build a rule-based score using ROI, conversion rate, and engagement, then rank records.
-- ============================================================================

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    ROI,
    Conversion_Rate,
    Engagement_Score,

    (
        CASE
            WHEN ROI >= 20 THEN 3
            WHEN ROI >= 10 THEN 2
            ELSE 1
        END
        +
        CASE
            WHEN Conversion_Rate >= 0.10 THEN 3
            WHEN Conversion_Rate >= 0.05 THEN 2
            ELSE 1
        END
        +
        CASE
            WHEN Engagement_Score >= 8 THEN 3
            WHEN Engagement_Score >= 5 THEN 2
            ELSE 1
        END
    ) AS Performance_Score

FROM marketing_campaign_clean
ORDER BY Performance_Score DESC, ROI DESC
LIMIT 20;

-- ============================================================================
-- 23. FINAL BUSINESS SUMMARY AND TOP-PERFORMER LOOKUPS
-- Summarize dataset dimensions and retrieve top-performing companies, channels, campaign types, segments, locations, and records.
-- ============================================================================

SELECT
    COUNT(*) AS total_campaigns,
    COUNT(DISTINCT Company) AS total_companies,
    COUNT(DISTINCT Campaign_Type) AS total_campaign_types,
    COUNT(DISTINCT Channel_Used) AS total_channels,
    COUNT(DISTINCT Customer_Segment) AS total_customer_segments,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Acquisition_Cost), 2) AS average_acquisition_cost,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean;

SELECT
    Company,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Company
ORDER BY average_roi DESC
LIMIT 1;

SELECT
    Channel_Used,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Channel_Used
ORDER BY average_roi DESC
LIMIT 1;

SELECT
    Campaign_Type,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Campaign_Type
ORDER BY average_roi DESC
LIMIT 1;

SELECT
    Customer_Segment,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Customer_Segment
ORDER BY average_roi DESC
LIMIT 1;

SELECT
    Location,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Location
ORDER BY average_roi DESC
LIMIT 1;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Customer_Segment,
    Conversion_Rate,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM marketing_campaign_clean
ORDER BY ROI DESC
LIMIT 1;

SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Engagement_Score,
    Conversion_Rate,
    ROI
FROM marketing_campaign_clean
ORDER BY Engagement_Score DESC
LIMIT 1;

-- ============================================================================
-- 24. QUALIFIED COMBINATION ANALYSIS
-- Compare company-channel and campaign-type-segment combinations with at least ten records.
-- ============================================================================

SELECT
    Company,
    Channel_Used,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Company, Channel_Used
HAVING COUNT(*) >= 10
ORDER BY average_roi DESC
LIMIT 10;

SELECT
    Campaign_Type,
    Customer_Segment,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY Campaign_Type, Customer_Segment
HAVING COUNT(*) >= 10
ORDER BY average_roi DESC
LIMIT 10;

-- ============================================================================
-- 25. MONTHLY TRENDS AND COST CATEGORY ANALYSIS
-- Review monthly trends and compare low-, medium-, and high-cost groups.
-- ============================================================================

SELECT
    DATE_FORMAT(Campaign_Date, '%Y-%m') AS campaign_month,
    COUNT(*) AS campaign_count,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate,
    ROUND(AVG(Engagement_Score), 2) AS average_engagement
FROM marketing_campaign_clean
GROUP BY DATE_FORMAT(Campaign_Date, '%Y-%m')
ORDER BY campaign_month;

SELECT
    CASE
        WHEN Acquisition_Cost < 30000 THEN 'Low Cost'
        WHEN Acquisition_Cost < 60000 THEN 'Medium Cost'
        ELSE 'High Cost'
    END AS cost_category,
    COUNT(*) AS campaign_count,
    ROUND(AVG(Acquisition_Cost), 2) AS average_cost,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(Conversion_Rate), 4) AS average_conversion_rate
FROM marketing_campaign_clean
GROUP BY cost_category
ORDER BY average_roi DESC;

-- ============================================================================
-- 26. FINAL COMPOSITE RANKING
-- Calculate a combined campaign performance score and assign an overall rank.
-- ============================================================================

WITH campaign_scores AS (
    SELECT
        Campaign_ID,
        Company,
        Campaign_Type,
        Channel_Used,
        Customer_Segment,
        ROI,
        Conversion_Rate,
        Engagement_Score,
        (
            CASE
                WHEN ROI >= 20 THEN 3
                WHEN ROI >= 10 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN Conversion_Rate >= 0.10 THEN 3
                WHEN Conversion_Rate >= 0.05 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN Engagement_Score >= 8 THEN 3
                WHEN Engagement_Score >= 5 THEN 2
                ELSE 1
            END
        ) AS performance_score
    FROM marketing_campaign_clean
)
SELECT
    *,
    DENSE_RANK() OVER (
        ORDER BY performance_score DESC, ROI DESC
    ) AS overall_rank
FROM campaign_scores
ORDER BY overall_rank
LIMIT 20;

-- ============================================================================
-- 27. FINAL TABLE REVIEW
-- Select the project database and perform a final sample and schema check.
-- ============================================================================

USE marketing_campaign_analytics;

SELECT *
FROM marketing_campaign_clean
LIMIT 10;

DESCRIBE marketing_campaign_clean;