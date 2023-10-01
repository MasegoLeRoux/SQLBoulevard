--1. **Retrieve All Player Names and Clubs:**
 
   SELECT [player_name], [club]
   FROM [UCL].[dbo].[distributon$];


--2. **Players with the Highest Pass Accuracy:**
 
   SELECT TOP 10 [player_name], [pass_accuracy]
   FROM [UCL].[dbo].[distributon$]
   ORDER BY [pass_accuracy] DESC;


--3. **Count of Players in Each Position:**
 
   SELECT [position], COUNT(*) AS [player_count]
   FROM [UCL].[dbo].[distributon$]
   GROUP BY [position];


--4. **Players with the Most Cross Completions:**
 
   SELECT TOP 10 [player_name], [cross_complted]
   FROM [UCL].[dbo].[distributon$]
   ORDER BY [cross_complted] DESC;


--5. **Total Matches Played by Each Club:**
 
   SELECT [club], SUM([match_played]) AS [total_matches_played]
   FROM [UCL].[dbo].[distributon$]
   GROUP BY [club];


--6. **Average Pass Accuracy Across Positions:**
 
SELECT
    [position],
    ROUND(AVG(CONVERT(float, [pass_accuracy])), 2) AS [avg_pass_accuracy]
FROM [UCL].[dbo].[distributon$]
GROUP BY [position];


--7. **Players with the Most Free Kicks Taken:**
 
   SELECT TOP 10 [player_name],[club], [freekicks_taken]
   FROM [UCL].[dbo].[distributon$]
   ORDER BY [freekicks_taken] DESC;


--8. **Players with the Highest Cross Accuracy:**
 
   SELECT TOP 10 [player_name], [cross_accuracy]
   FROM [UCL].[dbo].[distributon$]
   ORDER BY [cross_accuracy] DESC;
  

--9. **Players with the Best Pass Completion Rate:**
 
   SELECT TOP 10 [player_name], ([pass_completed]*100.0)/[pass_attempted] AS [pass_completion_rate]
   FROM [UCL].[dbo].[distributon$]
   ORDER BY [pass_completion_rate] DESC;


--10. **Players with the Most Matches Played:**
  
    SELECT TOP 10 [player_name], [match_played]
    FROM [UCL].[dbo].[distributon$]
    ORDER BY [match_played] DESC;



--11. **Players with the Highest Pass Accuracy in Each Position:**
  
   SELECT top 5 [position], [player_name], [pass_accuracy]
   FROM (
       SELECT [position], [player_name], [pass_accuracy],
              ROW_NUMBER() OVER (PARTITION BY [position] ORDER BY [pass_accuracy] DESC) AS rnk
       FROM [UCL].[dbo].[distributon$]
   ) ranked
   WHERE rnk = 1;


--12. **Cumulative Pass Accuracy Over Matches Played:**
  
SELECT
    [player_name],
    [match_played],
    SUM(CONVERT(float, [pass_accuracy])) OVER (PARTITION BY [player_name] ORDER BY [match_played]) AS [cumulative_pass_accuracy]
FROM [UCL].[dbo].[distributon$];


--13. **Players with the Most Consistent Performance (Low Variance in Pass Accuracy):**
  
SELECT
    [player_name],
    AVG(CONVERT(float, [pass_accuracy])) AS [avg_pass_accuracy],
    SQRT(VAR(CONVERT(float, [pass_accuracy]))) AS [pass_accuracy_standard_deviation]
FROM [UCL].[dbo].[distributon$]
GROUP BY [player_name]
HAVING SQRT(VAR(CONVERT(float, [pass_accuracy]))) < 5; -- Adjust the threshold as needed



--14. **Ranking Players by Overall Contribution (Pass Accuracy + Cross Accuracy):**
  
   SELECT top 10 [player_name], ([pass_completed] + [cross_complted])/([pass_attempted] + [cross_attempted])*100 AS [overall_contribution],
          RANK() OVER (ORDER BY ([pass_completed] + [cross_complted]) DESC) AS rnk
   FROM [UCL].[dbo].[distributon$]
   WHERE [pass_accuracy] IS NOT NULL AND [cross_accuracy] IS NOT NULL
   ORDER BY rnk;


--15. **Finding Players with a Significant Increase in Pass Accuracy:**
  
SELECT [player_name], [pass_accuracy], [prev_pass_accuracy]
FROM (
    SELECT
        [player_name],
        CONVERT(float, [pass_accuracy]) AS [pass_accuracy],
        LAG(CONVERT(float, [pass_accuracy])) OVER (PARTITION BY [player_name] ORDER BY [match_played]) AS [prev_pass_accuracy]
    FROM [UCL].[dbo].[distributon$]
) AS Subquery
WHERE [pass_accuracy] > [prev_pass_accuracy] + 10;

-- Adjust the threshold as needed


--16. **Players with the Most Varied Positional Roles (Distinct Positions Played):**
  
   SELECT [player_name], COUNT(DISTINCT [position]) AS [unique_positions_played]
   FROM [UCL].[dbo].[distributon$]
   GROUP BY [player_name]
   ORDER BY [unique_positions_played] DESC;


--17. **Calculating Pass Accuracy Improvement After Cross Attempts:**
  
   SELECT [player_name], [pass_accuracy], [pass_accuracy_after_cross]
   FROM (
       SELECT [player_name], [pass_accuracy],
              LAG([pass_accuracy]) OVER (PARTITION BY [player_name] ORDER BY [cross_attempted]) AS [pass_accuracy_after_cross]
       FROM [UCL].[dbo].[distributon$]
   ) improved_pass_accuracy
   WHERE [pass_accuracy_after_cross] IS NOT NULL;


--18. **Identifying Players with an Increasing Trend in Matches Played:**
  
   SELECT [player_name], [match_played], [match_played_trend]
   FROM (
       SELECT [player_name], [match_played],
              [match_played] - LAG([match_played]) OVER (PARTITION BY [player_name] ORDER BY [match_played]) AS [match_played_trend]
       FROM [UCL].[dbo].[distributon$]
   ) increased_matches
   WHERE [match_played_trend] > 0;

--19. **Identifying Players with Consistently High Performance Across Categories:**
   
SELECT
    [player_name],
    AVG(CONVERT(float, [pass_accuracy])) AS [avg_pass_accuracy],
    AVG(CONVERT(float, [cross_accuracy])) AS [avg_cross_accuracy],
    AVG(CONVERT(float, [freekicks_taken])) AS [avg_freekicks_taken]
FROM [UCL].[dbo].[distributon$]
GROUP BY [player_name]
HAVING
    AVG(CONVERT(float, [pass_accuracy])) > 80 AND
    AVG(CONVERT(float, [cross_accuracy])) > 70 AND
    AVG(CONVERT(float, [freekicks_taken])) > 5 AND
    AVG(CONVERT(float, [match_played])) > 5;