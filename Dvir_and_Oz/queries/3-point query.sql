SELECT
    player_name,
    team_name,
    home_stadium,
    best_location,
    total_three_point_throw
FROM (
    SELECT
        player_name,
        team_name,
        home_stadium,
        location AS best_location,
        three_point_throw,
        total_three_point_throw,
        ROW_NUMBER() OVER (PARTITION BY player_name ORDER BY three_point_throw DESC) AS rn
    FROM (
        SELECT
            p.fname || ' ' || p.lname AS player_name,
            te.team_name,
            s.stadium_name AS home_stadium,
            player_throw_stats.location,
            player_throw_stats.three_point_throw,
            total_throw_stats.total_three_point_throw
        FROM (
            SELECT
                th.thrower_id,
                th.location,
                COUNT(*) AS three_point_throw,
                MAX(COUNT(*)) OVER (PARTITION BY th.thrower_id) AS max_three_point_throw
            FROM oreich.throw th
            WHERE th.score = 3
            GROUP BY th.thrower_id, th.location
        ) player_throw_stats
        JOIN liocohen.player p ON p.id = player_throw_stats.thrower_id
        JOIN oreich.play_in pla ON pla.player_id = player_throw_stats.thrower_id
        JOIN chashken.team te ON te.teamid = pla.team_id
        JOIN chashken.stadium s ON te.stadiumid = s.stadiumid
        JOIN (
            SELECT
                thrower_id,
                COUNT(*) AS total_three_point_throw
            FROM oreich.throw
            WHERE score = 3
            GROUP BY thrower_id
        ) total_throw_stats ON total_throw_stats.thrower_id = player_throw_stats.thrower_id
        WHERE player_throw_stats.three_point_throw = player_throw_stats.max_three_point_throw and total_throw_stats.total_three_point_throw > 16
    ) player_stats
) player_summary
WHERE rn = 1
ORDER BY total_three_point_throw DESC, team_name ASC, player_name ASC;
