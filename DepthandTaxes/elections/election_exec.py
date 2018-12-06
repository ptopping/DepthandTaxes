import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
from DepthandTaxes.elections import results
from DepthandTaxes.elections import census

census2000 = census.CensusLoad('st-est00int-alldata',kind='group').pretty()
census2010 = census.CensusLoad('sc-est2017-alldata6').projection()
df = pd.concat([census2000, census2010],sort=True)
df.columns = df.columns.str.upper()
df.drop_duplicates(inplace=True)

df = df.merge(results.GlobalVariables().df, how='left', left_on='YEAR', right_on='YEAR')
df.drop(columns=0,inplace=True)

presge2000 = results.FECLoad('presge',2000).pretty()
presprim2000 = results.FECLoad('presprim',2000,is_primary=True).pretty()
pres2000 = presge2000.merge(presprim2000, how='outer', left_on= ['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'], 
		right_on=['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'])
sen2000 = results.FECLoad('senate',2000,is_pres=False).pretty()
house2000 = results.FECLoad('house',2000,is_pres=False,is_house=True).pretty()
results2000 = pd.concat([pres2000, sen2000, house2000], sort=True)
results2002 = results.FECLoad('2002fedresults',2002).pretty()
results2004 = results.FECLoad('federalelections2004',2004).pretty()
results2006 = results.FECLoad('federalelections2006',2006).pretty()
results2008 = results.FECLoad('federalelections2008',2008).pretty()
results2010 = results.FECLoad('federalelections2010',2010).pretty()
results2012 = results.FECLoad('federalelections2012',2012).pretty()
results2014 = results.FECLoad('federalelections2014',2014).pretty()
results2016 = results.FECLoad('federalelections2016',2016).pretty()
resultsall = pd.concat([results2000,results2002,results2004,results2006,results2008,results2010,results2012,results2014,results2016],sort=True)
resultsall = results.ElectionAnalytics(resultsall).pretty()

df = df.merge(resultsall, how='left', left_on=['YEAR','STATE','PARTY','DISTRICT'], right_on=['YEAR','STATE','PARTY','DISTRICT'])

sns.set_style('darkgrid')
sns.set_palette('seismic',7)
political_pal = {'Democratic' : 'C0', 'Republican': 'C6', 'Other': 'g'}

data = results.AllData(df).response()
g = sns.FacetGrid(data=data, col='Party', col_wrap=3, sharex=False, sharey=False, hue='Party', palette=political_pal)
g = g.map(plt.hist, 'Log10(Votes)')
g.savefig('pres_uni_response.png')

sns.set_palette('tab10')
data = results.AllData(df).cont_var()
g = sns.FacetGrid(data=data, col='Race', col_wrap=4, sharex=False, sharey=False)
g = g.map(plt.hist, 'LOG10(Population)')
g.savefig('pres_uni_continuous.png')

data = results.AllData(df).cat_var()
g = sns.catplot(data=data, x='Division', kind='count', aspect=1.25)
g.set_xticklabels(rotation=45)
g.savefig('pres_uni_categorical.png')

sns.set_palette('seismic',7)
data = results.AllData(df).cont_var()
g = sns.relplot(data=data, col='Party', row='Race', hue='Party', palette=political_pal, x='LOG10(Population)', y='Log10(Votes)')
g.savefig('pres_bi_continuous.png')

sns.set_palette('tab10')
data = results.AllData(df).train
data = data[['ASIAN', 'BLACK', 'HAWAIIAN', 'HISPANIC', 'MULTI', 'NATIVE', 'WHITE']]
data.drop_duplicates(inplace=True)
data = data.apply(np.log10)
data.columns = data.columns.str.title()
g = sns.PairGrid(data)
g = g.map(plt.scatter)
g.savefig('corrmatrix.png')
data.corr().to_html() # .style.background_gradient()

sns.set_palette('seismic',7)
data = results.AllData(df).cat_var()
g = sns.catplot(data=data, x='Party', y='Log10(Votes)', hue='Party', col='Division', kind='box', col_wrap=3, palette=political_pal)
g.savefig('pres_bi_categorical.png')

data = results.AllData(df).regression(output='fit')
# data = data.style
data.to_html()

data = results.AllData(df).residuals()
g = sns.FacetGrid(data, col='Party', hue='Party', palette=political_pal, sharex=False, sharey=False)
g = g.map(plt.scatter, 'Prelog10(Votes)', 'Residual', edgecolor='w')
g.savefig('pres_residuals.png')
