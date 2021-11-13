Select * from Portfolio..CovidDeaths
where continent is not null

--Total cases vs Total deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
From Portfolio..CovidDeaths
Where location = 'Nigeria'
Order by 1,2

--Total cases vs population
--Shows insight into the percentage of cases based on the population
Select location, date, population, total_cases, (total_cases/population)*100 as percent_of_population
From Portfolio..CovidDeaths
Where location = 'Nigeria'
Order by 1,2

--Countries in Africa with highest death counts
Select location, MAX(total_deaths) as totaldeathcount
from Portfolio..CovidDeaths
where continent = 'Africa'
Group by location
order by totaldeathcount desc

--Daily Global Numbers
Select date, SUM(new_cases) as new_cases, SUM(new_deaths) as deaths
from Portfolio..CovidDeaths
where continent is not NULL
group by date
order by 1,2

--Total Global numbers
Select SUM(new_cases) as new_cases, SUM(new_deaths) as deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathRate
from Portfolio..CovidDeaths
where continent is not NULL
order by 1,2

--Global death counts by country
Select location, MAX(total_deaths) as totaldeathcount
from Portfolio..CovidDeaths
where continent is not null
Group by location
order by totaldeathcount desc

--Global death counts by continent
Select location, MAX(total_deaths) as totaldeathcount
from Portfolio..CovidDeaths
where continent is null
Group by [location]
order by totaldeathcount desc

--Global daily Vaccinations 
Select deaths.continent, deaths.[location], deaths.date, deaths.population, vaccs.new_vaccinations,
SUM(vaccs.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as total_people_vaccinated
From Portfolio..CovidDeaths deaths
Join Portfolio..CovidVaccinations vaccs
 on deaths.[location]=vaccs.[location]
 and deaths.[date]=vaccs.[date]
where deaths.continent is not NULL
Order by 2,3

--Creaing a CTE
With Vaccs_to_pop(continent, location, date, population, vaccinations,total_people_vaccinated)
as
(Select deaths.continent, deaths.[location], deaths.date, deaths.population, vaccs.new_vaccinations,
SUM(vaccs.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as total_people_vaccinated
From Portfolio..CovidDeaths deaths
Join Portfolio..CovidVaccinations vaccs
 on deaths.[location]=vaccs.[location]
 and deaths.[date]=vaccs.[date]
where deaths.continent is not NULL
--Order by 2,3
)
Select * , (total_people_vaccinated/population)*100 as vacc_rate
From Vaccs_to_pop

--Creating a view for later Visualisation 
Create VIEW Vaccs_to_pop as
Select deaths.continent, deaths.[location], deaths.date, deaths.population, vaccs.new_vaccinations,
SUM(vaccs.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as total_people_vaccinated
From Portfolio..CovidDeaths deaths
Join Portfolio..CovidVaccinations vaccs
 on deaths.[location]=vaccs.[location]
 and deaths.[date]=vaccs.[date]
where deaths.continent is not NULL

Select * 
From Vaccs_to_pop