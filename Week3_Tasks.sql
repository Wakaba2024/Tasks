-- The first step is to set the search path to the schema with the tables we want to use.
set search_path to luxsql;
-- Next is to view all the tables needed.
select * from customers;
select * from books;
select * from orders;
-- Basic Queries
-- 1. List all customers with their full name and city.
-- The full name is needed therefore we need to combines two or more strings into one(first_name and the second_name) therefore use the CONCAT function.
select CONCAT(first_name,' ', second_name) as Full_Name, city
from customers;
-- 2. Show all books priced above 2000.
-- We have to use the where clause so as to filter for books priced above 2000.
select * from books
where price > 2000;
-- 3. List customers who live in 'Nairobi'.
-- We have to use the where clause so as to filter for the customers whose city is recorded as nairobi.
select * from customers
where city = 'Nairobi';
-- 4. Retrieve all book titles that were published in 2023.
-- We have to filter for books within the 2023 range hence we have to use the between clause.
select title, published_date
from books
where published_date between '2023-01-01' and '2023-12-31';
-- Filtering and Sorting
-- 5. Show all orders placed after March 1st, 2025.
-- We have to use the where clause so as to filter orders placed after March 1st, 2025
select book_id, order_date
from orders
where order_date > '2025-03-01';
-- 6. List all books ordered, sorted by price (descending).
-- In this case the price is in a different table other than the orders table.
-- A join is needed so as to get data from the two tables
-- I will use the Inner join to get only books that were ordered by pulling records from the books and orders table.
select books.title, books.price from books
inner join orders
on books.book_id = orders.book_id
order by books.price desc;
-- 7. Show all customers whose names start with 'J'.
-- The Like clause will be used to pattern match by looking for the first name starting with J 
select * from customers
where first_name like 'J%';
-- 8. List books with prices between 1500 and 3000.
-- In this scenario we are filtering a column based on a range hence the need to use the between clause.
select title, price from books
where price between '1500' and '3000';
-- Aggregate Functions and Grouping
-- 9. Count the number of customers in each city.
select city, count(*) as total_customers
from customers
where city is not null
group by city;
-- count(*) counts how many customers are in each city.
-- as total_customers: This is the alias given to the count column
-- The group by in this scenario groups the data by city so the count can be calculated per city.
-- 10. Show the total number of orders per customer.
select customer_id, count(*) as orders_per_customer
from orders
group by customer_id;
-- count(*) counts how many orders were made by every customer_id.
-- as orders_per_customer: This is the alias given to the count column
-- The group by in this scenario groups the data by the customer_id so the count can be calculated per customer.
-- 11. Find the average price of books in the store.
select avg(price) as Average_price
from books;
-- The Average aggregate function is used in this scenario to get the mean of the price colum.
-- 12. List the book title and total quantity ordered for each book
select books.title, sum(orders.quantity) as total_quantity
from books
inner join orders on books.book_id = orders.book_id
group by title;
-- sum is used to add up the total of all quantities per book 
-- The inner join is used to combine rows from both tables needed and only includes rows where there is a matching book_id in both tables
-- Subqueries
-- 13. Show customers who have placed more orders than customer with ID = 1.
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM orders
    WHERE customer_id = 1
);
-- A subquery is a query nested within another query 
-- The inner query fetches the count of orders associated with customer_id 1
-- The outer query fetches the count of all customers grouping them by their customer ID
-- The having clause filters based on the count (*) aggregate of the outer query.
-- 14. List books that are more expensive than the average book price.
select title, price
from books 
where price > (
		select  avg(price) as average_price from books
	)
order by price desc;
-- The inner query fetches for the average price of all books
-- The outer query fetches for the books that are more expensive than the average of the inner query then orders by desc
-- 15. Show each customer and the number of orders they placed using a subquery in SELECT.
select customer_id, concat(first_name,'-', second_name) as full_name,
(
select count(*)
from orders
where orders.customer_id = customers.customer_id) as count_of_total_orders
from customers;
-- concat(first_name,'-', second_name) as full_name shows full name as first_name-second_name
-- The subquery in select counts how many orders each customer has placed
-- JOINS
-- 16. Show full name of each customer and the titles of books they ordered.
select concat(customers.first_name,' ', second_name) as full_name, books.title
from customers
inner join orders on orders.customer_id = customers.customer_id
inner join books on books.book_id = orders.book_id
order by full_name asc;
-- 17. List all orders including book title, quantity, and total cost (price × quantity).
select orders.order_id, books.title, books.price, orders.quantity, books.price*orders.quantity as total_cost
from books
inner join orders on books.book_id = orders.book_id;
-- 18. Show customers who haven't placed any orders (LEFT JOIN).
select concat(first_name,' ',second_name) as customers_without_orders
from customers
left join orders on orders.customer_id = customers.customer_id
where order_id is null;
-- 19. List all books and the names of customers who ordered them, if any (LEFT JOIN).
select books.title, books.book_id, concat(first_name,' ',second_name) as customers_with_orders,  orders.order_id
from orders
left join customers on orders.customer_id = customers.customer_id
left  join books on books.book_id = orders.book_id;
--20. Show customers who live in the same city (SELF JOIN).
select A.customer_id as customer_1,
A.first_name as name_1,
B.customer_id as customer_2,
B.first_name as customer_2,
A.city
from customers A
join customers B on A.city = B.city;
-- Combined Logic
-- 21. Show all customers who placed more than 2 orders for books priced over 2000.
select customers.first_name, books.price, books.book_id, orders.order_id, orders.quantity
from orders
inner join customers on orders.customer_id = customers.customer_id
inner  join books on books.book_id = orders.book_id
where orders.quantity > 2 and books.price > 2000;
-- 22. List customers who ordered the same book more than once.
select customer_id, book_id, quantity
from orders
where quantity > 1;
-- 23. Show each customer's full name, total quantity of books ordered, and total amount spent.
select concat(customers.first_name,'-', second_name) as full_name, sum(orders.quantity) as total_quantity, sum(books.price) as total_amount_spent
from customers
inner join orders on orders.customer_id = customers.customer_id
inner  join books on books.book_id = orders.book_id
group by full_name;
-- 24. List books that have never been ordered.
select books.title, books.book_id, books.published_date
from books
inner join orders on orders.book_id = books.book_id
where orders.order_date is null;
-- 25. Find the customer who has spent the most in total (JOIN + GROUP BY + ORDER BY + LIMIT).
select concat(customers.first_name,' ', second_name) as full_name, sum(books.price) as total_amount_spent
from customers
inner join orders on orders.customer_id = customers.customer_id
inner  join books on books.book_id = orders.book_id
group by full_name
order by total_amount_spent desc 
limit 1;
-- 26. Write a query that shows, for each book, the number of different customers who have ordered it.
select books.title, COUNT(distinct orders.customer_id) as customers_who_ordered
from orders 
inner  join books on books.book_id = orders.book_id
group by books.title ;
select * from orders;
-- 27. Using a subquery, list books whose total order quantity is above the average order quantity.
select books.title, sum(distinct orders.quantity) as total_order_quantity
from orders
inner join books on books.book_id = orders.book_id
group by books.title
Having sum(distinct orders.quantity) >(
select avg(quantity) as average_quantity from orders);
-- 28. Show the top 3 customers with the highest number of orders and the total amount they spent.
select concat(customers.first_name,' ', second_name) as full_name, count(distinct orders.order_id) as number_of_orders, sum(distinct books.price) as total_amount_spent
from customers
inner join orders on orders.customer_id = customers.customer_id
inner  join books on books.book_id = orders.book_id
group by full_name
order by number_of_orders desc;
limit 3;























