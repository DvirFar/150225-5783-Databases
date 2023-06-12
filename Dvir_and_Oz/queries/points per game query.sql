SELECT p.id, p.fname || ' ' || p.lname AS player_name, t.team_name, SUM(th.score)/COUNT(th.game_id) AS points_per_game
FROM liocohen.player p
JOIN oreich.throw th ON th.thrower_id = p.id
JOIN oreich.play_in pla ON pla.player_id = th.thrower_id
JOIN chashken.team t ON t.teamid = pla.team_id
GROUP BY p.id, p.fname, p.lname, t.team_name
HAVING SUM(th.score)/COUNT(th.game_id) > 1.55
ORDER BY points_per_game DESC, p.fname || ' ' || p.lname ASC
