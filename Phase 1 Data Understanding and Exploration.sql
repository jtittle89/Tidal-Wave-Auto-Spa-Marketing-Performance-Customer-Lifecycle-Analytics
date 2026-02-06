-- Display all tables in the schema 
SHOW tables;

-- Inspection of table structures
DESCRIBE crm_events;
DESCRIBE customer_service;
DESCRIBE customers;
DESCRIBE marketing_spend;
DESCRIBE nps_reviews;
DESCRIBE transactions;

-- Count of all rows in each table
SELECT 'crm_events' as table_name, COUNT(*) row_count FROM crm_events
UNION ALL
SELECT 'customer_service', COUNT(*) FROM customer_service
UNION ALL 
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'marketing_spend', COUNT(*) FROM marketing_spend
UNION ALL
SELECT 'nps_reviews', COUNT(*) FROM nps_reviews
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions;

-- Identifying Null Values
SELECT
	SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END) AS missing_event_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN event_type IS NULL THEN 1 ELSE 0 END) AS missing_event_type,
    SUM(CASE WHEN event_date IS NULL THEN 1 ELSE 0 END) AS missing_event_date,
    SUM(CASE WHEN channel IS NULL THEN 1 ELSE 0 END) AS missing_channel
FROM crm_events;

SELECT
	SUM(CASE WHEN ticket_id IS NULL THEN 1 ELSE 0 END) AS missing_ticket_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN issue_type IS NULL THEN 1 ELSE 0 END) AS missing_issue_type,
    SUM(CASE WHEN resolution_time_minutes IS NULL THEN 1 ELSE 0 END) AS missing_resolution_time,
    SUM(CASE WHEN csat_score IS NULL THEN 1 ELSE 0 END) AS missing_csat_score
FROM customer_service;

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END) AS missing_signup_date,
    SUM(CASE WHEN signup_channel IS NULL THEN 1 ELSE 0 END) AS missing_signup_channel,
	SUM(CASE WHEN campaign IS NULL THEN 1 ELSE 0 END) AS missing_campaign,
    SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END) AS missing_location_id,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS missing_state,
	SUM(CASE WHEN membership_type IS NULL THEN 1 ELSE 0 END) AS missing_membership_type,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN income_band IS NULL THEN 1 ELSE 0 END) AS missing_income_band,
    SUM(CASE WHEN vehicle_type IS NULL THEN 1 ELSE 0 END) AS missing_vehicle_type
FROM customers;

SELECT
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN channel IS NULL THEN 1 ELSE 0 END) AS missing_channel,
    SUM(CASE WHEN campaign IS NULL THEN 1 ELSE 0 END) AS missing_campaign,
	SUM(CASE WHEN ad_group IS NULL THEN 1 ELSE 0 END) AS missing_ad_group,
    SUM(CASE WHEN spend IS NULL THEN 1 ELSE 0 END) AS missing_spend,
    SUM(CASE WHEN impressions IS NULL THEN 1 ELSE 0 END) AS missing_impressions,
    SUM(CASE WHEN clicks IS NULL THEN 1 ELSE 0 END) AS missing_clicks,
	SUM(CASE WHEN conversions IS NULL THEN 1 ELSE 0 END) AS missing_conversions
FROM marketing_spend;

SELECT
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS missing_review_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN review_date IS NULL THEN 1 ELSE 0 END) AS missing_review_date,
	SUM(CASE WHEN nps_score IS NULL THEN 1 ELSE 0 END) AS missing_nps_score,
	SUM(CASE WHEN sentiment IS NULL THEN 1 ELSE 0 END) AS missing_sentiment
FROM nps_reviews;

SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS missing_transaction_date,
	SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END) AS missing_location_id,
    SUM(CASE WHEN service_type IS NULL THEN 1 ELSE 0 END) AS missing_service_type,
    SUM(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) AS missing_revenue,
	SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS missing_payment_type
FROM transactions;

-- Identifying duplicate primary keys
SELECT customer_id, COUNT(*) as customer_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT ticket_id, COUNT(*) as ticket_count
FROM customer_service
GROUP BY ticket_id
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*) as review_count
FROM nps_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT(*) as transaction_count
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Invalid values
SELECT *
FROM crm_events
WHERE event_date > curdate();

SELECT *
FROM customer_service
WHERE resolution_time_minutes < 0 OR csat_score NOT BETWEEN 0 AND 5;

SELECT *
FROM customers
WHERE signup_date > curdate();

SELECT *
FROM marketing_spend
WHERE 
	date > curdate() OR
    spend < 0 OR
    impressions < 0 OR
    clicks < 0 OR
    conversions < 0;
    
SELECT *
FROM nps_reviews
WHERE review_date > curdate() OR nps_score NOT BETWEEN 0 AND 10;