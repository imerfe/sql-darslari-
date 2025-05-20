create database homework_20_sql 
use homework_20_sql 

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');


1. Find customers who purchased at least one item in March 2024 using EXISTS

select*from #sales 

select s.CUSTOMERNAME from #sales s
where exists 
			(select * from #SALES s2
	where 
			MONTH(SALEDATE)=03  and  year(saledate)=2024)

2. Find the product with the highest total sales revenue using a subquery.

select*from #sales   

select product,sum(price*quantity) as revenue from #sales 
GROUP BY product
having sum(price*quantity)=( select max(SLE.summed) 
from (select sum(price*quantity) AS SUMMED  from  #sales 
group by product ) AS SLE)

3. Find the second highest sale amount using a subquery

select * from #sales  



SELECT S2.SALEID FROM #SALES S2 WHERE 2 =(SELECT COUNT(*) FROM (
	SELECT PRODUCT,SUM(QUANTITY*PRICE) AS SANASH FROM #SALES S1 GROUP BY PRODUCT) AS M
	WHERE M.SALEID=S2.SALEID)

4. Find the total quantity of products sold per month using a subquery

select*from #sales 

select me.number_of_month, me.sumish 
     from ( select  sum(quantity) as sumish,
			   datename(month,min(saledate)) as number_of_month from #sales
			   group by month(saledate)
           ) as me


5. Find customers who bought same products as another customer using EXISTS


select * from #sales 

select s.customername,s.product 
from #sales s
 where exists (select p1.product from #sales p1 
				where s.saleid!=p1.saleid 
		and 
				 p1.product=s.product 
		AND 
				 s.CustomerName <> p1.CustomerName)
group by s.product,s.customername 


6. Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values
('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
('Mario', 'Orange')

select *from Fruits
Expected Output

+-----------+-------+--------+--------+
| Name      | Apple | Orange | Banana |
+-----------+-------+--------+--------+
| Francesko |   3   |   2    |   1    |
| Li        |   2   |   1    |   1    |
| Mario     |   3   |   1    |   2    |
+-----------+-------+--------+--------+



select * from (select name, fruit from fruits) 
	as 
		source_table
		pivot(count(fruit) for fruit in ([Apple],[Orange],[Banana])) as pivots 

7. Return older people in the family with younger ones

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)
Oldest person in the family --1  grandfather 2 Father 3 Son 4 Grandson

select *from family 

;WITH cte_tree AS (
    -- Anchor member: select all parent-child pairs
    SELECT 
        f.childid,
        f.parentid,
        f.parentid AS root_parent  -- Keep track of original parent
    FROM family f

    UNION ALL

    -- Recursive member: join family with cte_tree to find ancestors
    SELECT 
        f1.childid,
        f1.parentid,
        cte_tree.root_parent       -- propagate the original root parent down
    FROM family f1
    JOIN cte_tree 
        ON f1.parentid = cte_tree.childid
)

SELECT * FROM cte_tree;


-- Family jadvali yaratish va ma'lumot kiritish
CREATE TABLE Family (
    ParentID INT,
    ChildID INT
);

INSERT INTO Family VALUES (1, 2), (2, 3), (3, 4);

select*from family 



;WITH family_cte AS (
    SELECT ParentID, ChildID
    FROM Family

    UNION ALL

    SELECT f.ParentID, c.ChildID
    FROM Family f
    INNER JOIN family_cte c ON f.ChildID = c.ParentID
)

SELECT DISTINCT ParentID, ChildID
FROM family_cte
OPTION (MAXRECURSION 0);

	select 


Expected output

+-----+-----+
| PID |CHID |
+-----+-----+
|  1  |  2  |
|  1  |  3  |
|  1  |  4  |
|  2  |  3  |
|  2  |  4  |
|  3  |  4  |
+-----+-----+

8. Write an SQL statement given the following requirements.
For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


select*from #Orders

select customerid, deliverystate from  #ORDERS 
	where deliverystate='TX' AND customerid IN (select DISTINCT customerid
				from #orders 
						where deliverystate='CA')

select customerid, deliverystate from (select deliverystate 
				from #orders 
						where deliverystate='CA')
						

9. Insert the names of residents if they are missing

select *from #residents 
create table #residents(resid int identity, fullname varchar(50), address varchar(100))
insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

select resid, address,
case 
	when address like '%name%' then address
	else 
	  address + 'name=' + fullname
	end
from #residents 

update #residents set address = address + 'name='+ fullname 
where fullname not like '%name=%'

10. Write a query to return the route to reach from Tashkent to Khorezm. 
The result should include the cheapest and the most expensive routes

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select *from #Routes

Expected Output

|             Route                                 |Cost |
|Tashkent - Samarkand - Khorezm                     | 500 |
|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |


11. Rank products based on their order of insertion.

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

select * from #RankingPuzzle

WITH ProductRanks AS (
    SELECT *, 
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProductRank
    FROM #RankingPuzzle
)
SELECT * FROM ProductRanks;


Question 12

Find employees whose sales were higher than the average sales in their department


select*from #employeesales 

select*from #employeesales where salesamount>(
select avg(salesamount) from #employeesales
)

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

13. Find employees who had the highest sales in any given month using EXISTS

select*from #employeesales 
select *from #employeesales 
where salary exists( select max(salesamount),salesmonth from #employeesales group by salesmonth)
group by salesmonth,employeename

14. Find employees who made sales in every month using NOT EXISTS 


select * from #employeesales 

select employeename,employeeid from #employeesales 
where not exists (select employeename,salesmonth from #employeesales group by employeename) 


15. Retrieve the names of products that are more expensive than the average price of all products.

select *from Products 

select *from products where 
price> (select avg(price) from products )

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);


16. Find the products that have a stock count lower than the highest stock count.

select *from  products 
select*from products where stock<(select max(stock) from products)

17. Get the names of products that belong to the same category as 'Laptop'.

select name,category from products where category=(select category from products where name)

18. Retrieve products whose price is greater than the lowest price in the Electronics category.

select*from products 
select name,category, price from products 
where price > (select min(price) 
from products where category = 'Electronics')
 and category = 'Electronics'


19. Find the products that have a higher price than the average price of their respective category.

select name, category,price from products as p2 where price > 
			(				
				select avg(price) from products where category=p2.category  )

select *from products  

;with cte_grup as 
(select avg(price) as avg_price, category from products group by category) 
 
select 
p.name, 
p.category,
p.price   from products p 
inner join  cte_grup on 
p.category=cte_grup.category
where p.price > cte_grup.avg_price;

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


20. Find the products that have been ordered at least once.

select *from orders 
select *from Products where productid in (select productid from products p where p.ProductID=ProductID)


21. Retrieve the names of products that have been ordered more than the average quantity ordered.

select* from products 
select *from orders 

;with cte_solishtirish as (
select avg(Quantity) as avareged_qauntity from orders),
	cte_sumish as (
select sum(quantity) as summed_quantity, PRODUCTID FROM ORDERS GROUP BY ProductID)

select  cte_solishtirish.avareged_qauntity,
		cte_sumish.summed_quantity,
        p.ProductID,
		p.name 
		from products p 
		join cte_solishtirish on 1=1
		join cte_sumish on cte_sumish.productid=p.productid
		where cte_solishtirish.avareged_qauntity < cte_sumish.summed_quantity


22. Find the products that have never been ordered.

select *from orders 
select *from Products

select PRODUCTID,name from products where productid not in (select productid from orders) 


23. Retrieve the product with the highest total quantity ordered.

select *from orders 
select *from Products

;with cte_highest as (select top 1 SUM(quantity) AS TOTALED, ProductID from orders GROUP BY ProductID
order by TOTALED desc)

SELECT P.NAME,
       P.PRODUCTID,
	   cte_highest.TOTALED 
 FROM cte_highest 
 inner join Products p on  P.PRODUCTID=cte_highest.ProductID
