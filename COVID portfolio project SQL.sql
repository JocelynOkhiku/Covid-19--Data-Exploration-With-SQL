--select location,date,total_cases,new_cases,total_deaths,[ population]
--from PortfolioProject..CovidDeaths
--order by 1,2

--Looking at Total Cases vs Total Deaths
--shows the likelihood of dying if you contract covid in your country 
--Looking at Total Cases vs Population
--shows what percentage of population got covid

--select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like '%kingdom%'
--order by 1,2


--select location,date,total_cases,[ population], (total_cases/[ population])*100 as PopulationPercentage
--from PortfolioProject..CovidDeaths
--where location like '%kingdom%'
--order by 1,2

--looking at countries with higher infection rate compared to population
--select location, max(total_cases) as highestinfectioncount,[ population], max((total_cases/[ population]))*100 as PopulationPercentageinfected
--from PortfolioProject..CovidDeaths
----where location like '%kingdom%'
--group by location,[ population]
--order by PopulationPercentageinfected desc

--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
----where location like '%states%'
--where continent is not null
--group by continent
--order by TotalDeathCount desc



--select *
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4


----looking at countries with highest death count per population
--select location, max(cast(total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
----where location like '%kingdom%'
--where continent is null
--group by location
--order by TotalDeathCount desc


--GLOBAL NUMBERS
--select date, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths ,sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
--from PortfolioProject..CovidDeaths
----where location like '%states%'
--where continent is not null
--group by date
--order by 1,2


--looking at total population vs vaccinations

--USE CTE
With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.[ population],vac.new_vaccinations
,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100 
from PopvsVac



--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated --(when you plan on making alterations)
Create Table #PercentPopulationVaccinated
(
continent nvarchar (255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.[ population],vac.new_vaccinations
,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100 
from #PercentPopulationVaccinated


--Creating View to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.[ population],vac.new_vaccinations
,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
