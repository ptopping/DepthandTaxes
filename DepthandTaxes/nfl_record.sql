SELECT CASE
         WHEN nfl_game_details.homepointstotal <
              nfl_game_details.visitorpointstotal
       THEN 1
         ELSE 0
       END                                        AS losses
       ,nfl_game_details.visitorteam_abbreviation AS opponent
       ,nfl_game.week_seasonvalue                 AS season
       ,nfl_game.week_seasontype                  AS seasontype
       ,nfl_game_details.hometeam_abbreviation    AS team
       ,CASE
          WHEN nfl_game_details.homepointstotal =
               nfl_game_details.visitorpointstotal
        THEN 1
          ELSE 0
        END                                       AS ties
       ,nfl_game.week_weekvalue                   AS week
       ,CASE
          WHEN nfl_game_details.homepointstotal >
               nfl_game_details.visitorpointstotal
        THEN 1
          ELSE 0
        END                                       AS wins
FROM   nfl_game
       left join nfl_game_details
              ON nfl_game.gamedetailid = nfl_game_details.id
WHERE  nfl_game.week_seasontype = 'REG'
    OR nfl_game.week_seasontype = 'POST'
UNION
SELECT CASE
         WHEN nfl_game_details.visitorpointstotal <
              nfl_game_details.homepointstotal
       THEN 1
         ELSE 0
       END                                        AS losses
       ,nfl_game_details.hometeam_abbreviation    AS opponent
       ,nfl_game.week_seasonvalue                 AS season
       ,nfl_game.week_seasontype                  AS seasontype
       ,nfl_game_details.visitorteam_abbreviation AS team
       ,CASE
          WHEN nfl_game_details.homepointstotal =
               nfl_game_details.visitorpointstotal
        THEN 1
          ELSE 0
        END                                       AS ties
       ,nfl_game.week_weekvalue                   AS week
       ,CASE
          WHEN nfl_game_details.visitorpointstotal >
               nfl_game_details.homepointstotal
        THEN 1
          ELSE 0
        END                                       AS wins
FROM   nfl_game
       left join nfl_game_details
              ON nfl_game.gamedetailid = nfl_game_details.id
WHERE  nfl_game.week_seasontype = 'REG'
    OR nfl_game.week_seasontype = 'POST' 
