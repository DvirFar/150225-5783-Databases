SELECT t.teamid, t.team_name, COUNT(*) AS total_games_played
FROM chashken.team t
JOIN akorman.games g ON t.teamid IN (g.hometeamid, g.awayteamid)
WHERE EXTRACT(YEAR FROM to_date(g.gamedate, 'yyyy-mm-dd')) between 2012 and 2022
GROUP BY t.teamid, t.team_name
ORDER BY total_games_played DESC;
