

--1. **Rank Players by Tackles Won Percentage:**
--   This query ranks players by their tackles won percentage in descending order.

SELECT top 50 player_name, club,
       CASE WHEN Tackles > 0 THEN ROUND((t_won * 100.0 / Tackles), 2) ELSE NULL END AS TacklesWonPercentage
FROM defending$
WHERE [match_played] > 8
ORDER BY TacklesWonPercentage DESC;

--2. **Find Clubs with the Best Defensive Team:**
--   This query identifies clubs with players who have the highest average balls recovered per match.

   SELECT top 10 Club,ROUND(AVG(balls_recoverd / match_played),2) AS AvgBallsRecoveredPerMatch
   FROM defending$
   GROUP BY Club
   ORDER BY AvgBallsRecoveredPerMatch DESC;

--3. **Identify Versatile Players:**
--   Find players who have played multiple positions and display the count of positions they have played.

   SELECT player_name, COUNT(DISTINCT Position) AS UniquePositionsPlayed
   FROM defending$
   GROUP BY player_name
   HAVING UniquePositionsPlayed > 1;
 

--4. **Calculate Total Clearances per Club:**
--   Determine the total clearance attempts for each club.

   SELECT Club, SUM(clearance_attempted) AS TotalClearances
   FROM defending$
   GROUP BY Club
   ORDER BY TotalClearances DESC;


--5. **Top Defensive Performances by Club:**
   SELECT top 10  Club, sum(t_won) AS MaxTacklesWon
   FROM defending$
   GROUP BY Club
   ORDER BY MaxTacklesWon DESC;

--6. **Find Players with High Tackle Efficiency:**
--   Identify players who have a high ratio of tackles won to tackles attempted.

   SELECT player_name, Club, ROUND((t_won * 1.0 / Tackles)*100,2) AS TackleEfficiency
   FROM defending$
   WHERE Tackles > 10  -- Include players with a minimum number of tackles attempted
   ORDER BY TackleEfficiency DESC;
	go

--7. **Player Defensive Performance Comparison:**
--   Compare the performance of two players in terms of balls recovered and clearances.

   SELECT player_name, Club, balls_recoverd, clearance_attempted
   FROM defending$
   WHERE player_name IN ('Koke', 'Rodri');


--8. **Find Players with High Match Participation:**
--   Identify players who have played in at least 80% of matches.

   SELECT player_name, Club, match_played
   FROM defending$
   WHERE match_played >= (0.8 * (SELECT MAX(match_played) FROM defending$));


--9. **Calculate Average Tackles Per Match:**
--   Calculate the average number of tackles per match for all players.

   SELECT top 50 player_name, Club, ROUND(AVG(Tackles / match_played),2) AS AvgTacklesPerMatch
   FROM defending$
   GROUP BY player_name, Club
   ORDER BY AvgTacklesPerMatch DESC;


--10. **Identify Defensive Specialists:**
--    Find players who have a high combination of tackles won and clearances attempted.

    SELECT player_name, Club, t_won, clearance_attempted
    FROM defending$
    WHERE t_won > 10 AND clearance_attempted > 10;
go