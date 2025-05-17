use homework_18_sql
--Lesson-18: View, temp table, variable, functions
--Notes before doing the tasks:
use 
--Tasks should be solved using SQL Server.
--Case insensitivity applies.
--Alias names do not affect the score.
--Scoring is based on the correct output.
--One correct solution is sufficient.
--You're working in a database for a Retail Sales System. 
--The database contains the following tables:

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');


1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.

select *from products 
select *from sales 

create table #MonthlySales (ProductID int , TotalQuantity int, TotalRevenue decimal(10,2))

insert into #MonthlySales (ProductID  , TotalQuantity , TotalRevenue )

select		
            p.productid,
            sum(s.quantity), 
			sum(p.price*s.quantity)
		    from  products p 

inner join sales s on p.productid=s.productid 

where month(saledate)= month(getdate()) and 
	year(saledate)= year(getdate())
group by p.productid


select *from #MonthlySales
	 
Return: ProductID, TotalQuantity, TotalRevenue



2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.

select *from products 
select *from sales 

alter view vw_ProductSalesSummary as (
   select  
   p.ProductID,
   p.Category,
   p.productname,
		sum(s.quantity) as TotalQuantitySold  
		from products p
		inner join sales s on s.productid=p.productid
		GROUP BY 
    p.ProductName,p.ProductID,
   p.Category)


	select *from vw_ProductSalesSummary


Return: ProductID, ProductName, Category, TotalQuantitySold

3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
Return: total revenue for the given product ID




CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductID,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Sales s
    INNER JOIN Products p ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductID
);

SELECT*from  dbo.fn_GetTotalRevenueForProduct(1)




select*from products 
select*from sales 

select p.productid,
 sum(s.quantity*p.price) as sumish  
 
from sales s inner join products p on 
p.productid=s.productid
group by p.productid 


4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.


select *from products 
select *from sales 


create function fn_GetSalesByCategory(@Category VARCHAR(50))
returns table 
as 
return 
select
	p.ProductName,
	sum(quantity) as TotalQuantity, 
	sum(s.quantity*p.price) as TotalRevenue
	from products p 
inner join sales s on p.productid=s.productid 
where p.Category = @Category
group by p.ProductName


SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');






select
	p.ProductName,
	sum(quantity) as TotalQuantity, 
	sum(s.quantity*p.price) as TotalRevenue
	from products p 
inner join sales s on p.productid=s.productid 
group by p.ProductName


		
	


Now we will move on with 2 Lateral-thinking puzzles (5 and 6th puzzles). 
Lateral-thinking puzzles are the ones that can’t be solved by straightforward logic —
you have to think outside the box. 🔍🧠


5. You have to create a function that get one argument as input from user 
and the function should return 
'Yes' if the input number is a prime number and 'No' otherwise. 
You can start it like this:


Create function fn_IsPrime (@Number INt)
 returns varchar(max)
 as 
 begin 

	
	declare @bolinuvchi int= 2 
	declare @checker int=0
	declare @status varchar(max) 

while @bolinuvchi < @number 
begin 
	if @number % @bolinuvchi != 0
		begin 
			set @checker = 1  --cheker prime bolsa 1 qoyadi bolmasa 0 
			set @bolinuvchi = @bolinuvchi+1 
		end 
	else 
	begin 
			 set @checker = 0
		BREAK 
	END 
END

IF @checker = 0 
		set @status='No'
else 
	 set @status='yes'

	 rETURN @status
END


SELECT dbo.fn_IsPrime(13) AS IsPrime; 
SELECT dbo.fn_IsPrime(20) AS IsPrime; 

This is for those who has no idea about prime numbers: A prime number is a number greater than 1 that has only two divisors: 
1 and itself(2, 3, 5, 7 and so on).

6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

CREATE FUNCTION fn_GetNumbersBetween(@Start INT, @End INT)
RETURNS TABLE
AS
RETURN (
    SELECT Number
    FROM (VALUES (1), (2), (3), (4), (5), (6)) AS t(Number)
    WHERE number BETWEEN @Start AND @End
);

SELECT * FROM dbo.fn_GetNumbersBetween(4, 5);
	
@Start INT
@End INT
The function should return a table with a single column:

| Number |
|--------|
| @Start |
...
...
...
|   @end |


It should include all integer values from @Start to @End, inclusive.






7. Write a SQL query to return the Nth highest distinct salary from the Employee table.
If there are fewer than N distinct salaries, return NULL.

select *from Employee

DECLARE @N INT =1;


select max( e.salary) as max_salary, e.id from employee e 
where @N = (select count(distinct e2.salary) from employee e2 
where e.salary <= e2.salary 
)
group by e.id





DECLARE @N INT =1;

select max( e.salary) as max_salary from employee e 
where @N = (select count(distinct e2.salary) from employee e2 
where e.salary <= e2.salary 
)



-- Create the table
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT
);


-- Insert data into the table
INSERT INTO Employee (id, salary) VALUES (1, 100);
INSERT INTO Employee (id, salary) VALUES (2, 200);
INSERT INTO Employee (id, salary) VALUES (3, 300);



Example 1:

Input.Employee table:

| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |

n = 2

Output:

| getNthHighestSalary(2) |
|    HighestNSalary      |
|------------------------|
| 200                    |


Example 2:

Input.Employee table:

| id | salary |
|----|--------|
| 1  | 100    |

n = 2


Output:

| getNthHighestSalary(2) |
|    HighestNSalary      |
|        null            |



You can also solve this in Leetcode: https://leetcode.com/problems/nth-highest-salary/description/






8. Write a SQL query to find the person who has the most friends.
Return: Their id, The total number of friends they have

CREATE TABLE RequestAccepted (
requester_id INT,
accepter_id INT,
accept_date DATE
);

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES 
    (1, 2, '2016-06-03'),
    (1, 3, '2016-06-08'),
    (2, 3, '2016-06-08'),
    (3, 4, '2016-06-09');

	SELECT*FROM RequestAccepted

	with cte as (
		select count(*) as counted_friend, requester_id as user_id   from RequestAccepted 
			group by requester_id 
	union all
		select count(*) as counted_friend,accepter_id as user_id from RequestAccepted 
			group by accepter_id),


		fulls as (select sum(counted_friend) as all_numbers , user_id from  cte 
	group by user_id )





	select top 1 
			all_numbers,		
			user_id		
		from fulls
		order by all_numbers desc


			




Friendship is mutual. 
For example, if user A sends a request to user B and its accepted, both A and B are considered friends with each other. 
The test case is guaranteed to have only one user with the most friends.
Input.RequestAccepted table:

| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
Output:

| id | num |
+----+-----+
| 3  | 3   |


Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.

9. Create a View for Customer Order Summary.


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);
Create a view called vw_CustomerOrderSummary that returns a summary of customer orders.
The view must contain the following columns:

Column Name | Description
customer_id | Unique identifier of the customer
name | Full name of the customer
total_orders | Total number of orders placed by the customer
total_amount | Cumulative amount spent across all orders
last_order_date | Date of the most recent order placed by the customer

select*from Customers
select*from Orders

create view vw_CustomerOrderSummary as (

select 
	c.customer_id,
	c.name ,
	count(o.order_id) as total_orders,
	sum(o.amount) as total_amount,
	max(o.order_date) as last_order_date  
 from customers c
inner join orders o on c.customer_id=o.customer_id
group by c.customer_id, c.name 
)

select *from vw_CustomerOrderSummary


10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.

select *from gaps 

select count(testcase) as case_lar
from gaps where count(testcase)

from Gaps


with cte_gaps as (

select count(rownumber),count(testcase from gaps 
where testcase is null and 
group by rownumber) 
 

| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         |          |
| 3         |          |
| 4         |          |
| 5         | Bravo    |
| 6         |          |
| 7         |          |
| 8         |          |
| 9         |          |
| 10        | Charlie  |
| 11        |          |
| 12        |          |

Here is the expected output.

| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         | Alpha    |
| 3         | Alpha    |
| 4         | Alpha    |
| 5         | Bravo    |
| 6         | Bravo    |
| 7         | Bravo    |
| 8         | Bravo    |
| 9         | Bravo    |
| 10        | Charlie  |
| 11        | Charlie  |
| 12        | Charlie  |
DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);


select *from gaps 

select count(testcase) as case_lar
from gaps where count(testcase)
