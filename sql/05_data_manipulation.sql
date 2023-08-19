-- Basic CASE statements

--In this exercise, you will identify matches played between FC Schalke 04 and FC Bayern Munich. 
-- There are 2 teams identified in each match in the hometeam_id and awayteam_id columns, available to you in the filtered matches_germany table. ID can join to the team_api_id column in the teams_germany table, but you cannot perform a join on both at the same time.

-- However, you can perform this operation using a CASE statement once you've identified the team_api_id associated with each team!

SELECT
	-- Select the team long name and team API id
	team_api_id
	,team_long_name
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');

-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
        CASE 
                WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
                WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
                ELSE 'Other' 
        END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;




-- CASE statements comparing column values

-- In this exercise, you will be creating a list of matches in the 2011/2012 season where Barcelona was the home team. You will do this using a CASE statement that compares the values of two columns to create a new group -- wins, losses, and ties.

SELECT 
	-- Select the date of the match
	date,
	-- Identify home wins, losses, or ties
	CASE 
                WHEN home_goal > away_goal THEN 'Home win!'
                WHEN home_goal < away_goal THEN 'Home loss :(' 
                ELSE 'Tie' 
        END AS outcome
FROM matches_spain;


SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;


SELECT 
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	CASE 
                WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
                WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :(' 
                ELSE 'Tie' 
        END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634; 