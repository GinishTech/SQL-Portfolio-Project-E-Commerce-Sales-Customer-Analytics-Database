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

-- ----------------------* SECTION 2: Intermediate Queries (56-105)------------------------------
--   - Multi-table joins (INNER, LEFT, Self-Joins), conditional filtering with HAVING, subqueries, 
--     conditional logic using CASE statements, and date/string manipulation.

#56.List orders along with the customer's name.
Select o.order_id, c.first_name, c.last_name, o.order_date, o.status
From Orders as o
Join customers as c ON o.customer_id = c.customer_id;

#57. List order items along with the product name.
Select oi.order_item_id, p.product_name, oi.quantity, oi.unit_price
From OrderItems as oi
Join Products as p ON oi.product_id = p.product_id;

#58. List products along with their category name.
Select p.product_name, c.category_name
From Products as p
Join Categories as c ON p.category_id = c.category_id;

#59. List products along with their supplier name.
Select p.product_name, s.supplier_name
From Products as p
Join Suppliers as s ON p.supplier_id = s.supplier_id;

#60.List each employee with their manager's name (self join).
Select e.first_name as Employee , m.first_name as Manager
From Employees as e
Left Join Employees as m ON e.manager_id = m.employee_id;

#61. List orders along with the employee who processed them.
Select o.order_id, e.first_name, e.last_name, o.order_date
From Orders as o
Join Employees as e ON o.employee_id = e.employee_id;

#62. List reviews with product name and customer name (two joins).
Select r.review_id, p.product_name, c.first_name, c.last_name, r.rating
From Reviews as r
Join Products as p ON r.product_id = p.product_id
Join Customers as c ON r.customer_id = c.customer_id;

#63. Total revenue per order (accounting for discount).
Select order_id, SUM(quantity * unit_price * (1 - discount)) as Order_Revenue
From OrderItems
Group by order_id;

#64. Total amount spent per customer.
Select o.customer_id, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Total_spent
From Orders as o
Join OrderItems as oi ON o.order_id = oi.order_id
Group By o.customer_id
Order By total_spent DESC;

#65. Customers with more than 5 orders.
Select customer_id , COUNT(*) as order_count
From Orders
Group By customer_id
Having COUNT(*) > 5 ;

#66. Number of orders handled per employee.
Select employee_id,COUNT(*) as Orders_handled
From Orders
Group By employee_id
Order By orders_handled DESC;

#67. Products with an average rating above 4.
Select product_id, AVG(rating) as Avg_rating
From Reviews
Group By product_id
Having AVG(rating) > 4;

#68. Total quantity sold per product.
Select product_id, SUM(quantity) as Total_Sold
From OrderItems
Group By Product_id
Order By Total_Sold DESC;

#69. Categories with more than 50 products.
Select category_id, COUNT(*) as product_count
From Products
Group By category_id
Having COUNT(*) > 50;

#70.Customers with more than 10 orders.
Select customer_id, COUNT(*) as Order_Count
From Orders
Group By customer_id
Having COUNT(*) > 10;

#71. Products that have never been ordered.
Select p.product_id, p.product_name
From Products as p
Left Join OrderItems as oi ON p.product_id = oi.product_id
Where oi.order_item_id IS Null;

#72. Customers who have never placed an order.
Select c.customer_id, c.first_name, c.last_name,o.order_id
From Customers as c
Left Join Orders as o ON c.customer_id = o.customer_id
Where o.order_id IS NULL ;

#73. Products with no reviews.
Select p.product_id, p.product_name
From Products as p
Left Join Reviews as r ON p.product_id = r.product_id
Where r.review_id IS NULL ;

#74. Employees who have processed more than 100 orders.
Select employee_id, COUNT(order_id) as orders_handled
From Orders
Group By employee_id
Having COUNT(*) > 100;

#75. Orders placed by the single highest-spending customer.
Select *
From Orders
Where customer_id = (
		Select o.customer_id
        From Orders as o
        Join OrderItems as oi ON o.order_id = oi.order_id
        Group By  o.customer_id
        Order By SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC
        Limit 1
        );

#76. Products priced above the overall average product price.
Select product_name, unit_price
From Products
Where unit_price > (Select AVG(unit_price)
					From Products);

#77. Customers who spent more than the average customer's total spend.
SELECT customer_id, total_spent FROM (
SELECT o.customer_id, SUM(oi.quantity *
oi.unit_price * (1 - oi.discount)) AS
total_spent
FROM Orders o
JOIN OrderItems oi ON o.order_id =
oi.order_id
GROUP BY o.customer_id
) t
WHERE total_spent > (
SELECT AVG(total_spent) FROM (
SELECT o.customer_id,
SUM(oi.quantity * oi.unit_price * (1 -
oi.discount)) AS total_spent
FROM Orders o
JOIN OrderItems oi ON o.order_id =
oi.order_id
GROUP BY o.customer_id
) t2
);

#78.Find the second highest priced product.
Select product_name, unit_price
From Products
Order By unit_price DESC
LIMIT 1 OFFSET 1;

#79.Products supplied by suppliers based in the USA.
Select p.product_name, s.supplier_name, s.country
From Products as p
Join Suppliers as s ON p.supplier_id = s.supplier_id
Where s.country = 'USA';

#80. Categorize orders by shipping cost (Low/Medium/High) using CASE.
Select order_id, shipping_cost,
	CASE
		When shipping_cost < 15 then 'Low'
        When shipping_cost Between 15 And 40 then 'Medium'
        Else 'High'
        End As Shipping_tier
From Orders ;

#81.Categorize products into price bands using CASE.
Select product_name, unit_price,
	CASE
		When unit_price < 100 Then 'Budget'
        When unit_price Between 100 And 500 Then 'Mid Range'
        Else 'Premium'
        End as Price_band
From Products;

#82. Number of orders placed per year.
Select YEAR(order_date) as Order_year, COUNT(*) as Total_Orders
From Orders
Group By YEAR(order_date)
Order By Order_year;

#83. New customer sign-ups per month.
Select YEAR(signup_date) as Year, MONTH(signup_date) as Month, COUNT(*) as New_customers
From Customers
Group By YEAR(signup_date), MONTH(signup_date)
Order By Year , Month;

#84. Orders placed in the last 30 days (relative to the most recent order).
Select *
From Orders
Where order_date >= (Select MAX(order_date)
					From Orders) - INTERVAL 30 Day;

#85. Employee tenure in years.
Select first_name, last_name, hire_date, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) as Years_of_Service
From Employees;

#86. Customers whose email domain is 'mail.com'.
Select *
From Employees
Where email Like '%mail.com';

#87. Full name of each customer using CONCAT.
Select CONCAT(first_name, ' ', last_name) as Full_name
From Customers;

#88. Product names in uppercase and lowercase.
Select product_name, UPPER(product_name) as Upper_Name, LOWER(product_name) as Lower_Name
From Products;

#89. Length of each product name.
Select product_name, LENGTH(product_name) as Name_length
From Products
Order By Name_length DESC;

#90.Orders with total order value computed via a correlated subquery.
Select o.order_id, o.order_date,
	(Select SUM(oi.quantity * oi.unit_price * (1 - oi.discount))
    From orderItems as oi
    Where oi.order_id = o.order_id) as Order_Total
From Orders as o;

#91. Top 3 categories by total revenue.
Select c.category_name, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Revenue
From OrderItems as oi
Join Products as p ON oi.product_id = p.product_id
Join Categories as c ON p.category_id = c.category_id
Group By Category_name
Order By Revenue DESC
LIMIT 3;

#92. Top 5 products by total revenue.
Select p.product_name, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Revenue
From OrderItems as oi
Join Products as p ON oi.product_id = p.product_id
Group By p.product_name
Order By Revenue DESC
Limit 5;

#93. Monthly revenue trend.
Select YEAR(o.order_date) as Year, MONTH(o.order_date) as Month,
		SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Monthly_Revenue
From Orders as o
Join OrderItems as oi ON o.order_id = oi.order_id
Group By YEAR(o.order_date), MONTH(o.order_date)
Order By Year , Month;

#94. Total revenue by customer country.
Select c.country , SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Total_Revenue
From Customers as c
Join Orders as o ON c.customer_id = o.customer_id
Join OrderItems as oi ON oi.order_id = o.order_id
Group By c.country
Order By Total_Revenue;

#95.Total revenue generated per employee (sales performance).
Select e.employee_id, e.first_name,e.last_name,
		SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Revenue_Generated
From Employees as e
Join Orders as o ON e.employee_id = o.employee_id
Join OrderItems as oi ON o.order_id = oi.order_id
Group By e.employee_id , e.first_name, e.last_name
Order By Revenue_Generated DESC;

#96.Average order value (AOV) per customer.
Select o.customer_id, AVG(oi.line_total) as Avg_Order_Value
From Orders as o
Join(
	Select order_id, SUM(quantity * unit_price * (1 - discount)) as line_total
    From OrderItems
    Group By Order_id) as oi ON o.order_id = oi.order_id
Group By o.customer_id
Order By Avg_Order_Value DESC;

#97. Customers who have at least one cancelled order.
Select DISTINCT c.customer_id, c.first_name, c.last_name
From Customers as c
Join Orders as o ON c.customer_id = o.customer_id
Where o.status = 'Cancelled';

#98.Discontinued products that still have reviews.
Select p.product_name, COUNT(r.review_id) as Review_Count
From Products as p
Join Reviews as r ON p.product_id = r.product_id
Where p.discontinued = 1
Group By p.product_name;

#99. Orders with shipping cost above the overall average shipping cost.
Select *
From Orders
Where shipping_cost > (Select AVG(shipping_cost) From Orders);

#100. Managers and how many direct reports each one has.
Select m.employee_id, m.first_name, m.last_name, COUNT(e.employee_id) as Direct_Reports
From Employees as m
Join Employees as e ON e.manager_id = m.manager_id
Group By m.employee_id, m.first_name,m.last_name
Order By Direct_Reports DESC;

#101. Count of reviews for each rating value (1–5).
Select rating, COUNT(*) as Review_Count
From Reviews
Group By Rating
Order By Rating;

#102. Percentage of orders in each status.
Select status, COUNT(*) as Total, ROUND(COUNT(*) * 100.0 / (Select COUNT(*) From Orders), 2) as Percentage
From Orders
Group By status;

#103. Suppliers who supply products across more than 3 different categories.
Select s.supplier_id, s.supplier_name, COUNT(DISTINCT p.category_id) as Category_count
From Suppliers as s
Join Products as p ON s.supplier_id = p.supplier_id
Group By s.supplier_id, s.supplier_name
Having COUNT(DISTINCT p.category_id) > 3;

#104.Categories whose average product price is above the overall average.
SELECT category_id, AVG(unit_price) AS category_avg
FROM Products
GROUP BY category_id
HAVING AVG(unit_price) > (SELECT
AVG(unit_price) FROM Products);

#105. Orders that contain more than 3 order items (large basket orders).
SELECT order_id, COUNT(*) AS item_count
FROM OrderItems
GROUP BY order_id
HAVING COUNT(*) > 3;


# ======================================================================================================================== #

-- * -------------------------------------SECTION 3: Advanced Queries (106-150)--------------------------------------------
--   - Window functions (RANK, ROW_NUMBER, LAG, LEAD, NTILE, PERCENT_RANK), 
--     Common Table Expressions (CTEs), Recursive CTEs for organizational hierarchies, 
--     Advanced Market Basket Analysis, Cohort & RFM Customer Analytics, and Views.

#106.Rank products by price within each category.
Select product_id, product_name, category_id, unit_price,
		RANK() OVER (PARTITION BY category_id Order By Unit_price DESC) as Price_Rank
From Products ;

#107. Assign a sequence number to each customer's orders (order 1, 2, 3...).
Select order_id , customer_id, order_date,
		ROW_NUMBER() OVER (PARTITION BY customer_id Order By order_date) as Order_Sequence
From Orders ;

#108. Running total of daily revenue.
Select order_date, SUM(daily_revenue) OVER (ORDER BY order_date) as Running_Total
From ( Select o.order_date, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Daily_Revenue
		From Orders as o
        Join OrderItems as oi ON o.order_id = oi.order_id
        Group By o.order_date
		)daily;

#109. Top 3 highest-revenue products within each category.
Select * 
From ( Select p.category_id, p.product_name, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as Revenue,
		RANK() OVER (PARTITION BY p.category_id Order By SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC) as Rnk
        From OrderItems as oi
        Join products as p ON oi.product_id = p.product_id
        Group By p.category_id, p.product_name) Ranked
Where rnk <= 3;
        
#110. Each customer's first and most recent order date.
Select customer_id, MIN(order_date) OVER (PARTITION BY customer_id) as First_Order,
					MAX(order_date) OVER (PARTITION BY customer_id) as Last_Order
From Orders;
        
#111. Month-over-month revenue growth percentage.
WITH monthly AS (
SELECT YEAR(o.order_date) AS yr,
MONTH(o.order_date) AS mo,
SUM(oi.quantity * oi.unit_price
* (1 - oi.discount)) AS revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id =
oi.order_id
GROUP BY YEAR(o.order_date),
MONTH(o.order_date)
)
SELECT yr, mo, revenue,
LAG(revenue) OVER (ORDER BY yr, mo)
AS prev_month_revenue,
ROUND((revenue - LAG(revenue) OVER
(ORDER BY yr, mo)) * 100.0
/ LAG(revenue) OVER (ORDER BY
yr, mo), 2) AS growth_pct
FROM monthly;

#112. Days between each customer's consecutive orders.
SELECT customer_id, order_id, order_date,
DATEDIFF(order_date, LAG(order_date)
OVER (PARTITION BY customer_id ORDER BY
order_date)) AS days_since_last_order
FROM Orders;

#113. Each customer's next order date (LEAD).
SELECT customer_id, order_id, order_date,
LEAD(order_date) OVER (PARTITION BY
customer_id ORDER BY order_date) AS
next_order_date
FROM Orders;

#114. Cumulative count of new customers by signup month.
WITH monthly_signups AS(
						Select Year(signup_date) as Yr ,
                        Month(signup_date) as Mo, COUNT(*) as New_Customers
                        From Customers
                        Group By Year(signup_date), Month(signup_date))
Select Yr, Mo, New_Customers,
		SUM(New_Customers) OVER (ORDER BY Yr, Mo) AS Cumulative_Customers
From monthly_signups;

#115. Percentile rank of each product's price.
SELECT product_name, unit_price,
Round(PERCENT_RANK() OVER (ORDER BY
unit_price),2) AS price_percentile
FROM Products;

#116.Divide customers into 4 spending quartiles (NTILE).
WITH customer_spend AS(
						Select o.customer_id , SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) As Total_Spent
                        From Orders as O
                        Join OrderItems as oi ON o.order_id = oi.order_id
                        Group By o.customer_id
                        )
Select customer_id , Total_Spent,
		NTILE(4) OVER (ORDER BY Total_Spent DESC) as Spend_Quartile
From customer_spend;

#117. 7-day moving average of daily revenue.
WITH Daily As(
			Select o.order_date, SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) As Revenue
            From Orders as o
            Join OrderItems as oi ON o.order_id = oi.order_id
            Group By o.order_date
            )
Select order_date, Revenue,
		AVG(Revenue) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) As Moving_Avg_7Days
From Daily;

#118.Pivot order counts by status into columns (conditional aggregation).
SELECT
COUNT(CASE WHEN status = 'Pending' THEN
1 END) AS pending,
COUNT(CASE WHEN status = 'Processing'
THEN 1 END) AS processing,
COUNT(CASE WHEN status = 'Shipped' THEN
1 END) AS shipped,
COUNT(CASE WHEN status = 'Delivered'
THEN 1 END) AS delivered,
COUNT(CASE WHEN status = 'Cancelled'
THEN 1 END) AS cancelled,
COUNT(CASE WHEN status = 'Returned'
THEN 1 END) AS returned
FROM Orders;

#119.Pivot monthly revenue into columns per year (Jan–Dec across columns).
SELECT
YEAR(o.order_date) AS yr,
SUM(CASE WHEN MONTH(o.order_date) = 1
THEN oi.quantity * oi.unit_price * (1 -
oi.discount) ELSE 0 END) AS jan,
SUM(CASE WHEN MONTH(o.order_date) = 2
THEN oi.quantity * oi.unit_price * (1 -
oi.discount) ELSE 0 END) AS feb,
SUM(CASE WHEN MONTH(o.order_date) = 3
THEN oi.quantity * oi.unit_price * (1 -
oi.discount) ELSE 0 END) AS mar,
SUM(CASE WHEN MONTH(o.order_date) = 12
THEN oi.quantity * oi.unit_price * (1 -
oi.discount) ELSE 0 END) AS dec_
FROM Orders o
JOIN OrderItems oi ON o.order_id =
oi.order_id
GROUP BY YEAR(o.order_date);

#120.Customers who haven't ordered in the last 6 months (churn risk).
Select c.customer_id, c.first_name, c.last_name, MAX(o.order_date) as last_order
From Customers as c
Left Join Orders as o ON c.customer_id = o.customer_id
Group By c.customer_id, c.first_name, c.last_name
Having MAX(o.order_date) < (Select
							MIN(order_date)
                            From Orders) - INTERVAL 6 Month 
                            OR MAX(o.order_date) IS NULL ;

#121. Employees who share the same department (self join).
SELECT e1.first_name AS employee_1,
e2.first_name AS employee_2, e1.department
FROM Employees e1
JOIN Employees e2 ON e1.department =
e2.department AND e1.employee_id <
e2.employee_id
ORDER BY e1.department;

#122. Find duplicate customer emails, if any.
SELECT email, COUNT(*) AS occurrences
FROM Customers
GROUP BY email
HAVING COUNT(*) > 1;

#123. Products priced identically to another product (self join).
SELECT p1.product_name AS product_a,
p2.product_name AS product_b, p1.unit_price
FROM Products p1
JOIN Products p2 ON p1.unit_price =
p2.unit_price AND p1.product_id <
p2.product_id;

#124. Most recent order for each customer (window function + filter).
SELECT * FROM (
SELECT o.*, ROW_NUMBER() OVER
(PARTITION BY customer_id ORDER BY
order_date DESC) AS RN
FROM Orders o
) t
WHERE RN = 1;

#125. Customers who have ordered products from every single category ("relational division").
SELECT o.customer_id
FROM Orders as o
JOIN OrderItems as oi ON o.order_id = oi.order_id
JOIN Products as p ON oi.product_id = p.product_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.category_id) =
(SELECT COUNT(*) FROM Categories);

#126. Product pairs frequently purchased together (market basket analysis).
SELECT a.product_id AS product_a,
b.product_id AS product_b, COUNT(*) AS
times_bought_together
FROM OrderItems as  a
JOIN OrderItems as b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC
LIMIT 20 ;

#127. Top 3 suppliers by total revenue generated through their products.
SELECT s.supplier_name, SUM(oi.quantity *
		oi.unit_price * (1 - oi.discount)) AS Revenue
FROM Suppliers as s
JOIN Products as p ON s.supplier_id = p.supplier_id
JOIN OrderItems as oi ON p.product_id = oi.product_id
GROUP BY s.supplier_name
ORDER BY revenue DESC
LIMIT 3;

#128. Products that have never been purchased by anyone (NOT EXISTS).
SELECT p.product_id, p.product_name
FROM Products as p
WHERE NOT EXISTS (
SELECT * FROM OrderItems oi WHERE
oi.product_id = p.product_id
);

#129. Employees who have never handled a cancelled order.
SELECT e.employee_id, e.first_name, e.last_name
FROM Employees as e
WHERE NOT EXISTS (
SELECT 1 FROM Orders o
WHERE o.employee_id = e.employee_id AND
o.status = 'Cancelled'
);

#130. Impact of discounts on total revenue (actual revenue vs. revenue without any discount).
SELECT SUM(quantity * unit_price) AS revenue_without_discount,
		SUM(quantity * unit_price * (1 - discount)) AS actual_revenue,
		SUM(quantity * unit_price * discount) AS total_discount_given
From OrderItems;

#131.Day of the week with the highest number of orders.
SELECT DAYNAME(order_date) AS day_of_week, COUNT(*) AS total_orders
FROM Orders
GROUP BY DAYNAME(order_date)
ORDER BY total_orders DESC;

#132. Suppliers with zero discontinued products (all active).
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
WHERE NOT EXISTS (
SELECT 1 FROM Products p
WHERE p.supplier_id = s.supplier_id AND
p.discontinued = 1
);

#133. Top 5 customers by number of distinct product categories purchased.
SELECT o.customer_id, COUNT(DISTINCT p.category_id) AS distinct_categories
FROM Orders as o
JOIN OrderItems as oi ON o.order_id = oi.order_id
JOIN Products as p ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY distinct_categories DESC
LIMIT 5;

#134. Combine cancelled and returned orders into a single list (UNION).
SELECT order_id, customer_id, order_date, 'Cancelled' AS reason
FROM Orders WHERE status = 'Cancelled'
UNION
SELECT order_id, customer_id, order_date, 'Returned' AS reason
FROM Orders WHERE status = 'Returned';

#135. Products in the top price quartile of their category (window function).
WITH price_quartiles AS (
						SELECT product_id, product_name,category_id, unit_price,
						NTILE(4) OVER (PARTITION BY category_id ORDER BY unit_price DESC) AS Quartile
						FROM Products
						)
SELECT * FROM price_quartiles 
WHERE Quartile = 1;

#136. Employees ranked within their own department by salary (DENSE_RANK).
SELECT employee_id, first_name, last_name, department, salary,
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS Dept_Salary_Rank
FROM Employees;

#137.Rank all employees by total sales revenue handled.
SELECT e.employee_id, e.first_name, e.last_name,
		SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS Total_Sales,
			RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC) AS Sales_Rank
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY e.employee_id, e.first_name, e.last_name;

#138. Customers with the highest average order value (AOV).
WITH order_values AS (
					SELECT o.customer_id, o.order_id,SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS Order_Value
FROM Orders as o
JOIN OrderItems as oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_id
)
SELECT customer_id, AVG(order_value) AS Avg_Order_Value
FROM order_values
GROUP BY customer_id
ORDER BY avg_order_value DESC
LIMIT 10;

#139. Average time between order date and ship date, per employee.
SELECT e.employee_id, e.first_name, e.last_name,
AVG(DATEDIFF(o.ship_date, o.order_date)) AS Avg_Days_To_Ship
FROM Employees as e
JOIN Orders as o ON e.employee_id = o.employee_id
WHERE o.ship_date IS NOT NULL
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY Avg_Days_To_Ship;
        
#140. Customers who reviewed a product they actually purchased (EXISTS).
SELECT DISTINCT r.customer_id, r.product_id
FROM Reviews as r
WHERE EXISTS (
			SELECT 1
			FROM Orders o
			JOIN OrderItems oi ON o.order_id =
			oi.order_id
			WHERE o.customer_id = r.customer_id AND
			oi.product_id = r.product_id
			);
            
#141. Create a view summarizing product performance.
CREATE VIEW product_performance AS SELECT p.product_id, p.product_name,SUM(oi.quantity) AS units_sold,
									SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue,
                                    AVG(r.rating) AS avg_rating
FROM Products as p
LEFT JOIN OrderItems as oi ON p.product_id = oi.product_id
LEFT JOIN Reviews as r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

#142.Products priced higher than their own category's average price (correlated subquery).
SELECT p1.product_name, p1.category_id, p1.unit_price
FROM Products p1
WHERE p1.unit_price > (SELECT AVG(p2.unit_price)
						FROM Products p2
						WHERE p2.category_id = p1.category_id
						);

#143. Products with below-average ratings but above-average sales volume (cross-metric analysis).
WITH product_metrics AS (
SELECT p.product_id, p.product_name,AVG(r.rating) AS avg_rating,SUM(oi.quantity) AS units_sold
FROM Products as p
LEFT JOIN Reviews as r ON p.product_id = r.product_id
LEFT JOIN OrderItems as oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
)
SELECT * FROM product_metrics
WHERE avg_rating < (SELECT AVG(rating) FROM Reviews)
AND units_sold > (SELECT AVG(units_sold) FROM product_metrics);

#144. Create a view summarizing each customer's order activity.
CREATE VIEW customer_summary AS
SELECT c.customer_id, c.first_name, c.last_name, c.country,COUNT(DISTINCT o.order_id) AS Total_orders,
		SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_spent
FROM Customers as c
LEFT JOIN Orders as o ON c.customer_id = o.customer_id
LEFT JOIN OrderItems as oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name,c.last_name, c.country;

#145.Products ordered more than 50 times in total, with their category name.
SELECT p.product_name, c.category_name, SUM(oi.quantity) AS total_units_sold
FROM OrderItems as oi
JOIN Products as p ON oi.product_id = p.product_id
JOIN Categories as c ON p.category_id = c.category_id
GROUP BY p.product_name, c.category_name
HAVING SUM(oi.quantity) > 50
ORDER BY total_units_sold DESC;

#146.Number of orders placed by customers in each country during 2025.
SELECT c.country, COUNT(o.order_id) AS orders_2025
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2025
GROUP BY c.country
ORDER BY orders_2025 DESC;

#147. Each employee's total orders handled and their average order value.
SELECT e.employee_id, e.first_name, e.last_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       AVG(oi.quantity * oi.unit_price * (1 - oi.discount)) AS avg_line_value
FROM Employees as e
JOIN Orders as o ON e.employee_id = o.employee_id
JOIN OrderItems as oi ON o.order_id = oi.order_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_orders DESC;

#148. Comprehensive order summary report (multijoin + CASE + aggregation).
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		CONCAT(e.first_name, ' ', e.last_name) AS handled_by, o.order_date, o.status,
		COUNT(oi.order_item_id) AS items_in_order,
		SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS order_value,
CASE
WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) > 1000 THEN 'High Value'
WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) BETWEEN 200 AND 1000 THEN 'Medium Value'
ELSE 'Low Value'
END AS order_tier
FROM Orders as  o
JOIN Customers as c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.order_id, customer_name, handled_by, o.order_date, o.status
ORDER BY order_value DESC;

#149..RFM analysis (Recency, Frequency, Monetary) per customer.
WITH rfm AS (
			SELECT o.customer_id, DATEDIFF((SELECT MAX(order_date)
			FROM Orders), MAX(o.order_date)) AS Recency_days,
			COUNT(DISTINCT o.order_id) AS Frequency,
			SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS monetary
			FROM Orders as o
			JOIN OrderItems as oi ON o.order_id = oi.order_id
			GROUP BY o.customer_id
            )
SELECT *,
NTILE(5) OVER (ORDER BY Recency_days ASC) AS r_score,
NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
FROM rfm;

#150. Find the top 2 best-selling products in each category, by total revenue.
WITH product_revenue AS (
	SELECT p.category_id, p.product_name,
	SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue,
	RANK() OVER (PARTITION BY p.category_id ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC) AS rnk
    FROM OrderItems as oi
    JOIN Products as p ON oi.product_id = p.product_id
    GROUP BY p.category_id, p.product_name
)
SELECT category_id, product_name, revenue
FROM product_revenue
WHERE rnk <= 2
ORDER BY category_id, rnk;












