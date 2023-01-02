-- Looking for Total Cases vs Total Deaths
-- Shows the likelihood of contracting and daying of covid
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases * 100) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%pakistan%'
ORDER BY 1,2;

-- looking at total cases vs total population
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%pakistan%'
ORDER BY 1, 2;

-- highest infection rate countries 

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPoputlationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPoputlationInfected DESC;

-- highest death counts per population

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeathCount DESC

-- Let's do this by continent
SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC;

-- showing continent wrt highest death counts
-- Let's do this by continent
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY TotalDeathCount DESC;

-- calculate global numbers

SELECT date, SUM(new_cases) AS SumCases, SUM(CAST( new_deaths AS int)) AS SumDeath, (SUM(CAST( new_deaths AS int)) / SUM(new_cases))* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- calculate global numbers across globe

SELECT SUM(new_cases) AS SumCases, SUM(CAST( new_deaths AS int)) AS SumDeath, (SUM(CAST( new_deaths AS int)) / SUM(new_cases))* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


-- Joining table 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location  ORDER BY dea.location, dea.date) AS ROLLING
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidDeaths AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

-- Joining table 
WITH POPvsVAC( Continent, Location, Date, Population, New_Vaccination, ROLLING)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location  ORDER BY dea.location, dea.date) AS ROLLING
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidDeaths AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (ROLLING/Population)*100
FROM POPvsVAC

CREATE VIEW FirstView as 
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent;