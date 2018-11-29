import pandas as pd
import seaborn as sns
import numpy as np
from scipy import stats
from math import sqrt
from statsmodels.tsa.stattools import acf
from matplotlib import pyplot as plt
sns.set_style('white')

elechis_df = pd.read_excel('C:\\Users\\jen\\Documents\\Patrick\\exit polls.xlsx',sheet_name='Sheet1')
elechis_df

roper = elechis_df[elechis_df['Source'] == 'Roper']
roper

sns.despine(left=True)
roperplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Race',data=roper,col='Party')
roperplot.savefig('elec10141801.png')

gallup = elechis_df[elechis_df['Source'] == 'Gallup']
gallup

gallupplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Race',data=gallup,col='Party')
gallupplot.savefig('elec10141802.png')

roper_trunc = roper[(roper['Year'] >= 1980) & (roper['Race'] == 'White')]
gallup_trunc = gallup[(gallup['Year'] <= 1996)]
merged_sample = roper_trunc.append(gallup_trunc)
merged_sample = merged_sample.append(r9.reset_index(drop=True))
mergeplot = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Source',data=merged_sample,col='Party')
mergeplot.savefig('elec10261803.png')
merged_sample

roper_race_samp = roper[(roper['Race'] == 'White') | (roper['Race'] == 'African-American') | (roper['Race'] == 'Hispanic')]
raceplot = sns.lmplot(x='Year',y='Vote Pct.',hue='Race',col='Party',data=roper_race_samp)
raceplot.savefig('elec10141804.png')

raceplot2 = sns.lmplot(x='Year',y='Vote Pct.',hue='Race',col='Party',data=roper_trunc)
raceplot2.savefig('elec10141805.png')

raceplot3 = sns.relplot(x='Year',y='Vote Pct.',kind='line',hue='Race',style='Race',data=roper_trunc,col='Party')
raceplot3.savefig('elec10141806.png')

sns.set_style('whitegrid')
fig, axs = plt.subplots(1,3,sharey = True,figsize=(12,4))
plt.xticks([1,2,3,4,5])
#sns.barplot(x=results_df.index,y=results_df['HispanicDem'],data=results_df,color='red')
g1 = axs[0].bar(results_df.index,results_df['WhiteRep'])
g2 = axs[1].bar(results_df.index,results_df['BlackRep'],color='C1')
g3 = axs[2].bar(results_df.index,results_df['HispanicRep'],color='C2')
axs[0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].set_xlim(.5,5.5)
axs[0].set_xticks([1,2,3,4,5])
axs[0].set_xlabel('White')
axs[1].set_xlim(.5,5.5)
axs[1].set_xticks([1,2,3,4,5])
axs[1].set_xlabel('African American')
axs[2].set_xlim(.5,5.5)
axs[2].set_xticks([1,2,3,4,5])
axs[2].set_xlabel('Hispanic')
plt.ylim(-1,1)
#plt.setp(plt.xticks(), (1,2,3,4,5))
fig.suptitle('Republican Correlogram')
plt.savefig('repcorr.png')

sns.set_style('whitegrid')
fig, axs = plt.subplots(1,3,sharey = True,figsize=(12,4))
sns.set_palette('default')
#sns.barplot(x=results_df.index,y=results_df['HispanicDem'],data=results_df,color='red')
g1 = axs[0].bar(results_df.index,results_df['WhiteDem'])
g2 = axs[1].bar(results_df.index,results_df['BlackDem'],color='C1')
g3 = axs[2].bar(results_df.index,results_df['HispanicDem'],color='C2')
axs[0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].set_xlim(.5,5.5)
axs[0].set_xticks([1,2,3,4,5])
axs[0].set_xlabel('White')
axs[1].set_xlim(.5,5.5)
axs[1].set_xticks([1,2,3,4,5])
axs[1].set_xlabel('African American')
axs[2].set_xlim(.5,5.5)
axs[2].set_xticks([1,2,3,4,5])
axs[2].set_xlabel('Hispanic')
plt.ylim(-1,1)
#plt.setp(plt.xticks(), (1,2,3,4,5))
fig.suptitle('Democratic Correlogram')
#plt.savefig('demcorr.png')

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
r9

roper_race_samp = roper[(roper['Race'] == 'White') | (roper['Race'] == 'African-American') | (roper['Race'] == 'Hispanic')]
roper_race_samp

results = {}
nlags=6
whiterep = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Republican')]
blackrep = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Republican')]
hispanicrep = roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Republican')]
whitedem = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Democratic')]
blackdem = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Democratic')]
hispanicdem =roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Democratic')]
results['WhiteRep'] = [acf_by_hand(whiterep['Vote Pct.'], lag) for lag in range(nlags)]
results['BlackRep'] = [acf_by_hand(blackrep['Vote Pct.'], lag) for lag in range(nlags)]
results['HispanicRep'] = [acf_by_hand(hispanicrep['Vote Pct.'], lag) for lag in range(nlags)]
results['WhiteDem'] = [acf_by_hand(whitedem['Vote Pct.'], lag) for lag in range(nlags)]
results['BlackDem'] = [acf_by_hand(blackdem['Vote Pct.'], lag) for lag in range(nlags)]
results['HispanicDem'] = [acf_by_hand(hispanicdem['Vote Pct.'], lag) for lag in range(nlags)]
results_df = pd.DataFrame(results)
results_df
#sns.barplot(x=results_df.index,y=results_df['WhiteRep'],data=results_df,color='red')
#stats.ttest_1samp(results['WhiteRep'][1:],0)

samplemean = results_df.BlackDem
tstat = stats.ttest_1samp(results['BlackDem'][1:],0)[0]
samplestd = results_df.BlackDem.std()
n = results_df.BlackDem.count()
[0 + tstat * (samplestd/sqrt(n)), 0 - tstat * (samplestd/sqrt(n))]

statsmodels.graphics.tsaplots.plot_acf(blackdem['Vote Pct.'],unbiased=True,zero=False)

plt.acorr(blackdem['Vote Pct.'],maxlags=None)

statsmodels.tsa.stattools.acf(blackdem['Vote Pct.'],unbiased=True)

blackdem['Vote Pct.'].autocorr(2)

plt.xcorr(x=blackdem['Vote Pct.'][1:],y=blackdem['Vote Pct.'].shift()[1:],maxlags=None)

blackdem['Vote Pct.'].shift()

def acf_by_hand(x, lag):
    # Slice the relevant subseries based on the lag
    y1 = x[:(len(x)-lag)]
    y2 = x[lag:]
    # Subtract the mean of the whole series x to calculate Cov
    sum_product = np.sum((y1-np.mean(x))*(y2-np.mean(x)))
    # Normalize with var of whole series
    return sum_product / ((len(x) - lag) * np.var(x))

    def acf(Y,k):
        #Calculate the numerator
        lagged_val = Y.shift(k)

Y = blackdem['Vote Pct.']

blackdem['lagged_val'] = blackdem['Vote Pct.'].shift(1)
blackdem

((Y.shift(1)-Y.mean())*(Y-Y.mean())).sum()

((Y-Y.mean())**2).sum()

((Y.shift(3)-Y.mean())*(Y-Y.mean())).sum()/((Y[2:]-Y.mean())**2).sum()

blackdem['Vote Pct.'].autocorr(1)/(1/sqrt(len(blackdem['Vote Pct.'])-1))

2/sqrt(len(blackdem['Vote Pct.']))

results = {}
whiterep = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Republican')]
blackrep = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Republican')]
hispanicrep = roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Republican')]
whitedem = roper[(roper['Race'] == 'White') & (roper['Party'] == 'Democratic')]
blackdem = roper[(roper['Race'] == 'African-American') & (roper['Party'] == 'Democratic')]
hispanicdem =roper[(roper['Race'] == 'Hispanic') & (roper['Party'] == 'Democratic')]
results['WhiteRep'] = acf(whiterep['Vote Pct.'],unbiased=True)
results['BlackRep'] = acf(blackrep['Vote Pct.'],unbiased=True)
results['HispanicRep'] = acf(hispanicrep['Vote Pct.'],unbiased=True)
results['WhiteDem'] = acf(whitedem['Vote Pct.'],unbiased=True)
results['BlackDem'] = acf(blackdem['Vote Pct.'],unbiased=True)
results['HispanicDem'] = acf(hispanicdem['Vote Pct.'],unbiased=True)
results_df = pd.DataFrame(results)
results_df

sns.set_style('whitegrid')
fig, axs = plt.subplots(1,3,sharey = True,figsize=(12,4))
plt.xticks([1,2,3,4,5])
#sns.barplot(x=results_df.index,y=results_df['HispanicDem'],data=results_df,color='red')
g1 = axs[0].bar(results_df.index,results_df['WhiteRep'])
g2 = axs[1].bar(results_df.index,results_df['BlackRep'],color='C1')
g3 = axs[2].bar(results_df.index,results_df['HispanicRep'],color='C2')
axs[0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].set_xlim(.5,5.5)
axs[0].set_xticks([1,2,3,4,5])
axs[0].set_xlabel('White')
axs[1].set_xlim(.5,5.5)
axs[1].set_xticks([1,2,3,4,5])
axs[1].set_xlabel('African American')
axs[2].set_xlim(.5,5.5)
axs[2].set_xticks([1,2,3,4,5])
axs[2].set_xlabel('Hispanic')
plt.ylim(-1.5,1.5)
#plt.setp(plt.xticks(), (1,2,3,4,5))
fig.suptitle('Republican Correlogram')
plt.savefig('repcorr.png')

2/sqrt(len(results_df)-1)

sns.set_style('whitegrid')
fig, axs = plt.subplots(1,3,sharey = True,figsize=(12,4))
#plt.set_cmap('winter')
#sns.barplot(x=results_df.index,y=results_df['HispanicDem'],data=results_df,color='red')
g1 = axs[0].bar(results_df.index,results_df['WhiteDem'])
g2 = axs[1].bar(results_df.index,results_df['BlackDem'],color='C1')
g3 = axs[2].bar(results_df.index,results_df['HispanicDem'],color='C2')
axs[0].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[1].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[2].axhline(y=-2/sqrt(len(whiterep)-1),color='black',linestyle='dotted')
axs[0].set_xlim(.5,5.5)
axs[0].set_xticks([1,2,3,4,5])
axs[0].set_xlabel('White')
axs[1].set_xlim(.5,5.5)
axs[1].set_xticks([1,2,3,4,5])
axs[1].set_xlabel('African American')
axs[2].set_xlim(.5,5.5)
axs[2].set_xticks([1,2,3,4,5])
axs[2].set_xlabel('Hispanic')
plt.ylim(-1.5,1.5)
#plt.setp(plt.xticks(), (1,2,3,4,5))
fig.suptitle('Democratic Correlogram')


