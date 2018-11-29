def censusdf(object):
    df = object.df
    type = object.type
    df.REGION = df.REGION.map(object.region_dict).fillna(df.REGION)
    df.DIVISION = df.DIVISION.map(object.division_dict).fillna(df.DIVISION)
    df.SEX = df.SEX.map(object.sex_dict).fillna(df.SEX)
    df.ORIGIN = df.ORIGIN.map(object.origin_dict).fillna(df.ORIGIN)
    df.RACE = df.RACE.map(object.race_dict).fillna(df.RACE)
    if type == 'single':
        df.SUMLEV = df.SUMLEV.map(object.sumlev_dict).fillna(df.SUMLEV)
        df.loc[df['AGE'] <= 4,'AGE'] = 1
        df.loc[(df['AGE'] >= 5) & (df['AGE'] <= 9),'AGE'] = 2
        df.loc[(df['AGE'] >= 10) & (df['AGE'] <= 14),'AGE'] = 3
        df.loc[(df['AGE'] >= 15) & (df['AGE'] <= 19),'AGE'] = 4
        df.loc[(df['AGE'] >= 20) & (df['AGE'] <= 24),'AGE'] = 5
        df.loc[(df['AGE'] >= 25) & (df['AGE'] <= 29),'AGE'] = 6
        df.loc[(df['AGE'] >= 30) & (df['AGE'] <= 34),'AGE'] = 7
        df.loc[(df['AGE'] >= 35) & (df['AGE'] <= 39),'AGE'] = 8
        df.loc[(df['AGE'] >= 40) & (df['AGE'] <= 44),'AGE'] = 9
        df.loc[(df['AGE'] >= 45) & (df['AGE'] <= 49),'AGE'] = 10
        df.loc[(df['AGE'] >= 50) & (df['AGE'] <= 54),'AGE'] = 11
        df.loc[(df['AGE'] >= 55) & (df['AGE'] <= 59),'AGE'] = 12
        df.loc[(df['AGE'] >= 60) & (df['AGE'] <= 64),'AGE'] = 13
        df.loc[(df['AGE'] >= 65) & (df['AGE'] <= 69),'AGE'] = 14
        df.loc[(df['AGE'] >= 70) & (df['AGE'] <= 74),'AGE'] = 15
        df.loc[(df['AGE'] >= 75) & (df['AGE'] <= 79),'AGE'] = 16
        df.loc[(df['AGE'] >= 80) & (df['AGE'] <= 84),'AGE'] = 17
        df.loc[(df['AGE'] >= 85),'AGE'] = 18
        df.rename(columns={'AGE' : 'AGEGRP'}, inplace=True)
    hispanic = df[(df['ORIGIN'] == 'Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] != 0)]
    hispanic = hispanic.pivot_table(values=hispanic.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['ORIGIN'],aggfunc=np.sum).stack(0)
    white = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'White')]
    white = white.pivot_table(values=white.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    black = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Black')]
    black = black.pivot_table(values=black.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    indian = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'American Indian')]
    indian = indian.pivot_table(values=indian.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    asian = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Asian')]
    asian = asian.pivot_table(values=asian.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    hawaii = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Native Hawaiian')]
    hawaii = hawaii.pivot_table(values=hawaii.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    multi = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Multi')]
    multi = multi.pivot_table(values=multi.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
    df = hispanic.merge(white,how='left',left_index=True,right_index=True)
    for race in [black,indian,asian,hawaii,multi]:
        df = df.merge(race,how='left',left_index=True,right_index=True)
    df = df.unstack(2).stack(0).reset_index().rename(columns={'level_2' : 'RACE'})
    df.columns = df.columns.str.title()
    return df

def popprojection(df):
    census_year = {'Census2010Pop' : 2010, 'Estimatesbase2000' : 2000, 'Popestimate2001' : 2001, 'Popestimate2002' : 2002, 'Popestimate2003' : 2003,
    'Popestimate2004' : 2004, 'Popestimate2005' : 2005, 'Popestimate2006' : 2006, 'Popestimate2007' : 2007, 'Popestimate2008' : 2008, 'Popestimate2009' : 2009,
    'Popestimate2011' : 2011, 'Popestimate2012' : 2012, 'Popestimate2013' : 2013, 'Popestimate2014' : 2014, 'Popestimate2015' : 2015, 'Popestimate2016' : 2016,
    'Popestimate2017' : 2017, 'POPESTIMATE2018' : 2018, 'POPESTIMATE2020' : 2020, 'POPESTIMATE2024' : 2024, 'POPESTIMATE2028' : 2028,
    'POPESTIMATE2032' : 2032, 'POPESTIMATE2036' : 2036, 'POPESTIMATE2040' : 2040}
    future = {'2020' : pd.Series([.0162,.0243,.0125,.0264,.0174,.0022,.0086,.0350,.0066],
    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
    '2030' : pd.Series([.0141,.0221,.0113,.0243,.0163,.0010,.0076,.0337,.0056],
    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
    '2040' : pd.Series([.0124,.0202,.0105,.0216,.0147,-.0001,.0066,.0319,.0046],
    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
    '2050' : pd.Series([.0109,.0185,.0099,.0196,.0132,-.0010,.0058,.0304,.0037],
    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
    '2060' : pd.Series([.0099,.0170,.0093,.0180,.0113,-.0015,.0052,.0290,.0032],
    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White'])}
    future_df = pd.DataFrame(future)
    cols = census_year.keys()
    cols.extend(['Name','Race','Division'])
    df = df.merge(future_df,how='left',left_on='Race',right_index=True)
    df['POPESTIMATE2018'] = df['Popestimate2017'] * (1+df['2020'])**(2018-2017)
    df['POPESTIMATE2020'] = df['Popestimate2017'] * (1+df['2020'])**(2020-2017)
    df['POPESTIMATE2024'] = df['Popestimate2017'] * (1+df['2030'])**(2024-2017)
    df['POPESTIMATE2028'] = df['Popestimate2017'] * (1+df['2030'])**(2028-2017)
    df['POPESTIMATE2032'] = df['Popestimate2017'] * (1+df['2040'])**(2032-2017)
    df['POPESTIMATE2036'] = df['Popestimate2017'] * (1+df['2040'])**(2036-2017)
    df['POPESTIMATE2040'] = df['Popestimate2017'] * (1+df['2040'])**(2040-2017)
    df = df[cols]
    df = df.rename(columns=census_year)
    df = df.melt(id_vars=['Name','Race','Division']).pivot_table(index=['Name','Division','variable'],columns='Race',values='value')
    df = df.reset_index().rename(columns={'variable':'YEAR','Name' : 'State'})
    df.columns = df.columns.str.title()
    return df
