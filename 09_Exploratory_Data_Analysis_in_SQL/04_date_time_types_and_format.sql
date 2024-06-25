-----------------------
-- Date comparisons --
-----------------------
/*
When working with timestamps, sometimes you want to find all observations on a given day. However, if you specify only a date in a comparison, you may get unexpected results. This query:

SELECT count(*) 
  FROM evanston311
 WHERE date_created = '2018-01-02';
returns 0, even though there were 49 requests on January 2, 2018.

This is because dates are automatically converted to timestamps when compared to a timestamp. The time fields are all set to zero:

SELECT '2018-01-02'::timestamp;
 2018-01-02 00:00:00
When working with both timestamps and dates, you'll need to keep this in mind.
*/


-- Instructions 1/3
-- Count the number of Evanston 311 requests created on January 31, 2017 by casting date_created to a date.

-- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date_created::date = '2017-01-31';

-- Instructions 2/3
-- Count the number of Evanston 311 requests created on February 29, 2016 by using >= and < operators.

-- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29'
   AND date_created < '2016-03-01';

-- Instructions 3/3
-- Count the number of requests created on March 13, 2017.
-- Specify the upper bound by adding 1 to the lower bound.

-- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;

---------------------------------------------------------------------------------------------------------------------------------

---------------------
-- Date arithmetic -- 
---------------------
/*
You can subtract dates or timestamps from each other.

You can add time to dates or timestamps using intervals. An interval is specified with a number of units and the name of a datetime field. For example:

'3 days'::interval
'6 months'::interval
'1 month 2 years'::interval
'1 hour 30 minutes'::interval
Practice date arithmetic with the Evanston 311 data and now().
*/

-- Instructions 1/4
-- Subtract the minimum date_created from the maximum date_created.

-- Subtract the min date_created from the max
SELECT max(date_created) - min(date_created)
  FROM evanston311;

-- Instructions 2/4
-- Using now(), find out how old the most recent evanston311 request was created.

-- How old is the most recent request?
SELECT now() - max(date_created)
  FROM evanston311;

-- Instructions 3/4
-- Add 100 days to the current timestamp.
-- Add 100 days to the current timestamp
SELECT now() + '100 days'::interval;


-- Instructions 4/4
-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT now()
    ,now() + '5 minutes'::interval;


---------------------------------------------------------------------------------------------------------------------------------

---------------------------------
-- Completion time by category --
---------------------------------
/*
The evanston311 data includes a date_created timestamp from when each request was created and a date_completed timestamp for when it was completed. The difference between these tells us how long a request was open.

Which category of Evanston 311 requests takes the longest to complete?
*/

-- Instructions
-- Compute the average difference between the completion timestamp and the creation timestamp by category.
-- Order the results with the largest average time to complete the request first.

-- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed - date_created) AS completion_time
  FROM evanston311
 GROUP BY category
-- Order the results
 ORDER BY completion_time DESC;


 ---------------------------------------------------------------------------------------------------------------------------------

----------------
-- Date parts --
----------------
/*
The date_part() function is useful when you want to aggregate data by a unit of time across multiple larger units of time. For example, aggregating data by month across different years, or aggregating by hour across different days.

Recall that you use date_part() as:

SELECT date_part('field', timestamp);
In this exercise, you'll use date_part() to gain insights about when Evanston 311 requests are submitted and completed.
*/

-- Instructions 1/3
-- How many requests are created in each of the 12 months during 2016-2017?

-- Extract the month from date_created and count requests
SELECT date_part('month', date_created) AS month, 
       count(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created < '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY month;


-- Instructions 2/3
-- What is the most common hour of the day for requests to be created?

-- Get the hour and count requests
SELECT date_part('hour', date_created) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 -- Order results to select most common
 ORDER BY count(*) DESC
 LIMIT 1;


-- Instructions 3/3
-- During what hours are requests usually completed? Count requests completed by hour.
-- Order the results by hour.

-- Count requests completed by hour
SELECT date_part('hour', date_completed) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 ORDER BY hour;

---------------------------------------------------------------------------------------------------------------------------------

------------------------------
-- Variation by day of week --
------------------------------
/*
Does the time required to complete a request vary by the day of the week on which the request was created?

We can get the name of the day of the week by converting a timestamp to character data:

to_char(date_created, 'day') 
But character names for the days of the week sort in alphabetical, not chronological, order. To get the chronological order of days of the week with an integer value for each day, we can use:

EXTRACT(DOW FROM date_created)
DOW stands for "day of week."
*/

-- Instructions
-- Select the name of the day of the week the request was created (date_created) as day.
-- Select the mean time between the request completion (date_completed) and request creation as duration.
-- Group by day (the name of the day of the week) and the integer value for the day of the week (use a function).
-- Order by the integer value of the day of the week using the same function used in GROUP BY.

-- Select name of the day of the week the request was created 
SELECT to_char(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(DOW FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(DOW FROM date_created);


---------------------------------------------------------------------------------------------------------------------------------

---------------------
-- Date truncation --
---------------------
/*
Unlike date_part() or EXTRACT(), date_trunc() keeps date/time units larger than the field you specify as part of the date. So instead of just extracting one component of a timestamp, date_trunc() returns the specified unit and all larger ones as well.

Recall the syntax:

date_trunc('field', timestamp)
Using date_trunc(), find the average number of Evanston 311 requests created per day for each month of the data. Ignore days with no requests when taking the average.
*/

-- Instructions
-- Write a subquery to count the number of requests created per day.
-- Select the month and average count per month from the daily_count subquery.

-- Aggregate daily counts by month
SELECT date_trunc('month', day) AS month,
       AVG(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day', date_created) AS day,
               count(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;


---------------------------------------------------------------------------------------------------------------------------------

------------------------
-- Find missing dates --
------------------------
/*
The generate_series() function can be useful for identifying missing dates.

Recall:

generate_series(from, to, interval)
where from and to are dates or timestamps, and interval can be specified as a string with a number and a unit of time, such as '1 month'.

Are there any days in the Evanston 311 data where no requests were created?
*/

-- Instructions
-- Write a subquery using generate_series() to get all dates between the min() and max() date_created in evanston311.
-- Write another subquery to select all values of date_created as dates from evanston311.
-- Both subqueries should produce values of type date (look for the ::).
-- Select dates (day) from the first subquery that are NOT IN the results of the second subquery. This gives you days that are not in date_created.

SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(min(date_created),
                               max(date_created),
                               '1 day')::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN 
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);


---------------------------------------------------------------------------------------------------------------------------------

--------------------------------
-- Custom aggregation periods -- 
--------------------------------
/*
Find the median number of Evanston 311 requests per day in each six month period from 2016-01-01 to 2018-06-30. Build the query following the three steps below.

Recall that to aggregate data by non-standard date/time intervals, such as six months, you can use generate_series() to create bins with lower and upper bounds of time, and then summarize observations that fall in each bin.

Remember: you can access the slides with an example of this type of query using the PDF icon link in the upper right corner of the screen.
*/

-- Instructions 1/3
-- Use generate_series() to create bins of 6 month intervals. Recall that the upper bin values are exclusive, so the values need to be one day greater than the last day to be included in the bin.
-- Notice how in the sample code, the first bin value of the upper bound is July 1st, and not June 30th.
-- Use the same approach when creating the last bin values of the lower and upper bounds (i.e. for 2018).

-- Generate 6 month bins covering 2016-01-01 to 2018-06-30

-- Create lower bounds of bins
SELECT generate_series('2016-01-01',  -- First bin lower value
                       '2018-01-01',  -- Last bin lower value
                       '6 months'::interval) AS lower,
-- Create upper bounds of bins
       generate_series('2016-07-01',  -- First bin upper value
                       '2018-07-01',  -- Last bin upper value
                       '6 months'::interval) AS upper;


-- Instructions 2/3
-- Count the number of requests created per day. Remember to not count *, or you will risk counting NULL values.
-- Include days with no requests by joining evanston311 to a daily series from 2016-01-01 to 2018-06-30.
-- Note that because we are not generating bins, you can use June 30th as your series end date.

-- Count number of requests made per day
SELECT day, count(date_created) AS count
-- Use a daily series from 2016-01-01 to 2018-06-30 
-- to include days with no requests
  FROM (SELECT generate_series('2016-01-01',  -- series start date
                               '2018-06-30',  -- series end date
                               '1 day'::interval)::date AS day) AS daily_series
       LEFT JOIN evanston311
       -- match day from above (which is a date) to date_created
       ON day = date_created::date
 GROUP BY day;


-- Instructions 3/3
-- Assign each daily count to a single 6 month bin by joining bins to daily_counts.
-- Compute the median value per bin using percentile_disc().

-- Bins from Step 1
WITH bins AS (
	 SELECT generate_series('2016-01-01',
                            '2018-01-01',
                            '6 months'::interval) AS lower,
            generate_series('2016-07-01',
                            '2018-07-01',
                            '6 months'::interval) AS upper),
-- Daily counts from Step 2
     daily_counts AS (
     SELECT day, count(date_created) AS count
       FROM (SELECT generate_series('2016-01-01',
                                    '2018-06-30',
                                    '1 day'::interval)::date AS day) AS daily_series
            LEFT JOIN evanston311
            ON day = date_created::date
      GROUP BY day)
-- Select bin bounds 
SELECT lower, 
       upper, 
       -- Compute median of count for each bin
       percentile_disc(0.5) WITHIN GROUP (ORDER BY count) AS median
  -- Join bins and daily_counts
  FROM bins
       LEFT JOIN daily_counts
       -- Where the day is between the bin bounds
       ON day >= lower
          AND day < upper
 -- Group by bin bounds
 GROUP BY lower, upper
 ORDER BY lower;


---------------------------------------------------------------------------------------------------------------------------------

----------------------------------------
-- Monthly average with missing dates --
----------------------------------------
/*
Find the average number of Evanston 311 requests created per day for each month of the data.

This time, do not ignore dates with no requests.
*/

-- Instructions
-- Generate a series of dates from 2016-01-01 to 2018-06-30.
-- Join the series to a subquery to count the number of requests created per day.
-- Use date_trunc() to get months from date, which has all dates, NOT day.
-- Use coalesce() to replace NULL count values with 0. Compute the average of this value.

-- generate series with all days from 2016-01-01 to 2018-06-30
WITH all_days AS 
     (SELECT generate_series('2016-01-01',
                             '2018-06-30',
                             '1 day'::interval) AS date),
     -- Subquery to compute daily counts
     daily_count AS 
     (SELECT date_trunc('day', date_created) AS day,
             count(*) AS count
        FROM evanston311
       GROUP BY day)
-- Aggregate daily counts by month using date_trunc
SELECT date_trunc('month', date) AS month,
       -- Use coalesce to replace NULL count values with 0
       avg(coalesce(count, NULL, 0)) AS average
  FROM all_days
       LEFT JOIN daily_count
       -- Joining condition
       ON all_days.date=daily_count.day
 GROUP BY month
 ORDER BY month; 


---------------------------------------------------------------------------------------------------------------------------------

-----------------
-- Longest gap --
-----------------
/*
What is the longest time between Evanston 311 requests being submitted?

Recall the syntax for lead() and lag():

lag(column_to_adjust) OVER (ORDER BY ordering_column)
lead(column_to_adjust) OVER (ORDER BY ordering_column)
*/

-- Instructions
-- Select date_created and the date_created of the previous request using lead() or lag() as appropriate.
-- Compute the gap between each request and the previous request.
-- Select the row with the maximum gap.

-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               lag(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - lag(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT max(gap)
                FROM request_gaps);


---------------------------------------------------------------------------------------------------------------------------------

-----------
-- Rats! --
-----------
/*
Requests in category "Rodents- Rats" average over 64 days to resolve. Why?

Investigate in 4 steps:

Why is the average so high? Check the distribution of completion times. Hint: date_trunc() can be used on intervals.

See how excluding outliers influences average completion times.

Do requests made in busy months take longer to complete? Check the correlation between the average completion time and requests per month.

Compare the number of requests created per month to the number completed.

Remember: the time to resolve, or completion time, is date_completed - date_created.
*/

-- Instructions 1/4
-- Use date_trunc() to examine the distribution of rat request completion times by number of days.

-- Truncate the time to complete requests to the day
SELECT date_trunc('day', date_completed - date_created) AS completion_time,
-- Count requests with each truncated time
       count(*)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY completion_time
 ORDER BY completion_time;


-- Instructions 2/4
-- Compute average completion time per category excluding the longest 5% of requests (outliers).

SELECT category, 
       -- Compute average completion time per category
       AVG(date_completed - date_created) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE (date_completed - date_created) < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed-date_created)
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;

-- Instructions 3/4
-- Get corr() between avg. completion time and monthly requests. EXTRACT(epoch FROM interval) returns seconds in interval.

-- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT corr(avg_completion, count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT date_trunc('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               AVG(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               count(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;

-- Instructions 4/4
-- Select the number of requests created and number of requests completed per month.

-- Compute monthly counts of requests created
WITH created AS (
       SELECT date_trunc('month', date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT date_trunc('month',date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created.created_count, 
       completed.completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;