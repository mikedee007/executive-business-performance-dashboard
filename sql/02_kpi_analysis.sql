-- Maven Fuzzy Factory: starter KPI analysis
-- SQL dialect: MySQL 8+
-- Definitions: sessions are counted by website_session_id; orders by order_id.
-- Revenue here is item-level listed revenue before refunds unless stated otherwise.

-- 1. Monthly sessions, orders and session-to-order conversion.
-- Orders are attributed to the month the session began.
SELECT
  DATE_FORMAT(s.created_at, '%Y-%m-01') AS session_month,
  COUNT(DISTINCT s.website_session_id) AS sessions,
  COUNT(DISTINCT o.order_id) AS orders,
  ROUND(100.0 * COUNT(DISTINCT o.order_id)
        / NULLIF(COUNT(DISTINCT s.website_session_id), 0), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders o
  ON s.website_session_id = o.website_session_id
GROUP BY DATE_FORMAT(s.created_at, '%Y-%m-01')
ORDER BY session_month;

-- 2. Monthly item revenue, refunds and net revenue.
-- Aggregate refunds to order first to avoid multiplying order-item rows.
WITH refunds_by_order AS (
  SELECT order_id, SUM(refund_amount_usd) AS refunds_usd
  FROM order_item_refunds
  GROUP BY order_id
),
sales_by_order AS (
  SELECT order_id, SUM(price_usd) AS item_revenue_usd,
         SUM(cogs_usd) AS item_cogs_usd
  FROM order_items
  GROUP BY order_id
)
SELECT
  DATE_FORMAT(o.created_at, '%Y-%m-01') AS order_month,
  COUNT(DISTINCT o.order_id) AS orders,
  ROUND(SUM(s.item_revenue_usd), 2) AS item_revenue_usd,
  ROUND(SUM(COALESCE(r.refunds_usd, 0)), 2) AS refunds_usd,
  ROUND(SUM(s.item_revenue_usd) - SUM(COALESCE(r.refunds_usd, 0)), 2) AS net_revenue_usd,
  ROUND(SUM(s.item_revenue_usd) - SUM(s.item_cogs_usd), 2) AS gross_profit_before_refunds_usd
FROM orders o
JOIN sales_by_order s ON o.order_id = s.order_id
LEFT JOIN refunds_by_order r ON o.order_id = r.order_id
GROUP BY DATE_FORMAT(o.created_at, '%Y-%m-01')
ORDER BY order_month;

-- 3. Marketing source and campaign performance.
SELECT
  COALESCE(s.utm_source, '(not set)') AS utm_source,
  COALESCE(s.utm_campaign, '(not set)') AS utm_campaign,
  COUNT(DISTINCT s.website_session_id) AS sessions,
  COUNT(DISTINCT o.order_id) AS orders,
  ROUND(100.0 * COUNT(DISTINCT o.order_id)
        / NULLIF(COUNT(DISTINCT s.website_session_id), 0), 2) AS conversion_rate_pct
FROM website_sessions s
LEFT JOIN orders o ON s.website_session_id = o.website_session_id
GROUP BY COALESCE(s.utm_source, '(not set)'),
         COALESCE(s.utm_campaign, '(not set)')
ORDER BY sessions DESC;

-- 4. Product performance. Revenue and COGS are summed from order_items.
SELECT
  p.product_id,
  p.product_name,
  COUNT(DISTINCT oi.order_id) AS orders_containing_product,
  COUNT(*) AS units_sold,
  ROUND(SUM(oi.price_usd), 2) AS item_revenue_usd,
  ROUND(SUM(oi.cogs_usd), 2) AS item_cogs_usd,
  ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS gross_profit_before_refunds_usd
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY item_revenue_usd DESC;

-- 5. Refund rate by product, measured as refunded order items / sold order items.
SELECT
  p.product_id,
  p.product_name,
  COUNT(DISTINCT oi.order_item_id) AS order_items_sold,
  COUNT(DISTINCT r.order_item_id) AS order_items_refunded,
  ROUND(100.0 * COUNT(DISTINCT r.order_item_id)
        / NULLIF(COUNT(DISTINCT oi.order_item_id), 0), 2) AS refunded_item_rate_pct,
  ROUND(COALESCE(SUM(r.refund_amount_usd), 0), 2) AS refunds_usd
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN order_item_refunds r ON oi.order_item_id = r.order_item_id
GROUP BY p.product_id, p.product_name
ORDER BY refunded_item_rate_pct DESC;
