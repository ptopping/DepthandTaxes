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

SELECT TRIM(fec_2014_senate_results.candidatename)      AS candidatename
       ,1                                               AS dempres
       ,'Senate'                                        AS district
       ,TO_DATE('11/04/2014', 'MM/DD/YYYY')             AS generaldate
       ,TO_NUMBER(fec_2014_senate_results.generalvotes) AS generalvotes
       ,NVL2(fec_2014_senate_results.i, 1, 0)           AS incumbentindicator
       ,1                                               AS midterm
       ,CASE
          WHEN TRIM(fec_2014_senate_results.party) IN ( 'D', 'DEM/IP/PRO/WF', 'DFL' ) THEN 'Democratic'
          WHEN TRIM(fec_2014_senate_results.party) IN ( 'R', 'R ' ) THEN 'Republican'
          WHEN TRIM(fec_2014_senate_results.party) IN ( 'R/W', 'W' ) THEN 'Write-In'
          ELSE 'Other'
        END                                             AS partyname
       ,fec_2014_senate_results.stateabbreviation       AS postal
       ,fec_2014_senate_results.state                   AS statename
FROM   fec_2014_senate_results
WHERE  TO_NUMBER(REGEXP_REPLACE(fec_2014_senate_results.generalvotes, '[^0-9.]+')) > 0
   AND fec_2014_senate_results.totalvotes IS NULL