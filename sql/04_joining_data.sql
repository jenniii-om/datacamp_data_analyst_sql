-- Perform an inner join with the cities table on the left and the countries table on the right; do not alias tables here or in the next step.
-- Identify the relevant column names to join ON by inspecting the cities and countries tabs in the console.

SELECT * 
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on country codes
ON cities.country_code = countries.code
;

-- Complete the SELECT statement to keep only the name of the city, the name of the country, and the region the country is located in (in the order specified).
-- Alias the name of the city AS city and the name of the country AS country.
-- Select name fields (with alias) and region 
SELECT 
    cities.name AS city
    ,countries.name AS country
    ,countries.region 
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code
;


-- Start with your inner join in line 5; join the tables countries AS c (left) with economies (right), aliasing economies AS e.
-- Next, use code as your joining field in line 7; do not use the USING command here.
-- Lastly, select the following columns in order in line 2: code from the countries table (aliased as country_code), name, year, and inflation_rate.

-- Select fields with aliases
SELECT c.code AS country_code
    ,c.name
    ,e.year
    ,e.inflation_rate
FROM countries AS c
-- Join to economies (alias e)
INNER JOIN economies AS e 
-- Match on code field using table aliases
ON c.code = e.code 
;


-- Use the country code field to complete the INNER JOIN with USING; do not change any alias names.
SELECT c.name AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
-- Match using the code column
USING(code)
;


-- Inspecting a relationship
-- You've just identified that the countries table has a many-to-many relationship with the languages table. 
-- That is, many languages can be spoken in a country, and a language can be spoken in many countries.

-- This exercise looks at each of these in turn. First, what is the best way to query all the different languages spoken in a country? 
-- And second, how is this different from the best way to query all the countries that speak each language?

-- Start with the join statement in line 6; perform an inner join with the countries table as c on the left with the languages table as l on the right.
-- Make use of the USING keyword to join on code in line 8.
-- Lastly, in line 2, select the country name, aliased as country, and the language name, aliased as language.

-- Select country and language names, aliased
SELECT
    c.name AS country
    ,l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code);


-- Rearrange the SELECT statement so that the language column appears on the left and the country column on the right.
-- Sort the results by language.
-- Rearrange SELECT statement, keeping aliases
SELECT 
    c.name AS country
    ,l.name AS language
FROM languages AS l
INNER JOIN countries AS c
USING(code)
-- Order the results by language
ORDER BY language
;





--- Joining multiple tables


-- Suppose you are interested in the relationship between fertility and unemployment rates. 
-- Your task in this exercise is to join tables to return the country name, year, fertility rate, and unemployment rate in a single result from the countries, populations and economies tables.

-- Perform an inner join of countries AS c (left) with populations AS p (right), on code.
-- Select name, year and fertility_rate.
-- Select relevant fields
SELECT 
    name
    ,year
    ,fertility_rate
FROM countries AS c
-- Inner join countries and populations, aliased, on code
INNER JOIN populations AS p
ON c.code = p.country_code
;

-- Chain another inner join to your query with the economies table AS e, using code.
-- Select name, and using table aliases, select year and unemployment_rate from economies.
-- Select fields
SELECT 
    name
    ,e.year AS year 
    ,fertility_rate
    ,e.unemployment_rate AS unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e 
-- Match on country code
USING(code) ;




-----------------------
-- LEFT and RIGHT JOINs
-----------------------

-- You'll begin with an INNER JOIN with the cities table (left) and countries table (right). 
-- This helps if you are interested only in records where a country is present in both tables.

-- You'll then change to a LEFT JOIN. This helps if you're interested in returning all countries in the cities table, whether or not they have a match in the countries table.

-- Perform an inner join with cities AS c1 on the left and countries as c2 on the right.
-- Use code as the field to merge your tables on.
SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
-- Perform an inner join with cities as c1 and countries as c2 on country code
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;


-- Change the code to perform a LEFT JOIN instead of an INNER JOIN. After executing this query, have a look at how many records the query result contains.
SELECT 
    c1.name AS city
 	,c2.code AS country_code
    ,c2.name AS country
    ,c2.region AS region
    ,c1.city_proper_pop AS city_population
FROM world.cities AS c1
-- Join right table (with alias)
LEFT JOIN world.countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;



-- Building on your LEFT JOIN

-- You will use AVG() in combination with a LEFT JOIN to determine the average gross domestic product (GDP) per capita by region in 2010.
SELECT 
    c.region AS region
    ,AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE e.year = 2010
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC
-- Return only first 10 records
LIMIT 10
;




--- FULL JOIN

-- Comparing joins

-- Perform a full join with countries (left) and currencies (right).
-- Filter for the North America region or NULL country names.

SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
FULL JOIN currencies 
USING (code)
-- Where region is North America or name is null
WHERE region = 'North America'
    OR name IS NULL 
ORDER BY region;



-- Chaining FULL JOINs

-- Suppose you are doing some research on Melanesia and Micronesia, and are interested in pulling information about languages and currencies into the data we see for these regions in the countries table. Since languages and currencies exist in separate tables, this will require two consecutive full joins involving the countries, languages and currencies tables.

SELECT 
	c1.name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
FULL JOIN languages as l 
USING(code)
-- Full join with currencies (alias as c2)
FULL JOIN currencies as c2
USING(code) 
WHERE region LIKE 'M%esia';




-- CROSS JOIN
-- CROSS JOIN can be incredibly helpful when asking questions that involve looking at all possible combinations or pairings between two sets of data.

-- Imagine you are a researcher interested in the languages spoken in two countries: Pakistan and India. You are interested in asking:
-- What are the languages presently spoken in the two countries?
SELECT c.name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
FROM countries AS c
INNER JOIN languages as l
USING(code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');




-- You will determine the names of the five countries and their respective regions with the lowest life expectancy for the year 2010. 
-- Use your knowledge about joins, filtering, sorting and limiting to create this list!

SELECT 
	c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
LEFT JOIN populations as p
ON c.code = p.country_code
-- Filter for only results in the year 2010
WHERE p.year = 2010
-- Sort by life_exp
ORDER BY life_exp 
-- Limit to five records
LIMIT 5;




--------------
-- SELF JOINS
--------------

-- Comparing a country to itself
-- Self joins are very useful for comparing data from one part of a table with another part of the same table. 

-- Suppose you are interested in finding out how much the populations for each country changed from 2010 to 2015. You can visualize this change by performing a self join.
SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
-- Filter such that p1.year is always five years before p2.year
AND p1.year = p2.year-5
;




-- SET THEORY OPERATIONS


-- UNION


-- In this exercise, you have two tables, economies2015 and economies2019, available to you under the tabs in the console. You'll perform a set operation to stack all records in these two tables on top of each other, excluding duplicates.

-- Select all fields from economies2015
SELECT *
FROM economies2015    
-- Set operation
UNION
-- Select all fields from economies2019
SELECT * 
FROM economies2019
ORDER BY code, year;



-- Perform an appropriate set operation that determines all pairs of country code and year (in that order) from economies and populations, excluding duplicates.
-- Order by country code and year.
-- Query that determines all pairs of code and year from economies and populations, without duplicates
SELECT code AS country_code, year
FROM economies
UNION
SELECT country_code, year
FROM populations
ORDER BY country_code, year
;


-- INTERSECT

-- Return all city names that are also country names.
-- Return all cities with the same name as a country
SELECT name
FROM countries
INTERSECT
SELECT name 
FROM cities
;


-- EXCEPT

-- Return all cities that do not have the same name as a country
SELECT name
FROM cities
EXCEPT
SELECT name
FROM countries
ORDER BY name;




-- SUBQUERYING / NESTED SQL

-- Semi join
-- Subquery inside WHERE
-- Let's say you are interested in identifying languages spoken in the Middle East. The languages table contains information about languages and countries, but it does not tell you what region the countries belong to. You can build up a semi join by filtering the countries table by a particular region, and then using this to further filter the languages table.

SELECT DISTINCT name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;


-- Diagnosing problems using anti join
-- Say you are interested in identifying currencies of Oceanian countries. You have written the following INNER JOIN, which returns 15 records. Now, you want to ensure that all Oceanian countries from the countries table are included in this result. You'll do this in the first step.

SELECT c1.code, name, basic_unit AS currency
FROM countries AS c1
INNER JOIN currencies AS c2
ON c1.code = c2.code
WHERE c1.continent = 'Oceania';

SELECT code, name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN
    (SELECT code
    FROM currencies);



-- Subquery inside WHERE

-- In this exercise, you will nest a subquery from the populations table inside another query from the same table, populations. Your goal is to figure out which countries had high average life expectancies in 2015.

SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
    AND year = 2015;


-- strengthen your knowledge of subquerying by identifying capital cities in order of largest to smallest population.
-- Select relevant fields from cities table
SELECT
    name
    ,country_code
    ,urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name in (
    SELECT capital
    FROM countries
)
ORDER BY urbanarea_pop DESC;



-- Subquery inside SELECT

-- In Step 1, you'll begin with a LEFT JOIN combined with a GROUP BY to select the nine countries with the most cities appearing in the cities table, along with the counts of these cities. 
-- Find top nine countries with the most cities
SELECT c1.name AS country 
    ,COUNT(c2.name) AS cities_num
FROM countries AS c1
LEFT JOIN cities AS c2
ON c1.code = c2.country_code
GROUP BY country
-- Order by count of cities as cities_num
ORDER BY cities_num DESC
    ,country
LIMIT 9
;

-- In Step 2, you'll write a query that returns the same result as the join, but leveraging a nested query instead.
SELECT countries.name AS country,
-- Subquery that provides the count of cities   
  (SELECT COUNT(*)
   FROM cities
   WHERE cities.country_code = countries.code
   ) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;



-- Subquery inside FROM
-- you are interested in determining the number of languages spoken for each country. You want to present this information alongside each country's local_name, which is a field only present in the countries table and not in the languages table. You'll use a subquery inside FROM to bring information from these two tables together!

-- Select code, and language count as lang_num
/*SELECT 
    countries.code
    ,lang_num
FROM countries,
    (SELECT code, COUNT(*) AS lang_num
        FROM languages
    GROUP BY code) AS lang
WHERE countries.code = lang.code
-- ORDER BY countries.code
;*/

-- Select code, and language count as lang_num
SELECT 
    countries.code
    ,COUNT(languages.name) AS lang_num
FROM countries, languages
WHERE countries.code = languages.code
GROUP BY countries.code
;


-- Select local_name and lang_num from appropriate tables
SELECT 
  countries.local_name
  ,sub.lang_num
FROM countries
  ,(SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;


-- Subquery challenge

--Suppose you're interested in analyzing inflation and unemployment rate for certain countries in 2015. You are not interested in countries with "Republic" or "Monarchy" as their form of government, but are interested in all other forms of government, such as emirate federations, socialist states, and commonwealths.

-- Select relevant fields
SELECT economies.code
  ,economies.inflation_rate
  ,economies.unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code
  FROM countries
  WHERE gov_form LIKE '%Republic%' OR 
    gov_form LIKE '%Monarchy%')
ORDER BY inflation_rate;


-- Your task is to determine the top 10 capital cities in Europe and the Americas by city_perc, a metric you'll calculate. city_perc is a percentage that calculates the "proper" population in a city as a percentage of the total population in the wider metro area, as follows:

-- Select fields from cities
SELECT cities.name
    ,cities.country_code
    ,cities.city_proper_pop
    ,cities.metroarea_pop
    ,(cities.city_proper_pop / cities.metroarea_pop) * 100 AS city_perc
FROM cities
-- Use subquery to filter city name
WHERE cities.name IN (
    SELECT capital
    FROM countries
    WHERE continent LIKE '%America%' OR
        continent LIKE '%Europe%'
    )
-- Add filter condition such that metroarea_pop does not have null values
AND cities.metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;