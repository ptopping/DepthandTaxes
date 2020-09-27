-- For 2000, DFL in Minnesota is same as Democratic
-- DNL in North Dakota is same as Democratic

-- State names can be pulled from postal codes in fec_2000_pres_general_results
-- Check that only candidates are returned in the results
-- SELECT
--     fec_2000_pres_general_results.*
-- FROM
--     fec_2000_pres_general_results
-- WHERE
--     fec_2000_pres_general_results.numofvotes != 0
--     AND fec_2000_pres_general_results.party IS NOT Null
--     AND fec_2000_pres_general_results.state != 'ZZZZ'
SELECT TRIM(fec_2016_pres_general_results.lastnamefirst)                                    AS candidatename
       ,1                                                                                   AS dempres
       ,'President'                                                                         AS district
       ,TO_DATE(fec_2016_pres_general_results.generalelectiondate, 'MM/DD/YYYY')            AS generaldate
       ,TO_NUMBER(REGEXP_REPLACE(fec_2016_pres_general_results.generalresults, '[^0-9.]+')) AS generalvotes
       ,0                                                                                   AS midterm
       ,CASE
          WHEN fec_2016_pres_general_results.lastname = 'Obama' THEN 1
          ELSE 0
        END                                                                                 AS incumbentindicator
       ,CASE
          WHEN TRIM(fec_2016_pres_general_results.party) IN ( 'DEM', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2016_pres_general_results.party) IN ( 'R', 'REP/AIP' ) THEN 'Republican'
          WHEN TRIM(fec_2016_pres_general_results.party) = 'W' THEN 'Write-In'
          ELSE 'Other'
        END                                                                                 AS partyname
       ,fec_2016_pres_general_results.stateabbreviation                                     AS postal
       ,fec_2016_pres_general_results.state                                                 AS statename
FROM   fec_2016_pres_general_results
WHERE  fec_2016_pres_general_results.totalvotes IS NULL
   AND fec_2016_pres_general_results.party != 'Combined Parties:'
UNION
SELECT TRIM(fec_2016_senate_results.candidatename)      AS candidatename
       ,1                                               AS dempres
       ,'Senate'                                        AS district
       ,TO_DATE('11/08/2016', 'MM/DD/YYYY')             AS generaldate
       ,TO_NUMBER(fec_2016_senate_results.generalvotes) AS generalvotes
       ,NVL2(fec_2016_senate_results.i, 1, 0)           AS incumbentindicator
       ,0                                               AS midterm
       ,CASE
          WHEN TRIM(fec_2016_senate_results.party) IN ( 'D', 'DNL', 'D ' ) THEN 'Democratic'
          WHEN TRIM(fec_2016_senate_results.party) IN ( 'R', 'R ' ) THEN 'Republican'
          WHEN TRIM(fec_2016_senate_results.party) IN ( 'W', 'W(GRE)/GRE' ) THEN 'Write-In'
          ELSE 'Other'
        END                                             AS partyname
       ,fec_2016_senate_results.stateabbreviation       AS postal
       ,fec_2016_senate_results.state                   AS statename
FROM   fec_2016_senate_results
WHERE  fec_2016_senate_results.generalvotes IS NOT NULL
   AND fec_2016_senate_results.totalvotes IS NULL; 
