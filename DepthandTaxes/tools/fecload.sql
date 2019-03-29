CREATE TABLE presgeneral2000
	(
	POSTAL varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	GENERALVOTES number,
	WRITEIN number
	);

CREATE TABLE presgeneral2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	CANDIDATE varchar2(255),
	PARTY varchar2(255),
	NUMBEROFVOTES varchar2(255),
	COMBINEDPARTIES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presgeneral2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presgeneral2000
	(
	POSTAL,	CANDIDATENAMEFIRST,	CANDIDATENAMELAST, CANDIDATENAME, PARTY, GENERALVOTES, WRITEIN
	)
	(
	SELECT
	    presgeneral2000_load.statename,
	    regexp_substr(presgeneral2000_load.candidate, '[^,]+', 1, 2),
	    regexp_substr(presgeneral2000_load.candidate, '[^,]+', 1, 1),
	    presgeneral2000_load.candidate,
	    CASE
	        WHEN presgeneral2000_load.party = 'I (GRN)' THEN 'GRN'
	        WHEN presgeneral2000_load.party = 'I (LBT)' THEN 'LBT'
	        WHEN presgeneral2000_load.party = 'I (SWP)' THEN 'SWP'
	        WHEN presgeneral2000_load.party = 'I (CON)' THEN 'CON'
	        WHEN presgeneral2000_load.party = 'I (REF)' THEN 'REF'
	        WHEN presgeneral2000_load.party = 'PRO/GRN' THEN 'GRN'
	        WHEN presgeneral2000_load.party = 'I (SOC)' THEN 'SOC'
	        WHEN presgeneral2000_load.party = 'I (I)'   THEN 'I'
	        ELSE TRIM(presgeneral2000_load.party)
	    END,
	    to_number(regexp_replace(presgeneral2000_load.numberofvotes, '\D+')),
	    CASE
	        WHEN presgeneral2000_load.party = 'W' THEN 1
	        ELSE 0
	    END
	FROM
	    presgeneral2000_load
	WHERE
	    presgeneral2000_load.statename != 'ZZZZ'
	    AND presgeneral2000_load.numberofvotes != 0
	);

CREATE TABLE presprimary2000
	(
	POSTAL varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	WRITEIN number
	);

CREATE TABLE presprimary2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	CANDIDATE varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	WRITEIN varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimary2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimary2000
	(
	POSTAL, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, WRITEIN
	)
	(
	SELECT
	    presprimary2000_load.statename,
	    regexp_substr(presprimary2000_load.candidate, '[^,]+', 1, 2),
	    regexp_substr(presprimary2000_load.candidate, '[^,]+', 1, 1),
	    presprimary2000_load.candidate,
	    CASE
	        WHEN presprimary2000_load.party = 'UN(R)'  THEN 'R'
	        WHEN presprimary2000_load.party = 'W(R)'   THEN 'R'
	        WHEN presprimary2000_load.party = 'UN(D)'  THEN 'D'
	        WHEN presprimary2000_load.party = 'W(D)'   THEN 'D'
	        WHEN presprimary2000_load.party = 'W(N)'   THEN 'N'
	        WHEN presprimary2000_load.party = 'W(GRN)' THEN 'GRN'
	        WHEN presprimary2000_load.party = 'W(REF)' THEN 'REF'
	        ELSE TRIM(presprimary2000_load.party)
	    END,
	    to_number(regexp_replace(presprimary2000_load.numberofvotes, '\D+')),
	    CASE
	        WHEN presprimary2000_load.party IN (
	            'W',
	            'W(R)',
	            'W(D)',
	            'W(N)',
	            'W(GRN)',
	            'W(REF)'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    presprimary2000_load
	WHERE
	    presprimary2000_load.percent IS NOT NULL
	);

CREATE TABLE presprimarydates2000
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	PARTY varchar2(255)
	);

CREATE TABLE presprimarydates2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	PRIMARYDATE varchar2(255),
	CAUCUSDATE varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimarydates2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimarydates2000
	(
	STATENAME,PRIMARYDATE,PARTY
	)
	(
	SELECT
	    statename,
	    CASE
	        WHEN EXTRACT(YEAR FROM primarydate) = 2001 THEN add_months(primarydate, - 12)
	        ELSE primarydate
	    END,
	    party
	FROM
	    (
	        SELECT
	            initcap(presprimarydates2000_load.statename) statename,
	            CASE
	                WHEN presprimarydates2000_load.primarydate IS NULL THEN TO_DATE(presprimarydates2000_load.caucusdate, 'YYYY-MM-DD HH24:MI:SS'
	                )
	                ELSE TO_DATE(presprimarydates2000_load.primarydate, 'YYYY-MM-DD HH24:MI:SS')
	            END primarydate,
	            'R' party
	        FROM
	            presprimarydates2000_load
	        WHERE
	            presprimarydates2000_load.statename IN (
	                SELECT
	                    statename
	                FROM
	                    (
	                        SELECT
	                            presprimarydates2000_load.statename,
	                            CASE
	                                WHEN presprimarydates2000_load.primarydate IS NULL THEN presprimarydates2000_load.caucusdate
	                                ELSE presprimarydates2000_load.primarydate
	                            END primarydate
	                        FROM
	                            presprimarydates2000_load
	                    )
	                GROUP BY
	                    statename
	                HAVING
	                    COUNT(statename) = 1
	            )
	        UNION
	        SELECT
	            initcap(presprimarydates2000_load.statename) statename,
	            CASE
	                WHEN presprimarydates2000_load.primarydate IS NULL THEN TO_DATE(presprimarydates2000_load.caucusdate, 'YYYY-MM-DD HH24:MI:SS'
	                )
	                ELSE TO_DATE(presprimarydates2000_load.primarydate, 'YYYY-MM-DD HH24:MI:SS')
	            END primarydate,
	            'D' party
	        FROM
	            presprimarydates2000_load
	        WHERE
	            presprimarydates2000_load.statename IN (
	                SELECT
	                    statename
	                FROM
	                    (
	                        SELECT
	                            presprimarydates2000_load.statename,
	                            CASE
	                                WHEN presprimarydates2000_load.primarydate IS NULL THEN presprimarydates2000_load.caucusdate
	                                ELSE presprimarydates2000_load.primarydate
	                            END primarydate
	                        FROM
	                            presprimarydates2000_load
	                    )
	                GROUP BY
	                    statename
	                HAVING
	                    COUNT(statename) = 1
	            )
	        UNION
	        SELECT
	            initcap(presprimarydates2000_load.statename) statename,
	            TO_DATE(presprimarydates2000_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
	            'R' party
	        FROM
	            presprimarydates2000_load
	        WHERE
	            presprimarydates2000_load.statename IN (
	                'ARIZONA',
	                'MICHIGAN'
	            )
	            AND NOT REGEXP_LIKE ( presprimarydates2000_load.primarydate,
	                                  '[RD]' )
	        UNION
	        SELECT
	            initcap(presprimarydates2000_load.statename) statename,
	            TO_DATE(presprimarydates2000_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
	            'D' party
	        FROM
	            presprimarydates2000_load
	        WHERE
	            presprimarydates2000_load.statename = 'DELAWARE'
	            AND NOT REGEXP_LIKE ( presprimarydates2000_load.primarydate,
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
	                    presprimarydates2000_load.statename,
	                    CASE
	                        WHEN presprimarydates2000_load.primarydate IS NULL THEN presprimarydates2000_load.caucusdate
	                        ELSE presprimarydates2000_load.primarydate
	                    END primarydate
	                FROM
	                    presprimarydates2000_load
	            )
	        WHERE
	            REGEXP_LIKE ( primarydate,
	                          '[RD]' )
	    )
	);

CREATE TABLE senate2000
	(
	POSTAL varchar2(255),
	DISTRICT varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	RUNOFFVOTES number,
	GENERALVOTES number,
	WRITEIN number
	);

CREATE TABLE senate2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	NAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	RUNOFFRESULTS varchar2(255),
	GENERALRESULTS varchar2(255),
	COMBINEDPARTIES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('senate2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO senate2000
	(
	POSTAL,DISTRICT,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,WRITEIN
	)
	(
	SELECT
	    senate2000_load.statename,
	    senate2000_load.district,
	    nvl2(senate2000_load.incumbentindicator, 1, 0),
	    regexp_substr(senate2000_load.name, '[^,]+', 1, 2),
	    regexp_substr(senate2000_load.name, '[^,]+', 1, 1),
	    senate2000_load.name,
	    CASE
	        WHEN senate2000_load.party = 'I (GRN)' THEN 'GRN'
	        WHEN senate2000_load.party = '(N)NL'   THEN 'NL'
	        WHEN senate2000_load.party = 'N(D)'    THEN 'D'
	        WHEN senate2000_load.party = 'W(RTL)'  THEN 'RTL'
	        WHEN senate2000_load.party = 'I (NJC)' THEN 'NJC'
	        WHEN senate2000_load.party = 'N(R)'    THEN 'R'
	        WHEN senate2000_load.party = 'W(R)'    THEN 'R'
	        WHEN senate2000_load.party = 'I (GBJ)' THEN 'GBJ'
	        WHEN senate2000_load.party = 'I (LBT)' THEN 'LBT'
	        WHEN senate2000_load.party = 'W(LBT)'  THEN 'LBT'
	        WHEN senate2000_load.party = 'I (SWP)' THEN 'SWP'
	        WHEN senate2000_load.party = '(N)LBT'  THEN 'LBT'
	        WHEN senate2000_load.party = 'W(CON)'  THEN 'CON'
	        WHEN senate2000_load.party = 'W(D)'    THEN 'D'
	        WHEN senate2000_load.party = 'I (REF)' THEN 'REF'
	        WHEN senate2000_load.party = 'W(IDP)'  THEN 'IDP'
	        WHEN senate2000_load.party = 'I (SOC)' THEN 'SOC'
	        WHEN senate2000_load.party = 'I (TG)'  THEN 'TG'
	        WHEN senate2000_load.party = 'W(WG)'   THEN 'WG'
	        WHEN senate2000_load.party = 'W(GRN)'  THEN 'GRN'
	        WHEN senate2000_load.party = 'I (I)'   THEN 'I'
	        ELSE TRIM(senate2000_load.party)
	    END,
	    to_number(regexp_replace(senate2000_load.primaryresults, '\D+')),
	    to_number(regexp_replace(senate2000_load.runoffresults, '\D+')),
	    to_number(regexp_replace(senate2000_load.generalresults, '\D+')),
	    CASE
	        WHEN senate2000_load.party IN (
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
	    END
	FROM
	    senate2000_load
	WHERE
	    senate2000_load.combinedparties IS NULL
	);

CREATE TABLE house2000
	(
	POSTAL varchar2(255),
	DISTRICT varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	RUNOFFVOTES number,
	GENERALVOTES number,
	GEWINNER number,
	WRITEIN number
	);

CREATE TABLE house2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	NAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	RUNOFFRESULTS varchar2(255),
	GENERALRESULTS varchar2(255),
	COMBINEDPARTIES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('house2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO house2000
	(
	POSTAL,DISTRICT,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GEWINNER,WRITEIN
	)
	(
	SELECT
	    house2000_load.statename,
	    house2000_load.district,
	    nvl2(house2000_load.incumbentindicator, 1, 0),
	    regexp_substr(house2000_load.name, '[^,]+', 1, 2),
	    regexp_substr(house2000_load.name, '[^,]+', 1, 1),
	    house2000_load.name,
	    CASE
	        WHEN house2000_load.party = '(N)NL'      THEN 'NL'
	        WHEN house2000_load.party = 'N(D)'       THEN 'D'
	        WHEN house2000_load.party = 'I (GRN)'    THEN 'GRN'
	        WHEN house2000_load.party = 'I (NJC)'    THEN 'NJC'
	        WHEN house2000_load.party = 'I (IPR)'    THEN 'IPR'
	        WHEN house2000_load.party = 'W(GRN)/GRN' THEN 'GRN'
	        WHEN house2000_load.party = 'W(R)'       THEN 'R'
	        WHEN house2000_load.party = 'W(UM)'      THEN 'UM'
	        WHEN house2000_load.party = 'W(LBT)'     THEN 'LBT'
	        WHEN house2000_load.party = 'N(R)'       THEN 'R'
	        WHEN house2000_load.party = 'I (LBT)'    THEN 'LBT'
	        WHEN house2000_load.party = 'I (SWP)'    THEN 'SWP'
	        WHEN house2000_load.party = 'I(CFC)'     THEN 'CFC'
	        WHEN house2000_load.party = 'D/LU'       THEN 'D'
	        WHEN house2000_load.party = 'W/LBT'      THEN 'LBT'
	        WHEN house2000_load.party = 'U(LBT)'     THEN 'LBT'
	        WHEN house2000_load.party = 'W(R)/R'     THEN 'R'
	        WHEN house2000_load.party = 'D/R'        THEN 'R'
	        WHEN house2000_load.party = 'W(D)'       THEN 'D'
	        WHEN house2000_load.party = 'W(DCG)'     THEN 'DCG'
	        WHEN house2000_load.party = 'I (LMP)'    THEN 'LMP'
	        WHEN house2000_load.party = 'I (NJI)'    THEN 'NJI'
	        WHEN house2000_load.party = 'I (CON)'    THEN 'CON'
	        WHEN house2000_load.party = 'W(C)'       THEN 'C'
	        WHEN house2000_load.party = 'W(CON)'     THEN 'CON'
	        WHEN house2000_load.party = 'N(LBT)'     THEN 'LBT'
	        WHEN house2000_load.party = 'I (REF)'    THEN 'REF'
	        WHEN house2000_load.party = 'W(G)'       THEN 'G'
	        WHEN house2000_load.party = 'W(WF)/WF'   THEN 'WF'
	        WHEN house2000_load.party = 'I(LBT)'     THEN 'LBT'
	        WHEN house2000_load.party = 'I (SOC)'    THEN 'SOC'
	        WHEN house2000_load.party = 'I (ICE)'    THEN 'ICE'
	        WHEN house2000_load.party = 'W(IDP)'     THEN 'IDP'
	        WHEN house2000_load.party = 'W(NL)'      THEN 'NL'
	        WHEN house2000_load.party = 'I (NL)'     THEN 'NL'
	        WHEN house2000_load.party = 'I (PC)'     THEN 'PC'
	        WHEN house2000_load.party = 'W(GRN)'     THEN 'GRN'
	        WHEN house2000_load.party = 'I(GRN)'     THEN 'GRN'
	        WHEN house2000_load.party = 'W(WG)'      THEN 'WG'
	        WHEN house2000_load.party = 'W(D)/R'     THEN 'R'
	        WHEN house2000_load.party = 'I (UC)'     THEN 'UC'
	        ELSE TRIM(house2000_load.party)
	    END,
	    to_number(regexp_replace(house2000_load.primaryresults, '\D+')),
	    to_number(regexp_replace(house2000_load.runoffresults, '\D+')),
	    to_number(regexp_replace(house2000_load.generalresults, '\D+')),
	    CASE
	        WHEN house2000_load.generalresults LIKE '%Un%' THEN 1
	        ELSE NULL
	    END,
	    CASE
	        WHEN house2000_load.party IN (
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
	    END
	FROM
	    house2000_load
	WHERE
	    house2000_load.statename IS NOT NULL
	    AND house2000_load.party != 'Combined'
	);

CREATE TABLE labels2000
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2000_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2000.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2000
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT
	ABBREVIATION,PARTYNAME
	FROM labels2000_load
	);

CREATE TABLE congress2002
	(
	POSTAL varchar2(255), 
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number, 
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2002_load
	(
	RWID varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFRESULTS varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALRESULTS varchar2(255),
	GENERALPCT varchar2(255),
	GENERALRUNOFFRESULTS varchar2(255),
	GENERALRUNOFFPCT varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2002.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2002
	(
	POSTAL, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2002_load.statename,
	    congress2002_load.district,
	    congress2002_load.fecid,
	    nvl2(congress2002_load.incumbentindicator, 1, 0),
	    congress2002_load.firstname,
	    congress2002_load.lastname,
	    congress2002_load.lastnamefirst,
	    CASE
	        WHEN congress2002_load.party = 'N(D)'           THEN 'D'
	        WHEN congress2002_load.party = 'I (GRN)'        THEN 'GRN'
	        WHEN congress2002_load.party = 'I (NJC)'        THEN 'NJC'
	        WHEN congress2002_load.party = 'I (LTI)'        THEN 'LTI'
	        WHEN congress2002_load.party = 'I (PLC)'        THEN 'PLC'
	        WHEN congress2002_load.party = 'W(RTL) '        THEN 'TRL'
	        WHEN congress2002_load.party = 'W(RTL)'         THEN 'RTL'
	        WHEN congress2002_load.party = 'W(R)'           THEN 'R'
	        WHEN congress2002_load.party = 'W(LBT)'         THEN 'LBT'
	        WHEN congress2002_load.party = 'W(R)/W'         THEN 'R'
	        WHEN congress2002_load.party = 'DFL/W'          THEN 'DFL'
	        WHEN congress2002_load.party = 'N(R)'           THEN 'R'
	        WHEN congress2002_load.party = 'I (LBT)'        THEN 'LBT'
	        WHEN congress2002_load.party = 'I (AF)'         THEN 'AF'
	        WHEN congress2002_load.party = 'I (HHD)'        THEN 'HHD'
	        WHEN congress2002_load.party = 'W(RTL)/RTL'     THEN 'RTL'
	        WHEN congress2002_load.party = 'W(D)'           THEN 'D'
	        WHEN congress2002_load.party = 'W(DCG)'         THEN 'DCG'
	        WHEN congress2002_load.party = 'GRN/W'          THEN 'GRN'
	        WHEN congress2002_load.party = 'I (AM,AC)'      THEN 'AM'
	        WHEN congress2002_load.party = 'W(C)'           THEN 'C'
	        WHEN congress2002_load.party = 'W(CON)'         THEN 'CON'
	        WHEN congress2002_load.party = 'W(LBT)  '       THEN 'LBT'
	        WHEN congress2002_load.party = 'N(LBT)'         THEN 'LBT'
	        WHEN congress2002_load.party = 'R and R/D'      THEN 'R'
	        WHEN congress2002_load.party = 'I(HP)'          THEN 'HP'
	        WHEN congress2002_load.party = 'W(IG)'          THEN 'IG'
	        WHEN congress2002_load.party = 'I (SOC)'        THEN 'SOC'
	        WHEN congress2002_load.party = 'PRO AND LU/PRO' THEN 'PRO'
	        WHEN congress2002_load.party = 'W(GRN)'         THEN 'GRN'
	        WHEN congress2002_load.party = 'I (PC)'         THEN 'PC'
	        WHEN congress2002_load.party = 'W(PRO)'         THEN 'PRO'
	        WHEN congress2002_load.party = 'W(WG)'          THEN 'WG'
	        WHEN congress2002_load.party = 'W(LBT)/LBT'     THEN 'LBT'
	        WHEN congress2002_load.party = 'R/W'            THEN 'R'
	        WHEN congress2002_load.party = 'I (HRA)'        THEN 'HRA'
	        ELSE TRIM(congress2002_load.party)
	    END,
	    to_number(regexp_replace(congress2002_load.primaryresults, '\D+')),
	    to_number(regexp_replace(congress2002_load.runoffresults, '\D+')),
	    to_number(regexp_replace(congress2002_load.generalresults, '\D+')),
	    to_number(regexp_replace(congress2002_load.generalrunoffresults, '\D+')),
	    CASE
	        WHEN congress2002_load.generalresults LIKE '%Un%' THEN 1
	        ELSE NULL
	    END AS,
	    congress2002_load.notes,
	    CASE
	        WHEN congress2002_load.party IN (
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
	    END
	FROM
	    congress2002_load
	WHERE
	    congress2002_load.lastnamefirst IS NOT NULL
	    AND congress2002_load.party NOT IN (
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
	    congress2002_load.statename,
	    congress2002_load.district,
	    congress2002_load.fecid,
	    nvl2(congress2002_load.incumbentindicator, 1, 0),
	    congress2002_load.firstname,
	    congress2002_load.lastname,
	    congress2002_load.lastname
	    || ','
	    || ' '
	    || congress2002_load.firstname,
	    TRIM(congress2002_load.totalvotes),
	    to_number(regexp_replace(congress2002_load.party, '\D+')),
	    to_number(regexp_replace(congress2002_load.runoffresults, '\D+')),
	    to_number(regexp_replace(congress2002_load.generalresults, '\D+')),
	    to_number(regexp_replace(congress2002_load.generalrunoffresults, '\D+')),
	    NULL gewinner,
	    congress2002_load.notes,
	    0
	FROM
	    congress2002_load
	WHERE
	    congress2002_load.fecid IS NOT NULL
	    AND congress2002_load.lastnamefirst IS NULL
    );

CREATE TABLE labels2002
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2002_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2002.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2002
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT
	ABBREVIATION,PARTYNAME
	FROM labels2002_load
	);

CREATE TABLE primarydates2002
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date	
	);

CREATE TABLE primarydates2002_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	UNUSED varchar2(255),
	PRIMARYDATE varchar2(255),
	RUNOFFDATE varchar2(255)	
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2002.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2002
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
	SELECT
	    initcap(primarydates2002_load.statename),
	    TO_DATE(primarydates2002_load.primarydate, 'YYYY-MM-DD HH24:MI:SS'),
	    TO_DATE(primarydates2002_load.runoffdate, 'YYYY-MM-DD HH24:MI:SS')
	FROM
	    primarydates2002_load
   	);

CREATE TABLE presgeneral2004
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	GENERALVOTES number,
	NOTES varchar2(255),
	GENERALELECTIONDATE date,
	WRITEIN number
	);

CREATE TABLE presgeneral2004_load
	(
	RWID varchar2(255),
	IDNUMBER varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	GENERALELECTIONDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	GENERALRESULTS varchar2(255),
	TOTALVOTESNUMBER varchar2(255),
	GENERALPCT varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presgeneral2004.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presgeneral2004
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, GENERALVOTES, NOTES, GENERALELECTIONDATE, WRITEIN
	)
	(
	SELECT
	    presgeneral2004_load.statenameabbreviation   postal,
	    presgeneral2004_load.statename,
	    presgeneral2004_load.fecid,
	    presgeneral2004_load.firstname               candidatenamefirst,
	    presgeneral2004_load.lastname                candidatenamelast,
	    presgeneral2004_load.lastnamefirst           candidatename,
	    TRIM(presgeneral2004_load.party) party,
	    to_number(regexp_replace(presgeneral2004_load.generalresults, '\D+')) generalvotes,
	    presgeneral2004_load.notes,
	    TO_DATE(presgeneral2004_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
	    CASE
	        WHEN presgeneral2004_load.party = 'W' THEN 1
	        ELSE 0
	    END writein
	FROM
	    presgeneral2004_load
	WHERE
	    presgeneral2004_load.lastnamefirst IS NOT NULL
	    AND ( presgeneral2004_load.totalvotes NOT LIKE '%Comb%'
	          OR presgeneral2004_load.totalvotes IS NULL )
	);

CREATE TABLE presprimary2004
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	NOTES varchar2(255),
	PRIMARYDATE date,
	WRITEIN number
	);

CREATE TABLE presprimary2004_load
	(
	RWID varchar2(255),
	IDNUMBER varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	PRIMARYDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	PRIMARYPCT varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimary2004.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimary2004
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, NOTES, PRIMARYDATE, WRITEIN
	)
	(
	SELECT
	    presprimary2004_load.statenameabbreviation,
	    presprimary2004_load.statename,
	    presprimary2004_load.fecid,
	    presprimary2004_load.firstname,
	    presprimary2004_load.lastname,
	    presprimary2004_load.lastnamefirst,
	    CASE
	        WHEN presprimary2004_load.party = 'W(PFP)'  THEN 'PFP'
	        WHEN presprimary2004_load.party = 'W(R)'    THEN 'R'
	        WHEN presprimary2004_load.party = 'W(LBT)'  THEN 'LBT'
	        WHEN presprimary2004_load.party = 'UN(D)'   THEN 'D'
	        WHEN presprimary2004_load.party = 'W(D)'    THEN 'D'
	        WHEN presprimary2004_load.party = 'UN(AIP)' THEN 'AIP'
	        WHEN presprimary2004_load.party = 'W(GRN)'  THEN 'GRN'
	        ELSE TRIM(presprimary2004_load.party)
	    END,
	    to_number(regexp_replace(presprimary2004_load.primaryresults, '\D+')),
	    presprimary2004_load.notes,
	    TO_DATE(presprimary2004_load.primarydate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN presprimary2004_load.party IN (
	            'W',
	            'W(PFP)',
	            'W(R)',
	            'W(LBT)',
	            'W(D)',
	            'W(GRN)'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    presprimary2004_load
	WHERE
	    presprimary2004_load.lastnamefirst IS NOT NULL
	);

CREATE TABLE congress2004
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number, 
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2004_load
	(
	RWID varchar2(255),
	IDNUMBER varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	DISTRICT varchar2(255),
	FECID varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARY varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFF varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERAL varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFF varchar2(255),
	GERUNOFFPCT varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2004.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2004
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2004_load.statenameabbreviation,
	    congress2004_load.statename,
	    congress2004_load.district,
	    congress2004_load.fecid,
	    nvl2(congress2004_load.incumbentindicator, 1, 0),
	    congress2004_load.firstname,
	    congress2004_load.lastname,
	    congress2004_load.lastnamefirst,
	    CASE
	        WHEN congress2004_load.party = 'W(D)/D'  THEN 'D'
	        WHEN congress2004_load.party = 'U (SEP)' THEN 'SEP'
	        WHEN congress2004_load.party = 'N(D)'    THEN 'D'
	        WHEN congress2004_load.party = 'W(R)'    THEN 'R'
	        WHEN congress2004_load.party = 'D/W'     THEN 'D'
	        WHEN congress2004_load.party = 'W(LBT)'  THEN 'LBT'
	        WHEN congress2004_load.party = 'N(R)'    THEN 'R'
	        WHEN congress2004_load.party = 'N(GRN)'  THEN 'GRN'
	        WHEN congress2004_load.party = 'N(NB)'   THEN 'NB'
	        WHEN congress2004_load.party = 'W(R)/W'  THEN 'R'
	        WHEN congress2004_load.party = 'W(R)/R'  THEN 'R'
	        WHEN congress2004_load.party = 'W(D)'    THEN 'D'
	        WHEN congress2004_load.party = 'W(DCG)'  THEN 'DCG'
	        WHEN congress2004_load.party = 'W(C)'    THEN 'C'
	        WHEN congress2004_load.party = 'W(CON)'  THEN 'CON'
	        WHEN congress2004_load.party = 'N(LBT)'  THEN 'LBT'
	        WHEN congress2004_load.party = 'W(WF)'   THEN 'WF'
	        WHEN congress2004_load.party = 'W(NPP)'  THEN 'NPP'
	        WHEN congress2004_load.party = 'W(GR)'   THEN 'GR'
	        WHEN congress2004_load.party = 'W(GRN)'  THEN 'GRN'
	        WHEN congress2004_load.party = 'W(PRO)'  THEN 'PRO'
	        WHEN congress2004_load.party = 'W(WG)'   THEN 'WG'
	        WHEN congress2004_load.party = 'D/NP'    THEN 'D'
	        ELSE TRIM(congress2004_load.party)
	    END,
	    to_number(regexp_replace(congress2004_load.primary, '\D+')),
	    to_number(regexp_replace(congress2004_load.runoff, '\D+')),
	    to_number(regexp_replace(congress2004_load.general, '\D+')),
	    to_number(regexp_replace(congress2004_load.gerunoff, '\D+')),
	    CASE
	        WHEN congress2004_load.general LIKE '%Un%' THEN 1
	        ELSE NULL
	    END,
	    congress2004_load.notes,
	    CASE
	        WHEN congress2004_load.party IN (
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
	    END
	FROM
	    congress2004_load
	WHERE
	    congress2004_load.lastnamefirst IS NOT NULL
	    AND ( congress2004_load.runoffpct NOT LIKE '%Comb%'
	          OR congress2004_load.runoffpct IS NULL )
    );

CREATE TABLE labels2004
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2004_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2004.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2004
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2004_load
	);

CREATE TABLE primarydates2004
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date	
	);

CREATE TABLE primarydates2004_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	UNUSED varchar2(255),
	Primary varchar2(255),
	Runoff varchar2(255)	
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2004.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2004
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
	SELECT
	    initcap(primarydates2004_load.statename),
	    TO_DATE(primarydates2004_load.primary, 'YYYY-MM-DD HH24:MI:SS'),
	    TO_DATE(primarydates2004_load.runoff, 'YYYY-MM-DD HH24:MI:SS')
	FROM
    primarydates2004_load	
    );

CREATE TABLE congress2006
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number, 
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2006_load
	(
	RWID varchar2(255),
	IDNUMBER varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	DISTRICT varchar2(255),
	FECID varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARY varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFF varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERAL varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFF varchar2(255),
	GERUNOFFPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2006.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2006
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2006_load.statenameabbreviation,
	    congress2006_load.statename,
	    congress2006_load.district,
	    congress2006_load.fecid,
	    nvl2(congress2006_load.incumbentindicator, 1, 0),
	    congress2006_load.firstname,
	    congress2006_load.lastname,
	    congress2006_load.lastnamefirst,
	    CASE
	        WHEN congress2006_load.party = 'REP'         THEN 'R'
	        WHEN congress2006_load.party = 'W(PAF)'      THEN 'PAF'
	        WHEN congress2006_load.party = 'REP*'        THEN 'R'
	        WHEN congress2006_load.party = 'W(DEM)/DEM*' THEN 'D'
	        WHEN congress2006_load.party = 'U (IND)'     THEN 'IND'
	        WHEN congress2006_load.party = 'W(LBT)'      THEN 'LBT'
	        WHEN congress2006_load.party = 'DEM '        THEN 'D'
	        WHEN congress2006_load.party = 'W (REP)/REP' THEN 'R'
	        WHEN congress2006_load.party = 'DEM/W'       THEN 'D'
	        WHEN congress2006_load.party = 'W(REP)'      THEN 'R'
	        WHEN congress2006_load.party = 'REP '        THEN 'R'
	        WHEN congress2006_load.party = 'REP/IND'     THEN 'R'
	        WHEN congress2006_load.party = 'W(DEM)'      THEN 'D'
	        WHEN congress2006_load.party = 'REP/W'       THEN 'R'
	        WHEN congress2006_load.party = 'W(DCG)'      THEN 'DCG'
	        WHEN congress2006_load.party = 'W(IND)'      THEN 'IND'
	        WHEN congress2006_load.party = 'W(LU)'       THEN 'LU'
	        WHEN congress2006_load.party = 'W(CON)'      THEN 'CON'
	        WHEN congress2006_load.party = 'DEM'         THEN 'D'
	        WHEN congress2006_load.party = 'GRE/W'       THEN 'GRE'
	        WHEN congress2006_load.party = 'W (DEM)/DEM' THEN 'D'
	        WHEN congress2006_load.party = 'GRE*'        THEN 'GRE'
	        WHEN congress2006_load.party = 'W(IDP)'      THEN 'IDP'
	        WHEN congress2006_load.party = 'DEM/CFL*'    THEN 'D'
	        WHEN congress2006_load.party = 'N(DEM)'      THEN 'D'
	        WHEN congress2006_load.party = 'N(REP)'      THEN 'R'
	        WHEN congress2006_load.party = 'W(DEM)/DEM'  THEN 'D'
	        WHEN congress2006_load.party = 'W(PRO)'      THEN 'PRO'
	        WHEN congress2006_load.party = 'W(WG)'       THEN 'WG'
	        WHEN congress2006_load.party = 'W(LBT)/LBT'  THEN 'LBT'
	        WHEN congress2006_load.party = 'W(REP)/REP'  THEN 'R'
	        ELSE TRIM(congress2006_load.party)
	    END,
	    to_number(regexp_replace(congress2006_load.primary, '\D+')),
	    to_number(regexp_replace(congress2006_load.runoff, '\D+')),
	    to_number(regexp_replace(congress2006_load.general, '\D+')),
	    to_number(regexp_replace(congress2006_load.gerunoff, '\D+')),
	    CASE
	        WHEN congress2006_load.general LIKE '%Un%' THEN 1
	        ELSE NULL
	    END,
	    congress2006_load.notes,
	    CASE
	        WHEN congress2006_load.party IN (
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
	    END
	FROM
	    congress2006_load
	WHERE
	    congress2006_load.lastnamefirst IS NOT NULL
	);

CREATE TABLE labels2006
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2006_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2006.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2006
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2006_load
	);

CREATE TABLE primarydates2006
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date	
	);

CREATE TABLE primarydates2006_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	UNUSED varchar2(255),
	Primary varchar2(255),
	Runoff varchar2(255)	
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2006.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2006
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
	SELECT
	    initcap(primarydates2006_load.statename),
	    TO_DATE(primarydates2006_load.primary, 'YYYY-MM-DD HH24:MI:SS'),
	    TO_DATE(primarydates2006_load.runoff, 'YYYY-MM-DD HH24:MI:SS')
	FROM	primarydates2006_load
	);

CREATE TABLE presgeneral2008
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	GENERALVOTES number,
	GENERALELECTIONDATE date,
	WRITEIN number
	);

CREATE TABLE presgeneral2008_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	GENERALELECTIONDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	GENERALRESULTS varchar2(255),
	TOTALVOTESNUMBER varchar2(255),
	GENERALPCT varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presgeneral2008.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presgeneral2008
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, GENERALVOTES, GENERALELECTIONDATE, WRITEIN
	)
	(
	SELECT
	    presgeneral2008_load.statenameabbreviation,
	    presgeneral2008_load.statename,
	    presgeneral2008_load.fecid,
	    presgeneral2008_load.firstname,
	    presgeneral2008_load.lastname,
	    presgeneral2008_load.lastnamefirst,
	    TRIM(presgeneral2008_load.party),
	    to_number(regexp_replace(presgeneral2008_load.generalresults, '\D+')),
	    TO_DATE(presgeneral2008_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN replace(presgeneral2008_load.party, ' ', '') = 'W' THEN 1
	        ELSE 0
	    END
	FROM
	    presgeneral2008_load
	WHERE
	    presgeneral2008_load.lastnamefirst IS NOT NULL
	    AND presgeneral2008_load.party NOT LIKE '%Comb%'
	);

CREATE TABLE presprimary2008
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	PRIMARYDATE date,
	WRITEIN number
	);

CREATE TABLE presprimary2008_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	PRIMARYDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	PRIMARYPCT varchar2(255),
	NOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimary2008.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimary2008
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, PRIMARYDATE, WRITEIN
	)
	(
	SELECT
	    presprimary2008_load.statenameabbreviation,
	    presprimary2008_load.statename,
	    presprimary2008_load.fecid,
	    presprimary2008_load.firstname,
	    presprimary2008_load.lastname,
	    presprimary2008_load.lastnamefirst,
	    CASE
	        WHEN presprimary2008_load.party = 'W(R)'   THEN 'R'
	        WHEN presprimary2008_load.party = 'W(AIP)' THEN 'AIP'
	        WHEN presprimary2008_load.party = 'W(LIB)' THEN 'LIB'
	        WHEN presprimary2008_load.party = 'W(D)'   THEN 'D'
	        WHEN presprimary2008_load.party = 'W(DCG)' THEN 'DCG'
	        WHEN presprimary2008_load.party = 'W(LU)'  THEN 'LU'
	        ELSE TRIM(presprimary2008_load.party)
	    END,
	    to_number(regexp_replace(presprimary2008_load.primaryresults, '\D+')),
	    TO_DATE(presprimary2008_load.primarydate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN presprimary2008_load.party IN (
	            'W',
	            'W(R)',
	            'W(AIP)',
	            'W(LIB)',
	            'W(D)',
	            'W(DCG)',
	            'W(LU)'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    presprimary2008_load
	WHERE
	    presprimary2008_load.lastnamefirst IS NOT NULL
	);

CREATE TABLE congress2008
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number, 
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2008_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	DISTRICT varchar2(255),
	FECID varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARY varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFF varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERAL varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFF varchar2(255),
	GERUNOFFPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2008.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2008
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2008_load.statenameabbreviation,
	    congress2008_load.statename,
	    congress2008_load.district,
	    congress2008_load.fecid,
	    nvl2(congress2008_load.incumbentindicator, 1, 0),
	    congress2008_load.candidatenamefirst,
	    congress2008_load.candidatenamelast,
	    congress2008_load.candidatename,
	    CASE
	        WHEN congress2008_load.party = 'N(D)'       THEN 'D'
	        WHEN congress2008_load.party = 'W(R)'       THEN 'R'
	        WHEN congress2008_load.party = 'W (D)'      THEN 'D'
	        WHEN congress2008_load.party = 'D/W'        THEN 'D'
	        WHEN congress2008_load.party = 'N(R)'       THEN 'R'
	        WHEN congress2008_load.party = 'N(NB)'      THEN 'NB'
	        WHEN congress2008_load.party = 'W(LBT)'     THEN 'LBT'
	        WHEN congress2008_load.party = 'W(R)/W'     THEN 'R'
	        WHEN congress2008_load.party = 'W(R)/R'     THEN 'R'
	        WHEN congress2008_load.party = 'W(LBT)/I'   THEN 'LBT'
	        WHEN congress2008_load.party = 'D/R'        THEN 'D'
	        WHEN congress2008_load.party = 'W(D)'       THEN 'D'
	        WHEN congress2008_load.party = 'W(DCG)'     THEN 'DCG'
	        WHEN congress2008_load.party = 'W(D)/W'     THEN 'D'
	        WHEN congress2008_load.party = 'D'          THEN 'D'
	        WHEN congress2008_load.party = 'W(CON)'     THEN 'CON'
	        WHEN congress2008_load.party = 'W(LU)'      THEN 'LU'
	        WHEN congress2008_load.party = 'W(LBT)/W'   THEN 'LBT'
	        WHEN congress2008_load.party = 'W(WF)'      THEN 'WF'
	        WHEN congress2008_load.party = 'R/IP#'      THEN 'R'
	        WHEN congress2008_load.party = 'D/IP'       THEN 'D'
	        WHEN congress2008_load.party = 'W(NPP)'     THEN 'NPP'
	        WHEN congress2008_load.party = 'W(GR)'      THEN 'GR'
	        WHEN congress2008_load.party = 'NPA*'       THEN 'NPA'
	        WHEN congress2008_load.party = 'R'          THEN 'R'
	        WHEN congress2008_load.party = 'N(GRE)'     THEN 'GRE'
	        WHEN congress2008_load.party = 'W(PRO)'     THEN 'PRO'
	        WHEN congress2008_load.party = 'W(WG)'      THEN 'WG'
	        WHEN congress2008_load.party = 'W(LBT)/LBT' THEN 'LBT'
	        WHEN congress2008_load.party = 'R/W'        THEN 'R'
	        ELSE TRIM(congress2008_load.party)
	    END,
	    to_number(regexp_replace(congress2008_load.primary, '\D+')),
	    to_number(regexp_replace(congress2008_load.runoff, '\D+')),
	    to_number(regexp_replace(congress2008_load.general, '\D+')),
	    to_number(regexp_replace(congress2008_load.gerunoff, '\D+')),
	    CASE
	        WHEN congress2008_load.general LIKE '%Un%' THEN 1
	        ELSE NULL
	    END,
	    congress2008_load.footnotes,
	    CASE
	        WHEN congress2008_load.party IN (
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
	    END
	FROM
	    congress2008_load
	WHERE
	    congress2008_load.candidatename IS NOT NULL
	);

CREATE TABLE labels2008
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2008_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2008.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2008
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2008_load
	);

CREATE TABLE primarydates2008
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date
	);

CREATE TABLE primarydates2008_load
	(
	RWID varchar2(255),
	STATENAME1 varchar2(255),
	PRESIDENTIALPRIMARYDATE varchar2(255),
	PRESIDENTIALCAUCUSDATE varchar2(255),
	UNUSED varchar2(255),
	SENATEINDICATOR varchar2(255),
	STATENAME varchar2(255),
	CONGRESSIONALPRIMARYDATE varchar2(255),
	CONGRESSIONALRUNOFFDATE	 varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2008.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2008
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
    SELECT
        initcap(primarydates2008_load.statename) statename,
        add_months(TO_DATE(primarydates2008_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS'), - 12) primarydate,
        add_months(TO_DATE(primarydates2008_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
    FROM
        primarydates2008_load
    WHERE
        primarydates2008_load.statename IS NOT NULL
	);

CREATE TABLE congress2010
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2010_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	DISTRICT varchar2(255),
	FECID varchar2(255),
	INCUMBENTINDICATOR varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARY varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFF varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERAL varchar2(255),
	GENERALPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2010.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2010
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2010_load.statenameabbreviation,
	    congress2010_load.statename,
	    congress2010_load.district,
	    congress2010_load.fecid,
	    nvl2(congress2010_load.incumbentindicator, 1, 0),
	    congress2010_load.candidatenamefirst,
	    congress2010_load.candidatenamelast,
	    congress2010_load.candidatename,
	    CASE
	        WHEN congress2010_load.party = 'W(AIP)'                 THEN 'AIP'
	        WHEN congress2010_load.party = 'DEM/W'                  THEN 'DEM'
	        WHEN congress2010_load.party = 'W(LIB)/LIB'             THEN 'LIB'
	        WHEN congress2010_load.party = 'W(LIB)'                 THEN 'LIB'
	        WHEN congress2010_load.party = 'W(GRE)'                 THEN 'GRE'
	        WHEN congress2010_load.party = 'W(REP)'                 THEN 'REP'
	        WHEN congress2010_load.party = 'PG/PRO'                 THEN 'PRO'
	        WHEN congress2010_load.party = 'DEM/IND'                THEN 'DEM'
	        WHEN congress2010_load.party = 'W(DEM)'                 THEN 'DEM'
	        WHEN congress2010_load.party = 'W(DCG)'                 THEN 'DCG'
	        WHEN congress2010_load.party = 'W(DEM'                  THEN 'DEM'
	        WHEN congress2010_load.party = 'REP/W'                  THEN 'REP'
	        WHEN congress2010_load.party = 'APP/LIB'                THEN 'LIB'
	        WHEN congress2010_load.party = 'IP*'                    THEN 'IP'
	        WHEN congress2010_load.party = 'W(CRV)'                 THEN 'CRV'
	        WHEN congress2010_load.party = 'CRV/TX'                 THEN 'CRV'
	        WHEN congress2010_load.party = 'W (Challenged Counted)' THEN 'W'
	        WHEN congress2010_load.party = 'W(DEM)/DEM'             THEN 'DEM'
	        WHEN congress2010_load.party = 'N(REP)'                 THEN 'REP'
	        WHEN congress2010_load.party = 'N(DEM)'                 THEN 'DEM'
	        WHEN congress2010_load.party = 'W(DNL)'                 THEN 'DNL'
	        WHEN congress2010_load.party = 'W(CON)/CON'             THEN 'CON'
	        WHEN congress2010_load.party = 'DEM/PRO/WF'             THEN 'DEM'
	        WHEN congress2010_load.party = 'W(PRO)'                 THEN 'PRO'
	        WHEN congress2010_load.party = 'W(WG)'                  THEN 'WG'
	        WHEN congress2010_load.party = 'REP/W***'               THEN 'REP'
	        WHEN congress2010_load.party = 'W(GRE)/GRE'             THEN 'GRE'
	        WHEN congress2010_load.party = 'W(REP)/REP'             THEN 'REP'
	        WHEN congress2010_load.party = 'W(REP)/W'               THEN 'REP'
	        WHEN congress2010_load.party = 'REP/TRP'                THEN 'REP'
	        ELSE TRIM(congress2010_load.party)
	    END,
	    to_number(regexp_replace(congress2010_load.primary, '\D+')),
	    to_number(regexp_replace(congress2010_load.runoff, '\D+')),
	    to_number(regexp_replace(congress2010_load.general, '\D+')),
	    CASE
	        WHEN congress2010_load.general LIKE '%Un%' THEN 1
	        ELSE NULL
	    END,
	    congress2010_load.footnotes,
	    CASE
	        WHEN congress2010_load.party IN (
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
	    END
	FROM
	    congress2010_load
	WHERE
	    congress2010_load.candidatename IS NOT NULL
	    AND ( congress2010_load.runoff NOT LIKE '%Comb'
	          OR congress2010_load.runoff IS NULL )
	    AND congress2010_load.party != 'W (Challenged NOT Counted)'
	);

CREATE TABLE labels2010
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2010_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2010.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2010
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2010_load
	);

CREATE TABLE primarydates2010
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date	
	);

CREATE TABLE primarydates2010_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	SENATEINDICATOR varchar2(255),
	CONGRESSIONALPRIMARYDATE varchar2(255),
	CONGRESSIONALRUNOFFDATE varchar2(255)	
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2010.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2010
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
    SELECT
        initcap(primarydates2010_load.statename) statename,
        TO_DATE(primarydates2010_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        TO_DATE(primarydates2010_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2010_load
    WHERE
        primarydates2010_load.statename IS NOT NULL
	);

CREATE TABLE presgeneral2012
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	GENERALVOTES number,
	GEWINNER number,
	GENERALELECTIONDATE date,
	WRITEIN number
	);

CREATE TABLE presgeneral2012_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	GENERALELECTIONDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	GENERALRESULTS varchar2(255),
	TOTALVOTESNUMBER varchar2(255),
	GENERALPCT varchar2(255),
	WINNERINDICATOR varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presgeneral2012.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presgeneral2012
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, GENERALVOTES, GEWINNER, GENERALELECTIONDATE, WRITEIN
	)
	(
	SELECT
	    presgeneral2012_load.statenameabbreviation,
	    presgeneral2012_load.statename,
	    presgeneral2012_load.fecid,
	    presgeneral2012_load.firstname,
	    presgeneral2012_load.lastname,
	    presgeneral2012_load.lastnamefirst,
	    TRIM(presgeneral2012_load.party),
	    to_number(regexp_replace(presgeneral2012_load.generalresults, '\D+')),
	    nvl2(presgeneral2012_load.winnerindicator, 1, 0),
	    TO_DATE(presgeneral2012_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN presgeneral2012_load.party = 'W' THEN 1
	        ELSE 0
	    END
	FROM
	    presgeneral2012_load
	WHERE
	    presgeneral2012_load.lastnamefirst IS NOT NULL
	    AND presgeneral2012_load.party NOT LIKE '%Comb%')
	;

CREATE TABLE presprimary2012
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	PRIMARYDATE date,
	WRITEIN number
	);

CREATE TABLE presprimary2012_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	PRIMARYDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	PRIMARYPCT varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimary2012.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimary2012
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, PRIMARYDATE, WRITEIN
	)
	(
	SELECT
	    presprimary2012_load.statenameabbreviation,
	    presprimary2012_load.statename,
	    presprimary2012_load.fecid,
	    presprimary2012_load.firstname,
	    presprimary2012_load.lastname,
	    presprimary2012_load.lastnamefirst,
	    CASE
	        WHEN presprimary2012_load.party = 'W(R)'   THEN 'R'
	        WHEN presprimary2012_load.party = 'W(AIP)' THEN 'AIP'
	        WHEN presprimary2012_load.party = 'W(D)'   THEN 'D'
	        WHEN presprimary2012_load.party = 'W(DCG)' THEN 'DCG'
	        WHEN presprimary2012_load.party = 'W(GR)'  THEN 'GR'
	        ELSE TRIM(presprimary2012_load.party)
	    END,
	    to_number(regexp_replace(presprimary2012_load.primaryresults, '\D+')),
	    TO_DATE(presprimary2012_load.primarydate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN presprimary2012_load.party IN (
	            'W',
	            'W(R)',
	            'W(AIP)',
	            'W(D)',
	            'W(DCG)',
	            'W(GR)'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    presprimary2012_load
	WHERE
	    presprimary2012_load.lastnamefirst IS NOT NULL
	);

CREATE TABLE congress2012
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number,
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE congress2012_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	STATENAME varchar2(255),
	D varchar2(255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFVOTES varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALVOTES varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFFELECTIONVOTES varchar2(255),
	GERUNOFFELECTIONPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	GEWINNERINDICATOR varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('congress2012.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO congress2012
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    congress2012_load.statenameabbreviation,
	    congress2012_load.statename,
	    congress2012_load.d,
	    congress2012_load.fecid,
	    nvl2(congress2012_load.incumbent, 1, 0),
	    congress2012_load.candidatenamefirst,
	    congress2012_load.candidatenamelast,
	    congress2012_load.candidatename,
	    CASE
	        WHEN congress2012_load.party = 'W(PAF)'     THEN 'PAF'
	        WHEN congress2012_load.party = 'W(D)/D'     THEN 'D'
	        WHEN congress2012_load.party = 'N(D)'       THEN 'D'
	        WHEN congress2012_load.party = 'R/CON'      THEN 'R'
	        WHEN congress2012_load.party = 'W(AE)/AE'   THEN 'AE'
	        WHEN congress2012_load.party = 'W(R)'       THEN 'R'
	        WHEN congress2012_load.party = 'D/W'        THEN 'D'
	        WHEN congress2012_load.party = 'W(R)/W'     THEN 'R'
	        WHEN congress2012_load.party = 'N(R)'       THEN 'R'
	        WHEN congress2012_load.party = 'W(LIB)/LIB' THEN 'LIB'
	        WHEN congress2012_load.party = 'W(R)/R'     THEN 'R'
	        WHEN congress2012_load.party = 'W(LIB)'     THEN 'LIB'
	        WHEN congress2012_load.party = 'W(GRE)'     THEN 'GRE'
	        WHEN congress2012_load.party = 'D/WF'       THEN 'D'
	        WHEN congress2012_load.party = 'D/IND'      THEN 'D'
	        WHEN congress2012_load.party = 'W(AE)'      THEN 'AE'
	        WHEN congress2012_load.party = 'W(D)'       THEN 'D'
	        WHEN congress2012_load.party = 'W(DCG)'     THEN 'DCG'
	        WHEN congress2012_load.party = 'W(IND)'     THEN 'IND'
	        WHEN congress2012_load.party = 'W(CON)'     THEN 'CON'
	        WHEN congress2012_load.party = 'R/TRP'      THEN 'R'
	        WHEN congress2012_load.party = 'W(GR)'      THEN 'GR'
	        WHEN congress2012_load.party = 'CRV/LIB'    THEN 'CRV'
	        WHEN congress2012_load.party = 'W(DNL)'     THEN 'DNL'
	        WHEN congress2012_load.party = 'W(PRO)'     THEN 'PRO'
	        WHEN congress2012_load.party = 'W(GRE)/GRE' THEN 'GRE'
	        WHEN congress2012_load.party = 'D/PRO/WF'   THEN 'D'
	        ELSE TRIM(congress2012_load.party)
	    END party,
	    to_number(regexp_replace(congress2012_load.primaryvotes, '\D+')) primaryvotes,
	    to_number(regexp_replace(congress2012_load.runoffvotes, '\D+')) runoffvotes,
	    to_number(regexp_replace(congress2012_load.generalvotes, '\D+')) generalvotes,
	    to_number(regexp_replace(congress2012_load.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
	    nvl2(congress2012_load.gewinnerindicator, 1, 0) gewinner,
	    congress2012_load.footnotes   notes,
	    CASE
	        WHEN congress2012_load.party IN (
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
	    congress2012_load
	WHERE
	    congress2012_load.d IS NOT NULL
	    AND congress2012_load.candidatename IS NOT NULL
	    AND congress2012_load.party NOT IN (
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
	    congress2012_load.statenameabbreviation   postal,
	    congress2012_load.statename,
	    congress2012_load.d                       district,
	    congress2012_load.fecid,
	    nvl2(congress2012_load.incumbent, 1, 0) incumbent,
	    congress2012_load.candidatenamefirst,
	    congress2012_load.candidatename           candidatenamelast,
	    congress2012_load.candidatenamelast       candidatename,
	    TRIM(congress2012_load.totalvotes) party,
	    to_number(regexp_replace(congress2012_load.party, '\D+')) primaryvotes,
	    to_number(regexp_replace(congress2012_load.primarypct, '\D+')) runoffvotes,
	    to_number(regexp_replace(congress2012_load.runoffpct, '\D+')) generalvotes,
	    to_number(regexp_replace(congress2012_load.generalpct, '\D+')) gerunoffelectionvotes,
	    nvl2(congress2012_load.gewinnerindicator, 1, 0) gewinner,
	    congress2012_load.footnotes               notes,
	    0 writein
	FROM
	    congress2012_load
	WHERE
	    congress2012_load.d IS NOT NULL
	    AND congress2012_load.fecid IS NOT NULL
	    AND congress2012_load.candidatename IS NULL
	);

CREATE TABLE labels2012
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2012_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2012.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2012
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2012_load
	);

CREATE TABLE primarydates2012
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date
	);

CREATE TABLE primarydates2012_load
	(
	RWID varchar2(255),
	STATENAME1 varchar2(255),
	PRESIDENTIALPRIMARYDATE varchar2(255),
	PRESIDENTIALCAUCUSDATE varchar2(255),
	UNUSED varchar2(255),
	SENATEINDICATOR varchar2(255),
	STATENAME varchar2(255),
	CONGRESSIONALPRIMARYDATE varchar2(255),
	CONGRESSIONALRUNOFFDATE	 varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2012.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2012
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
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
	            initcap(primarydates2012_load.statename) statename,
	            CASE
	                WHEN REGEXP_LIKE ( primarydates2012_load.congressionalprimarydate,
	                                   '\/' ) THEN TO_DATE(regexp_substr(primarydates2012_load.congressionalprimarydate, '^\d\/\d{2}'
	                                   )
	                                                       || '/'
	                                                       || '2012', 'MM/DD/YYYY')
	                ELSE TO_DATE(primarydates2012_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS')
	            END primarydate,
	            TO_DATE(primarydates2012_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
	        FROM
	            primarydates2012_load
	        WHERE
	            primarydates2012_load.statename IS NOT NULL
	    )	
	);

CREATE TABLE house2014
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number,
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE house2014_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	STATENAME varchar2(255),
	D varchar2(255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFVOTES varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALVOTES varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFFELECTIONVOTES varchar2(255),
	GERUNOFFELECTIONPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	GEWINNERINDICATOR varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('house2014.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO house2014
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    house2014_load.statenameabbreviation,
	    house2014_load.statename,
	    house2014_load.d,
	    house2014_load.fecid,
	    nvl2(house2014_load.incumbent, 1, 0) incumbent,
	    house2014_load.candidatenamefirst,
	    house2014_load.candidatenamelast,
	    house2014_load.candidatename,
	    CASE
	        WHEN house2014_load.party = 'W(NOP)'     THEN 'NOP'
	        WHEN house2014_load.party = 'W(PAF)/PAF' THEN 'PAF'
	        WHEN house2014_load.party = 'N(D)'       THEN 'D'
	        WHEN house2014_load.party = 'W(AE)/AE'   THEN 'AE'
	        WHEN house2014_load.party = 'W(AIP)'     THEN 'AIP'
	        WHEN house2014_load.party = 'W(R)'       THEN 'R'
	        WHEN house2014_load.party = 'D/W'        THEN 'D'
	        WHEN house2014_load.party = 'N(R)'       THEN 'R'
	        WHEN house2014_load.party = 'N(LIB)'     THEN 'LIB'
	        WHEN house2014_load.party = 'R/CON*'     THEN 'R'
	        WHEN house2014_load.party = 'W(R)/W'     THEN 'R'
	        WHEN house2014_load.party = 'W(LIB)/LIB' THEN 'LIB'
	        WHEN house2014_load.party = 'W(LIB)'     THEN 'LIB'
	        WHEN house2014_load.party = 'W(R)/R'     THEN 'R'
	        WHEN house2014_load.party = 'W(D)'       THEN 'D'
	        WHEN house2014_load.party = 'W(DCG)'     THEN 'DCG'
	        WHEN house2014_load.party = 'W(CON)'     THEN 'CON'
	        WHEN house2014_load.party = 'R/TRP'      THEN 'R'
	        WHEN house2014_load.party = 'CRV/LIB'    THEN 'CRV'
	        WHEN house2014_load.party = 'R'          THEN 'R'
	        WHEN house2014_load.party = 'W(DNL)'     THEN 'DWL'
	        WHEN house2014_load.party = 'W(LBU)'     THEN 'LBU'
	        WHEN house2014_load.party = 'W(PRO)'     THEN 'PRO'
	        WHEN house2014_load.party = 'R/W'        THEN 'R'
	        ELSE TRIM(house2014_load.party)
	    END party,
	    to_number(regexp_replace(house2014_load.primaryvotes, '\D+')),
	    to_number(regexp_replace(house2014_load.runoffvotes, '\D+')),
	    to_number(regexp_replace(house2014_load.generalvotes, '\D+')),
	    to_number(regexp_replace(house2014_load.gerunoffelectionvotes, '\D+')),
	    nvl2(house2014_load.gewinnerindicator, 1, 0),
	    house2014_load.footnotes,
	    CASE
	        WHEN house2014_load.party IN (
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
	    END 
	FROM
	    house2014_load
	WHERE
	    house2014_load.candidatename IS NOT NULL
	    AND house2014_load.party != 'Combined Parties:'
	);

CREATE TABLE senate2014
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number,
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE senate2014_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	STATENAME varchar2(255),
	D varchar2(255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFVOTES varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALVOTES varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFFELECTIONVOTES varchar2(255),
	GERUNOFFELECTIONPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	GEWINNERINDICATOR varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('senate2014.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO senate2014
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    senate2014_load.statenameabbreviation,
	    senate2014_load.statename,
	    senate2014_load.d,
	    senate2014_load.fecid,
	    nvl2(senate2014_load.incumbent, 1, 0),
	    senate2014_load.candidatenamefirst,
	    senate2014_load.candidatenamelast,
	    senate2014_load.candidatename,
	    CASE
	        WHEN senate2014_load.party = 'W(R)'   THEN 'R'
	        WHEN senate2014_load.party = 'N(R)'   THEN 'R'
	        WHEN senate2014_load.party = 'W(D)'   THEN 'D'
	        WHEN senate2014_load.party = 'N(DEM)' THEN 'D'
	        WHEN senate2014_load.party = 'R/W'    THEN 'R'
	        ELSE TRIM(senate2014_load.party)
	    END,
	    to_number(regexp_replace(senate2014_load.primaryvotes, '\D+')),
	    to_number(regexp_replace(senate2014_load.runoffvotes, '\D+')),
	    to_number(regexp_replace(senate2014_load.generalvotes, '\D+')),
	    to_number(regexp_replace(senate2014_load.gerunoffelectionvotes, '\D+')),
	    nvl2(senate2014_load.gewinnerindicator, 1, 0),
	    senate2014_load.footnotes,
	    CASE
	        WHEN senate2014_load.party IN (
	            'W',
	            'W(R)',
	            'N(R)',
	            'W(D)',
	            'R',
	            'N(DEM)',
	            'R/W'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    senate2014_load
	WHERE
	    senate2014_load.candidatename IS NOT NULL);

CREATE TABLE labels2014
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2014_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2014.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2014
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2014_load
	);

CREATE TABLE primarydates2014
	(
	STATENAME varchar2(255),
	PRIMARYDATE varchar2(255),
	RUNOFFDATE varchar2(255)	
	);

CREATE TABLE primarydates2014_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAME varchar2(255),
	CONGRESSIONALPRIMARYDATE varchar2(255),
	CONGRESSIONALRUNOFFDATE varchar2(255)	
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('primarydates2014.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2014
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
	SELECT
	    initcap(primarydates2014_load.statename) statename,
	    CASE
	        WHEN REGEXP_LIKE ( primarydates2014_load.congressionalprimarydate,
	                           '\/' ) THEN TO_DATE(regexp_substr(primarydates2014_load.congressionalprimarydate, '^\d\/\d+')
	                                               || '/'
	                                               || '2014', 'MM/DD/YYYY')
	        ELSE TO_DATE(primarydates2014_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS')
	    END primarydate,
	    TO_DATE(primarydates2014_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
	FROM
	    primarydates2014_load
	WHERE
    primarydates2014_load.statename IS NOT NULL	);

CREATE TABLE presgeneral2016
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	GENERALVOTES number,
	GEWINNER number,
	GENERALELECTIONDATE date,
	WRITEIN number
	);

CREATE TABLE presgeneral2016_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	GENERALELECTIONDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	GENERALRESULTS varchar2(255),
	TOTALVOTESNUMBER varchar2(255),
	GENERALPCT varchar2(255),
	WINNERINDICATOR varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presgeneral2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presgeneral2016
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, GENERALVOTES, GEWINNER, GENERALELECTIONDATE, WRITEIN
	)
	(
	SELECT
	    presgeneral2016_load.statenameabbreviation,
	    presgeneral2016_load.statename,
	    presgeneral2016_load.fecid,
	    presgeneral2016_load.firstname,
	    presgeneral2016_load.lastname,
	    presgeneral2016_load.lastnamefirst,
	    CASE
	        WHEN presgeneral2016_load.party = 'REP'     THEN 'R'
	        WHEN presgeneral2016_load.party = 'PG/PRO'  THEN 'PRO'
	        WHEN presgeneral2016_load.party = 'REP/AIP' THEN 'R'
	        WHEN presgeneral2016_load.party = 'DEM'     THEN 'D'
	        ELSE TRIM(presgeneral2016_load.party)
	    END,
	    to_number(regexp_replace(presgeneral2016_load.generalresults, '\D+')),
	    nvl2(presgeneral2016_load.winnerindicator, 1, 0),
	    TO_DATE(presgeneral2016_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS'),
	    CASE
	        WHEN presgeneral2016_load.party = 'W' THEN 1
	        ELSE 0
	    END
	FROM
	    presgeneral2016_load
	WHERE
	    presgeneral2016_load.lastnamefirst IS NOT NULL
	    AND presgeneral2016_load.party != 'Combined Parties:'
	);

CREATE TABLE presprimary2016
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	FECID varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	PRIMARYDATE date,
	NOTES varchar2(255),
	WRITEIN number
	);

CREATE TABLE presprimary2016_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	FECID varchar2(255),
	STATENAME varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	PRIMARYDATE varchar2(255),
	FIRSTNAME varchar2(255),
	LASTNAME varchar2(255),
	LASTNAMEFIRST varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYRESULTS varchar2(255),
	PRIMARYPCT varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('presprimary2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO presprimary2016
	(
	POSTAL, STATENAME, FECID, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, PRIMARYDATE, NOTES, WRITEIN
	)
	(
	SELECT
	    presprimary2016_load.statenameabbreviation,
	    presprimary2016_load.statename,
	    presprimary2016_load.fecid,
	    presprimary2016_load.firstname,
	    presprimary2016_load.lastname,
	    presprimary2016_load.lastnamefirst,
	    CASE
	        WHEN presprimary2016_load.party = 'W(R)'  THEN 'R'
	        WHEN presprimary2016_load.party = 'W(D)'  THEN 'D'
	        WHEN presprimary2016_load.party = 'W(GR)' THEN 'GR'
	        WHEN presprimary2016_load.party = 'W(IP)' THEN 'IP'
	        ELSE TRIM(presprimary2016_load.party)
	    END,
	    to_number(regexp_replace(presprimary2016_load.primaryresults, '\D+')),
	    TO_DATE(presprimary2016_load.primarydate, 'YYYY-MM-DD HH24:MI:SS'),
	    presprimary2016_load.footnotes,
	    CASE
	        WHEN presprimary2016_load.party IN (
	            'W',
	            'W(R)',
	            'W(D)',
	            'W(GR)',
	            'W(IP)'
	        ) THEN 1
	        ELSE 0
	    END
	FROM
	    presprimary2016_load
	WHERE
	    presprimary2016_load.lastnamefirst IS NOT NULL
);

CREATE TABLE house2016
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number,
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE house2016_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	STATENAME varchar2(255),
	D varchar2(255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFVOTES varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALVOTES varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFFELECTIONVOTES varchar2(255),
	GERUNOFFELECTIONPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	GEWINNERINDICATOR varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('house2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO house2016
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    house2016_load.statenameabbreviation,
	    house2016_load.statename,
	    house2016_load.d,
	    house2016_load.fecid,
	    nvl2(house2016_load.incumbent, 1, 0),
	    house2016_load.candidatenamefirst,
	    house2016_load.candidatenamelast,
	    house2016_load.candidatename,
	    CASE
	        WHEN house2016_load.party = 'W(NOP)'      THEN 'NOP'
	        WHEN house2016_load.party = 'W(D)/D'      THEN 'D'
	        WHEN house2016_load.party = 'R/CON'       THEN 'R'
	        WHEN house2016_load.party = 'W(R)'        THEN 'R'
	        WHEN house2016_load.party = 'R/IP'        THEN 'R'
	        WHEN house2016_load.party = 'W(PPD)'      THEN 'PPD'
	        WHEN house2016_load.party = 'W(LIB)'      THEN 'LIB'
	        WHEN house2016_load.party = 'W(GRE)'      THEN 'GRE'
	        WHEN house2016_load.party = 'W(R)/R'      THEN 'R'
	        WHEN house2016_load.party = 'IP/R'        THEN 'IP'
	        WHEN house2016_load.party = 'D/R'         THEN 'D'
	        WHEN house2016_load.party = 'W(D)'        THEN 'D'
	        WHEN house2016_load.party = 'W(DCG)'      THEN 'DCG'
	        WHEN house2016_load.party = 'W(IND)'      THEN 'IND'
	        WHEN house2016_load.party = 'D/PRO/WF/IP' THEN 'D'
	        WHEN house2016_load.party = 'W(D)/W'      THEN 'D'
	        WHEN house2016_load.party = 'W(CON)'      THEN 'CON'
	        WHEN house2016_load.party = 'R/TRP'       THEN 'R'
	        WHEN house2016_load.party = 'D/IP'        THEN 'D'
	        WHEN house2016_load.party = 'W(NPP)'      THEN 'NPP'
	        WHEN house2016_load.party = 'W(IP)'       THEN 'IP'
	        WHEN house2016_load.party = 'W(DNL)'      THEN 'DNL'
	        WHEN house2016_load.party = 'W(PRO)'      THEN 'PRO'
	        WHEN house2016_load.party = 'W(WG)'       THEN 'WG'
	        WHEN house2016_load.party = 'W(GRE)/GRE'  THEN 'GRE'
	        WHEN house2016_load.party = 'R/W'         THEN 'R'
	        ELSE TRIM(house2016_load.party)
	    END,
	    to_number(regexp_replace(house2016_load.primaryvotes, '\D+')),
	    to_number(regexp_replace(house2016_load.runoffvotes, '\D+')),
	    to_number(regexp_replace(house2016_load.generalvotes, '\D+')),
	    to_number(regexp_replace(house2016_load.gerunoffelectionvotes, '\D+')),
	    nvl2(house2016_load.gewinnerindicator, 1, 0),
	    house2016_load.footnotes,
	    CASE
	        WHEN house2016_load.party IN (
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
	    END
	FROM
	    house2016_load
	WHERE
	    house2016_load.candidatename IS NOT NULL
	UNION
	SELECT
	    house2016_load.statenameabbreviation,
	    house2016_load.statename,
	    house2016_load.d,
	    house2016_load.fecid,
	    nvl2(house2016_load.incumbent, 1, 0),
	    house2016_load.candidatenamefirst,
	    house2016_load.candidatename,
	    house2016_load.candidatenamelast,
	    TRIM(house2016_load.totalvotes),
	    to_number(regexp_replace(house2016_load.party, '\D+')),
	    to_number(regexp_replace(house2016_load.primarypct, '\D+')),
	    to_number(regexp_replace(house2016_load.runoffpct, '\D+')),
	    to_number(regexp_replace(house2016_load.generalpct, '\D+')),
	    nvl2(house2016_load.combinedpct, 1, 0),
	    house2016_load.footnotes,
	    0
	FROM
	    house2016_load
	WHERE
	    house2016_load.fecid IS NOT NULL
	    AND house2016_load.candidatename IS NULL
	);

CREATE TABLE senate2016
	(
	POSTAL varchar2(255),
	STATENAME varchar2(255),
	DISTRICT varchar2(255), 
	FECID varchar2(255), 
	INCUMBENT number, 
	CANDIDATENAMEFIRST varchar2(255), 
	CANDIDATENAMELAST varchar2(255), 
	CANDIDATENAME varchar2(255), 
	PARTY varchar2(255), 
	PRIMARYVOTES number, 
	RUNOFFVOTES number, 
	GENERALVOTES number,
	GERUNOFFELECTIONVOTES number, 
	GEWINNER number, 
	NOTES varchar2(255), 
	WRITEIN number
	);

CREATE TABLE senate2016_load
	(
	RWID varchar2(255),
	UNUSED varchar2(255),
	STATENAMEABBREVIATION varchar2(255),
	STATENAME varchar2(255),
	D varchar2(255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	TOTALVOTES varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES varchar2(255),
	PRIMARYPCT varchar2(255),
	RUNOFFVOTES varchar2(255),
	RUNOFFPCT varchar2(255),
	GENERALVOTES varchar2(255),
	GENERALPCT varchar2(255),
	GERUNOFFELECTIONVOTES varchar2(255),
	GERUNOFFELECTIONPCT varchar2(255),
	COMBINEDGEPARTYTOTALS varchar2(255),
	COMBINEDPCT varchar2(255),
	GEWINNERINDICATOR varchar2(255),
	FOOTNOTES varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('senate2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO senate2016
	(
	POSTAL, STATENAME, DISTRICT, FECID, INCUMBENT, CANDIDATENAMEFIRST, CANDIDATENAMELAST, CANDIDATENAME, PARTY, PRIMARYVOTES, RUNOFFVOTES, GENERALVOTES, GERUNOFFELECTIONVOTES, GEWINNER, NOTES, WRITEIN
	)
	(
	SELECT
	    senate2016_load.statenameabbreviation,
	    senate2016_load.statename,
	    senate2016_load.d,
	    senate2016_load.fecid,
	    nvl2(senate2016_load.incumbent, 1, 0),
	    senate2016_load.candidatenamefirst,
	    senate2016_load.candidatenamelast,
	    senate2016_load.candidatename,
	    CASE
	        WHEN senate2016_load.party = 'W(R)'   THEN 'R'
	        WHEN senate2016_load.party = 'N(R)'   THEN 'R'
	        WHEN senate2016_load.party = 'W(D)'   THEN 'D'
	        WHEN senate2016_load.party = 'N(DEM)' THEN 'D'
	        WHEN senate2016_load.party = 'R/W'    THEN 'R'
	        ELSE TRIM(senate2016_load.party)
	    END,
	    to_number(regexp_replace(senate2016_load.primaryvotes, '\D+')),
	    to_number(regexp_replace(senate2016_load.runoffvotes, '\D+')),
	    to_number(regexp_replace(senate2016_load.generalvotes, '\D+')),
	    to_number(regexp_replace(senate2016_load.gerunoffelectionvotes, '\D+')),
	    nvl2(senate2016_load.gewinnerindicator, 1, 0),
	    senate2016_load.footnotes,
	    CASE
	        WHEN senate2016_load.party IN (
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
	    END
	FROM
	    senate2016_load
	WHERE
	    senate2016_load.candidatename IS NOT NULL
	UNION
	SELECT
	    senate2016_load.statenameabbreviation,
	    senate2016_load.statename,
	    senate2016_load.d,
	    senate2016_load.fecid,
	    nvl2(senate2016_load.incumbent, 1, 0),
	    senate2016_load.candidatenamefirst,
	    senate2016_load.candidatename,
	    senate2016_load.candidatenamelast,
	    TRIM(senate2016_load.totalvotes),
	    to_number(regexp_replace(senate2016_load.party, '\D+')),
	    to_number(regexp_replace(senate2016_load.primarypct, '\D+')),
	    to_number(regexp_replace(senate2016_load.runoffpct, '\D+')),
	    to_number(regexp_replace(senate2016_load.generalpct, '\D+')),
	    nvl2(senate2016_load.gewinnerindicator, 1, 0),
	    senate2016_load.footnotes,
	    0
	FROM
	    senate2016_load
	WHERE
	    senate2016_load.fecid = 'S6CA00980 '
    );
 

CREATE TABLE labels2016
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255)
	);

CREATE TABLE labels2016_load
	(
	RWID varchar2(255),
	ABBREVIATION varchar2(255),
	EQUALS varchar2(255),
	PARTYNAME varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('labels2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO labels2016
	(
	ABBREVIATION,PARTYNAME
	)
	(
	SELECT	ABBREVIATION,PARTYNAME
	FROM	labels2016_load
	);

CREATE TABLE primarydates2016
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date
	);

CREATE TABLE primarydates2016_load
	(
	RWID varchar2(255),
	STATENAME1 varchar2(255),
	PRESIDENTIALPRIMARYDATE varchar2(255),
	PRESIDENTIALCAUCUSDATE varchar2(255),
	UNUSED varchar2(255),
	SENATE varchar2(255),
	STATENAME varchar2(255),
	CONGRESSIONALPRIMARY varchar2(255),
	CONGRESSIONALRUNOFF varchar2(255)
	)
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_hoc_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('dates2016.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO primarydates2016
	(
	STATENAME,PRIMARYDATE,RUNOFFDATE
	)
	(
	SELECT
	    initcap(primarydates2016_load.statename) statename,
	    CASE
	        WHEN REGEXP_LIKE ( primarydates2016_load.congressionalprimary,
	                           '\/' ) THEN TO_DATE(regexp_substr(primarydates2016_load.congressionalprimary, '^\d\/\d+')
	                                               || '/'
	                                               || '2016', 'MM/DD/YYYY')
	        ELSE add_months(TO_DATE(primarydates2016_load.congressionalprimary, 'YYYY-MM-DD HH24:MI:SS'), - 12)
	    END primarydate,
	    add_months(TO_DATE(primarydates2016_load.congressionalrunoff, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
	FROM
	    primarydates2016_load
	WHERE
	    primarydates2016_load.statename IS NOT NULL	
	);