

```markdown
# UEFA Champions League (UCL) 2021/22 Season Disciplinary Data Analysis

## Overview

This repository contains a set of SQL scripts that provide valuable insights into player and team discipline in the UEFA Champions League for the 2021/22 season. These scripts analyze disciplinary data, including fouls committed, red cards, yellow cards, minutes played, and matches played. Each script is accompanied by a description of its purpose and a SQL query to execute.

## SQL Scripts

1. **Top Foulers**:
   - Find the top 10 players with the highest number of fouls committed in the UCL.

```sql
SELECT TOP 10 player_name, club, fouls_committed, match_played
FROM disciplinary$
ORDER BY fouls_committed DESC;
```

2. **Most Disciplined Players**:
   - Identify players with the fewest fouls and cards received in the UCL.

```sql
SELECT TOP 10 player_name, club, fouls_committed, match_played, red, yellow
FROM [disciplinary$]
ORDER BY fouls_committed ASC, red ASC, yellow ASC;
```

3. **Players with Red Card Records**:
   - Find players with the highest number of red cards in the UCL.

```sql
SELECT TOP 10 player_name, club, red, match_played
FROM [disciplinary$]
ORDER BY red DESC;
```

4. **Players with Consistent Yellow Cards**:
   - Identify players with a high number of yellow cards but a low number of red cards, indicating consistent discipline issues.

```sql
SELECT TOP 10 player_name, yellow, red
FROM [disciplinary$]
ORDER BY yellow DESC, red ASC;
```

5. **Average Fouls Committed per Position**:
   - Calculate the average number of fouls committed by players in each position.

```sql
SELECT position, AVG(fouls_committed) AS avg_fouls_committed
FROM [disciplinary$]
GROUP BY position;
```

6. **Players with Most Minutes Played**:
   - Find the top 10 players with the highest total minutes played in the UCL.

```sql
SELECT TOP 10 player_name, club, SUM(minutes_played) AS total_minutes_played
FROM [disciplinary$]
GROUP BY player_name
ORDER BY total_minutes_played DESC;
```

7. **Players with High Fouls per Minute**:
   - Identify players with the highest average number of fouls committed per minute played.

```sql
SELECT TOP 10 player_name, SUM(fouls_committed) / SUM(minutes_played) AS fouls_per_minute
FROM [disciplinary$]
GROUP BY player_name
ORDER BY fouls_per_minute DESC;
```

8 and 9. **Teams with Most Yellow Cards and Red Cards**:
   - Determine which clubs (teams) have received the most yellow cards in total.

```sql
SELECT club, SUM(red) AS total_red_cards, SUM(yellow) AS total_yellow_cards
FROM [disciplinary$]
GROUP BY club
ORDER BY total_yellow_cards DESC;
```

10. **Players with Most Matches Played**:
    - Find the top 10 players who have played the most matches in the UCL.

```sql
SELECT TOP 10 player_name, MAX(match_played) AS max_matches_played
FROM [disciplinary$]
GROUP BY player_name
ORDER BY max_matches_played DESC;
```

11. **Player Discipline History**:
    - Retrieve the disciplinary history (fouls, yellow cards, and red cards) for a specific player over multiple seasons.
   
   Replace `<player_name>` with the desired player's name in the SQL query.

12. **Player Discipline by Position**:
    - Calculate average fouls committed, yellow cards, and red cards for each player position.

```sql
SELECT
    position,
    ROUND(AVG(fouls_committed), 2) AS avg_fouls,
    ROUND(AVG(yellow), 2) AS avg_yellow,
    ROUND(AVG(red), 2) AS avg_red
FROM disciplinary$
GROUP BY position;
```

13. **Team Discipline Summary**:
    - Generate a summary of each team's discipline by calculating the average fouls, yellow cards, and red cards for players in each club.

```sql
SELECT club, ROUND(AVG(fouls_committed), 2) AS avg_fouls, ROUND(AVG(yellow), 2) AS avg_yellow, ROUND(AVG(red), 2) AS avg_red
FROM disciplinary$
GROUP BY club;
```

14. **Players with Persistent Yellow Card Accumulation**:
    - Find players who consistently accumulate a high number of yellow cards without receiving a red card.

```sql
SELECT player_name, MAX(yellow) AS max_yellow_cards
FROM [disciplinary$]
WHERE red = 0
GROUP BY player_name
HAVING MAX(yellow) < 5; -- Adjust threshold as needed
```

These scripts provide a comprehensive analysis of disciplinary data in the UEFA Champions League for the 2021/22 season. You can execute these SQL queries to gain valuable insights into player and team discipline trends.
```