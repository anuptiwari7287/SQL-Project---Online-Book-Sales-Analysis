# Online Bookstore Sales Analysis (SQL Server)

A portfolio project analyzing an online bookstore's catalog, customers, orders, revenue, and inventory using Microsoft SQL Server (T-SQL).

## Project goals
- Measure overall sales performance and average order value.
- Compare revenue and units sold across book genres.
- Identify high-revenue books and high-spending customers.
- Explore monthly revenue trends and month-over-month change.
- Review current stock levels and perform basic data-quality checks.

## Repository structure
```text
sql-sales-analysis/
├── README.md
├── .gitignore
├── data/
│   ├── Books.csv
│   ├── Customers.csv
│   └── Orders.csv
├── sql/
│   ├── 01_create_database_and_tables.sql
│   ├── 02_sales_analysis_queries.sql
│   └── original_practice_queries.sql
├── results/
│   └── key_findings.md
└── screenshots/
    └── (add your own SSMS screenshots here)
```

## Tools and skills
- Microsoft SQL Server and SQL Server Management Studio (SSMS)
- T-SQL, table design, primary and foreign keys, constraints
- `JOIN`, `GROUP BY`, `HAVING`, aggregate functions, `TOP`, CTEs, `LAG`, date functions
- Revenue analysis, product performance, customer analysis, inventory review, data-quality checks

## Dataset
The supplied sample data has 500 books, 500 customers, and 500 order records. The order dates span December 2022 through December 2024. The CSV files are included in `data/`.

**Privacy check before publishing:** The customer file contains email addresses and phone numbers. Publish it only if the data is synthetic or you have permission to share it. Otherwise anonymize or remove those columns before committing.

## How to run in SSMS

### 1. Create the database and tables
1. Open SSMS and connect to your SQL Server instance.
2. Open `sql/01_create_database_and_tables.sql`.
3. Execute the script. It creates/uses `OnlineBookstore` and creates the three tables.
4. **Warning:** The script drops existing `dbo.Orders`, `dbo.Customers`, and `dbo.Books` tables in `OnlineBookstore`. Back up any important data first.

### 2. Import the CSV files
Use the SSMS Import Data wizard to load each CSV into the existing tables:
1. In Object Explorer, right-click the `OnlineBookstore` database.
2. Select **Tasks → Import Data** (the exact menu may vary by SSMS/SQL Server version).
3. Choose **Flat File Source** or the CSV/text source available in your wizard and select `data/Books.csv`.
4. Set destination to SQL Server and choose the `OnlineBookstore` database.
5. Map the source columns to the existing `dbo.Books` table in this order: `Book_ID`, `Title`, `Author`, `Genre`, `Published_Year`, `Price`, `Stock`.
6. Repeat for `Customers.csv` to `dbo.Customers` with columns `Customer_ID`, `Name`, `Email`, `Phone`, `City`, `Country`.
7. Repeat for `Orders.csv` to `dbo.Orders` with columns `Order_ID`, `Customer_ID`, `Book_ID`, `Order_Date`, `Quantity`, `Total_Amount`.
8. Import **Books and Customers before Orders** because Orders has foreign keys to both tables.
9. Confirm the wizard maps IDs as integers, dates as dates, prices/amounts as decimal, and text fields as Unicode/text. Ensure it treats the first row as column headers.

If your SSMS version cannot map CSV data into existing tables, use its Import Flat File workflow to create staging tables, then use `INSERT INTO dbo... SELECT ...` after checking column types. Do not import the same data twice.

### 3. Verify row counts
Run:
```sql
USE OnlineBookstore;
SELECT COUNT(*) AS Books FROM dbo.Books;       -- expected: 500
SELECT COUNT(*) AS Customers FROM dbo.Customers; -- expected: 500
SELECT COUNT(*) AS Orders FROM dbo.Orders;     -- expected: 500
```

### 4. Run the analysis
Open and execute `sql/02_sales_analysis_queries.sql`. Run one query or one highlighted block at a time if you prefer. Review `results/key_findings.md` for calculated reference findings.

## Business questions answered
1. How much revenue and how many units were recorded?
2. Which months generated the most revenue?
3. Which genres and books generated the most revenue?
4. Which customers spent the most, and which customers ordered repeatedly?
5. Which countries generated the most revenue?
6. Which books currently have the lowest stock?
7. Are there orders with missing customer or book references?

## Limitations
- `Total_Amount` is assumed to be the project's revenue field; the source data does not specify tax, discount, return, or margin treatment.
- Revenue by country describes the supplied sample and should not be generalized to a real business.
- `Stock` is treated as current stock, not reconstructed inventory after each order.
- This project is an analytical exercise; the findings do not establish why sales rose or fell.
