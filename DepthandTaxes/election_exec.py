import cx_Oracle
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
# import geopandas as gpd
# from DepthandTaxes.tools import results
# from DepthandTaxes.tools import census

url = 'https://api.census.gov/data/2019/pep/charage?get=AGE_DESC,DATE_CODE,'+
'DATE_DESC,NAME,POP&for=state:*&AGE!=999&HISP!=0&SEX=0&RACE=1&RACE=2&RACE=3'+
'&RACE=4&RACE=5&RACE=6'

df = pd.read_json(url)

df2 = df.copy()

df2.columns = df2.loc[0]
df2 = df2.drop(0)
df2['AGE'] = df2['AGE'].apply(pd.to_numeric)
df2['POP'] = df2['POP'].apply(pd.to_numeric)
df2['DATE_CODE'] = df2['DATE_CODE'].apply(pd.to_numeric)
df2['DATE_DESC'] = df2['DATE_DESC'].str.extract(r'([0-9\/]+)')
df2['DATE_DESC'] = df2['DATE_DESC'].apply(pd.to_datetime)
hisp_dict = {'1':'Non Hispanic', '2':'Hispanic'}
race_dict = {'1':'White', '2':'Black', '3':'American Indian and Alaska Native', '4':'Asian', '5':'"Native Hawaiian and Other Pacific Islander', '6':'Two or more races'}
df2['HISP'] = df2['HISP'].map(hisp_dict)
df2['RACE'] = df2['RACE'].map(race_dict)

df2[(df2['AGE'] >= 18) & (df2['DATE_CODE'] >= 3)].groupby(['DATE_DESC', 'NAME', 'HISP','RACE']).sum()


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

