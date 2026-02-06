-- Phase 3 Advanced Marketing Analytics

-- Campaign ROI
WITH spend_by_campaign AS (
    SELECT 
        campaign,
        ROUND(SUM(spend)) AS cost
    FROM marketing_spend
    GROUP BY campaign
),
revenue_by_campaign AS (
    SELECT 
        c.campaign,
        COUNT(t.transaction_id) AS conversions,
        ROUND(SUM(t.revenue)) AS revenue
    FROM customers c
    JOIN transactions t 
        ON t.customer_id = c.customer_id
    GROUP BY c.campaign
)
SELECT 
    s.campaign,
    r.conversions,
    r.revenue,
    s.cost,
    ROUND((r.revenue - s.cost) / NULLIF(s.cost, 0), 2) AS ROI
FROM spend_by_campaign s
LEFT JOIN revenue_by_campaign r 
    ON s.campaign = r.campaign
ORDER BY ROI DESC;

-- Cohort Analysis (Customer Retention Over Time)
-- Identify First Purchase Month
WITH first_purchase AS(
	SELECT
		customer_id,
        MIN(STR_TO_DATE(transaction_date, '%m/%d/%Y')) AS first_purchase_date
	FROM transactions
    GROUP BY customer_id
),
cohort_data AS(
	SELECT
		t.customer_id,
        DATE_FORMAT(fp.first_purchase_date, '%Y-%m') as cohort_month,
        DATE_FORMAT(str_to_date(t.transaction_date, '%m/%d/%Y'), '%Y-%m') as activity_month
	FROM transactions t JOIN first_purchase fp ON t.customer_id = fp.customer_id
)
SELECT
	cohort_month,
    activity_month,
    COUNT(DISTINCT customer_id) as active_customers
FROM cohort_data
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;

-- Retention Rate and Churn
-- Monthly Retention Rate
WITH cohort_counts AS (
    SELECT 
        cohort_month,
        activity_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM (
        SELECT 
            t.customer_id,
            DATE_FORMAT(fp.first_purchase_date, '%Y-%m') AS cohort_month,
            DATE_FORMAT(STR_TO_DATE(t.transaction_date, '%m/%d/%Y'), '%Y-%m') AS activity_month
        FROM transactions t
        JOIN (
            SELECT customer_id, MIN(STR_TO_DATE(transaction_date, '%m/%d/%Y')) AS first_purchase_date
            FROM transactions
            GROUP BY customer_id
        ) fp
        ON t.customer_id = fp.customer_id
    ) x
    GROUP BY cohort_month, activity_month
)
SELECT 
    cohort_month,
    activity_month,
    active_customers,
    FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY activity_month) AS cohort_size,
    ROUND(active_customers / FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY activity_month), 2) AS retention_rate
FROM cohort_counts
ORDER BY cohort_month, activity_month;

-- Funnel Analysis (Marketing → Conversion → Revenue)
SELECT 
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0), 4) AS click_through_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0), 4) AS conversion_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(impressions), 0), 4) AS impression_to_conversion_rate
FROM marketing_spend;

-- Funnel by channel
SELECT 
    channel,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0), 4) AS click_through_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0), 4) AS conversion_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(impressions), 0), 4) AS impression_to_conversion_rate,
    ROUND(SUM(spend) / NULLIF(SUM(conversions), 0), 2) AS cost_per_conversion
FROM marketing_spend
GROUP BY channel
ORDER BY conversions DESC;

-- Funnel by campaign
SELECT 
    channel,
    campaign,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0), 4) AS click_through_rate,
    ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0), 4) AS conversion_rate,
    ROUND(SUM(spend) / NULLIF(SUM(conversions), 0), 2) AS cost_per_conversion,
    ROUND(SUM(spend) / NULLIF(SUM(clicks), 0), 2) AS cost_per_click,
    ROUND(SUM(spend) / NULLIF(SUM(impressions), 0) * 1000, 2) AS cost_per_mille
FROM marketing_spend
GROUP BY channel, campaign
ORDER BY cost_per_conversion ASC;

-- Funnel Trend Over Time (Lifecycle Marketing)
WITH monthly_metrics AS (
    SELECT 
        DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%Y-%m') AS month,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks,
        SUM(conversions) AS conversions,
        ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0), 4) AS click_through_rate,
        ROUND(SUM(conversions) / NULLIF(SUM(clicks), 0), 4) AS conversion_rate
    FROM marketing_spend
    GROUP BY DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%Y-%m')
)
SELECT 
    month,
    impressions,
    clicks,
    conversions,
    click_through_rate,
    conversion_rate,
    ROUND(
        conversion_rate 
        - LAG(conversion_rate) OVER (ORDER BY month),
        4
    ) AS conversion_rate_mom_change
FROM monthly_metrics
ORDER BY month;
