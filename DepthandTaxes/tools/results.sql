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
            ELSE TRIM(presgeneral2000.party)
        END party,
        to_number(regexp_replace(presgeneral2000.numberofvotes, '\D+')) generalvotes,
        CASE
            WHEN presgeneral2000.party = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2000
    WHERE
        presgeneral2000.statename != 'ZZZZ'
        AND presgeneral2000.numberofvotes != 0
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
            ELSE TRIM(presprimary2000.party)
        END party,
        to_number(regexp_replace(presprimary2000.numberofvotes, '\D+')) primaryvotes,
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
), h2000 AS (
    SELECT
        house2000.statename   postal,
        house2000.district,
        nvl2(house2000.incumbentindicator, 1, 0) incumbent,
        regexp_substr(house2000.name, '[^,]+', 1, 2) candidatenamefirst,
        regexp_substr(house2000.name, '[^,]+', 1, 1) candidatenamelast,
        house2000.name        candidatename,
        CASE
            WHEN house2000.party = '(N)NL'      THEN 'NL'
            WHEN house2000.party = 'N(D)'       THEN 'D'
            WHEN house2000.party = 'I (GRN)'    THEN 'GRN'
            WHEN house2000.party = 'I (NJC)'    THEN 'NJC'
            WHEN house2000.party = 'I (IPR)'    THEN 'IPR'
            WHEN house2000.party = 'W(GRN)/GRN' THEN 'GRN'
            WHEN house2000.party = 'W(R)'       THEN 'R'
            WHEN house2000.party = 'W(UM)'      THEN 'UM'
            WHEN house2000.party = 'W(LBT)'     THEN 'LBT'
            WHEN house2000.party = 'N(R)'       THEN 'R'
            WHEN house2000.party = 'I (LBT)'    THEN 'LBT'
            WHEN house2000.party = 'I (SWP)'    THEN 'SWP'
            WHEN house2000.party = 'I(CFC)'     THEN 'CFC'
            WHEN house2000.party = 'D/LU'       THEN 'D'
            WHEN house2000.party = 'W/LBT'      THEN 'LBT'
            WHEN house2000.party = 'U(LBT)'     THEN 'LBT'
            WHEN house2000.party = 'W(R)/R'     THEN 'R'
            WHEN house2000.party = 'D/R'        THEN 'R'
            WHEN house2000.party = 'W(D)'       THEN 'D'
            WHEN house2000.party = 'W(DCG)'     THEN 'DCG'
            WHEN house2000.party = 'I (LMP)'    THEN 'LMP'
            WHEN house2000.party = 'I (NJI)'    THEN 'NJI'
            WHEN house2000.party = 'I (CON)'    THEN 'CON'
            WHEN house2000.party = 'W(C)'       THEN 'C'
            WHEN house2000.party = 'W(CON)'     THEN 'CON'
            WHEN house2000.party = 'N(LBT)'     THEN 'LBT'
            WHEN house2000.party = 'I (REF)'    THEN 'REF'
            WHEN house2000.party = 'W(G)'       THEN 'G'
            WHEN house2000.party = 'W(WF)/WF'   THEN 'WF'
            WHEN house2000.party = 'I(LBT)'     THEN 'LBT'
            WHEN house2000.party = 'I (SOC)'    THEN 'SOC'
            WHEN house2000.party = 'I (ICE)'    THEN 'ICE'
            WHEN house2000.party = 'W(IDP)'     THEN 'IDP'
            WHEN house2000.party = 'W(NL)'      THEN 'NL'
            WHEN house2000.party = 'I (NL)'     THEN 'NL'
            WHEN house2000.party = 'I (PC)'     THEN 'PC'
            WHEN house2000.party = 'W(GRN)'     THEN 'GRN'
            WHEN house2000.party = 'I(GRN)'     THEN 'GRN'
            WHEN house2000.party = 'W(WG)'      THEN 'WG'
            WHEN house2000.party = 'W(D)/R'     THEN 'R'
            WHEN house2000.party = 'I (UC)'     THEN 'UC'
            ELSE TRIM(house2000.party)
        END party,
        to_number(regexp_replace(house2000.primaryresults, '\D+')) primaryvotes,
        to_number(regexp_replace(house2000.runoffresults, '\D+')) runoffvotes,
        to_number(regexp_replace(house2000.generalresults, '\D+')) generalvotes,
        CASE
            WHEN house2000.generalresults LIKE '%Un%' THEN 1
            ELSE NULL
        END AS gewinner,
        CASE
            WHEN house2000.party IN (
                'W',
                'W(GRN)/GRN',
                'W(R)',
                'W(UM)',
                'W(LBT)',
                'W(R)/R',
                'W(D)',
                'W(DCG)',
                'W(C)',
                'W(CON)',
                'W(G)',
                'W(WF)/WF',
                'W(IDP)',
                'W(NL)',
                'W(GRN)',
                'W(WG)',
                'W(D)/R'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        house2000
    WHERE
        house2000.statename IS NOT NULL
        AND house2000.party != 'Combined'
), s2000 AS (
    SELECT
        senate2000.statename   postal,
        senate2000.district,
        nvl2(senate2000.incumbentindicator, 1, 0) incumbent,
        regexp_substr(senate2000.name, '[^,]+', 1, 2) candidatenamefirst,
        regexp_substr(senate2000.name, '[^,]+', 1, 1) candidatenamelast,
        senate2000.name        candidatename,
        CASE
            WHEN senate2000.party = 'I (GRN)' THEN 'GRN'
            WHEN senate2000.party = '(N)NL'   THEN 'NL'
            WHEN senate2000.party = 'N(D)'    THEN 'D'
            WHEN senate2000.party = 'W(RTL)'  THEN 'RTL'
            WHEN senate2000.party = 'I (NJC)' THEN 'NJC'
            WHEN senate2000.party = 'N(R)'    THEN 'R'
            WHEN senate2000.party = 'W(R)'    THEN 'R'
            WHEN senate2000.party = 'I (GBJ)' THEN 'GBJ'
            WHEN senate2000.party = 'I (LBT)' THEN 'LBT'
            WHEN senate2000.party = 'W(LBT)'  THEN 'LBT'
            WHEN senate2000.party = 'I (SWP)' THEN 'SWP'
            WHEN senate2000.party = '(N)LBT'  THEN 'LBT'
            WHEN senate2000.party = 'W(CON)'  THEN 'CON'
            WHEN senate2000.party = 'W(D)'    THEN 'D'
            WHEN senate2000.party = 'I (REF)' THEN 'REF'
            WHEN senate2000.party = 'W(IDP)'  THEN 'IDP'
            WHEN senate2000.party = 'I (SOC)' THEN 'SOC'
            WHEN senate2000.party = 'I (TG)'  THEN 'TG'
            WHEN senate2000.party = 'W(WG)'   THEN 'WG'
            WHEN senate2000.party = 'W(GRN)'  THEN 'GRN'
            WHEN senate2000.party = 'I (I)'   THEN 'I'
            ELSE TRIM(senate2000.party)
        END party,
        to_number(regexp_replace(senate2000.primaryresults, '\D+')) primaryvotes,
        to_number(regexp_replace(senate2000.runoffresults, '\D+')) runoffvotes,
        to_number(regexp_replace(senate2000.generalresults, '\D+')) generalvotes,
        CASE
            WHEN senate2000.party IN (
                'W',
                'W(RTL)',
                'W(R)',
                'W(LBT)',
                'W(CON)',
                'W(D)',
                'W(IDP)',
                'W(WG)',
                'W(GRN)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        senate2000
    WHERE
        senate2000.combinedparties IS NULL
    ORDER BY
        postal
), c2002 AS (
    SELECT
        congress2002.statename       postal,
        congress2002.district,
        congress2002.fecid,
        nvl2(congress2002.incumbentindicator, 1, 0) incumbent,
        congress2002.firstname       candidatenamefirst,
        congress2002.lastname        candidatenamelast,
        congress2002.lastnamefirst   candidatename,
        CASE
            WHEN congress2002.party = 'N(D)'           THEN 'D'
            WHEN congress2002.party = 'I (GRN)'        THEN 'GRN'
            WHEN congress2002.party = 'I (NJC)'        THEN 'NJC'
            WHEN congress2002.party = 'I (LTI)'        THEN 'LTI'
            WHEN congress2002.party = 'I (PLC)'        THEN 'PLC'
            WHEN congress2002.party = 'W(RTL) '        THEN 'TRL'
            WHEN congress2002.party = 'W(RTL)'         THEN 'RTL'
            WHEN congress2002.party = 'W(R)'           THEN 'R'
            WHEN congress2002.party = 'W(LBT)'         THEN 'LBT'
            WHEN congress2002.party = 'W(R)/W'         THEN 'R'
            WHEN congress2002.party = 'DFL/W'          THEN 'DFL'
            WHEN congress2002.party = 'N(R)'           THEN 'R'
            WHEN congress2002.party = 'I (LBT)'        THEN 'LBT'
            WHEN congress2002.party = 'I (AF)'         THEN 'AF'
            WHEN congress2002.party = 'I (HHD)'        THEN 'HHD'
            WHEN congress2002.party = 'W(RTL)/RTL'     THEN 'RTL'
            WHEN congress2002.party = 'W(D)'           THEN 'D'
            WHEN congress2002.party = 'W(DCG)'         THEN 'DCG'
            WHEN congress2002.party = 'GRN/W'          THEN 'GRN'
            WHEN congress2002.party = 'I (AM,AC)'      THEN 'AM'
            WHEN congress2002.party = 'W(C)'           THEN 'C'
            WHEN congress2002.party = 'W(CON)'         THEN 'CON'
            WHEN congress2002.party = 'W(LBT)  '       THEN 'LBT'
            WHEN congress2002.party = 'N(LBT)'         THEN 'LBT'
            WHEN congress2002.party = 'R and R/D'      THEN 'R'
            WHEN congress2002.party = 'I(HP)'          THEN 'HP'
            WHEN congress2002.party = 'W(IG)'          THEN 'IG'
            WHEN congress2002.party = 'I (SOC)'        THEN 'SOC'
            WHEN congress2002.party = 'PRO AND LU/PRO' THEN 'PRO'
            WHEN congress2002.party = 'W(GRN)'         THEN 'GRN'
            WHEN congress2002.party = 'I (PC)'         THEN 'PC'
            WHEN congress2002.party = 'W(PRO)'         THEN 'PRO'
            WHEN congress2002.party = 'W(WG)'          THEN 'WG'
            WHEN congress2002.party = 'W(LBT)/LBT'     THEN 'LBT'
            WHEN congress2002.party = 'R/W'            THEN 'R'
            WHEN congress2002.party = 'I (HRA)'        THEN 'HRA'
            ELSE TRIM(congress2002.party)
        END party,
        to_number(regexp_replace(congress2002.primaryresults, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2002.runoffresults, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2002.generalresults, '\D+')) generalvotes,
        to_number(regexp_replace(congress2002.generalrunoffresults, '\D+')) gerunoffelectionvotes,
        CASE
            WHEN congress2002.generalresults LIKE '%Un%' THEN 1
            ELSE NULL
        END AS gewinner,
        congress2002.notes,
        CASE
            WHEN congress2002.party IN (
                'W',
                'W(RTL) ',
                'W(RTL)',
                'W(R)',
                'W(LBT)',
                'W(R)/W',
                'DFL/W',
                'W(RTL)/RTL',
                'W(D)',
                'W(DCG)',
                'GRN/W',
                'W(C)',
                'W(CON)',
                'W(LBT)  ',
                'W(IG)',
                'W(GRN)',
                'W(PRO)',
                'W(WG)',
                'W(LBT)/LBT',
                'R/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2002
    WHERE
        congress2002.lastnamefirst IS NOT NULL
        AND congress2002.party NOT IN (
            'R/C',
            'R/C/IDP/RTL',
            'R/IDP',
            'R/IDP/C',
            'D/WF',
            'D/IDP/C/WF',
            'D/IDP/L/WF',
            'D/L',
            'D/IDP/WF',
            'D/UC',
            'R/IDP/C/RTL',
            'R/C/RTL',
            'D/L/WF'
        )
    UNION
    SELECT
        congress2002.statename   postal,
        congress2002.district,
        congress2002.fecid,
        nvl2(congress2002.incumbentindicator, 1, 0) incumbent,
        congress2002.firstname   candidatenamefirst,
        congress2002.lastname    candidatenamelast,
        congress2002.lastname
        || ','
        || ' '
        || congress2002.firstname candidatename,
        TRIM(congress2002.totalvotes) party,
        to_number(regexp_replace(congress2002.party, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2002.runoffresults, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2002.generalresults, '\D+')) generalvotes,
        to_number(regexp_replace(congress2002.generalrunoffresults, '\D+')) gerunoffelectionvotes,
        NULL gewinner,
        congress2002.notes,
        0 writein
    FROM
        congress2002
    WHERE
        congress2002.fecid IS NOT NULL
        AND congress2002.lastnamefirst IS NULL
), pg2004 AS (
    SELECT
        presgeneral2004.statenameabbreviation   postal,
        presgeneral2004.statename,
        presgeneral2004.fecid,
        presgeneral2004.firstname               candidatenamefirst,
        presgeneral2004.lastname                candidatenamelast,
        presgeneral2004.lastnamefirst           candidatename,
        TRIM(presgeneral2004.party) party,
        to_number(regexp_replace(presgeneral2004.generalresults, '\D+')) generalvotes,
        presgeneral2004.notes,
        TO_DATE(presgeneral2004.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
        CASE
            WHEN presgeneral2004.party = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2004
    WHERE
        presgeneral2004.lastnamefirst IS NOT NULL
        AND ( presgeneral2004.totalvotes NOT LIKE '%Comb%'
              OR presgeneral2004.totalvotes IS NULL )
), pp2004 AS (
    SELECT
        presprimary2004.statenameabbreviation   postal,
        presprimary2004.statename,
        presprimary2004.fecid,
        presprimary2004.firstname               candidatenamefirst,
        presprimary2004.lastname                candidatenamelast,
        presprimary2004.lastnamefirst           candidatename,
        CASE
            WHEN presprimary2004.party = 'W(PFP)'  THEN 'PFP'
            WHEN presprimary2004.party = 'W(R)'    THEN 'R'
            WHEN presprimary2004.party = 'W(LBT)'  THEN 'LBT'
            WHEN presprimary2004.party = 'UN(D)'   THEN 'D'
            WHEN presprimary2004.party = 'W(D)'    THEN 'D'
            WHEN presprimary2004.party = 'UN(AIP)' THEN 'AIP'
            WHEN presprimary2004.party = 'W(GRN)'  THEN 'GRN'
            ELSE TRIM(presprimary2004.party)
        END party,
        to_number(regexp_replace(presprimary2004.primaryresults, '\D+')) primaryvotes,
        presprimary2004.notes,
        TO_DATE(presprimary2004.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        CASE
            WHEN presprimary2004.party IN (
                'W',
                'W(PFP)',
                'W(R)',
                'W(LBT)',
                'W(D)',
                'W(GRN)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        presprimary2004
    WHERE
        presprimary2004.lastnamefirst IS NOT NULL
), c2004 AS (
    SELECT
        congress2004.statenameabbreviation   postal,
        congress2004.statename,
        congress2004.district,
        congress2004.fecid,
        nvl2(congress2004.incumbentindicator, 1, 0) incumbent,
        congress2004.firstname               candidatefirstname,
        congress2004.lastname                candidatenamelast,
        congress2004.lastnamefirst           candidatename,
        CASE
            WHEN congress2004.party = 'W(D)/D'  THEN 'D'
            WHEN congress2004.party = 'U (SEP)' THEN 'SEP'
            WHEN congress2004.party = 'N(D)'    THEN 'D'
            WHEN congress2004.party = 'W(R)'    THEN 'R'
            WHEN congress2004.party = 'D/W'     THEN 'D'
            WHEN congress2004.party = 'W(LBT)'  THEN 'LBT'
            WHEN congress2004.party = 'N(R)'    THEN 'R'
            WHEN congress2004.party = 'N(GRN)'  THEN 'GRN'
            WHEN congress2004.party = 'N(NB)'   THEN 'NB'
            WHEN congress2004.party = 'W(R)/W'  THEN 'R'
            WHEN congress2004.party = 'W(R)/R'  THEN 'R'
            WHEN congress2004.party = 'W(D)'    THEN 'D'
            WHEN congress2004.party = 'W(DCG)'  THEN 'DCG'
            WHEN congress2004.party = 'W(C)'    THEN 'C'
            WHEN congress2004.party = 'W(CON)'  THEN 'CON'
            WHEN congress2004.party = 'N(LBT)'  THEN 'LBT'
            WHEN congress2004.party = 'W(WF)'   THEN 'WF'
            WHEN congress2004.party = 'W(NPP)'  THEN 'NPP'
            WHEN congress2004.party = 'W(GR)'   THEN 'GR'
            WHEN congress2004.party = 'W(GRN)'  THEN 'GRN'
            WHEN congress2004.party = 'W(PRO)'  THEN 'PRO'
            WHEN congress2004.party = 'W(WG)'   THEN 'WG'
            WHEN congress2004.party = 'D/NP'    THEN 'D'
            ELSE TRIM(congress2004.party)
        END party,
        to_number(regexp_replace(congress2004.primary, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2004.runoff, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2004.general, '\D+')) generalvotes,
        to_number(regexp_replace(congress2004.gerunoff, '\D+')) gerunoffelectionvotes,
        CASE
            WHEN congress2004.general LIKE '%Un%' THEN 1
            ELSE NULL
        END gewinner,
        congress2004.notes,
        CASE
            WHEN congress2004.party IN (
                'W',
                'W(D)/D',
                'W(R)',
                'D/W',
                'W(LBT)',
                'W(R)/W',
                'W(R)/R',
                'W(D)',
                'W(DCG)',
                'W(C)',
                'W(CON)',
                'W(WF)',
                'W(NPP)',
                'W(GR)',
                'W(GRN)',
                'W(PRO)',
                'W(WG)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2004
    WHERE
        congress2004.lastnamefirst IS NOT NULL
        AND ( congress2004.runoffpct NOT LIKE '%Comb%'
              OR congress2004.runoffpct IS NULL )
), c2006 AS (
    SELECT
        congress2006.statenameabbreviation   postal,
        congress2006.statename,
        congress2006.district,
        congress2006.fecid,
        nvl2(congress2006.incumbentindicator, 1, 0) incumbent,
        congress2006.firstname               candidatenamefirst,
        congress2006.lastname                candidatenamelast,
        congress2006.lastnamefirst           candidatename,
        CASE
            WHEN congress2006.party = 'REP'         THEN 'R'
            WHEN congress2006.party = 'W(PAF)'      THEN 'PAF'
            WHEN congress2006.party = 'REP*'        THEN 'R'
            WHEN congress2006.party = 'W(DEM)/DEM*' THEN 'D'
            WHEN congress2006.party = 'U (IND)'     THEN 'IND'
            WHEN congress2006.party = 'W(LBT)'      THEN 'LBT'
            WHEN congress2006.party = 'DEM '        THEN 'D'
            WHEN congress2006.party = 'W (REP)/REP' THEN 'R'
            WHEN congress2006.party = 'DEM/W'       THEN 'D'
            WHEN congress2006.party = 'W(REP)'      THEN 'R'
            WHEN congress2006.party = 'REP '        THEN 'R'
            WHEN congress2006.party = 'REP/IND'     THEN 'R'
            WHEN congress2006.party = 'W(DEM)'      THEN 'D'
            WHEN congress2006.party = 'REP/W'       THEN 'R'
            WHEN congress2006.party = 'W(DCG)'      THEN 'DCG'
            WHEN congress2006.party = 'W(IND)'      THEN 'IND'
            WHEN congress2006.party = 'W(LU)'       THEN 'LU'
            WHEN congress2006.party = 'W(CON)'      THEN 'CON'
            WHEN congress2006.party = 'DEM'         THEN 'D'
            WHEN congress2006.party = 'GRE/W'       THEN 'GRE'
            WHEN congress2006.party = 'W (DEM)/DEM' THEN 'D'
            WHEN congress2006.party = 'GRE*'        THEN 'GRE'
            WHEN congress2006.party = 'W(IDP)'      THEN 'IDP'
            WHEN congress2006.party = 'DEM/CFL*'    THEN 'D'
            WHEN congress2006.party = 'N(DEM)'      THEN 'D'
            WHEN congress2006.party = 'N(REP)'      THEN 'R'
            WHEN congress2006.party = 'W(DEM)/DEM'  THEN 'D'
            WHEN congress2006.party = 'W(PRO)'      THEN 'PRO'
            WHEN congress2006.party = 'W(WG)'       THEN 'WG'
            WHEN congress2006.party = 'W(LBT)/LBT'  THEN 'LBT'
            WHEN congress2006.party = 'W(REP)/REP'  THEN 'R'
            ELSE TRIM(congress2006.party)
        END party,
        to_number(regexp_replace(congress2006.primary, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2006.runoff, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2006.general, '\D+')) generalvotes,
        to_number(regexp_replace(congress2006.gerunoff, '\D+')) gerunoffelectionvotes,
        CASE
            WHEN congress2006.general LIKE '%Un%' THEN 1
            ELSE NULL
        END gewinner,
        congress2006.notes,
        CASE
            WHEN congress2006.party IN (
                'W',
                'W(PAF)',
                'W(DEM)/DEM*',
                'W(LBT)',
                'W (REP)/REP',
                'DEM/W',
                'W(REP)',
                'W(DEM)',
                'REP/W',
                'W(DCG)',
                'W(IND)',
                'W(LU)',
                'W(CON)',
                'GRE/W',
                'W (DEM)/DEM',
                'W(IDP)',
                'W(DEM)/DEM',
                'W(PRO)',
                'W(WG)',
                'W(LBT)/LBT',
                'W(REP)/REP'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2006
    WHERE
        congress2006.lastnamefirst IS NOT NULL
), pg2008 AS (
    SELECT
        presgeneral2008.statenameabbreviation   postal,
        presgeneral2008.statename,
        presgeneral2008.fecid,
        presgeneral2008.firstname               candidatenamefirst,
        presgeneral2008.lastname                candidatenamelast,
        presgeneral2008.lastnamefirst           candidatename,
        TRIM(presgeneral2008.party) party,
        to_number(regexp_replace(presgeneral2008.generalresults, '\D+')) generalvotes,
        TO_DATE(presgeneral2008.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
        CASE
            WHEN replace(presgeneral2008.party, ' ', '') = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2008
    WHERE
        presgeneral2008.lastnamefirst IS NOT NULL
        AND presgeneral2008.party NOT LIKE '%Comb%'
), pp2008 AS (
    SELECT
        presprimary2008.statenameabbreviation   postal,
        presprimary2008.statename,
        presprimary2008.fecid,
        presprimary2008.firstname               candidatenamefirst,
        presprimary2008.lastname                candidatenamelast,
        presprimary2008.lastnamefirst           candidatename,
        CASE
            WHEN presprimary2008.party = 'W(R)'   THEN 'R'
            WHEN presprimary2008.party = 'W(AIP)' THEN 'AIP'
            WHEN presprimary2008.party = 'W(LIB)' THEN 'LIB'
            WHEN presprimary2008.party = 'W(D)'   THEN 'D'
            WHEN presprimary2008.party = 'W(DCG)' THEN 'DCG'
            WHEN presprimary2008.party = 'W(LU)'  THEN 'LU'
            ELSE TRIM(presprimary2008.party)
        END party,
        to_number(regexp_replace(presprimary2008.primaryresults, '\D+')) primaryvotes,
        TO_DATE(presprimary2008.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        CASE
            WHEN presprimary2008.party IN (
                'W',
                'W(R)',
                'W(AIP)',
                'W(LIB)',
                'W(D)',
                'W(DCG)',
                'W(LU)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        presprimary2008
    WHERE
        presprimary2008.lastnamefirst IS NOT NULL
), c2008 AS (
    SELECT
        congress2008.statenameabbreviation   postal,
        congress2008.statename,
        congress2008.district,
        congress2008.fecid,
        nvl2(congress2008.incumbentindicator, 1, 0) incumbent,
        congress2008.candidatenamefirst,
        congress2008.candidatenamelast,
        congress2008.candidatename,
        CASE
            WHEN congress2008.party = 'N(D)'       THEN 'D'
            WHEN congress2008.party = 'W(R)'       THEN 'R'
            WHEN congress2008.party = 'W (D)'      THEN 'D'
            WHEN congress2008.party = 'D/W'        THEN 'D'
            WHEN congress2008.party = 'N(R)'       THEN 'R'
            WHEN congress2008.party = 'N(NB)'      THEN 'NB'
            WHEN congress2008.party = 'W(LBT)'     THEN 'LBT'
            WHEN congress2008.party = 'W(R)/W'     THEN 'R'
            WHEN congress2008.party = 'W(R)/R'     THEN 'R'
            WHEN congress2008.party = 'W(LBT)/I'   THEN 'LBT'
            WHEN congress2008.party = 'D/R'        THEN 'D'
            WHEN congress2008.party = 'W(D)'       THEN 'D'
            WHEN congress2008.party = 'W(DCG)'     THEN 'DCG'
            WHEN congress2008.party = 'W(D)/W'     THEN 'D'
            WHEN congress2008.party = 'D'          THEN 'D'
            WHEN congress2008.party = 'W(CON)'     THEN 'CON'
            WHEN congress2008.party = 'W(LU)'      THEN 'LU'
            WHEN congress2008.party = 'W(LBT)/W'   THEN 'LBT'
            WHEN congress2008.party = 'W(WF)'      THEN 'WF'
            WHEN congress2008.party = 'R/IP#'      THEN 'R'
            WHEN congress2008.party = 'D/IP'       THEN 'D'
            WHEN congress2008.party = 'W(NPP)'     THEN 'NPP'
            WHEN congress2008.party = 'W(GR)'      THEN 'GR'
            WHEN congress2008.party = 'NPA*'       THEN 'NPA'
            WHEN congress2008.party = 'R'          THEN 'R'
            WHEN congress2008.party = 'N(GRE)'     THEN 'GRE'
            WHEN congress2008.party = 'W(PRO)'     THEN 'PRO'
            WHEN congress2008.party = 'W(WG)'      THEN 'WG'
            WHEN congress2008.party = 'W(LBT)/LBT' THEN 'LBT'
            WHEN congress2008.party = 'R/W'        THEN 'R'
            ELSE TRIM(congress2008.party)
        END party,
        to_number(regexp_replace(congress2008.primary, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2008.runoff, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2008.general, '\D+')) generalvotes,
        to_number(regexp_replace(congress2008.gerunoff, '\D+')) gerunoffelectionvotes,
        CASE
            WHEN congress2008.general LIKE '%Un%' THEN 1
            ELSE NULL
        END gewinner,
        congress2008.footnotes               notes,
        CASE
            WHEN congress2008.party IN (
                'W',
                'W(R)',
                'W (D)',
                'D/W',
                'W(LBT)',
                'W(R)/W',
                'W(R)/R',
                'W(LBT)/I',
                'W(D)',
                'W(DCG)',
                'W(D)/W',
                'W(CON)',
                'W(LU)',
                'W(LBT)/W',
                'W(WF)',
                'W(NPP)',
                'W(GR)',
                'W(PRO)',
                'W(WG)',
                'W(LBT)/LBT',
                'R/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2008
    WHERE
        congress2008.candidatename IS NOT NULL
), c2010 AS (
    SELECT
        congress2010.statenameabbreviation   postal,
        congress2010.statename,
        congress2010.district,
        congress2010.fecid,
        nvl2(congress2010.incumbentindicator, 1, 0) incumbent,
        congress2010.candidatenamefirst,
        congress2010.candidatenamelast,
        congress2010.candidatename,
        CASE
            WHEN congress2010.party = 'W(AIP)'                 THEN 'AIP'
            WHEN congress2010.party = 'DEM/W'                  THEN 'DEM'
            WHEN congress2010.party = 'W(LIB)/LIB'             THEN 'LIB'
            WHEN congress2010.party = 'W(LIB)'                 THEN 'LIB'
            WHEN congress2010.party = 'W(GRE)'                 THEN 'GRE'
            WHEN congress2010.party = 'W(REP)'                 THEN 'REP'
            WHEN congress2010.party = 'PG/PRO'                 THEN 'PRO'
            WHEN congress2010.party = 'DEM/IND'                THEN 'DEM'
            WHEN congress2010.party = 'W(DEM)'                 THEN 'DEM'
            WHEN congress2010.party = 'W(DCG)'                 THEN 'DCG'
            WHEN congress2010.party = 'W(DEM'                  THEN 'DEM'
            WHEN congress2010.party = 'REP/W'                  THEN 'REP'
            WHEN congress2010.party = 'APP/LIB'                THEN 'LIB'
            WHEN congress2010.party = 'IP*'                    THEN 'IP'
            WHEN congress2010.party = 'W(CRV)'                 THEN 'CRV'
            WHEN congress2010.party = 'CRV/TX'                 THEN 'CRV'
            WHEN congress2010.party = 'W (Challenged Counted)' THEN 'W'
            WHEN congress2010.party = 'W(DEM)/DEM'             THEN 'DEM'
            WHEN congress2010.party = 'N(REP)'                 THEN 'REP'
            WHEN congress2010.party = 'N(DEM)'                 THEN 'DEM'
            WHEN congress2010.party = 'W(DNL)'                 THEN 'DNL'
            WHEN congress2010.party = 'W(CON)/CON'             THEN 'CON'
            WHEN congress2010.party = 'DEM/PRO/WF'             THEN 'DEM'
            WHEN congress2010.party = 'W(PRO)'                 THEN 'PRO'
            WHEN congress2010.party = 'W(WG)'                  THEN 'WG'
            WHEN congress2010.party = 'REP/W***'               THEN 'REP'
            WHEN congress2010.party = 'W(GRE)/GRE'             THEN 'GRE'
            WHEN congress2010.party = 'W(REP)/REP'             THEN 'REP'
            WHEN congress2010.party = 'W(REP)/W'               THEN 'REP'
            WHEN congress2010.party = 'REP/TRP'                THEN 'REP'
            ELSE TRIM(congress2010.party)
        END party,
        to_number(regexp_replace(congress2010.primary, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2010.runoff, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2010.general, '\D+')) generalvotes,
        CASE
            WHEN congress2010.general LIKE '%Un%' THEN 1
            ELSE NULL
        END gewinner,
        congress2010.footnotes               notes,
        CASE
            WHEN congress2010.party IN (
                'W',
                'W(AIP)',
                'DEM/W',
                'W(LIB)/LIB',
                'W(LIB)',
                'W(GRE)',
                'W(REP)',
                'W(DEM)',
                'W(DCG)',
                'W(DEM',
                'REP/W',
                'W(CRV)',
                'W (Challenged Counted)',
                'W(DEM)/DEM',
                'N(REP)',
                'N(DEM)',
                'W(DNL)',
                'W(CON)/CON',
                'W(PRO)',
                'W(WG)',
                'REP/W***',
                'W(GRE)/GRE',
                'W(REP)/REP',
                'W(REP)/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2010
    WHERE
        congress2010.candidatename IS NOT NULL
        AND ( congress2010.runoff NOT LIKE '%Comb'
              OR congress2010.runoff IS NULL )
        AND congress2010.party != 'W (Challenged NOT Counted)'
), pg2012 AS (
    SELECT
        presgeneral2012.statenameabbreviation   postal,
        presgeneral2012.statename,
        presgeneral2012.fecid,
        presgeneral2012.firstname               candidatenamefirst,
        presgeneral2012.lastname                candidatenamelast,
        presgeneral2012.lastnamefirst           candidatename,
        TRIM(presgeneral2012.party) party,
        to_number(regexp_replace(presgeneral2012.generalresults, '\D+')) generalvotes,
        nvl2(presgeneral2012.winnerindicator, 1, 0) gewinner,
        TO_DATE(presgeneral2012.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
        CASE
            WHEN presgeneral2012.party = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2012
    WHERE
        presgeneral2012.lastnamefirst IS NOT NULL
        AND presgeneral2012.party NOT LIKE '%Comb%'
), pp2012 AS (
    SELECT
        presprimary2012.statenameabbreviation   postal,
        presprimary2012.statename,
        presprimary2012.fecid,
        presprimary2012.firstname               candidatenamefirst,
        presprimary2012.lastname                candidatenamelast,
        presprimary2012.lastnamefirst           candidatename,
        CASE
            WHEN presprimary2012.party = 'W(R)'   THEN 'R'
            WHEN presprimary2012.party = 'W(AIP)' THEN 'AIP'
            WHEN presprimary2012.party = 'W(D)'   THEN 'D'
            WHEN presprimary2012.party = 'W(DCG)' THEN 'DCG'
            WHEN presprimary2012.party = 'W(GR)'  THEN 'GR'
            ELSE TRIM(presprimary2012.party)
        END party,
        to_number(regexp_replace(presprimary2012.primaryresults, '\D+')) primaryvotes,
        TO_DATE(presprimary2012.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        CASE
            WHEN presprimary2012.party IN (
                'W',
                'W(R)',
                'W(AIP)',
                'W(D)',
                'W(DCG)',
                'W(GR)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        presprimary2012
    WHERE
        presprimary2012.lastnamefirst IS NOT NULL
), c2012 AS (
    SELECT
        congress2012.statenameabbreviation   postal,
        congress2012.statename,
        congress2012.d                       district,
        congress2012.fecid,
        nvl2(congress2012.incumbent, 1, 0) incumbent,
        congress2012.candidatenamefirst,
        congress2012.candidatenamelast,
        congress2012.candidatename,
        CASE
            WHEN congress2012.party = 'W(PAF)'     THEN 'PAF'
            WHEN congress2012.party = 'W(D)/D'     THEN 'D'
            WHEN congress2012.party = 'N(D)'       THEN 'D'
            WHEN congress2012.party = 'R/CON'      THEN 'R'
            WHEN congress2012.party = 'W(AE)/AE'   THEN 'AE'
            WHEN congress2012.party = 'W(R)'       THEN 'R'
            WHEN congress2012.party = 'D/W'        THEN 'D'
            WHEN congress2012.party = 'W(R)/W'     THEN 'R'
            WHEN congress2012.party = 'N(R)'       THEN 'R'
            WHEN congress2012.party = 'W(LIB)/LIB' THEN 'LIB'
            WHEN congress2012.party = 'W(R)/R'     THEN 'R'
            WHEN congress2012.party = 'W(LIB)'     THEN 'LIB'
            WHEN congress2012.party = 'W(GRE)'     THEN 'GRE'
            WHEN congress2012.party = 'D/WF'       THEN 'D'
            WHEN congress2012.party = 'D/IND'      THEN 'D'
            WHEN congress2012.party = 'W(AE)'      THEN 'AE'
            WHEN congress2012.party = 'W(D)'       THEN 'D'
            WHEN congress2012.party = 'W(DCG)'     THEN 'DCG'
            WHEN congress2012.party = 'W(IND)'     THEN 'IND'
            WHEN congress2012.party = 'W(CON)'     THEN 'CON'
            WHEN congress2012.party = 'R/TRP'      THEN 'R'
            WHEN congress2012.party = 'W(GR)'      THEN 'GR'
            WHEN congress2012.party = 'CRV/LIB'    THEN 'CRV'
            WHEN congress2012.party = 'W(DNL)'     THEN 'DNL'
            WHEN congress2012.party = 'W(PRO)'     THEN 'PRO'
            WHEN congress2012.party = 'W(GRE)/GRE' THEN 'GRE'
            WHEN congress2012.party = 'D/PRO/WF'   THEN 'D'
            ELSE TRIM(congress2012.party)
        END party,
        to_number(regexp_replace(congress2012.primaryvotes, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2012.runoffvotes, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2012.generalvotes, '\D+')) generalvotes,
        to_number(regexp_replace(congress2012.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
        nvl2(congress2012.gewinnerindicator, 1, 0) gewinner,
        congress2012.footnotes               notes,
        CASE
            WHEN congress2012.party IN (
                'W',
                'W(PAF)',
                'W(D)/D',
                'W(AE)/AE',
                'W(R)',
                'D/W',
                'W(R)/W',
                'W(LIB)/LIB',
                'W(R)/R',
                'W(LIB)',
                'W(GRE)',
                'D/WF',
                'W(AE)',
                'W(D)',
                'W(DCG)',
                'W(IND)',
                'W(CON)',
                'W(GR)',
                'W(DNL)',
                'W(PRO)',
                'W(GRE)/GRE'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        congress2012
    WHERE
        congress2012.d IS NOT NULL
        AND congress2012.candidatename IS NOT NULL
        AND congress2012.party NOT IN (
            'R/CRV/IDP Combined Parties',
            'D/WF Combined Parties',
            'R/CRV/IDP/TRP Combined Parties',
            'R/TRP Combined Parties',
            'D/WF/IDP Combined Parties',
            'R/CRV/TRP Combined Parties',
            'D/IDP/WF Combined Parties',
            'R/CRV Combined Parties',
            'R/IDP Combined Parties',
            'R/CRV/LIB Combined Parties'
        )
    UNION
    SELECT
        congress2012.statenameabbreviation   postal,
        congress2012.statename,
        congress2012.d                       district,
        congress2012.fecid,
        nvl2(congress2012.incumbent, 1, 0) incumbent,
        congress2012.candidatenamefirst,
        congress2012.candidatename           candidatenamelast,
        congress2012.candidatenamelast       candidatename,
        TRIM(congress2012.totalvotes) party,
        to_number(regexp_replace(congress2012.party, '\D+')) primaryvotes,
        to_number(regexp_replace(congress2012.primarypct, '\D+')) runoffvotes,
        to_number(regexp_replace(congress2012.runoffpct, '\D+')) generalvotes,
        to_number(regexp_replace(congress2012.generalpct, '\D+')) gerunoffelectionvotes,
        nvl2(congress2012.gewinnerindicator, 1, 0) gewinner,
        congress2012.footnotes               notes,
        0 writein
    FROM
        congress2012
    WHERE
        congress2012.d IS NOT NULL
        AND congress2012.fecid IS NOT NULL
        AND congress2012.candidatename IS NULL
), h2014 AS (
    SELECT
        house2014.statenameabbreviation   postal,
        house2014.statename,
        house2014.d                       district,
        house2014.fecid,
        house2014.candidatenamefirst,
        house2014.candidatenamelast,
        house2014.candidatename,
        CASE
            WHEN house2014.party = 'W(NOP)'     THEN 'NOP'
            WHEN house2014.party = 'W(PAF)/PAF' THEN 'PAF'
            WHEN house2014.party = 'N(D)'       THEN 'D'
            WHEN house2014.party = 'W(AE)/AE'   THEN 'AE'
            WHEN house2014.party = 'W(AIP)'     THEN 'AIP'
            WHEN house2014.party = 'W(R)'       THEN 'R'
            WHEN house2014.party = 'D/W'        THEN 'D'
            WHEN house2014.party = 'N(R)'       THEN 'R'
            WHEN house2014.party = 'N(LIB)'     THEN 'LIB'
            WHEN house2014.party = 'R/CON*'     THEN 'R'
            WHEN house2014.party = 'W(R)/W'     THEN 'R'
            WHEN house2014.party = 'W(LIB)/LIB' THEN 'LIB'
            WHEN house2014.party = 'W(LIB)'     THEN 'LIB'
            WHEN house2014.party = 'W(R)/R'     THEN 'R'
            WHEN house2014.party = 'W(D)'       THEN 'D'
            WHEN house2014.party = 'W(DCG)'     THEN 'DCG'
            WHEN house2014.party = 'W(CON)'     THEN 'CON'
            WHEN house2014.party = 'R/TRP'      THEN 'R'
            WHEN house2014.party = 'CRV/LIB'    THEN 'CRV'
            WHEN house2014.party = 'R'          THEN 'R'
            WHEN house2014.party = 'W(DNL)'     THEN 'DWL'
            WHEN house2014.party = 'W(LBU)'     THEN 'LBU'
            WHEN house2014.party = 'W(PRO)'     THEN 'PRO'
            WHEN house2014.party = 'R/W'        THEN 'R'
            ELSE TRIM(house2014.party)
        END party,
        to_number(regexp_replace(house2014.primaryvotes, '\D+')) primaryvotes,
        to_number(regexp_replace(house2014.runoffvotes, '\D+')) runoffvotes,
        to_number(regexp_replace(house2014.generalvotes, '\D+')) generalvotes,
        to_number(regexp_replace(house2014.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
        nvl2(house2014.gewinnerindicator, 1, 0) gewinner,
        house2014.footnotes               notes,
        CASE
            WHEN house2014.party IN (
                'W',
                'W(NOP)',
                'W(PAF)/PAF',
                'W(AE)/AE',
                'W(AIP)',
                'W(R)',
                'D/W',
                'W(R)/W',
                'W(LIB)/LIB',
                'W(LIB)',
                'W(R)/R',
                'W(D)',
                'W(DCG)',
                'W(CON)',
                'W(DNL)',
                'W(LBU)',
                'W(PRO)',
                'R/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        house2014
    WHERE
        house2014.candidatename IS NOT NULL
        AND house2014.party != 'Combined Parties:'
), s2014 AS (
    SELECT
        senate2014.statenameabbreviation   postal,
        senate2014.statename,
        senate2014.d                       district,
        senate2014.fecid,
        nvl2(senate2014.incumbent, 1, 0) incumbent,
        senate2014.candidatenamefirst,
        senate2014.candidatenamelast,
        senate2014.candidatename,
        CASE
            WHEN senate2014.party = 'W(R)'   THEN 'R'
            WHEN senate2014.party = 'N(R)'   THEN 'R'
            WHEN senate2014.party = 'W(D)'   THEN 'D'
            WHEN senate2014.party = 'N(DEM)' THEN 'D'
            WHEN senate2014.party = 'R/W'    THEN 'R'
            ELSE TRIM(senate2014.party)
        END party,
        to_number(regexp_replace(senate2014.primaryvotes, '\D+')) primaryvotes,
        to_number(regexp_replace(senate2014.runoffvotes, '\D+')) runoffvotes,
        to_number(regexp_replace(senate2014.generalvotes, '\D+')) generalvotes,
        to_number(regexp_replace(senate2014.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
        nvl2(senate2014.gewinnerindicator, 1, 0) gewinner,
        senate2014.footnotes               notes,
        CASE
            WHEN senate2014.party IN (
                'W',
                'W(R)',
                'N(R)',
                'W(D)',
                'R',
                'N(DEM)',
                'R/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        senate2014
    WHERE
        senate2014.candidatename IS NOT NULL
), pg2016 AS (
    SELECT
        presgeneral2016.statenameabbreviation   postal,
        presgeneral2016.statename,
        presgeneral2016.fecid,
        presgeneral2016.lastname                candidatenamelast,
        presgeneral2016.firstname               candidatenamefirst,
        presgeneral2016.lastnamefirst           candidatename,
        CASE
            WHEN presgeneral2016.party = 'REP'     THEN 'R'
            WHEN presgeneral2016.party = 'PG/PRO'  THEN 'PRO'
            WHEN presgeneral2016.party = 'REP/AIP' THEN 'R'
            WHEN presgeneral2016.party = 'DEM'     THEN 'D'
            ELSE TRIM(presgeneral2016.party)
        END party,
        to_number(regexp_replace(presgeneral2016.generalresults, '\D+')) generalvotes,
        nvl2(presgeneral2016.winnerindicator, 1, 0) gewinner,
        TO_DATE(presgeneral2016.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
        CASE
            WHEN presgeneral2016.party = 'W' THEN 1
            ELSE 0
        END writein
    FROM
        presgeneral2016
    WHERE
        presgeneral2016.lastnamefirst IS NOT NULL
        AND presgeneral2016.party != 'Combined Parties:'
), pp2016 AS (
    SELECT
        presprimary2016.statenameabbreviation   postal,
        presprimary2016.statename,
        presprimary2016.fecid,
        presprimary2016.firstname               candidatenamefirst,
        presprimary2016.lastname                candidatenamelast,
        presprimary2016.lastnamefirst           candidatename,
        CASE
            WHEN presprimary2016.party = 'W(R)'  THEN 'R'
            WHEN presprimary2016.party = 'W(D)'  THEN 'D'
            WHEN presprimary2016.party = 'W(GR)' THEN 'GR'
            WHEN presprimary2016.party = 'W(IP)' THEN 'IP'
            ELSE TRIM(presprimary2016.party)
        END party,
        to_number(regexp_replace(presprimary2016.primaryresults, '\D+')) primaryvotes,
        TO_DATE(presprimary2016.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        presprimary2016.footnotes               notes,
        CASE
            WHEN presprimary2016.party IN (
                'W',
                'W(R)',
                'W(D)',
                'W(GR)',
                'W(IP)'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        presprimary2016
    WHERE
        presprimary2016.lastnamefirst IS NOT NULL
), h2016 AS (
    SELECT
        house2016.statenameabbreviation   postal,
        house2016.statename,
        house2016.d                       district,
        house2016.fecid,
        nvl2(house2016.incumbent, 1, 0) incumbent,
        house2016.candidatenamefirst,
        house2016.candidatenamelast,
        house2016.candidatename,
        CASE
            WHEN house2016.party = 'W(NOP)'      THEN 'NOP'
            WHEN house2016.party = 'W(D)/D'      THEN 'D'
            WHEN house2016.party = 'R/CON'       THEN 'R'
            WHEN house2016.party = 'W(R)'        THEN 'R'
            WHEN house2016.party = 'R/IP'        THEN 'R'
            WHEN house2016.party = 'W(PPD)'      THEN 'PPD'
            WHEN house2016.party = 'W(LIB)'      THEN 'LIB'
            WHEN house2016.party = 'W(GRE)'      THEN 'GRE'
            WHEN house2016.party = 'W(R)/R'      THEN 'R'
            WHEN house2016.party = 'IP/R'        THEN 'IP'
            WHEN house2016.party = 'D/R'         THEN 'D'
            WHEN house2016.party = 'W(D)'        THEN 'D'
            WHEN house2016.party = 'W(DCG)'      THEN 'DCG'
            WHEN house2016.party = 'W(IND)'      THEN 'IND'
            WHEN house2016.party = 'D/PRO/WF/IP' THEN 'D'
            WHEN house2016.party = 'W(D)/W'      THEN 'D'
            WHEN house2016.party = 'W(CON)'      THEN 'CON'
            WHEN house2016.party = 'R/TRP'       THEN 'R'
            WHEN house2016.party = 'D/IP'        THEN 'D'
            WHEN house2016.party = 'W(NPP)'      THEN 'NPP'
            WHEN house2016.party = 'W(IP)'       THEN 'IP'
            WHEN house2016.party = 'W(DNL)'      THEN 'DNL'
            WHEN house2016.party = 'W(PRO)'      THEN 'PRO'
            WHEN house2016.party = 'W(WG)'       THEN 'WG'
            WHEN house2016.party = 'W(GRE)/GRE'  THEN 'GRE'
            WHEN house2016.party = 'R/W'         THEN 'R'
            ELSE TRIM(house2016.party)
        END party,
        to_number(regexp_replace(house2016.primaryvotes, '\D+')) primaryvotes,
        to_number(regexp_replace(house2016.runoffvotes, '\D+')) runoffvotes,
        to_number(regexp_replace(house2016.generalvotes, '\D+')) generalvotes,
        to_number(regexp_replace(house2016.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
        nvl2(house2016.gewinnerindicator, 1, 0) gewinner,
        house2016.footnotes               notes,
        CASE
            WHEN house2016.party IN (
                'W',
                'W(NOP)',
                'W(D)/D',
                'W(R)',
                'W(PPD)',
                'W(LIB)',
                'W(GRE)',
                'W(R)/R',
                'W(D)',
                'W(DCG)',
                'W(IND)',
                'W(D)/W',
                'W(CON)',
                'W(NPP)',
                'W(IP)',
                'W(DNL)',
                'W(PRO)',
                'W(WG)',
                'W(GRE)/GRE',
                'R/W '
            ) THEN 1
            ELSE 0
        END writein
    FROM
        house2016
    WHERE
        house2016.candidatename IS NOT NULL
    UNION
    SELECT
        house2016.statenameabbreviation   postal,
        house2016.statename,
        house2016.d                       district,
        house2016.fecid,
        nvl2(house2016.incumbent, 1, 0) incumbent,
        house2016.candidatenamefirst,
        house2016.candidatename           candidatenamelast,
        house2016.candidatenamelast       candidatename,
        TRIM(house2016.totalvotes) party,
        to_number(regexp_replace(house2016.party, '\D+')) primaryvotes,
        to_number(regexp_replace(house2016.primarypct, '\D+')) runoffvotes,
        to_number(regexp_replace(house2016.runoffpct, '\D+')) generalvotes,
        to_number(regexp_replace(house2016.generalpct, '\D+')) gerunoffelectionvotes,
        nvl2(house2016.combinedpct, 1, 0) gewinner,
        house2016.footnotes               notes,
        0 writein
    FROM
        house2016
    WHERE
        house2016.fecid IS NOT NULL
        AND house2016.candidatename IS NULL
), s2016 AS (
    SELECT
        senate2016.statenameabbreviation   postal,
        senate2016.statename,
        senate2016.d                       district,
        senate2016.fecid,
        senate2016.candidatenamefirst,
        senate2016.candidatenamelast,
        CASE
            WHEN senate2016.party = 'W(R)'   THEN 'R'
            WHEN senate2016.party = 'N(R)'   THEN 'R'
            WHEN senate2016.party = 'W(D)'   THEN 'D'
            WHEN senate2016.party = 'N(DEM)' THEN 'D'
            WHEN senate2016.party = 'R/W'    THEN 'R'
            ELSE TRIM(senate2016.party)
        END party,
        to_number(regexp_replace(senate2016.primaryvotes, '\D+')) primaryvotes,
        to_number(regexp_replace(senate2016.runoffvotes, '\D+')) runoffvotes,
        to_number(regexp_replace(senate2016.generalvotes, '\D+')) generalvotes,
        to_number(regexp_replace(senate2016.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
        nvl2(senate2016.gewinnerindicator, 1, 0) gewinner,
        senate2016.footnotes               notes,
        CASE
            WHEN senate2016.party IN (
                'W',
                'DRP',
                'W(R)',
                'N(R)',
                'PET',
                'W(D)',
                'BQT',
                'AKI',
                'R',
                'N(DEM)',
                'R/W'
            ) THEN 1
            ELSE 0
        END writein
    FROM
        senate2016
    WHERE
        senate2016.candidatename IS NOT NULL
), postal AS (
    SELECT
        presgeneral2000.statename   postal,
        initcap(presgeneral2000.candidate) statename
    FROM
        presgeneral2000
    WHERE
        presgeneral2000.numberofvotes = 0
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
), pd2002 AS (
    SELECT
        initcap(primarydates2002.statename) statename,
        TO_DATE(primarydates2002.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        TO_DATE(primarydates2002.runoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2002
    WHERE
        primarydates2002.statename IS NOT NULL
), pd2004 AS (
    SELECT
        initcap(primarydates2004.statename) statename,
        TO_DATE(primarydates2004.primary, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        TO_DATE(primarydates2004.runoff, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2004
    WHERE
        primarydates2004.statename IS NOT NULL
), pd2006 AS (
    SELECT
        initcap(primarydates2006.statename) statename,
        add_months(TO_DATE(primarydates2006.primary, 'YYYY-MM-DD HH24:MI:SS'), - 12) primarydate,
        add_months(TO_DATE(primarydates2006.runoff, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
    FROM
        primarydates2006
    WHERE
        primarydates2006.statename IS NOT NULL
), pd2008 AS (
    SELECT
        initcap(primarydates2008.statename) statename,
        add_months(TO_DATE(primarydates2008.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS'), - 12) primarydate,
        add_months(TO_DATE(primarydates2008.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
    FROM
        primarydates2008
    WHERE
        primarydates2008.statename IS NOT NULL
), pd2010 AS (
    SELECT
        initcap(primarydates2010.statename) statename,
        TO_DATE(primarydates2010.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        TO_DATE(primarydates2010.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2010
    WHERE
        primarydates2010.statename IS NOT NULL
), pd2012 AS (
    SELECT
        statename,
        CASE
            WHEN EXTRACT(YEAR FROM primarydate) = 2012 THEN primarydate
            ELSE add_months(primarydate, 12 *(2012 - EXTRACT(YEAR FROM primarydate)))
        END primarydate,
        runoffdate
    FROM
        (
            SELECT
                initcap(primarydates2012.statename) statename,
                CASE
                    WHEN REGEXP_LIKE ( primarydates2012.congressionalprimarydate,
                                       '\/' ) THEN TO_DATE(regexp_substr(primarydates2012.congressionalprimarydate, '^\d\/\d{2}')
                                                           || '/'
                                                           || '2012', 'MM/DD/YYYY')
                    ELSE TO_DATE(primarydates2012.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS')
                END primarydate,
                TO_DATE(primarydates2012.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
            FROM
                primarydates2012
            WHERE
                primarydates2012.statename IS NOT NULL
        )
), pd2014 AS (
    SELECT
        initcap(primarydates2014.statename) statename,
        CASE
            WHEN REGEXP_LIKE ( primarydates2014.congressionalprimarydate,
                               '\/' ) THEN TO_DATE(regexp_substr(primarydates2014.congressionalprimarydate, '^\d\/\d+')
                                                   || '/'
                                                   || '2014', 'MM/DD/YYYY')
            ELSE TO_DATE(primarydates2014.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS')
        END primarydate,
        TO_DATE(primarydates2014.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2014
    WHERE
        primarydates2014.statename IS NOT NULL
), pd2016 AS (
    SELECT
        initcap(primarydates2016.statename) statename,
        CASE
            WHEN REGEXP_LIKE ( primarydates2016.congressionalprimary,
                               '\/' ) THEN TO_DATE(regexp_substr(primarydates2016.congressionalprimary, '^\d\/\d+')
                                                   || '/'
                                                   || '2016', 'MM/DD/YYYY')
            ELSE add_months(TO_DATE(primarydates2016.congressionalprimary, 'YYYY-MM-DD HH24:MI:SS'), - 12)
        END primarydate,
        add_months(TO_DATE(primarydates2016.congressionalrunoff, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
    FROM
        primarydates2016
    WHERE
        primarydates2016.statename IS NOT NULL
), p2000 AS (
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
                pg2000.postal,
                pg2000.candidatenamefirst,
                pg2000.candidatenamelast,
                pg2000.candidatename,
                pg2000.party,
                SUM(pg2000.generalvotes) generalvotes,
                pg2000.writein
            FROM
                pg2000
            GROUP BY
                pg2000.postal,
                pg2000.candidatenamefirst,
                pg2000.candidatenamelast,
                pg2000.candidatename,
                pg2000.party,
                pg2000.writein
        ) pg
        FULL OUTER JOIN (
            SELECT
                pp2000.postal,
                pp2000.candidatenamefirst,
                pp2000.candidatenamelast,
                pp2000.candidatename,
                pp2000.party,
                SUM(pp2000.primaryvotes) primaryvotes,
                pp2000.writein
            FROM
                pp2000
            GROUP BY
                pp2000.postal,
                pp2000.candidatenamefirst,
                pp2000.candidatenamelast,
                pp2000.candidatename,
                pp2000.party,
                pp2000.writein
        ) pp ON pg.postal = pp.postal
                AND pg.candidatename = pp.candidatename
                AND pg.party = pp.party
), p2004 AS (
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
                pg2004.postal,
                pg2004.statename,
                pg2004.fecid,
                pg2004.candidatenamefirst,
                pg2004.candidatenamelast,
                pg2004.candidatename,
                pg2004.party,
                SUM(pg2004.generalvotes) generalvotes,
                pg2004.notes,
                pg2004.generalelectiondate,
                pg2004.writein
            FROM
                pg2004
            GROUP BY
                pg2004.postal,
                pg2004.statename,
                pg2004.fecid,
                pg2004.candidatenamefirst,
                pg2004.candidatenamelast,
                pg2004.candidatename,
                pg2004.party,
                pg2004.notes,
                pg2004.generalelectiondate,
                pg2004.writein                
        ) pg
        FULL OUTER JOIN (
            SELECT
                pp2004.postal,
                pp2004.statename,
                pp2004.fecid,
                pp2004.candidatenamefirst,
                pp2004.candidatenamelast,
                pp2004.candidatename,
                pp2004.party,
                SUM(pp2004.primaryvotes) primaryvotes,
                pp2004.notes,
                pp2004.primarydate,
                pp2004.writein
            FROM
                pp2004
            GROUP BY
                pp2004.postal,
                pp2004.statename,
                pp2004.fecid,
                pp2004.candidatenamefirst,
                pp2004.candidatenamelast,
                pp2004.candidatename,
                pp2004.party,
                pp2004.notes,
                pp2004.primarydate,
                pp2004.writein                
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), p2008 AS (
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
                pg2008.postal,
                pg2008.statename,
                pg2008.fecid,
                pg2008.candidatenamefirst,
                pg2008.candidatenamelast,
                pg2008.candidatename,
                pg2008.party,
                SUM(pg2008.generalvotes) generalvotes,
                pg2008.generalelectiondate,
                pg2008.writein
            FROM
                pg2008
            GROUP BY
                pg2008.postal,
                pg2008.statename,
                pg2008.fecid,
                pg2008.candidatenamefirst,
                pg2008.candidatenamelast,
                pg2008.candidatename,
                pg2008.party,
                pg2008.generalelectiondate,
                pg2008.writein                
        ) pg
        FULL OUTER JOIN (
            SELECT
                pp2008.postal,
                pp2008.statename,
                pp2008.fecid,
                pp2008.candidatenamefirst,
                pp2008.candidatenamelast,
                pp2008.candidatename,
                pp2008.party,
                SUM(pp2008.primaryvotes) primaryvotes,
                pp2008.primarydate,
                pp2008.writein
            FROM
                pp2008
            GROUP BY
                pp2008.postal,
                pp2008.statename,
                pp2008.fecid,
                pp2008.candidatenamefirst,
                pp2008.candidatenamelast,
                pp2008.candidatename,
                pp2008.party,
                pp2008.primarydate,
                pp2008.writein                
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), p2012 AS (
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
                pg2012.postal,
                pg2012.statename,
                pg2012.fecid,
                pg2012.candidatenamefirst,
                pg2012.candidatenamelast,
                pg2012.candidatename,
                pg2012.party,
                SUM(pg2012.generalvotes) generalvotes,
                pg2012.gewinner,
                pg2012.generalelectiondate,
                pg2012.writein
            FROM
                pg2012
            GROUP BY
                pg2012.postal,
                pg2012.statename,
                pg2012.fecid,
                pg2012.candidatenamefirst,
                pg2012.candidatenamelast,
                pg2012.candidatename,
                pg2012.party,
                pg2012.gewinner,
                pg2012.generalelectiondate,
                pg2012.writein                
        ) pg
        FULL OUTER JOIN (
            SELECT
                pp2012.postal,
                pp2012.statename,
                pp2012.fecid,
                pp2012.candidatenamefirst,
                pp2012.candidatenamelast,
                pp2012.candidatename,
                pp2012.party,
                SUM(pp2012.primaryvotes) primaryvotes,
                pp2012.primarydate,
                pp2012.writein
            FROM
                pp2012
            GROUP BY
                pp2012.postal,
                pp2012.statename,
                pp2012.fecid,
                pp2012.candidatenamefirst,
                pp2012.candidatenamelast,
                pp2012.candidatename,
                pp2012.party,
                pp2012.primarydate,
                pp2012.writein                
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
), p2016 AS (
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
                pg2016.postal,
                pg2016.statename,
                pg2016.fecid,
                pg2016.candidatenamefirst,
                pg2016.candidatenamelast,
                pg2016.candidatename,
                pg2016.party,
                SUM(pg2016.generalvotes) generalvotes,
                pg2016.gewinner,
                pg2016.generalelectiondate,
                pg2016.writein
            FROM
                pg2016
            GROUP BY
                pg2016.postal,
                pg2016.statename,
                pg2016.fecid,
                pg2016.candidatenamefirst,
                pg2016.candidatenamelast,
                pg2016.candidatename,
                pg2016.party,
                pg2016.gewinner,
                pg2016.generalelectiondate,
                pg2016.writein                
        ) pg
        FULL OUTER JOIN (
            SELECT
                pp2016.postal,
                pp2016.statename,
                pp2016.fecid,
                pp2016.candidatenamefirst,
                pp2016.candidatenamelast,
                pp2016.candidatename,
                pp2016.party,
                SUM(pp2016.primaryvotes) primaryvotes,
                pp2016.notes,
                pp2016.primarydate,
                pp2016.writein
            FROM
                pp2016
            GROUP BY
                pp2016.postal,
                pp2016.statename,
                pp2016.fecid,
                pp2016.candidatenamefirst,
                pp2016.candidatenamelast,
                pp2016.candidatename,
                pp2016.party,
                pp2016.notes,
                pp2016.primarydate,
                pp2016.writein                
        ) pp ON pg.postal = pp.postal
                AND pg.fecid = pp.fecid
                AND pg.party = pp.party
)