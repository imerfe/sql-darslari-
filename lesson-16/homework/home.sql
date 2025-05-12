--Easy Tasks
--Create a numbers table using a recursive query from 1 to 1000

CREATE TABLE #number (numbers INT);

DECLARE @numbers INT = 1;

INSERT INTO #number VALUES (@numbers);


SELECT numbers FROM #number

;with cte as (SELECT 1 as number 
union all 
select number+1 
from cte
where number < 1000) 

insert into #number (numbers)
select number from cte 
OPTION (MAXRECURSION 1000);


--Write a query to find the total sales per employee using a derived table.(Sales, Employees)

select*from Sales
select*from Employees

select e.firstname, e.lastname, coalesce(t.total_sales,0) as total_sales 
from employees e 
left join (select employeeid, sum(salesamount) as total_sales 
from sales group by employeeid) as t
on t.employeeid=e.employeeid 

--Create a CTE to find the average salary of employees.(Employees)

select*from  Employees

;with avg_cte as(
select DepartmentID,avg(salary) as avg_sal from employees 
group by DepartmentID)

select  e.DepartmentID, e.firstname,e.lastname,e.salary,avg_cte.avg_sal from employees e
inner join avg_cte on avg_cte.DepartmentID=e.DepartmentID 


SELECT * FROM cte;

--Write a query using a derived table to find the highest sales for each product.(Sales, Products)

select * from Sales
select * from Products

;with highest_cte as (
select max(salesamount) as max_sales_amounts, productid from sales
group by productid)

select p.PRODUCTid, p.productname, p.price,highest_cte.max_sales_amounts
	from 
		products p
	inner join 
	highest_cte on p.ProductID = highest_cte.ProductID


--Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.


create table #double_number ( number int )

declare @number int =1 

;with double_cte as (select 1 as number 
union all 
select number*2 from double_cte where number*2<1000000
)
insert into #double_number (number)
select number from double_cte
option(maxrecursion 1000)
SELECT * FROM #double_number;



--Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)


select*from  Sales
select*from  Employees


;with sales_5_cte as ( select count(salesid) as counted_sales, employeeid from sales 
group by employeeid 
having count(salesid)>=5)
select  e.firstname, e.lastname, e.employeeid, sales_5_cte.counted_sales from employees e 
inner join sales_5_cte on sales_5_cte.employeeid=e.employeeid

--Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

select*from  Sales
select*from Products


;with sales_cte_500 as (select sum(SalesAmount) as summed_amount , productid from Sales
group by productid 
having sum(SalesAmount)>500 )
select p.productid, sales_cte_500.summed_amount,p.productname from products p 
inner join sales_cte_500 on sales_cte_500.productid=p.productid
 
--Create a CTE to find employees with salaries above the average salary.(Employees)

select*from Employees

;with avg_cte as ( select avg(salary) as averaged_salary from employees )
	select e.employeeid, e.firstname, e.lastname, e.salary from employees e
		inner join avg_cte on avg_cte.averaged_salary < e.salary


--Medium Tasks
--Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

select*from  Sales
select*from Employees

select top 5
e.employeeid, 
e.firstname,
e.lastname from employees e 
inner join  (select count(salesid) as countish ,employeeid from sales 
group by employeeid) as f on f.employeeid=e.employeeid
order by f.countish desc


--Write a query using a derived table to find the sales per product category.(Sales, Products)

select*from  Sales
select*from Products



select s.sumish, grup.CategoryID
from products p 
inner join 
(select sum(salesamount) as sumish, productid 
from sales group by productid) as s on p.productid=s.productid
inner join (select DISTINCT CategoryID from products  
) as grup on grup.CategoryID=p.CategoryID



SELECT 
    p.CategoryID,
    SUM(s.SalesAmount) AS TotalSales
FROM 
    Products p
JOIN 
    Sales s ON p.ProductID = s.ProductID
GROUP BY 
    p.CategoryID;

--Write a script to return the factorial of each value next to it.(Numbers1)

select*from Numbers1

;with cte as (
select 5 number, 5 as factorial
union all 
select (number+1),(number+1)*factorial from cte 
where number+1<10 and number+1>=5)

select*from cte 

--This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

select*from Example 

;with split_cte as (select  string, 1
as starting_postion,substring(string,1,1) as subs from example
union all 
select string,starting_postion+1,substring(string,starting_postion+1,1) from split_cte
where  starting_postion+1 < = len(string))

SELECT  starting_postion, subs
FROM Split_CTE
ORDER BY  starting_postion
OPTION (MAXRECURSION 1000);


--Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

select * from Sales

;with month_cte as (
select employeeid, 
month(saledate) as month_of_sales, 
year(saledate) as year_of_sale, 
sum(SalesAmount) as total_sales,
dateadd(month,-1,getdate()) as previus_month
from sales 
where 
	month(saledate)=month(getdate()) 
		and 
		dateadd(month,-1,getdate())=month(getdate())-1 
			and 
				year(saledate)=year(getdate())
group by employeeid, 
year(saledate)),
sum(SalesAmount)



from sales 
where 
	month(saledate)=month(getdate()) 
		and 
			year(saledate)=year(getdate())
group by employeeid, month(saledate), year(saledate)
union all

s.employeeid, 
month(dateadd(month,-1,getdate())) as previus_month,
sum(salesamount) as differs
from sales s
group by employeeid, 
year(saledate) 
)

left join (
select 
s.employeeid, 
month(dateadd(month,-1,getdate())) as previus_month,
sum(salesamount) as differs
from sales s
group by employeeid, 
year(saledate) ) on month_cte.employeeid



--Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

select * from Sales
select * from  Employees

SELECT 
    e.employeeid,
    e.firstname,
    e.lastname,
    sales_per_q.quarter,
    sales_per_q.total_sales
FROM
    (
        SELECT 
            employeeid,
            DATEPART(QUARTER, saledate) AS quarter,
            SUM(salesamount) AS total_sales
        FROM 
            Sales
        GROUP BY 
            employeeid, DATEPART(QUARTER, saledate)
        HAVING 
            SUM(salesamount) > 4500
    ) AS sales_per_q
JOIN 
    Employees e ON e.employeeid = sales_per_q.employeeid
ORDER BY 
    e.employeeid, sales_per_q.quarter;



--Difficult Tasks

--This script uses recursion to calculate Fibonacci numbers
;with fibon (n, f1, f2) as (
select 1,0,1
union all
select n+1, f2, f1+f2 
from fibon 
where n<10)
select n, f1 as fibon_numbers 
from fibon 


--Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

select * from  FindSameCharacters
SELECT *
FROM FindSameCharacters
WHERE 
    LEN(vals) > 1 AND        
    vals NOT LIKE '%[^' + LEFT(vals, 1) + '%]';

--Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.
--(Example:n=5 | 1, 12, 123, 1234, 12345)

declare @n int= 10;

;with numbers_cte(num,string) as
(
select 1 , cast(1 as varchar(max))
union all 
select num+1, string + cast(num+1 as varchar(max)) from numbers_cte
where num+1<=@n )

select string from numbers_cte
option (maxrecursion 100)

--Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

select * from  Employees
select * from  Sales

select e.employeeid,e.firstname, e.lastname,derived.total_sale_amount,derived.dated_date  from employees e 
inner join (select s.employeeid,dateadd(month,-6,getdate()) as dated_date, sum(salesamount) as total_sale_amount from sales s
where s.saledate> = dateadd(month,1,getdate())
 group by s. employeeid)
 as derived on  e.employeeid=derived.employeeid 
order by derived.total_sale_amount  desc

select * from  Employees
select * from  Sales

--Write a T-SQL query to remove the duplicate integer values present in the string column. 
--Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

select * from  RemoveDuplicateIntsFromNames

;WITH SplitValues AS (
    SELECT 
        Pawan_slug_name,
        LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name)) AS NamePart,
        RIGHT(Pawan_slug_name, LEN(Pawan_slug_name) - CHARINDEX('-', Pawan_slug_name)) AS NumberPart
    FROM RemoveDuplicateIntsFromNames
),
Processed AS (
    SELECT 
        Pawan_slug_name,
        NamePart,
        NumberPart,
        CASE 
            WHEN LEN(NumberPart) = 1 THEN ''  -- 1 xonali bo‘lsa, olib tashlash
            ELSE
                -- faqat noyob raqamlarni olish
                (
                    SELECT '' + value
                    FROM (
                        SELECT DISTINCT SUBSTRING(NumberPart, number, 1) AS value
                        FROM master.dbo.spt_values
                        WHERE type = 'P' AND number BETWEEN 1 AND LEN(NumberPart)
                    ) AS DistinctChars
                    ORDER BY value
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)')
        END AS CleanedNumbers
    FROM SplitValues
)
SELECT 
    Pawan_slug_name,
    NamePart + CleanedNumbers AS CleanedResult
FROM Processed;





