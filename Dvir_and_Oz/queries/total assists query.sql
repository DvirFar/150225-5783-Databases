select t.teamid, t.team_name, sum(gts.assists) as total_assists
from akorman.gameteamstats gts
join chashken.team t on t.teamid = gts.teamid
group by t.teamid, t.team_name
order by sum(gts.assists) desc
