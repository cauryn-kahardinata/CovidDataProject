--Select Data that gonna be used

SELECT DISTINCT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
ORDER BY 1, 2;

-- lOOKING AT TOTAL CASES VS TOTAL DEATHS
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTACT COVID IN INDONESIA
SELECT DISTINCT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS "Death Percentage"
FROM CovidProject..CovidDeaths
WHERE LOWER(location) LIKE 'indonesia'
ORDER BY 1, 2;

-- LOOKING AT THE TOTAL CASES VS POPULATION -> PERCENTAGE OF POPULATION GOT COVID
SELECT DISTINCT location, date, total_cases, population, (total_cases/population)*100 AS "Case Percentage"
FROM CovidProject..CovidDeaths
WHERE LOWER(location) LIKE 'indonesia'
ORDER BY 1, 2;

-- HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT DISTINCT location, population, MAX(total_cases) AS "Highest Infection", 
				MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;
 
-- SHOWING HIGHEST DEATH COUNT
-- DECIDE BY COUNTRY LOCATION
SELECT DISTINCT location, MAX(CAST(total_deaths AS int)) AS maxDeath
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY maxDeath DESC;

-- DECIDE BY CONTINENT
SELECT location, MAX(CAST(total_deaths AS int)) AS maxDeath
FROM CovidProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY maxDeath DESC;

-- SHOWING CONTINENT WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(CAST(total_deaths AS int)) AS maxDeath
FROM CovidProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY maxDeath DESC;

-- GLOBAL NUMBER
SELECT DISTINCT date, SUM(new_cases) AS "Total Case", 
				SUM(CAST(new_deaths AS int)) AS "Total Deaths", 
				(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY DeathPercentage DESC;
