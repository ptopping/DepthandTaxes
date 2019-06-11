WITH pg2000 AS (
    SELECT
        presgeneral2000.statename   postal,
        regexp_substr(presgeneral2000.candidate, '[^,]+', 1, 2) candidatenamefirst,
        regexp_substr(presgeneral2000.candidate, '[^,]+', 1, 1) candidatenamelast,
        presgeneral2000.candidate   candidatename,
        CASE
            WHEN presgeneral2000.party = 'I (GRN)' THEN 'GRN'
            WHEN presgeneral2000.party = 'I (LBT)' THEN 'LBT'
            WHEN presgeneral2000.party = 'I (SWP)' THEN 'SWP'
            WHEN presgeneral2000.party = 'I (CON)' THEN 'CON'
            WHEN presgeneral2000.party = 'I (REF)' THEN 'REF'
            WHEN presgeneral2000.party = 'PRO/GRN' THEN 'GRN'
            WHEN presgeneral2000.party = 'I (SOC)' THEN 'SOC'
            WHEN presgeneral2000.party = 'I (I)'   THEN 'I'
            ELSE replace(presgeneral2000.party, ' ', '')
        END party,
        SUM(regexp_replace(presgeneral2000.numberofvotes, '\D+')) generalvotes,
        CASE
            WHEN presgeneral2000.party = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2000
    WHERE
        presgeneral2000.statename != 'ZZZZ'
        AND presgeneral2000.numberofvotes != 0
    GROUP BY
        presgeneral2000.statename,
        presgeneral2000.candidate,
        presgeneral2000.party
), pp2000 AS (
    SELECT
        presprimary2000.statename   postal,
        regexp_substr(presprimary2000.candidate, '[^,]+', 1, 2) candidatenamefirst,
        regexp_substr(presprimary2000.candidate, '[^,]+', 1, 1) candidatenamelast,
        presprimary2000.candidate   candidatename,
        CASE
            WHEN presprimary2000.party = 'UN(R)'  THEN 'R'
            WHEN presprimary2000.party = 'W(R)'   THEN 'R'
            WHEN presprimary2000.party = 'UN(D)'  THEN 'D'
            WHEN presprimary2000.party = 'W(D)'   THEN 'D'
            WHEN presprimary2000.party = 'W(N)'   THEN 'N'
            WHEN presprimary2000.party = 'W(GRN)' THEN 'GRN'
            WHEN presprimary2000.party = 'W(REF)' THEN 'REF'
            ELSE replace(presprimary2000.party, ' ', '')
        END party,
        SUM(regexp_replace(presprimary2000.numberofvotes, '\D+')) primaryvotes,
        CASE
            WHEN presprimary2000.party IN (
                'W',
                'W(R)',
                'W(D)',
                'W(N)',
                'W(GRN)',
                'W(REF)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        presprimary2000
    WHERE
        presprimary2000.percent IS NOT NULL
    GROUP BY
        presprimary2000.statename,
        presprimary2000.candidate,
        presprimary2000.party
), pga_state2000 AS (
    SELECT
        pg2000.postal,
        SUM(pg2000.generalvotes) generalvotes
    FROM
        pg2000
    GROUP BY
        pg2000.postal
), pga_name2000 AS (
    SELECT
        pg2000.postal,
        pg2000.candidatename,
        SUM(pg2000.generalvotes) generalvotes
    FROM
        pg2000
    GROUP BY
        pg2000.postal,
        pg2000.candidatename
), pgmax2000 AS (
    SELECT
        pga_name2000.postal,
        MAX(pga_name2000.generalvotes) maxvotes
    FROM
        pga_name2000
    GROUP BY
        pga_name2000.postal
), ppa_state2000 AS (
    SELECT
        pp2000.postal,
        pp2000.party,
        SUM(pp2000.primaryvotes) primaryvotes
    FROM
        pp2000
    GROUP BY
        pp2000.postal,
        pp2000.party
), postal AS (
    SELECT
        presgeneral2000.statename   postal,
        initcap(presgeneral2000.candidate) statename
    FROM
        presgeneral2000
    WHERE
        presgeneral2000.numberofvotes = 0
), pr2000 AS (
    SELECT
        CASE
            WHEN pg2000.postal IS NULL THEN pp2000.postal
            ELSE pg2000.postal
        END postal,
        CASE
            WHEN pg2000.candidatenamefirst IS NULL THEN pp2000.candidatenamefirst
            ELSE pg2000.candidatenamefirst
        END candidatenamefirst,
        CASE
            WHEN pg2000.candidatenamelast IS NULL THEN pp2000.candidatenamelast
            ELSE pg2000.candidatenamelast
        END candidatenamelast,
        CASE
            WHEN pg2000.candidatename IS NULL THEN pp2000.candidatename
            ELSE pg2000.candidatename
        END candidatename,
        CASE
            WHEN pg2000.party IS NULL THEN pp2000.party
            ELSE pg2000.party
        END party,
        pp2000.primaryvotes,
        pg2000.generalvotes,
        CASE
            WHEN pg2000.writein IS NULL THEN pp2000.writein
            ELSE pg2000.writein
        END writein
    FROM
        pg2000
        FULL OUTER JOIN pp2000 ON pg2000.postal = pp2000.postal
                                  AND pg2000.candidatename = pp2000.candidatename
                                  AND pg2000.party = pp2000.party
), ppd2000 AS (
    SELECT
        statename,
        CASE
            WHEN EXTRACT(YEAR FROM primarydate) = 2001 THEN add_months(primarydate, - 12)
            ELSE primarydate
        END primarydate,
        party
    FROM
        (
            SELECT
                initcap(presprimarydates2000.statename) statename,
                CASE
                    WHEN presprimarydates2000.primarydate IS NULL THEN TO_DATE(presprimarydates2000.caucusdate, 'YYYY-MM-DD HH24:MI:SS'
                    )
                    ELSE TO_DATE(presprimarydates2000.primarydate, 'YYYY-MM-DD HH24:MI:SS')
                END primarydate,
                'R' party
            FROM
                presprimarydates2000
            WHERE
                presprimarydates2000.statename IN (
                    SELECT
                        statename
                    FROM
                        (
                            SELECT
                                presprimarydates2000.statename,
                                CASE
                                    WHEN presprimarydates2000.primarydate IS NULL THEN presprimarydates2000.caucusdate
                                    ELSE presprimarydates2000.primarydate
                                END primarydate
                            FROM
                                presprimarydates2000
                        )
                    GROUP BY
                        statename
                    HAVING
                        COUNT(statename) = 1
                )
            UNION
            SELECT
                initcap(presprimarydates2000.statename) statename,
                CASE
                    WHEN presprimarydates2000.primarydate IS NULL THEN TO_DATE(presprimarydates2000.caucusdate, 'YYYY-MM-DD HH24:MI:SS'
                    )
                    ELSE TO_DATE(presprimarydates2000.primarydate, 'YYYY-MM-DD HH24:MI:SS')
                END primarydate,
                'D' party
            FROM
                presprimarydates2000
            WHERE
                presprimarydates2000.statename IN (
                    SELECT
                        statename
                    FROM
                        (
                            SELECT
                                presprimarydates2000.statename,
                                CASE
                                    WHEN presprimarydates2000.primarydate IS NULL THEN presprimarydates2000.caucusdate
                                    ELSE presprimarydates2000.primarydate
                                END primarydate
                            FROM
                                presprimarydates2000
                        )
                    GROUP BY
                        statename
                    HAVING
                        COUNT(statename) = 1
                )
            UNION
            SELECT
                initcap(presprimarydates2000.statename) statename,
                TO_DATE(presprimarydates2000.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
                'R' party
            FROM
                presprimarydates2000
            WHERE
                presprimarydates2000.statename IN (
                    'ARIZONA',
                    'MICHIGAN'
                )
                AND NOT REGEXP_LIKE ( presprimarydates2000.primarydate,
                                      '[RD]' )
            UNION
            SELECT
                initcap(presprimarydates2000.statename) statename,
                TO_DATE(presprimarydates2000.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
                'D' party
            FROM
                presprimarydates2000
            WHERE
                presprimarydates2000.statename = 'DELAWARE'
                AND NOT REGEXP_LIKE ( presprimarydates2000.primarydate,
                                      '[RD]' )
            UNION
            SELECT
                initcap(statename) statename,
                TO_DATE(regexp_substr(primarydate, '(^\d+\/\d+)')
                        || '/'
                        || '2000', 'MM/DD/YYYY') primarydate,
                CASE
                    WHEN REGEXP_LIKE ( primarydate,
                                       '[R]' ) THEN 'R'
                    ELSE 'D'
                END party
            FROM
                (
                    SELECT
                        presprimarydates2000.statename,
                        CASE
                            WHEN presprimarydates2000.primarydate IS NULL THEN presprimarydates2000.caucusdate
                            ELSE presprimarydates2000.primarydate
                        END primarydate
                    FROM
                        presprimarydates2000
                )
            WHERE
                REGEXP_LIKE ( primarydate,
                              '[RD]' )
        )
), multi AS (
    SELECT
        pg2000.postal,
        pg2000.candidatename,
        COUNT(pg2000.candidatename) cancount
    FROM
        pg2000
    GROUP BY
        pg2000.postal,
        pg2000.candidatename
)
SELECT
    pr2000.postal,
    postal.statename,
    'President' district,
    NULL fecid,
    0 incumbent,
    pr2000.candidatenamefirst,
    pr2000.candidatenamelast,
    pr2000.candidatename,
    labels2000.partyname   party,
    pr2000.primaryvotes,
    pr2000.primaryvotes / ppa_state2000.primaryvotes primarypct,
    NULL runoffvotes,
    NULL runoffpct,
    pr2000.generalvotes,
    pr2000.generalvotes / pga_state2000.generalvotes generalpct,
    NULL gerunoffelectionvotes,
    NULL gerunoffelectionpct,
    CASE
        WHEN multi.cancount > 1 THEN pga_name2000.generalvotes
        ELSE NULL
    END combinedgeparytotals,
    CASE
        WHEN multi.cancount > 1 THEN pga_name2000.generalvotes / pga_state2000.generalvotes
        ELSE NULL
    END combinedpct,
    CASE
        WHEN pga_name2000.generalvotes = pgmax2000.maxvotes THEN 1
        ELSE 0
    END gewinnerindicator,
    NULL footnotes,
    TO_DATE('11/07/2000', 'MM/DD/YYYY') generalelectiondate,
    ppd2000.primarydate,
    NULL runoffdate,
    NULL gerunoffdate,
    pr2000.writein
FROM
    pr2000 left
    JOIN postal ON pr2000.postal = postal.postal
    LEFT JOIN labels2000 ON pr2000.party = replace(labels2000.abbreviation, ' ', '')
    LEFT JOIN ppa_state2000 ON pr2000.postal = ppa_state2000.postal
                               AND pr2000.party = ppa_state2000.party
    LEFT JOIN pga_state2000 ON pr2000.postal = pga_state2000.postal
    LEFT JOIN pga_name2000 ON pr2000.postal = pga_name2000.postal
                              AND pr2000.candidatename = pga_name2000.candidatename
    LEFT JOIN multi ON pr2000.postal = multi.postal
                       AND pr2000.candidatename = multi.candidatename
    LEFT JOIN pgmax2000 ON pr2000.postal = pgmax2000.postal
    LEFT JOIN ppd2000 ON postal.statename = ppd2000.statename
                         AND pr2000.party = ppd2000.party