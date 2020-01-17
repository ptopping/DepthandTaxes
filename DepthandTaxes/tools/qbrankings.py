import cx_Oracle
from math import pi
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import scipy.stats as stats

# NFL color palette
colors = {
'primary' : ['#97233F', '#A71930', '#241773', '#00338D', '#0085CA', '#0B162A', '#FB4F14', '#311D00', '#041E42', '#FB4F14', '#0076B6', '#203731', '#03202F', 
'#002C5F', '#101820', '#E31837', '#002244', '#002A5E', '#008E97', '#4F2683', '#002244', '#D3BC8D', '#0B2265', '#125740', '#000000', '#004C54', '#FFB612', 
'#002244', '#AA0000', '#D50A0A', '#0C2340', '#773141'],
'secondary' : ['#000000', '#000000', '#000000', '#C60C30', '#101820', '#C83803', '#000000', '#FF3C00', '#869397', '#002244', '#B0B7BC', '#FFB612', '#A71930', 
'#A2AAAD', '#D7A22A', '#FFB81C', '#866D4B', '#FFC20E', '#FC4C02', '#FFC62F', '#C60C30', '#101820', '#A71930', '#000000', '#A5ACAF', '#A5ACAF', '#101820',
'#69BE28', '#B3995D', '#FF7900', '#418FDE', '#FFB612'],
'alt': ['#FFB612', '#A5ACAF', '#9E7C0C', '#C60C30', '#BFC0BF', '#C83803', '#000000', '#FFFFFF', '#FFFFFF', '#002244', '#000000', '#FFB612', '#A71930', 
'#A2AAAD', '#006778', '#FFB81C', '#FFFFFF', '#0080C6', '#005778', '#FFC62F', '#B0B7BC', '#101820', '#A5ACAF', '#FFF', '#A5ACAF', '#000000', '#003087', 
'#A5ACAF', '#B3995D', '#0A0A08', '#C8102E', '#FFB612']
}
index = ['ARI', 'ATL', 'BAL', 'BUF', 'CAR', 'CHI', 'CIN', 'CLE', 'DAL', 'DEN', 'DET', 'GB', 'HOU', 'IND', 'JAX', 'KC', 'LA', 'LAC', 'MIA', 'MIN', 'NE', 'NO', 
'NYG', 'NYJ', 'OAK', 'PHI', 'PIT', 'SEA', 'SF', 'TB', 'TEN', 'WAS']
color_df = pd.DataFrame(colors, index=index)
nfl_pal = color_df['primary'].to_dict()
secondary_pal = color_df['secondary'].to_dict()


class QBStats(object):
	def __init__(self,SQL,con):
		self.df = pd.read_sql(SQL, con = con)
		self.SQL = SQL
		self.con = con

	def score(self):
		'''Creates a DataFrame of Passer Rating Components and performs a z transform
		'''
		df = self.df
		df2 = df[['DISPLAYNAME', 'ABBREVIATION', 'PASSINGATTEMPTS','PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 
		'PASSINGYARDS']].groupby(['DISPLAYNAME', 'ABBREVIATION']).sum()
		df3 = df[['ABBREVIATION', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']].groupby('ABBREVIATION').sum()
		df4 = df[['GAMEID', 'ABBREVIATION','GAMESPLAYED']].drop_duplicates(subset=['GAMEID', 'ABBREVIATION']).groupby('ABBREVIATION').sum()
		
		df3 = df3.join(df4)
		df3.loc[:,'IntPct'] = 1 - df3.loc[:,'PASSINGINTERCEPTIONS']/df3.loc[:,'PASSINGATTEMPTS']
		df3[['CmpPct', 'YardsPer', 'TDPct']] = df3[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df3['PASSINGATTEMPTS'].values, axis=0)
		# df3.loc[:,'AttPer'] = df3.loc[:,'PASSINGATTEMPTS'] / df3.loc[:,'GAMESPLAYED']
		df3.loc[:,'CmpPct_mean'] = df3.CmpPct.mean()
		df3.loc[:,'CmpPct_std'] = df3.CmpPct.std()
		df3.loc[:,'YardsPer_mean'] = df3.YardsPer.mean()
		df3.loc[:,'YardsPer_std'] = df3.YardsPer.std()
		df3.loc[:,'TDPct_mean'] = df3.TDPct.mean()
		df3.loc[:,'TDPct_std'] = df3.TDPct.std()    
		df3.loc[:,'IntPct_mean'] = df3.IntPct.mean()
		df3.loc[:,'IntPct_std'] = df3.IntPct.std() 
		# df3.loc[:,'AttPer_mean'] = df3.AttPer.mean()
		# df3.loc[:,'AttPer_std'] = df3.AttPer.std()     
		# df3 = df3[['CmpPct_mean','CmpPct_std','YardsPer_mean','YardsPer_std','TDPct_mean','TDPct_std','IntPct_mean','IntPct_std', 'AttPer_mean','AttPer_std']]
		df3 = df3[['CmpPct_mean','CmpPct_std','YardsPer_mean','YardsPer_std','TDPct_mean','TDPct_std','IntPct_mean','IntPct_std']]

		df2 = df2.join(df4)
		df2 = df2.join(df3)
		df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
		df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)
		# df2.loc[:,'AttPer'] = df2.loc[:,'PASSINGATTEMPTS'] / df2.loc[:,'GAMESPLAYED']
		
		df2.loc[:,'z_CmpPct'] = (df2.loc[:,'CmpPct'] - df2.loc[:,'CmpPct_mean'])/df2.loc[:,'CmpPct_std']
		df2.loc[:,'z_YardsPer'] = (df2.loc[:,'YardsPer'] - df2.loc[:,'YardsPer_mean'])/df2.loc[:,'YardsPer_std']
		df2.loc[:,'z_TDPct'] = (df2.loc[:,'TDPct'] - df2.loc[:,'TDPct_mean'])/df2.loc[:,'TDPct_std']
		df2.loc[:,'z_IntPct'] = (df2.loc[:,'IntPct'] - df2.loc[:,'IntPct_mean'])/df2.loc[:,'IntPct_std']
		# df2.loc[:,'z_AttPer'] = (df2.loc[:,'AttPer'] - df2.loc[:,'AttPer_mean'])/df2.loc[:,'AttPer_std']
		df2 = df2.reset_index()
		df2.rename(columns={'DISPLAYNAME':'Name', 'ABBREVIATION':'Team'},inplace=True)
		df2 = df2[df2['PASSINGCOMPLETIONS']>=df2['GAMESPLAYED']*14]

		#  
		# df2['Above'] = (df2[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]>=1).sum(1)
		# df2['Below'] = (df2[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]<=-1).sum(1)
		df2['Above'] = (df2[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]>=1).sum(1)
		df2['Below'] = (df2[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]<=-1).sum(1)

		# Assign players to categories
		# df2.loc[df2['Above'] >= 4, 'Cat'] = 'GOAT'
		# df2.loc[df2['Below'] >= 4, 'Cat'] = 'Train'
		# df2.loc[(df2['Above'] == 0) & (df2['Below'] == 0), 'Cat'] = 'Mediocre'
		# df2.loc[(df2['Above'] >= 1) & (df2['Above'] < 4) & (df2['Below'] == 0), 'Cat'] = 'Good'
		# df2.loc[(df2['Above'] >= 1) & (df2['Below'] >= 1), 'Cat'] = 'Mixed'
		# df2.loc[(df2['Above'] == 0) & (df2['Below'] < 4) & (df2['Below'] >= 1), 'Cat'] = 'Bad'
		df2.loc[df2['Above'] == 4, 'Cat'] = 'GOAT'
		df2.loc[df2['Below'] == 4, 'Cat'] = 'Train'
		df2.loc[(df2['Above'] == 0) & (df2['Below'] == 0), 'Cat'] = 'Mediocre'
		df2.loc[(df2['Above'] >= 1) & (df2['Above'] < 4) & (df2['Below'] == 0), 'Cat'] = 'Good'
		df2.loc[(df2['Above'] >= 1) & (df2['Below'] >= 1), 'Cat'] = 'Mixed'
		df2.loc[(df2['Above'] == 0) & (df2['Below'] < 4) & (df2['Below'] >= 1), 'Cat'] = 'Bad'

		# Format result
		# df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']] = df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct',
		# 'z_AttPer']].apply(lambda x: stats.norm.cdf(x))

		# df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']] = df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct',
		# 'z_AttPer']].apply(lambda x: stats.norm.cdf(x))
		df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']] = df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']].apply(lambda x: stats.norm.cdf(x))

		# return df2[['Name','Team','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer','Cat']]
		return df2[['Name','Team','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','Cat']]

	def spider(self,category):
		'''Creates faceted radar charts for Standardized Passing statistics
		'''
		try:

			df = self.score()
			df = df[df['Cat'] == category]
			df.reset_index(drop=True,inplace=True)
			categories=list(df)[3:]
			N = len(categories)

			# What will be the angle of each axis in the plot? (we divide the plot / number of variable)
			angles = [n / float(N) * 2 * pi for n in range(N)]
			angles += angles[:1]

			df['Close'] = df['z_CmpPct']
			# Calculate the plot Area


			df1 = df.melt(id_vars=['Name','Tm','Cat'])

			map_loc = dict(zip(categories,angles))
			map_loc['Close'] = 0
			df1.variable = df1.variable.map(map_loc)
		    
			sns.set_style('whitegrid')

			g = sns.FacetGrid(df1, col='Name', hue="Tm", subplot_kws=dict(projection='polar'), col_wrap=3,
			sharex=False, sharey=False, despine=False, palette=nfl_pal)
			g = (g.map(plt.plot,'variable','value')).set(ylim = (-3,3), xticks = angles[:-1], rlabel_position = 45,
			theta_offset = (pi / 3), theta_direction = -1)
			g = g.map(plt.fill,'variable','value',alpha=.5).set_axis_labels('','')
			g = g.set_xticklabels(['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct','z_AttPer'])
			g = g.set_titles('{col_name}')
			plt.tight_layout()
			# g.savefig('{}{}.png'.format(sheet,category))

		except ValueError:
			pass

	def ratings_chart(self, year, week,category):
		try:
			df = self.score()
			df = df[df['Cat'] == category]
			df.reset_index(drop=True,inplace=True)	
			df = df.melt(id_vars=['Name','Team','Cat'])		
			g = sns.FacetGrid(data = df[df['Cat']==category],col='Name',col_wrap=3,sharex=False, sharey=False).set(xticks=[.16,.5,.84,]).despine(bottom=True)
			# g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=nfl_pal,dodge=False,order=['z_CmpPct',
			# 	'z_YardsPer','z_TDPct','z_IntPct','z_AttPer']).set(xticks=[.16,.5,.84,])
			# g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=secondary_pal,order=['z_CmpPct','z_YardsPer',
			# 	'z_TDPct','z_IntPct','z_AttPer']).set(xticks=[.16,.5,.84,])
			g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=nfl_pal,dodge=False,order=['z_CmpPct',
				'z_YardsPer','z_TDPct','z_IntPct']).set(xticks=[.16,.5,.84,])
			g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=secondary_pal,order=['z_CmpPct','z_YardsPer',
				'z_TDPct','z_IntPct']).set(xticks=[.16,.5,.84,])
			g.savefig('d:\\datfiles\\{}Week{}{}.png'.format(year,week,category))
		except ValueError:
			pass

	def ratings_chart(self, year, week,team):
		try:
			df = self.score()
			df = df[df['Team'] == team]
			df.reset_index(drop=True,inplace=True)	
			df = df.melt(id_vars=['Name','Team','Cat'])
			return df

		except ValueError:
			pass

			g = sns.FacetGrid(data = df,col='Name',col_wrap=3,sharex=False, sharey=False).set(xticks=[.16,.5,.84,]).despine(bottom=True)
			# g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=nfl_pal,dodge=False,order=['z_CmpPct',
			# 	'z_YardsPer','z_TDPct','z_IntPct','z_AttPer']).set(xticks=[.16,.5,.84,])
			# g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=secondary_pal,order=['z_CmpPct','z_YardsPer',
			# 	'z_TDPct','z_IntPct','z_AttPer']).set(xticks=[.16,.5,.84,])
			g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=nfl_pal,dodge=False,order=['z_CmpPct',
				'z_YardsPer','z_TDPct','z_IntPct']).set(xticks=[.16,.5,.84,])
			g = g.map(sns.barplot,'value','variable',data = df[df['Cat']==category],hue='Team',palette=secondary_pal,order=['z_CmpPct','z_YardsPer',
				'z_TDPct','z_IntPct']).set(xticks=[.16,.5,.84,])
			g.savefig('d:\\datfiles\\{}Week{}{}.png'.format(year,week,category))
