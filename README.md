Retail Sales & Profitability Analysis
An analysis of the Sample Superstore retail dataset to explore sales performance, profitability, discounting, regional trends, and returns using Excel, SQL, and Python.
Overview
Retail sales totals do not tell the whole story: a product or region can generate high sales while contributing less profit. This analysis looks at sales and profit together to identify patterns that may be useful for business decisions.
Tools
- Microsoft Excel — data checks, lookup/enrichment, summary tables, PivotTable-style analysis, and conditional formatting
- SQL (SQLite) — aggregations, KPI calculations, joins, subqueries, returns analysis, and data-quality checks
- Python — exploratory data analysis using Pandas and visualizations
- HTML dashboard — interactive browser-based view of selected KPIs and charts

Analysis Performed
Excel
- Checked selected fields for data-quality issues
- Enriched order records using a regional-manager lookup
- Summarized sales and profit by category, region, and discount
- Used conditional formatting to highlight loss-making records
SQL
- Calculated overall sales, profit, and other key metrics
- Aggregated performance by category, region, and sub-category
- Used joins to combine related tables
- Explored returns and discount-related profitability
- Included data-quality queries
Python EDA
- Inspected dataset structure and selected data-quality indicators
- Explored sales and profit patterns across product and regional groups
- Used visualizations to communicate trends and comparisons
Selected Findings
Based on the supplied dataset and the accompanying analysis files:
- Total sales: $2,326,534.35
- Total profit: $292,296.81
- Overall profit margin: 12.56%
- Unique orders: 5,111
- Quantity sold: 38,654
- Technology was the leading category by sales and profit in this analysis.
- The West region led by sales and profit.
- Tables had the lowest total profit among sub-categories.
- 1,901 order lines (18.6%) recorded negative profit.
These findings describe this dataset; they should not be treated as universal retail benchmarks. Negative-profit records and discount patterns warrant further investigation rather than proving that a single factor caused a loss.
