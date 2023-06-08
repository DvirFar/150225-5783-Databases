WITH free_throw_stats AS (
     SELECT p.fname || ' ' || p.lname AS player_name,
            te.team_name AS team_name,
            COUNT(CASE WHEN t.type = 'Free Throw' THEN 1 END) AS total_free_throws,
            COUNT(CASE WHEN t.type = 'Free Throw' AND t.score = 1 THEN 1 END) AS successful_free_throws
     FROM oreich.throw t 
     JOIN liocohen.player p ON p.id = t.thrower_id
     JOIN oreich.play_in pla ON pla.player_id = t.thrower_id
     JOIN chashken.team te ON te.teamid = pla.team_id
     GROUP BY p.fname || ' ' || p.lname, te.team_name
),

ft_percent AS (
     SELECT player_name,
            team_name,
            total_free_throws,
            successful_free_throws,
            (CAST(successful_free_throws AS FLOAT) / total_free_throws) * 100 AS ft_percentage
     FROM free_throw_stats
     WHERE total_free_throws > 0
     ORDER BY ft_percentage DESC, total_free_throws DESC
)

SELECT *
FROM ft_percent
WHERE ft_percentage > 88;
