--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [EmployeeID]
--      ,[FirstName]
--      ,[LastName]
--      ,[Age]
--      ,[Gender]
--  FROM [bootcam].[dbo].[EmployeeDemographics]


--case statement--
  select FirstName,LastName, age,
  case 
    when age > 30 then 'old'
	when age < 29 then 'young'
	else 'baby' 
	
  end
  from EmployeeDemographics
  order by age

  ---usecase--- salary increase pere job title--
  select FirstName, LastName, jobtitle, salary,
  case
     when jobtitle = 'salesman' then salary + (salary * .10)
	 when jobtitle = 'accountant' then salary + (salary * .5)
	 when jobtitle = 'HR' then salary + (salary * .3)
	 else salary + (salary * .002)
  end as salaryrais
  from bootcam.dbo.EmployeeDemographics
  join bootcam.dbo.EmployeeSalary
  on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

  
  