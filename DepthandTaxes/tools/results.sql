SELECT
    results.statename,
    results.district,
    results.electionyear,
    SUM(results.generalvotes) generalvotes,
    results.party,
    COUNT(results.generalvotes) gecancount
FROM
    (
        SELECT
            fecresults.statename,
            fecresults.district,
            EXTRACT(YEAR FROM fecresults.generalelectiondate) electionyear,
            fecresults.generalvotes,
            CASE
                WHEN fecresults.party NOT IN (
                    'Democratic',
                    'Republican'
                ) THEN 'Other'
                ELSE fecresults.party
            END party
        FROM
            fecresults
        WHERE
            fecresults.party IS NOT NULL
    ) results
GROUP BY
    results.statename,
    results.district,
    results.electionyear,
    results.party