import geopandas
import numpy as np
import pandas as pd

class CensusData(object):
    """docstring for CensusData"""
    def __init__(self, state):
        self.df = pd.DataFrame()
        self.state = state
        self.FIPS = {'Alabama':'01', 'Alaska':'02', 'Arizona':'04',
                     'Arkansas':'05', 'California':'06', 'Colorado':'08',
                     'Connecticut':'09', 'Delaware':'10',
                     'District of Columbia':'11', 'Florida':'12',
                     'Georgia':'13', 'Hawaii':'15', 'Idaho':'16',
                     'Illinois':'17', 'Indiana':'18', 'Iowa':'19',
                     'Kansas':'20', 'Kentucky':'21', 'Louisiana':'22',
                     'Maine':'23', 'Maryland':'24', 'Massachusetts':'25',
                     'Michigan':'26', 'Minnesota':'27', 'Mississippi':'28',
                     'Missouri':'29', 'Montana':'30', 'Nebraska':'31',
                     'Nevada':'32', 'New Hampshire':'33', 'New Jersey':'34',
                     'New Mexico':'35', 'New York':'36',
                     'North Carolina':'37', 'North Dakota':'38', 'Ohio':'39',
                     'Oklahoma':'40', 'Oregon':'41', 'Pennsylvania':'42',
                     'Rhode Island':'44', 'South Carolina':'45',
                     'South Dakota':'46', 'Tennessee':'47', 'Texas':'48',
                     'Utah':'49', 'Vermont':'50', 'Virginia':'51',
                     'Washington':'53', 'West Virginia':'54',
                     'Wisconsin':'55', 'Wyoming':'56'}
        self.stateId = self.FIPS.get(self.state)
        self.gdf = self.geo_df()
    
    def extract(self, url):
        df = pd.read_json(url)
        df.columns = df.loc[0]
        df = df.drop(0)
        return df

    def geo_df(self):
        file = '..//DATFiles//Geofiles//tl_2019_us_county.shp'
        df = geopandas.read_file(file)
        df = df[df['STATEFP'] == self.stateId]
        return df

    def pull(self, year=2000, geolevel='state'):
        race_list = ['2', '3', '4', '5', '6']
        hisp_dict = {'0': 'BothHispanicOrigins', '1': 'Non-Hispanic',
                     '2': 'Hispanic'}
        race_dict = {'0': 'Allraces', '1': 'White', '2': 'Black',
                     '3': 'Native', '4': 'Asian', '5': 'API', '6': 'Multi'}
        sex_dict = {'1': 'Male', '2':'Female'}
        age_dict = {'23': '18to24years', '24': '25to44years',
                    '25': '45to64years', '26': '65yearsandover'}
        replace_dict = {'POP': '', 'yearsHispanicAllraces': 'Hisp',
                        'yearsandoverHispanicAllraces': 'overHisp',
                        'yearsNon-Hispanic': '',
                        'yearsandoverNon-Hispanic': 'over',
                        'yearsBothHispanicOrigins': '',
                        'yearsandoverBothHispanicOrigins': 'over'}
        
        if geolevel == 'state':
            if year == 2000:
                year_code_list = ['1', '3', '4', '5', '6', '7', '8', '9', '10',
                                  '11']
                url = 'https://api.census.gov/data/2000/pep/int_charagegroups?'\
                      + 'get=DATE_,DATE_DESC,GEONAME,HISP,POP,RACE,SEX&for='\
                      + 'state:{}&AGEGROUP=23:26'.format(self.stateId)
                df = self.extract(url)
                
                df.rename(columns={'GEONAME':'NAME'}, inplace=True)
           
                df = df[(df['DATE_'].isin(year_code_list)) & (df['SEX'] != '0')]

            if year >= 2010 and year < 2020:
                year_code_dict = {2010: '1', 2011: '4', 2012: '5', 2013: '6',
                                  2014: '7', 2015: '8', 2016: '9', 2017: '10',
                                  2018: '11', 2019: '12'}
                url = 'https://api.census.gov/data/2019/pep/charagegroups'\
                      + '?get=DATE_DESC,HISP,NAME,POP,RACE'\
                      + '&for=state:{}&AGEGROUP=23:26&SEX!=0'.format(self.stateId)\
                      + '&DATE_CODE={}'.format(year_code_dict.get(year))
                df = self.extract(url)

            if year >= 2020:
                age_list = ['23', '24', '25', '26']
                url = 'https://api.census.gov/data/2017/popproj/agegroups?get='\
                      + 'AGEGROUP,DATE_CODE,HISP,POP,RACE,YEAR&for=us:1&SEX!=0'
                df = self.extract(url)
                df = df[df['AGEGROUP'].isin(age_list)]

            df['POP'] = df['POP'].apply(pd.to_numeric)
            df2 = df[(df['HISP'] == '2') & (df['RACE'] =='0')]
            df3 = df[(df['HISP'] == '1') & (df['RACE'] =='1')]
            df4 = df[(df['HISP'] == '0') & (df['RACE'].isin(race_list))]
            df = pd.concat([df2, df3, df4])

            if year < 2020:
                df['DATE_DESC'] = df['DATE_DESC'].str.extract(r'([0-9\/]+)')
                df['DATE_DESC'] = df['DATE_DESC'].apply(pd.to_datetime)
                df.rename(columns={'DATE_DESC':'YEAR'}, inplace=True)
                df['YEAR'] = df['YEAR'].dt.year

                cols = ['AGEGROUP', 'YEAR', 'HISP', 'NAME', 'POP', 'RACE',
                        'SEX']
                ndx = ['YEAR', 'NAME']

            if year >= 2020:
                df['YEAR'] = df['YEAR'].apply(pd.to_numeric)
                cols = ['AGEGROUP', 'YEAR', 'HISP', 'POP', 'RACE', 'SEX']
                ndx = ['YEAR']

            df['HISP'] = df['HISP'].map(hisp_dict)
            df['RACE'] = df['RACE'].map(race_dict)
            df['SEX'] = df['SEX'].map(sex_dict)
            df['AGEGROUP'] = df['AGEGROUP'].map(age_dict)
            
            df = df[cols]
            df = df.pivot(index=ndx, columns=['AGEGROUP', 'HISP', 'RACE', 'SEX'])

            df.columns = df.columns.map(''.join).str.strip()
            for k, v in replace_dict.items():
                df.columns = df.columns.str.replace(k, v)
            
            df.columns = df.columns.str.upper()
            df = df.reset_index()


        if geolevel == 'congress':
            var_list = ['B', 'C', 'D', 'E', 'G', 'H', 'I']
            var_dict = {'B': 'BLACK', 'C': 'NATIVE', 'D': 'ASIAN', 'E': 'API',
                        'G': 'MULTI', 'H': 'WHITE', 'I': 'HISP'}
            cols = ['GEO_ID', 'YEAR']
            df_list = []
            df = pd.DataFrame()

            for v in var_list:
                male = [format(i, '02') for i in range(7,17)]
                female = [format(i, '02') for i in range(22,32)]
                comb = male + female

                url = 'https://api.census.gov/data/{}'.format(year)\
                          + '/acs/acs1?get=group(B01001{}'.format(v)\
                          + ')&for=congressional%20district:*&in=state:'\
                          + '{}'.format(self.stateId)
                df2 = self.extract(url)
                df2['YEAR'] = year
                cols = ['congressional district', 'YEAR']
                
                for c in comb:
                        cols.append('B01001{}_0{}E'.format(v, c))
                if year == 2005:
                    cols.append('NAME')
                else:
                    pass
                for c in cols:
                    if c not in ['congressional district', 'YEAR', 'NAME']:
                        df2[c] = df2[c].apply(pd.to_numeric)
                    else:
                        pass
                df_list.append(df2[cols])
            
            for d in df_list:
                df = df.append(d, sort=True)

            df.reset_index(inplace=True, drop=True)
            df = df.groupby(['YEAR', 'congressional district'])\
                   .sum()\
                   .reset_index()
            df.rename(columns={'congressional district':'NAME'}, inplace=True)
            cols = ['B01001B_007E', 'B01001B_008E']
            df['18TO24BLACKMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_009E', 'B01001B_010E', 'B01001B_011E']
            df['25TO44BLACKMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_012E', 'B01001B_013E']
            df['45TO64BLACKMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_014E', 'B01001B_015E', 'B01001B_016E']
            df['65OVERBLACKMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_022E', 'B01001B_023E']
            df['18TO24BLACKFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_024E', 'B01001B_025E', 'B01001B_026E']
            df['25TO44BLACKFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_027E', 'B01001B_028E']
            df['45TO64BLACKFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001B_029E', 'B01001B_030E', 'B01001B_031E']
            df['65OVERBLACKFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_007E', 'B01001C_008E']
            df['18TO24NATIVEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_009E', 'B01001C_010E', 'B01001C_011E']
            df['25TO44NATIVEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_012E', 'B01001C_013E']
            df['45TO64NATIVEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_014E', 'B01001C_015E', 'B01001C_016E']
            df['65OVERNATIVEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_022E', 'B01001C_023E']
            df['18TO24NATIVEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_024E', 'B01001C_025E', 'B01001C_026E']
            df['25TO44NATIVEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_027E', 'B01001C_028E']
            df['45TO64NATIVEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001C_029E', 'B01001C_030E', 'B01001C_031E']
            df['65OVERNATIVEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_007E', 'B01001D_008E']
            df['18TO24ASIANMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_009E', 'B01001D_010E', 'B01001D_011E']
            df['25TO44ASIANMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_012E', 'B01001D_013E']
            df['45TO64ASIANMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_014E', 'B01001D_015E', 'B01001D_016E']
            df['65OVERASIANMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_022E', 'B01001D_023E']
            df['18TO24ASIANFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_024E', 'B01001D_025E', 'B01001D_026E']
            df['25TO44ASIANFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_027E', 'B01001D_028E']
            df['45TO64ASIANFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001D_029E', 'B01001D_030E', 'B01001D_031E']
            df['65OVERASIANFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_007E', 'B01001E_008E']
            df['18TO24APIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_009E', 'B01001E_010E', 'B01001E_011E']
            df['25TO44APIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_012E', 'B01001E_013E']
            df['45TO64APIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_014E', 'B01001E_015E', 'B01001E_016E']
            df['65OVERAPIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_022E', 'B01001E_023E']
            df['18TO24APIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_024E', 'B01001E_025E', 'B01001E_026E']
            df['25TO44APIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_027E', 'B01001E_028E']
            df['45TO64APIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001E_029E', 'B01001E_030E', 'B01001E_031E']
            df['65OVERAPIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_007E', 'B01001G_008E']
            df['18TO24MULTIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_009E', 'B01001G_010E', 'B01001G_011E']
            df['25TO44MULTIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_012E', 'B01001G_013E']
            df['45TO64MULTIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_014E', 'B01001G_015E', 'B01001G_016E']
            df['65OVERMULTIMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_022E', 'B01001G_023E']
            df['18TO24MULTIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_024E', 'B01001G_025E', 'B01001G_026E']
            df['25TO44MULTIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_027E', 'B01001G_028E']
            df['45TO64MULTIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001G_029E', 'B01001G_030E', 'B01001G_031E']
            df['65OVERMULTIFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_007E', 'B01001H_008E']
            df['18TO24WHITEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_009E', 'B01001H_010E', 'B01001H_011E']
            df['25TO44WHITEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_012E', 'B01001H_013E']
            df['45TO64WHITEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_014E', 'B01001H_015E', 'B01001H_016E']
            df['65OVERWHITEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_022E', 'B01001H_023E']
            df['18TO24WHITEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_024E', 'B01001H_025E', 'B01001H_026E']
            df['25TO44WHITEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_027E', 'B01001H_028E']
            df['45TO64WHITEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001H_029E', 'B01001H_030E', 'B01001H_031E']
            df['65OVERWHITEFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_007E', 'B01001I_008E']
            df['18TO24HISPMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_009E', 'B01001I_010E', 'B01001I_011E']
            df['25TO44HISPMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_012E', 'B01001I_013E']
            df['45TO64HISPMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_014E', 'B01001I_015E', 'B01001I_016E']
            df['65OVERHISPMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_022E', 'B01001I_023E']
            df['18TO24HISPFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_024E', 'B01001I_025E', 'B01001I_026E']
            df['25TO44HISPFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_027E', 'B01001I_028E']
            df['45TO64HISPFEMALE'] = df[cols].sum(axis=1)
            cols = ['B01001I_029E', 'B01001I_030E', 'B01001I_031E']
            df['65OVERHISPFEMALE'] = df[cols].sum(axis=1)
            
            df['YEAR'] = df['YEAR'].apply(pd.to_numeric)

            cols = ['YEAR', 'NAME', '18TO24HISPMALE', '18TO24HISPFEMALE',
                    '25TO44HISPMALE', '25TO44HISPFEMALE', '45TO64HISPMALE',
                    '45TO64HISPFEMALE', '65OVERHISPMALE', '65OVERHISPFEMALE',
                    '18TO24WHITEMALE', '18TO24WHITEFEMALE', '25TO44WHITEMALE',
                    '25TO44WHITEFEMALE', '45TO64WHITEMALE', '45TO64WHITEFEMALE',
                    '65OVERWHITEMALE', '65OVERWHITEFEMALE', '18TO24BLACKMALE',
                    '18TO24BLACKFEMALE', '18TO24NATIVEMALE', '18TO24NATIVEFEMALE',
                    '18TO24ASIANMALE', '18TO24ASIANFEMALE', '18TO24APIMALE',
                    '18TO24APIFEMALE', '18TO24MULTIMALE', '18TO24MULTIFEMALE',
                    '25TO44BLACKMALE', '25TO44BLACKFEMALE', '25TO44NATIVEMALE',
                    '25TO44NATIVEFEMALE', '25TO44ASIANMALE', '25TO44ASIANFEMALE',
                    '25TO44APIMALE', '25TO44APIFEMALE', '25TO44MULTIMALE',
                    '25TO44MULTIFEMALE', '45TO64BLACKMALE', '45TO64BLACKFEMALE',
                    '45TO64NATIVEMALE', '45TO64NATIVEFEMALE', '45TO64ASIANMALE',
                    '45TO64ASIANFEMALE', '45TO64APIMALE', '45TO64APIFEMALE',
                    '45TO64MULTIMALE', '45TO64MULTIFEMALE', '65OVERBLACKMALE',
                    '65OVERBLACKFEMALE', '65OVERNATIVEMALE', '65OVERNATIVEFEMALE',
                    '65OVERASIANMALE', '65OVERASIANFEMALE', '65OVERAPIMALE',
                    '65OVERAPIFEMALE', '65OVERMULTIMALE', '65OVERMULTIFEMALE']

            df = df[cols]

        return df

    def projection(self, df):
        years = [2016, 2020, 2022, 2024]
        cols = ['18TO24HISPMALE', '25TO44HISPMALE', '45TO64HISPMALE',
                '65OVERHISPMALE', '18TO24HISPFEMALE', '25TO44HISPFEMALE',
                '45TO64HISPFEMALE', '65OVERHISPFEMALE', '18TO24WHITEMALE',
                '25TO44WHITEMALE', '45TO64WHITEMALE', '65OVERWHITEMALE',
                '18TO24WHITEFEMALE', '25TO44WHITEFEMALE', '45TO64WHITEFEMALE',
                '65OVERWHITEFEMALE', '18TO24BLACKMALE', '25TO44BLACKMALE',
                '45TO64BLACKMALE', '65OVERBLACKMALE', '18TO24NATIVEMALE',
                '25TO44NATIVEMALE', '45TO64NATIVEMALE', '65OVERNATIVEMALE',
                '18TO24ASIANMALE', '25TO44ASIANMALE', '45TO64ASIANMALE',
                '65OVERASIANMALE', '18TO24APIMALE', '25TO44APIMALE',
                '45TO64APIMALE', '65OVERAPIMALE', '18TO24MULTIMALE',
                '25TO44MULTIMALE', '45TO64MULTIMALE', '65OVERMULTIMALE',
                '18TO24BLACKFEMALE', '25TO44BLACKFEMALE', '45TO64BLACKFEMALE',
                '65OVERBLACKFEMALE', '18TO24NATIVEFEMALE',
                '25TO44NATIVEFEMALE', '45TO64NATIVEFEMALE',
                '65OVERNATIVEFEMALE', '18TO24ASIANFEMALE',
                '25TO44ASIANFEMALE', '45TO64ASIANFEMALE', '65OVERASIANFEMALE',
                '18TO24APIFEMALE', '25TO44APIFEMALE', '45TO64APIFEMALE',
                '65OVERAPIFEMALE', '18TO24MULTIFEMALE', '25TO44MULTIFEMALE',
                '45TO64MULTIFEMALE', '65OVERMULTIFEMALE']

        df2 = self.pull(2022)
        df2 = df2[df2['YEAR'].isin(years)].reset_index(drop=True)

        df2[cols] = df2[cols].apply(pd.to_numeric)
        df2[cols] = df2[cols].pct_change()

        df2.fillna(0, inplace=True)
        df2[cols] = df2[cols].add(1)

        df = df.append(df2)
        df[cols] = df[cols].cumprod()
        df[cols] = df[cols].round(0)
        df['NAME'].fillna(method='ffill', inplace=True)
        df.reset_index(inplace=True, drop=True)
        df = df[1:]

        return df

    def compile_census(self):
        self.df = self.df.append(self.pull(year=2000))
        for y in range(2010, 2016):
            self.df = self.df.append(self.pull(year=y))
        proj = self.projection(self.pull(year=2016))
        self.df = self.df.append(proj)
        for y in range(2017, 2020):
            self.df = self.df.append(self.pull(year=y))
        cong = [2006, 2008, 2010, 2012, 2014, 2018]
        for y in cong:
            self.df = self.df.append(self.pull(year=y, geolevel='congress'))
        df = self.pull(year=2016, geolevel='congress')
        for n in df['NAME'].unique():
            df2 = df[df['NAME'] == n]
            self.df = self.df.append(self.projection(df2))

    def ratio(self, level=1):
        df = self.df
        lst1 = ['18TO24', '25TO44', '45TO64', '65OVER']
        lst2 = ['HISP', 'WHITE', 'BLACK', 'ASIAN', 'API', 'MULTI', 'NATIVE']
        cols = ['YEAR', 'NAME']
        
        if level == 1:
            for k in lst2:
                df['{}'.format(k)] = df.filter(like=k).sum(axis=1)
                cols.append('{}'.format(k))
                df['{}MFR'.format(k)] = df.filter(like='{}MALE'.format(k)).sum(axis=1)\
                                                / df.filter(like='{}FEMALE'.format(k)).sum(axis=1)
                cols.append('{}MFR'.format(k))
        
        if level == 2:
            for k in lst1:
                for v in lst2:
                    df['{}{}'.format(k,v)] = df['{}{}MALE'.format(k,v)]\
                                             + df['{}{}FEMALE'.format(k,v)]
                    cols.append('{}{}'.format(k,v))
                    df['{}{}MFR'.format(k,v)] = df['{}{}MALE'.format(k,v)]\
                                                / df['{}{}FEMALE'.format(k,v)]
                    cols.append('{}{}MFR'.format(k,v))

        return df[cols]


