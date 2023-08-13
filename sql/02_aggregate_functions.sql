----------------------------------------
/* Aggregate functions and data types */
----------------------------------------

/*
Aggregate functions are another valuable tool for the SQL programmer. 
They are used extensively across businesses to calculate important metrics, such as the average cost of making a film.

You know five different aggregate functions:
-AVG()
-SUM()
-MIN()
-MAX()
-COUNT()

Data types they are compatible with:
-Numerical data only: SUM(), AVG()
-Non-numerical: COUNT(), MIN(), MAX()
-ROUND()

*/


-- Use the SUM() function to calculate the total duration of all films and alias with total_duration.
-- Query the sum of film durations
SELECT SUM(duration) AS total_duration
FROM films;

-- Calculate the average duration of all films and alias with average_duration.
SELECT AVG(duration) AS average_duration
FROM films;

-- Find the most recent release_year in the films table, aliasing as latest_year.
-- Find the latest release_year
SELECT MAX(release_year) AS latest_year
FROM films;

-- Find the duration of the shortest film and use the alias shortest_film.
SELECT MIN(duration) AS shortest_film
FROM films;



-- Combining aggregate functions with WHERE 

-- Use SUM() to calculate the total gross for all films made in the year 2000 or later, and use the alias total_gross.
-- Calculate the sum of gross from the year 2000 or later
SELECT SUM(gross) AS total_gross
FROM films
WHERE release_year >= 2000;


-- Calculate the average amount grossed by all films whose titles start with the letter 'A' and alias with avg_gross_A.
-- Calculate the average gross of films that start with A
SELECT AVG(gross) AS avg_gross_A
FROM films
WHERE title LIKE 'A%';

-- Calculate the lowest gross film in 1994 and use the alias lowest_gross.
SELECT MIN(gross) AS lowest_gross
FROM films
WHERE release_year = 1994;

-- Calculate the highest gross film between 2000 and 2012, inclusive, and use the alias highest_gross.
-- Calculate the highest gross film released between 2000-2012
SELECT MAX(gross) AS highest_gross
FROM films
WHERE release_year BETWEEN 2000 AND 2012;


-- Calculate the average facebook_likes to one decimal place and assign to the alias, avg_facebook_likes.
-- Round the average number of facebook_likes to one decimal place
SELECT ROUND(AVG(facebook_likes),1) AS avg_facebook_likes
FROM reviews;

-- Calculate the average budget from the films table, aliased as avg_budget_thousands, and round to the nearest thousand.
-- Calculate the average budget rounded to the thousands
SELECT ROUND(AVG(budget), -3) AS avg_budget_thousands
FROM films;



-- Aliasing with functions

-- Select the title and duration in hours for all films and alias as duration_hours; since the current durations are in minutes, you'll need to divide duration by 60.0.
-- Calculate the title and duration_hours from films
SELECT title
    ,(duration / 60.0) AS duration_hours
FROM films;

-- Round duration_hours to two decimal places
SELECT title
    , ROUND(duration / 60.0,2) AS duration_hours
FROM films;

-- Calculate the percentage of people who are no longer alive and alias the result as percentage_dead.
SELECT COUNT(deathdate) * 100.0 / COUNT(name) AS percentage_dead
FROM people
;

-- Find how many decades the films table covers by using MIN() and MAX() and alias as number_of_decades.
-- Find the number of decades in the films table
SELECT (MAX(release_year) - MIN(release_year)) / 10.0 AS number_of_decades
FROM films;