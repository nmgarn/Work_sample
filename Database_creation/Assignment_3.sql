
--Nathan Garn
--3-2-2022
--U0628150
--IS 6420-090 Spring 2022 Database Theory/Design
--Assignment 3: SQL


--1. List the average price for all products available to sell.


SELECT AVG (PRODUCT_PRICE)
FROM PRODUCT
;

--2. In a single query result, with no duplicates, ordered by the price in ascending order, list the product_id, name, and price for all products with a price greater than the average price for all products available to sell.  
--IMPORTANT: the average price should be calculated as part of a subquery (i.e., don’t just hard-code the final number from the previous question)

SELECT DISTINCT PRODUCT_ID, PRODUCT_NAME, PRODUCT_PRICE
FROM PRODUCT
WHERE PRODUCT_PRICE > (SELECT AVG(PRODUCT_PRICE) FROM PRODUCT)
ORDER BY PRODUCT_PRICE ASC
;

--3. In a single query result, with no duplicates, ordered by the product_id in ascending order, 
--list the product_id and total quantity ordered (by all customers).


SELECT DISTINCT PRODUCT_ID, SUM(Quantity) Total_Orders
FROM ORDER_LINE
GROUP BY PRODUCT_ID
ORDER BY PRODUCT_ID ASC
;


--4. In a single query result, with no duplicates, ordered by the product_name in ascending order, 
--list the product_id, product_name and total quantity ordered (by all customers).

SELECT DISTINCT ol.product_id, p.product_name, SUM(ol.quantity) Total_Quantity
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
GROUP BY ol.product_id, p.product_name
ORDER BY p.product_name ASC
;


--5. In a single query result, with no duplicates, ordered by the total quantity ordered (by all customers) in descending order, list the product_id, product_name and total quantity ordered (by all customers).

SELECT DISTINCT ol.product_id, p.product_name, SUM(ol.quantity)Total_Quantity
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
GROUP BY ol.product_id, p.product_name
ORDER BY Total_Quantity DESC
;

--6 In a single query result, with no duplicates, ordered by the total quantity ordered (by all customers) in descending order, 
--list the product_id, product_name and total quantity ordered (by all customers) 
--considering only orders after (i.e., not including) Oct. 23, 2008.

SELECT DISTINCT ol.product_id, p.product_name, SUM(ol.quantity)Total_Quantity
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
WHERE oh.order_date > '23-OCT-08'
GROUP BY ol.product_id, p.product_name
ORDER BY Total_Quantity DESC
;

--7 In a single query result, with no duplicates, ordered by customer_id in ascending order, 
--list the customer_id for all customers who have placed at least one order on or after Oct. 22, 2008.

SELECT DISTINCT c.customer_id
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
WHERE oh.order_date > '22-OCT-08'
GROUP BY c.customer_id, oh.order_date
ORDER BY c.customer_id ASC
;

--8.In a single query result, with no duplicates, ordered by the customer name in descending order, 
--list the customer_id and customer name for all customers who have placed at least one order on or after Oct. 22, 2008.  
--IMPORTANT: You must use “in” along with a subquery (i.e. you are not allowed to use a join for this query).


SELECT DISTINCT customer_id, full_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM order_header WHERE
order_date >= '22-OCT-08') 
GROUP BY customer_id, full_name
ORDER BY full_name desc
;


--SELECT product_name, product_price
--FROM product
--WHERE product_id IN (SELECT product_id FROM order_line WHERE order_id = 1001)

--9. In a single query result, with no duplicates, ordered by the customer name in descending order, 
--list the customer_id and customer name for all customers who have placed at least one order on or after Oct. 22, 2008.  
--IMPORTANT: You must use a “natural join” for this query (i.e. you are not allowed to use a subquery for this query).

SELECT DISTINCT customer_id, full_name
FROM order_line
NATURAL JOIN order_header
NATURAL JOIN customer
WHERE order_date >= '22-OCT-08'
AND quantity > 0
GROUP BY customer_id, full_name
ORDER BY full_name DESC
;

--10. Update the query from the previous question to use an “equijoin” instead of a “natural join”.
--HELP!


SELECT DISTINCT c.customer_id, c.full_name
FROM order_line ol, order_header oh, customer c
WHERE ol.order_id = oh.order_id AND c.customer_id = oh.customer_id
AND order_date > '22-OCT-08'
GROUP BY c.customer_id, c.full_name
ORDER BY c.full_name DESC
;

--11. In a single query result, with no duplicates, ordered by the product_id in ascending order, 
--list the product_ids that have NOT been ordered after Oct. 27, 2008.  
--IMPORTANT: You must use the “minus” for this query.

SELECT DISTINCT p.product_id, oh.order_date
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
MINUS
SELECT p.product_id, oh.order_date
FROM product p
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
WHERE oh.order_date > '27-OCT-08'
ORDER BY product_id ASC
;

--12. In a single query result, with no duplicates, ordered by the customer_id in descending order, 
--list the cuustomer_id for all customers from Arizona who have placed order(s) on or after Oct. 27, 2008.  
--IMPORTANT: You must use the “intersect” for this query.

SELECT DISTINCT c.customer_id, oh.order_date
FROM product p 
LEFT JOIN order_line ol ON p.product_id = ol.product_id
LEFT JOIN order_header oh ON ol.order_id = oh.order_id
LEFT JOIN customer c ON oh.customer_id = c.customer_id
WHERE region_abbr = 'AZ'
INTERSECT
SELECT DISTINCT c.customer_id, oh.order_date
FROM product p 
RIGHT JOIN order_line ol ON p.product_id = ol.product_id
RIGHT JOIN order_header oh ON ol.order_id = oh.order_id
RIGHT JOIN customer c ON oh.customer_id = c.customer_id
WHERE order_date >= '27-OCT-08'
ORDER BY customer_id DESC
;

--13. In a single query result, with no duplicates, ordered by the customer_id in ascending order, 
--list the customer_id and customer_name for all customers from California along with all customers who have placed order(s)
--on or after Oct. 23, 2008.  
--IMPORTANT: You must use the “union” for this query
-- Add CUstomer Name

SELECT DISTINCT c.customer_id, c.full_name
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
WHERE region_abbr = 'CA'
UNION
SELECT DISTINCT c.customer_id, c.full_name
FROM product p 
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
WHERE order_date >= '23-OCT-08'
ORDER BY customer_id ASC
;

--14. In a single query result, with no duplicates, ordered by the customer name descending, 
--list the customer id, name and city for all customers whose name starts with a B.

SELECT DISTINCT customer_id, full_name, city
FROM customer
WHERE full_name LIKE 'B%'
ORDER BY full_name DESC
;


--15. In a single query result, with no duplicates, ordered by the customer name ascending, 
--list the customer id, name and city for all customers whose name contains a lowercase or uppercase T 
--(i.e. either or both of “t” or “T”)

SELECT DISTINCT customer_id, full_name, city
FROM customer
WHERE full_name LIKE '%T%'
OR full_name LIKE '%t%'
ORDER BY full_name ASC
;

--16. In a single query result, with no duplicates, ordered by the product name in ascending order,
--list the product_id, product name, and total quantity ordered (by all customers)
--for products with a total quantity ordered (by all customers)  greater than 5.
--HELP!

SELECT DISTINCT p.product_id, p.product_name, SUM(ol.quantity)
FROM product p
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id
HAVING SUM(ol.quantity) > 5
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name ASC
;

--17. In a single query result, with no duplicates, ordered by the product name in ascending order, 
--list the product_id, product name, and total quantity ordered (by all Utah customers) 
--for products with a total quantity ordered (by all Utah customers) greater than 2.
--HELP!

SELECT DISTINCT p.product_id, p.product_name, SUM(ol.quantity)
FROM product p
JOIN order_line ol ON p.product_id = ol.product_id
JOIN order_header oh ON ol.order_id = oh.order_id
JOIN customer c ON oh.customer_id = c.customer_id and c.region_abbr = 'UT'
HAVING SUM(ol.quantity) > 2 
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name ASC
;