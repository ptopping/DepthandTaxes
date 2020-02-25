SELECT abbreviation        AS abbreviation
       ,SUM(fumbles)       AS fumbles
       ,gsisplayer_id      AS gsisplayer_id
       ,SUM(interceptions) AS interceptions
       ,opponent           AS opponent
       ,playername         AS playername
       ,SUM(receptions)    AS receptions
       ,season             AS season
       ,seasontype         AS seasontype
       ,SUM(targets)       AS targets
       ,SUM(touchdowns)    AS touchdowns
       ,week               AS week
       ,SUM(yards)         AS yards
FROM   (SELECT nfl_game_playstats.team_abbreviation AS abbreviation
               ,NVL(fumbles, 0)                     AS fumbles
               ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
               ,NVL(interceptions, 0)               AS interceptions
               ,CASE
                  WHEN nfl_game_playstats.team_id = nfl_game.awayteam_id THEN
                  nfl_game.hometeam_abbreviation
                  ELSE nfl_game.awayteam_abbreviation
                END                                 AS opponent
               ,nfl_game_playstats.playername       AS playername
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 21, 22 ) THEN 1
                  ELSE 0
                END                                 AS receptions
               ,nfl_game.week_seasonvalue           AS season
               ,nfl_game.week_seasontype            AS seasontype
               ,CASE
                  WHEN nfl_game_playstats.statid = 115 THEN 1
                  ELSE 0
                END                                 AS targets
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 22, 24 ) THEN 1
                  ELSE 0
                END                                 AS touchdowns
               ,nfl_game.week_weekvalue             AS week
               ,nfl_game_playstats.yards            AS yards
        FROM   nfl_game_playstats
               left join nfl_game
                      ON nfl_game_playstats.id = nfl_game.gamedetailid
               left join (SELECT p.gsisplayer_id AS gsisplayer_id
                                 ,p.id           AS id
                                 ,p.playid       AS playid
                                 ,1              AS fumbles
                          FROM   nfl_game_playstats p
                                 ,nfl_game_playstats s
                          WHERE  p.statid IN ( 52, 53 )
                             AND s.statid IN ( 21, 22 )
                             AND p.id = s.id
                             AND p.playid = s.playid
                             AND p.gsisplayer_id = s.gsisplayer_id) fumbles
                      ON nfl_game_playstats.gsisplayer_id =
                         fumbles.gsisplayer_id
                         AND nfl_game_playstats.id = fumbles.id
                         AND nfl_game_playstats.playid = fumbles.playid
               left join (SELECT p.gsisplayer_id AS gsisplayer_id
                                 ,p.id           AS id
                                 ,p.playid       AS playid
                                 ,1              AS interceptions
                          FROM   nfl_game_playstats p
                                 ,nfl_game_playstats s
                          WHERE  p.statid = 115
                             AND s.statid = 19
                             AND p.id = s.id
                             AND p.playid = s.playid) interceptions
                      ON nfl_game_playstats.gsisplayer_id =
                         interceptions.gsisplayer_id
                         AND nfl_game_playstats.id = interceptions.id
                         AND nfl_game_playstats.playid = interceptions.playid
        WHERE  nfl_game_playstats.statid IN ( 21, 22, 23, 24, 115 )
           AND nfl_game.week_seasonvalue = :year
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' ))
GROUP  BY abbreviation
          ,gsisplayer_id
          ,opponent
          ,playername
          ,season
          ,seasontype
          ,week 
