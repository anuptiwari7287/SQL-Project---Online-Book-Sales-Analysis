-- Create Database
CREATE DATABASE OnlineBookstore;

-- Create Tables
IF OBJECT_ID('dbo.Books', 'U') IS NOT NULL
    DROP TABLE dbo.Books;

CREATE TABLE dbo.Books (
    Book_ID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Author NVARCHAR(100) NOT NULL,
    Genre NVARCHAR(50),
    Published_Year INT CHECK (Published_Year > 0),
    Price DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0
);


IF OBJECT_ID('Customers', 'U') IS NOT NULL
    DROP TABLE Customers;

CREATE TABLE Customers (
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

IF OBJECT_ID('Orders', 'U') IS NOT NULL
    DROP TABLE Orders;

CREATE TABLE Orders (
    Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM BOOKS 
WHERE Genre='Fiction'

-- 2) Find books published after the year 1950:
  SELECT Book_ID,Title,Published_Year
    FROM Books
    WHERE Published_Year>1950

-- 3) List all customers from the Canada:

SELECT*FROM Customers
WHERE Country ='Canada'

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-1'AND '2023-11-30'

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS 'Total Stocks'
FROM Books

-- 6) Find the details of the most expensive book:
SELECT TOP 1 *
FROM Books
ORDER BY Price DESC

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM Orders
WHERE Quantity>1

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM Orders
WHERE Total_Amount > 20

-- 9) List all genres available in the Books table:

SELECT DISTINCT Genre 
FROM Books

-- 10) Find the book with the lowest stock:

SELECT TOP 1 Title, Stock
FROM Books
ORDER BY Stock ASC

-- 11) Calculate the total revenue generated from all orders:

SELECT ROUND( SUM (Total_Amount),2)AS Total_Revenue
FROM Orders

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM  Books b
JOIN Orders o ON o.book_id = b.book_id
GROUP BY b.Genre

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT ROUND (AVG(Price),2) AS Avg_Book_Price FROM Books 
WHERE Genre='Fantasy'

-- 3) List customers who have placed at least 2 orders:

 SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2 

-- 4) Find the most frequently ordered book:

SELECT TOP 1 o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC 

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT TOP 3 * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC

-- 6) Retrieve the total quantity of books sold by each author:

SELECT DISTINCT b.Author,SUM(o.Quantity) AS Total_quantity_sold
FROM Books b
JOIN Orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Author

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30

-- 8) Find the customer who spent the most on orders:
 
 SELECT TOP 1 c.Customer_ID, c.Name ,SUM(o.Total_Amount) AS Total_Spent
 FROM Orders o 
 JOIN Customers c ON c.Customer_ID=o.Customer_ID
 GROUP BY  c.Customer_ID, c.Name
 ORDER BY Total_Spent DESC

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id,b.Title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ,b.Title,b.Stock
ORDER BY b.book_id
