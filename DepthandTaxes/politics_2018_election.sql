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

SELECT TRIM(fec_2018_senate_results.candidate_name)      AS candidatename
       ,0                                                AS dempres
       ,'Senate'                                         AS district
       ,TO_DATE('11/06/2018', 'MM/DD/YYYY')              AS generaldate
       ,TO_NUMBER(fec_2018_senate_results.general_votes) AS generalvotes
       ,NVL2(fec_2018_senate_results.i, 1, 0)            AS incumbentindicator
       ,1                                                AS midterm
       ,CASE
          WHEN TRIM(fec_2018_senate_results.party) IN ( 'D', 'DFL', 'DNL' ) THEN 'Democratic'
          WHEN TRIM(fec_2018_senate_results.party) = 'R' THEN 'Republican'
          WHEN TRIM(fec_2018_senate_results.party) IN ( 'W', 'W(GRE)/GRE', 'W(LIB)/W' ) THEN 'Write-In'
          ELSE 'Other'
        END                                              AS partyname
       ,fec_2018_senate_results.state_abbreviation       AS postal
       ,fec_2018_senate_results.state                    AS statename
FROM   fec_2018_senate_results
WHERE  fec_2018_senate_results.general_votes IS NOT NULL
   AND fec_2018_senate_results.total_votes IS NULL; 

