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

SELECT TRIM(fec_2006_congress_results.lastnamefirst)             AS candidatename
       ,0                                                        AS dempres
       ,'Senate'                                                 AS district
       ,TO_DATE('11/07/2006', 'MM/DD/YYYY')                      AS generaldate
       ,TO_NUMBER(fec_2006_congress_results.general)             AS generalvotes
       ,NVL2(fec_2006_congress_results.incumbentindicator, 1, 0) AS incumbentindicator
       ,1                                                        AS midterm
       ,CASE
          WHEN TRIM(fec_2006_congress_results.party) IN ( 'DEM', 'DEM/CFL*', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2006_congress_results.party) IN ( 'R', 'REP/IND' ) THEN 'Republican'
          WHEN TRIM(fec_2006_congress_results.party) IN ( 'DEM/W', 'GRE/W', 'REP/W', 'W' ) THEN 'Write-In'
          ELSE 'Other'
        END                                                      AS partyname
       ,fec_2006_congress_results.stateabbreviation              AS postal
       ,fec_2006_congress_results.state                          AS statename
FROM   fec_2006_congress_results
WHERE  TRIM(fec_2006_congress_results.district) = 'S'
   AND fec_2006_congress_results.general IS NOT NULL
   AND fec_2006_congress_results.totalvotes IS NULL
