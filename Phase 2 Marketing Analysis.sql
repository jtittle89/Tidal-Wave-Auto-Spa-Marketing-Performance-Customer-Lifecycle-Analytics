-- Phase 2 Core Marketing Analysis

-- Total Revenue, Transactions, and Customers
SELECT 
	COUNT(distinct customer_id) as total_customers,
    COUNT(*) as total_transactions,
    ROUND(SUM(revenue)) as total_revenue,
    ROUND(AVG(revenue),2) as average_transaction
FROM transactions;

-- Revenue and transation count by channel
SELECT 
	c.channel,
    COUNT(t.transaction_id) as transactions,
    ROUND(SUM(t.revenue)) as revenue
FROM transactions t JOIN crm_events c on t.customer_id = c.customer_id
GROUP BY c.channel
ORDER BY revenue DESC;

-- Campaign Performance

-- ROAS(Revenue On Ad Spend)
SELECT 
	m.campaign,
    m.channel,
    ROUND(SUM(t.revenue)) as revenue,
    ROUND(SUM(m.spend)) as ad_spend,
    ROUND(SUM(t.revenue)/SUM(m.spend),2) as ROAS
FROM marketing_spend m
	LEFT JOIN crm_events c ON m.channel = c.channel
    LEFT JOIN transactions t on t.customer_id = c.customer_id
GROUP BY m.campaign, m.channel
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
    DATEDIFF(CURDATE(), MAX(STR_TO_DATE(transaction_date, '%m-%d-%Y'))) as recency_days,
    MAX(transaction_date),
    COUNT(*) as frequency,
    ROUND(SUM(revenue)) as monetary_value
FROM transactions
GROUP BY customer_id;

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
