
-- Find Employees with Minimum Salary
--Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)



 select *from employees 

 select top 2*from employees 
 order by salary asc
 
 select  id, name, salary from employees
 where salary=(select min(salary) from employees)


CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);


--2. Find Products Above Average Price
--Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)


select *from products

select id, product_name, price from products 
where price>(select avg(price) from products )


CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);


--Level 2: Nested Subqueries with Conditions
--3. Find Employees in Sales Department 
--Task: Retrieve employees who work in the "Sales" department. Tables: employees (columns: id, name, department_id), 
--departments (columns: id, department_name)

select*from employees 
select*from departments

select e.id, e.name, e.department_id from employees e where e.department_id=(select d.id from departments d where d.department_name='sales')

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);



4. Find Customers with No Orders
Task: Retrieve customers who have not placed any orders. Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

select*from customers 
select*from Orders

select c.name,c.customer_id from customers c where exists(select*from orders o where o.customer_id!=c.customer_id ) 
select c.name,c.customer_id from customers c where not exists(select*from orders o where o.customer_id=c.customer_id ) 


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);





Level 3: Aggregation and Grouping in Subqueries
5. Find Products with Max Price in Each Category
Task: Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)
 

 select*from products

select p.id, p.product_name, p.price, p.category_id from products  p where p.price= 
( select max(p1.price) from products p1 where p1.category_id=p.category_id   group by p1.category_id  )  

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);


6. Find Employees in Department with Highest Average Salary
Task: Retrieve employees working in the department with the highest average salary. 
Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)


select d.id, d.department_name, E.NAME,E.SALARY   from  departments d JOIN employees E
ON  D.ID=E.ID
where  e.salary >=(select  avg (salary) from employees  )


CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

 select*from departments


CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);






Level 4: Correlated Subqueries
7. Find Employees Earning Above Department Average
Task: Retrieve employees earning more than the average salary in their department.
Tables: employees (columns: id, name, salary, department_id)
 

 SELECT*FROM EMPLOYEES 



 SELECT E.id, E.name, E.salary, E.department_id FROM EMPLOYEES E 
 join (select department_id, avg(salary) AS AVG_SALARY from EMPLOYEES GROUP BY department_id) AS DEPT_AVG ON E.department_id= DEPT_AVG.department_id
 WHERE E.salary>DEPT_AVG.AVG_SALARY
 
 


CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);



8. Find Students with Highest Grade per Course
Task: Retrieve students who received the highest grade in each course. 
Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)


 select*from students
  select*from  grades


  SELECT S.student_id, s.name, G.grade, G.course_id FROM grades g
  JOIN ( SELECT course_id, MAX(grade) AS MAX_GRADE FROM GRADES GROUP BY COURSE_ID) 
  AS COUNTED_ID ON G.course_id=COUNTED_ID.course_id  and g.grade=COUNTED_ID.MAX_GRADE
  join students s on S.STUDENT_ID =G.student_id


CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);




Level 5: Subqueries with Ranking and Complex Conditions
9. Find Third-Highest Price per Category 
Task: Retrieve products with the third-highest price in each category. 
Tables: products (columns: id, product_name, price, category_id)


select max(p1.price), p1.category_id  from products p1
where 3=(select count(distinct p2.price) from products p2 
where p1.price <= p2.price and p1.category_id=p2.category_id)
group by p1.category_id

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);
drop table products 
INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);









10. Find Employees whose Salary Between Company Average and Department Max Salary
Task: Retrieve employees with salaries above the company average but below the maximum in
their department. 
Tables: employees (columns: id, name, salary, department_id)


 select*from employees

 select e.id, e.name, e.salary, e.department_id from employees e where e.salary>
 (select avg(salary) from employees ) and e.salary < (select max(e2.salary)
 from employees e2 where e.department_id=e2.department_id )


CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);


INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);
