/*
temp tables (temporary tables)
*/

drop table if exists #temp_employee1
create table #temp_employee1(
    jobtitile varchar(50),
	employeesperjob int,
	avgage int,
	avgsalart int
)
insert into #temp_employee1
select jobtitle, count(jobtitle), avg(age), avg(salary)
from bootcam.dbo.EmployeeDemographics
join bootcam.dbo.EmployeeSalary
on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
group by jobtitle

select *
from #temp_employee1