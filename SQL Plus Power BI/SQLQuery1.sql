-- Selecting a single table
SELECT *
FROM Projects.dbo.['2018$'];


-- Selecting all three of the table from Projects
SELECT *
FROM Projects.dbo.['2019$'];
SELECT *
FROM Projects.dbo.['2020$'];

-- Using UNION to create a single table from all the previous three tables aka append
SELECT *
FROM Projects.dbo.['2018$']
UNION
SELECT *
FROM Projects.dbo.['2019$']
UNION
SELECT *
FROM Projects.dbo.['2020$'];


-- Creating a Temporary table 
WITH hotels_2018_2020 AS (
SELECT *
FROM Projects.dbo.['2018$']
UNION
SELECT *
FROM Projects.dbo.['2019$']
UNION
SELECT *
FROM Projects.dbo.['2020$']
)

SELECT 
arrival_date_year,
hotel,
ROUND (SUM((stays_in_week_nights + stays_in_weekend_nights) * adr), 3) AS REVENUE
FROM hotels_2018_2020
GROUP BY arrival_date_year, hotel;


-- creating JOINS
WITH hotels as (

SELECT *
FROM Projects.dbo.['2018$']
UNION
SELECT *
FROM Projects.dbo.['2019$']
UNION 
SELECT * 
FROM Projects.dbo.['2020$']
)
SELECT *
FROM hotels
LEFT JOIN Projects.dbo.market_segment$
ON hotels.market_segment = Projects.dbo.market_segment$.market_segment
LEFT JOIN Projects.dbo.meal_cost$
ON hotels.meal = Projects.dbo.meal_cost$.meal;



