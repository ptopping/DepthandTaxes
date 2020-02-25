SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,1                              AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,0                              AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 6
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,0                              AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,1                              AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 7
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,1                              AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,0                              AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 8
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,0                              AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,1                              AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 9
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,1                              AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,0                              AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 6
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,NULL                           AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,NULL                           AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,0                              AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,1                              AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 7
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,1                              AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,0                              AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 8
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,NULL                           AS fourth_down_converted_away
       ,0                              AS fourth_down_converted_home
       ,NULL                           AS fourth_down_failed_away
       ,1                              AS fourth_down_failed_home
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS third_down_converted_away
       ,NULL                           AS third_down_converted_home
       ,NULL                           AS third_down_failed_away
       ,NULL                           AS third_down_failed_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid = 9 
