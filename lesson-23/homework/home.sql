
Puzzle 1: In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. 
Please check out sample input and expected output.
Input Table: Dates

CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');
Sample Input

| Id |             Dt              |  
|----|-----------------------------|  
|  1 | 2018-04-06 11:06:43.020     |  
|  2 | 2017-12-06 11:06:43.020     |  
|  3 | 2016-01-06 11:06:43.020     |  
|  4 | 2015-11-06 11:06:43.020     |  
|  5 | 2014-10-06 11:06:43.020     |
Expected Output:

| Id | Dt                       | MonthPrefixedWithZero  |
|----|--------------------------|------------------------|
| 1  | 2018-04-06 11:06:43.020  | 04                     |
| 2  | 2017-12-06 11:06:43.020  | 12                     |
| 3  | 2016-01-06 11:06:43.020  | 01                     |
| 4  | 2015-11-06 11:06:43.020  | 11                     |
| 5  | 2014-10-06 11:06:43.020  | 10                     |


select * from Dates

select id,dt,month(dt) as month_of_date from dates 


Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. 
You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.
Input Table: MyTabel

CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

Sample Input:

| Id  | rID | Vals |  
|-----|-----|------|  
| 121 |  9  |  1   |  
| 121 |  9  |  8   |  
| 122 |  9  | 14   |  
| 122 |  9  |  0   |  
| 122 |  9  |  1   |  
| 123 |  9  |  1   |  
| 123 |  9  |  2   |  
| 123 |  9  | 10   |
Expected Output:

| Distinct_Ids | rID | TotalOfMaxVals |
|--------------|-----|----------------|
| 3            | 9   | 32             |

MyTabel
select* from MyTabel 


with cte as (
select max(vals) as maxed,
rid,
id from MyTabel
group by id,rid)

SELECT 
   COUNT(DISTINCT cte.id) AS distinct_id_count,
   cte.rid,
   SUM(cte.maxed) AS vals_sum
FROM cte 
GROUP BY cte.rid;



Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. 
Please see the sample input and expected output.
Input Table: TestFixLengths

CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');
Sample Input

| Id |     Vals         |  
+----+------------------+  
|  1 |  11111111        |  
|  2 |  123456          |  
|  2 |  123467          |  
|  2 |  1234567890      |  
|  5 |                  |  
|  6 |  NULL            |  
|  7 |  123456789012345 |  

Expected Output

| Id |     Vals     |  
+----+--------------+  
|  1 |  11111111    |  
|  2 |  123456      |  
|  2 |  123467      |  
|  2 |  1234567890  |  

select *from TestFixLengths

select id,
	   vals
	   from TestFixLengths
	   where len(vals) between 6 and 10 

Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value.
Please check out sample input and expected output.
Input Table: TestMaximum

CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);
Sample Input

| ID | Item  | Vals |  
+----+-------+------+  
|  1 |  a1   |  15  |  
|  1 |  a2   |  20  |  
|  1 |  a3   |  90  |  
|  1 |  q1   |  10  |  
|  2 |  q2   |  40  |  
|  2 |  q3   |  60  |  
|  2 |  q4   |  30  |  
|  3 |  q5   |  20  | 

Expected Output

| ID | Item  | Vals |  
+----+-------+------+  
|  2 |  q3   |  60  |  
|  1 |  a3   |  90  |  
|  3 |  q5   |  20  | 


select * from TestMaximum

with cte AS (
SELECT ID,
      VALS,
	  ROW_NUMBER() OVER (PARTITION BY ID ORDER BY VALS DESC ) AS ROWED 
	  FROM TESTMAXIMUM)

	  SELECT
			
			CTE.ID,
			CTE.VALS
			FROM CTE WHERE CTE.ROWED=1 
		

Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, 
and then Sum the data using Id only. Please check out sample input and expected output.
Input Table: SumOfMax

CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);

SELECT*FROM SumOfMax

WITH CTE AS (
SELECT MAX (VALS) AS 
       MAX_VALS,
	   DETAILEDNUMBER,
	   ID 
	   FROM SUMOFMAX 
	GROUP BY ID,DETAILEDNUMBER )
	SELECT 
	ID,
	SUM(MAX_VALS) AS SUMMED FROM CTE
	GROUP BY ID 



Sample Input

| DetailedNumber | Vals | Id  |  
+----------------+------+-----+  
|        1       |  5   | 101 |  
|        1       |  4   | 101 |  
|        2       |  6   | 101 |  
|        2       |  3   | 101 |  
|        3       |  3   | 102 |  
|        4       |  2   | 102 |  
|        4       |  3   | 102 |  
Expected Output

| Id  | SumofMax|  
+-----+---------+  
| 101 |   11    |  
| 102 |    6    |  

Puzzle 6: In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.
Input Table: TheZeroPuzzle
CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1, 10000000), (4,15,15);
Sample Input
| Id | a  |    b     |  
+----+----+----------+  
|  1 | 10 |    4     |  
|  2 | 10 |   10     |  
|  3 |  1 | 10000000 |  
|  4 | 15 |   15     |  
Expected Output

| Id | a  |    b     | OUTPUT  |  
+----+----+----------+---------+  
|  1 | 10 |    4     |    6    |  
|  2 | 10 |   10     |         |  
|  3 |  1 | 10000000 | -9999999|  
|  4 | 15 |   15     |         |

SELECT *FROM THEZEROPUZZLE 

select 
	   id,
	   a,
	   b,
	   a-b as differens_outputs from thezeropuzzle 


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Product VARCHAR(50),
    Category VARCHAR(50),
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50),
    CustomerID INT
);

INSERT INTO Sales (Product, Category, QuantitySold, UnitPrice, SaleDate, Region, CustomerID)
VALUES
('Laptop', 'Electronics', 10, 800.00, '2024-01-01', 'North', 1),
('Smartphone', 'Electronics', 15, 500.00, '2024-01-02', 'North', 2),
('Tablet', 'Electronics', 8, 300.00, '2024-01-03', 'East', 3),
('Headphones', 'Electronics', 25, 100.00, '2024-01-04', 'West', 4),
('TV', 'Electronics', 5, 1200.00, '2024-01-05', 'South', 5),
('Refrigerator', 'Appliances', 3, 1500.00, '2024-01-06', 'South', 6),
('Microwave', 'Appliances', 7, 200.00, '2024-01-07', 'East', 7),
('Washing Machine', 'Appliances', 4, 1000.00, '2024-01-08', 'North', 8),
('Oven', 'Appliances', 6, 700.00, '2024-01-09', 'West', 9),
('Smartwatch', 'Electronics', 12, 250.00, '2024-01-10', 'East', 10),
('Vacuum Cleaner', 'Appliances', 5, 400.00, '2024-01-11', 'South', 1),
('Gaming Console', 'Electronics', 9, 450.00, '2024-01-12', 'North', 2),
('Monitor', 'Electronics', 14, 300.00, '2024-01-13', 'West', 3),
('Keyboard', 'Electronics', 20, 50.00, '2024-01-14', 'South', 4),
('Mouse', 'Electronics', 30, 25.00, '2024-01-15', 'East', 5),
('Blender', 'Appliances', 10, 150.00, '2024-01-16', 'North', 6),
('Fan', 'Appliances', 12, 75.00, '2024-01-17', 'South', 7),
('Heater', 'Appliances', 8, 120.00, '2024-01-18', 'East', 8),
('Air Conditioner', 'Appliances', 2, 2000.00, '2024-01-19', 'West', 9),
('Camera', 'Electronics', 7, 900.00, '2024-01-20', 'North', 10);

What is the total revenue generated from all sales?

select *from sales 

select *,
		 quantitysold*unitprice as total_revenue 
		 from sales 

What is the average unit price of products?

select 
		 avg(unitprice) as avg_unitprice
		 from sales 


How many sales transactions were recorded?

select *from sales 
select 
 saledate,
 count(*) as counted ,
row_number () over (order by saledate ) as rowed 
from sales
group by 
 saledate


What is the highest number of units sold in a single transaction?

select max(unitprice) as max_value from sales 

How many products were sold in each category?

select count(*) as counted,
category
from sales group by 
category 


What is the total revenue for each region?
select*from sales 
select region,
		 sum(quantitysold*unitprice) as total_revenue 
		 from sales 
		 group by region 

Which product generated the highest total revenue?
with acte_aq as (select 
product,
		 sum(quantitysold*unitprice) as total_revenue 
		 from sales 
		 group by product)

		 select max(total_revenue) as maxe ,product from acte_aq 
		 group by product

Compute the running total of revenue ordered by sale date.

select * from sales 

WITH cte_a AS (
    SELECT *,
           QuantitySold * UnitPrice AS total_revenue
    FROM Sales
)
SELECT 
    cte_a.SaleDate,
    SUM(cte_a.total_revenue) OVER (ORDER BY cte_a.SaleDate) AS running_total
FROM cte_a;


How much does each category contribute to total sales revenue?
select *from sales 
WITH cte_a AS (
    SELECT *,
           QuantitySold * UnitPrice AS total_revenue
    FROM Sales
)
SELECT 
    cte_a.category,
    SUM(cte_a.total_revenue)  AS cat_partion 
FROM cte_a
group by cte_a.category 


Input Table: Customers

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    JoinDate DATE
);
INSERT INTO Customers (CustomerName, Region, JoinDate)
VALUES
('John Doe', 'North', '2022-03-01'),
('Jane Smith', 'West', '2023-06-15'),
('Emily Davis', 'East', '2021-11-20'),
('Michael Brown', 'South', '2023-01-10'),
('Sarah Wilson', 'North', '2022-07-25'),
('David Martinez', 'East', '2023-04-30'),
('Laura Johnson', 'West', '2022-09-14'),
('Kevin Anderson', 'South', '2021-12-05'),
('Sophia Moore', 'North', '2023-02-17'),
('Daniel Garcia', 'East', '2022-08-22');

Show all sales along with the corresponding customer names

select *from Customers
select* from sales 

select * from customers c
inner join sales s on  c.customerid=s.customerid

List customers who have not made any purchases

select * from Customers
select * from sales 

SELECT * 
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.SaleID IS NULL

Compute total revenue generated from each customer

select *from customers
select *from  sales 

SELECT  
		c.customerid,
		c.customername,
		s.product,
		s.quantitysold*s.unitprice as total_revenue
		from sales s inner join 
		customers c on c.customerid=s.customerid

Find the customer who has contributed the most revenue

SELECT  
		c.customerid,
		c.customername,
		max(s.quantitysold*s.unitprice) as max_total_revenue
		from sales s inner join 
		customers c on c.customerid=s.customerid
		group by c.customerid,
		c.customername

Calculate the total sales per customer

SELECT  
		c.customerid,
		c.customername,
		sum(s.quantitysold) as summed
		from sales s inner join 
		customers c on c.customerid=s.customerid
		group by c.customerid,
		c.customername

Input Table: Products

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2)
);
INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice)
VALUES
('Laptop', 'Electronics', 600.00, 800.00),
('Smartphone', 'Electronics', 350.00, 500.00),
('Tablet', 'Electronics', 200.00, 300.00),
('Headphones', 'Electronics', 50.00, 100.00),
('TV', 'Electronics', 900.00, 1200.00),
('Refrigerator', 'Appliances', 1100.00, 1500.00),
('Microwave', 'Appliances', 120.00, 200.00),
('Washing Machine', 'Appliances', 700.00, 1000.00),
('Oven', 'Appliances', 500.00, 700.00),
('Gaming Console', 'Electronics', 320.00, 450.00);

List all products that have been sold at least once
select *from
Products

SELECT DISTINCT p.*
FROM Products p
INNER JOIN Sales s ON p.Category = s.Category;


Find the most expensive product in the Products table

select * from products 
select *
       from products 
	   where sellingprice=(select  max(sellingprice) from products )


Find all products where the selling price is higher than the average selling price in their category

select *
       from products 
	   where sellingprice>(select  avg(sellingprice) from products )
