SELECT
    season,
    player,
    SUM(att),
    SUM(cmp),
    SUM(yds),
    SUM(td),
    SUM(intercep)
FROM
    (
        SELECT
            CASE
                WHEN EXTRACT(YEAR FROM nfl_pbp.gamedate) < 7 THEN
                    EXTRACT(YEAR FROM nfl_pbp.gamedate) - 1
                ELSE
                    EXTRACT(YEAR FROM nfl_pbp.gamedate)
            END AS season,
            regexp_substr(TRIM(substr(nfl_pbp.detail, 1, instr(nfl_pbp.detail, 'pass') - 1)), '\w+\s\w+$') player,
            instr(nfl_pbp.detail, 'pass'),
            regexp_count(nfl_pbp.detail, 'pass') att,
            regexp_count(nfl_pbp.detail, 'pass complete') cmp,
            nfl_pbp.yds,
            regexp_count(nfl_pbp.detail, 'touchdown') td,
            regexp_count(nfl_pbp.detail, 'intercepted') intercep,
            nfl_pbp.detail
        FROM
            nfl_pbp
        WHERE
            ( nfl_pbp.detail LIKE '%pass complete%'
              OR nfl_pbp.detail LIKE '%pass incomplete%' )
            AND nfl_pbp.detail NOT LIKE '%(no play)%'
            AND nfl_pbp.detail NOT LIKE '%Two Point%'
    )
GROUP BY
    season,
    player
ORDER BY
    season,
    player