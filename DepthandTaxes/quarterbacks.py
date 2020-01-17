import cx_Oracle
from math import pi
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# NFL Primary color palette
nfl_pal = {'ARI':'#97233F','ATL':'#A71930','BAL':'#241773','BUF':'#00338D','CAR':'#0085CA','CHI':'#0B162A',
'CIN':'#FB4F14','CLE':'#311D00','DAL':'#041E42','DEN':'#FB4F14','DET':'#0076B6','GB':'#203731','HOU':'#03202F',
'IND':'#002C5F','JAX':'#101820','KC':'#E31837','LAC':'#002A5E','LA':'#002244','MIA':'#008E97','MIN':'#4F2683',
'NO':'#D3BC8D','NE':'#002244','NYG':'#0B2265','NYJ':'#003F2D','OAK':'#000000','PHI':'#004C54','PIT':'#FFB612',
'SEA':'#002244','SF':'#AA0000','TB':'#D50A0A','TEN':'#002A5C','WAS':'#773141'}

#Connect to OracleDB
passkey = pd.read_csv('..\\DepthandTaxes\\DepthandTaxes\\passfile.csv')
con = cx_Oracle.connect('{0}/{1}@{2}/XEPDB1'.format(passkey.iat[0,0],passkey.iat[0,1],passkey.iat[0,2]))

sql_string = (
"WITH passerstats AS ("
"    SELECT"
"        p.displayname,"
"        g.abbreviation,"
"        p.gameid,"
"        p.passingattempts,"
"        p.passingcompletions,"
"        p.passingtouchdowns,"
"        p.passingyards,"
"        p.passinginterceptions"
"    FROM"
"        ("
"            SELECT"
"                nfl_game.homeabbreviation abbreviation,"
"                nfl_game.id"
"            FROM"
"                nfl_game"
"            WHERE"
"                nfl_game.SEASONVALUE = 2019"
"                AND nfl_game.seasontype = 'REG'"
"            UNION"
"            SELECT"
"                nfl_game.awayabbreviation abbreviation,"
"                nfl_game.id"
"            FROM"
"                nfl_game"
"            WHERE"
"                nfl_game.seasonvalue = 2019"
"                AND nfl_game.seasontype = 'REG'"
"        ) g"
"        INNER JOIN nfl_game_player                                                                                                                                                                                                                                                     p ON g.ID = p.gameid"
"                                        AND g.abbreviation = p.abbreviation"
" )"
" select displayname, attempts_qualifier / 14 teamgames, abbreviation, passingattempts, passingcompletions, passingtouchdowns, passingyards, passinginterceptions"
" from ("
" SELECT s.displayname, s.abbreviation, q.attempts_qualifier, s.passingattempts, s.passingcompletions, s.passingtouchdowns, s.passingyards, s.passinginterceptions"
" FROM ("
" SELECT"
"     abbreviation, count(distinct(gameid)) * 14 AS attempts_qualifier"
" FROM"
"     passerstats"
" group by abbreviation) q"
" inner join"
" (SELECT"
" displayname, abbreviation,sum(passingattempts) passingattempts, sum(passingcompletions) passingcompletions, sum(passingtouchdowns) passingtouchdowns, sum(passingyards) passingyards,"
" sum(passinginterceptions) passinginterceptions from passerstats group by displayname, abbreviation) s"
" on q.abbreviation = s.abbreviation)"
" where passingattempts >= attempts_qualifier"
)

class QBStats(object):
	def __init__(self,SQL):
		self.df = pd.read_sql(SQL, con = con)

	def zscore(self):
		'''Creates a DataFrame of Passer Rating Components and performs a z transform
		'''
		df = self.df
		
		# Compile Ratio Stats
		df['IntPct'] = 1 - df['PASSINGINTERCEPTIONS']/df['PASSINGATTEMPTS']
		df[['CmpPct', 'YardsPer', 'TDPct']] = df[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df['PASSINGATTEMPTS'].values, axis=0)
		df['AttPer'] = df['PASSINGATTEMPTS'] / df['TEAMGAMES']
		
		# Z Transform Relevant Statistics
		df['z_CmpPct'] = (df.CmpPct - df.CmpPct.mean())/df.CmpPct.std()
		df['z_YardsPer'] = (df.YardsPer - df.YardsPer.mean())/df.YardsPer.std()
		df['z_TDPct'] = (df.TDPct - df.TDPct.mean())/df.TDPct.std()
		df['z_IntPct'] = (df.IntPct - df.IntPct.mean())/df.IntPct.std()
		df['z_AttPer'] = (df.AttPer - df.AttPer.mean())/df.AttPer.std()

		#  
		df['Above'] = (df[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]>=1).sum(1)
		df['Below'] = (df[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]<=-1).sum(1)

		# Assign players to categories
		df.loc[df['Above'] == 5, 'Cat'] = 'GOAT'
		df.loc[df['Below'] == 5, 'Cat'] = 'Train'
		df.loc[(df['Above'] == 0) & (df['Below'] == 0), 'Cat'] = 'Mediocre'
		df.loc[(df['Above'] >= 1) & (df['Above'] <= 4) & (df['Below'] == 0), 'Cat'] = 'Good'
		df.loc[(df['Above'] >= 1) & (df['Below'] >= 1), 'Cat'] = 'Mixed'
		df.loc[(df['Above'] == 0) & (df['Below'] <= 4) & (df['Below'] >= 1), 'Cat'] = 'Bad'

		# Format result
		df.rename(columns={'DISPLAYNAME':'Name','ABBREVIATION':'Tm'},inplace=True)

		return df[['Name','Tm','Cat','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]

	def spider(self,category):
		'''Creates faceted radar charts for Standardized Passing statistics
		'''
		try:

			df = self.zscore()
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

class TeamPassingStats(object):
	"""docstring for TeamPassingStats"""
	def __init__(self, SQL):
		self.df = pd.read_sql(SQL, con = con)

	def zscore(self,year):
		'''	'''
		df = self.df
		df = df[df['SEASONVALUE']==year]
		
		# Compile Ratio Stats
		df['IntPct'] = 1 - df['PASSINGINTERCEPTIONS']/df['PASSINGATTEMPTS']
		df[['CmpPct', 'YardsPer', 'TDPct']] = df[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df['PASSINGATTEMPTS'].values, axis=0)
		df['AttPer'] = df['PASSINGATTEMPTS'] / 16
		df['Rating'] = (((df.CmpPct - 0.3)*5) + ((df.YardsPer - 3)*0.25) + (df.TDPct*20) + (2.375-(df['PASSINGINTERCEPTIONS']/df['PASSINGATTEMPTS']*25)))/6*100

		# Z Transform Relevant Statistics
		df['z_CmpPct'] = (df.CmpPct - df.CmpPct.mean())/df.CmpPct.std()
		df['z_YardsPer'] = (df.YardsPer - df.YardsPer.mean())/df.YardsPer.std()
		df['z_TDPct'] = (df.TDPct - df.TDPct.mean())/df.TDPct.std()
		df['z_IntPct'] = (df.IntPct - df.IntPct.mean())/df.IntPct.std()
		df['z_AttPer'] = (df.AttPer - df.AttPer.mean())/df.AttPer.std()

		# Format result
		df.rename(columns={'ABBREVIATION':'Tm', 'SEASONVALUE':'Season', 'WINS':'Wins'},inplace=True)

		return df[['Tm','Season','Wins','Rating','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','z_AttPer']]

def uniplot(df):
# 	sns.set_style('darkgrid')
# 	g = sns.FacetGrid(data=df, sharex=False, sharey=False)
# 	g = g.map(plt.hist, 'Rate')
# 	plt.tight_layout()
# 	g.savefig('{}ratedist.png'.format(dfname)) 

	g2 = sns.FacetGrid(data=df, sharex=False, sharey=False)
	g2 = g2.map(plt.hist, 'Wins')
	plt.tight_layout()
# 	g2.savefig('{}depdist.png'.format(dfname)) 

	df1 = df.melt(id_vars=['Tm','Season','Wins','Rating'])
	g3 = sns.FacetGrid(data=df1, col='variable', col_wrap=3, sharex=False, sharey=False)
	g3 = g3.map(plt.hist, 'value')
	plt.tight_layout()
# 	g3.savefig('{}indepdist.png'.format(dfname))

def soloplot(df,var):
	sns.set_style('darkgrid')
	g = sns.relplot(x=var, y='Wins', data=df, kind='scatter')

def biplot(df):
	sns.set_style('darkgrid')
	df1 = df.melt(id_vars=['Tm','Season','Wins','Rating'])
	df1.reset_index(inplace=True)
	g = sns.relplot(x='value', y='Wins', data=df1, col='variable', col_wrap=2, kind='scatter')
# 	g.savefig('{}bivar.png'.format(dfname))

	g1 = sns.PairGrid(df[['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct','z_AttPer']])
	g1.map(plt.scatter, edgecolor='w')
# 	g1.savefig('{}matrix.png'.format(dfname))

	g2 = sns.FacetGrid(df)
	g2.axes = sns.heatmap(df[['Wins','z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct','z_AttPer']].corr(), annot=True, cmap='Blues')	
# 	g2.savefig('{}corr.png'.format(dfname))


# salary = pd.read_html('https://www.spotrac.com/nfl/rankings/cap-hit/quarterback/')
# salary = salary[0]
# sa_name = salary['Player'].str.split(expand=True)
# sa_name['Name'] = sa_name.iloc[:,0] + ' ' + sa_name.iloc[:,1]
# salary = salary.join(sa_name)

# week13['PredictedWins'] = reg.predict(week13[['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct']])
# data = week13.merge(salary[['cap hit','Name']],how='left', left_on='Name',right_on='Name')
# data['cap hit'].replace(regex=r'\D+',value='',inplace=True)
# data['cap hit'] = data['cap hit'].apply(pd.to_numeric)
# data['Cap Hit/Predicted Win'] = data['cap hit']/data['PredictedWins']
# data['Win Percentage'] = data['Wins']/data['G']


# g = sns.relplot(kind='scatter', data=data, x='Cap Hit/Predicted Win', y='Win Percentage', hue='Tm', palette=nfl_pal)
# g.savefig('scatterwins.png')
# g = sns.lmplot(data=data, x='Cap Hit/Predicted Win', y='Win Percentage', scatter_kws={'edgecolors':'w'})
# g.savefig('regwins.png')

# data.sort_values('Cap Hit/Predicted Win').reset_index(drop=True).to_html()

