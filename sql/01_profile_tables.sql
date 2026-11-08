-- Maven Fuzzy Factory: initial data profiling
-- SQL dialect: MySQL 8+
-- Tables/columns below were checked against the supplied CSV headers.
-- Import the six business CSVs as tables with these exact names before running.

-- 1. Row counts: compare these with the CSV row counts.
SELECT 'website_sessions' AS table_name, COUNT(*) AS row_count FROM website_sessions
UNION ALL SELECT 'website_pageviews', COUNT(*) FROM website_pageviews
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_item_refunds', COUNT(*) FROM order_item_refunds
UNION ALL SELECT 'products', COUNT(*) FROM products;

-- 2. Date coverage for each event table.
SELECT 'website_sessions' AS table_name, MIN(created_at) AS first_record, MAX(created_at) AS last_record FROM website_sessions
UNION ALL SELECT 'website_pageviews', MIN(created_at), MAX(created_at) FROM website_pageviews
UNION ALL SELECT 'orders', MIN(created_at), MAX(created_at) FROM orders
UNION ALL SELECT 'order_items', MIN(created_at), MAX(created_at) FROM order_items
UNION ALL SELECT 'order_item_refunds', MIN(created_at), MAX(created_at) FROM order_item_refunds
UNION ALL SELECT 'products', MIN(created_at), MAX(created_at) FROM products;

-- 3. Check candidate primary keys. Each query should return zero rows.
SELECT website_session_id, COUNT(*) AS records_per_id
FROM website_sessions GROUP BY website_session_id HAVING COUNT(*) > 1;
SELECT website_pageview_id, COUNT(*) AS records_per_id
FROM website_pageviews GROUP BY website_pageview_id HAVING COUNT(*) > 1;
SELECT order_id, COUNT(*) AS records_per_id
FROM orders GROUP BY order_id HAVING COUNT(*) > 1;
SELECT order_item_id, COUNT(*) AS records_per_id
FROM order_items GROUP BY order_item_id HAVING COUNT(*) > 1;
SELECT order_item_refund_id, COUNT(*) AS records_per_id
FROM order_item_refunds GROUP BY order_item_refund_id HAVING COUNT(*) > 1;
SELECT product_id, COUNT(*) AS records_per_id
FROM products GROUP BY product_id HAVING COUNT(*) > 1;

-- 4. Important missing values in session acquisition fields.
SELECT
  COUNT(*) AS total_sessions,
  SUM(utm_source IS NULL) AS null_utm_source,
  SUM(utm_campaign IS NULL) AS null_utm_campaign,
  SUM(utm_content IS NULL) AS null_utm_content,
  SUM(http_referer IS NULL) AS null_http_referer
FROM website_sessions;

-- 5. Relationship checks. Each query should return zero rows.
SELECT p.website_session_id
FROM website_pageviews p
LEFT JOIN website_sessions s ON p.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;

SELECT o.website_session_id
FROM orders o
LEFT JOIN website_sessions s ON o.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;

SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT oi.product_id
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT r.order_item_id
FROM order_item_refunds r
LEFT JOIN order_items oi ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;
