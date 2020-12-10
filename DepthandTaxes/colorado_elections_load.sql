DROP TABLE co_sos_elections_turnout PURGE;
DROP TABLE co_sos_elections_results PURGE;
DROP TABLE co_sos_elections_2004generalprecinctballotscast PURGE;
DROP TABLE co_sos_elections_2004generalprecinctresults PURGE;
DROP TABLE co_sos_elections_2004primaryresults PURGE;
DROP TABLE co_sos_elections_2004primaryballotscast PURGE;
DROP TABLE co_sos_elections_2005ballotscast PURGE;
DROP TABLE co_sos_elections_2005results PURGE;
DROP TABLE co_sos_elections_2006generalprecinctballotscast PURGE;
DROP TABLE co_sos_elections_2006generalprecinctresults PURGE;
DROP TABLE co_sos_elections_2006primaryballotscast PURGE;
DROP TABLE co_sos_elections_2006primaryresults PURGE;
DROP TABLE co_sos_elections_2008generalprecinctresults PURGE;
DROP TABLE co_sos_elections_2008generalprecinctturnout PURGE;
DROP TABLE co_sos_elections_2008primaryresults PURGE;
DROP TABLE co_sos_elections_2008primaryturnout PURGE;
DROP TABLE co_sos_elections_2010generalprecinctresults PURGE;
DROP TABLE co_sos_elections_2010generalprecinctturnout PURGE;
DROP TABLE co_sos_elections_2010primaryresults PURGE;
DROP TABLE co_sos_elections_2010PrimaryTurnout PURGE;
DROP TABLE co_sos_elections_2011results PURGE;
DROP TABLE co_sos_elections_2011turnout PURGE;
DROP TABLE co_sos_elections_2012generalprecinctlevelresults PURGE;
DROP TABLE co_sos_elections_2012generalprecinctlevelturnout PURGE;
DROP TABLE co_sos_elections_2012primaryresults PURGE;
DROP TABLE co_sos_elections_2012primaryturnout PURGE;
DROP TABLE co_sos_elections_2013electionresults PURGE;
DROP TABLE co_sos_elections_2013turnout PURGE;
DROP TABLE co_sos_elections_2014generalprecinctresults PURGE;
DROP TABLE co_sos_elections_2014generalprecinctturnout PURGE;
DROP TABLE co_sos_elections_2014primaryelectionresults PURGE;
DROP TABLE co_sos_elections_2014primaryturnout PURGE;
DROP TABLE co_sos_elections_2015resultscountylevel PURGE;
DROP TABLE co_sos_elections_2015turnoutcountylevel PURGE;
DROP TABLE co_sos_elections_2016generalresultsprecinctlevel PURGE;
DROP TABLE co_sos_elections_2016generalturnoutprecinctlevel PURGE;
DROP TABLE co_sos_elections_2016primaryabstractresults PURGE;
DROP TABLE co_sos_elections_2016primaryturnoutcountylevel PURGE;
DROP TABLE co_sos_elections_2018geprecinctlevelresults PURGE;
DROP TABLE co_sos_elections_2018geprecinctlevelturnout PURGE;
DROP TABLE co_sos_elections_2018primaryresults PURGE;
DROP TABLE co_sos_elections_2019FinalResults PURGE;
DROP TABLE co_sos_elections_2020presprimaryresultsbycountyfinal PURGE;

CREATE TABLE co_sos_elections_turnout
  (
     activevoters    NUMBER
     ,ballotscast    NUMBER
     ,county         VARCHAR2(50)
     ,electiontype   VARCHAR2(26)
     ,inactivevoters NUMBER
     ,party          VARCHAR2(26)
     ,precinct       VARCHAR2(50)
     ,state          VARCHAR2(26)
     ,totalvoters    NUMBER
     ,year           DATE
  );

CREATE TABLE co_sos_elections_results
  (
     candidateyesno        VARCHAR2(128)
     ,county               VARCHAR2(50)
     ,electiontype         VARCHAR2(26)
     ,officeissuejudgeship VARCHAR2(128)
     ,party                VARCHAR2(50)
     ,precinct             VARCHAR2(50)
     ,state                VARCHAR2(26)
     ,votes                NUMBER
     ,year                 DATE
  );


CREATE TABLE co_sos_elections_2004generalprecinctballotscast
  (
     state         VARCHAR2(128)
     ,year         VARCHAR2(128)
     ,electiontype VARCHAR2(128)
     ,county       VARCHAR2(128)
     ,precinct     VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,votingmethod VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2004GeneralPrecinctBallotsCast.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2004generalprecinctballotscast.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2004generalprecinctballotscast.county)) AS county
              ,TRIM(co_sos_elections_2004generalprecinctballotscast.electiontype)    AS electiontype
              ,TRIM(co_sos_elections_2004generalprecinctballotscast.precinct)        AS precinct
              ,TRIM(co_sos_elections_2004generalprecinctballotscast.state)           AS state
              ,TO_DATE(co_sos_elections_2004generalprecinctballotscast.year, 'YYYY') AS year
       FROM   co_sos_elections_2004generalprecinctballotscast) t2004
ON ( co_sos_elections_turnout.county = t2004.county
     AND co_sos_elections_turnout.ballotscast = t2004.ballotscast
     AND co_sos_elections_turnout.electiontype = t2004.electiontype
     AND co_sos_elections_turnout.precinct = t2004.precinct
     AND co_sos_elections_turnout.year = t2004.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2004.ballotscast
           ,t2004.county
           ,t2004.electiontype
           ,t2004.precinct
           ,t2004.state
           ,t2004.year);

CREATE TABLE co_sos_elections_2004generalprecinctresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2004GeneralPrecinctResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2004generalprecinctresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2004generalprecinctresults.county))      AS county
              ,TRIM(co_sos_elections_2004generalprecinctresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2004generalprecinctresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2004generalprecinctresults.party)                AS party
              ,TRIM(co_sos_elections_2004generalprecinctresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2004generalprecinctresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2004generalprecinctresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2004generalprecinctresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2004generalprecinctresults) r2004
ON ( co_sos_elections_results.county = r2004.county
     AND co_sos_elections_results.votes = r2004.votes
     AND co_sos_elections_results.electiontype = r2004.electiontype
     AND co_sos_elections_results.party = r2004.party
     AND co_sos_elections_results.precinct = r2004.precinct
     AND co_sos_elections_results.year = r2004.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2004.candidateyesno
           ,r2004.county
           ,r2004.electiontype
           ,r2004.officeissuejudgeship
           ,r2004.party
           ,r2004.precinct
           ,r2004.state
           ,r2004.votes
           ,r2004.year);  

CREATE TABLE co_sos_elections_2004primaryballotscast
  (
     state         VARCHAR2(128)
     ,year         VARCHAR2(128)
     ,electiontype VARCHAR2(128)
     ,county       VARCHAR2(128)
     ,votingmethod VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,party        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2004PrimaryBallotsCast.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2004primaryballotscast.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2004primaryballotscast.county)) AS county
              ,TRIM(co_sos_elections_2004primaryballotscast.electiontype)    AS electiontype
              ,TRIM(co_sos_elections_2004primaryballotscast.party)           AS party
              ,TRIM(co_sos_elections_2004primaryballotscast.state)           AS state
              ,TO_DATE(co_sos_elections_2004primaryballotscast.year, 'YYYY') AS year
       FROM   co_sos_elections_2004primaryballotscast) t2004
ON ( co_sos_elections_turnout.county = t2004.county
     AND co_sos_elections_turnout.ballotscast = t2004.ballotscast
     AND co_sos_elections_turnout.electiontype = t2004.electiontype
     AND co_sos_elections_turnout.party = t2004.party
     AND co_sos_elections_turnout.year = t2004.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.party
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2004.ballotscast
           ,t2004.county
           ,t2004.electiontype
           ,t2004.party
           ,t2004.state
           ,t2004.year);

CREATE TABLE co_sos_elections_2004primaryresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,votingmethod         VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2004PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2004primaryresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2004primaryresults.county))      AS county
              ,TRIM(co_sos_elections_2004primaryresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2004primaryresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2004primaryresults.party)                AS party
              ,TRIM(co_sos_elections_2004primaryresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2004primaryresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2004primaryresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2004primaryresults) r2004
ON ( co_sos_elections_results.county = r2004.county
     AND co_sos_elections_results.votes = r2004.votes
     AND co_sos_elections_results.electiontype = r2004.electiontype
     AND co_sos_elections_results.party = r2004.party
     AND co_sos_elections_results.year = r2004.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2004.candidateyesno
           ,r2004.county
           ,r2004.electiontype
           ,r2004.officeissuejudgeship
           ,r2004.party
           ,r2004.state
           ,r2004.votes
           ,r2004.year);

CREATE TABLE co_sos_elections_2005ballotscast
  (
     state         VARCHAR2(128)
     ,year         VARCHAR2(128)
     ,electiontype VARCHAR2(128)
     ,county       VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2005BallotsCast.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2005ballotscast.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2005ballotscast.county)) AS county
              ,TRIM(co_sos_elections_2005ballotscast.electiontype)    AS electiontype
              ,TRIM(co_sos_elections_2005ballotscast.state)           AS state
              ,TO_DATE(co_sos_elections_2005ballotscast.year, 'YYYY') AS year
       FROM   co_sos_elections_2005ballotscast) t2005
ON ( co_sos_elections_turnout.county = t2005.county
     AND co_sos_elections_turnout.ballotscast = t2005.ballotscast
     AND co_sos_elections_turnout.electiontype = t2005.electiontype
     AND co_sos_elections_turnout.year = t2005.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2005.ballotscast
           ,t2005.county
           ,t2005.electiontype
           ,t2005.state
           ,t2005.year);

CREATE TABLE co_sos_elections_2005results
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2005Results.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2005results.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2005results.county))      AS county
              ,TRIM(co_sos_elections_2005results.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2005results.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2005results.state)                AS state
              ,TO_NUMBER(co_sos_elections_2005results.votes)           AS votes
              ,TO_DATE(co_sos_elections_2005results.year, 'YYYY')      AS year
       FROM   co_sos_elections_2005results) r2005
ON ( co_sos_elections_results.county = r2005.county
     AND co_sos_elections_results.votes = r2005.votes
     AND co_sos_elections_results.electiontype = r2005.electiontype
     AND co_sos_elections_results.year = r2005.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2005.candidateyesno
           ,r2005.county
           ,r2005.electiontype
           ,r2005.officeissuejudgeship
           ,r2005.state
           ,r2005.votes
           ,r2005.year);

CREATE TABLE co_sos_elections_2006generalprecinctballotscast
  (
     state         VARCHAR2(128)
     ,year         VARCHAR2(128)
     ,electiontype VARCHAR2(128)
     ,county       VARCHAR2(128)
     ,precinct     VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,votingmethod VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2006GeneralPrecinctBallotsCast.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2006generalprecinctballotscast.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2006generalprecinctballotscast.county)) AS county
              ,TRIM(co_sos_elections_2006generalprecinctballotscast.electiontype)    AS electiontype
              ,TRIM(co_sos_elections_2006generalprecinctballotscast.precinct)        AS precinct
              ,TRIM(co_sos_elections_2006generalprecinctballotscast.state)           AS state
              ,TO_DATE(co_sos_elections_2006generalprecinctballotscast.year, 'YYYY') AS year
       FROM   co_sos_elections_2006generalprecinctballotscast) t2006
ON ( co_sos_elections_turnout.county = t2006.county
     AND co_sos_elections_turnout.ballotscast = t2006.ballotscast
     AND co_sos_elections_turnout.electiontype = t2006.electiontype
     AND co_sos_elections_turnout.precinct = t2006.precinct
     AND co_sos_elections_turnout.year = t2006.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2006.ballotscast
           ,t2006.county
           ,t2006.electiontype
           ,t2006.precinct
           ,t2006.state
           ,t2006.year);

CREATE TABLE co_sos_elections_2006generalprecinctresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2006GeneralPrecinctResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2006generalprecinctresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2006generalprecinctresults.county))      AS county
              ,TRIM(co_sos_elections_2006generalprecinctresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2006generalprecinctresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2006generalprecinctresults.party)                AS party
              ,TRIM(co_sos_elections_2006generalprecinctresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2006generalprecinctresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2006generalprecinctresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2006generalprecinctresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2006generalprecinctresults) r2006
ON ( co_sos_elections_results.county = r2006.county
     AND co_sos_elections_results.votes = r2006.votes
     AND co_sos_elections_results.electiontype = r2006.electiontype
     AND co_sos_elections_results.party = r2006.party
     AND co_sos_elections_results.precinct = r2006.precinct
     AND co_sos_elections_results.year = r2006.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2006.candidateyesno
           ,r2006.county
           ,r2006.electiontype
           ,r2006.officeissuejudgeship
           ,r2006.party
           ,r2006.precinct
           ,r2006.state
           ,r2006.votes
           ,r2006.year);  

CREATE TABLE co_sos_elections_2006primaryballotscast
  (
     state         VARCHAR2(128)
     ,year         VARCHAR2(128)
     ,electiontype VARCHAR2(128)
     ,county       VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,party        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2006PrimaryBallotsCast.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2006primaryballotscast.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2006primaryballotscast.county)) AS county
              ,TRIM(co_sos_elections_2006primaryballotscast.electiontype)    AS electiontype
              ,TRIM(co_sos_elections_2006primaryballotscast.party)           AS party
              ,TRIM(co_sos_elections_2006primaryballotscast.state)           AS state
              ,TO_DATE(co_sos_elections_2006primaryballotscast.year, 'YYYY') AS year
       FROM   co_sos_elections_2006primaryballotscast) t2006
ON ( co_sos_elections_turnout.county = t2006.county
     AND co_sos_elections_turnout.ballotscast = t2006.ballotscast
     AND co_sos_elections_turnout.electiontype = t2006.electiontype
     AND co_sos_elections_turnout.party = t2006.party
     AND co_sos_elections_turnout.year = t2006.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.party
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2006.ballotscast
           ,t2006.county
           ,t2006.electiontype
           ,t2006.party
           ,t2006.state
           ,t2006.year);

CREATE TABLE co_sos_elections_2006primaryresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2006PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2006primaryresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2006primaryresults.county))      AS county
              ,TRIM(co_sos_elections_2006primaryresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2006primaryresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2006primaryresults.party)                AS party
              ,TRIM(co_sos_elections_2006primaryresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2006primaryresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2006primaryresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2006primaryresults) r2006
ON ( co_sos_elections_results.county = r2006.county
     AND co_sos_elections_results.votes = r2006.votes
     AND co_sos_elections_results.electiontype = r2006.electiontype
     AND co_sos_elections_results.party = r2006.party
     AND co_sos_elections_results.year = r2006.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2006.candidateyesno
           ,r2006.county
           ,r2006.electiontype
           ,r2006.officeissuejudgeship
           ,r2006.party
           ,r2006.state
           ,r2006.votes
           ,r2006.year);

CREATE TABLE co_sos_elections_2008generalprecinctresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2008GeneralPrecinctResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2008generalprecinctresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2008generalprecinctresults.county))      AS county
              ,TRIM(co_sos_elections_2008generalprecinctresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2008generalprecinctresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2008generalprecinctresults.party)                AS party
              ,TRIM(co_sos_elections_2008generalprecinctresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2008generalprecinctresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2008generalprecinctresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2008generalprecinctresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2008generalprecinctresults) r2008
ON ( co_sos_elections_results.county = r2008.county
     AND co_sos_elections_results.votes = r2008.votes
     AND co_sos_elections_results.electiontype = r2008.electiontype
     AND co_sos_elections_results.party = r2008.party
     AND co_sos_elections_results.precinct = r2008.precinct
     AND co_sos_elections_results.year = r2008.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2008.candidateyesno
           ,r2008.county
           ,r2008.electiontype
           ,r2008.officeissuejudgeship
           ,r2008.party
           ,r2008.precinct
           ,r2008.state
           ,r2008.votes
           ,r2008.year);

CREATE TABLE co_sos_elections_2008generalprecinctturnout
  (
     county        VARCHAR2(128)
     ,precinct     VARCHAR2(128)
     ,activevoters VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,turnout      VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2008GeneralPrecinctTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2008generalprecinctturnout.activevoters, '[^0-9.]', '')) AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2008generalprecinctturnout.ballotscast, '[^0-9.]', '')) AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2008generalprecinctturnout.county))                                 AS
               county
              ,'General'                                                                                         AS
               electiontype
              ,TRIM(co_sos_elections_2008generalprecinctturnout.precinct)                                        AS
               precinct
              ,'Colorado'                                                                                        AS
               state
              ,TO_DATE(2008, 'YYYY')                                                                             AS year
       FROM   co_sos_elections_2008generalprecinctturnout) t2008
ON ( co_sos_elections_turnout.county = t2008.county
     AND co_sos_elections_turnout.ballotscast = t2008.ballotscast
     AND co_sos_elections_turnout.electiontype = t2008.electiontype
     AND co_sos_elections_turnout.precinct = t2008.precinct
     AND co_sos_elections_turnout.year = t2008.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2008.activevoters
           ,t2008.ballotscast
           ,t2008.county
           ,t2008.electiontype
           ,t2008.precinct
           ,t2008.state
           ,t2008.year);

CREATE TABLE co_sos_elections_2008primaryresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2008PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2008primaryresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2008primaryresults.county))      AS county
              ,TRIM(co_sos_elections_2008primaryresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2008primaryresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2008primaryresults.party)                AS party
              ,TRIM(co_sos_elections_2008primaryresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2008primaryresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2008primaryresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2008primaryresults) r2008
ON ( co_sos_elections_results.county = r2008.county
     AND co_sos_elections_results.votes = r2008.votes
     AND co_sos_elections_results.electiontype = r2008.electiontype
     AND co_sos_elections_results.party = r2008.party
     AND co_sos_elections_results.year = r2008.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2008.candidateyesno
           ,r2008.county
           ,r2008.electiontype
           ,r2008.officeissuejudgeship
           ,r2008.party
           ,r2008.state
           ,r2008.votes
           ,r2008.year);

CREATE TABLE co_sos_elections_2008primaryturnout
  (
     county        VARCHAR2(128)
     ,activevoters VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,turnout      VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2008PrimaryTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(co_sos_elections_2008primaryturnout.activevoters) AS activevoters
              ,TO_NUMBER(co_sos_elections_2008primaryturnout.ballotscast) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2008primaryturnout.county))  AS county
              ,'Primary'                                                  AS electiontype
              ,'Colorado'                                                 AS state
              ,TO_DATE(2008, 'YYYY')                                      AS year
       FROM   co_sos_elections_2008primaryturnout) t2008
ON ( co_sos_elections_turnout.county = t2008.county
     AND co_sos_elections_turnout.ballotscast = t2008.ballotscast
     AND co_sos_elections_turnout.electiontype = t2008.electiontype
     AND co_sos_elections_turnout.year = t2008.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2008.ballotscast
           ,t2008.county
           ,t2008.electiontype
           ,t2008.state
           ,t2008.year);

 CREATE TABLE co_sos_elections_2010generalprecinctresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,pollvotes            VARCHAR2(128)
     ,mailvotes            VARCHAR2(128)
     ,earlyvotes           VARCHAR2(128)
     ,provvotes            VARCHAR2(128)
     ,votes                VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2010GeneralPrecinctResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2010generalprecinctresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2010generalprecinctresults.county))      AS county
              ,TRIM(co_sos_elections_2010generalprecinctresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2010generalprecinctresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2010generalprecinctresults.party)                AS party
              ,TRIM(co_sos_elections_2010generalprecinctresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2010generalprecinctresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2010generalprecinctresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2010generalprecinctresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2010generalprecinctresults) r2010
ON ( co_sos_elections_results.county = r2010.county
     AND co_sos_elections_results.votes = r2010.votes
     AND co_sos_elections_results.electiontype = r2010.electiontype
     AND co_sos_elections_results.party = r2010.party
     AND co_sos_elections_results.precinct = r2010.precinct
     AND co_sos_elections_results.year = r2010.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2010.candidateyesno
           ,r2010.county
           ,r2010.electiontype
           ,r2010.officeissuejudgeship
           ,r2010.party
           ,r2010.precinct
           ,r2010.state
           ,r2010.votes
           ,r2010.year);

CREATE TABLE co_sos_elections_2010generalprecinctturnout
  (
     county        VARCHAR2(128)
     ,precinct     VARCHAR2(128)
     ,activevoters VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,turnout      VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2010GeneralPrecinctTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2010generalprecinctturnout.activevoters, '[^0-9.]', '')) AS
                    activevoters
              ,TO_NUMBER(co_sos_elections_2010generalprecinctturnout.ballotscast)                                AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2010generalprecinctturnout.county))                                 AS
               county
              ,'General'                                                                                         AS
               electiontype
              ,TRIM(co_sos_elections_2010generalprecinctturnout.precinct)                                        AS
               precinct
              ,'Colorado'                                                                                        AS
               state
              ,TO_DATE(2010, 'YYYY')                                                                             AS year
       FROM   co_sos_elections_2010generalprecinctturnout) t2010
ON ( co_sos_elections_turnout.county = t2010.county
     AND co_sos_elections_turnout.ballotscast = t2010.ballotscast
     AND co_sos_elections_turnout.electiontype = t2010.electiontype
     AND co_sos_elections_turnout.precinct = t2010.precinct
     AND co_sos_elections_turnout.year = t2010.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2010.activevoters
           ,t2010.ballotscast
           ,t2010.county
           ,t2010.electiontype
           ,t2010.precinct
           ,t2010.state
           ,t2010.year);

CREATE TABLE co_sos_elections_2010primaryresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2010PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2010primaryresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2010primaryresults.county))      AS county
              ,TRIM(co_sos_elections_2010primaryresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2010primaryresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2010primaryresults.party)                AS party
              ,TRIM(co_sos_elections_2010primaryresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2010primaryresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2010primaryresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2010primaryresults) r2010
ON ( co_sos_elections_results.county = r2010.county
     AND co_sos_elections_results.votes = r2010.votes
     AND co_sos_elections_results.electiontype = r2010.electiontype
     AND co_sos_elections_results.party = r2010.party
     AND co_sos_elections_results.year = r2010.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2010.candidateyesno
           ,r2010.county
           ,r2010.electiontype
           ,r2010.officeissuejudgeship
           ,r2010.party
           ,r2010.state
           ,r2010.votes
           ,r2010.year);

CREATE TABLE co_sos_elections_2010PrimaryTurnout
  (
     county        VARCHAR2(128)
     ,activevoters VARCHAR2(128)
     ,ballotscast  VARCHAR2(128)
     ,turnout      VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2010PrimaryTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2010primaryturnout.activevoters, '[^0-9.]', '')) AS activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2010primaryturnout.ballotscast, '[^0-9.]', '')) AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2010primaryturnout.county))                                 AS county
              ,'Primary'                                                                                 AS electiontype
              ,'Colorado'                                                                                AS state
              ,TO_DATE(2010, 'YYYY')                                                                     AS year
       FROM   co_sos_elections_2010primaryturnout) t2010
ON ( co_sos_elections_turnout.county = t2010.county
     AND co_sos_elections_turnout.ballotscast = t2010.ballotscast
     AND co_sos_elections_turnout.electiontype = t2010.electiontype
     AND co_sos_elections_turnout.year = t2010.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.year)
  VALUES ( t2010.ballotscast
           ,t2010.county
           ,t2010.electiontype
           ,t2010.state
           ,t2010.year);

CREATE TABLE co_sos_elections_2011results
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2011Results.csv')
  )
REJECT LIMIT UNLIMITED;

 MERGE INTO co_sos_elections_results
using (SELECT 'Yes'                                                                            AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2011results.county))                              AS county
              ,TRIM(co_sos_elections_2011results.electiontype)                                 AS electiontype
              ,TRIM(co_sos_elections_2011results.officeissuejudgeship)                         AS officeissuejudgeship
              ,TRIM(co_sos_elections_2011results.state)                                        AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011results.yesvotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2011results.year, 'YYYY')                              AS year
       FROM   co_sos_elections_2011results
       UNION
       SELECT 'No'                                                                            AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2011results.county))                             AS county
              ,TRIM(co_sos_elections_2011results.electiontype)                                AS electiontype
              ,TRIM(co_sos_elections_2011results.officeissuejudgeship)                        AS officeissuejudgeship
              ,TRIM(co_sos_elections_2011results.state)                                       AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011results.novotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2011results.year, 'YYYY')                             AS year
       FROM   co_sos_elections_2011results) r2011
ON ( co_sos_elections_results.county = r2011.county
     AND co_sos_elections_results.votes = r2011.votes
     AND co_sos_elections_results.electiontype = r2011.electiontype
     AND co_sos_elections_results.year = r2011.year )
WHEN NOT matched THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2011.candidateyesno
           ,r2011.county
           ,r2011.electiontype
           ,r2011.officeissuejudgeship
           ,r2011.state
           ,r2011.votes
           ,r2011.year);  
CREATE TABLE co_sos_elections_2011turnout
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2011Turnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011turnout.activevoters, '[^0-9.]', ''))    AS activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011turnout.ballotscast, '[^0-9.]', ''))    AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2011turnout.county))                                    AS county
              ,TRIM(co_sos_elections_2011turnout.electiontype)                                       AS electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011turnout.inactivevoters, '[^0-9.]', '')) AS inactivevoters
              ,TRIM(co_sos_elections_2011turnout.state)                                              AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2011turnout.totalvoters, '[^0-9.]', ''))    AS totalvoters
              ,TO_DATE(co_sos_elections_2011turnout.year, 'YYYY')                                    AS year
       FROM   co_sos_elections_2011turnout) t2011
ON ( co_sos_elections_turnout.county = t2011.county
     AND co_sos_elections_turnout.ballotscast = t2011.ballotscast
     AND co_sos_elections_turnout.electiontype = t2011.electiontype
     AND co_sos_elections_turnout.year = t2011.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2011.activevoters
           ,t2011.ballotscast
           ,t2011.county
           ,t2011.electiontype
           ,t2011.inactivevoters
           ,t2011.state
           ,t2011.totalvoters
           ,t2011.year );

CREATE TABLE co_sos_elections_2012generalprecinctlevelresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2012GeneralPrecinctLevelResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2012generalprecinctlevelresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2012generalprecinctlevelresults.county))      AS county
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.party)                AS party
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2012generalprecinctlevelresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2012generalprecinctlevelresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2012generalprecinctlevelresults
       WHERE  co_sos_elections_2012generalprecinctlevelresults.yesvotes = 0
          AND co_sos_elections_2012generalprecinctlevelresults.novotes = 0
       UNION
       SELECT 'Yes'                                                                     AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2012generalprecinctlevelresults.county))   AS county
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2012generalprecinctlevelresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.party)             AS party
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2012generalprecinctlevelresults.yesvotes)     AS votes
              ,TO_DATE(co_sos_elections_2012generalprecinctlevelresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2012generalprecinctlevelresults
       WHERE  co_sos_elections_2012generalprecinctlevelresults.yesvotes > 0
       UNION
       SELECT 'No'                                                                      AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2012generalprecinctlevelresults.county))   AS county
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2012generalprecinctlevelresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.party)             AS party
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2012generalprecinctlevelresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2012generalprecinctlevelresults.novotes)      AS votes
              ,TO_DATE(co_sos_elections_2012generalprecinctlevelresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2012generalprecinctlevelresults
       WHERE  co_sos_elections_2012generalprecinctlevelresults.novotes > 0) r2012
ON ( co_sos_elections_results.county = r2012.county
     AND co_sos_elections_results.votes = r2012.votes
     AND co_sos_elections_results.electiontype = r2012.electiontype
     AND co_sos_elections_results.precinct = r2012.precinct
     AND co_sos_elections_results.year = r2012.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2012.candidateyesno
           ,r2012.county
           ,r2012.electiontype
           ,r2012.officeissuejudgeship
           ,r2012.party
           ,r2012.precinct
           ,r2012.state
           ,r2012.votes
           ,r2012.year );

CREATE TABLE co_sos_elections_2012generalprecinctlevelturnout
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,precinct       VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
     ,notes          VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2012GeneralPrecinctLevelTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012generalprecinctlevelturnout.activevoters, '[^0-9.]', ''))
              AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012generalprecinctlevelturnout.ballotscast, '[^0-9.]', ''))
               AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2012generalprecinctlevelturnout.county))
               AS
               county
              ,TRIM(co_sos_elections_2012generalprecinctlevelturnout.electiontype)
               AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012generalprecinctlevelturnout.inactivevoters, '[^0-9.]', ''))
               AS
               inactivevoters
              ,TRIM(co_sos_elections_2012generalprecinctlevelturnout.precinct)
               AS
               precinct
              ,TRIM(co_sos_elections_2012generalprecinctlevelturnout.state)
               AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012generalprecinctlevelturnout.totalvoters, '[^0-9.]', ''))
               AS
               totalvoters
              ,TO_DATE(co_sos_elections_2012generalprecinctlevelturnout.year, 'YYYY')
               AS
               year
       FROM   co_sos_elections_2012generalprecinctlevelturnout) t2012
ON ( co_sos_elections_turnout.county = t2012.county
     AND co_sos_elections_turnout.ballotscast = t2012.ballotscast
     AND co_sos_elections_turnout.electiontype = t2012.electiontype
     AND co_sos_elections_turnout.year = t2012.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2012.activevoters
           ,t2012.ballotscast
           ,t2012.county
           ,t2012.electiontype
           ,t2012.inactivevoters
           ,t2012.precinct
           ,t2012.state
           ,t2012.totalvoters
           ,t2012.year );

CREATE TABLE co_sos_elections_2012primaryresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2012PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2012primaryresults.candidateyesno)                             AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2012primaryresults.county))                           AS county
              ,TRIM(co_sos_elections_2012primaryresults.electiontype)                              AS electiontype
              ,TRIM(co_sos_elections_2012primaryresults.officeissuejudgeship)                      AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2012primaryresults.party)                                     AS party
              ,TRIM(co_sos_elections_2012primaryresults.state)                                     AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012primaryresults.votes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2012primaryresults.year, 'YYYY')                           AS year
       FROM   co_sos_elections_2012primaryresults) r2012
ON ( co_sos_elections_results.county = r2012.county
     AND co_sos_elections_results.votes = r2012.votes
     AND co_sos_elections_results.electiontype = r2012.electiontype
     AND co_sos_elections_results.year = r2012.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2012.candidateyesno
           ,r2012.county
           ,r2012.electiontype
           ,r2012.officeissuejudgeship
           ,r2012.party
           ,r2012.state
           ,r2012.votes
           ,r2012.year );

CREATE TABLE co_sos_elections_2012PrimaryTurnout
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2012PrimaryTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012primaryturnout.activevoters, '[^0-9.]', ''))    AS
              activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012primaryturnout.ballotscast, '[^0-9.]', ''))    AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2012primaryturnout.county))                                    AS county
              ,TRIM(co_sos_elections_2012primaryturnout.electiontype)                                       AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012primaryturnout.inactivevoters, '[^0-9.]', '')) AS
               inactivevoters
              ,TRIM(co_sos_elections_2012primaryturnout.state)                                              AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2012primaryturnout.totalvoters, '[^0-9.]', ''))    AS
               totalvoters
              ,TO_DATE(co_sos_elections_2012primaryturnout.year, 'YYYY')                                    AS year
       FROM   co_sos_elections_2012primaryturnout) t2012
ON ( co_sos_elections_turnout.county = t2012.county
     AND co_sos_elections_turnout.ballotscast = t2012.ballotscast
     AND co_sos_elections_turnout.electiontype = t2012.electiontype
     AND co_sos_elections_turnout.year = t2012.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2012.activevoters
           ,t2012.ballotscast
           ,t2012.county
           ,t2012.electiontype
           ,t2012.inactivevoters
           ,t2012.state
           ,t2012.totalvoters
           ,t2012.year );

CREATE TABLE co_sos_elections_2013electionresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2013ElectionResults.csv')
  )
REJECT LIMIT UNLIMITED;

 MERGE INTO co_sos_elections_results
using (SELECT 'Yes'                                                                                    AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2013electionresults.county))                              AS county
              ,TRIM(co_sos_elections_2013electionresults.electiontype)                                 AS electiontype
              ,TRIM(co_sos_elections_2013electionresults.officeissuejudgeship)                         AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2013electionresults.state)                                        AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013electionresults.yesvotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2013electionresults.year, 'YYYY')                              AS year
       FROM   co_sos_elections_2013electionresults
       UNION
       SELECT 'No'                                                                                    AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2013electionresults.county))                             AS county
              ,TRIM(co_sos_elections_2013electionresults.electiontype)                                AS electiontype
              ,TRIM(co_sos_elections_2013electionresults.officeissuejudgeship)                        AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2013electionresults.state)                                       AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013electionresults.novotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2013electionresults.year, 'YYYY')                             AS year
       FROM   co_sos_elections_2013electionresults) r2013
ON ( co_sos_elections_results.county = r2013.county
     AND co_sos_elections_results.votes = r2013.votes
     AND co_sos_elections_results.electiontype = r2013.electiontype
     AND co_sos_elections_results.year = r2013.year )
WHEN NOT matched THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2013.candidateyesno
           ,r2013.county
           ,r2013.electiontype
           ,r2013.officeissuejudgeship
           ,r2013.state
           ,r2013.votes
           ,r2013.year);

CREATE TABLE co_sos_elections_2013turnout
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2013Turnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013turnout.activevoters, '[^0-9.]', ''))    AS activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013turnout.ballotscast, '[^0-9.]', ''))    AS ballotscast
              ,INITCAP(TRIM(co_sos_elections_2013turnout.county))                                    AS county
              ,TRIM(co_sos_elections_2013turnout.electiontype)                                       AS electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013turnout.inactivevoters, '[^0-9.]', '')) AS inactivevoters
              ,TRIM(co_sos_elections_2013turnout.state)                                              AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2013turnout.totalvoters, '[^0-9.]', ''))    AS totalvoters
              ,TO_DATE(co_sos_elections_2013turnout.year, 'YYYY')                                    AS year
       FROM   co_sos_elections_2013turnout) t2013
ON ( co_sos_elections_turnout.county = t2013.county
     AND co_sos_elections_turnout.ballotscast = t2013.ballotscast
     AND co_sos_elections_turnout.electiontype = t2013.electiontype
     AND co_sos_elections_turnout.year = t2013.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2013.activevoters
           ,t2013.ballotscast
           ,t2013.county
           ,t2013.electiontype
           ,t2013.inactivevoters
           ,t2013.state
           ,t2013.totalvoters
           ,t2013.year );

CREATE TABLE co_sos_elections_2014generalprecinctresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2014GeneralPrecinctResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2014generalprecinctresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2014generalprecinctresults.county))      AS county
              ,TRIM(co_sos_elections_2014generalprecinctresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2014generalprecinctresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2014generalprecinctresults.party)                AS party
              ,TRIM(co_sos_elections_2014generalprecinctresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2014generalprecinctresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2014generalprecinctresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2014generalprecinctresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2014generalprecinctresults
       WHERE  co_sos_elections_2014generalprecinctresults.yesvotes = 0
          AND co_sos_elections_2014generalprecinctresults.novotes = 0
       UNION
       SELECT 'Yes'                                                                     AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2014generalprecinctresults.county))   AS county
              ,TRIM(co_sos_elections_2014generalprecinctresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2014generalprecinctresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2014generalprecinctresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2014generalprecinctresults.party)             AS party
              ,TRIM(co_sos_elections_2014generalprecinctresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2014generalprecinctresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2014generalprecinctresults.yesvotes)     AS votes
              ,TO_DATE(co_sos_elections_2014generalprecinctresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2014generalprecinctresults
       WHERE  co_sos_elections_2014generalprecinctresults.yesvotes > 0
       UNION
       SELECT 'No'                                                                      AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2014generalprecinctresults.county))   AS county
              ,TRIM(co_sos_elections_2014generalprecinctresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2014generalprecinctresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2014generalprecinctresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2014generalprecinctresults.party)             AS party
              ,TRIM(co_sos_elections_2014generalprecinctresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2014generalprecinctresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2014generalprecinctresults.novotes)      AS votes
              ,TO_DATE(co_sos_elections_2014generalprecinctresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2014generalprecinctresults
       WHERE  co_sos_elections_2014generalprecinctresults.novotes > 0) r2014
ON ( co_sos_elections_results.county = r2014.county
     AND co_sos_elections_results.votes = r2014.votes
     AND co_sos_elections_results.electiontype = r2014.electiontype
     AND co_sos_elections_results.precinct = r2014.precinct
     AND co_sos_elections_results.year = r2014.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2014.candidateyesno
           ,r2014.county
           ,r2014.electiontype
           ,r2014.officeissuejudgeship
           ,r2014.party
           ,r2014.precinct
           ,r2014.state
           ,r2014.votes
           ,r2014.year );

CREATE TABLE co_sos_elections_2014generalprecinctturnout 
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,precinct       VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2014GeneralPrecinctTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014generalprecinctturnout.activevoters, '[^0-9.]', ''))    AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014generalprecinctturnout.ballotscast, '[^0-9.]', ''))    AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2014generalprecinctturnout.county))                                    AS
               county
              ,TRIM(co_sos_elections_2014generalprecinctturnout.electiontype)                                       AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014generalprecinctturnout.inactivevoters, '[^0-9.]', '')) AS
               inactivevoters
              ,TRIM(co_sos_elections_2014generalprecinctturnout.precinct)                                           AS
               precinct
              ,TRIM(co_sos_elections_2014generalprecinctturnout.state)                                              AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014generalprecinctturnout.totalvoters, '[^0-9.]', ''))    AS
               totalvoters
              ,TO_DATE(co_sos_elections_2014generalprecinctturnout.year, 'YYYY')                                    AS
               year
       FROM   co_sos_elections_2014generalprecinctturnout) t2014
ON ( co_sos_elections_turnout.county = t2014.county
     AND co_sos_elections_turnout.ballotscast = t2014.ballotscast
     AND co_sos_elections_turnout.electiontype = t2014.electiontype
     AND co_sos_elections_turnout.year = t2014.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2014.activevoters
           ,t2014.ballotscast
           ,t2014.county
           ,t2014.electiontype
           ,t2014.inactivevoters
           ,t2014.precinct
           ,t2014.state
           ,t2014.totalvoters
           ,t2014.year );  

CREATE TABLE co_sos_elections_2014primaryelectionresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2014PrimaryElectionResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2014primaryelectionresults.candidateyesno)                             AS
              candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2014primaryelectionresults.county))                           AS county
              ,TRIM(co_sos_elections_2014primaryelectionresults.electiontype)                              AS
               electiontype
              ,TRIM(co_sos_elections_2014primaryelectionresults.officeissuejudgeship)                      AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2014primaryelectionresults.party)                                     AS party
              ,TRIM(co_sos_elections_2014primaryelectionresults.state)                                     AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014primaryelectionresults.votes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2014primaryelectionresults.year, 'YYYY')                           AS year
       FROM   co_sos_elections_2014primaryelectionresults) r2014
ON ( co_sos_elections_results.county = r2014.county
     AND co_sos_elections_results.votes = r2014.votes
     AND co_sos_elections_results.electiontype = r2014.electiontype
     AND co_sos_elections_results.year = r2014.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2014.candidateyesno
           ,r2014.county
           ,r2014.electiontype
           ,r2014.officeissuejudgeship
           ,r2014.party
           ,r2014.state
           ,r2014.votes
           ,r2014.year );  

CREATE TABLE co_sos_elections_2014primaryturnout
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2014PrimaryTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014primaryturnout.activevoters, '[^0-9.]', ''))    AS
              activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014primaryturnout.ballotscast, '[^0-9.]', ''))    AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2014primaryturnout.county))                                    AS county
              ,TRIM(co_sos_elections_2014primaryturnout.electiontype)                                       AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014primaryturnout.inactivevoters, '[^0-9.]', '')) AS
               inactivevoters
              ,TRIM(co_sos_elections_2014primaryturnout.state)                                              AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2014primaryturnout.totalvoters, '[^0-9.]', ''))    AS
               totalvoters
              ,TO_DATE(co_sos_elections_2014primaryturnout.year, 'YYYY')                                    AS year
       FROM   co_sos_elections_2014primaryturnout) t2014
ON ( co_sos_elections_turnout.county = t2014.county
     AND co_sos_elections_turnout.ballotscast = t2014.ballotscast
     AND co_sos_elections_turnout.electiontype = t2014.electiontype
     AND co_sos_elections_turnout.year = t2014.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2014.activevoters
           ,t2014.ballotscast
           ,t2014.county
           ,t2014.electiontype
           ,t2014.inactivevoters
           ,t2014.state
           ,t2014.totalvoters
           ,t2014.year );  

CREATE TABLE co_sos_elections_2015resultscountylevel
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2015ResultsCountyLevel.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT 'Yes'                                                                                       AS
              candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2015resultscountylevel.county))                              AS county
              ,TRIM(co_sos_elections_2015resultscountylevel.electiontype)                                 AS
               electiontype
              ,TRIM(co_sos_elections_2015resultscountylevel.officeissuejudgeship)                         AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2015resultscountylevel.state)                                        AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015resultscountylevel.yesvotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2015resultscountylevel.year, 'YYYY')                              AS year
       FROM   co_sos_elections_2015resultscountylevel
       UNION
       SELECT 'No'                                                                                       AS
              candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2015resultscountylevel.county))                             AS county
              ,TRIM(co_sos_elections_2015resultscountylevel.electiontype)                                AS electiontype
              ,TRIM(co_sos_elections_2015resultscountylevel.officeissuejudgeship)                        AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2015resultscountylevel.state)                                       AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015resultscountylevel.novotes, '[^0-9.]', '')) AS votes
              ,TO_DATE(co_sos_elections_2015resultscountylevel.year, 'YYYY')                             AS year
       FROM   co_sos_elections_2015resultscountylevel) r2015
ON ( co_sos_elections_results.county = r2015.county
     AND co_sos_elections_results.votes = r2015.votes
     AND co_sos_elections_results.electiontype = r2015.electiontype
     AND co_sos_elections_results.year = r2015.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2015.candidateyesno
           ,r2015.county
           ,r2015.electiontype
           ,r2015.officeissuejudgeship
           ,r2015.state
           ,r2015.votes
           ,r2015.year);

CREATE TABLE co_sos_elections_2015turnoutcountylevel
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2015TurnoutCountyLevel.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015turnoutcountylevel.activevoters, '[^0-9.]', ''))    AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015turnoutcountylevel.ballotscast, '[^0-9.]', ''))    AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2015turnoutcountylevel.county))                                    AS
               county
              ,TRIM(co_sos_elections_2015turnoutcountylevel.electiontype)                                       AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015turnoutcountylevel.inactivevoters, '[^0-9.]', '')) AS
               inactivevoters
              ,TRIM(co_sos_elections_2015turnoutcountylevel.state)                                              AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2015turnoutcountylevel.totalvoters, '[^0-9.]', ''))    AS
               totalvoters
              ,TO_DATE(co_sos_elections_2015turnoutcountylevel.year, 'YYYY')                                    AS year
       FROM   co_sos_elections_2015turnoutcountylevel) t2015
ON ( co_sos_elections_turnout.county = t2015.county
     AND co_sos_elections_turnout.ballotscast = t2015.ballotscast
     AND co_sos_elections_turnout.electiontype = t2015.electiontype
     AND co_sos_elections_turnout.year = t2015.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2015.activevoters
           ,t2015.ballotscast
           ,t2015.county
           ,t2015.electiontype
           ,t2015.inactivevoters
           ,t2015.state
           ,t2015.totalvoters
           ,t2015.year );

CREATE TABLE co_sos_elections_2016generalresultsprecinctlevel
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2016GeneralResultsPrecinctLevel.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2016generalresultsprecinctlevel.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2016generalresultsprecinctlevel.county))      AS county
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.party)                AS party
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.precinct)             AS precinct
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.state)                AS state
              ,TO_NUMBER(co_sos_elections_2016generalresultsprecinctlevel.votes)           AS votes
              ,TO_DATE(co_sos_elections_2016generalresultsprecinctlevel.year, 'YYYY')      AS year
       FROM   co_sos_elections_2016generalresultsprecinctlevel
       WHERE  co_sos_elections_2016generalresultsprecinctlevel.yesvotes = 0
          AND co_sos_elections_2016generalresultsprecinctlevel.novotes = 0
       UNION
       SELECT 'Yes'                                                                     AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2016generalresultsprecinctlevel.county))   AS county
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2016generalresultsprecinctlevel.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.party)             AS party
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.precinct)          AS precinct
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.state)             AS state
              ,TO_NUMBER(co_sos_elections_2016generalresultsprecinctlevel.yesvotes)     AS votes
              ,TO_DATE(co_sos_elections_2016generalresultsprecinctlevel.year, 'YYYY')   AS year
       FROM   co_sos_elections_2016generalresultsprecinctlevel
       WHERE  co_sos_elections_2016generalresultsprecinctlevel.yesvotes > 0
       UNION
       SELECT 'No'                                                                      AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2016generalresultsprecinctlevel.county))   AS county
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2016generalresultsprecinctlevel.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.party)             AS party
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.precinct)          AS precinct
              ,TRIM(co_sos_elections_2016generalresultsprecinctlevel.state)             AS state
              ,TO_NUMBER(co_sos_elections_2016generalresultsprecinctlevel.novotes)      AS votes
              ,TO_DATE(co_sos_elections_2016generalresultsprecinctlevel.year, 'YYYY')   AS year
       FROM   co_sos_elections_2016generalresultsprecinctlevel
       WHERE  co_sos_elections_2016generalresultsprecinctlevel.novotes > 0) r2016
ON ( co_sos_elections_results.county = r2016.county
     AND co_sos_elections_results.votes = r2016.votes
     AND co_sos_elections_results.electiontype = r2016.electiontype
     AND co_sos_elections_results.precinct = r2016.precinct
     AND co_sos_elections_results.year = r2016.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2016.candidateyesno
           ,r2016.county
           ,r2016.electiontype
           ,r2016.officeissuejudgeship
           ,r2016.party
           ,r2016.precinct
           ,r2016.state
           ,r2016.votes
           ,r2016.year );

CREATE TABLE co_sos_elections_2016generalturnoutprecinctlevel 
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,precinct       VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2016GeneralTurnoutPrecinctLevel.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016generalturnoutprecinctlevel.activevoters, '[^0-9.]', ''))
              AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016generalturnoutprecinctlevel.ballotscast, '[^0-9.]', ''))
               AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2016generalturnoutprecinctlevel.county))
               AS
               county
              ,TRIM(co_sos_elections_2016generalturnoutprecinctlevel.electiontype)
               AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016generalturnoutprecinctlevel.inactivevoters, '[^0-9.]', ''))
               AS
               inactivevoters
              ,TRIM(co_sos_elections_2016generalturnoutprecinctlevel.precinct)
               AS
               precinct
              ,TRIM(co_sos_elections_2016generalturnoutprecinctlevel.state)
               AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016generalturnoutprecinctlevel.totalvoters, '[^0-9.]', ''))
               AS
               totalvoters
              ,TO_DATE(co_sos_elections_2016generalturnoutprecinctlevel.year, 'YYYY')
               AS
               year
       FROM   co_sos_elections_2016generalturnoutprecinctlevel) t2016
ON ( co_sos_elections_turnout.county = t2016.county
     AND co_sos_elections_turnout.ballotscast = t2016.ballotscast
     AND co_sos_elections_turnout.electiontype = t2016.electiontype
     AND co_sos_elections_turnout.year = t2016.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2016.activevoters
           ,t2016.ballotscast
           ,t2016.county
           ,t2016.electiontype
           ,t2016.inactivevoters
           ,t2016.precinct
           ,t2016.state
           ,t2016.totalvoters
           ,t2016.year );

CREATE TABLE co_sos_elections_2016primaryabstractresults
  (
     officeissuejudgeship VARCHAR2(128)
     ,party               VARCHAR2(128)
     ,county              VARCHAR2(128)
     ,candidateyesno      VARCHAR2(128)
     ,votes               VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2016PrimaryAbstractResults.csv')
  )
REJECT LIMIT UNLIMITED;

 MERGE INTO co_sos_elections_results
using (SELECT TRIM(co_sos_elections_2016primaryabstractresults.candidateyesno)                             AS
              candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2016primaryabstractresults.county))                           AS county
              ,'Primary'                                                                                   AS
               electiontype
              ,TRIM(co_sos_elections_2016primaryabstractresults.officeissuejudgeship)                      AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2016primaryabstractresults.party)                                     AS party
              ,'Colorado'                                                                                  AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016primaryabstractresults.votes, '[^0-9.]', '')) AS votes
              ,TO_DATE(2016, 'YYYY')                                                                       AS year
       FROM   co_sos_elections_2016primaryabstractresults) r2016
ON ( co_sos_elections_results.county = r2016.county
     AND co_sos_elections_results.votes = r2016.votes
     AND co_sos_elections_results.electiontype = r2016.electiontype
     AND co_sos_elections_results.year = r2016.year )
WHEN NOT matched THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2016.candidateyesno
           ,r2016.county
           ,r2016.electiontype
           ,r2016.officeissuejudgeship
           ,r2016.party
           ,r2016.state
           ,r2016.votes
           ,r2016.year );

CREATE TABLE co_sos_elections_2016primaryturnoutcountylevel
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2016PrimaryTurnoutCountyLevel.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_turnout
USING (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016primaryturnoutcountylevel.activevoters, '[^0-9.]', ''))
              AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016primaryturnoutcountylevel.ballotscast, '[^0-9.]', ''))
               AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2016primaryturnoutcountylevel.county))
               AS
               county
              ,TRIM(co_sos_elections_2016primaryturnoutcountylevel.electiontype)
               AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016primaryturnoutcountylevel.inactivevoters, '[^0-9.]', ''))
               AS
               inactivevoters
              ,TRIM(co_sos_elections_2016primaryturnoutcountylevel.state)
               AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2016primaryturnoutcountylevel.totalvoters, '[^0-9.]', ''))
               AS
               totalvoters
              ,TO_DATE(co_sos_elections_2016primaryturnoutcountylevel.year, 'YYYY')
               AS year
       FROM   co_sos_elections_2016primaryturnoutcountylevel) t2016
ON ( co_sos_elections_turnout.county = t2016.county
     AND co_sos_elections_turnout.ballotscast = t2016.ballotscast
     AND co_sos_elections_turnout.electiontype = t2016.electiontype
     AND co_sos_elections_turnout.year = t2016.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2016.activevoters
           ,t2016.ballotscast
           ,t2016.county
           ,t2016.electiontype
           ,t2016.inactivevoters
           ,t2016.state
           ,t2016.totalvoters
           ,t2016.year );

CREATE TABLE co_sos_elections_2018geprecinctlevelresults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,precinct             VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,candidateyesno       VARCHAR2(128)
     ,party                VARCHAR2(128)
     ,votes                VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2018GEPrecinctLevelResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2018geprecinctlevelresults.candidateyesno)        AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2018geprecinctlevelresults.county))      AS county
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.party)                AS party
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.precinct)             AS precinct
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2018geprecinctlevelresults.votes)           AS votes
              ,TO_DATE(co_sos_elections_2018geprecinctlevelresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2018geprecinctlevelresults
       WHERE  co_sos_elections_2018geprecinctlevelresults.yesvotes = 0
          AND co_sos_elections_2018geprecinctlevelresults.novotes = 0
       UNION
       SELECT 'Yes'                                                                     AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2018geprecinctlevelresults.county))   AS county
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2018geprecinctlevelresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.party)             AS party
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2018geprecinctlevelresults.yesvotes)     AS votes
              ,TO_DATE(co_sos_elections_2018geprecinctlevelresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2018geprecinctlevelresults
       WHERE  co_sos_elections_2018geprecinctlevelresults.yesvotes > 0
       UNION
       SELECT 'No'                                                                      AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2018geprecinctlevelresults.county))   AS county
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.electiontype)      AS electiontype
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.officeissuejudgeship)
               || ': '
               || TRIM(co_sos_elections_2018geprecinctlevelresults.candidateyesno) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.party)             AS party
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.precinct)          AS precinct
              ,TRIM(co_sos_elections_2018geprecinctlevelresults.state)             AS state
              ,TO_NUMBER(co_sos_elections_2018geprecinctlevelresults.novotes)      AS votes
              ,TO_DATE(co_sos_elections_2018geprecinctlevelresults.year, 'YYYY')   AS year
       FROM   co_sos_elections_2018geprecinctlevelresults
       WHERE  co_sos_elections_2018geprecinctlevelresults.novotes > 0) r2018
ON ( co_sos_elections_results.county = r2018.county
     AND co_sos_elections_results.votes = r2018.votes
     AND co_sos_elections_results.electiontype = r2018.electiontype
     AND co_sos_elections_results.precinct = r2018.precinct
     AND co_sos_elections_results.year = r2018.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.precinct
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2018.candidateyesno
           ,r2018.county
           ,r2018.electiontype
           ,r2018.officeissuejudgeship
           ,r2018.party
           ,r2018.precinct
           ,r2018.state
           ,r2018.votes
           ,r2018.year );

CREATE TABLE co_sos_elections_2018GEPrecinctLevelTurnout 
  (
     state           VARCHAR2(128)
     ,year           VARCHAR2(128)
     ,electiontype   VARCHAR2(128)
     ,county         VARCHAR2(128)
     ,precinct       VARCHAR2(128)
     ,activevoters   VARCHAR2(128)
     ,inactivevoters VARCHAR2(128)
     ,totalvoters    VARCHAR2(128)
     ,ballotscast    VARCHAR2(128)
     ,turnout        VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE
    CHARACTERSET WE8MSWIN1252
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2018GEPrecinctLevelTurnout.csv')
  )
REJECT LIMIT UNLIMITED;

 MERGE INTO co_sos_elections_turnout
using (SELECT TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2018geprecinctlevelturnout.activevoters, '[^0-9.]', ''))    AS
                    activevoters
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2018geprecinctlevelturnout.ballotscast, '[^0-9.]', ''))    AS
               ballotscast
              ,INITCAP(TRIM(co_sos_elections_2018geprecinctlevelturnout.county))                                    AS
               county
              ,TRIM(co_sos_elections_2018geprecinctlevelturnout.electiontype)                                       AS
               electiontype
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2018geprecinctlevelturnout.inactivevoters, '[^0-9.]', '')) AS
               inactivevoters
              ,TRIM(co_sos_elections_2018geprecinctlevelturnout.precinct)                                           AS
               precinct
              ,TRIM(co_sos_elections_2018geprecinctlevelturnout.state)                                              AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2018geprecinctlevelturnout.totalvoters, '[^0-9.]', ''))    AS
               totalvoters
              ,TO_DATE(co_sos_elections_2018geprecinctlevelturnout.year, 'YYYY')                                    AS
               year
       FROM   co_sos_elections_2018geprecinctlevelturnout) t2018
ON ( co_sos_elections_turnout.county = t2018.county
     AND co_sos_elections_turnout.ballotscast = t2018.ballotscast
     AND co_sos_elections_turnout.electiontype = t2018.electiontype
     AND co_sos_elections_turnout.year = t2018.year )
WHEN NOT matched THEN
  INSERT ( co_sos_elections_turnout.activevoters
           ,co_sos_elections_turnout.ballotscast
           ,co_sos_elections_turnout.county
           ,co_sos_elections_turnout.electiontype
           ,co_sos_elections_turnout.inactivevoters
           ,co_sos_elections_turnout.precinct
           ,co_sos_elections_turnout.state
           ,co_sos_elections_turnout.totalvoters
           ,co_sos_elections_turnout.year )
  VALUES ( t2018.activevoters
           ,t2018.ballotscast
           ,t2018.county
           ,t2018.electiontype
           ,t2018.inactivevoters
           ,t2018.precinct
           ,t2018.state
           ,t2018.totalvoters
           ,t2018.year );

CREATE TABLE co_sos_elections_2018primaryresults
  (
     officeissuejudgeship VARCHAR2(128)
     ,party               VARCHAR2(128)
     ,county              VARCHAR2(128)
     ,candidateyesno      VARCHAR2(128)
     ,votes               VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2018PrimaryResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2018primaryresults.candidateyesno)                             AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2018primaryresults.county))                           AS county
              ,'Primary'                                                                           AS electiontype
              ,TRIM(co_sos_elections_2018primaryresults.officeissuejudgeship)                      AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2018primaryresults.party)                                     AS party
              ,'Colorado'                                                                          AS state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2018primaryresults.votes, '[^0-9.]', '')) AS votes
              ,TO_DATE(2018, 'YYYY')                                                               AS year
       FROM   co_sos_elections_2018primaryresults
       WHERE  co_sos_elections_2018primaryresults.county NOT LIKE '%TOTAL%'
          AND co_sos_elections_2018primaryresults.county NOT LIKE '%PERCENTAGE%') r2018
ON ( co_sos_elections_results.county = r2018.county
     AND co_sos_elections_results.votes = r2018.votes
     AND co_sos_elections_results.electiontype = r2018.electiontype
     AND co_sos_elections_results.year = r2018.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2018.candidateyesno
           ,r2018.county
           ,r2018.electiontype
           ,r2018.officeissuejudgeship
           ,r2018.party
           ,r2018.state
           ,r2018.votes
           ,r2018.year );  
CREATE TABLE co_sos_elections_2019FinalResults
  (
     state                 VARCHAR2(128)
     ,year                 VARCHAR2(128)
     ,electiontype         VARCHAR2(128)
     ,county               VARCHAR2(128)
     ,officeissuejudgeship VARCHAR2(128)
     ,yesvotes             VARCHAR2(128)
     ,novotes              VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2019FinalResults.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT 'Yes'                                                         AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2019finalresults.county))      AS county
              ,TRIM(co_sos_elections_2019finalresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2019finalresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2019finalresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2019finalresults.yesvotes)        AS votes
              ,TO_DATE(co_sos_elections_2019finalresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2019finalresults
       UNION
       SELECT 'No'                                                          AS candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2019finalresults.county))      AS county
              ,TRIM(co_sos_elections_2019finalresults.electiontype)         AS electiontype
              ,TRIM(co_sos_elections_2019finalresults.officeissuejudgeship) AS officeissuejudgeship
              ,TRIM(co_sos_elections_2019finalresults.state)                AS state
              ,TO_NUMBER(co_sos_elections_2019finalresults.novotes)         AS votes
              ,TO_DATE(co_sos_elections_2019finalresults.year, 'YYYY')      AS year
       FROM   co_sos_elections_2019finalresults) r2019
ON ( co_sos_elections_results.county = r2019.county
     AND co_sos_elections_results.votes = r2019.votes
     AND co_sos_elections_results.electiontype = r2019.electiontype
     AND co_sos_elections_results.year = r2019.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year)
  VALUES ( r2019.candidateyesno
           ,r2019.county
           ,r2019.electiontype
           ,r2019.officeissuejudgeship
           ,r2019.state
           ,r2019.votes
           ,r2019.year);

CREATE TABLE co_sos_elections_2020PresPrimaryResultsByCountyFINAL
  (
     officeissuejudgeship VARCHAR2(128)
     ,party               VARCHAR2(128)
     ,county              VARCHAR2(128)
     ,candidateyesno      VARCHAR2(128)
     ,votes               VARCHAR2(128)
  )
ORGANIZATION EXTERNAL
  (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_dat_co
  ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY NEWLINE 
    CHARACTERSET WE8MSWIN1252 
    skip=1
    fields terminated by ','
    OPTIONALLY ENCLOSED BY '"' AND '"'
    MISSING FIELD VALUES ARE NULL
    )
  LOCATION ('2020PresPrimaryResultsByCountyFINAL.csv')
  )
REJECT LIMIT UNLIMITED;

MERGE INTO co_sos_elections_results
USING (SELECT TRIM(co_sos_elections_2020presprimaryresultsbycountyfinal.candidateyesno)                             AS
                    candidateyesno
              ,INITCAP(TRIM(co_sos_elections_2020presprimaryresultsbycountyfinal.county))                           AS
               county
              ,'Primary'                                                                                            AS
               electiontype
              ,TRIM(co_sos_elections_2020presprimaryresultsbycountyfinal.officeissuejudgeship)                      AS
               officeissuejudgeship
              ,TRIM(co_sos_elections_2020presprimaryresultsbycountyfinal.party)                                     AS
               party
              ,'Colorado'                                                                                           AS
               state
              ,TO_NUMBER(REGEXP_REPLACE(co_sos_elections_2020presprimaryresultsbycountyfinal.votes, '[^0-9.]', '')) AS
               votes
              ,TO_DATE(2020, 'YYYY')                                                                                AS
               year
       FROM   co_sos_elections_2020presprimaryresultsbycountyfinal
       WHERE  co_sos_elections_2020presprimaryresultsbycountyfinal.county NOT LIKE '%Vote%') r2020
ON ( co_sos_elections_results.county = r2020.county
     AND co_sos_elections_results.votes = r2020.votes
     AND co_sos_elections_results.electiontype = r2020.electiontype
     AND co_sos_elections_results.year = r2020.year )
WHEN NOT MATCHED THEN
  INSERT ( co_sos_elections_results.candidateyesno
           ,co_sos_elections_results.county
           ,co_sos_elections_results.electiontype
           ,co_sos_elections_results.officeissuejudgeship
           ,co_sos_elections_results.party
           ,co_sos_elections_results.state
           ,co_sos_elections_results.votes
           ,co_sos_elections_results.year )
  VALUES ( r2020.candidateyesno
           ,r2020.county
           ,r2020.electiontype
           ,r2020.officeissuejudgeship
           ,r2020.party
           ,r2020.state
           ,r2020.votes
           ,r2020.year );  