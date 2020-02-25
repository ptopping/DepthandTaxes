SELECT abbreviation             AS abbreviation
       ,SUM(attempts)           AS attempts
       ,SUM(attempts_inc_sacks) AS attempts_inc_sacks
       ,SUM(completions)        AS completions
       ,gsisplayer_id           AS gsisplayer_id
       ,SUM(interceptions)      AS interceptions
       ,opponent                AS opponent
       ,playername              AS playername
       ,season                  AS season
       ,SUM(sacks)              AS sacks
       ,SUM(sackyards)          AS sackyards
       ,seasontype              AS seasontype
       ,SUM(touchdowns)         AS touchdowns
       ,week                    AS week
       ,SUM(yards)              AS yards
FROM  (SELECT nfl_game_playstats.team_abbreviation AS abbreviation
              ,CASE
                 WHEN nfl_game_playstats.statid IN ( 14, 15, 16, 19 ) THEN 1
                 ELSE 0
               END                                 AS attempts
              ,1                                   AS attempts_inc_sacks
              ,CASE
                 WHEN nfl_game_playstats.statid IN ( 15, 16 ) THEN 1
                 ELSE 0
               END                                 AS completions
              ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
              ,CASE
                 WHEN nfl_game_playstats.statid = 19 THEN 1
                 ELSE 0
               END                                 AS interceptions
              ,CASE
                 WHEN nfl_game_playstats.team_id = nfl_game.awayteam_id THEN
                 nfl_game.hometeam_abbreviation
                 ELSE nfl_game.awayteam_abbreviation
               END                                 AS opponent
              ,nfl_game_playstats.playername       AS playername
              ,nfl_game.week_seasonvalue           AS season
              ,CASE
                 WHEN nfl_game_playstats.statid = 20 THEN 1
                 ELSE 0
               END                                 AS sacks
              ,CASE
                 WHEN nfl_game_playstats.statid = 20 THEN
                 nfl_game_playstats.yards
                 ELSE 0
               END                                 AS sackyards
              ,nfl_game.week_seasontype            AS seasontype
              ,CASE
                 WHEN nfl_game_playstats.statid = 16 THEN 1
                 ELSE 0
               END                                 AS touchdowns
              ,nfl_game.week_weekvalue             AS week
              ,CASE
                 WHEN nfl_game_playstats.statid IN ( 14, 15, 16, 19 ) THEN
                 nfl_game_playstats.yards
                 ELSE 0
               END                                 AS yards
       FROM   nfl_game_playstats
              left join nfl_game
                     ON nfl_game_playstats.id = nfl_game.gamedetailid
       WHERE  nfl_game_playstats.statid IN ( 14, 15, 16, 19, 20 )
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
