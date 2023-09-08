---These scripts provide a range of insights into player and team discipline in the UEFA Champions League based on the provided columns.
--1. *--Top Foulers**:
   -- Find the top 10 players with the highest number of fouls committed in the UCL.

SELECT TOP 10 player_name, club,fouls_committed,match_played
FROM disciplinary$
ORDER BY fouls_committed DESC;
go 

--2. --Most Disciplined Players**:
   -- Identify players with the fewest fouls and cards received in the UCL.


SELECT TOP 10 player_name, club,fouls_committed,match_played, red, yellow
FROM [disciplinary$]
ORDER BY fouls_committed ASC, red ASC, yellow ASC;
go 

--3. --Players with Red Card Records--:
   -- Find players with the highest number of red cards in the UCL.


SELECT TOP 10 player_name,club, red,match_played
FROM [disciplinary$]
ORDER BY red DESC;
go

--4. --Players with Consistent Yellow Cards**:
   --- Identify players with a high number of yellow cards but a low number of red cards, indicating consistent discipline issues.


SELECT TOP 10 player_name, yellow, red
FROM [disciplinary$]
ORDER BY yellow DESC, red ASC;
go

--5.---Average Fouls Committed per Position**:
-- Calculate the average number of fouls committed by players in each position.


SELECT position, AVG(fouls_committed) AS avg_fouls_committed
FROM [disciplinary$]
GROUP BY position;
go

--6.--Players with Most Minutes Played**:
   --Find the top 10 players with the highest total minutes played in the UCL.


SELECT TOP 10 player_name, club,SUM(minutes_played) AS total_minutes_played
FROM [disciplinary$]
GROUP BY player_name
ORDER BY total_minutes_played DESC
go

--7. --Players with High Fouls per Minute**:
   -- Identify players with the highest average number of fouls committed per minute played.


SELECT TOP 10 player_name ,SUM(fouls_committed) / SUM(minutes_played) AS fouls_per_minute
FROM [disciplinary$]
GROUP BY player_name
ORDER BY fouls_per_minute DESC;
go

--8 and 9 .--Teams with Most Yellow Cards and Red Cards**:
  --etermine which clubs (teams) have received the most yellow cards in total.


SELECT club, SUM(red) AS total_red_cards, SUM(yellow) AS total_yellow_cards
FROM [disciplinary$]
GROUP BY club
ORDER BY total_yellow_cards DESC;


--10.-- **Players with Most Matches Played**:
  -- - Find the top 10 players who have played the most matches in the UCL.

SELECT TOP 10 player_name, MAX(match_played) AS max_matches_played
FROM [disciplinary$]
GROUP BY player_name
ORDER BY max_matches_played DESC
go


--11. **Player Discipline History**:
   -- - Retrieve the disciplinary history (fouls, yellow cards, and red cards) for a specific player over multiple seasons.


SELECT  player_name, fouls_committed, yellow, red
FROM [disciplinary$]
WHERE player_name = '<player_name>'



--Remember to replace `<player_name>` with the name of the specific player you want to analyze in the last query. These scripts provide a range of insights into player and team discipline in the UEFA Champions League based on the provided columns.
--12--Player Discipline by Position:
--Calculate average fouls committed, yellow cards, and red cards for each player position.
SELECT
    position,
    ROUND(AVG(fouls_committed), 2) AS avg_fouls,
    ROUND(AVG(yellow), 2) AS avg_yellow,
    ROUND(AVG(red), 2) AS avg_red
FROM disciplinary$
GROUP BY position;

--13--Team Discipline Summary:
--Generate a summary of each team's discipline by calculating the average fouls, yellow cards, and red cards for players in each club.

SELECT club, ROUND(AVG(fouls_committed),2) AS avg_fouls,ROUND( AVG(yellow),2) AS avg_yellow, ROUND(AVG(red),2) AS avg_red
FROM disciplinary$
GROUP BY club;


--14--Players with Persistent Yellow Card Accumulation:
---Find players who consistently accumulate a high number of yellow cards without receiving a red card.

SELECT player_name, MAX(yellow) AS max_yellow_cards
FROM [disciplinary$]
WHERE red = 0
GROUP BY player_name
HAVING MAX(yellow) <5; -- Adjust threshold as needed