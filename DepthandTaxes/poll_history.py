import pandas as pd
import seaborn as sns
import numpy as np
from scipy import stats
from math import sqrt
from statsmodels.tsa.stattools import acf
from matplotlib import pyplot as plt

sns.set_style('whitegrid')

elechis_df = pd.read_excel('C:\\Users\\ptopp\\Documents\\DATFiles\\exit polls.xlsx',sheet_name='Sheet1')
roper = elechis_df[elechis_df['Source'] == 'Roper']
gallup = elechis_df[elechis_df['Source'] == 'Gallup']

roperplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Race',data=roper,col='Party')
roperplot.despine(left=True)
roperplot.savefig('ropertimeseries.png')

gallupplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Race',data=gallup,col='Party')
gallupplot.despine(left=True)
gallupplot.savefig('galluptimeseries.png')

roper_trunc = roper[(roper['Year'] >= 1980) & (roper['Race'] == 'White')]
gallup_trunc = gallup[(gallup['Year'] <= 1996)]
merged_sample = roper_trunc.append(gallup_trunc)
merged_sample = merged_sample.append(r9.reset_index(drop=True))
mergeplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Source',data=merged_sample,col='Party')
mergeplot.savefig('elec10261803.png')
merged_sample

roper_race_samp = roper[(roper['Race'] == 'White') | (roper['Race'] == 'African-American') | (roper['Race'] == 'Hispanic')]
raceplot = sns.lmplot(x='Year',y='Vote Pct.',hue='Race',col='Party',data=roper_race_samp, scatter_kws={'edgecolors':'w'})
raceplot.despine(left=True)
raceplot.savefig('roper3racetimeseries.png')

whiterep = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Republican')]
blackrep = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Republican')]
hispanicrep = roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Republican')]
whitedem = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Democratic')]
blackdem = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Democratic')]
hispanicdem =roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Democratic')]
a_whiterep = {'acf': acf(whiterep['Vote Pct.'],unbiased=True), 'Race': 'White', 'Party': 'Republican'}
a_blackrep = {'acf':acf(blackrep['Vote Pct.'],unbiased=True), 'Race': 'African-American', 'Party': 'Republican'}
a_hispanicrep = {'acf': acf(hispanicrep['Vote Pct.'],unbiased=True), 'Race': 'Hispanic', 'Party': 'Republican'}
a_whitedem = {'acf': acf(whitedem['Vote Pct.'],unbiased=True), 'Race': 'White', 'Party': 'Democratic'}
a_blackdem = {'acf': acf(blackdem['Vote Pct.'],unbiased=True), 'Race': 'African-American', 'Party': 'Democratic'}
a_hispanicdem = {'acf': acf(hispanicdem['Vote Pct.'],unbiased=True), 'Race': 'Hispanic', 'Party': 'Democratic'}
results = [a_whiterep, a_blackrep, a_hispanicrep, a_whitedem, a_blackdem, a_hispanicdem]
results = [pd.DataFrame(d) for d in results]
results_df = pd.concat(results, sort=True).reset_index()

acfplot = sns.catplot(x='index', y='acf', data = results_df, col='Race', row='Party', kind='bar', ci=None, hue='Race', sharex=False, sharey=False)
acfplot.despine(left=True)
acfplot.axes[0,0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[0,0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[0,1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[0,1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[0,2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[0,2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
acfplot.axes[1,2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')

roper_race_trunc = roper_race_samp[roper_race_samp['Year'] >= 1980]
race_trunc_plot = sns.lmplot(x='Year',y='Vote Pct.',hue='Race',col='Party',data=roper_race_trunc, scatter_kws={'edgecolors':'w'})
race_trunc_plot.despine(left=True)
race_trunc_plot.savefig('roper3racetimeseriestrunc.png')

r1 = roper[roper['Race'] != 'White']
r1['inter'] = r1['Pct.'].multiply(r1['Vote Pct.'])
r2 = r1[r1['Party'] == 'Republican'].groupby('Year').sum()
r3 = r1.groupby('Year').sum()
r4 = r1.groupby(['Year','Party']).sum()
r5 = r4.merge(r3,left_index=True,right_index=True)
r5['Vote Pct.'] = r5['inter_x'] / r5['inter_y']
r5.rename(columns={'Pct._x' : 'Pct.'},inplace=True)
r5['Source'] = 'Roper'
r5['Race'] = 'Nonwhite'
r6 = r5[['Pct.','Vote Pct.','Source','Race']]
r7 = r6.xs('Democratic',level='Party')
r7['Party'] = 'Democratic'
r8 = r6.xs('Republican',level='Party')
r8['Party'] = 'Republican'
r9 = r7.append(r8)
r9 = r9.reset_index()
roper_trunc = roper[(roper['Year'] >= 1980) & (roper['Race'] == 'White')]
gallup_trunc = gallup[(gallup['Year'] <= 1996)]
merged_sample = roper_trunc.append(gallup_trunc)
merged_sample = merged_sample.append(r9.reset_index(drop=True))
mergeplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Source',data=merged_sample,col='Party')
mergeplot.despine(left=True)
mergeplot.savefig('combinedtimeseries.png')

var = pd.DataFrame({'Party':['Democratic','Democratic','Democratic','Republican','Republican','Republican'],'Race':['White','African-American','Hispanic','White','African-American','Hispanic'],
	'Stand Dev':[whitedem['Vote Pct.'].std(),blackdem['Vote Pct.'].std(),hispanicdem['Vote Pct.'].std(),whiterep['Vote Pct.'].std(),blackrep['Vote Pct.'].std(),hispanicrep['Vote Pct.'].std()]})
varplot = sns.catplot(x='Party',y='Stand Dev',data=var,kind='point',hue='Race')

roperplot_mean = sns.relplot(x='Year',y='Vote Pct.',kind='scatter',hue='Race',data=roper_race_samp,col='Party')
roperplot_mean.despine(left=True)
roperplot_mean.axes[0,0].axhline(y=whiterep['Vote Pct.'].mean(),color='C0',alpha=.8)
roperplot_mean.axes[0,0].axhline(y=blackrep['Vote Pct.'].mean(),color='C1',alpha=.8)
roperplot_mean.axes[0,0].axhline(y=hispanicrep['Vote Pct.'].mean(),color='C2',alpha=.8)
roperplot_mean.axes[0,1].axhline(y=whitedem['Vote Pct.'].mean(),color='C0',alpha=.8)
roperplot_mean.axes[0,1].axhline(y=blackdem['Vote Pct.'].mean(),color='C1',alpha=.8)
roperplot_mean.axes[0,1].axhline(y=hispanicdem['Vote Pct.'].mean(),color='C2',alpha=.8)
roperplot_mean.axes[0,1].fill([1976,2016,2016,1976],[.5,.5,.75,.75], 'C1', alpha=.5)