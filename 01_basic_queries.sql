Create Database Customer_Analytics_db;
Use Customer_Analytics_db;

-- DATABASE SUMMARY & SCHEMA OVERVIEW ----
-- Dataset: E-Commerce Sales & Customer Analytics
-- -------------IMPORT 70,000 + ROWS-----------------

-- ---------------QUERY SECTIONS BREAKDOWN (150+ Queries)-------------------

-- * SECTION 1: Basic Queries (1-55)
--   - Single-table SELECT statements, filtering (WHERE, IN, BETWEEN), sorting (ORDER BY, LIMIT), 
--     basic aggregate functions (COUNT, SUM, AVG, MIN, MAX), and GROUP BY operations.

-- * SECTION 2: Intermediate Queries (56-105)
--   - Multi-table joins (INNER, LEFT, Self-Joins), conditional filtering with HAVING, subqueries, 
--     conditional logic using CASE statements, and date/string manipulation.

-- * SECTION 3: Advanced Queries (106-150)
--   - Window functions (RANK, ROW_NUMBER, LAG, LEAD, NTILE, PERCENT_RANK), 
--     Common Table Expressions (CTEs), Recursive CTEs for organizational hierarchies, 
--     Advanced Market Basket Analysis, Cohort & RFM Customer Analytics, and Views.

-- ============================================================================================================== ---

-- -------------------------* SECTION 1: Basic Queries (1-55)----------------------------------
--   - Single-table SELECT statements, filtering (WHERE, IN, BETWEEN), sorting (ORDER BY, LIMIT), 
--     basic aggregate functions (COUNT, SUM, AVG, MIN, MAX), and GROUP BY operations.


-- Retrieve All 8 TABLES(Categories, Customers, Employees , OrderItems (listed as Order Items),
-- 							Orders , Products ,Reviews, Suppliers ) 
#1. Categories Table
Select * From categories;
#2. Customers Table
Select * From customers;
#3.Employees Table
Select * From employees;
#4. Orederitems Table
Select * From orderitems;
#5. Orders Table
Select * From orders;
#6. Products Table
Select * From products;
#7.Reviews Table
Select * From reviews;
#8. Suppliers Table
Select * From suppliers;

# 9.Get the distinct countries customers live in.
Select Distinct country
From Customers;

# 10.Get the distinct cities suppliers operate from.
Select Distinct city
From Customers;

# 11.Find products priced above $500
Select product_name, unit_price
From Products
Where unit_price > 500;

# 12.Find customers from the USA.
Select *
From Customers
Where Country = 'USA';

# 13.Find orders with status 'Delivered'.
Select *
From Orders
Where status = 'Delivered';

#14.Find employees in the IT department.
Select *
From Employees
Where Department = 'IT';

# 15.Find products with stock quantity below 100.
Select product_name, stock_quantity
From Products
Where stock_quantity < 100;

#16.Top 10 most expensive products.
Select product_name , unit_price
From Products
Order By unit_price DESC
LIMIT 10;

#17. Customers who signed up in 2024.
Select *
From Customers
Where signup_date = 2024;

#18. Orders placed after Jan 1, 2025.
Select *
From Orders
Where order_date > '2025-01-01';

#19.Reviews with a 5-star rating.
Select *
From Reviews
Where Rating = 5;

#20. Employees hired before 2020.
Select *
From Employees
Where hire_date < '2020';

#21. Products that are discontinued.
Select *
From Products
Where discontinued = 1;

#22.Count total number of customers.
Select COUNT(*) as Total_Customers
From Customers;

#23.Count total number of products.
Select COUNT(*) as Total_Products
From Products;

#24.Count total number of orders.
Select COUNT(*) as Total_Orders
From Orders;

#25.Count total number of employees.
Select COUNT(*) as Total_Employees
From Employees;

#26.Average unit price of all products.
Select AVG(unit_price) as Avg_Price
From Products;

#27.Maximum salary among employees.
Select MAX(salary) as Max_Salary
From Employees;

#28. Minimum salary among employees.
Select MIN(salary) as Max_Salary
From Employees;

#29.Total shipping cost collected across all orders.
Select SUM(shipping_cost) as Total_Shipping
From Orders;

#30.Count of orders grouped by status.
Select status, COUNT(*) as order_count
From Orders
Group BY status;

#31.Count of customers grouped by country.
Select country, COUNT(*) as customer_count
From Customers
Group By country
Order By customer_count DESC;

#32.Count of products grouped by category_id.
Select category_id, COUNT(*) as product_count
From Products
Group By category_id;

#33. Average product price grouped by category.
Select category_id, AVG(unit_price) as Avg_Price
From Products
Group By category_id;

#34. Customers whose first name starts with 'A'.
Select *
From Customers
Where first_name LIKE 'A%';

#35. Products with 'Pro' in the name.
Select *
From Products
Where product_name LIKE '%Pro%';

#36. Customers not from the USA.
Select *
From Customers
Where country != 'USA';

#37. Orders placed between January 2024 and December 2024.
Select *
From Orders
Where order_date BETWEEN '2024-01-01' AND '2024-12-31';

#38.Products priced between 100 and 500.
Select *
From Products
Where unit_price BETWEEN 100 AND 500;

#39.Employees who have no manager (top-level).
Select *
From Employees
Where manager_id IS NULL;

#40. Orders that haven't shipped yet.
Select *
From Orders
Where ship_date IS Null;

#41. Get the first 5 customers by ID.
Select *
From Customers
Order By customer_id ASC
LIMIT 5;

#42. Get the 5 most recently hired employees.
Select *
From Employees
Order By hire_date DESC
LIMIT 5;

#43. List all distinct order statuses.
Select DISTINCT(status)
From Orders;

#44. List all distinct departments.
Select DISTINCT(department)
From Employees;

#45. Suppliers based in Japan or Germany.
Select *
From Suppliers
Where country IN('Japan', 'Germany');

#46. Products that are still active (not discontinued).
Select *
From Products
Where discontinued = 0;

#47. Get email addresses of all customers.
Select email
From Customers;

#48. Count the number of distinct categories.
Select COUNT(DISTINCT category_id) as Category_Count
From Categories;

#49. Count the number of distinct suppliers actually used by products.
Select COUNT(DISTINCT supplier_id) as Supplier_used
From Products;

#50. Total quantity ordered across all order items.
Select SUM(quantity) as Total_units_sold
From OrderItems;

#51. Average discount applied across all orderitems.
Select AVG(discount) as Avg_discount
From OrderItems;

#52.Employees ordered by salary, highest first.
Select first_name, last_name, salary
From Employees
Order By Salary DESC
LIMIT 1;

#53. Products ordered by stock quantity, lowest first.
Select product_name, stock_quantity
From Products
Order By stock_quantity ASC;

#54. Reviews mentioning the word 'recommend'.
Select *
From Reviews
Where review_text LIKE '%recommend%';

#55. Customers whose phone number contains a specific area code pattern.
Select *
From Customers
Where phone LIKE '+1-212%';

# ================================================================================================================ #

