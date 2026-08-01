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

