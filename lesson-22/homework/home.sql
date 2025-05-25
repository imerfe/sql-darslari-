create database homework_22_sql
use homework_22_sql

CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')


Easy Questions
Compute Running Total Sales per Customer

select*from sales_data 

SELECT 
    Customer_ID,
    Order_Date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS RunningTotal
FROM sales_data;

Count the Number of Orders per Product Category

select distinct
	  product_category,
	  count(sale_id) over (partition by product_category) as counted_total
	   from sales_data


Find the Maximum Total Amount per Product Category

select*from sales_data 

select distinct 
	  product_category,
	  max(total_amount) over (partition by product_category) as maxed
	   from sales_data

Find the Minimum Price of Products per Product Category

select distinct 
	  product_category,
	  min(total_amount) over (partition by product_category) as maxed
	   from sales_data

Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

select*from sales_data 

select 
      product_name,
	  product_category,
      avg(total_amount) over(partition by product_category order by order_DATE  rows between 1 preceding and 1 following) as avg_sales_amount 
	  from sales_data 


Find the Total Sales per Region

select 
    distinct region,
      sum(total_amount) over(partition by region) as total_sales_amount 
	  from sales_data 

Compute the Rank of Customers Based on Their Total Purchase Amount

select*from sales_data 

select 
	   customer_name,customer_id,
	   sum(total_amount) as summed,
	   rank() over(order by sum(total_amount) desc) 
	   from sales_data 
	   group by customer_name,customer_id
	  

Calculate the Difference Between Current and Previous Sale Amount per Customer

select*from sales_data 
SELECT
    customer_id, 
    customer_name, 
    product_name,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS prev_amount,
    ABS(total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    )) AS difference_amount
FROM sales_data;


Find the Top 3 Most Expensive Products in Each Category

select* from sales_data

go
;with cte_numbers as ( 
select customer_id,
       customer_name,
	   product_category,
	   unit_price,
	   dense_rank() over (partition by product_category order by unit_price desc) as ranked_numbers 
	   from sales_data	)
	   select * from cte_numbers 
	   where cte_numbers.ranked_numbers<=3


--Compute the cumulative Sum of Sales Per Region by Order Date

select* from sales_data

select 
	   product_category,
	   region,
	   order_date,
	   sum(total_amount) over (partition by region order by order_date asc) as total_amount 
	   from sales_data


Medium Questions
Compute Cumulative Revenue per Product Category

select* from sales_data

select distinct 
	   product_category,
	   sum(total_amount) over (partition by product_category ) as total_amount 
	   from sales_data


Here you need to find out the sum of previous values. Please go through the sample input and expected output.
select* from sales_data

Sample Input

| ID |
|----|
|  1 |
|  2 |
|  3 |
|  4 |
|  5 |

Expected Output

| ID | SumPreValues |
|----|--------------|
|  1 |            1 |
|  2 |            3 |
|  3 |            6 |
|  4 |           10 |
|  5 |           15 |

Sum of Previous Values to Current Value

CREATE TABLE OneColumn (
    Value SMALLINT
);

INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);
Sample Input

| Value |
|-------|
|    10 |
|    20 |
|    30 |
|    40 |
|   100 |
Expected Output

| Value | Sum of Previous |
|-------|-----------------|
|    10 |              10 |
|    20 |              30 |
|    30 |              50 |
|    40 |              70 |
|   100 |             140 |


select*from OneColumn 

select 
	   value,
	  sum(value) over(order by value rows between 1 preceding and current row) as previous from onecolumn 
	  

Generate row numbers for the given data. 
The condition is that the first row number for every partition should be odd number.
For more details please check the sample input and expected output.

select*from Row_Nums

with cte as (
select
      id, 
	  VALS,
	  row_number()  over (order by id ) as row_NUMBERS
		FROM Row_Nums 
		)
		select *from cte 
		WHERE cte.row_NUMBERS%2 !=0


CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);

INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

Sample Input

| Id  | Vals |  
|-----|------|  
| 101 |    a |  
| 102 |    b |  
| 102 |    c |  
| 103 |    f |  
| 103 |    e |  
| 103 |    q |  
| 104 |    r |  
| 105 |    p |

Expected Output

| Id  | Vals | RowNumber |
|-----|------|-----------|
| 101 | a    | 1         |
| 102 | b    | 3         |
| 102 | c    | 4         |
| 103 | f    | 5         |
| 103 | e    | 6         |
| 103 | q    | 7         |
| 104 | r    | 9         |
| 105 | p    | 11        |


Find customers who have purchased items from more than one product_category''

select * from sales_data 

WITH CTE_COUNT AS (
  select  CUSTOMER_ID,
		customer_name 
		FROM SALES_DATA 
		GROUP BY CUSTOMER_NAME, CUSTOMER_ID 
		HAVING COUNT(DISTINCT product_category) >1)
		,
		CATEGORY AS (
	SELECT CUSTOMER_ID,
		   PRODUCT_CATEGORY
		   FROM SALES_DATA
)

SELECT  CTE_COUNT.CUSTOMER_ID,
		CTE_COUNT.customer_name ,
		CATEGORY.PRODUCT_CATEGORY 
	FROM CTE_COUNT 
	INNER JOIN CATEGORY
    ON CATEGORY.CUSTOMER_ID=CTE_COUNT.CUSTOMER_ID

Find Customers with Above-Average Spending in Their Region

select * from sales_data 

WITH CTE_AVG AS (
SELECT CUSTOMER_NAME,
	   CUSTOMER_ID, 
	   TOTAL_AMOUNT,
	   REGION,
	   AVG(TOTAL_AMOUNT) OVER (PARTITION BY REGION) AS AVREGED
	   FROM SALES_DATA)
	   
SELECT*FROM CTE_AVG 
WHERE CTE_AVG.TOTAL_AMOUNT>CTE_AVG.AVREGED
	   
Rank customers based on their total spending (total_amount) within each region. 
If multiple customers have the same spending, they should receive the same rank.

select* from sales_data 

select 
	  region,
	  customer_id,
	  customer_name, 
	  sum(total_amount) as sumish,
	  dense_rank() over(partition by region order by sum(total_amount)) as densed 
	  from sales_data 
	  group by region, customer_id, customer_name 

Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

select *from sales_data 

select 
	  total_amount,
	  customer_id,
	  order_date,
	  sum(total_amount) over (partition by customer_id order by order_date ) as cumulative 
	  from sales_data

Calculate the sales growth rate (growth_rate) for each DAY compared to the previous DAY.

select *from sales_data 

;WITH cte_total AS (
    SELECT 
        DAY(order_date) AS DAILY,
        SUM(total_amount) AS SUMMED_TOTAL_AMOUNT
    FROM sales_data 
    GROUP BY DAY(order_date)
)

SELECT 
    cte_total.DAILY,
    cte_total.SUMMED_TOTAL_AMOUNT,
    LAG(cte_total.SUMMED_TOTAL_AMOUNT) OVER (ORDER BY cte_total.DAILY) AS PREV_DAY,
    (cte_total.SUMMED_TOTAL_AMOUNT - LAG(cte_total.SUMMED_TOTAL_AMOUNT) OVER (ORDER BY cte_total.DAILY)) AS DIFFERENCE
FROM cte_total;

Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

select* from sales_data

GO
;WITH CTE_NEW AS(
select customer_id,
	   customer_name,
	   order_date,
	   sum(total_amount) as total_quantity,
	   lag(sum(total_amount)) over (partition by customer_id order by order_date desc) as last_order
	from sales_data
	GROUP BY 
			customer_id, customer_name, order_date)

SELECT *
FROM CTE_NEW
WHERE total_quantity > ISNULL(last_order, 0);  



Hard Questions
Identify Products that prices are above the average product price

SELECT *FROM SALES_DATA

go
;WITH avg_price AS (
    SELECT AVG(UNIT_PRICE) AS overall_avg_price
    FROM SALES_DATA
)

SELECT 
    PRODUCT_NAME,
    UNIT_PRICE
FROM 
    SALES_DATA, avg_price
WHERE 
    UNIT_PRICE > avg_price.overall_avg_price;


In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column.
The challenge here is to do this in a single select. For more details please see the sample input and expected output.

select * from mydata 


CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);

INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

Sample Input

| Id  | Grp | Val1 | Val2 |  
|-----|-----|------|------|  
|  1  |  1  |   30 |   29 |  
|  2  |  1  |   19 |    0 |  
|  3  |  1  |   11 |   45 |  
|  4  |  2  |    0 |    0 |  
|  5  |  2  |  100 |   17 |

Expected Output

| Id | Grp | Val1 | Val2 | Tot  |
|----|-----|------|------|------|
| 1  | 1   | 30   | 29   | 134  |
| 2  | 1   | 19   | 0    | NULL |
| 3  | 1   | 11   | 45   | NULL |
| 4  | 2   | 0    | 0    | 117  |
| 5  | 2   | 100  | 17   | NULL |


select * from mydata 

SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
	when ROW_NUMBER () OVER (PARTITION BY GRP ORDER BY ID )=1
	THEN SUM(VAL1+VAL2)  OVER (PARTITION BY Grp) else null 
	end as lot
	from mydata
	



Here you have to sum up the value of the cost column based on the values of Id. 
For Quantity if values are different then we have to add those values.
Please go through the sample input and expected output for details.
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);

INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);
Sample Input

select *from TheSumPuzzle

| Id   | Cost | Quantity |  
|------|------|----------|  
| 1234 |   12 |      164 |  
| 1234 |   13 |      164 |  
| 1235 |  100 |      130 |  
| 1235 |  100 |      135 |  
| 1236 |   12 |      136 | 

Expected Output

| Id   | Cost | Quantity |
|------|------|----------|
| 1234 | 25   | 164      |
| 1235 | 200  | 265      |
| 1236 | 12   | 136      |


select *from TheSumPuzzle

;WITH ranked_cte AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY id ORDER BY cost) AS rn
    FROM thesumpuzzle
),

cte_x AS (
    SELECT 
        id,
        SUM(cost) AS summed
    FROM thesumpuzzle
    GROUP BY id
)

SELECT 
    r.id,
    c.summed,
    SUM(r.quantity) AS total_quantity
FROM ranked_cte r
JOIN cte_x c ON r.id = c.id
WHERE r.rn = 1
GROUP BY r.id, c.summed
ORDER BY r.id;
 

 select ID, SUM(Cost) AS Cost, SUM(distinct Quantity) AS Quantity  from TheSumPuzzle
Group by id;

From following set of integers, write an SQL statement to determine the expected outputs
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

select* from Seats

Output:
---------------------
|Gap Start	|Gap End|
---------------------
|     1     |	6	|
|     8     |	12	|
|     16    |	26	|
|     36    |	51	|
---------------------

with cte as (
    select 1 as nb 
    union all
    select nb + 1 from cte
    where cte.nb < 54),
cte2 as (
select *,isnull(max(SeatNumber) over(order by cte.nb),0) as sth from cte
full join Seats as S on S.SeatNumber = cte.nb)
select min(cte2.nb) as GapStart,max(cte2.nb) as GapEnd from cte2
where cte2.nb <> cte2.sth
group by cte2.sth



In this puzzle you need to generate row numbers for the given data.
The condition is that the first row number for every partition
should be even number.For more details please check the sample input and expected output.

Sample Input

| Id  | Vals |
|-----|------|
| 101 | a    |
| 102 | b    |
| 102 | c    |
| 103 | f    |
| 103 | e    |
| 103 | q    |
| 104 | r    |
| 105 | p    |

Expected Output

| Id  | Vals | Changed |
|-----|------|---------|
| 101 | a    | 2       |
| 102 | b    | 4       |
| 102 | c    | 5       |
| 103 | e    | 7       |
| 103 | f    | 8       |
| 103 | q    | 9       |
| 104 | r    | 11      |
| 105 | p    | 13      |


CREATE TABLE SampleData (
    Id INT,
    Vals VARCHAR(10)
);

INSERT INTO SampleData (Id, Vals) VALUES
(101, 'a'),
(102, 'b'),
(102, 'c'),
(103, 'f'),
(103, 'e'),
(103, 'q'),
(104, 'r'),
(105, 'p');

select *from sampledata 

WITH Ranked AS (
    SELECT 
        Id,
        Vals,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn,
        DENSE_RANK() OVER (ORDER BY Id) AS grp
    FROM SampleData
),
Adjusted AS (
    SELECT 
        Id,
        Vals,
        (grp * 2) + rn - 1 AS Changed
    FROM Ranked
)
SELECT *
FROM Adjusted
ORDER BY Changed;
