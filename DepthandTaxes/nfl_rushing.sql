SELECT abbreviation     AS abbreviation
       ,SUM(attempts)   AS attempts
       ,SUM(fumbles)    AS fumbles
       ,gsisplayer_id   AS gsisplayer_id
       ,opponent        AS opponent
       ,playername      AS playername
       ,season          AS season
       ,seasontype      AS seasontype
       ,SUM(touchdowns) AS touchdowns
       ,week            AS week
       ,SUM(yards)      AS yards
FROM   (SELECT nfl_game_playstats.team_abbreviation AS abbreviation
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 10, 11 ) THEN 1
                  ELSE 0
                END                                 AS attempts
               ,NVL(fumbles, 0)                     AS fumbles
               ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
               ,CASE
                  WHEN nfl_game_playstats.team_id = nfl_game.awayteam_id THEN
                  nfl_game.hometeam_abbreviation
                  ELSE nfl_game.awayteam_abbreviation
                END                                 AS opponent
               ,nfl_game_playstats.playername       AS playername
               ,nfl_game.week_seasonvalue           AS season
               ,nfl_game.week_seasontype            AS seasontype
               ,CASE
                  WHEN nfl_game_playstats.statid IN ( 11, 13 ) THEN 1
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
                             AND s.statid IN ( 10, 11 )
                             AND p.id = s.id
                             AND p.playid = s.playid
                             AND p.gsisplayer_id = s.gsisplayer_id) fumbles
                      ON nfl_game_playstats.gsisplayer_id =
                         fumbles.gsisplayer_id
                         AND nfl_game_playstats.id = fumbles.id
                         AND nfl_game_playstats.playid = fumbles.playid
        WHERE  nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
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
