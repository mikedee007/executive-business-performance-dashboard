-- KPI analysis templates.
-- Verify source column names, grain, date attribution and refund treatment first.

-- Sessions by month
SELECT
  DATE_TRUNC('month', created_at) AS month,
  COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
GROUP BY 1
ORDER BY 1;

-- Orders by month
SELECT
  DATE_TRUNC('month', created_at) AS month,
  COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY 1
ORDER BY 1;

-- Revenue by month (confirm revenue column and whether this is gross/net)
SELECT
  DATE_TRUNC('month', created_at) AS month,
  SUM(price_usd) AS gross_item_revenue
FROM order_items
GROUP BY 1
ORDER BY 1;

-- These queries are intentionally separate starter examples. A final conversion
-- analysis must define how sessions are attributed to orders and align date logic.
