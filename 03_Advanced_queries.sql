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












