SELECT co_sos_elections_turnout.year                                                          AS year
       ,co_sos_elections_turnout.electiontype                                                 AS electiontype
       ,co_sos_elections_turnout.county                                                       AS county
       ,Sum(co_sos_elections_turnout.ballotscast)                                             AS ballotscast
       ,Sum(co_sos_elections_turnout.totalvoters)                                             AS totalvoters
       ,Sum(co_sos_elections_turnout.ballotscast) / Sum(co_sos_elections_turnout.totalvoters) AS turnout
FROM   co_sos_elections_turnout
GROUP  BY co_sos_elections_turnout.year
          ,co_sos_elections_turnout.electiontype
          ,co_sos_elections_turnout.county
HAVING co_sos_elections_turnout.electiontype IN ( 'G', 'General', 'O' )
       AND EXTRACT(year FROM co_sos_elections_turnout.year) = 2018
ORDER  BY co_sos_elections_turnout.county  