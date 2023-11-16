------ selecting the data we sre gonna be using -----
select location, date, total_cases, new_cases, total_deaths, population
from covidproject..CovidDeaths$
order by 1,2

----total cases vs total deaths --------
---likelyhood if dying if you have civid in your country -----
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covidproject..CovidDeaths$
where location like 'africa'
order by 1,2

------------looking at total cases vs population ---------
-------shows what percentage of population got covid-----------
select location, date, total_cases,  population, (total_cases/population)*100
from covidproject..CovidDeaths$
where location like 'africa'
order by 1,2

------------looking at countries with highest infection rate ---------
select location, population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100
as percentageinfected
from covidproject..CovidDeaths$
group by location, population
order by percentageinfected desc


----------looking at countries with the highest deathcount per population---------
-----------greaking things down by continent-------
select continent, max(cast (total_deaths as int))
as totaldeathcount
from covidproject..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc


----continents with highest deathcount--------------
select continent, max(cast (total_deaths as int))
as totaldeathcount
from covidproject..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc

------------------global numbers-------------------
select sum(new_cases) as totalcases, 
       sum(cast(new_deaths as int)) as totaldeaths, 
       sum(cast(new_deaths as int))/sum(new_cases)*100 
	   as deathpercentage
from CovidDeaths$
where continent is not null
order by 1,2

-----------------looking at the total amount of people vaccinated--------------

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as(
select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
  sum(cast(vaccin.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) 
  as rollingpeoplevaccinated
  --(rollingpeoplevaccinated/population)*100
from covidproject..CovidDeaths$ as death
join covidproject..CovidVaccinations$ as vaccin
  on death.location = vaccin.location
  and death.date = vaccin.date
where death.continent is not null
--order by 2,3
)
select *
from popvsvac


---------------------TEMP TABLE-----------------------

CREATE TABLE #percentpopulationvaccinated
(
  continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
  sum(cast(vaccin.new_vaccinations as int)) over (partition by death.location order by death.location, death.date) 
  as rollingpeoplevaccinated
  --(rollingpeoplevaccinated/population)*100
from covidproject..CovidDeaths$ as death
join covidproject..CovidVaccinations$ as vaccin
  on death.location = vaccin.location
  and death.date = vaccin.date
where death.continent is not null
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated