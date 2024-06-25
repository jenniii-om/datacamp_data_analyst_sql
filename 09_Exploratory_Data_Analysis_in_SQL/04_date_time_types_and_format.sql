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

