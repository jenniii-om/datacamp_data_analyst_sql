/*
Movies and ratings with correlated queries

Report a list of movies that received the most attention on the movie platform, (i.e. report all movies with more than 5 ratings and all movies with an average rating higher than 8).
*/

-- Instructions 1/2
-- Select all movies with more than 5 ratings. Use the first letter of the table as an alias.

SELECT *
FROM movies AS m
WHERE 5 < -- Select all movies with more than 5 ratings
	(SELECT COUNT(rating)
	FROM renting AS r
	WHERE m.movie_id = r.movie_id);


-- Instructions 2/2
-- Select all movies with an average rating higher than 8.

SELECT *
FROM movies AS m
WHERE 8 < -- Select all movies with an average rating higher than 8
	(SELECT AVG(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
/*
Customers with at least one rating

Having active customers is a key performance indicator for MovieNow. Make a list of customers who gave at least one rating.
*/

-- Instructions 1/4
-- Select all records of movie rentals from customer with ID 115.

SELECT *
FROM renting
WHERE customer_id = 115;

-- Instructions 2/4
-- Select all records of movie rentals from the customer with ID 115 and exclude records with null ratings.

SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude those with null ratings
AND customer_id = 115;

-- Instructions 3/4
-- Select all records of movie rentals from the customer with ID 1, excluding null ratings.

SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude null ratings
AND customer_id = 1; -- Select all ratings from customer with ID 1

-- Instructions 4/4
-- Select all customers with at least one rating. Use the first letter of the table as an alias.

SELECT *
FROM customers AS c-- Select all customers with at least one rating
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);



---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

-------------------------
-- Queries with EXISTS --
-------------------------

/*
Actors in comedies

In order to analyze the diversity of actors in comedies, first, report a list of actors who play in comedies and then, the number of actors for each nationality playing in comedies.
*/

-- Instructions 1/4
-- Select the records from the table actsin of all actors who play in a Comedy. Use the first letter of the table as an alias.

SELECT *  -- Select the records from the table `actsin` of all actors who play in a Comedy
FROM actsin AS ai
LEFT JOIN movies AS m
ON ai.movie_id = m.movie_id
WHERE m.genre = 'Comedy';

-- Instructions 2/4
-- Make a table of the records of actors who play in a Comedy and select only the actor with ID 1.

SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id = 1; -- Select only the actor with ID 1

-- Instructions 3/4
-- Create a list of all actors who play in a Comedy. Use the first letter of the table as an alias.

SELECT *
FROM actors AS a
WHERE EXISTS
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id);

-- Instructions 4/4
-- Report the nationality and the number of actors for each nationality.

SELECT a.nationality,
	COUNT(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

-----------------------
-- UNION & INTERSECT --
-----------------------
/*
Young actors not coming from the USA

As you've just seen, the operators UNION and INTERSECT are powerful tools when you work with two or more tables. Identify actors who are not from the USA and actors who were born after 1990.
*/

-- Instructions 1/4
-- Report the name, nationality and the year of birth of all actors who are not from the USA.

SELECT name,  
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'; 

-- Instructions 2/4
-- Report the name, nationality and the year of birth of all actors who were born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990; -- Born after 1990

-- Instructions 3/4
-- Select all actors who are not from the USA and all actors who are born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

-- Instructions 4/4
-- Select all actors who are not from the USA and who are also born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

