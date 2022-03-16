--In this file, some queries will be executed on the 'northwind' database.
--Practice of joins and aggregate functions.


--Obtain a table that contains the order id and it's total cost:
SELECT order_details.order_id,ROUND ((SUM((products.unit_price * order_details.quantity * (1 - order_details.discount))) + AVG(orders.freight))::numeric,2) AS total_order_price 
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
GROUP BY order_details.order_id;
SELECT * FROM orders;


--Obtain a list of the 10 customers with more orders, as well as the number of orders from each, sorted in decreasing order:
SELECT customers.contact_name,COUNT(*) 
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.contact_name
ORDER BY COUNT DESC LIMIT 10;

--Obtain a table that contains the order id and it's total cost, as well as the customer who ordered it:
SELECT customers.contact_name,order_details.order_id,ROUND ((SUM((products.unit_price * order_details.quantity * (1 - order_details.discount))) + AVG(orders.freight))::numerc,2) AS total_order_price 
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY order_details.order_id,customers.contact_name;

--Obtain a table that contains the customer's country and the value of his/her orders:
SELECT customers.contact_name,customers.country,ROUND ((SUM((products.unit_price * order_details.quantity * (1 - order_details.discount))) + AVG(orders.freight))::numeric,2) AS total_order_price 
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.contact_name,customers.country;

--Obtain a table that contains the list of the customer's countries and the total cost of their orders per country. Sort by the total cost and by the country, decreasingly:
SELECT customers.country, ROUND ((SUM((products.unit_price * order_details.quantity * (1 - order_details.discount))) + AVG(orders.freight))::numeric,2) AS total_sales_price
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.country
ORDER BY total_sales_price DESC;

--Obtain a table with the mean sales value for each month. Order by the value of the sales decreasingly.
SELECT TO_CHAR(DATE_TRUNC('month',orders.order_date), 'Mon/YY'),ROUND (((SUM((products.unit_price * order_details.quantity * (1 - order_details.discount))) + AVG(orders.freight))/COUNT(orders.order_id))::numeric,2) AS mean_sales_value
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY DATE_TRUNC('month',orders.order_date)
ORDER BY mean_sales_value DESC;