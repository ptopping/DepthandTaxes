SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,yards                          AS kick_return_yards_away
       ,NULL                           AS kick_return_yards_home
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS punt_return_yards_away
       ,NULL                           AS punt_return_yards_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid IN ( 45, 46, 47, 48 )
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,NULL                           AS kick_return_yards_away
       ,NULL                           AS kick_return_yards_home
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,yards                          AS punt_return_yards_away
       ,NULL                           AS punt_return_yards_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.awayteam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid IN ( 33, 34, 35, 36 )
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,NULL                           AS kick_return_yards_away
       ,yards                          AS kick_return_yards_home
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS punt_return_yards_away
       ,NULL                           AS punt_return_yards_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid IN ( 45, 46, 47, 48 )
UNION ALL
SELECT nfl_game.awayteam_abbreviation  AS awayteam_abbreviation
       ,nfl_game.hometeam_abbreviation AS hometeam_abbreviation
       ,NULL                           AS kick_return_yards_away
       ,NULL                           AS kick_return_yards_home
       ,nfl_game_playstats.id          AS nfl_game_playstats_id
       ,NULL                           AS punt_return_yards_away
       ,yards                          AS punt_return_yards_home
       ,nfl_game.week_weekvalue        AS week
FROM   nfl_game
       left join nfl_game_playstats
              ON nfl_game.gamedetailid = nfl_game_playstats.id
                 AND nfl_game.hometeam_id = nfl_game_playstats.team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' )
   AND nfl_game_playstats.statid IN ( 33, 34, 35, 36 ) 
