-- All together now
-- It's time to use much of what you've learned in one query! This is good preparation for using SQL in the real world where you'll often be asked to write more complex queries since some of the basic queries can be answered by playing around in spreadsheet applications.

-- In this exercise, you'll write a query that returns the average budget and gross earnings for films each year after 1990 if the average budget is greater than 60 million.

-- This will be a big query, but you can handle it!

-- Instructions 4/4
-- 25 XP
-- Select the release_year for each film in the films table, filter for records released after 1990, and group by release_year.
-- Modify the query to include the average budget aliased as avg_budget and average gross aliased as avg_gross for the results we have so far.
-- Modify the query once more so that only years with an average budget of greater than 60 million are included.

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
-- Order the results from highest to lowest average gross and limit to one
ORDER BY avg_gross DESC
LIMIT 1;
