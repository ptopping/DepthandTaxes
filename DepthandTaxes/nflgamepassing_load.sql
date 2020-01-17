DROP TABLE nfl_game_passing;
DROP TABLE nfl_game_passing_load;

CREATE TABLE nfl_game_passing
	(
	Rk number,
	Player varchar2(50), 
	Pos varchar2(10), 
	Age number, 
	Gamedate date, 
	Lg varchar2(10), 
	Tm varchar2(10), 
	HomeAway varchar2(10), 
	Opp varchar2(10),
	Result varchar2(10), 
	G number,
	Week number, 
	Day varchar2(10), 
	Cmp number, 
	Att number, 
	CmpPct number, 
	Yds number, 
	TD number, 
	Interception number,
	Rate number, 
	Sk number, 
	SkYds number, 
	YPA number, 
	AYPA number
	);

CREATE TABLE nfl_game_passing_load
	(
	Rk number,
	Player varchar2(50), 
	Pos varchar2(4), 
	Age number, 
	Gamedate varchar2(12), 
	Lg varchar2(4), 
	Tm varchar2(4), 
	HomeAway varchar2(3), 
	Opp varchar2(4),
	Result varchar2(10), 
	G number,
	Week number, 
	Day varchar2(4), 
	Cmp number, 
	Att number, 
	CmpPct number, 
	Yds number, 
	TD number, 
	Interception number,
	Rate number, 
	Sk number, 
	SkYds number, 
	YPA number, 
	AYPA number
    )
ORGANIZATION EXTERNAL
	(
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY ext_dat_load
	ACCESS PARAMETERS
		(
		RECORDS DELIMITED BY NEWLINE skip=1
		fields terminated by ','
		OPTIONALLY ENCLOSED BY '"' AND '"'
		MISSING FIELD VALUES ARE NULL
		)
	LOCATION ('quarterbacks.csv')
	)
REJECT LIMIT UNLIMITED;

INSERT INTO nfl_game_passing (
	Rk,	Player, Pos, Age, Gamedate, Lg, Tm,	HomeAway, Opp, Result, G, Week, Day, Cmp, Att, CmpPct, Yds, TD, Interception, Rate, Sk, SkYds, YPA, AYPA
)
	(
	SELECT
		Rk,
		Player, 
		Pos, 
		Age, 
		to_date(Gamedate,'YYYY-MM-DD'), 
		Lg, 
		Tm, 
		HomeAway, 
		Opp,
		Result, 
		G,
		Week, 
		Day, 
		Cmp, 
		Att, 
		CmpPct, 
		Yds, 
		TD, 
		Interception,
		Rate, 
		Sk, 
		SkYds, 
		YPA, 
		AYPA
	FROM nfl_game_passing_load
	);
