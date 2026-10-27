SELECT *
FROM CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccination v
	ON (d.location = v.location)
	AND (d.date = v.date)

-- TOTAL POPULATION VS VACCINATIONS
SELECT DISTINCT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int, v.new_vaccinations)) 
				OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccination v
	ON (d.location = v.location)
	AND (d.date = v.date)
WHERE d.continent IS NOT NULL
ORDER BY 2, 3;

-- USE CTE

WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT DISTINCT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int, v.new_vaccinations)) 
				OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccination v
	ON (d.location = v.location)
	AND (d.date = v.date)
WHERE d.continent IS NOT NULL
)
SELECT *, CAST((RollingPeopleVaccinated * 1.0 / population) * 100 AS DECIMAL(15, 5)) AS "Vaccination Percentage"
FROM PopvsVac
ORDER BY location, date;

-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated

SELECT DISTINCT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int, v.new_vaccinations)) 
				OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccination v
	ON (d.location = v.location)
	AND (d.date = v.date)
WHERE d.continent IS NOT NULL

SELECT *, CAST((RollingPeopleVaccinated * 1.0 / population) * 100 AS DECIMAL(15, 5)) AS "Vaccination Percentage"
FROM #PercentPopulationVaccinated
ORDER BY location, date;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE View PercentagePopulationVaccinated AS
SELECT DISTINCT d.continent, d.location, d.date, d.population, v.new_vaccinations,
				SUM(CONVERT(int, v.new_vaccinations)) 
				OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccination v
	ON (d.location = v.location)
	AND (d.date = v.date)
WHERE d.continent IS NOT NULL
--ORDER BY location, date;

SELECT *
FROM PercentagePopulationVaccinated