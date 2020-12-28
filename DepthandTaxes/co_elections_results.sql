SELECT co_sos_elections_results.county                AS county
       ,co_sos_elections_results.officeissuejudgeship AS officeissuejudgeship
       ,CASE
          WHEN co_sos_elections_results.party IN (
               'Democratic Party', 'Democratic', 'DEM',
               'Democrat' ) THEN 'Democratic'
          WHEN co_sos_elections_results.party IN (
               'Republican Party', 'Republican', 'REP' ) THEN 'Republican'
          ELSE 'Minor'
        END                                           AS party
       ,SUM(co_sos_elections_results.votes)           AS votes
       ,co_sos_elections_results.year                 AS year
FROM   co_sos_elections_results
WHERE  co_sos_elections_results.electiontype IN ( 'G', 'General', 'O' )
       AND co_sos_elections_results.officeissuejudgeship IN
           (
               'ATTORNEY GENERAL', 'Attorney General', 'Cong. District 1',
               'Cong. District 2',
               'Cong. District 3',
               'Cong. District 4', 'Cong. District 5',
               'Cong. District 6',
               'Cong. District 7',
               'GOVERNOR/LIEUTENANT GOVERNOR', 'Gov./Lieutenant Gov.',
               'Governor'
                                                                ,
               'Governor/Lieutenant Governor',
                 'PRESIDENTIAL ELECTORS/ PRESIDENTIAL ELECTORS (VICE)',
                 'President/Vice President', 'Presidential Electors',
               'REGENT OF THE UNIVERSITY OF COLORADO - AT LARGE',
       'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 1',
       'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 2',
       'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 3',
'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 4',
  'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 5',
  'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 6',
  'REPRESENTATIVE TO THE 111th UNITED STATES CONGRESS - DISTRICT 7',
'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 1',
  'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 2',
  'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 3',
  'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 4',
'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 5',
  'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 6',
  'REPRESENTATIVE TO THE 112th UNITED STATES CONGRESS - DISTRICT 7',
  'Regent Of The University Of Colorado - At Large',
'SECRETARY OF STATE', 'STATE TREASURER', 'Secretary of State',
  'State Treasurer',
'Treasurer', 'U of C Regent - At Large', 'U of C Regents - At Large',
  'UNITED STATES SENATOR',
'US Senator', 'United States Representative - District 1',
  'United States Representative - District 2',
  'United States Representative - District 3',
'United States Representative - District 4',
  'United States Representative - District 5',
  'United States Representative - District 6',
  'United States Representative - District 7', 'United States Senator'
)
AND co_sos_elections_results.party IS NOT NULL
GROUP  BY co_sos_elections_results.county
          ,co_sos_elections_results.officeissuejudgeship
          ,co_sos_elections_results.year
          ,co_sos_elections_results.party