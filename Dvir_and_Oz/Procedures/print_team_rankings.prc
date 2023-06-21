CREATE OR REPLACE PROCEDURE print_team_rankings AS
    rank_counter NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Team Rankings:');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    DBMS_OUTPUT.PUT_LINE('  Rank         Team Name  Win Percentage');

    FOR team_row IN (
        -- Query to calculate team statistics and rank the teams
        SELECT t.teamid, t.team_name, (SUM(CASE WHEN gts.IsWin = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS win_percentage
        FROM chashken.team t
        JOIN akorman.games g ON t.teamid IN (g.hometeamid, g.awayteamid)
        JOIN akorman.gameTeamStats gts ON g.gameid = gts.gameid AND t.teamid = gts.teamid
        GROUP BY t.teamid, t.team_name
        ORDER BY win_percentage DESC
        fetch first 100 rows only
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            LPAD(rank_counter, 5) || '   ' ||
            LPAD(team_row.team_name, 15) || '   ' ||
            team_row.win_percentage
        );
        rank_counter := rank_counter + 1;
    END LOOP;
END;
/
