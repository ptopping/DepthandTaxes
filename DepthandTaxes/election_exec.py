import cx_Oracle
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
# import geopandas as gpd
from DepthandTaxes.tools import dattools
# from DepthandTaxes.tools import census

class ElectionData(object):
    """docstring for ElectionData"""
    def __init__(self, con):
        self.con = con
        self.url = 'https://api.census.gov/data/2010/dec/sf1?get=P001001,'\
                   'NAME,DIVISION&for=state:*'
        self.df = pd.read_json(self.url)
        self.df.columns = self.df.loc[0]
        self.df = self.df.drop(0)
        self.year_code_list_2010 = ['1', '5', '7', '9', '11', '12']
        self.data = None
    
    def load_results(self):
        df = pd.DataFrame()
        elec_list = ['2000', '2002', '2004', '2006', '2008', '2010', '2012',
                     '2014', '2016', '2018']

        for v in elec_list:
            file = open('..\\DepthandTaxes\\DepthandTaxes\\politics_'\
                        '{}_election.sql'.format(v), 'r')
            sql_string = file.read()
            df2 = pd.read_sql(sql=sql_string, con=self.con)
            df = df.append(df2)
        
        df.rename(columns={'GENERALDATE':'YEAR'}, inplace=True)
        df['YEAR'] = df['YEAR'].dt.year
        
        self.results_df = df

    def census_pull(self, date_code=None, year=2000):
        race_list = ['1', '2', '3', '4', '5', '6']
        hisp_dict = {'1':'Non-Hispanic', '2':'Hispanic'}
        race_dict = {'1':'White', '2':'Black',
                     '3':'American Indian and Alaska Native', '4':'Asian',
                     '5':'"Native Hawaiian and Other Pacific Islander',
                     '6':'Two or more races'}
        div_dict = {'1':'New England', '2':'Middle Atlantic',
                    '3':'East North Central', '4':'West North Central',
                    '5':'South Atlantic', '6':'East South Central',
                    '7':'West South Central', '8':'Mountain', '9':'Pacific'}

        if year == 2000:
            year_code_list = ['1', '4', '6', '8', '10']
            url = 'https://api.census.gov/data/2000/pep/int_charagegroups?'\
                  + 'get=DATE_,DATE_DESC,DIVISION,GEONAME,HISP,POP,RACE,SEX'\
                  + '&for=state:*&AGEGROUP=22'
            df = pd.read_json(url)
            df.columns = df.loc[0]
            df = df.drop(0)
            df.rename(columns={'GEONAME':'NAME'}, inplace=True)

            url2 = 'https://api.census.gov/data/2000/pep/int_charagegroups?'\
                   + 'get=DATE_,DATE_DESC,DIVISION,GEONAME,HISP,POP,RACE,SEX'\
                   + '&for=state:*&AGEGROUP=26'
            df2 = pd.read_json(url2)
            df2.columns = df2.loc[0]
            df2 = df2.drop(0)
            df2.rename(columns={'GEONAME':'NAME'}, inplace=True)

            df = df.append(df2)
        
            df = df[(df['DATE_'].isin(year_code_list))\
                    & (df['HISP'] != '0')\
                    & (df['RACE'].isin(race_list))\
                    & (df['SEX'] == '0')]

            df['POP'] = df['POP'].apply(pd.to_numeric)
            df['DATE_DESC'] = df['DATE_DESC'].str.extract(r'([0-9\/]+)')
            df['DATE_DESC'] = df['DATE_DESC'].apply(pd.to_datetime)
        
        if year == 2010:
            url = 'https://api.census.gov/data/2019/pep/charagegroups'\
                  + '?get=DATE_DESC,NAME,POP,RACE&for=state:*'\
                  + '&DATE_CODE={}&AGEGROUP=22&AGEGROUP=26'.format(date_code)\
                  + '&HISP!=0&SEX=0'
            df = pd.read_json(url)
            df.columns = df.loc[0]
            df = df.drop(0)

            df = df[df['RACE'].isin(race_list)]
            df['POP'] = df['POP'].apply(pd.to_numeric)
            df['DATE_DESC'] = df['DATE_DESC'].str.extract(r'([0-9\/]+)')
            df['DATE_DESC'] = df['DATE_DESC'].apply(pd.to_datetime)

            df2 = self.df[['NAME','DIVISION']]
            df = df.merge(df2, left_on='NAME', right_on='NAME')

        df['HISP'] = df['HISP'].map(hisp_dict)
        df['RACE'] = df['RACE'].map(race_dict)
        df['DIVISION'] = df['DIVISION'].map(div_dict)
        
        df = df.groupby(['DATE_DESC', 'DIVISION', 'NAME', 'HISP','RACE'])\
               .sum()
        df = df.unstack()\
               .unstack()

        df.columns = df.columns.map(''.join).str.strip()
        df = df.reset_index()
        return df

    def compile_census(self):
        df = pd.DataFrame()
        df = df.append(self.census_pull(year=2000))
        for v in self.year_code_list_2010:
            df = df.append(self.census_pull(date_code=v, year=2010))

        df.rename(columns={'DATE_DESC':'YEAR', 'NAME':'STATENAME'},
                  inplace=True)
        df['YEAR'] = df['YEAR'].dt.year

        self.census_df = df

    def merge_df(self):
        merge_cols = ['STATENAME', 'YEAR']
        df = self.results_df.merge(self.census_df, left_on=merge_cols,
                                   right_on=merge_cols)
        df.columns = df.columns.str.upper()
        df.columns = df.columns.str.replace('POP', '')
        df.columns = df.columns.str.replace(' ', '')
        df.columns = df.columns.str.replace('"', '')

        df = df[['DEMPRES', 'DISTRICT', 'GENERALVOTES', 'INCUMBENTINDICATOR',
                 'MIDTERM', 'YEAR', 'DIVISION', 'PARTYNAME',
                 'NATIVEHAWAIIANANDOTHERPACIFICISLANDERHISPANIC',
                 'NATIVEHAWAIIANANDOTHERPACIFICISLANDERNON-HISPANIC',
                 'AMERICANINDIANANDALASKANATIVEHISPANIC',
                 'AMERICANINDIANANDALASKANATIVENON-HISPANIC', 'ASIANHISPANIC',
                 'ASIANNON-HISPANIC', 'BLACKHISPANIC', 'BLACKNON-HISPANIC',
                 'TWOORMORERACESHISPANIC', 'TWOORMORERACESNON-HISPANIC',
                 'WHITEHISPANIC', 'WHITENON-HISPANIC']]
        self.data = df
# census2000 = census.CensusLoad('st-est00int-alldata',kind='group').pretty()
# census2010 = census.CensusLoad('sc-est2017-alldata6').projection()
# df = pd.concat([census2000, census2010],sort=True)
# df.columns = df.columns.str.upper()
# df.drop_duplicates(inplace=True)

# df = df.merge(results.GlobalVariables().df, how='left', left_on='YEAR', right_on='YEAR')
# df.drop(columns=0,inplace=True)

# presge2000 = results.FECLoad('presge',2000).pretty()
# presprim2000 = results.FECLoad('presprim',2000,is_primary=True).pretty()
# pres2000 = presge2000.merge(presprim2000, how='outer', left_on= ['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'], 
# 		right_on=['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'])
# sen2000 = results.FECLoad('senate',2000,is_pres=False).pretty()
# house2000 = results.FECLoad('house',2000,is_pres=False,is_house=True).pretty()
# results2000 = pd.concat([pres2000, sen2000, house2000], sort=True)
# results2002 = results.FECLoad('2002fedresults',2002).pretty()
# results2004 = results.FECLoad('federalelections2004',2004).pretty()
# results2006 = results.FECLoad('federalelections2006',2006).pretty()
# results2008 = results.FECLoad('federalelections2008',2008).pretty()
# results2010 = results.FECLoad('federalelections2010',2010).pretty()
# results2012 = results.FECLoad('federalelections2012',2012).pretty()
# results2014 = results.FECLoad('federalelections2014',2014).pretty()
# results2016 = results.FECLoad('federalelections2016',2016).pretty()
# resultsall = pd.concat([results2000,results2002,results2004,results2006,results2008,results2010,results2012,results2014,results2016],sort=True)
# resultsall = results.ElectionAnalytics(resultsall).pretty()

# df = df.merge(resultsall, how='left', left_on=['YEAR','STATE','PARTY','DISTRICT'], right_on=['YEAR','STATE','PARTY','DISTRICT'])

# sns.set_style('darkgrid')
# sns.set_palette('seismic',7)
# political_pal = {'Democratic' : 'C0', 'Republican': 'C6', 'Other': 'g'}

# data = results.AllData(df).response()
# g = sns.FacetGrid(data=data, col='Party', col_wrap=3, sharex=False, sharey=False, hue='Party', palette=political_pal)
# g = g.map(plt.hist, 'Log10(Votes)')
# g.savefig('..\\DATFiles\\pres_uni_response.png')

# sns.set_palette('tab10')
# data = results.AllData(df).cont_var()
# g = sns.FacetGrid(data=data, col='Race', col_wrap=4, sharex=False, sharey=False)
# g = g.map(plt.hist, 'LOG10(Population)')
# g.savefig('..\\DATFiles\\pres_uni_continuous.png')

# data = results.AllData(df).cat_var()
# g = sns.catplot(data=data, x='Division', kind='count', aspect=1.25)
# g.set_xticklabels(rotation=45)
# g.savefig('..\\DATFiles\\pres_uni_categorical.png')

# sns.set_palette('seismic',7)
# data = results.AllData(df).cont_var()
# g = sns.relplot(data=data, col='Party', row='Race', hue='Party', palette=political_pal, x='LOG10(Population)', y='Log10(Votes)')
# g.savefig('..\\DATFiles\\pres_bi_continuous.png')

# sns.set_palette('tab10')
# data = results.AllData(df).train
# data = data[['ASIAN', 'BLACK', 'HAWAIIAN', 'HISPANIC', 'MULTI', 'NATIVE', 'WHITE']]
# data.drop_duplicates(inplace=True)
# data = data.apply(np.log10)
# data.columns = data.columns.str.title()
# g = sns.PairGrid(data)
# g = g.map(plt.scatter, edgecolor="w")
# g.savefig('..\\DATFiles\\corrmatrix.png')
# g2 = sns.FacetGrid(data)
# g2.axes = sns.heatmap(data.corr(), annot=True, annot_kws = {'fontsize': 'small'}, cmap='Blues')
# g2.savefig('..\\DATFiles\\correlations.png')

# sns.set_palette('seismic',7)
# data = results.AllData(df).cat_var()
# g = sns.catplot(data=data, x='Party', y='Log10(Votes)', hue='Party', col='Division', kind='box', col_wrap=3, palette=political_pal)
# g.savefig('..\\DATFiles\\pres_bi_categorical.png')

# data = results.AllData(df).regression(output='fit')
# data.to_html()

# data = results.AllData(df).residuals()
# g = sns.FacetGrid(data, col='Party', hue='Party', palette=political_pal, sharex=False, sharey=False)
# g = g.map(plt.scatter, 'Prelog10(Votes)', 'Residual', edgecolor='w')
# g.savefig('..\\DATFiles\\pres_residuals.png')

# data = results.AllData(df).regression(output='dataframe')
# data = data[['YEAR', 'STATE', 'PARTY', 'ACTUAL VOTES', 'PREDICTED VOTES']].set_index(['YEAR','STATE','PARTY']).unstack().reset_index()

# df1 = data[['YEAR', 'STATE', 'PARTY', 'ACTUAL VOTES', 'PREDICTED VOTES']].set_index(['YEAR','STATE','PARTY']).unstack()
# df1.loc[:,('ACTUAL LEAN','Democratic')] = df1['ACTUAL VOTES','Democratic'] - df1['ACTUAL VOTES','Republican']
# # df1.loc[(df1['ACTUAL VOTES','Democratic'] > df1['ACTUAL VOTES','Republican']),('ACTUAL WINNER','Democratic')] = 1
# df1.loc[:,('PREDICTED LEAN','Democratic')] = df1['PREDICTED VOTES','Democratic'] - df1['PREDICTED VOTES','Republican']
# # df1.loc[(df1['PREDICTED VOTES','Democratic'] > df1['PREDICTED VOTES','Republican']),('PREDICTED WINNER','Democratic')] = 1
# # df1 = df1[['YEAR','STATE','ACTUAL WINNER','PREDICTED WINNER']]
# # df1.loc[:,('LEAN DEM (PREDICTED)')] = df1['PREDICTED VOTES','Democratic'] - df1['PREDICTED VOTES','Republican']
# # df1.reset_index(drop=True)
# df1 = df1.stack().reset_index()
# df1.describe()
# states = gdp.read_file('..\\DATFiles\\tl_2018_us_state.shp')
# df1 = states.merge(df1[df1['PARTY']=='Democratic'], how='left', left_on='NAME', right_on='STATE')
# year = 2016
# united = df1[(df1['NAME']!='Alaska') & (df1['NAME']!='Hawaii') & (df1['YEAR']==year)]
# alaska = df1[(df1['NAME']=='Alaska') & (df1['YEAR']==year)]
# hawaii = df1[(df1['NAME']=='Hawaii') & (df1['YEAR']==year)]
# # united.sort_values('NAME')
# sns.set_style('white')
# # g = sns.FacetGrid(states)
# fig = plt.figure(constrained_layout=True,figsize=(10,4))
# gs = fig.add_gridspec(3, 3)
# ax1 = fig.add_subplot(gs[:,1:4])
# ax2 = fig.add_subplot(gs[0, 0])
# ax3 = fig.add_subplot(gs[1,0])

# # ax1 = plt.subplot(gs[:,1:4])
# ax1.axis('off')
# # ax2 = plt.subplot(gs[0, 0])
# ax2.axis('off')
# # ax3 = plt.subplot(gs[1, 0])
# ax3.axis('off')

# united.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax1, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# alaska.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax2, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# hawaii.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax3, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')

# ax2.set_xlim(right=-120)
# # ax.axis('off')
# # fig, ax = plt.subplots(1,figsize=(10,6))
# # united.plot(cmap='seismic_r', column=('PREDICTED LEAN'),ax=ax[1,0], vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# # ax.axis('off')
# # fig.colorbar(united)
# # united.plot(cmap='seismic_r', column=('PREDICTED LEAN'), ax=ax[0,1])
# # fig.colorbar('seismic')

