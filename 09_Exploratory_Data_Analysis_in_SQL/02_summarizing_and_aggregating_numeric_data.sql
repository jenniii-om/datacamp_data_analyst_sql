-------------------------
-- Create a temp table --
-------------------------

/*
Find the Fortune 500 companies that have profits in the top 20% for their sector (compared to other Fortune 500 companies).

To do this, first, find the 80th percentile of profit for each sector with

percentile_disc(fraction) 
WITHIN GROUP (ORDER BY sort_expression)

and save the results in a temporary table.

Then join fortune500 to the temporary table to select companies with profits greater than the 80th percentile cut-off.
*/


-- Instructions 1/2
-- Create a temporary table called profit80 containing the sector and 80th percentile of profits for each sector.
-- Alias the percentile column as pct80.


-- To clear table if it already exists;
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector 
         ,percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500
   GROUP BY sector;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;



-- Instructions 2/2
-- Using the profit80 table you created in step 1, select companies that have profits greater than pct80.
-- Select the title, sector, profits from fortune500, as well as the ratio of the company's profits to the 80th percentile profit.
*/

-- Code from previous step
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector 
         ,percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;

-- Select columns, aliasing as needed
SELECT fortune500.title
       ,fortune500.sector
       ,fortune500.profits
       ,fortune500.profits/profit80.pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE fortune500.profits > profit80.pct80;

 
 
---------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------
-- Create a temp table to simplify a query --
---------------------------------------------

/*
The Stack Overflow data contains daily question counts through 2018-09-25 for all tags, but each tag has a different starting date in the data.

Find out how many questions had each tag on the first date for which data for the tag is available, as well as how many questions had the tag on the last day. Also, compute the difference between these two values.

To do this, first compute the minimum date for each tag.

Then use the minimum dates to select the question_count on both the first and last day. To do this, join the temp table startdates to two different copies of the stackoverflow table: one for each column - first day and last day - aliased with different names.

*/

-- Instructions 1/2
-- First, create a temporary table called startdates with each tag and the min() date for the tag in stackoverflow.

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag
       ,min(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 GROUP BY tag;
 
 -- Look at the table you created
 SELECT * 
   FROM startdates;


-- Instructions 2/2
-- Join startdates to stackoverflow twice using different table aliases.
-- For each tag, select mindate, question_count on the mindate, and question_count on 2018-09-25 (the max date).
-- Compute the change in question_count over time.

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;

-- select * from startdates;

-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag 
       ,startdates.mindate
       -- Select question count on the min and max days
	   ,so_min.question_count AS min_date_question_count
       ,so_max.question_count AS max_date_question_count
       -- Compute the change in question_count (max- min)
       ,so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';



---------------------------------------------------------------------------------------------------------------------------------

------------------------------
-- Insert into a temp table --
------------------------------

/*
While you can join the results of multiple similar queries together with UNION, sometimes it's easier to break a query down into steps. You can do this by creating a temporary table and inserting rows into it.

Compute the correlations between each pair of profits, profits_change, and revenues_change from the Fortune 500 data.

Recall the round() function to make the results more readable:

round(column_name::numeric, decimal_places)
Note that Steps 1 and 2 do not produce output. It is normal for the query result pane to say "Your query did not generate any results."

*/


-- Instructions 1/3
-- Create a temp table correlations.
-- Compute the correlation between profits and each of the three variables (i.e. correlate profits with profits, profits with profits_change, etc).
-- Alias columns by the name of the variable for which the correlation with profits is being computed.

DROP TABLE IF EXISTS correlations;

-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure
       -- Compute correlations
       ,corr(profits, profits) AS profits
       ,corr(profits, profits_change) AS profits_change
       ,corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

-- SELECT * from correlations;


-- Instructions 2/3
-- Insert rows into the correlations table for profits_change and revenues_change.

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure
       ,corr(profits, profits) AS profits
       ,corr(profits, profits_change) AS profits_change
       ,corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure
       ,corr(profits_change, profits) AS profits
       ,corr(profits_change, profits_change) AS profits_change
       ,corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure
       ,corr(revenues_change, profits) AS profits
       ,corr(revenues_change, profits_change) AS profits_change
       ,corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;


-- SELECT * FROM correlations;


-- Instructions 3/3
-- Select all rows and columns from the correlations table to view the correlation matrix.
-- First, you will need to round each correlation to 2 decimal places.
-- The output of corr() is of type double precision, so you will need to also cast columns to numeric.

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure
       ,corr(profits, profits) AS profits
       ,corr(profits, profits_change) AS profits_change
       ,corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure
       ,corr(profits_change, profits) AS profits
       ,corr(profits_change, profits_change) AS profits_change
       ,corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure
       ,corr(revenues_change, profits) AS profits
       ,corr(revenues_change, profits_change) AS profits_change
       ,corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Select each column, rounding the correlations
SELECT measure, 
       round(profits::numeric,2) AS profits
       ,round(profits_change::numeric,2) AS profits_change
       ,round(revenues_change::numeric,2) AS revenues_change
  FROM correlations;

  

---------------------------------------------------------------------------------------------------------------------------------


  -- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT zip, count(*)
  FROM evanston311
 GROUP BY zip
HAVING count(*) > 100; 

-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, count(*)
  FROM evanston311
  GROUP BY source
HAVING count(*) > 100;

-- Find the 5 most common values of street and the count of each
SELECT street, count(*)
  FROM evanston311
 GROUP BY street
 ORDER BY count(*) DESC
 LIMIT 5;


---------------------------------------------------------------------------------------------------------------------------------

 SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;


---------------------------------------------------------------------------------------------------------------------------------

 -- Count rows
SELECT count(*)
  FROM evanston311
 -- Where description includes trash or garbage
 WHERE description ILIKE '%trash%'
    OR description ILIKE '%garbage%';


-- Select categories containing Trash or Garbage
SELECT category
  FROM evanston311
 -- Use LIKE
 WHERE category LIKE '%Trash%'
    OR category LIKE '%Garbage%';


-- Count rows
SELECT count(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';


-- Count rows with each category
SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 --- order by most frequent values
 ORDER BY count(*) DESC
 LIMIT 10;


 ---------------------------------------------------------------------------------------------------------------------------------


 -- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT ltrim(concat(house_num, ' ', street)) AS address
  FROM evanston311;


----------------------------------
-- Split strings on a delimiter --
----------------------------------
/* 
The street suffix is the part of the street name that gives the type of street, such as Avenue, Road, or Street. In the Evanston 311 data, sometimes the street suffix is the full word, while other times it is the abbreviation.

Extract just the first word of each street value to find the most common streets regardless of the suffix.

To do this, use
split_part(string_to_split, delimiter, part_number)
*/

-- Instructions
-- Use split_part() to select the first word in street; alias the result as street_name.
-- Also select the count of each value of street_name.

-- Select the first word of the street value
SELECT split_part(street, ' ', 1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;



--------------------------
-- Shorten long strings --
--------------------------
/*
The description column of evanston311 can be very long. You can get the length of a string with the length() function.

For displaying or quickly reviewing the data, you might want to only display the first few characters. You can use the left() function to get a specified number of characters at the start of each value.

To indicate that more data is available, concatenate '...' to the end of any shortened description. To do this, you can use a CASE WHEN statement to add '...' only when the string length is greater than 50.

Select the first 50 characters of description when description starts with the word "I".
*/


-- Instructions
-- Select the first 50 characters of description with '...' concatenated on the end where the length() of the description is greater than 50 characters. Otherwise just select the description as is.
-- Select only descriptions that begin with the word 'I' and not the letter 'I'.

-- For example, you would want to select "I like using SQL!", but would not want to select "In this course we use SQL!".


-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;


 ---------------------------------------------------------------------------------------------------------------------------------

-----------------------------
-- Group and recode values --
-----------------------------
/*
There are almost 150 distinct values of evanston311.category. But some of these categories are similar, with the form "Main Category - Details". We can get a better sense of what requests are common if we aggregate by the main category.

To do this, create a temporary table recode mapping distinct category values to new, standardized values. Make the standardized values the part of the category before a dash ('-'). Extract this value with the split_part() function:

split_part(string text, delimiter text, field int)
You'll also need to do some additional cleanup of a few cases that don't fit this pattern.

Then the evanston311 table can be joined to recode to group requests by the new standardized category values.
*/


-- Instructions 1/4
-- Create recode with a standardized column; use split_part() and then rtrim() to remove any remaining whitespace on the result of split_part().

-- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;

-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
    
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';


-- Instructions 2/4
-- UPDATE standardized values LIKE 'Trash%Cart' to 'Trash Cart'.
-- UPDATE standardized values of 'Snow Removal/Concerns' and 'Snow/Ice/Hazard Removal' to 'Snow Removal'.

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;

-- Update to group trash cart values
UPDATE recode 
   SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

-- Update to group snow removal values
UPDATE recode 
   SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
    
-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';



-- Instructions 3/4
-- UPDATE recode by setting standardized values of 'THIS REQUEST IS INACTIVE…Trash Cart', '(DO NOT USE) Water Bill', 'DO NOT USE Trash', and 'NO LONGER IN USE' to 'UNUSED'.

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;
  
UPDATE recode 
  SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

UPDATE recode 
  SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';

-- Update to group unused/inactive values
UPDATE recode 
   SET standardized='UNUSED' 
 WHERE standardized IN (
              'THIS REQUEST IS INACTIVE...Trash Cart'
              ,'(DO NOT USE) Water Bill'
              ,'DO NOT USE Trash'
              ,'NO LONGER IN USE');

-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 ORDER BY standardized;



-- Instructions 4/4
-- Now, join the evanston311 and recode tables to count the number of requests with each of the standardized values
-- List the most common standardized values first.

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;

UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN (
              'THIS REQUEST IS INACTIVE...Trash Cart'
              ,'(DO NOT USE) Water Bill'
              ,'DO NOT USE Trash'
              ,'NO LONGER IN USE');

-- Select the recoded categories and the count of each
SELECT recode.standardized, count(*)
-- From the original table and table with recoded values
  FROM evanston311 
       LEFT JOIN recode 
       -- What column do they have in common?
       ON evanston311.category = recode.category 
 -- What do you need to group by to count?
 GROUP BY recode.standardized
 -- Display the most common val values first
 ORDER BY count(*) DESC;


 ---------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------
-- Create a table with indicator variables --
---------------------------------------------
/*
Determine whether medium and high priority requests in the evanston311 data are more likely to contain requesters' contact information: an email address or phone number.

Emails contain an @.
Phone numbers have the pattern of three characters, dash, three characters, dash, four characters. For example: 555-555-1212.
Use LIKE to match these patterns. Remember % matches any number of characters (even 0), and _ matches a single character. Enclosing a pattern in % (i.e. before and after your pattern) allows you to locate it within other text.

For example, '%___.com%'would allow you to search for a reference to a website with the top-level domain '.com' and at least three characters preceding it.

Create and store indicator variables for email and phone in a temporary table. LIKE produces True or False as a result, but casting a boolean (True or False) as an integer converts True to 1 and False to 0. This makes the values easier to summarize later.
*/



-- Instructions 1/2
-- Create a temp table indicators from evanston311 with three columns: id, email, and phone.
-- Use LIKE comparisons to detect the email and phone patterns that are in the description, and cast the result as an integer with CAST().
-- Your phone indicator should use a combination of underscores _ and dashes - to represent a standard 10-digit phone number format.
-- Remember to start and end your patterns with % so that you can locate the pattern within other text!


-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;
  

-- Instructions 2/2
-- Join the indicators table to evanston311, selecting the proportion of reports including an email or phone grouped by priority.
-- Include adjustments to account for issues arising from integer division.

-- Select the column you'll group by
SELECT priority,
       -- Compute the proportion of rows with each indicator
       sum(email)/count(*)::numeric AS email_prop, 
       sum(phone)/count(*)::numeric AS phone_prop
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority;


 ---------------------------------------------------------------------------------------------------------------------------------

