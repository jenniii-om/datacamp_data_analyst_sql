/*
Create a temp table
Find the Fortune 500 companies that have profits in the top 20% for their sector (compared to other Fortune 500 companies).

To do this, first, find the 80th percentile of profit for each sector with

percentile_disc(fraction) 
WITHIN GROUP (ORDER BY sort_expression)

and save the results in a temporary table.

Then join fortune500 to the temporary table to select companies with profits greater than the 80th percentile cut-off.
*/

/*
Instructions 1/2
- Create a temporary table called profit80 containing the sector and 80th percentile of profits for each sector.
- Alias the percentile column as pct80.
*/

-- To clear table if it already exists;
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500
   GROUP BY sector;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;


/*
Instructions 2/2
- Using the profit80 table you created in step 1, select companies that have profits greater than pct80.
- Select the title, sector, profits from fortune500, as well as the ratio of the company's profits to the 80th percentile profit.
*/

-- Code from previous step
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
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