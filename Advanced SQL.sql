# Subqueries in SQL Advanced SQL VIA Simplilearn
# Connected to the WORK Bench 

# Subqueries
# A query embedded in another subquery

# using the database
USE sql_hr;

# checking the content of the table 
SELECT *
FROM employees;

# Finding emplyoess salaray greater than the average salaries
SELECT *
FROM employees
WHERE salary > (SELECT avg(salary) FROM employees);


# Creating a query that will compare with an employees salaray and take out those that are greater than the assigned emplyee
SELECT *
FROM employees
WHERE salary > (
SELECT salary
FROM employees
WHERE first_name = 'North'
);

SELECT salary
FROM employees
WHERE first_name = 'North';

USE classicmodels;

SELECT *
FROM products;

SELECT *
FROM orderdetails;
# Price is less than 100 dollars
SELECT productCode, productName, MSRP 
FROM products
WHERE productCode IN (
SELECT productCode
FROM orderdetails
WHERE priceEach < 100);

SELECT *
FROM orderdetails
WHERE priceEach < 100;

## Stored  Procedure
# reusable sql query

USE sql_hr;

SELECT *
FROM employees

delimiter &&
create procedure top_salary()
begin
select *
from employees
where salary > 60000;
end &&
delimiter ;
# default delimeter

call top_salary;

# In parameters inside the sotred procedure
delimiter //
create procedure sort_salray(IN var int)
begin 
select *
from employees
order by salary desc limit var;
end //
delimiter ;

 
 delimiter //
 create procedure update_salaries_1 (IN temp_name varchar(20), IN new_salary int)
 begin 
 update employees set
 salary = new_salary where first_name = temp_name;
 end //
 
 #
 call update_salaries_1 ('North', 100000);
 
SELECT *
FROM employees;

# SP Usinf OUT parameter

delimiter //
create procedure Count_office_ID_1 (OUT Total_Count int)
begin
select count(office_id) into Total_Count 
from employees;
end //
delimiter ;

call Count_office_ID_1(@1);
select @1 as number_s;

# Triggers in SQL 
# data manupulation, data insert and log in triggers


# creating a table

create table students
(
student_roll int,
student_age int,
student_name varchar(30),
student_obtained_marks float
);

# trigger command

delimiter //
create trigger marks_verify
before insert on students
for each row
if new.student_obtained_marks<0 
then set new.student_obtained_marks=50;
end if ; //

# calling triggers
insert into students 
values (501, 15, 'Sam', 75.0),
(502, 12, 'Mike', -20.5),
(503, 18, 'Dave', 90.0);

select *
from students

drop trigger marks_verify

# Views in SQL
use classicmodels;

select *
from customers;

create view cust_details
as
select customerName, phone, city
from customers;

select *
from cust_details;


select *
from productlines

# view joining tables 

create view product_description
as
select productName, quantityinstock, msrp, textdescription
from products as p 
inner join productlines as pl
on p.productline = pl.productline;

select *
from product_description

# display view
show full tables
where table_type = 'VIEW';


# renaming

rename table product_description 
to vehicle_description


# delete view

drop view cust_details;


# windows function
use sql_hr;

select *
from employees;

# printing total salaries

select first_name, last_name, job_title, office_id,
sum(salary) over (partition by office_id) as total_salray
from employees;

# row number
select row_number() over (order by salary) as row_numb, first_name, last_name, job_title, office_id,salary
from employees
order by salary desc;


#
create table demo (
st_id int, 
st_name varchar(20)
);

insert into demo
values (101, 'shane'),
(102, 'same'),
(101, 'shane');

select *
from demo

select st_id, st_name, row_number() over (partition by st_id, st_name order by st_id) as ss
from demo

# rank function

create table demo1 (
var_a int);

insert into demo1
value (101), (102), (103), (103), (103), (104);

select *,
rank() over (order by var_a) as test_rank2
from demo1;

# first value window function

select *, first_value(first_name)
over (order by salary desc) as highest_salray
from employees

select *, first_value(first_name)
over (partition by job_title order by salary desc) as highest_salra
from employees