create database homework_17_sql
use homework_17_sql

1.You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, 
provide a zero-dollar value for that day. 
Assume there is at least one sale for each region

;WITH 
crossing_region AS ( 
    SELECT DISTINCT region FROM #RegionSales 
),
crossing_distributor AS ( 
    SELECT DISTINCT Distributor FROM #RegionSales 
)

SELECT  
    cr.region, 
    cd.Distributor, 
    ISNULL(rs.sales, 0) AS sales
FROM 
    crossing_region cr
CROSS JOIN 
    crossing_distributor cd
LEFT JOIN 
    #RegionSales rs 
    ON rs.region = cr.region AND rs.Distributor = cd.Distributor
ORDER BY 
    cd.Distributor, cr.region;

 select*FROM #RegionSales

SQL Setup:

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);
Input:


select*from #RegionSales 


|Region       |Distributor    | Sales |
|-------------|---------------|--------
|North        |ACE            |   10  |
|South        |ACE            |   67  |
|East         |ACE            |   54  |
|North        |Direct Parts   |   8   |
|South        |Direct Parts   |   7   |
|West         |Direct Parts   |   12  |
|North        |ACME           |   65  |
|South        |ACME           |   9   |
|East         |ACME           |   1   |
|West         |ACME           |   7   |

Expected Output:

|Region |Distributor   | Sales |
|-------|--------------|-------|
|North  |ACE           | 10    |
|South  |ACE           | 67    |
|East   |ACE           | 54    |
|West   |ACE           | 0     |
|North  |Direct Parts  | 8     |
|South  |Direct Parts  | 7     |
|East   |Direct Parts  | 0     |
|West   |Direct Parts  | 12    |
|North  |ACME          | 65    |
|South  |ACME          | 9     |
|East   |ACME          | 1     |
|West   |ACME          | 7     |

2. Find managers with at least five direct reports

with least_cte as 
(
select managerid,count(*) as counted from employee
group by managerid)

select e.name, least_cte.counted from least_cte
inner join employee e on e.id=least_cte.managerid
where least_cte.counted>=5



SQL Setup:

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);


select * from employee

Input:

| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |

Expected Output:

+------+
| name |
+------+
| John |
+------+



You cal also solve this puzzle in Leetcode:
https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50



3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
SQL Setup:

;with units_cte as( select 
	product_id,
	sum (unit) as sumish 
	from Orders
	where year(order_date)= 2020 and 
	month(order_date)=2
	group by product_id
	having sum(unit) >= 100)

select u.sumish,p.product_name, p.product_category, p.product_id 
from units_cte u inner join products p on p.product_id=u.product_id

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);


select * from Orders
select * from Products

Input:


| product_id  | product_name          | product_category |
+-------------+-----------------------+------------------+
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |

Expected Output:

| product_name       | unit  |
+--------------------+-------+
| Leetcode Solutions | 130   |
| Leetcode Kit       | 100   |



4. Write an SQL statement that returns the vendor from which each customer has placed the most orders
SQL Setup:


with vendor_cte as ( select 
	sum(count) as summed_count, 
	customerid,
	vendor 
from Orders
group by customerid,vendor)

select*from vendor_cte where summed_count in 
(select max(summed_count) from vendor_cte group by CustomerID) 
order by CustomerID


DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

select * from Orders

Input:

|Order ID   | Customer ID | Order Count|     Vendor     |
---------------------------------------------------------
|Ord195342  |     1001    |      12    |  Direct Parts  |
|Ord245532  |     1001    |      54    |  Direct Parts  |
|Ord344394  |     1001    |      32    |     ACME       |
|Ord442423  |     2002    |      7     |     ACME       |
|Ord524232  |     2002    |      16    |     ACME       |
|Ord645363  |     2002    |      5     |  Direct Parts  |
Expected Output:

| CustomerID | Vendor       |
|------------|--------------|
| 1001       | Direct Parts |
| 2002       | ACME         |



5. You will be given a number as a variable called @Check_Prime check if
this number is prime then return 'This number is prime' else return 'This number is not prime'
Example Input:

declare @input int=1 
DECLARE @Check_Prime INT = 91;
-- Your WHILE-based SQL logic here
Expected Output:



;alter  function Prime_input (@input int )
returns int
as
begin 
  return  @input+1 
  where @input+1=@Check_Prime
  end 

  declare @input int=1 
  select dbo.Prime_input



This number is not prime(or "This number is prime")




6. Write an SQL query to return the number of locations,
in which location most signals sent, and total number of signal for each device from the given table.
SQL Setup:

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);

select *from Device




WITH TotalLocations AS (
    SELECT COUNT(DISTINCT Locations) AS total_locations
    FROM Device
),
TopLocation AS (
    SELECT TOP 1 Locations AS top_location, COUNT(*) AS top_signals
    FROM Device
    GROUP BY Locations
    ORDER BY top_signals DESC
),
DeviceSignals AS (
    SELECT Device_id, COUNT(*) AS total_signals
    FROM Device
    GROUP BY Device_id
)


SELECT 
    ds.Device_id,
    ds.total_signals,
    tl.top_location,
    tl.top_signals,
    tlc.total_locations
FROM DeviceSignals ds
CROSS JOIN TopLocation tl
CROSS JOIN TotalLocations tlc;




INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

Expected Output:

| Device_id | no_of_location | max_signal_location | no_of_signals |
|-----------|----------------|---------------------|---------------|
| 12        | 2              | Bangalore           | 6             |
| 13        | 2              | Secunderabad        | 5             |



7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
Return EmpID, EmpName,Salary in your output


with Employee_cte as (
select avg(salary) as avareged_salary, deptid from employee 
group by deptid )

select Employee_cte.avareged_salary,
e.EmpID,
e.EmpName,
e.Salary from Employee_cte
inner join employee e on e.deptid=Employee_cte.deptid
where e.Salary>=Employee_cte.avareged_salary
order by e.EmpID asc

SQL Setup:
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);

select * from employee

INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

Expected Output:

| EmpID | EmpName | Salary |
|-------|---------|--------|
| 1001  | Mark    | 60000  |
| 1004  | Peter   | 35000  |
| 1005  | John    | 55000  |
| 1007  | Donald  | 35000  |


8. You are part of an office lottery pool where you keep a 
table of the winning lottery numbers along with a table of each ticket’s chosen numbers. 
If a ticket has some but not all the winning numbers, you win $10.
If a ticket has all the winning numbers, you win $100.
Calculate the total winnings for today’s drawing.
Winning Numbers:

|Number|
--------
|  25  |
|  45  |
|  78  |

Tickets:

| Ticket ID | Number |
|-----------|--------|
| A23423    | 25     |
| A23423    | 45     |
| A23423    | 78     |
| B35643    | 25     |
| B35643    | 45     |
| B35643    | 98     |
| C98787    | 67     |
| C98787    | 86     |
| C98787    | 91     |

Expected Output would be $110, as you have one winning ticket, and one ticket that has some but not all the winning numbers.

9. The Spending table keeps the logs of the spendings history of users 
that make purchases from an online shopping website which has a desktop and a mobile devices.
Write an SQL query to find the total number of users and the total amount spent using mobile only,
desktop only and both mobile and desktop together for each date.

select*from Spending 

with total_cte as (select count(*) as users , sum(amount) as summed_amount ,platform,spend_date   from spending
group by platform,spend_date ) 


select 
		total_cte.users,
		total_cte.summed_amount,
		total_cte.platform,
		total_cte.spend_date,
		s.user_id
		from total_cte 
		inner join Spending s 
		on total_cte.users=s.user_id
		group by 





		WITH total_cte AS (
    SELECT 
        COUNT(DISTINCT user_id) AS users, 
        SUM(amount) AS summed_amount,
        platform,
        spend_date
    FROM Spending
    GROUP BY platform, spend_date
)

-- Now, select the data, and join for platform calculation
SELECT 
    spend_date,
    SUM(CASE WHEN platform = 'mobile' THEN users ELSE 0 END) AS mobile_users,
    SUM(CASE WHEN platform = 'desktop' THEN users ELSE 0 END) AS desktop_users,
    SUM(CASE WHEN platform = 'mobile' THEN summed_amount ELSE 0 END) AS mobile_amount,
    SUM(CASE WHEN platform = 'desktop' THEN summed_amount ELSE 0 END) AS desktop_amount,
  
    SUM(CASE WHEN platform = 'mobile' AND s2.platform = 'desktop' THEN users ELSE 0 END) AS both_platform_users,
    SUM(CASE WHEN platform = 'mobile' AND s2.platform = 'desktop' THEN summed_amount ELSE 0 END) AS both_platform_amount
FROM total_cte t
LEFT JOIN Spending s1 ON t.platform = s1.platform AND t.spend_date = s1.spend_date
LEFT JOIN Spending s2 ON s1.user_id = s2.user_id AND s2.platform != s1.platform -- identify users using both platforms
GROUP BY spend_date;




SQL Setup:
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);
Expected Output:

| Row | Spend_date | Platform | Total_Amount | Total_users |
|-----|------------|----------|--------------|-------------|
| 1   | 2019-07-01 | Mobile   | 100          | 1           |
| 2   | 2019-07-01 | Desktop  | 100          | 1           |
| 3   | 2019-07-01 | Both     | 200          | 1           |
| 4   | 2019-07-02 | Mobile   | 100          | 1           |
| 5   | 2019-07-02 | Desktop  | 100          | 1           |
| 6   | 2019-07-02 | Both     | 0            | 0           |












10. Write an SQL Statement to de-group the following data.
Input Table: 'Grouped'

|Product  |Quantity|
--------------------
|Pencil   |   3    |
|Eraser   |   4    |
|Notebook |   2    |
Expected Output:

|Product  |Quantity|
--------------------
|Pencil   |   1    |
|Pencil   |   1    |
|Pencil   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Notebook |   1    |
|Notebook |   1    |
SQL Setup:

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

select*from grouped 


with cte_pr as (
select product, quantity, 1 as changer from grouped where quaNtity > 0
union all
select product,quantity, changer + 1  AS PLUSSED from cte_pr
WHERE changer + 1 <= quantity)

SELECT 1 AS CHANGER,cte_pr.product FROM cte_pr
ORDER BY cte_pr.product 



