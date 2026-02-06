-- Phase 2 Core Marketing Analysis

-- Total Revenue, Transactions, and Customers
SELECT 
	COUNT(distinct customer_id) as total_customers,
    COUNT(*) as total_transactions,
    ROUND(SUM(revenue)) as total_revenue,
    ROUND(AVG(revenue),2) as average_transaction
FROM transactions;

-- Revenue and transaction count by channel
SELECT 
	c.channel,
    COUNT(t.transaction_id) as transactions,
    ROUND(SUM(t.revenue)) as revenue
FROM transactions t JOIN crm_events c on t.customer_id = c.customer_id
GROUP BY c.channel
ORDER BY revenue DESC;

-- Campaign Performance

-- ROAS(Revenue On Ad Spend)
WITH revenue_by_campaign AS (
    SELECT 
        c.campaign,
        SUM(t.revenue) AS revenue
    FROM customers c
    JOIN transactions t 
        ON t.customer_id = c.customer_id
    GROUP BY c.campaign
),
spend_by_campaign AS (
    SELECT 
        campaign,
        channel,
        SUM(spend) AS ad_spend
    FROM marketing_spend
    GROUP BY campaign, channel
)
SELECT 
    s.campaign,
    s.channel,
    ROUND(r.revenue, 2) AS revenue,
    ROUND(s.ad_spend, 2) AS ad_spend,
    ROUND(r.revenue / NULLIF(s.ad_spend, 0), 2) AS ROAS
FROM spend_by_campaign s
LEFT JOIN revenue_by_campaign r 
    ON s.campaign = r.campaign
ORDER BY ROAS DESC;

-- CAC(Customer Acquisition Cost)
SELECT 
    m.campaign,
    COUNT(DISTINCT t.customer_id) AS customers_acquired,
    ROUND(SUM(m.spend)) AS ad_spend,
    ROUND(SUM(m.spend) / COUNT(DISTINCT t.customer_id), 2) AS CAC
FROM marketing_spend m
	LEFT JOIN crm_events c ON m.channel = c.channel
    LEFT JOIN transactions t on t.customer_id = c.customer_id
GROUP BY m.campaign
ORDER BY CAC DESC;

-- Customer LTV(Lifetime Value)
SELECT
	customer_id,
    ROUND(SUM(revenue)) as lifetime_value,
    COUNT(*) as total_transactions
FROM transactions
GROUP BY customer_id
ORDER BY lifetime_value DESC;

-- RFM Analysis (Recency, Frequency, Monetary)
SELECT
	customer_id,
    MAX(transaction_date) as recent_date,
    DATEDIFF(CURDATE(), MAX(STR_TO_DATE(transaction_date, '%m/%d/%Y'))) AS recency,
    COUNT(*) as frequency,
    ROUND(SUM(revenue)) as monetary_value
FROM transactions
GROUP BY customer_id;

-- RFM Scoring
WITH rfm AS (
    SELECT
        customer_id,
        DATEDIFF(CURDATE(), MAX(STR_TO_DATE(transaction_date, '%m/%d/%Y'))) AS recency,
        COUNT(*) AS frequency,
        SUM(revenue) AS monetary
    FROM transactions
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm
)
SELECT *,
    CONCAT(r_score, f_score, m_score) AS rfm_segment
FROM rfm_scores;


-- Revenue by Location
SELECT 
	location_id,
    ROUND(SUM(revenue)) as total_revenue
FROM transactions
GROUP BY location_id
ORDER BY total_revenue DESC;

-- Revenue by Service Type
SELECT 
	service_type,
    ROUND(SUM(revenue)) as total_revenue
FROM transactions
GROUP BY service_type
ORDER BY total_revenue DESC;

-- Customer Segmentation
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(revenue) AS total_spend
    FROM transactions
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_spend > 500 THEN 'High Value'
        WHEN total_spend BETWEEN 200 AND 500 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS segment,
    COUNT(*) AS customers
FROM customer_spend
GROUP BY segment;

-- Customer Reviews
-- Count of each sentiment(positive, negative, and neutral)
SELECT 
	sentiment,
    COUNT(*) as customer_reviews
FROM nps_reviews
GROUP BY sentiment;

-- Count of reach review and average nps score by location
SELECT 
	location_id,
    COUNT(review_id) as reviews,
    ROUND(AVG(nps_score),1) as avg_nps_score
FROM nps_reviews nps JOIN customers c ON c.customer_id = nps.customer_id
GROUP BY location_id
ORDER BY avg_nps_score;

-- Count of each review sentiment by month for trend analysis
SELECT 
    DATE_FORMAT(review_date, '%Y-%m') AS review_month,
    COUNT(*) AS total_reviews,
    SUM(CASE WHEN sentiment = 'positive' THEN 1 ELSE 0 END) AS positive_reviews,
    SUM(CASE WHEN sentiment = 'neutral' THEN 1 ELSE 0 END) AS neutral_reviews,
    SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) AS negative_reviews
FROM nps_reviews
GROUP BY review_month
ORDER BY review_month;

-- Customer Service
SELECT
	COUNT(*) as cs_tickets,
    COUNT(DISTINCT customer_id) as customer_count
FROM customer_service;

SELECT
	issue_type,
    ROUND(AVG(resolution_time_minutes)) as avg_res_time,
    ROUND(AVG(csat_score),2) avg_csat
FROM customer_service
GROUP BY issue_type;
