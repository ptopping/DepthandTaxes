SELECT   co_sos_elections_results.county               AS county ,
         co_sos_elections_results.officeissuejudgeship AS officeissuejudgeship ,
         CASE
                  WHEN co_sos_elections_results.party IN ( 'Democratic Party',
                                                          'Democratic',
                                                          'DEM',
                                                          'Democrat' ) THEN 'Democratic'
                  WHEN co_sos_elections_results.party IN ( 'Republican Party',
                                                          'Republican',
                                                          'REP' ) THEN 'Republican'
                  ELSE 'Minor'
         END                                 AS party ,
         Sum(co_sos_elections_results.votes) AS votes ,
         co_sos_elections_results.year       AS year
FROM     co_sos_elections_results
WHERE    co_sos_elections_results.electiontype IN ( 'G',
                                                   'General',
                                                   'O' )
AND      co_sos_elections_results.officeissuejudgeship IN ( 'Attorney General',
                                                           'GOVERNOR/LIEUTENANT GOVERNOR',
                                                           'Gov./Lieutenant Gov.',
                                                           'Governor',
                                                           'PRESIDENTIAL ELECTORS/ PRESIDENTIAL ELECTORS (VICE)',
                                                           'President/Vice President',
                                                           'Presidential Electors',
                                                           'REGENT OF THE UNIVERSITY OF COLORADO - AT LARGE' ,
                                                           'Regent Of The University Of Colorado - At Large',
                                                           'SECRETARY OF STATE',
                                                           'STATE TREASURER',
                                                           'Secretary of State',
                                                           'State Treasurer',
                                                           'Supreme Court: Nathan B. Coats',
                                                           'Treasurer',
                                                           'U of C Regent - At Large',
                                                           'U of C Regents - At Large',
                                                           'UNITED STATES SENATOR',
                                                           'US Senator',
                                                           'United States Senator' )
AND      co_sos_elections_results.party IS NOT NULL
GROUP BY co_sos_elections_results.county ,
         co_sos_elections_results.officeissuejudgeship ,
         co_sos_elections_results.year ,
         co_sos_elections_results.party 