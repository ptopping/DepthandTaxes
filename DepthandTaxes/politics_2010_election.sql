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

SELECT TRIM(fec_2010_congress_results.candidatenamelastfirst)    AS candidatename
       ,1                                                        AS dempres
       ,'Senate'                                                 AS district
       ,TO_DATE('11/02/2010', 'MM/DD/YYYY')                      AS generaldate
       ,TO_NUMBER(fec_2010_congress_results.general)             AS generalvotes
       ,NVL2(fec_2010_congress_results.incumbentindicator, 1, 0) AS incumbentindicator
       ,1                                                        AS midterm
       ,CASE
          WHEN TRIM(fec_2010_congress_results.party) IN ( 'DEM', 'DEM/IND', 'DEM ', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2010_congress_results.party) IN ( 'REP', 'REP ' ) THEN 'Republican'
          WHEN TRIM(fec_2010_congress_results.party) IN ( 'DEM/W', 'REP/W***', 'W', 'W (Challenged Counted)', 'W(REP)/W' ) THEN 'Write-In'
          ELSE 'Other'
        END                                                      AS partyname
       ,fec_2010_congress_results.stateabbreviation              AS postal
       ,fec_2010_congress_results.state                          AS statename
FROM   fec_2010_congress_results
WHERE  fec_2010_congress_results.district LIKE '%S%'
   AND fec_2010_congress_results.general IS NOT NULL
   AND fec_2010_congress_results.totalvotes IS NULL

