# Tidal-Wave-Auto-Spa-Marketing-Performance-Customer-Lifecycle-Analytics
Senior Marketing Analyst Project

Project Overview

This project simulates a real-world marketing analytics environment by combining synthetic datasets, advanced SQL analysis, and Power BI dashboards to evaluate marketing performance, customer behavior, and business growth opportunities.

The objective is to demonstrate end-to-end analytics capabilities, including data generation, data modeling, advanced SQL querying, customer segmentation, cohort analysis, and executive-level reporting.

Business Objectives:
    
    Evaluate marketing performance
    
    Measure revenue, ROAS, CAC, and conversion efficiency by channel and campaign
    
    Understand customer behavior
    
    Analyze purchasing frequency, recency, and lifetime value
    
    Identify high-value and at-risk customers
    
    Segment customers using RFM analysis
    
    Assess retention and growth trends
    
    Perform cohort analysis to evaluate long-term customer retention
    
    Support data-driven decision-making
    
    Provide executive-level insights through interactive dashboards

Tools:

Python

    Synthetic datasets were generated using Python to simulate realistic business data with noise, inconsistencies, and real-world complexity

    Datasets generated were for CRM Events, Customers, Customer Service, NPS Reviews, Transactions, and Marketing Spend

SQL

    Phase 1 Data Understanding and Exploration
    
    - Loaded CSV datasets into the schema
    
    - Explored the tables using SHOW and DESCRIBE
    
    - Viewed the number of rows for each table
    
    - Identified any null values in the tables
    
    - Searched for any duplicate primary keys inside of tables with primary keys
    
    - Searched for any invalid values such as dates and amounts that did not fit the expected parameters
    
    Phase 2 Marketing Analysis
    
    - Used aggregations to summarize total revenue, transactions, and customers 
    
    - Summarized revenue and transaction count by channel
    
    - Analyzed campaign performance using CTEs to determine ROAS, CAC, Customer LTV, and RFM analysis
    
    - Identified the locations and service types that generate the most revenue
    
    - Segmented customers into High Value, Mid Value, and Low Value based on overall spend
    
    - Analyzed customer review sentiments to determine if any trends are present
    
    - Summarized customer service metrics byissue type, resolution time, and CSAT scores
    
    Phase 3 Advanced Marketing Analysis
    
    - Used CTEs to calculate campign ROI, perform cohort analysis, and determine retention rates and churn
    
    - Performed funnel analysis on customer activity Impressions -> Clicks -> Conversions
    
    - Calculated lifecycle marketing using CTE and window functions

Power BI

    Executive Marketing Dashboard
    
    - Connected to the CSV files and linked them together in the data model
    
    - Calculated measures for total revenue, total spend, ROAS, CAC, average LTV, total conversions, CPA, and CTR
    
    - Added KPI cards for total revenue, total spend, ROAS, CAC, average LTV, total conversions
    
    - Created line charts to identify trends in revenue and spend over time
    
    - Created bar charts to show ROAS by channels and campaigns
    
    - Created a funnel chart showing the change in customer activity from impressions to clicks to conversions
    
    - Added slicers for interactivity and to filter results by campaign, channel, service type, and location
    
<img width="1440" height="807" alt="image" src="https://github.com/user-attachments/assets/fb9c2f3c-a4ce-4357-8a4a-81fc01a15d70" />



