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

