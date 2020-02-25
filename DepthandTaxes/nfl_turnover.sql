SELECT nfl_game.awayteam_abbreviation                 AS awayteam_abbreviation
       ,Nvl(fumbles_away.fumbles_away, 0)             AS fumbles_away
       ,Nvl(fumbles_home.fumbles_home, 0)             AS fumbles_home
       ,nfl_game.id                                   AS game_id
       ,nfl_game.hometeam_abbreviation                AS hometeam_abbreviation
       ,Nvl(interceptions_away.interceptions_away, 0) AS interceptions_away
       ,Nvl(interceptions_home.interceptions_home, 0) AS interceptions_home
       ,nfl_game.week_weekvalue                       AS week
FROM   nfl_game
       left join (SELECT Count(nfl_game_playstats.statid) AS fumbles_away
                         ,nfl_game_playstats.id           AS
                          nfl_game_playstats_id
                         ,nfl_game_playstats.team_id      AS
                          nfl_game_playstats_team_id
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 59, 60 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) fumbles_away
              ON nfl_game.gamedetailid = fumbles_away.nfl_game_playstats_id
                 AND nfl_game.awayteam_id =
                     fumbles_away.nfl_game_playstats_team_id
       left join (SELECT Count(nfl_game_playstats.statid) AS fumbles_home
                         ,nfl_game_playstats.id           AS
                          nfl_game_playstats_id
                         ,nfl_game_playstats.team_id      AS
                          nfl_game_playstats_team_id
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid IN ( 59, 60 )
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) fumbles_home
              ON nfl_game.gamedetailid = fumbles_home.nfl_game_playstats_id
                 AND nfl_game.hometeam_id =
                     fumbles_home.nfl_game_playstats_team_id
       left join (SELECT Count(nfl_game_playstats.statid) AS interceptions_away
                         ,nfl_game_playstats.id           AS
                          nfl_game_playstats_id
                         ,nfl_game_playstats.team_id      AS
                          nfl_game_playstats_team_id
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid = 19
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) interceptions_away
              ON nfl_game.gamedetailid =
                 interceptions_away.nfl_game_playstats_id
                 AND nfl_game.awayteam_id =
                     interceptions_away.nfl_game_playstats_team_id
       left join (SELECT Count(nfl_game_playstats.statid) AS interceptions_home
                         ,nfl_game_playstats.id           AS
                          nfl_game_playstats_id
                         ,nfl_game_playstats.team_id      AS
                          nfl_game_playstats_team_id
                  FROM   nfl_game_playstats
                  WHERE  nfl_game_playstats.statid = 19
                  GROUP  BY nfl_game_playstats.id
                            ,nfl_game_playstats.team_id) interceptions_home
              ON nfl_game.gamedetailid =
                 interceptions_home.nfl_game_playstats_id
                 AND nfl_game.hometeam_id =
                     interceptions_home.nfl_game_playstats_team_id
WHERE  nfl_game.week_seasonvalue = :year
   AND ( nfl_game.week_seasontype = 'REG'
          OR nfl_game.week_seasontype = 'POST' ) 
