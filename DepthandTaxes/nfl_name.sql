SELECT gsisplayer_id
       ,playername
FROM   nfl_game_playstats
WHERE  ROWID IN (SELECT MIN(ROWID)
                 FROM   nfl_game_playstats
                 GROUP  BY gsisplayer_id) 
