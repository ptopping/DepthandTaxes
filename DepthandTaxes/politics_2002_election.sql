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

WITH states
     AS (SELECT TRIM(fec_2000_pres_general_results.state)               AS postal
                ,INITCAP(TRIM(fec_2000_pres_general_results.candidate)) AS statename
         FROM   fec_2000_pres_general_results
         WHERE  fec_2000_pres_general_results.party IS NULL
            AND fec_2000_pres_general_results.numofvotes = 0)
SELECT TRIM(fec_2002_congress_results.lastnamefirst)                                    AS candidatename
       ,0                                                                               AS dempres
       ,'Senate'                                                                        AS district
       ,TO_DATE('05-NOV-02')                                                            AS generaldate
       ,TO_NUMBER(REGEXP_REPLACE(fec_2002_congress_results.generalresults, '[^0-9.]+')) AS generalvotes
       ,NVL2(fec_2002_congress_results.incumbentindicator, 1, 0)                        AS incumbentindicator
       ,1                                                                               AS midterm
       ,CASE
          WHEN TRIM(fec_2002_congress_results.party) IN ( 'D', 'DFL' ) THEN 'Democratic'
          WHEN TRIM(fec_2002_congress_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2002_congress_results.party) IN ( 'DFL/W', 'GRN/W', 'R/W', 'W' ) THEN 'Write-In'
          ELSE 'Other'
        END                                                                             AS partyname
       ,fec_2002_congress_results.state                                                 AS postal
       ,states.statename                                                                AS statename
FROM   fec_2002_congress_results
       left join states
              ON TRIM(fec_2002_congress_results.state) = states.postal
WHERE  fec_2002_congress_results.totalvotes IS NULL
   AND fec_2002_congress_results.district = 'S'
   AND TO_NUMBER(REGEXP_REPLACE(fec_2002_congress_results.generalresults, '[^0-9.]+')) > 0; 
