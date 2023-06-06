WITH team_statistics AS (
    SELECT t.teamid, t.team_name,
               (
               SELECT p.fname || ' ' || p.lname
               FROM chashken.team t2
               JOIN oreich.play_in pla ON t2.teamid = pla.team_id
               JOIN liocohen.player p ON p.id = pla.player_id
               JOIN oreich.throw th ON th.thrower_id = p.id
               WHERE t2.teamid = t.teamid
               GROUP BY p.fname, p.lname
               HAVING SUM(th.score) > 77
               ORDER BY SUM(th.score) DESC
               FETCH FIRST 1 ROWS ONLY
           ) AS best_player_name,
           COUNT(*) AS total_games,
           (SUM(CASE WHEN gts.IsWin = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS win_percentage
    FROM chashken.team t
    JOIN akorman.games g ON t.teamid IN (g.hometeamid, g.awayteamid)
    JOIN akorman.gameTeamStats gts ON g.gameid = gts.gameid AND t.teamid = gts.teamid
    GROUP BY t.teamid, t.team_name
),
teams_over_77 AS (
    SELECT t.teamid, t.team_name
    FROM chashken.team t
    JOIN oreich.play_in pla ON t.teamid = pla.team_id
    JOIN (
        SELECT thrower_id, SUM(score) AS total_score
        FROM oreich.throw
        GROUP BY thrower_id
        HAVING SUM(score) > 77
    ) player_score ON pla.player_id = player_score.thrower_id
    GROUP BY t.teamid, t.team_name
)
SELECT t.teamid, t.team_name, t.best_player_name, t.win_percentage, t.total_games
FROM team_statistics t
JOIN teams_over_77 p ON t.teamid = p.teamid
GROUP BY t.teamid, t.team_name, t.win_percentage,  t.best_player_name, t.total_games
ORDER BY t.win_percentage DESC, t.team_name ASC;
