create database homework_19_sql 
use homework_19_sql

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);



📄 Task 1:
Create a stored procedure that:

select * from DepartmentBonus
select * from employees


Create procedure nimadir
	as 
      begin 
	       select  e.EmployeeID,
			       concat(e.FirstName, e.LastName) as full_name,
				   d.Department, 
				   e.Salary,
				   (e.Salary * d.bonusPercentage / 100) as BonusAmount
		into #stored_pr 
		from employees e 
		inner join DepartmentBonus d on d.Department=e.Department
		
		SELECT * FROM #stored_pr
		end 
	exec  nimadir

				 
Creates a temp table #EmployeeBonus
Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
(BonusAmount = Salary * BonusPercentage / 100)

Then, selects all data from the temp table.





📄 Task 2:
Create a stored procedure that:

Accepts a department name and an increase percentage as parameters
Update salary of all employees in the given department by the given percentage
Returns updated employees from that department.

select*from employees






🔵 Part 2: MERGE Tasks

Tables to use:
CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);


CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

select * from Products_Current
select * from Products_New

	
			merge into Products_Current as pro
using Products_New as new
on new.productid=pro.productid 

when matched then 
	update set 
		pro.productname=new.productname,
		pro.price=new.price

when not matched by target then 
		insert (productname, price)
		values (new.productname, new.price);

		select * from Products_Current




📄 Task 3:
Perform a MERGE operation that:

Updates ProductName and Price if ProductID matches
Inserts new products if ProductID does not exist
Deletes products from Products_Current if they are missing in Products_New
Return the final state of Products_Current after the MERGE.

select *from Products_Current
select *from  Products_New

MERGE INTO Products_Current AS currents
USING Products_New AS baza 
ON currents.productid = baza.productid

WHEN MATCHED THEN 
    UPDATE SET 
        currents.productname = baza.productname, 
        currents.price = baza.price

WHEN NOT MATCHED BY TARGET THEN 
    INSERT (productname, price)
    VALUES (baza.productname, baza.price)

WHEN NOT MATCHED BY SOURCE THEN 
    DELETE;

📄 Task 4:
Tree Node

Each node in the tree can be one of three types:

"Leaf": if the node is a leaf node.
"Root": if the node is the root of the tree.
"Inner": If the node is neither a leaf node nor a root node.
Write a solution to report the type of each node in the tree.

Input:

CREATE TABLE  Tree (id INT, p_id INT);
TRUNCATE TABLE Tree;
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

select*from tree

Output:

id	type
1	Root
2	Inner
3	Leaf
4	Leaf
5	Leaf

select*from tree


select t1.id,
	case 
	when t1.p_id is null then 'Root'  
    when t1.id in ( select distinct p_id from tree where p_id is not null) then  'inner'
	else 'leaf' 
	end as type
	from Tree t1
	order by t1.id
	
🔗 Solve this puzzle on LeetCode









📄 Task 5:
Confirmation Rate

Find the confirmation rate for each user. 
If  user has no confirmation requests, the rate should be 0.

Input:
CREATE TABLE Signups (
    user_id INT,
    time_stamp DATETIME
);

CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action VARCHAR(10)
);


TRUNCATE TABLE Signups;
INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

Output:

select *from Confirmations
select *from  Signups

user_id	confirmation_rate
6	0.00
3	0.00
7	1.00
2	0.50

select * from Confirmations

	with cte as(
	select 
	user_id,
	count(ACTION) as counted_overall_jarayonni,
	(sum(case when action='confirmed' then 1 else 0 end)*1.0
	/
	count(action)) as natija_foizda
	from Confirmations
	group by user_id )	

	select 
		ISNULL(cte.natija_foizda,0),
		S.user_id 
		FROM Signups S 	
		left join  CTE on s.user_id=cte.user_id
	ORDER BY s.user_id 



select confirmation_rate = confirmed_count / total_count

📄 Task 6:
Find employees with the lowest salary

Input:




CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);


SELECT * FROM employees

SELECT * FROM EMPLOYEES WHERE SALARY=(SELECT MIN(SALARY) FROM EMPLOYEES)

Find all employees who have the lowest salary using subqueries.
 Task 7:
Get Product Sales Summary

Input:

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

--Create a stored procedure called GetProductSalesSummary that:

--Accepts a @ProductID input
--Returns:
--ProductName
--Total Quantity Sold
--Total Sales Amount (Quantity × Price)
--First Sale Date
--Last Sale Date
--If the product has no sales, return NULL for quantity, total amount, first date, and last date, but still return the product name.

SELECT*FROM Products
SELECT*FROM Sales

CREATE PROCEDURE GetProductSalesSummary
	AS 
		begin 
			select
			P.PRODUCTID,
			P.ProductName,
			SUM(S.Quantity) AS Total_Quantity_Sold,
			SUM(S.Quantity*P.Price)  AS Total_Sales_Amount,
			MIN(SALEDATE) AS First_Sale_Date,
			MAX(SALEDATE) AS Last_Sale_Date 
		from PRODUCTS P 
		INNER JOIN SALES S 
			ON 
		P.PRODUCTID = S.PRODUCTID
		GROUP BY P.PRODUCTID, 	P.ProductName
	END 

	EXEC GetProductSalesSummary
