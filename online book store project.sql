CREATE DATABASE onlinebookstore;
-- Switch to the database
\c OnlineBookstore;

--CREATE TABLES
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock int
);
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--Import Data into Books Table
COPY
Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Program Files\PostgreSQL\18\data\Books.csv' 
DELIMITER ','
CSV HEADER;

-- Import Data into Customers Table
COPY 
Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Program Files\PostgreSQL\18\data\Customers.csv' 
DELIMITER ','
CSV HEADER;

-- Import Data into Orders Table
COPY
Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\18\data\Orders.csv' 
DELIMITER ','
CSV HEADER;

SELECT *from Books;
SELECT *from Customers;
SELECT *from Orders;

 --Retrive all books from "fiction" genre.

SELECT *from Books
WHERE Genre='Fiction';

-- Find all books published after the year 1950.

SELECT *from books
WHERE Published_Year>1950;

-- List all customers from canada.

SELECT *from Customers
WHERE Country='Canada';

--Show orders places in november 2023

SELECT *from Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Retrive total stocks of books available.

SELECT SUM(stock) as Total_stock
from Books ;

--Find the details of most expensive Books.

SELECT *FROM Books 
ORDER BY price DESC LIMIT 1;

--Show all customers who ordered morethan one quantity of a books.

SELECT *from Orders
WHERE quantity>1;

-- Retrive all orders where total amount exceeds $25.

SELECT *FROM Orders
WHERE total_amount>20;

--List all genre available in the books table.

SELECT DISTINCT genre from Books;

--Find the books with the lowest stocks.

SELECT *from Books 
ORDER BY stock
LIMIT 1;

--Calculate the total revenue generated from all orders.

SELECT sum(total_amount) as total_revenue
from Orders;

--Retrive the total number of books sold for each genre.

SELECT b.genre,SUM(o.quantity) AS sold_books
FROM Orders o
JOIN Books b on  b.book_id=o.book_id
GROUP BY b.genre;

--Find the average price of books in the "fantacy" genre.

SELECT AVG(price) as avg_price
FROM Books 
WHERE genre= 'Fantasy';

--List customers who have placed atleast 2 orders.

SELECT customer_id,COUNT(order_id) AS order_count
from orders 
GROUP BY customer_id
HAVING COUNT(order_id)>= 2;

--Find most frequently orderd book.

SELECT o.book_id, b.title ,COUNT(o.order_id) as Total_order
from orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY Total_order DESC LIMIT 1;

--Show the top 3 most expensive books of 'fantasy' Genre.

SELECT *FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--Retrive  the total quantity of books sold by each author.

SELECT b.author, SUM(o.quantity) as total_book_sold
from orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY B.author;

-- List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


--  Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


-- Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;




