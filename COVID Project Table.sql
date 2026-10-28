
-- 1. GLOBAL NUMBER
SELECT DISTINCT SUM(new_cases) AS "Total Case", 
				SUM(CAST(new_deaths AS int)) AS "Total Deaths", 
				(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

--SELECT DISTINCT SUM(new_cases) AS "Total Case", 
--				SUM(CAST(new_deaths AS int)) AS "Total Deaths", 
--				(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
--FROM CovidProject..CovidDeaths
--WHERE location = 'World'
--ORDER BY 1, 2;

-- 2. CONTINENT NUMBER
SELECT location, SUM(CAST(new_deaths AS int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- 3. HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT DISTINCT location, population, MAX(total_cases) AS "Highest Infection", 
				MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;

-- 4. 
SELECT DISTINCT location, population, date, MAX(total_cases) AS "Highest Infection", 
				MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentagePopulationInfected DESC;