create database Homework_lesson_2;
create table employees2 ( EmpID INT,
NAME CHAR(50),
SALARY DECIMAL (10,2)
);
 Select*from employees2;

 insert into employees2 (EmpID, Name, Salary) values (1,'Mirzobek', 50.3984);
  insert into employees2 (EmpID, Name, Salary) values (2,'Dilshodbek', 49.9984);
   insert into employees2 (EmpID, Name, Salary) values (3,'Murodbek', 78.3344584);
   --delete from employees2  where EmpID=1;
 Select*from employees2;
 insert into employees2 (EmpID, Name, Salary) 
 values (1,'Mirzobek', 50.3984),
 (2,'Dilshodbek', 49.9984),
 (3,'Murodbek', 78.3344584);
  Select*from employees2;
   --delete from employees2  where EmpID=1;
   --delete from employees2  where EmpID=2;
   --delete from employees2  where EmpID=3;
   Select*from employees2;
   update employees2 set salary=59.69 where EmpID=1;
Select*from employees2;
	  delete from employees2 where EmpID=2;
Select*from employees2;
--truncate table employees2;
Select*from employees2;
--drop table employees2;
alter table employees2 add department1 varchar(50);
Select*from employees2;
ALTER TABLE employees2
DROP COLUMN department,departments;
Select*from employees2;
ALTER TABLE employees2 alter column salary float;
Select*from employees2;
--Remove all records from the Employees table without deleting its structure.
truncate table employees2;
Select*from employees2;

--Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
create table departments(departmentID int , DepartmentName VARCHAR(50));
Select*from  departments;

--Intermediate-Level Tasks (6)
--Insert five records into the Departments table using INSERT INTO SELECT from an existing table.
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT  EmpID, Name FROM Employees2;

--Update the Department of all employees where Salary > 50 to 'Management'.
update employees2 set department1=case 
when salary>50 then 'Managment'
when salary<50 then 'Credit'
end;
Select*from employees2;

--Write a query that removes all employees but keeps the table structure intact.
truncate table employees2; 
--Drop the Department column from the Employees table.
drop column department1;

--Rename the Employees table to StaffMembers using SQL commands.
EXEC sp_rename 'employees2','StaffMembers';
select*from StaffMembers;
--Write a query to completely remove the Departments table from the database.
drop table StaffMembers;

--Advanced-Level Tasks (9)

--Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
create table
product (ProductID int Primary Key, ProductName VARCHAR(100), Category VARCHAR(50), Price DECIMAL(10,2));
select*from product;

--Add a CHECK constraint to ensure Price is always greater than 0.
 --alter table product add check(price>0) ;
--Modify the table to add a StockQuantity column with a DEFAULT value of 50.
alter table product add constraint price check (price>0);
alter table product add StockQuantity int default 50;

--Rename Category to ProductCategory
EXEC sp_rename 'product.Category', 'ProductCategory', 'COLUMN';
select*from product;

--Insert 5 records into the Products table using standard INSERT INTO queries.

INSERT INTO product (ProductID, ProductName, ProductCategory, Price, StockQuantity) 
VALUES (1, 'olma', 'meva', 52.652,100);
INSERT INTO product (ProductID, ProductName, ProductCategory, Price, StockQuantity) 
VALUES(2, 'nok', 'meva', 60.2165,200);
INSERT INTO product (ProductID, ProductName, ProductCategory, Price, StockQuantity) 
VALUES(3, 'olxori', 'meva', 98.2365,252);
INSERT INTO product (ProductID, ProductName, ProductCategory, Price, StockQuantity) 
VALUES(4, 'tarvuz', 'sabzavot', 12.3652,325);
INSERT INTO product (ProductID, ProductName, ProductCategory, Price, StockQuantity) 
VALUES(5, 'kartoshka', 'sabzavot', 27.23692,345);
select*from product;

--Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
select*into Products_Backup from product;

--Rename the Products table to Inventory.
Exec sp_rename 'product', 'Inventory';
select*from Inventory;

--Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
 alter table inventory drop constraint price;  
 alter table Inventory alter column Price float;
 alter table inventory add constraint price check (price>1);
 select*from Inventory;
--Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.
alter table inventory add ProductCode int identity (1000,5);
select*from Inventory;
