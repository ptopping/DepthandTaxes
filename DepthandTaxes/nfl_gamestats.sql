WITH opponents 
     AS (SELECT DISTINCT( team_id ) 
         FROM   (SELECT nfl_game.hometeam_id AS team_id 
                 FROM   nfl_game 
                 WHERE  nfl_game.week_seasonvalue = :year 
                        AND nfl_game.awayteam_abbreviation = :abbreviation 
                        AND ( nfl_game.week_seasontype = 'REG' 
                               OR nfl_game.week_seasontype = 'POST' ) 
                 UNION 
                 SELECT nfl_game.awayteam_id AS team_id 
                 FROM   nfl_game 
                 WHERE  nfl_game.week_seasonvalue = :year 
                        AND nfl_game.hometeam_abbreviation = :abbreviation 
                        AND ( nfl_game.week_seasontype = 'REG' 
                               OR nfl_game.week_seasontype = 'POST' ))) 
SELECT CASE 
         WHEN nfl_game.awayteam_abbreviation = :abbreviation THEN 
         nfl_game.awayteam_abbreviation 
         ELSE 'NFL' 
       END          AS abbreviation 
       ,nfl_game.id AS game_id 
       ,CASE 
          WHEN nfl_game_playstats.statid IN ( 15, 16, 20 ) 
               AND nfl_game.awayteam_abbreviation = :abbreviation 
               AND nfl_game.awayteam_id != nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          WHEN nfl_game_playstats.statid IN ( 15, 16, 20 ) 
               AND nfl_game.awayteam_abbreviation != :abbreviation 
               AND nfl_game.awayteam_id = nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          ELSE 0 
        END         AS passing_yards_defense 
       ,CASE 
          WHEN nfl_game_playstats.statid IN ( 15, 16, 20 ) 
               AND nfl_game.awayteam_abbreviation = :abbreviation 
               AND nfl_game.awayteam_id = nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          WHEN nfl_game_playstats.statid IN ( 15, 16, 20 ) 
               AND nfl_game.awayteam_abbreviation != :abbreviation 
               AND nfl_game.awayteam_id != nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          ELSE 0 
        END         AS passing_yards_offense 
       ,CASE 
          WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 ) 
               AND nfl_game.awayteam_abbreviation = :abbreviation 
               AND nfl_game.awayteam_id != nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 ) 
               AND nfl_game.awayteam_abbreviation != :abbreviation 
               AND nfl_game.awayteam_id = nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          ELSE 0 
        END         AS rushing_yards_defense 
       ,CASE 
          WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 ) 
               AND nfl_game.awayteam_abbreviation = :abbreviation 
               AND nfl_game.awayteam_id = nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 ) 
               AND nfl_game.awayteam_abbreviation != :abbreviation 
               AND nfl_game.awayteam_id != nfl_game_playstats.team_id THEN 
          nfl_game_playstats.yards 
          ELSE 0 
        END         AS rushing_yards_offense 
FROM   nfl_game 
       left join nfl_game_playstats 
              ON nfl_game.gamedetailid = nfl_game_playstats.id 
WHERE  nfl_game.week_seasonvalue = :year 
       AND ( nfl_game.week_seasontype = 'REG' 
              OR nfl_game.week_seasontype = 'POST' ) 
       AND ( nfl_game.awayteam_abbreviation = :abbreviation 
              OR ( nfl_game.awayteam_id IN opponents 
                   AND nfl_game.hometeam_abbreviation != :abbreviation ) ) 
       AND nfl_game_playstats.statid IN ( 10, 11, 12, 13, 
                                          15, 16, 20 ) 




SELECT abbreviation                AS abbreviation
       ,game_id                    AS game_id
       ,SUM(passing_yards_defense) AS passing_yards_defense
       ,SUM(passing_yards_offense) AS passing_yards_offense
       ,SUM(rushing_yards_defense) AS rushing_yards_defense
       ,SUM(rushing_yards_offense) AS rushing_yards_offense
FROM   (SELECT nfl_game.awayteam_abbreviation AS abbreviation
               ,nfl_game.id                   AS game_id
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.awayteam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.awayteam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_offense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.awayteam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.awayteam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_offense
        FROM   nfl_game
               left join nfl_game_playstats
                      ON nfl_game.gamedetailid = nfl_game_playstats.id
        WHERE  nfl_game.week_seasonvalue = :year
           AND nfl_game.awayteam_abbreviation = :abbreviation
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' )
           AND nfl_game_playstats.statid IN ( 10, 11, 12, 13,
                                              15, 16, 20 )
        UNION ALL
        SELECT nfl_game.hometeam_abbreviation AS abbreviation
               ,nfl_game.id                   AS game_id
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.hometeam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.hometeam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_offense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.hometeam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.hometeam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_offense
        FROM   nfl_game
               left join nfl_game_playstats
                      ON nfl_game.gamedetailid = nfl_game_playstats.id
        WHERE  nfl_game.week_seasonvalue = :year
           AND nfl_game.hometeam_abbreviation = :abbreviation
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' )
           AND nfl_game_playstats.statid IN ( 10, 11, 12, 13,
                                              15, 16, 20 )
        UNION ALL
        SELECT 'NFL' AS abbreviation
               ,nfl_game.id                   AS game_id
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.awayteam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.awayteam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_offense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.awayteam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.awayteam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_offense
        FROM   nfl_game
               left join nfl_game_playstats
                      ON nfl_game.gamedetailid = nfl_game_playstats.id
        WHERE  nfl_game.week_seasonvalue = :year
           AND nfl_game.hometeam_abbreviation != :abbreviation
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' )
           AND nfl_game_playstats.statid IN ( 10, 11, 12, 13,
                                              15, 16, 20 )
           AND nfl_game.awayteam_id IN (SELECT DISTINCT( team_id )
                                        FROM   (
               SELECT nfl_game.hometeam_id AS
                      team_id
               FROM   nfl_game
               WHERE  nfl_game.week_seasonvalue =
                      :year
                  AND nfl_game.awayteam_abbreviation =
                      :abbreviation
                  AND ( nfl_game.week_seasontype = 'REG'
                         OR nfl_game.week_seasontype =
                            'POST'
                      )
               UNION
               SELECT nfl_game.awayteam_id AS team_id
               FROM   nfl_game
               WHERE  nfl_game.week_seasonvalue = :year
                  AND nfl_game.hometeam_abbreviation =
                      :abbreviation
                  AND ( nfl_game.week_seasontype = 'REG'
                         OR nfl_game.week_seasontype =
                            'POST'
                      )))
UNION ALL
        SELECT 'NFL' AS abbreviation
               ,nfl_game.id                   AS game_id
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.hometeam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 15, 16, 20 )
                       AND nfl_game.hometeam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS passing_yards_offense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.hometeam_id = nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_defense
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                       AND nfl_game.hometeam_id != nfl_game_playstats.team_id
                THEN
                  nfl_game_playstats.yards
                  ELSE 0
                END                           AS rushing_yards_offense
        FROM   nfl_game
               left join nfl_game_playstats
                      ON nfl_game.gamedetailid = nfl_game_playstats.id
        WHERE  nfl_game.week_seasonvalue = :year
           AND nfl_game.awayteam_abbreviation != :abbreviation
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' )
           AND nfl_game_playstats.statid IN ( 10, 11, 12, 13,
                                              15, 16, 20 )
           AND nfl_game.hometeam_id IN (SELECT DISTINCT( team_id )
                                        FROM   (
               SELECT nfl_game.hometeam_id AS
                      team_id
               FROM   nfl_game
               WHERE  nfl_game.week_seasonvalue =
                      :year
                  AND nfl_game.awayteam_abbreviation =
                      :abbreviation
                  AND ( nfl_game.week_seasontype = 'REG'
                         OR nfl_game.week_seasontype =
                            'POST'
                      )
               UNION
               SELECT nfl_game.awayteam_id AS team_id
               FROM   nfl_game
               WHERE  nfl_game.week_seasonvalue = :year
                  AND nfl_game.hometeam_abbreviation =
                      :abbreviation
                  AND ( nfl_game.week_seasontype = 'REG'
                         OR nfl_game.week_seasontype =
                            'POST'
                      )))



           )
GROUP  BY abbreviation
          ,game_id 
