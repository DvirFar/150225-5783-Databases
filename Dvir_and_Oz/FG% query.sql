WITH field_throws AS (
     select 
                  p.FNAME || ' ' || p.LNAME AS player_name,
                  te.team_name AS team_name,
                  COUNT(*) AS total_field_throws,
                  SUM(CASE WHEN t.score > 1 THEN 1 ELSE 0 END) AS  made_field_throws,
                  (SUM(CASE WHEN t.score > 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS field_throw_percentage
     FROM oreich.throw t 
     JOIN liocohen.player p ON p.id = t.thrower_id
     JOIN oreich.play_in pla ON pla.player_id = t.thrower_id
     JOIN chashken.team te ON te.teamid = pla.team_id
     HAVING COUNT(*) > 0
     GROUP BY p.FNAME || ' ' || p.LNAME, te.team_name
)

select * from field_throws
where field_throw_percentage > 55
ORDER BY field_throw_percentage desc, total_field_throws desc;
