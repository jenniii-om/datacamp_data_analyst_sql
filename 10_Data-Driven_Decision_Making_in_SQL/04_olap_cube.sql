----------
-- CUBE --
----------

/*
Groups of customers

Use the CUBE operator to extract the content of a pivot table from the database. Create a table with the total number of male and female customers from each country.
*/

-- Instructions
-- Create a table with the total number of customers, of all female and male customers, of the number of customers for each country and the number of men and women from each country.

SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   COUNT(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;


/*
Categories of movies

Give an overview on the movies available on MovieNow. List the number of movies for different genres and release years.
*/

-- Instructions
-- List the number of movies for different genres and the year of release on all aggregation levels by using the CUBE operator.

SELECT genre,
       year_of_release,
       COUNT(*)
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;


/*
Analyzing average ratings
Prepare a table for a report about the national preferences of the customers from MovieNow comparing the average rating of movies across countries and genres.
*/

-- Instructions 1/4
-- Augment the records of movie rentals with information about movies and customers, in this order. Use the first letter of the table names as alias.

SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

-- Instructions 2/4
-- Calculate the average rating for each country.

SELECT 
	c.country,
    AVG(r.rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country;

-- Instructions 3/4
-- Calculate the average rating for all aggregation levels of country and genre.

SELECT 
	country, 
	genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE (country, genre); -- For all aggregation levels of country and genre


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

------------
-- ROLLUP --
------------
/*
Number of customers

You have to give an overview of the number of customers for a presentation.
*/

-- Instructions
-- Generate a table with the total number of customers, the number of customers for each country, and the number of female and male customers for each country.
-- Order the result by country and gender.

-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender; -- Order the result by country and gender


/*
Analyzing preferences of genres across countries

You are asked to study the preferences of genres across countries. Are there particular genres which are more popular in specific countries? Evaluate the preferences of customers by averaging their ratings and counting the number of movies rented from each genre.
*/

-- Instructions 1/3
-- Augment the renting records with information about movies and customers.

-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

-- Instructions 2/3
-- Calculate the average ratings and the number of ratings for each country and each genre. Include the columns country and genre in the SELECT clause.

SELECT 
	c.country, -- Select country
	m.genre, -- Select genre
	AVG(r.rating), -- Average ratings
	COUNT(*)  -- Count number of movie rentals
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY (c.country, m.genre) -- Aggregate for each country and each genre
ORDER BY c.country, m.genre;

-- Instructions 3/3
-- Finally, calculate the average ratings and the number of ratings for each country and genre, as well as an aggregation over all genres for each country and the overall average and total number.

-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP (c.country, m.genre)
ORDER BY c.country, m.genre;


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

------------------------------------
-- OLAP operations: GROUPING SETS --
------------------------------------
/*
Exploring nationality and gender of actors

For each movie in the database, the three most important actors are identified and listed in the table actors. This table includes the nationality and gender of the actors. We are interested in how much diversity there is in the nationalities of the actors and how many actors and actresses are in the list.
*/

SELECT 
	nationality -- Select nationality of the actors
    ,gender -- Select gender of the actors
    ,COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); 


/*
Exploring rating by country and gender

Now you will investigate the average rating of customers aggregated by country and gender.
*/

SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());


/*
Customer preference for genres

You just saw that customers have no clear preference for more recent movies over older ones. Now the management considers investing money in movies of the best rated genres.
*/

-- Instructions 1/4
-- Augment the records of movie rentals with information about movies. Use the first letter of the table as alias.

SELECT *
FROM renting AS r
LEFT JOIN movies AS m -- Augment the table with information about movies
ON r.movie_id = m.movie_id;

-- Instructions 2/4
-- Select records of movies with at least 4 ratings, starting from 2018-04-01.

SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( -- Select records of movies with at least 4 ratings
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'; -- Select records of movie rentals since 2018-04-01

-- Instructions 3-4/4
-- For each genre, calculate the average rating (use the alias avg_rating), the number of ratings (use the alias n_rating), the number of movie rentals (use the alias n_rentals), and the number of distinct movies (use the alias n_movies).

SELECT m.genre, -- For each genre, calculate:
	   AVG(r.rating) AS avg_rating, -- The average rating and use the alias avg_rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings and use the alias n_rating
	   COUNT(*) AS n_rentals,     -- The number of movie rentals and use the alias n_rentals
	   COUNT(DISTINCT m.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; -- Order the table by decreasing average rating


/*
Customer preference for actors

The last aspect you have to analyze are customer preferences for certain actors.
*/

-- Instructions 1/3
-- Join the tables.

-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN actsin AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id;

-- Instructions 2/3
-- For each combination of the actors' nationality and gender, calculate the average rating, the number of ratings, the number of movie rentals, and the number of actors.

SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY a.nationality, a.gender;

-- Instructions 3/3
-- Provide results for all aggregation levels represented in a pivot table.

SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY GROUPING SETS ((a.nationality, a.gender), (a.nationality), (a.gender), ()); -- Provide results for all aggregation levels represented in a pivot table

