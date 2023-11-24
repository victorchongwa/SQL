---having clause-- usecase--
select jobtitle, AVG(salary)
from bootcam.dbo.EmployeeDemographics
join bootcam.dbo.EmployeeSalary
on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
group by jobtitle
having AVG(salary) > 45000
order by AVG(salary)
