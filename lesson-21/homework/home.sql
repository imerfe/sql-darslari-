
CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL)

INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);

Write a query to assign a row number to each sale based on the SaleDate.

SELECT*,
ROW_NUMBER() OVER(ORDER BY SaleDate) AS RANKED  FROM ProductSales


Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.

SELECT*FROM ProductSales

SELECT productname,
	   sum(quantity) as summed, 
	   rank() OVER (ORDER BY SUM(QUANTITY)desc ) AS RANKED FROM ProductSales
	   group by productname


Write a query to identify the top sale for each customer based on the SaleAmount.


SELECT*FROM ProductSales

go 
;with cte as (
		select sum(saleamount) as summed,
	    customerid,
		row_number() over(order by sum(saleamount) desc) as descended  
	    from  ProductSales 
		group by customerid)
select*from cte where cte.descended=1


Write a query to display each sale's' amount along with the next sale amount in the order of SaleDate.

select  productname,
		saledate, 
		saleamount,
		saleid,
		lead(saleamount) over (order by saledate) as logged  
		from ProductSales
		order by saledate 



--Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

select productname,
		saledate, 
		saleamount,
		saleid,
		lag(saleamount) 
			over 
				( order by saledate) as saled1
		from ProductSales
	


Write a query to identify sales amounts that are greater than the previous sale's' amount

SELECT*FROM ProductSales
go
;with cte as (
select productname,
	   saleamount,
	   saleid,
	   lag(saleamount) over (order by saleamount) as selected_saleid 
	   from ProductSales
)

select cte.productname,
		cte.saleamount,
		cte.saleid,
		cte.selected_saleid
		from cte 
		where cte.selected_saleid < cte.saleid
		 
Write a query to calculate the difference in sale amount from the previous sale for every product


select  productname,
		saleamount,
		saleid,
		lag(saleamount) over(order by saleamount) as lagged,
		(saleamount-lag(saleamount) over(order by saleamount)) as difference_amount
		from productsales 
		

Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

select  productname,
		saleamount,
		saleid,
		lead(saleamount) over(partition by productname order by saledate) as next_amount,
		abs((lead(saleamount) over(order by saleamount)/saleamount)-1)*100 as percentaged 
		from productsales 




Write a query to calculate the difference in sale amount from the very first sale of that product.


SELECT*FROM ProductSales

select productname,
		saleamount,
		saleid,
		first_value(saleamount) over(partition by productname order by saledate) as first_amount,
		abs(first_value(saleamount) over(partition by productname order by saledate)-saleamount) as dif_amount 
		from productsales 


Write a query to find sales that have been increasing continuously for a product 
( each sale amount is greater than the previous sale amount for that product)

go
;with cte as (
SELECT 
    productname,
    saleid,
    saledate,
    saleamount,
    LAG(saleamount) OVER (PARTITION BY productname ORDER BY saledate) AS previous_amount
FROM ProductSales)
select *from cte where cte.saleamount > cte.previous_amount

--Write a query to calculate a "closing balance"(running total) for sales amounts which adds
--thecurrent sale amount to a running total of previous sales.

SELECT 
    productname,
    saleid,
    saledate,
    saleamount,
	sum(saleamount) over (partition by productname order by saledate  rows between 1 preceding and current row) as
	closing_balance_last_2
	FROM ProductSales;
	
Write a query to calculate the moving average of sales amounts over the last 3 sales.

select productname,
	   saleid,
       saledate,
       saleamount,
	   avg(saleamount) over (partition by productname order by saledate rows between 2 preceding and current row )
	   as overed_3_amount
	   from productsales 

Write a query to show the difference between each sale amount and the average sale amount.

select productname,
	   saleid,
       saledate,
       saleamount,
	   avg(saleamount) over (partition by productname order by saledate)  as averaged_amount,
	   abs(saleamount-avg(saleamount) over (partition by productname order by saledate)) as differed 
	   from productsales 

CREATE TABLE Employees1 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');


Find Employees Who Have the Same Salary Rank

select *from employees1 
go
;with cte as (
select name, 
	   employeeid,
	   department,
	   salary,
	   dense_rank() over (order by salary desc) as densed from Employees1)

, double_ranking as (
			   select densed 
			   from cte
			   group by densed
			   having count(*) > 1)


select * from cte
join double_ranking on double_ranking.densed = cte.densed

Identify the Top 2 Highest Salaries in Each Department


select* from Employees1 

go
;with cte_max as (
select name,
	   department,
	   salary,
	   hiredate,
	   row_number() over (partition by department order by salary desc) as maxed_salary 
	   from Employees1 )

	   select * from cte_max
	   where cte_max.maxed_salary<=2



Find the Lowest-Paid Employee in Each Department


go
;with cte_max as (
select name,
	   department,
	   salary,
	   hiredate,
	   row_number() over (partition by department order by salary asc) as maxed_salary 
	   from Employees1 )

	   select * from cte_max
	   where cte_max.maxed_salary=1

Calculate the Running Total of Salaries in Each Department


select* from Employees1 

select name,
       department,
	   salary,
	   hiredate, 
	   sum(salary) over ( partition by department order by hiredate ) as running_total 
	   from Employees1



Find the Total Salary of Each Department Without GROUP BY

select distinct 
       department,
	   sum(salary) over ( partition by department ) as total 
	   from Employees1
	  
	

Calculate the Average Salary in Each Department Without GROUP BY

select distinct
        department, 
		avg(salary) over (partition by department) as avarege_salary 
		from employees1 

Find the Difference Between an Employee’s Salary and Their Department’s Average

select distinct
        department, 
		name, 
		salary,
		avg(salary) over (partition by department) as avarege_salary,
		abs(salary-avg(salary) over (partition by department)) as dif_salary 
		from employees1  


Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)


select* from Employees1

select 
		name,
		department,
		salary,
		avg(salary) over( order by hiredate rows between 1 preceding and  1 following ) as averaged_salary
		from Employees1
		


Find the Sum of Salaries for the Last 3 Hired Employees



select* from Employees1
go
;with cte_3_last as (
  select 
		name,
	    department,
		hiredate,
		salary,
		row_number() over( order by hiredate desc) as summed_salary 
		from Employees1
         )

  select sum(cte_3_last.salary) as lest_3_employees_salary_summed_rate  from cte_3_last where cte_3_last.summed_salary<=3
