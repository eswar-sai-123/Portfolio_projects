--select * from projetc_1..Covid_deaths order by 3,4 

--select * from projetc_1..covid_vaccinations$ order by 3,4 

-- Select Data the Data that we are going to using

select Location, date, total_cases, new_cases, total_deaths, population
from projetc_1..Covid_deaths order by 1,2 



-- Total cases vs Total Deaths 
--Showing death percentage of infected
select Location, date, total_cases,  total_deaths, (convert(float,total_deaths)/convert(float,total_cases))*100 as ratio
from projetc_1..Covid_deaths where location like '%india%' 
order by 1,2 

-- Total cases vs populations 
-- showing percentage of people got infected 
select Location, date, total_cases, population, (convert(float,total_cases)/convert(float,population))*100  as Percenatage_of_infected 
from projetc_1..Covid_deaths where location like '%india%' 
order by 1,2 

-- Checking the highest infected countires 
select location, population, MAX(convert(float,total_cases)) as Highest_Cases , max(CONVERT(float,total_cases)/convert(float,population))*100 as Highest_infected
from projetc_1..Covid_deaths  
group by location, population 
order by Highest_Cases desc 

--Showing the highest death countries 
select location, population, MAX(convert(float,total_deaths)) as Highest_deaths, max(convert(float,total_deaths)/convert(float,population))*100 as Highest_deaths
from projetc_1..Covid_deaths 
where continent is  null
group by location, population 
order by 3 desc


--Showing continents for highest death count 

select continent, MAX(convert(float,total_deaths)) as TotalDeathCount
from projetc_1..Covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc 

--Global numbers 

select date, sum(new_cases) as Totalnewcases, sum(new_deaths) as Totalnewdeaths,sum(new_deaths)/sum(nullif(new_cases,0))as Ratio
from projetc_1..Covid_deaths
where continent is not null 
group by date 
order by 1,2 

--total cases 
select sum(new_cases) as Totalnewcases, sum(new_deaths) as Totalnewdeaths,sum(new_deaths)/sum(nullif(new_cases,0))as Ratio
from projetc_1..Covid_deaths
where continent is not null 0
--group by date 
order by 1,2  


--Using join Method 
select * 
from projetc_1..Covid_deaths dea
join projetc_1..covid_vaccinations$ vac 
     on dea.location = vac.location
	 and dea.date = vac.date 


--Using Common table expression (CTE) 
with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(float, new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated 

from projetc_1..Covid_deaths dea
join projetc_1..covid_vaccinations$ vac 
     on dea.location =vac.location
	 and dea.date = vac.date 
where dea.continent is not null 
)
select *, (rollingpeoplevaccinated/population)*100
from popvsvac



-- Creating Temp Table 


drop table if exists #Percentpopulationvaccinated 
create table #Percentpopulationvaccinated 
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #Percentpopulationvaccinated 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 

from projetc_1..Covid_deaths dea
join projetc_1..covid_vaccinations$ vac 
     on dea.location =vac.location
	 and dea.date = vac.date 
--where dea.continent is not null 


select *, (RollingPeopleVaccinated/Population)*100 
from #Percentpopulationvaccinated

--Creating view to store data for later use 


create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 

from projetc_1..Covid_deaths dea
join projetc_1..covid_vaccinations$ vac 
     on dea.location =vac.location
	 and dea.date = vac.date 
where dea.continent is not null 