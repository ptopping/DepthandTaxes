WITH h2000 AS (
    SELECT
        house2000.statename   postal,
        TO_CHAR(house2000.district) district,
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
            ELSE replace(house2000.party, ' ', '')
        END party,
        SUM(regexp_replace(house2000.primaryresults, '\D+')) primaryvotes,
        SUM(regexp_replace(house2000.runoffresults, '\D+')) runoffvotes,
        SUM(regexp_replace(house2000.generalresults, '\D+')) generalvotes,
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
    GROUP BY
        house2000.statename,
        TO_CHAR(house2000.district),
        house2000.name,
        house2000.incumbentindicator,
        house2000.party
), hap_district2000 AS (
    SELECT
        h2000.district,
        h2000.postal,
        h2000.party,
        SUM(h2000.primaryvotes) primaryvotes
    FROM
        h2000
    GROUP BY
        h2000.district,
        h2000.postal,
        h2000.party
), hag_district2000 AS (
    SELECT
        h2000.district,
        h2000.postal,
        SUM(h2000.generalvotes) generalvotes
    FROM
        h2000
    GROUP BY
        h2000.district,
        h2000.postal
), ha_name2000 AS (
    SELECT
        h2000.postal,
        h2000.candidatename,
        h2000.district,
        SUM(h2000.generalvotes) generalvotes
    FROM
        h2000
    GROUP BY
        h2000.postal,
        h2000.candidatename,
        h2000.district
), hmax2000 AS (
    SELECT
        ha_name2000.postal,
        ha_name2000.district,
        MAX(ha_name2000.generalvotes) maxvotes
    FROM
        ha_name2000
    GROUP BY
        ha_name2000.postal,
        ha_name2000.district
), multi AS (
    SELECT
        h2000.postal,
        h2000.candidatename,
        h2000.district,
        COUNT(h2000.generalvotes) cancount
    FROM
        h2000
    GROUP BY
        h2000.postal,
        h2000.candidatename,
        h2000.district
), postal AS (
    SELECT
        presgeneral2000.statename   postal,
        initcap(presgeneral2000.candidate) statename
    FROM
        presgeneral2000
    WHERE
        presgeneral2000.numberofvotes = 0
), unopp AS (
    SELECT
        house2000.statename   postal,
        TO_CHAR(house2000.district) district,
        house2000.name        candidatename,
        CASE
            WHEN house2000.generalresults = 'Unopposed' THEN 1
            ELSE NULL
        END gewinnerindicator
    FROM
        house2000
)
SELECT
    h2000.postal,
    postal.statename,
    h2000.district,
    NULL fecid,
    h2000.incumbent,
    h2000.candidatenamefirst,
    h2000.candidatenamelast,
    h2000.candidatename,
    labels2000.partyname   party,
    h2000.primaryvotes,
    h2000.primaryvotes / hap_district2000.primaryvotes primarypct,
    h2000.runoffvotes,
    NULL runoffpct,
    h2000.generalvotes,
    h2000.generalvotes / hag_district2000.generalvotes generalpct,
    NULL gerunoffelectionvotes,
    NULL gerunoffelectionpct,
    CASE
        WHEN multi.cancount > 1 THEN ha_name2000.generalvotes
        ELSE NULL
    END combinedgeparytotals,
    CASE
        WHEN multi.cancount > 1 THEN ha_name2000.generalvotes / hag_district2000.generalvotes
        ELSE NULL
    END combinedpct,
    CASE
        WHEN unopp.gewinnerindicator = 1                  THEN 1
        WHEN ha_name2000.generalvotes = hmax2000.maxvotes THEN 1
        ELSE 0
    END gewinnerindicator,
    NULL footnotes,
    TO_DATE('11/07/2000', 'MM/DD/YYYY') generalelectiondate,
    NULL primarydate,
    NULL runoffdate,
    NULL gerunoffdate,
    h2000.writein
FROM
    h2000 left
    JOIN postal ON h2000.postal = postal.postal
    LEFT JOIN labels2000 ON h2000.party = replace(labels2000.abbreviation, ' ', '')
    LEFT JOIN hap_district2000 ON h2000.postal = hap_district2000.postal
                                  AND h2000.party = hap_district2000.party
                                  AND h2000.district = hap_district2000.district
    LEFT JOIN hag_district2000 ON h2000.postal = hag_district2000.postal
                                  AND h2000.district = hag_district2000.district
    LEFT JOIN ha_name2000 ON h2000.candidatename = ha_name2000.candidatename
                             AND h2000.postal = ha_name2000.postal
                             AND h2000.district = ha_name2000.district
    LEFT JOIN hmax2000 ON h2000.postal = hmax2000.postal
                          AND h2000.district = hmax2000.district
    LEFT JOIN multi ON h2000.postal = multi.postal
                       AND h2000.candidatename = multi.candidatename
                       AND h2000.district = multi.district
    LEFT JOIN unopp ON h2000.postal = unopp.postal
                       AND h2000.district = unopp.district
                       AND h2000.candidatename = unopp.candidatename

WHEN party = 'W(PFP)' THEN 
WHEN party = 'W(R)' THEN 
WHEN party = 'W(LBT)' THEN 
WHEN party = 'UN(D)' THEN 
WHEN party = 'W(D)' THEN 
WHEN party = 'UN(AIP)' THEN 
WHEN party = 'W(GRN)' THEN 

WHEN party = 'W(D)/D' THEN 'D'
WHEN party = 'U (SEP)' THEN 'SEP'
WHEN party = 'N(D)' THEN 'D'
WHEN party = 'W(R)' THEN 'R'
WHEN party = 'D/W' THEN 'D'
WHEN party = 'W(LBT)' THEN 'LBT'
WHEN party = 'N(R)' THEN 'R'
WHEN party = 'N(GRN)' THEN 'GRN'
WHEN party = 'N(NB)' THEN 'NB'
WHEN party = 'W(R)/W' THEN 'R'
WHEN party = 'W(R)/R' THEN 'R'
WHEN party = 'W(D)' THEN 'D'
WHEN party = 'W(DCG)' THEN 'DCG'
WHEN party = 'W(C)' THEN 'C'
WHEN party = 'W(CON)' THEN 'CON'
WHEN party = 'N(LBT)' THEN 'LBT'
WHEN party = 'W(WF)' THEN 'WF'
WHEN party = 'W(NPP)' THEN 'NPP'
WHEN party = 'W(GR)' THEN 'GR'
WHEN party = 'W(GRN)' THEN 'GRN'
WHEN party = 'W(PRO)' THEN 'PRO'
WHEN party = 'W(WG)' THEN 'WG'
WHEN party = 'D/NP' THEN 'D'

'W(D)/D'
'W(R)'
'D/W'
'W(LBT)'
'W(R)/W'
'W(R)/R'
'W(D)'
'W(DCG)'
'W(C)'
'W(CON)'
'W(WF)'
'W(NPP)'
'W(GR)'
'W(GRN)'
'W(PRO)'
'W(WG)'


WHEN party = 'REP' then 'R'
WHEN party = 'W(PAF)' then 'PAF'
WHEN party = 'REP*' then 'R'
WHEN party = 'W(DEM)/DEM*' then 'D' 
WHEN party = 'U (IND)' then 'IND'
WHEN party = 'W(LBT)' then 'LBT'
WHEN party = 'DEM ' then 'D'
WHEN party = 'W (REP)/REP' then 'R'
WHEN party = 'DEM/W' then 'D'
WHEN party = 'W(REP)' then 'R'
WHEN party = 'REP ' then 'R'
WHEN party = 'REP/IND' then 'R'
WHEN party = 'W(DEM)' then 'D'
WHEN party = 'REP/W' then 'R'
WHEN party = 'W(DCG)' then 'DCG'
WHEN party = 'W(IND)' then 'IND'
WHEN party = 'W(LU)' then 'LU'
WHEN party = 'W(CON)' then 'CON'
WHEN party = 'DEM' then 'D'
WHEN party = 'GRE/W' then 'GRE'
WHEN party = 'W (DEM)/DEM' then 'D'
WHEN party = 'GRE*' then 'GRE'
WHEN party = 'W(IDP)' then 'IDP'
WHEN party = 'DEM/CFL*' then 'D'
WHEN party = 'N(DEM)' then 'D'
WHEN party = 'N(REP)' then 'R'
WHEN party = 'W(DEM)/DEM' then 'D' 
WHEN party = 'W(PRO)' then 'PRO'
WHEN party = 'W(WG)' then 'WG'
WHEN party = 'W(LBT)/LBT' then 'LBT' 
WHEN party = 'W(REP)/REP' then 'R'

'W(PAF)'
'W(DEM)/DEM*'
'W(LBT)'
'W (REP)/REP'
'DEM/W'
'W(REP)'
'W(DEM)'
'REP/W'
'W(DCG)'
'W(IND)'
'W(LU)'
'W(CON)'
'GRE/W'
'W (DEM)/DEM'
'W(IDP)'
'W(DEM)/DEM'
'W(PRO)'
'W(WG)'
'W(LBT)/LBT'
'W(REP)/REP'

WHEN party = 'W(R)' THEN 'R'
WHEN party = 'W(AIP)' THEN 'AIP'
WHEN party = 'W(LIB)' THEN 'LIB'
WHEN party = 'W(D)' THEN 'D'
WHEN party = 'W(DCG)' THEN 'DCG'
WHEN party = 'W(LU)' THEN 'LU'

'W(R)'
'W(AIP)'
'W(LIB)'
'W(D)'
'W(DCG)'
'W(LU)'

WHEN party = 'N(D)' THEN 'D'
WHEN party = 'W(R)' THEN 'R'
WHEN party = 'W (D)' THEN 'D'
WHEN party = 'D/W' THEN 'D'
WHEN party = 'N(R)' THEN 'R'
WHEN party = 'N(NB)' THEN 'NB'
WHEN party = 'W(LBT)' THEN 'LBT'
WHEN party = 'W(R)/W' THEN 'R'
WHEN party = 'W(R)/R' THEN'R'
WHEN party = 'W(LBT)/I' THEN 'LBT'
WHEN party = 'D/R' THEN 'D'
WHEN party = 'W(D)' THEN 'D'
WHEN party = 'W(DCG)' THEN 'DCG'
WHEN party = 'W(D)/W' THEN 'D'
WHEN party = 'D' THEN 'D'
WHEN party = 'W(CON)' THEN 'CON'
WHEN party = 'W(LU)' THEN 'LU'
WHEN party = 'W(LBT)/W' THEN 'LBT'
WHEN party = 'W(WF)' THEN 'WF'
WHEN party = 'R/IP#' THEN 'R'
WHEN party = 'D/IP' THEN 'D'
WHEN party = 'W(NPP)' THEN 'NPP'
WHEN party = 'W(GR)' THEN 'GR'
WHEN party = 'NPA*' THEN 'NPA'
WHEN party = 'R' THEN 'R'
WHEN party = 'N(GRE)' THEN 'GRE'
WHEN party = 'W(PRO)' THEN 'PRO'
WHEN party = 'W(WG)' THEN 'WG'
WHEN party = 'W(LBT)/LBT' THEN 'LBT'
WHEN party = 'R/W' THEN 'R'

'W(R)'
'W (D)'
'D/W'
'W(LBT)'
'W(R)/W'
'W(R)/R'
'W(LBT)/I'
'W(D)'
'W(DCG)'
'W(D)/W'
'W(CON)'
'W(LU)'
'W(LBT)/W'
'W(WF)'
'W(NPP)'
'W(GR)'
'W(PRO)'
'W(WG)'
'W(LBT)/LBT'
'R/W'

WHEN party = 'W(AIP)' THEN 'AIP'
WHEN party = 'DEM/W' THEN 'DEM'
WHEN party = 'W(LIB)/LIB' THEN 'LIB'
WHEN party = 'W(LIB)' THEN 'LIB'
WHEN party = 'W(GRE)' THEN 'GRE'
WHEN party = 'W(REP)' THEN 'REP'
WHEN party = 'PG/PRO' THEN 'PRO'
WHEN party = 'DEM/IND' THEN 'DEM'
WHEN party = 'W(DEM)' THEN 'DEM'
WHEN party = 'W(DCG)' THEN 'DCG'
WHEN party = 'W(DEM' THEN 'DEM'
WHEN party = 'REP/W' THEN 'REP'
WHEN party = 'APP/LIB' THEN 'LIB'
WHEN party = 'IP*' THEN 'IP'
WHEN party = 'W(CRV)' THEN 'CRV'
WHEN party = 'CRV/TX' THEN 'CRV'
WHEN party = 'W (Challenged Counted)' THEN 'W' 
WHEN party = 'W(DEM)/DEM' THEN 'DEM'
WHEN party = 'N(REP)' THEN 'REP'
WHEN party = 'N(DEM)' THEN 'DEM'
WHEN party = 'W(DNL)' THEN 'DNL'
WHEN party = 'W(CON)/CON' THEN 'CON'
WHEN party = 'DEM/PRO/WF' THEN 'DEM'
WHEN party = 'W(PRO)' THEN 'PRO'
WHEN party = 'W(WG)' THEN 'WG'
WHEN party = 'REP/W***' THEN 'REP'
WHEN party = 'W(GRE)/GRE' THEN 'GRE'
WHEN party = 'W(REP)/REP' THEN 'REP'
WHEN party = 'W(REP)/W' THEN 'REP'
WHEN party = 'REP/TRP' THEN 'REP'

'W(AIP)'
'DEM/W'
'W(LIB)/LIB'
'W(LIB)'
'W(GRE)'
'W(REP)'
'W(DEM)'
'W(DCG)'
'W(DEM'
'REP/W'
'W(CRV)'
'W (Challenged Counted)'
'W(DEM)/DEM'
'N(REP)'
'N(DEM)'
'W(DNL)'
'W(CON)/CON'
'W(PRO)'
'W(WG)'
'REP/W***'
'W(GRE)/GRE'
'W(REP)/REP'
'W(REP)/W'

WHEN party = 'W(R)' THEN 'R'
WHEN party = 'W(AIP)' THEN 'AIP'
WHEN party = 'W(D)' THEN 'D'
WHEN party = 'W(DCG)' THEN 'DCG'
WHEN party = 'W(GR)' THEN 'GR'

'W(R)'
'W(AIP)'
'W(D)'
'W(DCG)'
'W(GR)'

H2CA06283
H2CA24161
H2CA52063

W(PAF)
W(D)/D
N(D)
AF
R/CRV/IDP Combined Parties
R/CON
W(AE)/AE
W(R)
AE
D/W
W(R)/W
N(R)
W(LIB)/LIB
W(R)/R
W(LIB)
D/WF Combined Parties
R/CRV/IDP/TRP Combined Parties
W(GRE)
D/WF
D/IND
W(AE)
W(D)
W(DCG)
W(IND)
R/TRP Combined Parties
W(CON)
R/TRP
D/WF/IDP Combined Parties
R/CRV/TRP Combined Parties
D/IDP/WF Combined Parties
W(GR)
CRV/LIB
R/CRV Combined Parties
R/IDP Combined Parties
W(DNL)
W(PRO)
W(GRE)/GRE
R/CRV/LIB Combined Parties
D/PRO/WF

W(PAF)
W(D)/D
N(D)
AF
R/CRV/IDP Combined Parties
R/CON
W(AE)/AE
W(R)
AE
D/W
W(R)/W
N(R)
W(LIB)/LIB
W(R)/R
W(LIB)
D/WF Combined Parties
R/CRV/IDP/TRP Combined Parties
W(GRE)
D/WF
D/IND
W(AE)
W(D)
W(DCG)
W(IND)
R/TRP Combined Parties
W(CON)
R/TRP
D/WF/IDP Combined Parties
R/CRV/TRP Combined Parties
D/IDP/WF Combined Parties
W(GR)
CRV/LIB
R/CRV Combined Parties
R/IDP Combined Parties
W(DNL)
W(PRO)
W(GRE)/GRE
R/CRV/LIB Combined Parties
D/PRO/WF
