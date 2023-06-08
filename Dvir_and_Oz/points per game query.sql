select p.id, p.fname || ' ' || p.lname as player_name, sum(t.score)/count(t.game_id) as points_per_game
from liocohen.player p
join oreich.throw t on t.thrower_id = p.id
group by p.id, p.fname, p.lname
order by points_per_game desc
fetch first 50 rows only
