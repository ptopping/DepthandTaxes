import pandas as pd
import numpy as np

class CensusLoad(object):
    """Creates DataFrame from Census PopEstimate csv"""
    def __init__(self, csv, kind='single'):
        self.csv = csv
        self.kind = kind
        self.df = pd.read_csv('C:\\Users\\ptopp\\Documents\\DATFiles\\{csv}.csv'.format(csv=csv))
        self.region_dict = {0: 'United States Total', 1: 'Northeast', 2: 'Midwest', 3: 'South', 4: 'West'}
        self.division_dict = {0: 'United States Total', 1: 'New England', 2: 'Middle Atlantic', 3: 'East North Central', 4: 'West North Central', 5: 'South Atlantic', 6: 'East South Central', 7: 'West South Central',
                            8: 'Mountain', 9: 'Pacific'} 
        self.sex_dict = {0: 'Total', 1: 'Male', 2: 'Female'}
        self.origin_dict = {0: 'Total', 1: 'Not Hispanic', 2: 'Hispanic'}
        self.race_dict = {1: 'White', 2: 'Black', 3: 'Native', 4: 'Asian', 5: 'Hawaiian', 6: 'Multi'}
        self.sumlev_dict = {40: 'STATE'}
        self.year_dict = {'CENSUS2010POP' : 2010, 'ESTIMATESBASE2000' : 2000, 'POPESTIMATE2001' : 2001, 'POPESTIMATE2002' : 2002, 'POPESTIMATE2003' : 2003, 'POPESTIMATE2004' : 2004, 
                        'POPESTIMATE2005' : 2005, 'POPESTIMATE2006' : 2006, 'POPESTIMATE2007' : 2007, 'POPESTIMATE2008' : 2008, 'POPESTIMATE2009' : 2009, 'POPESTIMATE2011' : 2011, 
                        'POPESTIMATE2012' : 2012, 'POPESTIMATE2013' : 2013, 'POPESTIMATE2014' : 2014, 'POPESTIMATE2015' : 2015, 'POPESTIMATE2016' : 2016, 'POPESTIMATE2017' : 2017}        
        self.future = {'2020rate' : pd.Series([.0162,.0243,.0125,.0264,.0174,.0022,.0086,.0350,.0066], 
                    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
                    '2030rate' : pd.Series([.0141,.0221,.0113,.0243,.0163,.0010,.0076,.0337,.0056],
                    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
                    '2040rate' : pd.Series([.0124,.0202,.0105,.0216,.0147,-.0001,.0066,.0319,.0046],
                    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
                    '2050rate' : pd.Series([.0109,.0185,.0099,.0196,.0132,-.0010,.0058,.0304,.0037],
                    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White']),
                    '2060rate' : pd.Series([.0099,.0170,.0093,.0180,.0113,-.0015,.0052,.0290,.0032],
                    index=['American Indian','Asian','Black','Hispanic','Native Hawaiian','White','One Race','Multi','All White'])}
        self.future_df = pd.DataFrame(self.future)
        self.col_list = ['NAME', 'DIVISION', 'RACE', 'CENSUS2010POP', 'POPESTIMATE2011', 'POPESTIMATE2012', 'POPESTIMATE2013', 'POPESTIMATE2014', 'POPESTIMATE2015', 'POPESTIMATE2016', 
                    'POPESTIMATE2017', 'ESTIMATESBASE2000', 'POPESTIMATE2001', 'POPESTIMATE2002', 'POPESTIMATE2003', 'POPESTIMATE2004', 'POPESTIMATE2005', 'POPESTIMATE2006', 'POPESTIMATE2007',
                    'POPESTIMATE2008', 'POPESTIMATE2009']


    def pretty(self):
        #Instantiates and sets initial variables
        df = self.df
        kind = self.kind
		
		#Map categoricals to numerical index to prevent confusion
        df.REGION = df.REGION.map(self.region_dict).fillna(df.REGION)
        df.DIVISION = df.DIVISION.map(self.division_dict).fillna(df.DIVISION)
        df.SEX = df.SEX.map(self.sex_dict).fillna(df.SEX)
        df.ORIGIN = df.ORIGIN.map(self.origin_dict).fillna(df.ORIGIN)
        df.RACE = df.RACE.map(self.race_dict).fillna(df.RACE)
		
		#Currently two types 5-year and single-year age groups.  Single-year needs converting to 5-year
        if kind == 'single':
            df.SUMLEV = df.SUMLEV.map(self.sumlev_dict).fillna(df.SUMLEV)
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
        
		#Aggregate based on race groups
		hispanic = df[(df['ORIGIN'] == 'Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] != 0)]
        hispanic = hispanic.pivot_table(values=hispanic.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['ORIGIN'],aggfunc=np.sum).stack(0)
        white = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'White')]
        white = white.pivot_table(values=white.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        black = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Black')]
        black = black.pivot_table(values=black.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        indian = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Native')]
        indian = indian.pivot_table(values=indian.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        asian = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Asian')]
        asian = asian.pivot_table(values=asian.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        hawaii = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Hawaiian')]
        hawaii = hawaii.pivot_table(values=hawaii.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        multi = df[(df['ORIGIN'] == 'Not Hispanic') & (df['AGEGRP'] >= 5) & (df['SEX'] == 'Total') & (df['RACE'] == 'Multi')]
        multi = multi.pivot_table(values=multi.select_dtypes(include='number'),index=['NAME','DIVISION'],columns=['RACE'],aggfunc=np.sum).stack(0)
        
		#Merge race tables
		df = hispanic.merge(white,how='left',left_index=True,right_index=True)
        for race in [black,indian,asian,hawaii,multi]:
            df = df.merge(race,how='left',left_index=True,right_index=True)
        df = df.unstack(2).stack(0).reset_index().rename(columns={'level_2' : 'RACE'})
        df.columns = df.columns.str.upper()
        
		#Select wanted columns
        cols = [c for c in self.col_list if c in df.columns]
        df = df[cols]
        
		#Rename and reshape table
		df.rename(columns= self.year_dict, inplace= True)        
        df.rename(columns= {'NAME': 'STATE'}, inplace= True)
        df = df.melt(id_vars=['STATE', 'DIVISION', 'RACE'])
        df.rename(columns={'value' : 'POPULATION', 'variable': 'YEAR'}, inplace=True)
        return df

        def projection(self):
            #Create initial dataframe
			df = pretty(self.df)
			#Reshape dataframe
			#Merge future dataframe
			#Calculate future population estimates
			df = df.merge(future_df,how='left',left_on='Race',right_index=True)
			df['POPESTIMATE2018'] = df[df.columns[-1]] * (1+df['2020rate'])**(2018-df.columns[-1])
			df['POPESTIMATE2020'] = df[df.columns[-1]] * (1+df['2020rate'])**(2020-df.columns[-1])
			df['POPESTIMATE2024'] = df[df.columns[-1]] * (1+df['2030rate'])**(2024-df.columns[-1])
			df['POPESTIMATE2028'] = df[df.columns[-1]] * (1+df['2030rate'])**(2028-df.columns[-1])
			df['POPESTIMATE2032'] = df[df.columns[-1]] * (1+df['2040rate'])**(2032-df.columns[-1])
			df['POPESTIMATE2036'] = df[df.columns[-1]] * (1+df['2040rate'])**(2036-df.columns[-1])
			df['POPESTIMATE2040'] = df[df.columns[-1]] * (1+df['2040rate'])**(2040-df.columns[-1])
			df = df.melt(id_vars=['Name','Race','Division']).pivot_table(index=['Name','Division','variable'],columns='Race',values='value')
			df = df.reset_index().rename(columns={'variable':'YEAR','Name' : 'State'})
			df.columns = df.columns.str.title()
			return df
