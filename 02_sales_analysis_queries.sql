/*
Project: Online Bookstore Sales Analysis
Platform: Microsoft SQL Server (T-SQL)
Prerequisite: Run 01_create_database_and_tables.sql, then import the CSV files into
dbo.Books, dbo.Customers, and dbo.Orders. See README.md for import instructions.
*/

USE OnlineBookstore;
GO

-- 1. Basic data checks
SELECT COUNT(*) AS Book_Count FROM dbo.Books;
SELECT COUNT(*) AS Customer_Count FROM dbo.Customers;
SELECT COUNT(*) AS Order_Count FROM dbo.Orders;

-- 2. Total revenue, order count, units sold, and average order value
SELECT
    SUM(Total_Amount) AS Total_Revenue,
    COUNT(*) AS Order_Count,
    SUM(Quantity) AS Units_Sold,
    CAST(AVG(CAST(Total_Amount AS DECIMAL(12,2))) AS DECIMAL(12,2)) AS Average_Order_Value
FROM dbo.Orders;

-- 3. Revenue by month
SELECT
    DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS Order_Month,
    SUM(Total_Amount) AS Monthly_Revenue,
    COUNT(*) AS Orders
FROM dbo.Orders
WHERE Order_Date IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)
ORDER BY Order_Month;

-- 4. Revenue and units sold by genre
SELECT
    b.Genre,
    SUM(o.Total_Amount) AS Revenue,
    SUM(o.Quantity) AS Units_Sold,
    COUNT(DISTINCT o.Order_ID) AS Order_Count
FROM dbo.Orders AS o
JOIN dbo.Books AS b ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue DESC;

-- 5. Top 10 books by revenue
SELECT TOP (10)
    b.Book_ID, b.Title, b.Author, b.Genre,
    SUM(o.Total_Amount) AS Revenue,
    SUM(o.Quantity) AS Units_Sold
FROM dbo.Orders AS o
JOIN dbo.Books AS b ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Author, b.Genre
ORDER BY Revenue DESC, Units_Sold DESC;

-- 6. Top 10 customers by lifetime spend
SELECT TOP (10)
    c.Customer_ID, c.Name,
    COUNT(o.Order_ID) AS Order_Count,
    SUM(o.Total_Amount) AS Lifetime_Spend
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Lifetime_Spend DESC;

-- 7. Repeat customers (at least two orders)
SELECT
    c.Customer_ID, c.Name,
    COUNT(o.Order_ID) AS Order_Count,
    SUM(o.Total_Amount) AS Total_Spend
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Order_Count DESC, Total_Spend DESC;

-- 8. Revenue by country
SELECT
    c.Country,
    SUM(o.Total_Amount) AS Revenue,
    COUNT(DISTINCT o.Order_ID) AS Order_Count,
    COUNT(DISTINCT c.Customer_ID) AS Customers
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Revenue DESC;

-- 9. Inventory snapshot: current stock is not necessarily stock remaining after orders
SELECT Book_ID, Title, Genre, Stock AS Current_Stock
FROM dbo.Books
ORDER BY Current_Stock ASC, Title;

-- 10. Books with the lowest current stock
SELECT TOP (10) Book_ID, Title, Author, Genre, Stock
FROM dbo.Books
ORDER BY Stock ASC, Title;

-- 11. Orders in November 2023 (use a half-open date range)
SELECT *
FROM dbo.Orders
WHERE Order_Date >= '20231101'
  AND Order_Date <  '20231201'
ORDER BY Order_Date;

-- 12. Month-over-month revenue change
WITH MonthlyRevenue AS (
    SELECT
        DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS Order_Month,
        SUM(Total_Amount) AS Revenue
    FROM dbo.Orders
    WHERE Order_Date IS NOT NULL
    GROUP BY DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)
),
RevenueWithPreviousMonth AS (
    SELECT
        Order_Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Order_Month) AS Previous_Month_Revenue
    FROM MonthlyRevenue
)
SELECT
    Order_Month,
    Revenue,
    Previous_Month_Revenue,
    CAST(Revenue - Previous_Month_Revenue AS DECIMAL(12,2)) AS Revenue_Change,
    CAST(100.0 * (Revenue - Previous_Month_Revenue) / NULLIF(Previous_Month_Revenue, 0) AS DECIMAL(8,2)) AS Revenue_Change_Pct
FROM RevenueWithPreviousMonth
ORDER BY Order_Month;

-- 13. Data quality: find orders that reference missing customers/books (should return zero rows)
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c ON c.Customer_ID = o.Customer_ID
LEFT JOIN dbo.Books AS b ON b.Book_ID = o.Book_ID
WHERE c.Customer_ID IS NULL OR b.Book_ID IS NULL;

-- 14. Average book price by genre
SELECT Genre, COUNT(*) AS Book_Count, CAST(AVG(Price) AS DECIMAL(10,2)) AS Average_Price
FROM dbo.Books
GROUP BY Genre
ORDER BY Average_Price DESC;

-- 15. Most frequently ordered books by number of order records
SELECT TOP (10)
    b.Book_ID, b.Title,
    COUNT(o.Order_ID) AS Times_Ordered,
    SUM(o.Quantity) AS Units_Sold
FROM dbo.Books AS b
JOIN dbo.Orders AS o ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Times_Ordered DESC, Units_Sold DESC;
