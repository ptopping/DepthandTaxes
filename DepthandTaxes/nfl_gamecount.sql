SELECT abbreviation AS abbreviation
       ,COUNT(id)   AS games
FROM   (SELECT nfl_game.awayteam_abbreviation AS abbreviation
               ,nfl_game.id                   AS id
        FROM   nfl_game
        WHERE  nfl_game.week_seasonvalue = :year
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' )
        UNION ALL
        SELECT nfl_game.hometeam_abbreviation AS abbreviation
               ,nfl_game.id                   AS id
        FROM   nfl_game
        WHERE  nfl_game.week_seasonvalue = :year
           AND ( nfl_game.week_seasontype = 'REG'
                  OR nfl_game.week_seasontype = 'POST' ))
GROUP  BY abbreviation
 