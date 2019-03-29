WITH postalcodes AS (
    SELECT
        presgeneral2000_load.statename   postal,
        initcap(presgeneral2000_load.candidate) statename
    FROM
        presgeneral2000_load
    WHERE
        presgeneral2000_load.numberofvotes = 0
), pres2000 AS (
    SELECT
        CASE
            WHEN pg.postal IS NULL THEN pp.postal
            ELSE pg.postal
        END postal,
        CASE
            WHEN pg.candidatenamefirst IS NULL THEN pp.candidatenamefirst
            ELSE pg.candidatenamefirst
        END candidatenamefirst,
        CASE
            WHEN pg.candidatenamelast IS NULL THEN pp.candidatenamelast
            ELSE pg.candidatenamelast
        END candidatenamelast,
        CASE
            WHEN pg.candidatename IS NULL THEN pp.candidatename
            ELSE pg.candidatename
        END candidatename,
        CASE
            WHEN pg.party IS NULL THEN pp.party
            ELSE pg.party
        END party,
        pp.primaryvotes,
        pg.generalvotes,
        CASE
            WHEN pg.writein IS NULL THEN pp.writein
            ELSE pg.writein
        END writein
    FROM
        (
            SELECT
                presgeneral2000.postal,
                presgeneral2000.candidatenamefirst,
                presgeneral2000.candidatenamelast,
                presgeneral2000.candidatename,
                presgeneral2000.party,
                SUM(presgeneral2000.generalvotes) generalvotes,
                presgeneral2000.writein
            FROM
                presgeneral2000
            GROUP BY
                presgeneral2000.postal,
                presgeneral2000.candidatenamefirst,
                presgeneral2000.candidatenamelast,
                presgeneral2000.candidatename,
                presgeneral2000.party,
                presgeneral2000.writein
        ) pg
        FULL OUTER JOIN (
            SELECT
                presprimary2000.postal,
                presprimary2000.candidatenamefirst,
                presprimary2000.candidatenamelast,
                presprimary2000.candidatename,
                presprimary2000.party,
                SUM(presprimary2000.primaryvotes) primaryvotes,
                presprimary2000.writein
            FROM
                presprimary2000
            GROUP BY
                presprimary2000.postal,
                presprimary2000.candidatenamefirst,
                presprimary2000.candidatenamelast,
                presprimary2000.candidatename,
                presprimary2000.party,
                presprimary2000.writein
        ) pp ON pg.postal = pp.postal
                AND pg.candidatename = pp.candidatename
                AND pg.party = pp.party
), pres2004 AS (
    SELECT
        CASE
            WHEN pg.postal IS NULL THEN pp.postal
            ELSE pg.postal
        END postal,
        CASE
            WHEN pg.statename IS NULL THEN pp.statename
            ELSE pg.statename
        END statename,
        CASE
            WHEN pg.fecid IS NULL THEN pp.fecid
            ELSE pg.fecid
        END fecid,
        CASE
            WHEN pg.candidatenamefirst IS NULL THEN pp.candidatenamefirst
            ELSE pg.candidatenamefirst
        END candidatenamefirst,
        CASE
            WHEN pg.candidatenamelast IS NULL THEN pp.candidatenamelast
            ELSE pg.candidatenamelast
        END candidatenamelast,
        CASE
            WHEN pg.candidatename IS NULL THEN pp.candidatename
            ELSE pg.candidatename
        END candidatename,
        CASE
            WHEN pg.party IS NULL THEN pp.party
            ELSE pg.party
        END party,
        pp.primaryvotes,
        pg.generalvotes,
        CASE
            WHEN pg.notes IS NULL THEN pp.notes
            ELSE pg.notes
        END notes,
        pg.generalelectiondate,
        pp.primarydate,
        CASE
            WHEN pg.writein IS NULL THEN pp.writein
            ELSE pg.writein
        END writein
    FROM
        (
            SELECT
                presgeneral2004.postal,
                presgeneral2004.statename,
                presgeneral2004.fecid,
                presgeneral2004.candidatenamefirst,
                presgeneral2004.candidatenamelast,
                presgeneral2004.candidatename,
                presgeneral2004.party,
                SUM(presgeneral2004.generalvotes) generalvotes,
                presgeneral2004.notes,
                presgeneral2004.generalelectiondate,
                presgeneral2004.writein
            FROM
                presgeneral2004
            GROUP BY
                presgeneral2004.postal,
                presgeneral2004.statename,
                presgeneral2004.fecid,
                presgeneral2004.candidatenamefirst,
                presgeneral2004.candidatenamelast,
                presgeneral2004.candidatename,
                presgeneral2004.party,
                presgeneral2004.notes,
                presgeneral2004.generalelectiondate,
                presgeneral2004.writein
        ) pg
        FULL OUTER JOIN (
            SELECT
                presprimary2004.postal,
                presprimary2004.statename,
                presprimary2004.fecid,
                presprimary2004.candidatenamefirst,
                presprimary2004.candidatenamelast,
                presprimary2004.candidatename,
                presprimary2004.party,
                SUM(presprimary2004.primaryvotes) primaryvotes,
                presprimary2004.notes,
                presprimary2004.primarydate,
                presprimary2004.writein
            FROM
                presprimary2004
            GROUP BY
                presprimary2004.postal,
                presprimary2004.statename,
                presprimary2004.fecid,
                presprimary2004.candidatenamefirst,
                presprimary2004.candidatenamelast,
                presprimary2004.candidatename,
                presprimary2004.party,
                presprimary2004.notes,
                presprimary2004.primarydate,
                presprimary2004.writein
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), pres2008 AS (
    SELECT
        CASE
            WHEN pg.postal IS NULL THEN pp.postal
            ELSE pg.postal
        END postal,
        CASE
            WHEN pg.statename IS NULL THEN pp.statename
            ELSE pg.statename
        END statename,
        CASE
            WHEN pg.fecid IS NULL THEN pp.fecid
            ELSE pg.fecid
        END fecid,
        CASE
            WHEN pg.candidatenamefirst IS NULL THEN pp.candidatenamefirst
            ELSE pg.candidatenamefirst
        END candidatenamefirst,
        CASE
            WHEN pg.candidatenamelast IS NULL THEN pp.candidatenamelast
            ELSE pg.candidatenamelast
        END candidatenamelast,
        CASE
            WHEN pg.candidatename IS NULL THEN pp.candidatename
            ELSE pg.candidatename
        END candidatename,
        CASE
            WHEN pg.party IS NULL THEN pp.party
            ELSE pg.party
        END party,
        pp.primaryvotes,
        pg.generalvotes,
        pg.generalelectiondate,
        pp.primarydate,
        CASE
            WHEN pg.writein IS NULL THEN pp.writein
            ELSE pg.writein
        END writein
    FROM
        (
            SELECT
                presgeneral2008.postal,
                presgeneral2008.statename,
                presgeneral2008.fecid,
                presgeneral2008.candidatenamefirst,
                presgeneral2008.candidatenamelast,
                presgeneral2008.candidatename,
                presgeneral2008.party,
                SUM(presgeneral2008.generalvotes) generalvotes,
                presgeneral2008.generalelectiondate,
                presgeneral2008.writein
            FROM
                presgeneral2008
            GROUP BY
                presgeneral2008.postal,
                presgeneral2008.statename,
                presgeneral2008.fecid,
                presgeneral2008.candidatenamefirst,
                presgeneral2008.candidatenamelast,
                presgeneral2008.candidatename,
                presgeneral2008.party,
                presgeneral2008.generalelectiondate,
                presgeneral2008.writein
        ) pg
        FULL OUTER JOIN (
            SELECT
                presprimary2008.postal,
                presprimary2008.statename,
                presprimary2008.fecid,
                presprimary2008.candidatenamefirst,
                presprimary2008.candidatenamelast,
                presprimary2008.candidatename,
                presprimary2008.party,
                SUM(presprimary2008.primaryvotes) primaryvotes,
                presprimary2008.primarydate,
                presprimary2008.writein
            FROM
                presprimary2008
            GROUP BY
                presprimary2008.postal,
                presprimary2008.statename,
                presprimary2008.fecid,
                presprimary2008.candidatenamefirst,
                presprimary2008.candidatenamelast,
                presprimary2008.candidatename,
                presprimary2008.party,
                presprimary2008.primarydate,
                presprimary2008.writein
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), pres2012 AS (
    SELECT
        CASE
            WHEN pg.postal IS NULL THEN pp.postal
            ELSE pg.postal
        END postal,
        CASE
            WHEN pg.statename IS NULL THEN pp.statename
            ELSE pg.statename
        END statename,
        CASE
            WHEN pg.fecid IS NULL THEN pp.fecid
            ELSE pg.fecid
        END fecid,
        CASE
            WHEN pg.candidatenamefirst IS NULL THEN pp.candidatenamefirst
            ELSE pg.candidatenamefirst
        END candidatenamefirst,
        CASE
            WHEN pg.candidatenamelast IS NULL THEN pp.candidatenamelast
            ELSE pg.candidatenamelast
        END candidatenamelast,
        CASE
            WHEN pg.candidatename IS NULL THEN pp.candidatename
            ELSE pg.candidatename
        END candidatename,
        CASE
            WHEN pg.party IS NULL THEN pp.party
            ELSE pg.party
        END party,
        pp.primaryvotes,
        pg.generalvotes,
        pg.gewinner,
        pg.generalelectiondate,
        pp.primarydate,
        CASE
            WHEN pg.writein IS NULL THEN pp.writein
            ELSE pg.writein
        END writein
    FROM
        (
            SELECT
                presgeneral2012.postal,
                presgeneral2012.statename,
                presgeneral2012.fecid,
                presgeneral2012.candidatenamefirst,
                presgeneral2012.candidatenamelast,
                presgeneral2012.candidatename,
                presgeneral2012.party,
                SUM(presgeneral2012.generalvotes) generalvotes,
                presgeneral2012.gewinner,
                presgeneral2012.generalelectiondate,
                presgeneral2012.writein
            FROM
                presgeneral2012
            GROUP BY
                presgeneral2012.postal,
                presgeneral2012.statename,
                presgeneral2012.fecid,
                presgeneral2012.candidatenamefirst,
                presgeneral2012.candidatenamelast,
                presgeneral2012.candidatename,
                presgeneral2012.party,
                presgeneral2012.gewinner,
                presgeneral2012.generalelectiondate,
                presgeneral2012.writein
        ) pg
        FULL OUTER JOIN (
            SELECT
                presprimary2012.postal,
                presprimary2012.statename,
                presprimary2012.fecid,
                presprimary2012.candidatenamefirst,
                presprimary2012.candidatenamelast,
                presprimary2012.candidatename,
                presprimary2012.party,
                SUM(presprimary2012.primaryvotes) primaryvotes,
                presprimary2012.primarydate,
                presprimary2012.writein
            FROM
                presprimary2012
            GROUP BY
                presprimary2012.postal,
                presprimary2012.statename,
                presprimary2012.fecid,
                presprimary2012.candidatenamefirst,
                presprimary2012.candidatenamelast,
                presprimary2012.candidatename,
                presprimary2012.party,
                presprimary2012.primarydate,
                presprimary2012.writein
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), pres2016 AS (
SELECT
    CASE
        WHEN pg.postal IS NULL THEN pp.postal
        ELSE pg.postal
    END postal,
    CASE
        WHEN pg.statename IS NULL THEN pp.statename
        ELSE pg.statename
    END statename,
    CASE
        WHEN pg.fecid IS NULL THEN pp.fecid
        ELSE pg.fecid
    END fecid,
    CASE
        WHEN pg.candidatenamefirst IS NULL THEN pp.candidatenamefirst
        ELSE pg.candidatenamefirst
    END candidatenamefirst,
    CASE
        WHEN pg.candidatenamelast IS NULL THEN pp.candidatenamelast
        ELSE pg.candidatenamelast
    END candidatenamelast,
    CASE
        WHEN pg.candidatename IS NULL THEN pp.candidatename
        ELSE pg.candidatename
    END candidatename,
    CASE
        WHEN pg.party IS NULL THEN pp.party
        ELSE pg.party
    END party,
    pp.primaryvotes,
    pg.generalvotes,
    pg.gewinner,
    pp.notes,
    pg.generalelectiondate,
    pp.primarydate,
    CASE
        WHEN pg.writein IS NULL THEN pp.writein
        ELSE pg.writein
    END writein
FROM
    (
        SELECT
            presgeneral2016.postal,
            presgeneral2016.statename,
            presgeneral2016.fecid,
            presgeneral2016.candidatenamefirst,
            presgeneral2016.candidatenamelast,
            presgeneral2016.candidatename,
            presgeneral2016.party,
            SUM(presgeneral2016.generalvotes) generalvotes,
            presgeneral2016.gewinner,
            presgeneral2016.generalelectiondate,
            presgeneral2016.writein
        FROM
            presgeneral2016
        GROUP BY
            presgeneral2016.postal,
            presgeneral2016.statename,
            presgeneral2016.fecid,
            presgeneral2016.candidatenamefirst,
            presgeneral2016.candidatenamelast,
            presgeneral2016.candidatename,
            presgeneral2016.party,
            presgeneral2016.gewinner,
            presgeneral2016.generalelectiondate,
            presgeneral2016.writein
    ) pg
    FULL OUTER JOIN (
        SELECT
            presprimary2016.postal,
            presprimary2016.statename,
            presprimary2016.fecid,
            presprimary2016.candidatenamefirst,
            presprimary2016.candidatenamelast,
            presprimary2016.candidatename,
            presprimary2016.party,
            SUM(presprimary2016.primaryvotes) primaryvotes,
            presprimary2016.notes,
            presprimary2016.primarydate,
            presprimary2016.writein
        FROM
            presprimary2016
        GROUP BY
            presprimary2016.postal,
            presprimary2016.statename,
            presprimary2016.fecid,
            presprimary2016.candidatenamefirst,
            presprimary2016.candidatenamelast,
            presprimary2016.candidatename,
            presprimary2016.party,
            presprimary2016.notes,
            presprimary2016.primarydate,
            presprimary2016.writein
    ) pp ON pg.postal = pp.postal
            AND pg.fecid = pp.fecid
            AND pg.party = pp.party
)
SELECT
    pres2000.postal,
    postalcodes.statename,
    'President' district,
    NULL    fecid,
    0   incumbent,
    pres2000.candidatenamefirst,
    pres2000.candidatenamelast,
    pres2000.candidatename,
    labels2000.partyname    party,
    pres2000.primaryvotes,
    pres2000.primaryvotes / primpct.primaryvotes   primarypct,
    NULL    runoffvotes,
    NULL    runoffpct,
    pres2000.generalvotes,
    pres2000.generalvotes / genpct.generalvotes generalpct,
    NULL    gerunoffelectionvotes,
    NULL    gerunoffelectionpct,
    CASE
        WHEN
            multi.multi > 1 THEN combpct.generalvotes
            ELSE NULL 
        END combinedgepartytotals,
    CASE
        WHEN
        multi.multi > 1 THEN combpct.generalvotes / genpct.generalvotes
        ELSE NULL 
    END combinedpct,
    CASE 
        WHEN 
            combpct.generalvotes = gewin.maxvotes   THEN 1 
        ELSE 0 
    END gewinner,
    NULL    notes,
    TO_DATE('11/07/2000', 'MM/DD/YYYY')     generalelectiondate,
    ppd2000.primarydate,
    NULL    runoffdate,
    NULL    gerunoffdate,
    pres2000.writein
FROM    
    pres2000
LEFT JOIN postalcodes ON pres2000.postal = postalcodes.postal
LEFT JOIN labels2000 on pres2000.party = TRIM(labels2000.abbreviation)
LEFT JOIN (
    SELECT
        pres2000.postal,
        pres2000.party,
        SUM(pres2000.primaryvotes) primaryvotes
    FROM
        pres2000
    GROUP BY
        pres2000.postal,
        pres2000.party
    ) primpct ON pres2000.postal = primpct.postal
                AND pres2000.party = primpct.party
LEFT JOIN (
    SELECT 
        postal, 
        sum(generalvotes)   generalvotes
    FROM 
        pres2000 
    GROUP BY 
    postal
    ) genpct ON pres2000.postal = genpct.postal
LEFT JOIN (
    SELECT 
        candidatename, 
        postal, 
        SUM(generalvotes)   generalvotes
    FROM 
        pres2000 
    GROUP BY 
        postal, 
        candidatename
    ) combpct ON pres2000.postal = combpct.postal
                AND pres2000.candidatename = combpct.candidatename
LEFT JOIN (
    SELECT 
        postal, 
        candidatename, 
        COUNT(generalvotes)     multi
    FROM 
        pres2000
    GROUP BY 
        postal, 
        candidatename
    ) multi ON pres2000.postal = multi.postal
            AND pres2000.candidatename = multi.candidatename
LEFT JOIN (
    SELECT 
        postal, 
        MAX(generalvotes)   maxvotes
    FROM (
        SELECT 
            candidatename, 
            postal, 
            SUM(generalvotes)   generalvotes
        FROM 
            pres2000 
        GROUP BY 
            postal, 
            candidatename
        )
    GROUP BY 
        postal
    ) gewin ON pres2000.postal = gewin.postal
LEFT JOIN 
    ppd2000
ON postalcodes.statename = ppd2000.statename
    AND pres2000.party = ppd2000.party
UNION
SELECT
	pres2004.postal,
	pres2004.statename,
	'President'	district,
	pres2004.fecid,
	CASE
		WHEN pres2004.candidatename LIKE '%Bush%' THEN 1
		ELSE 0
	END incumbent,
	pres2004.candidatenamefirst,
	pres2004.candidatenamelast,
	pres2004.candidatename,
	labels2004.partyname 	party,
	pres2004.primaryvotes,
	pres2004.primaryvotes / primpct.primaryvotes 	primarypct,
	NULL 	runoffvotes,
	NULL 	runoffpct,
	pres2004.generalvotes,
	pres2004.generalvotes / genpct.generalvotes generalpct,
	NULL 	gerunoffelectionvotes,
	NULL 	gerunoffelectionpct,
	CASE
		WHEN
			multi.multi > 1	THEN combpct.generalvotes
			ELSE NULL 
		END combinedgepartytotals,
	CASE
		WHEN
		multi.multi > 1	THEN combpct.generalvotes / genpct.generalvotes
		ELSE NULL 
	END combinedpct,
	CASE 
		WHEN 
			combpct.generalvotes = gewin.maxvotes	THEN 1 
		ELSE 0 
	END gewinner,
	pres2004.notes,
	pres2004.generalelectiondate,
	pres2004.primarydate,
	NULL 	runoffdate,
	NULL 	gerunoffdate,
	pres2004.writein
FROM 	
	pres2004
LEFT JOIN labels2004 on pres2004.party = TRIM(labels2004.abbreviation)
LEFT JOIN (
	SELECT 
		postal, 
		party, 
		SUM(primaryvotes)	primaryvotes
	FROM 
		pres2004 
	GROUP BY 
		postal, 
		party
	) primpct ON pres2004.postal = primpct.postal
				AND pres2004.party = primpct.party
LEFT JOIN (
	SELECT 
		postal, 
		sum(generalvotes) 	generalvotes
	FROM 
		pres2004 
	GROUP BY 
	postal
	) genpct ON pres2004.postal = genpct.postal
LEFT JOIN (
	SELECT 
		candidatename, 
		postal, 
		SUM(generalvotes)	generalvotes
	FROM 
		pres2004 
	GROUP BY 
		postal, 
		candidatename
	) combpct ON pres2004.postal = combpct.postal
				AND pres2004.candidatename = combpct.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		candidatename, 
		COUNT(generalvotes) 	multi
	FROM 
		pres2004
	GROUP BY 
		postal, 
		candidatename
	) multi ON pres2004.postal = multi.postal
			AND pres2004.candidatename = multi.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		MAX(generalvotes) 	maxvotes
	FROM (
		SELECT 
			candidatename, 
			postal, 
			SUM(generalvotes) 	generalvotes
		FROM 
			pres2004 
		GROUP BY 
			postal, 
			candidatename
		)
	GROUP BY 
		postal
	) gewin ON pres2004.postal = gewin.postal
UNION
SELECT
	pres2008.postal,
	pres2008.statename,
	'President'	district,
	pres2008.fecid,
	0 	incumbent,
	pres2008.candidatenamefirst,
	pres2008.candidatenamelast,
	pres2008.candidatename,
	labels2008.partyname 	party,
	pres2008.primaryvotes,
	pres2008.primaryvotes / primpct.primaryvotes 	primarypct,
	NULL 	runoffvotes,
	NULL 	runoffpct,
	pres2008.generalvotes,
	pres2008.generalvotes / genpct.generalvotes generalpct,
	NULL 	gerunoffelectionvotes,
	NULL 	gerunoffelectionpct,
	CASE
		WHEN
			multi.multi > 1	THEN combpct.generalvotes
			ELSE NULL 
		END combinedgepartytotals,
	CASE
		WHEN
		multi.multi > 1	THEN combpct.generalvotes / genpct.generalvotes
		ELSE NULL 
	END combinedpct,
	CASE 
		WHEN 
			combpct.generalvotes = gewin.maxvotes	THEN 1 
		ELSE 0 
	END gewinner,
	NULL 	notes,
	pres2008.generalelectiondate,
	pres2008.primarydate,
	NULL 	runoffdate,
	NULL 	gerunoffdate,
	pres2008.writein
FROM 	
	pres2008
LEFT JOIN labels2008 on pres2008.party = TRIM(labels2008.abbreviation)
LEFT JOIN (
	SELECT 
		postal, 
		party, 
		SUM(primaryvotes)	primaryvotes
	FROM 
		pres2008 
	GROUP BY 
		postal, 
		party
	) primpct ON pres2008.postal = primpct.postal
				AND pres2008.party = primpct.party
LEFT JOIN (
	SELECT 
		postal, 
		sum(generalvotes) 	generalvotes
	FROM 
		pres2008 
	GROUP BY 
	postal
	) genpct ON pres2008.postal = genpct.postal
LEFT JOIN (
	SELECT 
		candidatename, 
		postal, 
		SUM(generalvotes)	generalvotes
	FROM 
		pres2008 
	GROUP BY 
		postal, 
		candidatename
	) combpct ON pres2008.postal = combpct.postal
				AND pres2008.candidatename = combpct.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		candidatename, 
		COUNT(generalvotes) 	multi
	FROM 
		pres2008
	GROUP BY 
		postal, 
		candidatename
	) multi ON pres2008.postal = multi.postal
			AND pres2008.candidatename = multi.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		MAX(generalvotes) 	maxvotes
	FROM (
		SELECT 
			candidatename, 
			postal, 
			SUM(generalvotes) 	generalvotes
		FROM 
			pres2008 
		GROUP BY 
			postal, 
			candidatename
		)
	GROUP BY 
		postal
	) gewin ON pres2008.postal = gewin.postal
UNION
SELECT
	pres2012.postal,
	pres2012.statename,
	'President'	district,
	pres2012.fecid,
	CASE
		WHEN pres2012.candidatename LIKE '%Obama%' THEN 1
		ELSE 0
	END	incumbent,
	pres2012.candidatenamefirst,
	pres2012.candidatenamelast,
	pres2012.candidatename,
	labels2012.partyname 	party,
	pres2012.primaryvotes,
	pres2012.primaryvotes / primpct.primaryvotes 	primarypct,
	NULL 	runoffvotes,
	NULL 	runoffpct,
	pres2012.generalvotes,
	pres2012.generalvotes / genpct.generalvotes generalpct,
	NULL 	gerunoffelectionvotes,
	NULL 	gerunoffelectionpct,
	CASE
		WHEN
			multi.multi > 1	THEN combpct.generalvotes
			ELSE NULL 
		END combinedgepartytotals,
	CASE
		WHEN
		multi.multi > 1	THEN combpct.generalvotes / genpct.generalvotes
		ELSE NULL 
	END combinedpct,
	pres2012.gewinner,
	NULL 	notes,
	pres2012.generalelectiondate,
	pres2012.primarydate,
	NULL 	runoffdate,
	NULL 	gerunoffdate,
	pres2012.writein
FROM 	
	pres2012
LEFT JOIN labels2012 on pres2012.party = TRIM(labels2012.abbreviation)
LEFT JOIN (
	SELECT 
		postal, 
		party, 
		SUM(primaryvotes)	primaryvotes
	FROM 
		pres2012 
	GROUP BY 
		postal, 
		party
	) primpct ON pres2012.postal = primpct.postal
				AND pres2012.party = primpct.party
LEFT JOIN (
	SELECT 
		postal, 
		sum(generalvotes) 	generalvotes
	FROM 
		pres2012 
	GROUP BY 
	postal
	) genpct ON pres2012.postal = genpct.postal
LEFT JOIN (
	SELECT 
		candidatename, 
		postal, 
		SUM(generalvotes)	generalvotes
	FROM 
		pres2012 
	GROUP BY 
		postal, 
		candidatename
	) combpct ON pres2012.postal = combpct.postal
				AND pres2012.candidatename = combpct.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		candidatename, 
		COUNT(generalvotes) 	multi
	FROM 
		pres2012
	GROUP BY 
		postal, 
		candidatename
	) multi ON pres2012.postal = multi.postal
			AND pres2012.candidatename = multi.candidatename
UNION
SELECT
	pres2016.postal,
	pres2016.statename,
	'President'	district,
	pres2016.fecid,
	0	incumbent,
	pres2016.candidatenamefirst,
	pres2016.candidatenamelast,
	pres2016.candidatename,
	labels2016.partyname 	party,
	pres2016.primaryvotes,
	pres2016.primaryvotes / primpct.primaryvotes 	primarypct,
	NULL 	runoffvotes,
	NULL 	runoffpct,
	pres2016.generalvotes,
	pres2016.generalvotes / genpct.generalvotes generalpct,
	NULL 	gerunoffelectionvotes,
	NULL 	gerunoffelectionpct,
	CASE
		WHEN
			multi.multi > 1	THEN combpct.generalvotes
			ELSE NULL 
		END combinedgepartytotals,
	CASE
		WHEN
		multi.multi > 1	THEN combpct.generalvotes / genpct.generalvotes
		ELSE NULL 
	END combinedpct,
	pres2016.gewinner,
	pres2016.notes,
	pres2016.generalelectiondate,
	pres2016.primarydate,
	NULL 	runoffdate,
	NULL 	gerunoffdate,
	pres2016.writein
FROM 	
	pres2016
LEFT JOIN labels2016 on pres2016.party = TRIM(labels2016.abbreviation)
LEFT JOIN (
	SELECT 
		postal, 
		party, 
		SUM(primaryvotes)	primaryvotes
	FROM 
		pres2016 
	GROUP BY 
		postal, 
		party
	) primpct ON pres2016.postal = primpct.postal
				AND pres2016.party = primpct.party
LEFT JOIN (
	SELECT 
		postal, 
		sum(generalvotes) 	generalvotes
	FROM 
		pres2016 
	GROUP BY 
	postal
	) genpct ON pres2016.postal = genpct.postal
LEFT JOIN (
	SELECT 
		candidatename, 
		postal, 
		SUM(generalvotes)	generalvotes
	FROM 
		pres2016 
	GROUP BY 
		postal, 
		candidatename
	) combpct ON pres2016.postal = combpct.postal
				AND pres2016.candidatename = combpct.candidatename
LEFT JOIN (
	SELECT 
		postal, 
		candidatename, 
		COUNT(generalvotes) 	multi
	FROM 
		pres2016
	GROUP BY 
		postal, 
		candidatename
	) multi ON pres2016.postal = multi.postal
			AND pres2016.candidatename = multi.candidatename
UNION
SELECT
    house2000.postal,
    postalcodes.statename,
    house2000.district,
    NULL    fecid,
    house2000.incumbent,
    house2000.candidatenamefirst,
    house2000.candidatenamelast,
    house2000.candidatename,
    labels2000.partyname    party,
    house2000.primaryvotes,
    house2000.primaryvotes / primpct.primaryvotes   primarypct,
    house2000.runoffvotes,
    house2000.runoffvotes /  genpct.runoffvotes   runoffpct,
    house2000.generalvotes,
    house2000.generalvotes / genpct.generalvotes generalpct,
    NULL    gerunoffelectionvotes,
    NULL    gerunoffelectionpct,
    CASE
        WHEN
            multi.multi > 1 THEN combpct.generalvotes
            ELSE NULL 
        END combinedgepartytotals,
    CASE
        WHEN
        multi.multi > 1 THEN combpct.generalvotes / genpct.generalvotes
        ELSE NULL 
    END combinedpct,
    CASE 
        WHEN 
            combpct.generalvotes = gewin.maxvotes   THEN 1 
        ELSE 0 
    END gewinner,
    NULL    notes,
    TO_DATE('11/07/2000', 'MM/DD/YYYY')     generalelectiondate,
    NULL    primarydate,
    NULL    runoffdate,
    NULL    gerunoffdate,
    house2000.writein
FROM    
    house2000
LEFT JOIN postalcodes ON house2000.postal = postalcodes.postal
LEFT JOIN labels2000 on house2000.party = TRIM(labels2000.abbreviation)
LEFT JOIN (
    SELECT 
        postal, 
        district,
        party,
        SUM(primaryvotes)   primaryvotes
    FROM 
        house2000 
    GROUP BY 
        postal,
        district, 
        party
    ) primpct ON house2000.postal = primpct.postal
                AND house2000.party = primpct.party
                AND house2000.district = primpct.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        SUM(runoffvotes)    runoffvotes,
        sum(generalvotes)   generalvotes

    FROM 
        house2000 
    GROUP BY 
    postal,
    district
    ) genpct ON house2000.postal = genpct.postal
                AND house2000.postal = genpct.district
LEFT JOIN (
    SELECT 
        candidatename, 
        postal,
        district, 
        SUM(generalvotes)   generalvotes
    FROM 
        house2000 
    GROUP BY 
        postal, 
        candidatename,
        district
    ) combpct ON house2000.postal = combpct.postal
                AND house2000.candidatename = combpct.candidatename
                AND house2000.district = combpct.district
LEFT JOIN (
    SELECT 
        postal, 
        candidatename,
        district, 
        COUNT(generalvotes)     multi
    FROM 
        house2000
    GROUP BY 
        postal, 
        candidatename,
        district
    ) multi ON house2000.postal = multi.postal
            AND house2000.candidatename = multi.candidatename
            AND house2000.district = multi.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        MAX(generalvotes)   maxvotes
    FROM (
        SELECT 
            candidatename, 
            postal,
            district, 
            SUM(generalvotes)   generalvotes
        FROM 
            house2000 
        GROUP BY 
            postal, 
            candidatename,
            district
        )
    GROUP BY 
        postal,
        district
    ) gewin ON house2000.postal = gewin.postal
            AND house2000.district = gewin.district
UNION
SELECT
    senate2000.postal,
    postalcodes.statename,
    senate2000.district,
    NULL    fecid,
    senate2000.incumbent,
    senate2000.candidatenamefirst,
    senate2000.candidatenamelast,
    senate2000.candidatename,
    labels2000.partyname    party,
    senate2000.primaryvotes,
    senate2000.primaryvotes / primpct.primaryvotes   primarypct,
    senate2000.runoffvotes,
    senate2000.runoffvotes /  genpct.runoffvotes   runoffpct,
    senate2000.generalvotes,
    senate2000.generalvotes / genpct.generalvotes generalpct,
    NULL    gerunoffelectionvotes,
    NULL    gerunoffelectionpct,
    CASE
        WHEN
            multi.multi > 1 THEN combpct.generalvotes
            ELSE NULL 
        END combinedgepartytotals,
    CASE
        WHEN
        multi.multi > 1 THEN combpct.generalvotes / genpct.generalvotes
        ELSE NULL 
    END combinedpct,
    CASE 
        WHEN 
            combpct.generalvotes = gewin.maxvotes   THEN 1 
        ELSE 0 
    END gewinner,
    NULL    notes,
    TO_DATE('11/07/2000', 'MM/DD/YYYY')     generalelectiondate,
    NULL    primarydate,
    NULL    runoffdate,
    NULL    gerunoffdate,
    senate2000.writein
FROM    
    senate2000
LEFT JOIN postalcodes ON senate2000.postal = postalcodes.postal
LEFT JOIN labels2000 on senate2000.party = TRIM(labels2000.abbreviation)
LEFT JOIN (
    SELECT 
        postal, 
        district,
        party,
        SUM(primaryvotes)   primaryvotes
    FROM 
        senate2000 
    GROUP BY 
        postal,
        district, 
        party
    ) primpct ON senate2000.postal = primpct.postal
                AND senate2000.party = primpct.party
                AND senate2000.district = primpct.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        SUM(runoffvotes)    runoffvotes,
        sum(generalvotes)   generalvotes

    FROM 
        senate2000 
    GROUP BY 
    postal,
    district
    ) genpct ON senate2000.postal = genpct.postal
                AND senate2000.postal = genpct.district
LEFT JOIN (
    SELECT 
        candidatename, 
        postal,
        district, 
        SUM(generalvotes)   generalvotes
    FROM 
        senate2000 
    GROUP BY 
        postal, 
        candidatename,
        district
    ) combpct ON senate2000.postal = combpct.postal
                AND senate2000.candidatename = combpct.candidatename
                AND senate2000.district = combpct.district
LEFT JOIN (
    SELECT 
        postal, 
        candidatename,
        district, 
        COUNT(generalvotes)     multi
    FROM 
        senate2000
    GROUP BY 
        postal, 
        candidatename,
        district
    ) multi ON senate2000.postal = multi.postal
            AND senate2000.candidatename = multi.candidatename
            AND senate2000.district = multi.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        MAX(generalvotes)   maxvotes
    FROM (
        SELECT 
            candidatename, 
            postal,
            district, 
            SUM(generalvotes)   generalvotes
        FROM 
            senate2000 
        GROUP BY 
            postal, 
            candidatename,
            district
        )
    GROUP BY 
        postal,
        district
    ) gewin ON senate2000.postal = gewin.postal
            AND senate2000.district = gewin.district
UNION
SELECT
    congress2002.postal,
    postalcodes.statename,
    congress2002.district,
    NULL    fecid,
    congress2002.incumbent,
    congress2002.candidatenamefirst,
    congress2002.candidatenamelast,
    congress2002.candidatename,
    labels2002.partyname    party,
    congress2002.primaryvotes,
    congress2002.primaryvotes / primpct.primaryvotes   primarypct,
    congress2002.runoffvotes,
    congress2002.runoffvotes /  genpct.runoffvotes   runoffpct,
    congress2002.generalvotes,
    congress2002.generalvotes / genpct.generalvotes generalpct,
    congress2002.gerunoffelectionvotes,
    congress2002.gerunoffelectionvotes / genpct.gerunoffelectionvotes  gerunoffelectionpct,
    CASE
        WHEN
            multi.multi > 1 THEN combpct.generalvotes
            ELSE NULL 
        END combinedgepartytotals,
    CASE
        WHEN
        multi.multi > 1 THEN combpct.generalvotes / genpct.generalvotes
        ELSE NULL 
    END combinedpct,
    CASE 
        WHEN 
            combpct.generalvotes = gewin.maxvotes   THEN 1 
        ELSE 0 
    END gewinner,
    NULL    notes,
    TO_DATE('11/05/2002', 'MM/DD/YYYY')     generalelectiondate,
    pd2002.primarydate,
    pd2002.runoffdate,
    NULL    gerunoffdate,
    congress2002.writein
FROM    
    congress2002
LEFT JOIN postalcodes ON congress2002.postal = postalcodes.postal
LEFT JOIN labels2002 on congress2002.party = TRIM(labels2002.abbreviation)
LEFT JOIN (
    SELECT 
        postal, 
        district,
        party,
        SUM(primaryvotes)   primaryvotes
    FROM 
        congress2002 
    GROUP BY 
        postal,
        district, 
        party
    ) primpct ON congress2002.postal = primpct.postal
                AND congress2002.party = primpct.party
                AND congress2002.district = primpct.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        SUM(runoffvotes)    runoffvotes,
        sum(generalvotes)   generalvotes,
        sum(gerunoffelectionvotes) gerunoffelectionvotes
    FROM 
        congress2002 
    GROUP BY 
    postal,
    district
    ) genpct ON congress2002.postal = genpct.postal
                AND congress2002.postal = genpct.district
LEFT JOIN (
    SELECT 
        candidatename, 
        postal,
        district, 
        SUM(generalvotes)   generalvotes
    FROM 
        congress2002 
    GROUP BY 
        postal, 
        candidatename,
        district
    ) combpct ON congress2002.postal = combpct.postal
                AND congress2002.candidatename = combpct.candidatename
                AND congress2002.district = combpct.district
LEFT JOIN (
    SELECT 
        postal, 
        candidatename,
        district, 
        COUNT(generalvotes)     multi
    FROM 
        congress2002
    GROUP BY 
        postal, 
        candidatename,
        district
    ) multi ON congress2002.postal = multi.postal
            AND congress2002.candidatename = multi.candidatename
            AND congress2002.district = multi.district
LEFT JOIN (
    SELECT 
        postal,
        district, 
        MAX(generalvotes)   maxvotes
    FROM (
        SELECT 
            candidatename, 
            postal,
            district, 
            SUM(generalvotes)   generalvotes
        FROM 
            congress2002 
        GROUP BY 
            postal, 
            candidatename,
            district
        )
    GROUP BY 
        postal,
        district
    ) gewin ON congress2002.postal = gewin.postal
            AND congress2002.district = gewin.district
LEFT JOIN pd2002
ON congress2002.postal = pd2002.statename    