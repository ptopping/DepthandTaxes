SELECT nfl_game_playstats.team_abbreviation AS abbreviation
       ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
       ,nfl_game_playstats.id               AS id
       ,CASE
          WHEN nfl_game_playstats.statid IN ( 70, 72 ) THEN 1
          ELSE 0
        END                                 AS made
       ,CASE
          WHEN nfl_game_playstats.statid IN ( 69, 71, 73, 74 ) THEN 1
          ELSE 0
        END                                 AS missed
       ,nfl_game_playstats.playid           AS playid
       ,nfl_game_playstats.playername       AS playername
       ,nfl_game.week_seasonvalue           AS season
       ,nfl_game.week_seasontype            AS seasontype
       ,nfl_game_playstats.team_id          AS team_id
       ,nfl_game.week_weekvalue             AS week
       ,CASE
          WHEN nfl_game_playstats.yards = 0 THEN
          TO_NUMBER(REGEXP_SUBSTR(nfl_game_plays.yardline, '\d+' ))
          + 18
          ELSE nfl_game_playstats.yards
        END                                 AS yards
FROM   nfl_game_playstats
       left join nfl_game_plays
              ON nfl_game_playstats.id = nfl_game_plays.id
                 AND nfl_game_playstats.playid = nfl_game_plays.playid
                 AND nfl_game_playstats.team_abbreviation =
                     nfl_game_plays.possessionteam_abbreviation
       left join nfl_game
              ON nfl_game_playstats.id = nfl_game.gamedetailid
WHERE  nfl_game_playstats.statid IN ( 69, 70, 71, 72,
                                      73, 74 )
   AND nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' ) 
