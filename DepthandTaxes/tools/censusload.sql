CREATE TABLE census2000_load
	(
	REGION number,
	DIVISION number,
	STATE number,
	NAME varchar2(255),
	SEX number,
	ORIGIN number,
	RACE number,
	AGEGRP number,
	ESTIMATESBASE2000 number,
	POPESTIMATE2000 number,
	POPESTIMATE2001 number,
	POPESTIMATE2002 number,
	POPESTIMATE2003 number,
	POPESTIMATE2004 number,
	POPESTIMATE2005 number,
	POPESTIMATE2006 number,
	POPESTIMATE2007 number,
	POPESTIMATE2008 number,
	POPESTIMATE2009 number,
	CENSUS2010POP number,
	POPESTIMATE2010	number
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
	LOCATION ('st-est00int-alldata.csv')
	)
REJECT LIMIT UNLIMITED;

CREATE TABLE census2010_load
	(
	SUMLEV number,
	REGION number,
	DIVISION number,
	STATE number,
	NAME varchar2(255),
	SEX number,
	ORIGIN number,
	RACE number,
	AGE number,
	CENSUS2010POP number,
	ESTIMATESBASE2010 number,
	POPESTIMATE2010 number,
	POPESTIMATE2011 number,
	POPESTIMATE2012 number,
	POPESTIMATE2013 number,
	POPESTIMATE2014 number,
	POPESTIMATE2015 number,
	POPESTIMATE2016 number,
	POPESTIMATE2017 number	
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
	LOCATION ('sc-est2017-alldata6.csv')
	)
REJECT LIMIT UNLIMITED;

CREATE TABLE census
	(
	REGION varchar2(50),
	DIVISION varchar2(50),
	STATE varchar2(50),
	STATENAME varchar2(255),
	SEX varchar2(10),
	ORIGIN varchar2(25),
	RACE varchar2(25),
	POPESTIMATE2000 number,
	POPESTIMATE2001 number,
	POPESTIMATE2002 number,
	POPESTIMATE2003 number,
	POPESTIMATE2004 number,
	POPESTIMATE2005 number,
	POPESTIMATE2006 number,
	POPESTIMATE2007 number,
	POPESTIMATE2008 number,
	POPESTIMATE2009 number,
	CENSUS2010POP number,
	POPESTIMATE2011 number,
	POPESTIMATE2012 number,
	POPESTIMATE2013 number,
	POPESTIMATE2014 number,
	POPESTIMATE2015 number,
	POPESTIMATE2016 number,
	POPESTIMATE2017 number	
	);

INSERT INTO census
	(
	REGION,	DIVISION, STATE,NAME,SEX,ORIGIN,RACE,POPESTIMATE2000,POPESTIMATE2001,POPESTIMATE2002,POPESTIMATE2003,POPESTIMATE2004,POPESTIMATE2005,POPESTIMATE2006,POPESTIMATE2007,POPESTIMATE2008,
	POPESTIMATE2009,CENSUS2010POP,POPESTIMATE2011,POPESTIMATE2012,POPESTIMATE2013,POPESTIMATE2014,POPESTIMATE2015,POPESTIMATE2016,POPESTIMATE2017	
	)
	(
SELECT
    CASE
        WHEN census2000.region = 0 THEN 'United States Total'
        WHEN census2000.region = 1 THEN 'Northeast'
        WHEN census2000.region = 2 THEN 'Midwest'
        WHEN census2000.region = 3 THEN 'South'
        ELSE 'West'
    END region,
    census2000.division,
    census2000.state,
    census2000.name,
    census2000.sex,
    census2000.origin,
    census2000.race,
    census2000.popestimate2000,
    census2000.popestimate2001,
    census2000.popestimate2002,
    census2000.popestimate2003,
    census2000.popestimate2004,
    census2000.popestimate2005,
    census2000.popestimate2006,
    census2000.popestimate2007,
    census2000.popestimate2008,
    census2000.popestimate2009,
    census2000.census2010pop,
    census2010.popestimate2011,
    census2010.popestimate2012,
    census2010.popestimate2013,
    census2010.popestimate2014,
    census2010.popestimate2015,
    census2010.popestimate2016,
    census2010.popestimate2017
FROM
    (
        SELECT
            census2000_load.region,
            census2000_load.division,
            census2000_load.state,
            census2000_load.name,
            census2000_load.sex,
            census2000_load.origin,
            census2000_load.race,
            SUM(census2000_load.popestimate2000) popestimate2000,
            SUM(census2000_load.popestimate2001) popestimate2001,
            SUM(census2000_load.popestimate2002) popestimate2002,
            SUM(census2000_load.popestimate2003) popestimate2003,
            SUM(census2000_load.popestimate2004) popestimate2004,
            SUM(census2000_load.popestimate2005) popestimate2005,
            SUM(census2000_load.popestimate2006) popestimate2006,
            SUM(census2000_load.popestimate2007) popestimate2007,
            SUM(census2000_load.popestimate2008) popestimate2008,
            SUM(census2000_load.popestimate2009) popestimate2009,
            SUM(census2000_load.census2010pop) census2010pop
        FROM
            census2000_load
        WHERE
            census2000_load.agegrp >= 5
        GROUP BY
            census2000_load.region,
            census2000_load.division,
            census2000_load.state,
            census2000_load.name,
            census2000_load.sex,
            census2000_load.origin,
            census2000_load.race
    ) census2000
    LEFT JOIN (
        SELECT
            census2010_load.region,
            census2010_load.division,
            census2010_load.state,
            census2010_load.name,
            census2010_load.sex,
            census2010_load.origin,
            census2010_load.race,
            SUM(census2010_load.popestimate2011) popestimate2011,
            SUM(census2010_load.popestimate2012) popestimate2012,
            SUM(census2010_load.popestimate2013) popestimate2013,
            SUM(census2010_load.popestimate2014) popestimate2014,
            SUM(census2010_load.popestimate2015) popestimate2015,
            SUM(census2010_load.popestimate2016) popestimate2016,
            SUM(census2010_load.popestimate2017) popestimate2017
        FROM
            census2010_load
        WHERE
            census2010_load.age >= 20
        GROUP BY
            census2010_load.region,
            census2010_load.division,
            census2010_load.state,
            census2010_load.name,
            census2010_load.sex,
            census2010_load.origin,
            census2010_load.race
    ) census2010 ON census2000.region = census2010.region
                    AND census2000.division = census2010.division
                    AND census2000.state = census2010.state
                    AND census2000.name = census2010.name
                    AND census2000.sex = census2010.sex
                    AND census2000.origin = census2010.origin
                    AND census2000.race = census2010.race	);