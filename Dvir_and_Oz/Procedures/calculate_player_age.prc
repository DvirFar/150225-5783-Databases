CREATE OR REPLACE PROCEDURE calculate_player_age AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Player Age:');
    DBMS_OUTPUT.PUT_LINE('------------------------');
    DBMS_OUTPUT.PUT_LINE('Player ID     Player Name       Age');

    FOR player_row IN (
        SELECT p.id, p.fname || ' ' || p.lname AS player_name, TRUNC(MONTHS_BETWEEN(SYSDATE, p.birthday) / 12) AS age
        FROM liocohen.player p
        ORDER BY p.id ASC
        FETCH FIRST 100 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            LPAD(player_row.id, 4) || '     ' ||
            LPAD(player_row.player_name, 20) || '   ' ||
            player_row.age
        );
    END LOOP;
END;
/
