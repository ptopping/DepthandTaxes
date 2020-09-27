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

-- candidatename
-- dempres
-- district
-- generaldate
-- generalvotes
-- gerunoffelectionvotesla
-- incumbentindicator
-- partyname
-- postal
-- presyear
-- statename
-- writeinindicator

-- [^0-9.]+


WITH states
     AS (SELECT TRIM(fec_2000_pres_general_results.state)               AS postal
                ,INITCAP(TRIM(fec_2000_pres_general_results.candidate)) AS statename
         FROM   fec_2000_pres_general_results
         WHERE  fec_2000_pres_general_results.party IS NULL
            AND fec_2000_pres_general_results.numofvotes = 0) 
SELECT TRIM(fec_2000_pres_general_results.candidate) AS candidatename
       ,1                                            AS dempres
       ,'President'                                  AS district
       ,TO_DATE('07-NOV-00')                         AS generaldate
       ,fec_2000_pres_general_results.numofvotes     AS generalvotes
       ,0                                            AS incumbentindicator
       ,0                                            AS midterm
       ,CASE
          WHEN TRIM(fec_2000_pres_general_results.party) IN ( 'D', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2000_pres_general_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2000_pres_general_results.party) = 'W' THEN 'Write-In'
          ELSE 'Other'
        END                                          AS partyname
       ,TRIM(fec_2000_pres_general_results.state)    AS postal
       ,states.statename                             AS statename
FROM   fec_2000_pres_general_results
       left join states
              ON TRIM(fec_2000_pres_general_results.state) = states.postal
WHERE  fec_2000_pres_general_results.party IS NOT NULL
UNION
SELECT TRIM(fec_2000_senate_results.name)                      AS candidatename
       ,1                                                      AS dempres
       ,'Senate'                                               AS district
       ,TO_DATE('07-NOV-00')                                   AS generaldate
       ,TO_NUMBER(fec_2000_senate_results.generalresults)      AS generalvotes
       ,NVL2(fec_2000_senate_results.incumbentindicator, 1, 0) AS incumbentindicator
       ,0                                                      AS midterm
       ,CASE
          WHEN TRIM(fec_2000_senate_results.party) IN ( 'D', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2000_senate_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2000_senate_results.party) IN ( 'W', 'W(GRN)' ) THEN 'Write-In'
          ELSE 'Other'
        END                                                    AS partyname
       ,fec_2000_senate_results.state                          AS postal
       ,states.statename                                       AS statename
FROM   fec_2000_senate_results
       left join states
              ON fec_2000_senate_results.state = states.postal
WHERE  fec_2000_senate_results.party IS NOT NULL
   AND fec_2000_senate_results.party != 'Combined'
   AND fec_2000_senate_results.generalresults > 0; 
