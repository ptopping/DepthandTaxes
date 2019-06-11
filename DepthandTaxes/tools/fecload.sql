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

CREATE TABLE presprimary2000_load
	(
	RWID varchar2(255),
	STATENAME varchar2(255),
	CANDIDATE varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
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

CREATE TABLE presprimarydates2000
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	PARTY varchar2(255)
	);

CREATE TABLE partylabels
	(
	ABBREVIATION varchar2(255),
	PARTYNAME varchar2(255),
	GENERALELECTIONDATE date
	);

CREATE TABLE congressionalprimarydates
	(
	STATENAME varchar2(255),
	PRIMARYDATE date,
	RUNOFFDATE date	
	);

INSERT INTO partylabels
	(
	ABBREVIATION,PARTYNAME,GENERALELECTIONDATE
	)
	(
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/07/2000', 'MM/DD/YYYY')
	FROM labels2000_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/05/2002', 'MM/DD/YYYY')
	FROM labels2002_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/02/2004', 'MM/DD/YYYY')
	FROM labels2004_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/07/2006', 'MM/DD/YYYY')
	FROM labels2006_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/04/2008', 'MM/DD/YYYY')
	FROM labels2008_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/02/2010', 'MM/DD/YYYY')
	FROM labels2010_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/06/2012', 'MM/DD/YYYY')
	FROM labels2012_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/04/2014', 'MM/DD/YYYY')
	FROM labels2014_load
	UNION
	SELECT
	TRIM(ABBREVIATION),PARTYNAME,TO_DATE('11/08/2016', 'MM/DD/YYYY')
	FROM labels2016_load
	);

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

INSERT INTO congressionalprimarydates
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
	UNION
	SELECT
	    initcap(primarydates2004_load.statename),
	    TO_DATE(primarydates2004_load.primary, 'YYYY-MM-DD HH24:MI:SS'),
	    TO_DATE(primarydates2004_load.runoff, 'YYYY-MM-DD HH24:MI:SS')
	FROM
    primarydates2004_load	
    UNION
	SELECT
	    initcap(primarydates2006_load.statename),
        add_months(TO_DATE(primarydates2006_load.primary, 'YYYY-MM-DD HH24:MI:SS'), - 12),
        add_months(TO_DATE(primarydates2006_load.runoff, 'YYYY-MM-DD HH24:MI:SS'), - 12)
	FROM	primarydates2006_load
	UNION
    SELECT
        initcap(primarydates2008_load.statename) statename,
        add_months(TO_DATE(primarydates2008_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS'), - 12) primarydate,
        add_months(TO_DATE(primarydates2008_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS'), - 12) runoffdate
    FROM
        primarydates2008_load
    WHERE
        primarydates2008_load.statename IS NOT NULL
    UNION
    SELECT
        initcap(primarydates2010_load.statename) statename,
        TO_DATE(primarydates2010_load.congressionalprimarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
        TO_DATE(primarydates2010_load.congressionalrunoffdate, 'YYYY-MM-DD HH24:MI:SS') runoffdate
    FROM
        primarydates2010_load
    WHERE
        primarydates2010_load.statename IS NOT NULL
    UNION
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
	UNION
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
    primarydates2014_load.statename IS NOT NULL
    UNION
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

CREATE TABLE fecresults
	(
	POSTAL varchar2(255),
	STATENAME varchar2 (255),
	DISTRICT varchar2 (255),
	FECID varchar2(255),
	INCUMBENT varchar2(255),
	CANDIDATENAMEFIRST varchar2(255),
	CANDIDATENAMELAST varchar2(255),
	CANDIDATENAME varchar2(255),
	PARTY varchar2(255),
	PRIMARYVOTES number,
	RUNOFFVOTES number,
	GENERALVOTES number,
	GENERALPCT number,
	GERUNOFFELECTIONVOTES number,
	COMBINEDGEPARTYTOTALS number,
	GEWINNER number,
	NOTES varchar2(255),
	GENERALELECTIONDATE date,
	PRIMARYDATE date,
	RUNOFFDATE date,
	GERUNOFFDATE date,
	WRITEIN number
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GENERALELECTIONDATE,PRIMARYDATE,WRITEIN
	)
	(
	SELECT
	    pres2000.postal,
	    postalcodes.statename,
	    'President',
	    0,
	    pres2000.candidatenamefirst,
	    pres2000.candidatenamelast,
	    pres2000.candidatename,
	    partylabels.partyname,
	    pres2000.primaryvotes,
	    pres2000.generalvotes,
	    combpct.generalvotes,
	    TO_DATE('11/07/2000', 'MM/DD/YYYY'),
	    presprimarydates2000.primarydate,
	    pres2000.writein
	FROM
	    (
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
	                    (
	                        SELECT
	                            presgeneral2000_load.statename   postal,
	                            regexp_substr(presgeneral2000_load.candidate, '[^,]+', 1, 2) candidatenamefirst,
	                            regexp_substr(presgeneral2000_load.candidate, '[^,]+', 1, 1) candidatenamelast,
	                            presgeneral2000_load.candidate   candidatename,
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
	                            END party,
	                            to_number(regexp_replace(presgeneral2000_load.numberofvotes, '\D+')) generalvotes,
	                            CASE
	                                WHEN presgeneral2000_load.party = 'W' THEN 1
	                                ELSE 0
	                            END writein
	                        FROM
	                            presgeneral2000_load
	                        WHERE
	                            presgeneral2000_load.statename != 'ZZZZ'
	                            AND presgeneral2000_load.numberofvotes != 0
	                    ) presgeneral2000
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
	                    (
	                        SELECT
	                            presprimary2000_load.statename   postal,
	                            regexp_substr(presprimary2000_load.candidate, '[^,]+', 1, 2) candidatenamefirst,
	                            regexp_substr(presprimary2000_load.candidate, '[^,]+', 1, 1) candidatenamelast,
	                            presprimary2000_load.candidate   candidatename,
	                            CASE
	                                WHEN presprimary2000_load.party = 'UN(R)'  THEN 'R'
	                                WHEN presprimary2000_load.party = 'W(R)'   THEN 'R'
	                                WHEN presprimary2000_load.party = 'UN(D)'  THEN 'D'
	                                WHEN presprimary2000_load.party = 'W(D)'   THEN 'D'
	                                WHEN presprimary2000_load.party = 'W(N)'   THEN 'N'
	                                WHEN presprimary2000_load.party = 'W(GRN)' THEN 'GRN'
	                                WHEN presprimary2000_load.party = 'W(REF)' THEN 'REF'
	                                ELSE TRIM(presprimary2000_load.party)
	                            END party,
	                            to_number(regexp_replace(presprimary2000_load.numberofvotes, '\D+')) primaryvotes,
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
	                            END writein
	                        FROM
	                            presprimary2000_load
	                        WHERE
	                            presprimary2000_load.percent IS NOT NULL
	                    ) presprimary2000
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
	    ) pres2000
	    LEFT JOIN (
	        SELECT
	            presgeneral2000_load.statename   postal,
	            initcap(presgeneral2000_load.candidate) statename
	        FROM
	            presgeneral2000_load
	        WHERE
	            presgeneral2000_load.numberofvotes = 0
	    ) postalcodes ON pres2000.postal = postalcodes.postal
	    LEFT JOIN partylabels ON pres2000.party = partylabels.abbreviation
	                             AND partylabels.generalelectiondate = TO_DATE('11/07/2000', 'MM/DD/YYYY')
	    LEFT JOIN (
	        SELECT
	            presgeneral2000_load.statename   postal,
	            presgeneral2000_load.candidate   candidatename,
	            COUNT(presgeneral2000_load.candidate) count,
	            SUM(to_number(regexp_replace(presgeneral2000_load.numberofvotes, '\D+'))) generalvotes
	        FROM
	            presgeneral2000_load
	        GROUP BY
	            presgeneral2000_load.statename,
	            presgeneral2000_load.candidate
	        HAVING
	            COUNT(presgeneral2000_load.candidate) > 1
	    ) combpct ON pres2000.candidatename = combpct.candidatename
	                 AND pres2000.postal = combpct.postal
	    LEFT JOIN presprimarydates2000 ON postalcodes.statename = presprimarydates2000.statename
	                                      AND pres2000.party = presprimarydates2000.party	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,NOTES,GENERALELECTIONDATE,PRIMARYDATE,WRITEIN
	)
	(
	SELECT
	    pres2004.postal,
	    pres2004.statename,
	    'President',
	    pres2004.fecid,
	    CASE
	        WHEN pres2004.candidatename LIKE '%Bush%' THEN 1
	        ELSE 0
	    END,
	    pres2004.candidatenamefirst,
	    pres2004.candidatenamelast,
	    pres2004.candidatename,
	    partylabels.partyname,
	    pres2004.primaryvotes,
	    pres2004.generalvotes,
	    combpct.generalvotes,
	    pres2004.notes,
	    pres2004.generalelectiondate,
	    pres2004.primarydate,
	    pres2004.writein
	FROM
	    (
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
	            CASE
	                WHEN pg.generalelectiondate IS NULL THEN TO_DATE('11/02/2004', 'MM/DD/YYYY')
	                ELSE pg.generalelectiondate
	            END generalelectiondate,
	            CASE
	                WHEN pg.writein IS NULL THEN pp.writein
	                ELSE pg.writein
	            END writein,
	            pp.primarydate
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
	                    ) presgeneral2004
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
	                    (
	                        SELECT
	                            presprimary2004_load.statenameabbreviation   postal,
	                            presprimary2004_load.statename,
	                            presprimary2004_load.fecid,
	                            presprimary2004_load.firstname               candidatenamefirst,
	                            presprimary2004_load.lastname                candidatenamelast,
	                            presprimary2004_load.lastnamefirst           candidatename,
	                            CASE
	                                WHEN presprimary2004_load.party = 'W(PFP)'  THEN 'PFP'
	                                WHEN presprimary2004_load.party = 'W(R)'    THEN 'R'
	                                WHEN presprimary2004_load.party = 'W(LBT)'  THEN 'LBT'
	                                WHEN presprimary2004_load.party = 'UN(D)'   THEN 'D'
	                                WHEN presprimary2004_load.party = 'W(D)'    THEN 'D'
	                                WHEN presprimary2004_load.party = 'UN(AIP)' THEN 'AIP'
	                                WHEN presprimary2004_load.party = 'W(GRN)'  THEN 'GRN'
	                                ELSE TRIM(presprimary2004_load.party)
	                            END party,
	                            to_number(regexp_replace(presprimary2004_load.primaryresults, '\D+')) primaryvotes,
	                            presprimary2004_load.notes,
	                            TO_DATE(presprimary2004_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
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
	                            END writein
	                        FROM
	                            presprimary2004_load
	                        WHERE
	                            presprimary2004_load.lastnamefirst IS NOT NULL
	                    ) presprimary2004
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
	                    AND pg.candidatename = pp.candidatename
	                    AND pg.party = pp.party
	    ) pres2004
	    LEFT JOIN partylabels ON pres2004.party = partylabels.abbreviation
	                             AND partylabels.generalelectiondate = TO_DATE('11/02/2004', 'MM/DD/YYYY')
	    LEFT JOIN (
	        SELECT
	            presgeneral2004_load.statenameabbreviation   postal,
	            presgeneral2004_load.lastnamefirst           candidatename,
	            COUNT(presgeneral2004_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(presgeneral2004_load.generalresults, '\D+'))) generalvotes
	        FROM
	            presgeneral2004_load
	        GROUP BY
	            presgeneral2004_load.statenameabbreviation,
	            presgeneral2004_load.lastnamefirst
	        HAVING
	            COUNT(presgeneral2004_load.lastnamefirst) > 1
	    ) combpct ON pres2004.candidatename = combpct.candidatename
	                 AND pres2004.postal = combpct.postal	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,NOTES,GENERALELECTIONDATE,PRIMARYDATE,WRITEIN
	)
	(
	SELECT
	    pres2008.postal,
	    pres2008.statename,
	    'President',
	    pres2008.fecid,
	    0,
	    pres2008.candidatenamefirst,
	    pres2008.candidatenamelast,
	    pres2008.candidatename,
	    partylabels.partyname,
	    pres2008.primaryvotes,
	    pres2008.generalvotes,
	    combpct.generalvotes,
	    pres2008.notes,
	    pres2008.generalelectiondate,
	    pres2008.primarydate,
	    pres2008.writein
	FROM
	    (
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
	            pp.notes,
	            CASE
	                WHEN pg.generalelectiondate IS NULL THEN TO_DATE('11/04/2008', 'MM/DD/YYYY')
	                ELSE pg.generalelectiondate
	            END generalelectiondate,
	            CASE
	                WHEN pg.writein IS NULL THEN pp.writein
	                ELSE pg.writein
	            END writein,
	            pp.primarydate
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
	                    (
	                        SELECT
	                            presgeneral2008_load.statenameabbreviation   postal,
	                            presgeneral2008_load.statename,
	                            presgeneral2008_load.fecid,
	                            presgeneral2008_load.firstname               candidatenamefirst,
	                            presgeneral2008_load.lastname                candidatenamelast,
	                            presgeneral2008_load.lastnamefirst           candidatename,
	                            TRIM(presgeneral2008_load.party) party,
	                            to_number(regexp_replace(presgeneral2008_load.generalresults, '\D+')) generalvotes,
	                            TO_DATE(presgeneral2008_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
	                            CASE
	                                WHEN replace(presgeneral2008_load.party, ' ', '') = 'W' THEN 1
	                                ELSE 0
	                            END writein
	                        FROM
	                            presgeneral2008_load
	                        WHERE
	                            presgeneral2008_load.lastnamefirst IS NOT NULL
	                            AND presgeneral2008_load.party NOT LIKE '%Comb%'
	                    ) presgeneral2008
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
	                    presprimary2008.notes,
	                    presprimary2008.primarydate,
	                    presprimary2008.writein
	                FROM
	                    (
	                        SELECT
	                            presprimary2008_load.statenameabbreviation   postal,
	                            presprimary2008_load.statename,
	                            presprimary2008_load.fecid,
	                            presprimary2008_load.firstname               candidatenamefirst,
	                            presprimary2008_load.lastname                candidatenamelast,
	                            presprimary2008_load.lastnamefirst           candidatename,
	                            CASE
	                                WHEN presprimary2008_load.party = 'W(R)'   THEN 'R'
	                                WHEN presprimary2008_load.party = 'W(AIP)' THEN 'AIP'
	                                WHEN presprimary2008_load.party = 'W(LIB)' THEN 'LIB'
	                                WHEN presprimary2008_load.party = 'W(D)'   THEN 'D'
	                                WHEN presprimary2008_load.party = 'W(DCG)' THEN 'DCG'
	                                WHEN presprimary2008_load.party = 'W(LU)'  THEN 'LU'
	                                ELSE TRIM(presprimary2008_load.party)
	                            END party,
	                            to_number(regexp_replace(presprimary2008_load.primaryresults, '\D+')) primaryvotes,
	                            presprimary2008_load.notes,
	                            TO_DATE(presprimary2008_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
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
	                            END writein
	                        FROM
	                            presprimary2008_load
	                        WHERE
	                            presprimary2008_load.lastnamefirst IS NOT NULL
	                    ) presprimary2008
	                GROUP BY
	                    presprimary2008.postal,
	                    presprimary2008.statename,
	                    presprimary2008.fecid,
	                    presprimary2008.candidatenamefirst,
	                    presprimary2008.candidatenamelast,
	                    presprimary2008.candidatename,
	                    presprimary2008.party,
	                    presprimary2008.notes,
	                    presprimary2008.primarydate,
	                    presprimary2008.writein
	            ) pp ON pg.postal = pp.postal
	                    AND pg.candidatename = pp.candidatename
	                    AND pg.party = pp.party
	    ) pres2008
	    LEFT JOIN partylabels ON pres2008.party = partylabels.abbreviation
	                             AND partylabels.generalelectiondate = TO_DATE('11/04/2008', 'MM/DD/YYYY')
	    LEFT JOIN (
	        SELECT
	            presgeneral2008_load.statenameabbreviation   postal,
	            presgeneral2008_load.lastnamefirst           candidatename,
	            COUNT(presgeneral2008_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(presgeneral2008_load.generalresults, '\D+'))) generalvotes
	        FROM
	            presgeneral2008_load
	        GROUP BY
	            presgeneral2008_load.statenameabbreviation,
	            presgeneral2008_load.lastnamefirst
	        HAVING
	            COUNT(presgeneral2008_load.lastnamefirst) > 1
	    ) combpct ON pres2008.candidatename = combpct.candidatename
	                 AND pres2008.postal = combpct.postal
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,GENERALELECTIONDATE,PRIMARYDATE,WRITEIN
	)
	(
	SELECT
	    pres2012.postal,
	    pres2012.statename,
	    'President',
	    pres2012.fecid,
	    CASE
	        WHEN pres2012.candidatename LIKE '%Obama%' THEN 1
	        ELSE 0
	    END,
	    pres2012.candidatenamefirst,
	    pres2012.candidatenamelast,
	    pres2012.candidatename,
	    partylabels.partyname,
	    pres2012.primaryvotes,
	    pres2012.generalvotes,
	    combpct.generalvotes,
	    pres2012.gewinner,
	    pres2012.generalelectiondate,
	    pres2012.primarydate,
	    pres2012.writein
	FROM
	    (
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
	                WHEN pg.generalelectiondate IS NULL THEN TO_DATE('11/06/2012', 'MM/DD/YYYY')
	                ELSE pg.generalelectiondate
	            END generalelectiondate,
	            CASE
	                WHEN pg.writein IS NULL THEN pp.writein
	                ELSE pg.writein
	            END writein,
	            pp.primarydate,
	            pg.gewinner
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
	                    (
	                        SELECT
	                            presgeneral2012_load.statenameabbreviation   postal,
	                            presgeneral2012_load.statename,
	                            presgeneral2012_load.fecid,
	                            presgeneral2012_load.firstname               candidatenamefirst,
	                            presgeneral2012_load.lastname                candidatenamelast,
	                            presgeneral2012_load.lastnamefirst           candidatename,
	                            TRIM(presgeneral2012_load.party) party,
	                            to_number(regexp_replace(presgeneral2012_load.generalresults, '\D+')) generalvotes,
	                            nvl2(presgeneral2012_load.winnerindicator, 1, 0) gewinner,
	                            TO_DATE(presgeneral2012_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
	                            CASE
	                                WHEN presgeneral2012_load.party = 'W' THEN 1
	                                ELSE 0
	                            END writein
	                        FROM
	                            presgeneral2012_load
	                        WHERE
	                            presgeneral2012_load.lastnamefirst IS NOT NULL
	                            AND presgeneral2012_load.party NOT LIKE '%Comb%'
	                    ) presgeneral2012
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
	                    (
	                        SELECT
	                            presprimary2012_load.statenameabbreviation   postal,
	                            presprimary2012_load.statename,
	                            presprimary2012_load.fecid,
	                            presprimary2012_load.firstname               candidatenamefirst,
	                            presprimary2012_load.lastname                candidatenamelast,
	                            presprimary2012_load.lastnamefirst           candidatename,
	                            CASE
	                                WHEN presprimary2012_load.party = 'W(R)'   THEN 'R'
	                                WHEN presprimary2012_load.party = 'W(AIP)' THEN 'AIP'
	                                WHEN presprimary2012_load.party = 'W(D)'   THEN 'D'
	                                WHEN presprimary2012_load.party = 'W(DCG)' THEN 'DCG'
	                                WHEN presprimary2012_load.party = 'W(GR)'  THEN 'GR'
	                                ELSE TRIM(presprimary2012_load.party)
	                            END party,
	                            to_number(regexp_replace(presprimary2012_load.primaryresults, '\D+')) primaryvotes,
	                            TO_DATE(presprimary2012_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
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
	                            END writein
	                        FROM
	                            presprimary2012_load
	                        WHERE
	                            presprimary2012_load.lastnamefirst IS NOT NULL
	                    ) presprimary2012
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
	                    AND pg.candidatename = pp.candidatename
	                    AND pg.party = pp.party
	    ) pres2012
	    LEFT JOIN partylabels ON pres2012.party = partylabels.abbreviation
	                             AND partylabels.generalelectiondate = TO_DATE('11/06/2012', 'MM/DD/YYYY')
	    LEFT JOIN (
	        SELECT
	            presgeneral2012_load.statenameabbreviation   postal,
	            presgeneral2012_load.lastnamefirst           candidatename,
	            COUNT(presgeneral2012_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(presgeneral2012_load.generalresults, '\D+'))) generalvotes
	        FROM
	            presgeneral2012_load
	        GROUP BY
	            presgeneral2012_load.statenameabbreviation,
	            presgeneral2012_load.lastnamefirst
	        HAVING
	            COUNT(presgeneral2012_load.lastnamefirst) > 1
	    ) combpct ON pres2012.candidatename = combpct.candidatename
	                 AND pres2012.postal = combpct.postal
    );

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,GENERALELECTIONDATE,PRIMARYDATE,WRITEIN,
	NOTES
	)
	(
	SELECT
	    pres2016.postal,
	    pres2016.statename,
	    'President',
	    pres2016.fecid,
	    0,
	    pres2016.candidatenamefirst,
	    pres2016.candidatenamelast,
	    pres2016.candidatename,
	    partylabels.partyname,
	    pres2016.primaryvotes,
	    pres2016.generalvotes,
	    combpct.generalvotes,
	    pres2016.gewinner,
	    pres2016.generalelectiondate,
	    pres2016.primarydate,
	    pres2016.writein,
	    pres2016.notes
	FROM
	    (
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
	                WHEN pg.generalelectiondate IS NULL THEN TO_DATE('11/08/2016', 'MM/DD/YYYY')
	                ELSE pg.generalelectiondate
	            END generalelectiondate,
	            CASE
	                WHEN pg.writein IS NULL THEN pp.writein
	                ELSE pg.writein
	            END writein,
	            pp.primarydate,
	            pg.gewinner,
	            pp.notes
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
	                    (
	                        SELECT
	                            presgeneral2016_load.statenameabbreviation   postal,
	                            presgeneral2016_load.statename,
	                            presgeneral2016_load.fecid,
	                            presgeneral2016_load.firstname               candidatenamefirst,
	                            presgeneral2016_load.lastname                candidatenamelast,
	                            presgeneral2016_load.lastnamefirst           candidatename,
	                            CASE
	                                WHEN presgeneral2016_load.party = 'REP'     THEN 'R'
	                                WHEN presgeneral2016_load.party = 'PG/PRO'  THEN 'PRO'
	                                WHEN presgeneral2016_load.party = 'REP/AIP' THEN 'R'
	                                WHEN presgeneral2016_load.party = 'DEM'     THEN 'D'
	                                ELSE TRIM(presgeneral2016_load.party)
	                            END party,
	                            to_number(regexp_replace(presgeneral2016_load.generalresults, '\D+')) generalvotes,
	                            nvl2(presgeneral2016_load.winnerindicator, 1, 0) gewinner,
	                            TO_DATE(presgeneral2016_load.generalelectiondate, 'YYYY-MM-DD HH24:MI:SS') generalelectiondate,
	                            CASE
	                                WHEN presgeneral2016_load.party = 'W' THEN 1
	                                ELSE 0
	                            END writein
	                        FROM
	                            presgeneral2016_load
	                        WHERE
	                            presgeneral2016_load.lastnamefirst IS NOT NULL
	                            AND presgeneral2016_load.party != 'Combined Parties:'
	                    ) presgeneral2016
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
	                    presprimary2016.primarydate,
	                    presprimary2016.notes,
	                    presprimary2016.writein
	                FROM
	                    (
	                        SELECT
	                            presprimary2016_load.statenameabbreviation   postal,
	                            presprimary2016_load.statename,
	                            presprimary2016_load.fecid,
	                            presprimary2016_load.firstname               candidatenamefirst,
	                            presprimary2016_load.lastname                candidatenamelast,
	                            presprimary2016_load.lastnamefirst           candidatename,
	                            CASE
	                                WHEN presprimary2016_load.party = 'W(R)'  THEN 'R'
	                                WHEN presprimary2016_load.party = 'W(D)'  THEN 'D'
	                                WHEN presprimary2016_load.party = 'W(GR)' THEN 'GR'
	                                WHEN presprimary2016_load.party = 'W(IP)' THEN 'IP'
	                                ELSE TRIM(presprimary2016_load.party)
	                            END party,
	                            to_number(regexp_replace(presprimary2016_load.primaryresults, '\D+')) primaryvotes,
	                            TO_DATE(presprimary2016_load.primarydate, 'YYYY-MM-DD HH24:MI:SS') primarydate,
	                            presprimary2016_load.footnotes               notes,
	                            CASE
	                                WHEN presprimary2016_load.party IN (
	                                    'W',
	                                    'W(R)',
	                                    'W(D)',
	                                    'W(GR)',
	                                    'W(IP)'
	                                ) THEN 1
	                                ELSE 0
	                            END writein
	                        FROM
	                            presprimary2016_load
	                        WHERE
	                            presprimary2016_load.lastnamefirst IS NOT NULL
	                    ) presprimary2016
	                GROUP BY
	                    presprimary2016.postal,
	                    presprimary2016.statename,
	                    presprimary2016.fecid,
	                    presprimary2016.candidatenamefirst,
	                    presprimary2016.candidatenamelast,
	                    presprimary2016.candidatename,
	                    presprimary2016.party,
	                    presprimary2016.primarydate,
	                    presprimary2016.notes,
	                    presprimary2016.writein
	            ) pp ON pg.postal = pp.postal
	                    AND pg.candidatename = pp.candidatename
	                    AND pg.party = pp.party
	    ) pres2016
	    LEFT JOIN partylabels ON pres2016.party = partylabels.abbreviation
	                             AND partylabels.generalelectiondate = TO_DATE('11/08/2016', 'MM/DD/YYYY')
	    LEFT JOIN (
	        SELECT
	            presgeneral2016_load.statenameabbreviation   postal,
	            presgeneral2016_load.lastnamefirst           candidatename,
	            COUNT(presgeneral2016_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(presgeneral2016_load.generalresults, '\D+'))) generalvotes
	        FROM
	            presgeneral2016_load
	        GROUP BY
	            presgeneral2016_load.statenameabbreviation,
	            presgeneral2016_load.lastnamefirst
	        HAVING
	            COUNT(presgeneral2016_load.lastnamefirst) > 1
	    ) combpct ON pres2016.candidatename = combpct.candidatename
	                 AND pres2016.postal = combpct.postal
    );

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GENERALELECTIONDATE,WRITEIN
	)
	(
	SELECT
	   senate2000.postal,
	   postalcodes.statename,
	   senate2000.district,
	   senate2000.incumbent,
	   senate2000.candidatenamefirst,
	   senate2000.candidatenamelast,
	   senate2000.candidatename,
	   partylabels.partyname,
	   senate2000.primaryvotes,
	   senate2000.runoffvotes,
	   senate2000.generalvotes,
	   combpct.generalvotes,
	   TO_DATE('11/07/2000', 'MM/DD/YYYY'),
	   senate2000.writein
	FROM
	   (
	       SELECT
	           senate2000_load.statename   postal,
	           senate2000_load.district,
	           nvl2(senate2000_load.incumbentindicator, 1, 0) incumbent,
	           regexp_substr(senate2000_load.name, '[^,]+', 1, 2) candidatenamefirst,
	           regexp_substr(senate2000_load.name, '[^,]+', 1, 1) candidatenamelast,
	           senate2000_load.name        candidatename,
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
	           END party,
	           to_number(regexp_replace(senate2000_load.primaryresults, '\D+')) primaryvotes,
	           to_number(regexp_replace(senate2000_load.runoffresults, '\D+')) runoffvotes,
	           to_number(regexp_replace(senate2000_load.generalresults, '\D+')) generalvotes,
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
	           END writein
	       FROM
	           senate2000_load
	       WHERE
	           senate2000_load.combinedparties IS NULL
	   ) senate2000
	   LEFT JOIN (
	       SELECT
	           presgeneral2000_load.statename   postal,
	           initcap(presgeneral2000_load.candidate) statename
	       FROM
	           presgeneral2000_load
	       WHERE
	           presgeneral2000_load.numberofvotes = 0
	   ) postalcodes ON senate2000.postal = postalcodes.postal
	   LEFT JOIN partylabels ON senate2000.party = partylabels.abbreviation
	                            AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2000
	   LEFT JOIN (
	       SELECT
	           senate2000_load.statename   postal,
	           senate2000_load.name        candidatename,
	           senate2000_load.district,
	           COUNT(senate2000_load.name) count,
	           SUM(to_number(regexp_replace(senate2000_load.generalresults, '\D+'))) generalvotes
	       FROM
	           senate2000_load
	       GROUP BY
	           senate2000_load.statename,
	           senate2000_load.name,
	           senate2000_load.district
	       HAVING
	           COUNT(senate2000_load.name) > 1
	   ) combpct ON senate2000.candidatename = combpct.candidatename
	                AND senate2000.postal = combpct.postal
	                AND senate2000.district = combpct.district
    );

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GENERALELECTIONDATE,GEWINNER,WRITEIN
	)
	(
	SELECT
	    house2000.postal,
	    postalcodes.statename,
	    house2000.district,
	    house2000.incumbent,
	    house2000.candidatenamefirst,
	    house2000.candidatenamelast,
	    house2000.candidatename,
	    partylabels.partyname,
	    house2000.primaryvotes,
	    house2000.runoffvotes,
	    house2000.generalvotes,
	    combpct.generalvotes,
	    TO_DATE('11/07/2000', 'MM/DD/YYYY'),
	    house2000.gewinner,
	    house2000.writein
	FROM
	    (
	        SELECT
	            house2000_load.statename   postal,
	            house2000_load.district,
	            nvl2(house2000_load.incumbentindicator, 1, 0) incumbent,
	            regexp_substr(house2000_load.name, '[^,]+', 1, 2) candidatenamefirst,
	            regexp_substr(house2000_load.name, '[^,]+', 1, 1) candidatenamelast,
	            house2000_load.name        candidatename,
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
	            END party,
	            to_number(regexp_replace(house2000_load.primaryresults, '\D+')) primaryvotes,
	            to_number(regexp_replace(house2000_load.runoffresults, '\D+')) runoffvotes,
	            to_number(regexp_replace(house2000_load.generalresults, '\D+')) generalvotes,
	            CASE
	                WHEN house2000_load.generalresults LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
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
	            END writein
	        FROM
	            house2000_load
	        WHERE
	            house2000_load.statename IS NOT NULL
	            AND house2000_load.party != 'Combined'
	    ) house2000
	    LEFT JOIN (
	        SELECT
	            presgeneral2000_load.statename   postal,
	            initcap(presgeneral2000_load.candidate) statename
	        FROM
	            presgeneral2000_load
	        WHERE
	            presgeneral2000_load.numberofvotes = 0
	    ) postalcodes ON house2000.postal = postalcodes.postal
	    LEFT JOIN partylabels ON house2000.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2000
	    LEFT JOIN (
	        SELECT
	            house2000_load.statename   postal,
	            house2000_load.name        candidatename,
	            house2000_load.district,
	            COUNT(house2000_load.name) count,
	            SUM(to_number(regexp_replace(house2000_load.generalresults, '\D+'))) generalvotes
	        FROM
	            house2000_load
	        GROUP BY
	            house2000_load.statename,
	            house2000_load.name,
	            house2000_load.district
	        HAVING
	            COUNT(house2000_load.name) > 1
	    ) combpct ON house2000.candidatename = combpct.candidatename
	                 AND house2000.postal = combpct.postal
	                 AND house2000.district = combpct.district	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2002.postal,
	    postalcodes.statename,
	    congress2002.district,
	    congress2002.fecid,
	    congress2002.incumbent,
	    congress2002.candidatenamefirst,
	    congress2002.candidatenamelast,
	    congress2002.candidatename,
	    partylabels.partyname,
	    congress2002.primaryvotes,
	    congress2002.runoffvotes,
	    congress2002.generalvotes,
	    congress2002.gerunoffelectionvotes,
	    combpct.generalvotes,
	    congress2002.gewinner,
	    congress2002.notes,
	    TO_DATE('11/05/2002', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2002.writein
	FROM
	    (
	        SELECT
	            congress2002_load.statename       postal,
	            congress2002_load.district,
	            congress2002_load.fecid,
	            nvl2(congress2002_load.incumbentindicator, 1, 0) incumbent,
	            congress2002_load.firstname       candidatenamefirst,
	            congress2002_load.lastname        candidatenamelast,
	            congress2002_load.lastnamefirst   candidatename,
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
	            END party,
	            to_number(regexp_replace(congress2002_load.primaryresults, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2002_load.runoffresults, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2002_load.generalresults, '\D+')) generalvotes,
	            to_number(regexp_replace(congress2002_load.generalrunoffresults, '\D+')) gerunoffelectionvotes,
	            CASE
	                WHEN congress2002_load.generalresults LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
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
	            END writein
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
	            congress2002_load.statename   postal,
	            congress2002_load.district,
	            congress2002_load.fecid,
	            nvl2(congress2002_load.incumbentindicator, 1, 0) incumbent,
	            congress2002_load.firstname   candidatenamefirst,
	            congress2002_load.lastname    candidatenamelast,
	            congress2002_load.lastname
	            || ','
	            || ' '
	            || congress2002_load.firstname candidatename,
	            TRIM(congress2002_load.totalvotes) party,
	            to_number(regexp_replace(congress2002_load.party, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2002_load.runoffresults, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2002_load.generalresults, '\D+')) generalvotes,
	            to_number(regexp_replace(congress2002_load.generalrunoffresults, '\D+')) gerunoffelectionvotes,
	            NULL gewinner,
	            congress2002_load.notes,
	            0 writein
	        FROM
	            congress2002_load
	        WHERE
	            congress2002_load.fecid IS NOT NULL
	            AND congress2002_load.lastnamefirst IS NULL
	    ) congress2002
	    LEFT JOIN (
	        SELECT
	            presgeneral2000_load.statename   postal,
	            initcap(presgeneral2000_load.candidate) statename
	        FROM
	            presgeneral2000_load
	        WHERE
	            presgeneral2000_load.numberofvotes = 0
	    ) postalcodes ON congress2002.postal = postalcodes.postal
	    LEFT JOIN partylabels ON congress2002.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2002
	    LEFT JOIN (
	        SELECT
	            congress2002_load.statename       postal,
	            congress2002_load.lastnamefirst   candidatename,
	            congress2002_load.district,
	            COUNT(congress2002_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(congress2002_load.generalresults, '\D+'))) generalvotes
	        FROM
	            congress2002_load
	        GROUP BY
	            congress2002_load.statename,
	            congress2002_load.lastnamefirst,
	            congress2002_load.district
	        HAVING
	            COUNT(congress2002_load.lastnamefirst) > 1
	    ) combpct ON congress2002.candidatename = combpct.candidatename
	                 AND congress2002.postal = combpct.postal
	                 AND congress2002.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON postalcodes.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2002
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2002 )	
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2004.postal,
	    congress2004.statename,
	    congress2004.district,
	    congress2004.fecid,
	    congress2004.incumbent,
	    congress2004.candidatenamefirst,
	    congress2004.candidatenamelast,
	    congress2004.candidatename,
	    partylabels.partyname,
	    congress2004.primaryvotes,
	    congress2004.runoffvotes,
	    congress2004.generalvotes,
	    congress2004.gerunoffelectionvotes,
	    combpct.generalvotes,
	    congress2004.gewinner,
	    congress2004.notes,
	    TO_DATE('11/02/2004', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2004.writein
	FROM
	    (
	        SELECT
	            congress2004_load.statenameabbreviation   postal,
	            congress2004_load.statename,
	            congress2004_load.district,
	            congress2004_load.fecid,
	            nvl2(congress2004_load.incumbentindicator, 1, 0) incumbent,
	            congress2004_load.firstname               candidatenamefirst,
	            congress2004_load.lastname                candidatenamelast,
	            congress2004_load.lastnamefirst           candidatename,
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
	            END party,
	            to_number(regexp_replace(congress2004_load.primary, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2004_load.runoff, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2004_load.general, '\D+')) generalvotes,
	            to_number(regexp_replace(congress2004_load.gerunoff, '\D+')) gerunoffelectionvotes,
	            CASE
	                WHEN congress2004_load.general LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
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
	            END writein
	        FROM
	            congress2004_load
	        WHERE
	            congress2004_load.lastnamefirst IS NOT NULL
	            AND ( congress2004_load.runoffpct NOT LIKE '%Comb%'
	                  OR congress2004_load.runoffpct IS NULL )
	    ) congress2004
	    LEFT JOIN partylabels ON congress2004.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2004
	    LEFT JOIN (
	        SELECT
	            congress2004_load.statenameabbreviation   postal,
	            congress2004_load.lastnamefirst           candidatename,
	            congress2004_load.district,
	            COUNT(congress2004_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(congress2004_load.general, '\D+'))) generalvotes
	        FROM
	            congress2004_load
	        GROUP BY
	            congress2004_load.statenameabbreviation,
	            congress2004_load.lastnamefirst,
	            congress2004_load.district
	        HAVING
	            COUNT(congress2004_load.lastnamefirst) > 1
	    ) combpct ON congress2004.candidatename = combpct.candidatename
	                 AND congress2004.postal = combpct.postal
	                 AND congress2004.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON congress2004.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2004
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2004 )	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2006.postal,
	    congress2006.statename,
	    congress2006.district,
	    congress2006.fecid,
	    congress2006.incumbent,
	    congress2006.candidatenamefirst,
	    congress2006.candidatenamelast,
	    congress2006.candidatename,
	    partylabels.partyname,
	    congress2006.primaryvotes,
	    congress2006.runoffvotes,
	    congress2006.generalvotes,
	    congress2006.gerunoffelectionvotes,
	    combpct.generalvotes,
	    congress2006.gewinner,
	    congress2006.notes,
	    TO_DATE('11/07/2006', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2006.writein
	FROM
	    (
	        SELECT
	            congress2006_load.statenameabbreviation   postal,
	            congress2006_load.statename,
	            congress2006_load.district,
	            congress2006_load.fecid,
	            nvl2(congress2006_load.incumbentindicator, 1, 0) incumbent,
	            congress2006_load.firstname               candidatenamefirst,
	            congress2006_load.lastname                candidatenamelast,
	            congress2006_load.lastnamefirst           candidatename,
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
	            END party,
	            to_number(regexp_replace(congress2006_load.primary, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2006_load.runoff, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2006_load.general, '\D+')) generalvotes,
	            to_number(regexp_replace(congress2006_load.gerunoff, '\D+')) gerunoffelectionvotes,
	            CASE
	                WHEN congress2006_load.general LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
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
	            END writein
	        FROM
	            congress2006_load
	        WHERE
	            congress2006_load.lastnamefirst IS NOT NULL
	    ) congress2006
	    LEFT JOIN partylabels ON congress2006.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2006
	    LEFT JOIN (
	        SELECT
	            congress2006_load.statenameabbreviation   postal,
	            congress2006_load.lastnamefirst           candidatename,
	            congress2006_load.district,
	            COUNT(congress2006_load.lastnamefirst) count,
	            SUM(to_number(regexp_replace(congress2006_load.general, '\D+'))) generalvotes
	        FROM
	            congress2006_load
	        GROUP BY
	            congress2006_load.statenameabbreviation,
	            congress2006_load.lastnamefirst,
	            congress2006_load.district
	        HAVING
	            COUNT(congress2006_load.lastnamefirst) > 1
	    ) combpct ON congress2006.candidatename = combpct.candidatename
	                 AND congress2006.postal = combpct.postal
	                 AND congress2006.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON congress2006.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2006
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2006 )
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2008.postal,
	    congress2008.statename,
	    congress2008.district,
	    congress2008.fecid,
	    congress2008.incumbent,
	    congress2008.candidatenamefirst,
	    congress2008.candidatenamelast,
	    congress2008.candidatename,
	    partylabels.partyname,
	    congress2008.primaryvotes,
	    congress2008.runoffvotes,
	    congress2008.generalvotes,
	    congress2008.gerunoffelectionvotes,
	    combpct.generalvotes,
	    congress2008.gewinner,
	    congress2008.notes,
	    TO_DATE('11/04/2008', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2008.writein
	FROM
	    (
	        SELECT
	            congress2008_load.statenameabbreviation   postal,
	            congress2008_load.statename,
	            congress2008_load.district,
	            congress2008_load.fecid,
	            nvl2(congress2008_load.incumbentindicator, 1, 0) incumbent,
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
	            END party,
	            to_number(regexp_replace(congress2008_load.primary, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2008_load.runoff, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2008_load.general, '\D+')) generalvotes,
	            to_number(regexp_replace(congress2008_load.gerunoff, '\D+')) gerunoffelectionvotes,
	            CASE
	                WHEN congress2008_load.general LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
	            congress2008_load.footnotes               notes,
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
	            END writein
	        FROM
	            congress2008_load
	        WHERE
	            congress2008_load.candidatename IS NOT NULL
	    ) congress2008
	    LEFT JOIN partylabels ON congress2008.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2008
	    LEFT JOIN (
	        SELECT
	            congress2008_load.statenameabbreviation   postal,
	            congress2008_load.candidatename,
	            congress2008_load.district,
	            COUNT(congress2008_load.candidatename) count,
	            SUM(to_number(regexp_replace(congress2008_load.general, '\D+'))) generalvotes
	        FROM
	            congress2008_load
	        GROUP BY
	            congress2008_load.statenameabbreviation,
	            congress2008_load.candidatename,
	            congress2008_load.district
	        HAVING
	            COUNT(congress2008_load.candidatename) > 1
	    ) combpct ON congress2008.candidatename = combpct.candidatename
	                 AND congress2008.postal = combpct.postal
	                 AND congress2008.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON congress2008.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2008
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2008 )	
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2010.postal,
	    congress2010.statename,
	    congress2010.district,
	    congress2010.fecid,
	    congress2010.incumbent,
	    congress2010.candidatenamefirst,
	    congress2010.candidatenamelast,
	    congress2010.candidatename,
	    partylabels.partyname,
	    congress2010.primaryvotes,
	    congress2010.runoffvotes,
	    congress2010.generalvotes,
	    combpct.generalvotes,
	    congress2010.gewinner,
	    congress2010.notes,
	    TO_DATE('11/02/2010', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2010.writein
	FROM
	    (
	        SELECT
	            congress2010_load.statenameabbreviation   postal,
	            congress2010_load.statename,
	            congress2010_load.district,
	            congress2010_load.fecid,
	            nvl2(congress2010_load.incumbentindicator, 1, 0) incumbent,
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
	            END party,
	            to_number(regexp_replace(congress2010_load.primary, '\D+')) primaryvotes,
	            to_number(regexp_replace(congress2010_load.runoff, '\D+')) runoffvotes,
	            to_number(regexp_replace(congress2010_load.general, '\D+')) generalvotes,
	            CASE
	                WHEN congress2010_load.general LIKE '%Un%' THEN 1
	                ELSE NULL
	            END gewinner,
	            congress2010_load.footnotes               notes,
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
	            END writein
	        FROM
	            congress2010_load
	        WHERE
	            congress2010_load.candidatename IS NOT NULL
	            AND ( congress2010_load.runoff NOT LIKE '%Comb'
	                  OR congress2010_load.runoff IS NULL )
	            AND congress2010_load.party != 'W (Challenged NOT Counted)'
	    ) congress2010
	    LEFT JOIN partylabels ON congress2010.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2010
	    LEFT JOIN (
	        SELECT
	            congress2010_load.statenameabbreviation   postal,
	            congress2010_load.candidatename,
	            congress2010_load.district,
	            COUNT(congress2010_load.candidatename) count,
	            SUM(to_number(regexp_replace(congress2010_load.general, '\D+'))) generalvotes
	        FROM
	            congress2010_load
	        GROUP BY
	            congress2010_load.statenameabbreviation,
	            congress2010_load.candidatename,
	            congress2010_load.district
	        HAVING
	            COUNT(congress2010_load.candidatename) > 1
	    ) combpct ON congress2010.candidatename = combpct.candidatename
	                 AND congress2010.postal = combpct.postal
	                 AND congress2010.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON congress2010.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2010
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2010 )
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    congress2012.postal,
	    congress2012.statename,
	    congress2012.district,
	    congress2012.fecid,
	    congress2012.incumbent,
	    congress2012.candidatenamefirst,
	    congress2012.candidatenamelast,
	    congress2012.candidatename,
	    partylabels.partyname,
	    congress2012.primaryvotes,
	    congress2012.runoffvotes,
	    congress2012.generalvotes,
	    congress2012.gerunoffelectionvotes,
	    combpct.generalvotes,
	    congress2012.gewinner,
	    congress2012.notes,
	    TO_DATE('11/06/2012', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    congress2012.writein
	FROM
	    (
	        SELECT
	            congress2012_load.statenameabbreviation   postal,
	            congress2012_load.statename,
	            congress2012_load.d                       district,
	            congress2012_load.fecid,
	            nvl2(congress2012_load.incumbent, 1, 0) incumbent,
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
	            congress2012_load.footnotes               notes,
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
	    ) congress2012
	    LEFT JOIN partylabels ON congress2012.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2012
	    LEFT JOIN (
	        SELECT
	            congress2012_load.statenameabbreviation   postal,
	            congress2012_load.candidatename,
	            congress2012_load.d                       district,
	            COUNT(congress2012_load.candidatename) count,
	            SUM(to_number(regexp_replace(congress2012_load.generalvotes, '\D+'))) generalvotes
	        FROM
	            congress2012_load
	        GROUP BY
	            congress2012_load.statenameabbreviation,
	            congress2012_load.candidatename,
	            congress2012_load.d
	        HAVING
	            COUNT(congress2012_load.candidatename) > 1
	    ) combpct ON congress2012.candidatename = combpct.candidatename
	                 AND congress2012.postal = combpct.postal
	                 AND congress2012.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON congress2012.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2012
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2012 )
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    house2014.postal,
	    house2014.statename,
	    house2014.district,
	    house2014.fecid,
	    house2014.incumbent,
	    house2014.candidatenamefirst,
	    house2014.candidatenamelast,
	    house2014.candidatename,
	    partylabels.partyname,
	    house2014.primaryvotes,
	    house2014.runoffvotes,
	    house2014.generalvotes,
	    house2014.gerunoffelectionvotes,
	    combpct.generalvotes,
	    house2014.gewinner,
	    house2014.notes,
	    TO_DATE('11/04/2014', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    house2014.writein
	FROM
	    (
	        SELECT
	            house2014_load.statenameabbreviation   postal,
	            house2014_load.statename,
	            house2014_load.d                       district,
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
	            to_number(regexp_replace(house2014_load.primaryvotes, '\D+')) primaryvotes,
	            to_number(regexp_replace(house2014_load.runoffvotes, '\D+')) runoffvotes,
	            to_number(regexp_replace(house2014_load.generalvotes, '\D+')) generalvotes,
	            to_number(regexp_replace(house2014_load.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
	            nvl2(house2014_load.gewinnerindicator, 1, 0) gewinner,
	            house2014_load.footnotes               notes,
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
	            END writein
	        FROM
	            house2014_load
	        WHERE
	            house2014_load.candidatename IS NOT NULL
	            AND house2014_load.party != 'Combined Parties:'
	    ) house2014
	    LEFT JOIN partylabels ON house2014.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2014
	    LEFT JOIN (
	        SELECT
	            house2014_load.statenameabbreviation   postal,
	            house2014_load.candidatename,
	            house2014_load.d                       district,
	            COUNT(house2014_load.candidatename) count,
	            SUM(to_number(regexp_replace(house2014_load.generalvotes, '\D+'))) generalvotes
	        FROM
	            house2014_load
	        GROUP BY
	            house2014_load.statenameabbreviation,
	            house2014_load.candidatename,
	            house2014_load.d
	        HAVING
	            COUNT(house2014_load.candidatename) > 1
	    ) combpct ON house2014.candidatename = combpct.candidatename
	                 AND house2014.postal = combpct.postal
	                 AND house2014.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON house2014.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2014
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2014 )	
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    senate2014.postal,
	    senate2014.statename,
	    senate2014.district,
	    senate2014.fecid,
	    senate2014.incumbent,
	    senate2014.candidatenamefirst,
	    senate2014.candidatenamelast,
	    senate2014.candidatename,
	    partylabels.partyname,
	    senate2014.primaryvotes,
	    senate2014.runoffvotes,
	    senate2014.generalvotes,
	    senate2014.gerunoffelectionvotes,
	    combpct.generalvotes,
	    senate2014.gewinner,
	    senate2014.notes,
	    TO_DATE('11/04/2014', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    senate2014.writein
	FROM
	    (
	        SELECT
	            senate2014_load.statenameabbreviation   postal,
	            senate2014_load.statename,
	            senate2014_load.d                       district,
	            senate2014_load.fecid,
	            nvl2(senate2014_load.incumbent, 1, 0) incumbent,
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
	            END party,
	            to_number(regexp_replace(senate2014_load.primaryvotes, '\D+')) primaryvotes,
	            to_number(regexp_replace(senate2014_load.runoffvotes, '\D+')) runoffvotes,
	            to_number(regexp_replace(senate2014_load.generalvotes, '\D+')) generalvotes,
	            to_number(regexp_replace(senate2014_load.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
	            nvl2(senate2014_load.gewinnerindicator, 1, 0) gewinner,
	            senate2014_load.footnotes               notes,
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
	            END writein
	        FROM
	            senate2014_load
	        WHERE
	            senate2014_load.candidatename IS NOT NULL
	    ) senate2014
	    LEFT JOIN partylabels ON senate2014.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2014
	    LEFT JOIN (
	        SELECT
	            senate2014_load.statenameabbreviation   postal,
	            senate2014_load.candidatename,
	            senate2014_load.d                       district,
	            COUNT(senate2014_load.candidatename) count,
	            SUM(to_number(regexp_replace(senate2014_load.generalvotes, '\D+'))) generalvotes
	        FROM
	            senate2014_load
	        GROUP BY
	            senate2014_load.statenameabbreviation,
	            senate2014_load.candidatename,
	            senate2014_load.d
	        HAVING
	            COUNT(senate2014_load.candidatename) > 1
	    ) combpct ON senate2014.candidatename = combpct.candidatename
	                 AND senate2014.postal = combpct.postal
	                 AND senate2014.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON senate2014.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2014
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2014 )	
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    house2016.postal,
	    house2016.statename,
	    house2016.district,
	    house2016.fecid,
	    house2016.incumbent,
	    house2016.candidatenamefirst,
	    house2016.candidatenamelast,
	    house2016.candidatename,
	    partylabels.partyname,
	    house2016.primaryvotes,
	    house2016.runoffvotes,
	    house2016.generalvotes,
	    house2016.gerunoffelectionvotes,
	    combpct.generalvotes,
	    house2016.gewinner,
	    house2016.notes,
	    TO_DATE('11/08/2016', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    house2016.writein
	FROM
	    (
	        SELECT
	            house2016_load.statenameabbreviation   postal,
	            house2016_load.statename,
	            house2016_load.d                       district,
	            house2016_load.fecid,
	            nvl2(house2016_load.incumbent, 1, 0) incumbent,
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
	            END party,
	            to_number(regexp_replace(house2016_load.primaryvotes, '\D+')) primaryvotes,
	            to_number(regexp_replace(house2016_load.runoffvotes, '\D+')) runoffvotes,
	            to_number(regexp_replace(house2016_load.generalvotes, '\D+')) generalvotes,
	            to_number(regexp_replace(house2016_load.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
	            nvl2(house2016_load.gewinnerindicator, 1, 0) gewinner,
	            house2016_load.footnotes               notes,
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
	            END writein
	        FROM
	            house2016_load
	        WHERE
	            house2016_load.candidatename IS NOT NULL
	        UNION
	        SELECT
	            house2016_load.statenameabbreviation   postal,
	            house2016_load.statename,
	            house2016_load.d                       district,
	            house2016_load.fecid,
	            nvl2(house2016_load.incumbent, 1, 0) incumbent,
	            house2016_load.candidatenamefirst,
	            house2016_load.candidatename           candidatenamelast,
	            house2016_load.candidatenamelast       candidatename,
	            TRIM(house2016_load.totalvotes) party,
	            to_number(regexp_replace(house2016_load.party, '\D+')) primaryvotes,
	            to_number(regexp_replace(house2016_load.primarypct, '\D+')) runoffvotes,
	            to_number(regexp_replace(house2016_load.runoffpct, '\D+')) generalvotes,
	            to_number(regexp_replace(house2016_load.generalpct, '\D+')) gerunoffelectionvotes,
	            nvl2(house2016_load.combinedpct, 1, 0) gewinner,
	            house2016_load.footnotes               notes,
	            0 writein
	        FROM
	            house2016_load
	        WHERE
	            house2016_load.fecid IS NOT NULL
	            AND house2016_load.candidatename IS NULL
	    ) house2016
	    LEFT JOIN partylabels ON house2016.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2016
	    LEFT JOIN (
	        SELECT
	            house2016_load.statenameabbreviation   postal,
	            house2016_load.candidatename,
	            house2016_load.d                       district,
	            COUNT(house2016_load.candidatename) count,
	            SUM(to_number(regexp_replace(house2016_load.generalvotes, '\D+'))) generalvotes
	        FROM
	            house2016_load
	        GROUP BY
	            house2016_load.statenameabbreviation,
	            house2016_load.candidatename,
	            house2016_load.d
	        HAVING
	            COUNT(house2016_load.candidatename) > 1
	    ) combpct ON house2016.candidatename = combpct.candidatename
	                 AND house2016.postal = combpct.postal
	                 AND house2016.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON house2016.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2016
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2016 )	
	);

INSERT INTO fecresults
	(
	POSTAL,STATENAME,DISTRICT,FECID,INCUMBENT,CANDIDATENAMEFIRST,CANDIDATENAMELAST,CANDIDATENAME,PARTY,PRIMARYVOTES,RUNOFFVOTES,GENERALVOTES,GERUNOFFELECTIONVOTES,COMBINEDGEPARTYTOTALS,GEWINNER,
	NOTES,GENERALELECTIONDATE,PRIMARYDATE,RUNOFFDATE,WRITEIN
	)
	(
	SELECT
	    senate2016.postal,
	    senate2016.statename,
	    senate2016.district,
	    senate2016.fecid,
	    senate2016.incumbent,
	    senate2016.candidatenamefirst,
	    senate2016.candidatenamelast,
	    senate2016.candidatename,
	    partylabels.partyname,
	    senate2016.primaryvotes,
	    senate2016.runoffvotes,
	    senate2016.generalvotes,
	    senate2016.gerunoffelectionvotes,
	    combpct.generalvotes,
	    senate2016.gewinner,
	    senate2016.notes,
	    TO_DATE('11/08/2016', 'MM/DD/YYYY'),
	    congressionalprimarydates.primarydate,
	    congressionalprimarydates.runoffdate,
	    senate2016.writein
	FROM
	    (
	        SELECT
	            senate2016_load.statenameabbreviation   postal,
	            senate2016_load.statename,
	            senate2016_load.d                       district,
	            senate2016_load.fecid,
	            nvl2(senate2016_load.incumbent, 1, 0) incumbent,
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
	            END party,
	            to_number(regexp_replace(senate2016_load.primaryvotes, '\D+')) primaryvotes,
	            to_number(regexp_replace(senate2016_load.runoffvotes, '\D+')) runoffvotes,
	            to_number(regexp_replace(senate2016_load.generalvotes, '\D+')) generalvotes,
	            to_number(regexp_replace(senate2016_load.gerunoffelectionvotes, '\D+')) gerunoffelectionvotes,
	            nvl2(senate2016_load.gewinnerindicator, 1, 0) gewinner,
	            senate2016_load.footnotes               notes,
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
	            END writein
	        FROM
	            senate2016_load
	        WHERE
	            senate2016_load.candidatename IS NOT NULL
	        UNION
	        SELECT
	            senate2016_load.statenameabbreviation   postal,
	            senate2016_load.statename,
	            senate2016_load.d                       district,
	            senate2016_load.fecid,
	            nvl2(senate2016_load.incumbent, 1, 0) incumbent,
	            senate2016_load.candidatenamefirst,
	            senate2016_load.candidatename           candidatenamelast,
	            senate2016_load.candidatenamelast       candidatename,
	            TRIM(senate2016_load.totalvotes) party,
	            to_number(regexp_replace(senate2016_load.party, '\D+')) primaryvotes,
	            to_number(regexp_replace(senate2016_load.primarypct, '\D+')) runoffvotes,
	            to_number(regexp_replace(senate2016_load.runoffpct, '\D+')) generalvotes,
	            to_number(regexp_replace(senate2016_load.generalpct, '\D+')) gerunoffelectionvotes,
	            nvl2(senate2016_load.gewinnerindicator, 1, 0) gewinner,
	            senate2016_load.footnotes               notes,
	            0 writein
	        FROM
	            senate2016_load
	        WHERE
	            senate2016_load.fecid = 'S6CA00980 '
	    ) senate2016
	    LEFT JOIN partylabels ON senate2016.party = partylabels.abbreviation
	                             AND EXTRACT(YEAR FROM partylabels.generalelectiondate) = 2016
	    LEFT JOIN (
	        SELECT
	            senate2016_load.statenameabbreviation   postal,
	            senate2016_load.candidatename,
	            senate2016_load.d                       district,
	            COUNT(senate2016_load.candidatename) count,
	            SUM(to_number(regexp_replace(senate2016_load.generalvotes, '\D+'))) generalvotes
	        FROM
	            senate2016_load
	        GROUP BY
	            senate2016_load.statenameabbreviation,
	            senate2016_load.candidatename,
	            senate2016_load.d
	        HAVING
	            COUNT(senate2016_load.candidatename) > 1
	    ) combpct ON senate2016.candidatename = combpct.candidatename
	                 AND senate2016.postal = combpct.postal
	                 AND senate2016.district = combpct.district
	    LEFT JOIN congressionalprimarydates ON senate2016.statename = congressionalprimarydates.statename
	                                           AND ( EXTRACT(YEAR FROM congressionalprimarydates.primarydate) = 2016
	                                                 OR EXTRACT(YEAR FROM congressionalprimarydates.runoffdate) = 2016 )	
	);

UPDATE fecresults
SET party = 'Democratic'
WHERE party LIKE '%Dem%' AND party NOT IN ('Popular Democratic Party','F.D.R. Democrat Party');

UPDATE fecresults
SET party = 'Republican'
WHERE party LIKE '%Rep%' AND party NOT IN ('Representing the 99%','NMI Republican Party Association');

DELETE FROM  fecresults
WHERE candidatename IN ('TOTAL VOTES:', 'FULL TERM:')
