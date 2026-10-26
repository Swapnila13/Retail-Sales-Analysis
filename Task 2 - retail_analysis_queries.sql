-- Retail Sales & Profitability Analysis
-- Dataset: Sample Superstore workbook (Orders, People, Returns)
-- SQLite syntax. Column names preserve the source workbook. Quote names containing spaces.

-- 1. Overall KPIs
SELECT
  ROUND(SUM("Sales"), 2) AS total_sales,
  ROUND(SUM("Profit"), 2) AS total_profit,
  ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"), 0), 2) AS profit_margin_pct,
  SUM("Quantity") AS total_quantity,
  COUNT(DISTINCT "Order ID") AS unique_orders
FROM orders;

-- 2. Sales and profit by category
SELECT "Category",
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit,
       ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"), 0), 2) AS margin_pct
FROM orders
GROUP BY "Category"
ORDER BY sales DESC;

-- 3. Region + regional manager JOIN
SELECT o."Region", p."Regional Manager",
       ROUND(SUM(o."Sales"), 2) AS sales,
       ROUND(SUM(o."Profit"), 2) AS profit
FROM orders o
LEFT JOIN people p ON o."Region" = p."Region"
GROUP BY o."Region", p."Regional Manager"
ORDER BY sales DESC;

-- 4. Discount levels associated with an overall loss
SELECT "Discount", COUNT(*) AS order_lines,
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit
FROM orders
GROUP BY "Discount"
HAVING SUM("Profit") < 0
ORDER BY "Discount";

-- 5. Lowest-profit sub-categories
SELECT "Category", "Sub-Category",
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit
FROM orders
GROUP BY "Category", "Sub-Category"
ORDER BY profit ASC
LIMIT 10;

-- 6. Top 10 customers by sales
SELECT "Customer ID", "Customer Name",
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit,
       COUNT(DISTINCT "Order ID") AS orders
FROM orders
GROUP BY "Customer ID", "Customer Name"
ORDER BY sales DESC
LIMIT 10;

-- 7. Monthly sales and profit trend
SELECT strftime('%Y-%m', "Order Date") AS order_month,
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit
FROM orders
GROUP BY strftime('%Y-%m', "Order Date")
ORDER BY order_month;

-- 8. JOIN returns to orders (deduplicate orders first so line items do not overcount returned orders)
WITH order_level AS (
  SELECT "Order ID", SUM("Sales") AS order_sales, SUM("Profit") AS order_profit,
         MAX("Region") AS region
  FROM orders
  GROUP BY "Order ID"
)
SELECT CASE WHEN r."Returned" = 'Yes' THEN 'Returned' ELSE 'Not Returned' END AS return_status,
       COUNT(DISTINCT o."Order ID") AS orders,
       ROUND(SUM(o.order_sales), 2) AS sales,
       ROUND(SUM(o.order_profit), 2) AS profit
FROM order_level o
LEFT JOIN returns r ON o."Order ID" = r."Order ID"
GROUP BY return_status;

-- 9. Subquery: orders whose total sales exceed the average order sales
WITH order_totals AS (
  SELECT "Order ID", SUM("Sales") AS order_sales
  FROM orders
  GROUP BY "Order ID"
)
SELECT "Order ID", ROUND(order_sales, 2) AS order_sales
FROM order_totals
WHERE order_sales > (SELECT AVG(order_sales) FROM order_totals)
ORDER BY order_sales DESC
LIMIT 20;

-- 10. Profitability flags by region
SELECT "Region",
       SUM(CASE WHEN "Profit" > 0 THEN 1 ELSE 0 END) AS profitable_lines,
       SUM(CASE WHEN "Profit" < 0 THEN 1 ELSE 0 END) AS loss_lines,
       SUM(CASE WHEN "Profit" = 0 THEN 1 ELSE 0 END) AS break_even_lines,
       ROUND(SUM("Profit"), 2) AS net_profit
FROM orders
GROUP BY "Region"
ORDER BY net_profit DESC;

-- 11. Ship mode performance
SELECT "Ship Mode", COUNT(DISTINCT "Order ID") AS orders,
       ROUND(SUM("Sales"), 2) AS sales,
       ROUND(SUM("Profit"), 2) AS profit,
       ROUND(AVG(julianday("Ship Date") - julianday("Order Date")), 2) AS avg_shipping_days
FROM orders
GROUP BY "Ship Mode"
ORDER BY orders DESC;

-- 12. Data quality: duplicate Row IDs (expected result: zero rows)
SELECT "Row ID", COUNT(*) AS occurrences
FROM orders
GROUP BY "Row ID"
HAVING COUNT(*) > 1;

-- 13. Data quality: missing values in important columns
SELECT
  SUM(CASE WHEN "Order ID" IS NULL OR TRIM("Order ID") = '' THEN 1 ELSE 0 END) AS missing_order_ids,
  SUM(CASE WHEN "Order Date" IS NULL THEN 1 ELSE 0 END) AS missing_order_dates,
  SUM(CASE WHEN "Customer Name" IS NULL OR TRIM("Customer Name") = '' THEN 1 ELSE 0 END) AS missing_customer_names,
  SUM(CASE WHEN "Sales" IS NULL THEN 1 ELSE 0 END) AS missing_sales,
  SUM(CASE WHEN "Profit" IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM orders;
