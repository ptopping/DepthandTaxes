SELECT nfl_game_playstats.team_abbreviation AS abbreviation
       ,CASE
          WHEN TRIM(REGEXP_SUBSTR(nfl_game_plays.yardline, '\D+')) =
               nfl_game_playstats.team_abbreviation THEN 100 -
          TO_NUMBER(REGEXP_SUBSTR(
        nfl_game_plays.yardline, '\d+'))
          ELSE TO_NUMBER(REGEXP_SUBSTR(nfl_game_plays.yardline, '\d+'))
        END                                 AS distance
       ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
       ,nfl_game_playstats.id               AS id
       ,nfl_game_playstats.playid           AS playid
       ,nfl_game_playstats.playername       AS playername
       ,nfl_game_playstats.yards            AS puntyards
       ,CASE
          WHEN nfl_game_playstats.statid = 32 THEN 20
          ELSE NVL(returns.returnyards, 0)
        END                                 AS returnyards
       ,nfl_game.week_seasonvalue           AS season
       ,nfl_game.week_seasontype            AS seasontype
       ,nfl_game_playstats.team_id          AS team_id
       ,nfl_game.week_weekvalue             AS week
FROM   nfl_game_playstats
       left join nfl_game_plays
              ON nfl_game_playstats.id = nfl_game_plays.id
                 AND nfl_game_playstats.playid = nfl_game_plays.playid
       left join (SELECT nfl_game_playstats.team_abbreviation AS abbreviation
                         ,nfl_game_playstats.gsisplayer_id    AS gsisplayer_id
                         ,nfl_game_playstats.id               AS id
                         ,nfl_game_playstats.playid           AS playid
                         ,nfl_game_playstats.playername       AS playername
                         ,nfl_game_playstats.team_id          AS team_id
                         ,nfl_game_playstats.yards            AS returnyards
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 33, 34, 35, 36 ))
                 returns
              ON nfl_game_playstats.id = returns.id
                 AND nfl_game_playstats.playid = returns.playid
       left join nfl_game
              ON nfl_game_playstats.id = nfl_game.gamedetailid
WHERE  nfl_game_playstats.statid IN ( 29, 31, 32 )
   AND nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' ) 
