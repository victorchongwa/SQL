
/*
CTE (common table expressions)
*/

WITH CTE_employee as
(
select FirstName, LastName, Gender, salary,
  count(gender) over (partition by gender) as totalgender,
  avg(salary) over (partition by gender) as avgsalary
from bootcam.dbo.EmployeeDemographics 
join bootcam.dbo.employeesalary 
on employeedemographics.employeeid = employeesalary.employeeid
)
SELECT *
FROM CTE_employee