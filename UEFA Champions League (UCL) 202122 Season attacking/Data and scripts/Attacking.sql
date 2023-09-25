
--1. **Top Assisters in the UCL:**
--   Identify the top players with the most assists in descending order.

  
   SELECT TOP 10 player_name, assists
   FROM attacking$
   ORDER BY assists DESC;
  

--2. **Player Scoring Efficiency:**
--   Calculate and rank players based on their average goals per match.

  
   SELECT player_name, club, round((assists * 1.0 / match_played),2) AS goals_per_match
   FROM attacking$
   ORDER BY goals_per_match DESC;
  

--3. **Distribution of Corner Kicks Taken:**
--   Analyze the distribution of corner kicks taken by players.

  
   SELECT top 10 corner_taken, COUNT(*) AS num_players
   FROM attacking$
   GROUP BY corner_taken;
  

--4. **Top Dribblers by Club:**
--   Find the top dribblers for each club based on the number of successful dribbles.

  
   SELECT club, player_name, dribbles
   FROM attacking$
   WHERE player_name IN (
       SELECT TOP 1 player_name
       FROM attacking$ AS a
       WHERE a.club = attacking$.club
       ORDER BY dribbles DESC
   );
  

--5. **Players with High Assist and Goals Contribution:**
--   Identify players who have contributed both in terms of goals (assists) and scoring (corner kicks).

  
   SELECT player_name, club, (assists + corner_taken) AS total_contributions
   FROM attacking$
   WHERE (assists + corner_taken) > 10
   ORDER BY total_contributions DESC;
  

--6. **Player Position and Assists:**
--   Group players by position and calculate the average number of assists for each position.

  
   SELECT position, ROUND(AVG(assists),2) AS avg_assists
   FROM attacking$
   GROUP BY position;
  

--7. **Top Offside Offenders:**
--   Find the players with the most offside incidents.

  
   SELECT TOP 10 player_name,CLUB, offsides
   FROM attacking$
   ORDER BY offsides DESC;
  

--8. **Players with a High Dribble Success Rate:**
--   Identify players with a dribble success rate greater than a certain threshold.

  
   SELECT player_name, club,match_played, ROUND((dribbles * 100.0 / (dribbles + match_played)),2) AS dribble_success_rate
   FROM attacking$
   WHERE (dribbles + match_played) > 0
   ORDER BY match_played DESC;
  

--9. **Player Match Participation Analysis:**
--   Analyze player participation by counting the number of players who have played a specific number of matches.

  
   SELECT match_played, COUNT(*) AS num_players
   FROM attacking$
   GROUP BY match_played;
  

--10. **Top Assisting Clubs:**
--    List the clubs with the highest total assists in descending order.

   
    SELECT club, SUM(assists) AS total_assists
    FROM attacking$
    GROUP BY club
    ORDER BY total_assists DESC;
   
--11. **Players with Consistent Assists:**
--    Identify players who have consistently provided assists in a high percentage of matches played.

    
    SELECT player_name, club, match_played,ROUND((assists * 100.0 / match_played),2) AS assist_percentage
    FROM attacking$
    WHERE match_played > 10 -- Adjust the minimum number of matches played as needed
    ORDER BY assist_percentage DESC;
    

--12. **Player Assists Distribution:**
--    Visualize the distribution of assists by grouping players into buckets based on their assist count.

    
    SELECT assists_bucket, COUNT(*) AS num_players
    FROM (
        SELECT CASE
            WHEN assists <= 5 THEN '0-5'
            WHEN assists <= 10 THEN '6-10'
            ELSE '11+' END AS assists_bucket
        FROM attacking$
    ) AS AssistBuckets
    GROUP BY assists_bucket;
    

--13. **Club's Top Assisting Player:**
--    Find the top assisting player for each club.

    
    SELECT club, player_name, assists
    FROM attacking$ a
    WHERE assists = (
        SELECT MAX(assists)
        FROM attacking$
        WHERE club = a.club
    ) ORDER BY club DESC;
    

--14. **Player Contribution Percentage:**
--    Calculate and rank players based on their percentage contribution to the total assists in the dataset.

    
    SELECT player_name, club, Round((assists * 100.0 / (SELECT SUM(assists) FROM attacking$)),2) AS contribution_percentage
    FROM attacking$
    ORDER BY contribution_percentage DESC;
    

--15. **Top Scorers with Low Offsides:**
--    Find players with a high number of assists but a low number of offsides incidents.

    
    SELECT TOP 10 player_name, assists, offsides
    FROM attacking$
    WHERE offsides < (assists * 0.1) -- Adjust the threshold as needed
    ORDER BY assists DESC;
    

--16. **Position-wise Corner Kick Analysis:**
--    Analyze the average number of corner kicks taken by players based on their positions.

    
    SELECT position, round(AVG(corner_taken),2) AS avg_corner_kicks
    FROM attacking$
    GROUP BY position;
    

--17. **Players with High Dribble Success and Assists:**
--    Identify players who excel in both dribbling (high success rate) and providing assists.

    
    SELECT player_name, club, (dribbles *0.1/ (dribbles + offsides)) AS dribble_success_rate, assists
    FROM attacking$
    WHERE (dribbles + offsides) > 0
    ORDER BY dribble_success_rate DESC, assists DESC;
    

--18. **Player Assists Over Time:**
--    Visualize how a specific player's assists have evolved over time (matches).

    
    SELECT player_name, match_played, assists
    FROM attacking$
    WHERE player_name IN ('Koke', 'Forsberg')
    ORDER BY match_played;
    

--19. **Player Assists Per Match by Club:**
--    Calculate and rank players within each club based on their average assists per match.

    
    WITH PlayerRanking AS (
        SELECT player_name, club,ROUND( AVG(assists * 1.0 / match_played),2) AS assists_per_match
        FROM attacking$
        GROUP BY player_name, club
    )
    SELECT club, player_name, assists_per_match
    FROM (
        SELECT club, player_name, assists_per_match,
               ROW_NUMBER() OVER (PARTITION BY club ORDER BY assists_per_match DESC) AS ranking
        FROM PlayerRanking
    ) AS RankedPlayers
    WHERE ranking <= 3; -- Top 3 players per club