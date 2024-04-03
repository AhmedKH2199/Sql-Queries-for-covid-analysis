--Retrieve the total number of confirmed cases, deaths, and recoveries for each country:
SELECT Country/Region,
       SUM(Confirmed) AS TotalConfirmed,
       SUM(Deaths) AS TotalDeaths,
       SUM(Recovered) AS TotalRecovered
FROM covid_data
GROUP BY Country/Region;


--Find the countries with the highest number of confirmed cases:
SELECT Country/Region, MAX(Confirmed) AS MaxConfirmed
FROM covid_data
GROUP BY Country/Region
ORDER BY MaxConfirmed DESC;

--Calculate the average number of confirmed cases per day for each country:
SELECT Country/Region,
       AVG(Confirmed) AS AvgConfirmedPerDay
FROM covid_data
GROUP BY Country/Region;

--Identify the provinces/states with the highest number of deaths:
SELECT Province,
       Country/Region,
       MAX(Deaths) AS MaxDeaths
FROM covid_data
GROUP BY Province, Country/Region
ORDER BY MaxDeaths DESC;


--	Get the total number of confirmed cases, deaths, and recoveries for a specific country and date:
SELECT Country/Region,
       Date,
       SUM(Confirmed) AS TotalConfirmed,
       SUM(Deaths) AS TotalDeaths,
       SUM(Recovered) AS TotalRecovered
FROM covid_data
WHERE Country/Region = 'Austria'
      AND Date = '1/22/2020'
GROUP BY Country/Region, Date;

--Calculate the mortality rate (percentage of deaths among confirmed cases) for each country:

SELECT Country/Region,
       SUM(Deaths) AS TotalDeaths,
       SUM(Confirmed) AS TotalConfirmed,
       (SUM(Deaths) / SUM(Confirmed)) * 100 AS MortalityRate
FROM covid_data
GROUP BY Country/Region
ORDER BY MortalityRate DESC;

--Find the provinces/states in countries with the highest number of confirmed cases and their respective mortality rates:

WITH MaxConfirmedPerCountry AS (
    SELECT Country/Region,
           MAX(Confirmed) AS MaxConfirmed
    FROM covid_data
    GROUP BY Country/Region
)
SELECT cd.Province,
       cd.Country/Region,
       cd.Confirmed,
       cd.Deaths,
       (cd.Deaths / cd.Confirmed) * 100 AS MortalityRate
FROM covid_data cd
JOIN MaxConfirmedPerCountry mcpc ON cd.Country/Region = mcpc.Country/Region AND cd.Confirmed = mcpc.MaxConfirmed
ORDER BY cd.Confirmed DESC;

--The first query calculates the mortality rate (percentage of deaths among confirmed cases)
--for each country by summing the total deaths and confirmed cases and 
--then dividing deaths by confirmed cases. It orders the results by mortality rate
--in descending order.

--The second query uses a common table expression (CTE) to 
--find the maximum number of confirmed cases for each country.
--Then, it joins the COVID dataset with this CTE to retrieve
--the provinces/states in countries with the highest number of confirmed cases. 
--It also calculates the mortality rate for each province/state. 
--The results are ordered by the number of confirmed cases in descending order.


--Calculate the average number of confirmed cases, deaths, and recoveries per day for each country:
SELECT Country/Region,
       AVG(Confirmed) AS AvgConfirmedPerDay,
       AVG(Deaths) AS AvgDeathsPerDay,
       AVG(Recovered) AS AvgRecoveredPerDay
FROM covid_data
GROUP BY Country/Region;


--Find the countries with the highest mortality
--rate (percentage of deaths among confirmed cases), 
--considering only countries with at least 1000 confirmed cases:

WITH CountriesWithCases AS (
    SELECT Country/Region
    FROM covid_data
    GROUP BY Country/Region
    HAVING SUM(Confirmed) >= 1000
),
MortalityRates AS (
    SELECT cd.Country/Region,
           SUM(cd.Deaths) AS TotalDeaths,
           SUM(cd.Confirmed) AS TotalConfirmed,
           (SUM(cd.Deaths) / SUM(cd.Confirmed)) * 100 AS MortalityRate
    FROM covid_data cd
    JOIN CountriesWithCases cwc ON cd.Country/Region = cwc.Country/Region
    GROUP BY cd.Country/Region
)
SELECT *
FROM MortalityRates
ORDER BY MortalityRate DESC;
