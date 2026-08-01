# SQL-Portfolio-Project-E-Commerce-Sales-Customer-Analytics-Database
### 150 SQL Queries on a 77K-row e-commerce dataset — joins, subqueries, window functions, CTEs, RFM segmentation, and market basket analysis in MySQL.

A SQL portfolio project built on a relational e-commerce dataset, covering everything from basic
filtering to window functions, recursive CTEs, RFM segmentation, and market basket analysis.
The goal is to demonstrate the kind of querying a data analyst does day-to-day: understanding sales
performance, customer behavior, and fulfillment operations.

## Database

**`Customer_Analytics_db`** — 8 relational tables, 77,445 rows total.

| Table | Rows | Purpose |
|---|---|---|
| Categories | 20 | Product category reference data |
| Suppliers | 150 | Supplier information for sourced products |
| Employees | 100 | Staff records, departments, and reporting hierarchy |
| Customers | 5,000 | Customer profile & signup information |
| Products | 2,000 | Product catalog (pricing, stock, category, supplier) |
| Orders | 15,000 | Order-level transaction data (status, dates, shipping) |
| OrderItems | 45,175 | Line-item level detail for each order |
| Reviews | 10,000 | Customer product reviews and ratings |

## Query breakdown

| Section | Range | Focus |
|---|---|---|
| **Basic** | 1–55 | `SELECT`, `WHERE` / `IN` / `BETWEEN`, `ORDER BY`, `LIMIT`, `COUNT`/`SUM`/`AVG`/`MIN`/`MAX`, `GROUP BY` |
| **Intermediate** | 56–105 | `INNER`/`LEFT`/self joins, `HAVING`, subqueries, `CASE`, date & string functions |
| **Advanced** | 106–150 | Window functions (`RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `NTILE`, `PERCENT_RANK`), CTEs, recursive CTEs, market basket analysis, RFM segmentation, views |

The full question list is in [`docs/150_SQL_Questions.pdf`](150_SQL_Questions.pdf).

## Techniques demonstrated

- Multi-table joins (inner, left, self) for relational analysis
- Window functions — `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `NTILE`, `PERCENT_RANK`
- CTEs, including recursive CTEs for the employee/manager hierarchy
- Market basket analysis — frequently co-purchased product pairs
- RFM analysis (Recency, Frequency, Monetary) for customer segmentation
- Churn/retention-style analysis
- Reusable SQL views (`product_performance`, `customer_summary`)
- Conditional aggregation / pivot-style reporting with `CASE`
- Correlated subqueries for row-level comparisons

## Dataset snapshot

**Orders by status** (15,000 total)

| Status | Count | % |
|---|---|---|
| Delivered | 6,795 | 45.3% |
| Shipped | 2,988 | 19.9% |
| Processing | 2,214 | 14.8% |
| Pending | 1,492 | 10.0% |
| Cancelled | 912 | 6.1% |
| Returned | 599 | 4.0% |

**Other highlights**

| Metric | Value |
|---|---|
| Product price range | $5.38 – $1,999.20 |
| Active products | 1,807 (90.4%) |
| Discontinued products | 193 (9.6%) |
| Top customer country | USA — 1,200 customers |
| Review rating spread | ~2,000 reviews per star (1–5), evenly distributed |
| Largest employee department | Management — 14 employees |

More detail in [`docs/project_insights.md`](docs/project_insights.md).

## Tech stack

MySQL 8.0+ (window functions and CTEs require 8.0). Source data originated as an Excel workbook and
is included here as CSV for reproducibility.

---
*Part of a self-directed data analytics learning project.*
