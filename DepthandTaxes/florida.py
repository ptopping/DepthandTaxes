import pandas as pd
import seaborn as sns
import numpy as np
import statsmodels.api as sm
import matplotlib.pyplot as plt
from scipy import stats
from statsmodels.formula.api import ols

df_dict = pd.read_excel('..\\DATFiles\\2016general_partyrace.xlsx',sheet_name=None)
df_dict.keys()

sheet2 = df_dict.get('Sheet2')
results = df_dict.get('Results')
reg = df_dict.get('RegistrationByPartyRace')
#sheet2 = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
#sheet2 = sheet2.groupby('CountyName').sum().reset_index()
#sheet2['Total Mail'] = sheet2.iloc[:,3] + sheet2.iloc[:,4] 
#sheet2['Unreturned Pct.'] = sheet2.iloc[:,4] / sheet2.iloc[:,5]
#sheet2
#sns.barplot(x='variable',y='Unreturned Pct.',data=sheet2)
#results = df_dict.get('Results')
#results = results[results['OfficeDesc'] == 'President of the United States']
#results2 = results.groupby(['CountyName']).sum().reset_index()
#results = results.merge(results2,how='left',left_on='CountyName',right_on='CountyName')
#results['Vote Pct.'] = results['CanVotes_x'] / results['CanVotes_y']
#results = results[['CountyName','PartyName','Vote Pct.']]
#results = results[results['PartyName'] == 'Democrat']
#results.CountyName = results.CountyName.str.strip()
#sheet2.CountyName = sheet2.CountyName.str.strip()
#results = results.set_index('CountyName').join(sheet2.set_index('CountyName'))
#sns.set_style('darkgrid')
#sns.regplot('Unreturned Pct.','Vote Pct.',data=results)
#results
#registration = df_dict.get('RegistrationByPartyRace')
#registration['American Indiant Pct.'] = registration['American Indian or Alaskan Native'] / registration['Total']
#registration.groupby('CountyName').sum()
#      u'Asian Or Pacific Islander', u'Black, Not Hispanic', u'Hispanic',
#       u'White, Not Hispanic', u'Other', u'Multi-Racial'

df = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df.rename(columns={'variable' : 'PartyName'},inplace=True)
df = df[df['PartyName'] == 'TOTAL']
df['PctUnreturned'] = df.iloc[:,4] / (df.iloc[:,3] + df.iloc[:,4])
df.CountyName = df.CountyName.str.strip()
df2 = results[(results['OfficeDesc'] == 'President of the United States') & (results['PartyName'] == 'Democrat')].set_index('CountyName')
df3 = results[results['OfficeDesc'] == 'President of the United States'].groupby('CountyName').sum().rename(columns={'CanVotes':'TotVotes'})
df2 = df2.join(df3,how='left',lsuffix='_l',rsuffix='_r')
df2['ClintonPct'] = df2['CanVotes'] / df2['TotVotes']
df = df.set_index('CountyName').join(df2,how='left',lsuffix='_1',rsuffix='_r').reset_index()
data = df[['CountyName','PctUnreturned','ClintonPct']]
sns.set_style('darkgrid')
sns.scatterplot('ClintonPct','PctUnreturned',data=data)
g = stats.pearsonr(data['PctUnreturned'],data['ClintonPct'])
g[0]

df = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df.rename(columns={'variable' : 'PartyName'},inplace=True)
df = df[df['PartyName'] == 'TOTAL']
df.CountyName = df.CountyName.str.strip()
df['Early'] = df.select_dtypes(np.number).sum(axis=1)
df2 = reg
df2.CountyName = df2.CountyName.str.strip()
df2 = df2.groupby('CountyName').sum()
df = df.set_index('CountyName').join(df2,how='left')
df['Enthusiasm'] = df['Early'] / df['Total']
data = df['Enthusiasm']
sns.set_style('darkgrid')
sns.distplot(data,kde=False)
plt.annotate('Miami-Dade',xy=(.637908,9),xytext=(.65,15),arrowprops=dict(arrowstyle="->",color='black'))
plt.annotate('Broward',xy=(.596665,9),xytext=(.6,17.5),arrowprops=dict(arrowstyle="->",color='black'))
plt.show()

df = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df.rename(columns={'variable' : 'PartyName'},inplace=True)
df['UnreturnedPct'] = df.iloc[:,4] / (df.iloc[:,3] + df.iloc[:,4])
df.CountyName = df.CountyName.str.strip()
df = df[df['PartyName'] != 'TOTAL']
df = df[['UnreturnedPct','PartyName']]
model = ols('UnreturnedPct ~ C(PartyName)', data = df).fit()
#model.summary()
var = sm.stats.anova_lm(model,typ=2)
from statsmodels.stats.multicomp import pairwise_tukeyhsd
from statsmodels.stats.multicomp import MultiComparison
mc = MultiComparison(df['UnreturnedPct'], df['PartyName'])
mc_results = mc.tukeyhsd()
print(mc_results)
sns.set_style('darkgrid')
sns.boxplot(x='PartyName',y='UnreturnedPct',hue='PartyName',data=df)

df = reg
df.CountyName = df.CountyName.str.strip()
df.PartyName = df.PartyName.str.strip()
df.loc[(df['PartyName'] != 'Republican') & (df['PartyName'] != 'Democrat') & (df['PartyName'] != 'No Party Affiliation'), 'PartyName'] = 'Other'
df = df.groupby(['CountyName','PartyName']).sum()
df = df.sum(axis=0,level=0)
df['AmericanIndian'] = df.iloc[:,0] / df['Total']
df['Asian'] = df.iloc[:,1] / df['Total']
df['Black'] = df.iloc[:,2] / df['Total']
df['Hispanic'] = df.iloc[:,3] / df['Total']
df['White'] = df.iloc[:,4] / df['Total']
df['Other'] = df.iloc[:,5] / df['Total']
df['Multi'] = df.iloc[:,6] / df['Total']
df['Unknown'] = df.iloc[:,7] / df['Total']
df2 = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df2.rename(columns={'variable' : 'PartyName'},inplace=True)
df2 = df2[df2['PartyName'] == 'TOTAL']
df2['PctUnreturned'] = df2.iloc[:,4] / (df2.iloc[:,3] + df2.iloc[:,4])
df2.CountyName = df2.CountyName.str.strip()
df2 = df2.set_index('CountyName')
data = df.join(df2,how='left').reset_index()
data = data[['AmericanIndian','Asian','Black','Hispanic','White','Other','Multi','Unknown','PctUnreturned']]
plotdata = data.melt(id_vars='PctUnreturned').rename(columns={'variable':'Race','value':'RegisteredVoterPct'})
sns.set_style('darkgrid')
g = sns.FacetGrid(plotdata,col='Race',sharey=False,sharex=False,col_wrap=3)
g.map(plt.scatter,'RegisteredVoterPct','PctUnreturned')
col_list = ['AmericanIndian','Asian','Black','Hispanic','White','Other','Multi','Unknown']
col1 = [stats.pearsonr(data[x],data['PctUnreturned']) for x in col_list]
pd.DataFrame(col1,index=col_list)
#df[df['WhitePct'] <= .6]

df = reg
df.CountyName = df.CountyName.str.strip()
df.PartyName = df.PartyName.str.strip()
df.loc[(df['PartyName'] != 'Republican') & (df['PartyName'] != 'Democrat') & (df['PartyName'] != 'No Party Affiliation'), 'PartyName'] = 'Other'
df = df.groupby(['CountyName','PartyName']).sum()
df = df.sum(axis=0,level=0)
df['White'] = df.iloc[:,4] / df['Total']
df2 = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df2.rename(columns={'variable' : 'PartyName'},inplace=True)
df2 = df2[df2['PartyName'] == 'TOTAL']
df2['PctUnreturned'] = df2.iloc[:,4] / (df2.iloc[:,3] + df2.iloc[:,4])
df2.CountyName = df2.CountyName.str.strip()
df2 = df2.set_index('CountyName')
data = df.join(df2,how='left').reset_index()
data.loc[data['White'] > .6,'Favorite'] = 'Trump'
data.loc[data['White'] <= .6,'Favorite'] = 'Clinton'
mc = MultiComparison(data['PctUnreturned'], data['Favorite'])
mc_results = mc.tukeyhsd()
print(mc_results)
sns.set_style('darkgrid')
sns.boxplot(x='Favorite',y='PctUnreturned',hue='Favorite',data=data)

df = sheet2.melt(id_vars=['CountyName','EarlyVote']).pivot_table(index=['CountyName','variable'],columns='EarlyVote',values='value').reset_index()
df.rename(columns={'variable' : 'PartyName'},inplace=True)
df = df[df['PartyName'] == 'TOTAL']
df.CountyName = df.CountyName.str.strip()
df['Vote Requested'] = df.iloc[:,3] + df.iloc[:,4]
df1 = df[(df['CountyName'] != 'Broward') & (df['CountyName'] != 'Miami-Dade')]
df1.loc['SUM'] = df1.select_dtypes(np.number).sum()
df1['PctUnreturned'] = df1.iloc[:,4] / (df1.iloc[:,3] + df1.iloc[:,4])
df1
df2 = df[(df['CountyName'] == 'Broward') | (df['CountyName'] == 'Miami-Dade')]
df2['PctUnreturned'] = df2.iloc[:,4] / (df2.iloc[:,3] + df2.iloc[:,4])
df2.loc['SUM'] = df2.select_dtypes(np.number).sum()
df2
#df3 = df
#df3.loc['SUM'] = df1.select_dtypes(np.number).sum()
#df3.reset_index()
#df2.iloc[2,4]  /df3.iloc[67,4]
#df2.iloc[2,5] / df3.iloc[67,5]

