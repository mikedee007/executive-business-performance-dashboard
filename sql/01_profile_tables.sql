-- Starter profiling queries.
-- IMPORTANT: Confirm the real table and column names after downloading the CSVs.
-- These examples use common names from this dataset family; adapt only after schema inspection.

-- 1. Row counts
SELECT COUNT(*) AS row_count FROM website_sessions;
SELECT COUNT(*) AS row_count FROM website_pageviews;
SELECT COUNT(*) AS row_count FROM orders;
SELECT COUNT(*) AS row_count FROM order_items;
SELECT COUNT(*) AS row_count FROM order_item_refunds;
SELECT COUNT(*) AS row_count FROM products;

-- 2. Date coverage (adjust date column names if needed)
SELECT MIN(created_at) AS first_record, MAX(created_at) AS last_record
FROM website_sessions;

-- 3. Candidate key check (adjust names after inspection)
SELECT website_session_id, COUNT(*) AS records_per_id
FROM website_sessions
GROUP BY website_session_id
HAVING COUNT(*) > 1
ORDER BY records_per_id DESC;

-- 4. Null checks: repeat for important columns once the schema is confirmed.
SELECT
  SUM(CASE WHEN website_session_id IS NULL THEN 1 ELSE 0 END) AS null_session_ids
FROM website_sessions;
