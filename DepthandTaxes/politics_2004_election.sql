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

SELECT TRIM(fec_2004_pres_general_results.lastnamefirst)                                    AS candidatename
       ,0                                                                                   AS dempres
       ,'President'                                                                         AS district
       ,TO_DATE(fec_2004_pres_general_results.generalelectiondate, 'MM/DD/YYYY')            AS generaldate
       ,TO_NUMBER(REGEXP_REPLACE(fec_2004_pres_general_results.generalresults, '[^0-9.]+')) AS generalvotes
       ,CASE
          WHEN TRIM(fec_2004_pres_general_results.lastnamefirst) IN ( 'Bush, George', 'Bush, George W.', 'Bush, George Walker' ) THEN 1
          ELSE 0
        END                                                                                 AS incumbentindicator
       ,0                                                                                   AS midterm
       ,CASE
          WHEN TRIM(fec_2004_pres_general_results.party) IN ( 'D', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2004_pres_general_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2004_pres_general_results.party) = 'W' THEN 'Write-In'
          ELSE 'Other'
        END                                                                                 AS partyname
       ,fec_2004_pres_general_results.stateabbreviation                                     AS postal
       ,fec_2004_pres_general_results.state                                                 AS statename
FROM   fec_2004_pres_general_results
WHERE  fec_2004_pres_general_results.party IS NOT NULL
UNION
SELECT TRIM(fec_2004_congress_results.lastnamefirst)             AS candidatename
       ,0                                                        AS dempres
       ,'Senate'                                                 AS district
       ,TO_DATE('11/02/2004', 'MM/DD/YYYY')                      AS generaldate
       ,TO_NUMBER(fec_2004_congress_results.general)             AS generalvotes
       ,NVL2(fec_2004_congress_results.incumbentindicator, 1, 0) AS incumbentindicator
       ,0                                                        AS midterm
       ,CASE
          WHEN TRIM(fec_2004_congress_results.party) IN ( 'D', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2004_congress_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2004_congress_results.party) IN ( 'D/W', 'R/W', 'W', 'W(D)' ) THEN 'Write-In'
          ELSE 'Other'
        END                                                      AS partyname
       ,fec_2004_congress_results.stateabbreviation              AS postal
       ,fec_2004_congress_results.state                          AS statename
FROM   fec_2004_congress_results
WHERE  TRIM(fec_2004_congress_results.district) = 'S'
   AND fec_2004_congress_results.totalvotes IS NULL
   AND fec_2004_congress_results.party IS NOT NULL
   AND fec_2004_congress_results.general IS NOT NULL
