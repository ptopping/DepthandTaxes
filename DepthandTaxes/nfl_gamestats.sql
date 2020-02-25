SELECT nfl_game.id                            AS game_id
       ,nfl_game.awayteam_abbreviation        AS awayteam_abbreviation
       ,nfl_game.hometeam_abbreviation        AS hometeam_abbreviation
       ,passing_yards_away.passing_yards_away AS passing_yards_away
       ,passing_yards_home.passing_yards_home AS passing_yards_home
       ,rushing_yards_away.rushing_yards_away AS rushing_yards_away
       ,rushing_yards_home.rushing_yards_home AS rushing_yards_home
       ,nfl_game.week_weekvalue               AS week
FROM   nfl_game
       left join (SELECT nfl_game_playstats.id          AS nfl_game_playstats_id
                         ,nfl_game_playstats.team_id    AS
                          nfl_game_playstats_team_id
                         ,SUM(nfl_game_playstats.yards) AS passing_yards_away
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 15, 16, 20 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) passing_yards_away
              ON nfl_game.gamedetailid =
                 passing_yards_away.nfl_game_playstats_id
                 AND nfl_game.awayteam_id =
                     passing_yards_away.nfl_game_playstats_team_id
       left join (SELECT nfl_game_playstats.id          AS nfl_game_playstats_id
                         ,nfl_game_playstats.team_id    AS
                          nfl_game_playstats_team_id
                         ,SUM(nfl_game_playstats.yards) AS passing_yards_home
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 15, 16, 20 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) passing_yards_home
              ON nfl_game.gamedetailid =
                 passing_yards_home.nfl_game_playstats_id
                 AND nfl_game.hometeam_id =
                     passing_yards_home.nfl_game_playstats_team_id
       left join (SELECT nfl_game_playstats.id          AS nfl_game_playstats_id
                         ,nfl_game_playstats.team_id    AS
                          nfl_game_playstats_team_id
                         ,SUM(nfl_game_playstats.yards) AS rushing_yards_away
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) rushing_yards_away
              ON nfl_game.gamedetailid =
                 rushing_yards_away.nfl_game_playstats_id
                 AND nfl_game.awayteam_id =
                     rushing_yards_away.nfl_game_playstats_team_id
       left join (SELECT nfl_game_playstats.id          AS nfl_game_playstats_id
                         ,nfl_game_playstats.team_id    AS
                          nfl_game_playstats_team_id
                         ,SUM(nfl_game_playstats.yards) AS rushing_yards_home
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 10, 11, 12, 13 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) rushing_yards_home
              ON nfl_game.gamedetailid =
                 rushing_yards_home.nfl_game_playstats_id
                 AND nfl_game.hometeam_id =
                     rushing_yards_home.nfl_game_playstats_team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' ) 
