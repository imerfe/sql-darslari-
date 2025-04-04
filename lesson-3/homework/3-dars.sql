database create database lesson_3_homework
use lesson_3_homework
create table MAAB ( id int,
gender varchar(50),
age int, 
city char(50))
select*from MAAB;


--Easy-Level Tasks (10)
--Define and explain the purpose of BULK INSERT in SQL Server.
--BUlk insert helps to tarnsfer certain date from the another sources, such as excel,csv,xxls...

bulk insert dbo.maab from 'C:\Users\MIRZOBEK\Downloads\Telegram Desktop\new_data.csv ' 
with ( 
firstrow = 2 , 
rowterminator='\n',
fieldterminator= ',')
select*from MAAB; 

--List four file formats that can be imported into SQL Server.
-- they are 1) csv 2) xls?xlsx 3) text 4)xml  

--Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
 create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50),
 Price DECIMAL(10,2))
 select*from products

 --Insert three records into the Products table using INSERT INTO.
 insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'Conserva ', 52.65565)
    insert into products (ProductID,ProductName, Price ) values ( 103, 'chocolate', 19.664065)
	 select*from products
	 
--Explain the difference between NULL and NOT NULL with examples.

create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50) null,
 Price DECIMAL(10,2) null)

  insert into products (ProductID ) values ( 101)
   insert into products (ProductID ) values ( 102)
    insert into products (ProductID) values ( 103)
	select*from products
 
 create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50) not null,
 Price DECIMAL(10,2) not null)


 insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'Conserva ', 52.65565)
   insert into products (ProductID,ProductName, Price ) values ( 103, 'chocolate', 19.664065)

   insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'Conserva ', 52.65565)
   insert into products (ProductID,ProductName) values ( 103, 'chocolate') -- it is kind of therestriction for column and it never works untill user enters data to the column 
	 
--Add a UNIQUE constraint to the ProductName column in the Products table.
create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50) unique,
 Price DECIMAL(10,2))
 
  insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'sok ', 52.65565)
    insert into products (ProductID,ProductName, Price ) values ( 103, 'chocolate', 19.664065) ----- it didnot work because there was used unique function and user should enter another name which is not same with other cells 

 insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'olxori', 52.65565)
    insert into products (ProductID,ProductName, Price ) values ( 103, 'chocolate', 19.664065)

	
--Write a comment in a SQL query explaining its purpose.
/* sql queries are the codes which helps to create table. We use the /**/ and -- these icons help to the write a comment within the codes */


--Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
 create table Categories
 (categoryies int primary key,
 categoryname varchar(50) unique)
 select*from Categories
--Explain the purpose of the IDENTITY column in SQL Server.
 alter table Categories add columnidentity int identity (10,5)
  select*from Categories 

 --Medium-Level Tasks (10)
--Use BULK INSERT to import data from a text file into the Products table.
select*from products;
create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50),
 Price DECIMAL(10,2))
 select*from products;
 
 insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 22.3565)
   insert into products (ProductID,ProductName, Price ) values ( 102, 'Conserva ', 52.65565)
   insert into products (ProductID,ProductName, Price ) values ( 103, 'chocolate', 19.664065)

 BULK INSERT dbo.products FROM 'C:\Users\MIRZOBEK\Desktop\BI Homeworks\excels\new_data.txt'  
WITH (  
    FIRSTROW = 2,  
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n'  
);

select*from products;

--Create a FOREIGN KEY in the Products table that references the Categories table.

FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)

create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50) unique,
 Price DECIMAL(10,2))
  select*from products

 create table Categories
 (categoryies int primary key,
 categoryname varchar(50) unique)
 select*from Categories


--Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
--primary key responsible to perevent the repetation of the values, unique key also like that and you cannot add the same values as an other names or values 

--Add a CHECK constraint to the Products table ensuring Price > 0.

alter table products add constraint chk_price check (price>0)
insert into products (ProductID,ProductName, Price ) values ( 101, 'sok', 5) ---worked 
  select*from products
  
--Modify the Products table to add a column Stock (INT, NOT NULL).
create table products (ProductID INT PRIMARY KEY, 
 ProductName VARCHAR(50) unique,
 Price DECIMAL(10,2)) 
 alter table products add stock int null; 
 insert into products (ProductID,ProductName, Price,stock) values ( 101, 'sok', 3,555)
 insert into products (ProductID,ProductName, Price ) values ( 102, 'olma', 5)
 insert into products (ProductID,ProductName, Price,stock) values ( 103, 'non', 56,36)
 insert into products (ProductID,ProductName, Price ) values ( 104, 'choy', 67)
 insert into products (ProductID,ProductName, Price ) values ( 105, 'cola', 8766)

 select*from products
 
--Use the ISNULL function to replace NULL values in a column with a default value.
select stock, isnull (stock,0) as stock from products 

--Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.


-- Hard-Level Tasks (10)

--Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
create table custamers (
id int primary key,
name varchar(50),
gender varchar(60),
age int )
select*from custamers 
alter table custamers add constraint age check (age>=18) 


--Create a table with an IDENTITY column starting at 100 and incrementing by 10.
alter table custamers add identit int identity (100, 10) 

--Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
create table OrderDetails (
id int not null,
name varchar(50) not null,
gender varchar(60) not null,
age int not null,
primary key (id,age))
 select*from OrderDetails
 
 insert into OrderDetails  (ID,Name, gender,age) values ( 1, 'vali', 'male',15)
 insert into OrderDetails  (ID,Name, gender,age) values ( 1, 'guli', 'female',25)
 

--Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.

create table raw (
id int  null,
name varchar(50)  null,
gender varchar(60) null,
age int null,
)
 select*from raw 
  insert into raw (ID, name,gender) values ( 1,'Mirzobek', 'male')
    insert into raw (ID, name,gender) values ( 2,'bek', 'male')
   insert into raw (ID, name,gender) values ( 3,'moha','male')

SELECT ID, name , COALESCE(age, 0) AS ageValue
FROM raw;

drop table raw 


---isnull

create table raw (
id int  null,
name varchar(50)  null,
gender varchar(60) null,
age int null,
)
 select*from raw 
 insert into raw (ID, name,gender) values ( 1, 'Mirzobek', 'male')
 insert into raw (ID, name,gender) values ( 2,'bek', 'male')
 insert into raw (ID, name,gender) values ( 3,'moha','male')

   SELECT 1, 'Mirzobek', isnull(age, 0) AS age 
FROM raw;

--Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
create table  Employees (
EmpID  int  primary key not null,
name varchar(50)  not null,
email varchar(60) unique not null,
)

select*from Employees
