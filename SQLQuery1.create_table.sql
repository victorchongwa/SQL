create table EmployeeDemograpics(
EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Gender varchar(50),
Age int
)

create table EmployeeSalary(
EmployeeID int,
Jobtitle varchar(50),
salary int
)


----table 1 insert:-------
insert into EmployeeDemograpics VALUES
(1001, 'Jim', 'Halpert', 'Male', 30),
(1002, 'Pam', 'bery', 'Female', 23),
(1003, 'Angela', 'clair', 'Female', 25),
(1004, 'Toby', 'Flenderson', 'Male', 30),
(1005, 'Michael', 'Scott', 'Male', 35),
(1006, 'Meredith', 'Palmer', 'Female', 32),
(1007, 'Stanley', 'Hudson', 'Male', 38),
(1008, 'Kevin', 'Malone', 'Male', 40)


select * FROM EmployeeDemograpics

-----Table 2 insert-----
Insert into EmployeeSalary VALUES
(1001, 'Salesman', 60000),
(1002, 'Receptionist', 50000),
(1003, 'Accountant', 55000),
(1004, 'Cleaner', 20000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000)

SELECT * FROM EmployeeSalary