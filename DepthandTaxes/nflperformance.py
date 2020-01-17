import cx_Oracle
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
from  matplotlib.ticker import PercentFormatter

dat_pal = ['#29506D','#AA3939','#2D882D','#AA7939','#718EA4','#FFAAAA','#88CC88','#FFDBAA','#042037','#550000','#004400',
           '#553100', '#496D89','#D46A6A','#55AA55','#D4A76A','#123652','#801515','#116611','#805215']
light_seq_dat_pal = sns.light_palette('#29506D')
sns.set_style('whitegrid')
sns.set_palette(dat_pal)
colors = {
'primary' : ['#97233F', '#A71930', '#241773', '#00338D', '#0085CA', '#0B162A', '#FB4F14', '#311D00', '#041E42', '#FB4F14', 
             '#0076B6', '#203731', '#03202F', '#002C5F', '#101820', '#E31837', '#002244', '#002A5E', '#008E97', '#4F2683', 
             '#002244', '#D3BC8D', '#0B2265', '#125740', '#000000', '#004C54', '#FFB612', '#002244', '#AA0000', '#D50A0A', 
             '#0C2340', '#773141'],
'secondary' : ['#000000', '#000000', '#000000', '#C60C30', '#101820', '#C83803', '#000000', '#FF3C00', '#869397', '#002244', 
               '#B0B7BC', '#FFB612', '#A71930', '#A2AAAD', '#D7A22A', '#FFB81C', '#866D4B', '#FFC20E', '#FC4C02', '#FFC62F', 
               '#C60C30', '#101820', '#A71930', '#000000', '#A5ACAF', '#A5ACAF', '#101820','#69BE28', '#B3995D', '#FF7900', 
               '#418FDE', '#FFB612'],
'alt': ['#FFB612', '#A5ACAF', '#9E7C0C', '#C60C30', '#BFC0BF', '#C83803', '#000000', '#FFFFFF', '#FFFFFF', '#002244', 
        '#000000', '#FFB612', '#A71930', '#A2AAAD', '#006778', '#FFB81C', '#FFFFFF', '#0080C6', '#005778', '#FFC62F', 
        '#B0B7BC', '#101820', '#A5ACAF', '#FFFFFF', '#A5ACAF', '#000000', '#003087', '#A5ACAF', '#B3995D', '#0A0A08', 
        '#C8102E', '#FFB612']
}
index = ['ARI', 'ATL', 'BAL', 'BUF', 'CAR', 'CHI', 'CIN', 'CLE', 'DAL', 'DEN', 'DET', 'GB', 'HOU', 'IND', 'JAX', 'KC', 
         'LA', 'LAC', 'MIA', 'MIN', 'NE', 'NO', 'NYG', 'NYJ', 'OAK', 'PHI', 'PIT', 'SEA', 'SF', 'TB', 'TEN', 'WAS']
color_df = pd.DataFrame(colors, index=index)
nfl_pal = color_df['primary'].to_dict()
secondary_pal = color_df['secondary'].to_dict()

qb_sql = (
" SELECT"
"     player_person_displayname         displayname,"
"     player_currentteam_abbreviation   abbreviation,"
"     gamestats_passingattempts         passingattempts,"
"     gamestats_passingcompletions      passingcompletions,"
"     gamestats_passinginterceptions    passinginterceptions,"
"     gamestats_passingtouchdowns       passingtouchdowns,"
"     gamestats_passingyards            passingyards"
" FROM"
"     nfl_game_player"
" WHERE"
"     game_id IN ("
"         SELECT"
"             id"
"         FROM"
"             nfl_game"
"         WHERE"
"             week_seasonvalue = 2019"
"             AND week_weektype = 'REG'"
"     )"
)

class NFLPerformance(object):
	"""docstring for NFLPerformance"""
	def __init__(self, team, con):
		self.team = team
		self.con = con
		self.record_df = self.query_record()
		self.gamestat_df = self.query_gamestats()
		self.playerdf = self.query_players()
		
	def query_record(self):
		sql_string = (
		" SELECT"
		"     g.week_seasonvalue           season,"
		"     g.week_seasontype            seasontype,"
		"     g.week_weekvalue             week,"
		"     d.hometeam_abbreviation      team,"
		"     d.visitorteam_abbreviation   opponent,"
		"     CASE"
		"         WHEN d.homepointstotal > d.visitorpointstotal THEN"
		"             1"
		"         ELSE"
		"             0"
		"     END wins,"
		"     CASE"
		"         WHEN d.homepointstotal < d.visitorpointstotal THEN"
		"             1"
		"         ELSE"
		"             0"
		"     END losses,"
		"     CASE"
		"         WHEN d.homepointstotal = d.visitorpointstotal THEN"
		"             1"
		"         ELSE"
		"             0"
		"     END ties"
		" FROM"
		"     nfl_game           g"
		"     LEFT JOIN nfl_game_details d ON g.gamedetailid = d.id"
		" WHERE"
		"     (g.week_seasontype = 'REG' )"
		"     OR ( g.week_seasontype = 'POST' )"
		" UNION"
		" SELECT"
		"     g.week_seasonvalue           season,"
		"     g.week_seasontype            seasontype,"
		"     g.week_weekvalue             week,"
		"     d.visitorteam_abbreviation team,"
		"     d.hometeam_abbreviation      opponent,"
		"     CASE"
		"         WHEN d.visitorpointstotal > d.HOMEPOINTSTOTAL THEN"
		"             1"
		"         ELSE"
		"             0 End wins,"
		"     CASE"
		"         WHEN d.visitorpointstotal < d.homepointstotal THEN"
		"             1"
		"         ELSE"
		"             0"
		"     END losses,"
		"     CASE"
		"         WHEN d.homepointstotal = d.visitorpointstotal THEN"
		"             1"
		"         ELSE"
		"             0"
		"     END ties"
		" FROM"
		"     nfl_game           g"
		"     LEFT JOIN nfl_game_details   d ON g.gamedetailid = d.id"
		" WHERE"
		"     ( g.week_seasontype = 'REG' )"
		"     OR ( g.week_seasontype = 'POST' )"
		)
		df = pd.read_sql(sql_string, con=self.con)
		df = df.sort_values(['SEASON','SEASONTYPE','WEEK'],ascending=[True,False,True]).reset_index(drop=True)
		return df

	def query_gamestats(self):
		sql_string = (
		" SELECT"
		"     g.week_weekvalue          week,"
		"     g.week_seasonvalue        season,"
		"     g.week_seasontype            seasontype,"		
		"     g.hometeam_abbreviation   abbreviation,"
		"     g.awayteam_abbreviation   opponent_abbreviation,"
		"     t.teamgamestats_passingnetyards,"
		"     t.teamgamestats_rushingyards,"
		"     t.opponentgamestats_passingnetyards,"
		"     t.opponentgamestats_rushingyards"
		" FROM"
		"     nfl_game             g"
		"     LEFT JOIN nfl_game_teamstats   t ON g.hometeam_abbreviation = t.team_abbreviation"
		"                                       AND g.id = t.gameid"
		" WHERE"
		"     ( g.week_seasontype = 'REG' )"
		"     OR ( g.week_seasontype = 'POST' )"
		" UNION"
		" SELECT"
		"     g.week_weekvalue          week,"
		"     g.week_seasonvalue        season,"
		"     g.week_seasontype            seasontype,"
		"     g.awayteam_abbreviation   abbreviation,"
		"     g.HOMETEAM_ABBREVIATION   opponent_abbreviation,"
		"     t.teamgamestats_passingnetyards,"
		"     t.teamgamestats_rushingyards, t.opponentgamestats_passingnetyards,"
		"     t.opponentgamestats_rushingyards"
		" FROM"
		"     nfl_game             g"
		"     LEFT JOIN nfl_game_teamstats   t ON g.awayteam_abbreviation = t.team_abbreviation"
		"                                       AND g.id = t.gameid"
		" WHERE"
		"     ( g.week_seasontype = 'REG') Or ( g.week_seasontype = 'POST' )"		
		)
		df = pd.read_sql(sql_string, con=self.con)
		return df
		
	def query_players(self):
		sql_string =(
		" SELECT"
		"     g.week_weekvalue                    week,"
		"     g.week_seasonvalue                  season,"
		"     g.week_seasontype					seasontype,"
		"     p.gamestats_fumblestotal            fumblestotal,"
		"     p.gamestats_passingattempts         passingattempts,"
		"     p.gamestats_passingcompletions      passingcompletions,"
		"     p.gamestats_passinginterceptions    passinginterceptions,"
		"     p.gamestats_passingtouchdowns       passingtouchdowns,"
		"     p.gamestats_passingyards            passingyards,"
		"     p.gamestats_receivingreceptions     receivingreceptions,"
		"     p.gamestats_receivingtarget         receivingtarget,"
		"     p.gamestats_receivingtouchdowns     receivingtouchdowns,"
		"     p.gamestats_receivingyards          receivingyards,"
		"     p.gamestats_rushingattempts         rushingattempts,"
		"     p.gamestats_rushingtouchdowns       rushingtouchdowns,"
		"     p.gamestats_rushingyards            rushingyards,"
		"     p.player_person_displayname         displayname,"
		"     p.player_currentteam_abbreviation   abbreviation"
		" FROM"
		"     nfl_game          g"
		"     LEFT JOIN NFL_GAME_PLAYER   p ON g.id = p.game_id"
		" WHERE ( g.week_seasontype = 'REG' )"
		"     OR ( g.week_seasontype = 'POST' )"	
		)
		df = pd.read_sql(sql_string, con=self.con)
		return df

	def coach_analysis(self, coachname, startyear, stopyear=2019, startweek=1, stopweek=21):
		df = self.record_df
		df.loc[df['SEASONTYPE']=='POST', 'WEEK'] = df.loc[df['SEASONTYPE']=='POST', 'WEEK'] + 17
		start, stop = df[(df['SEASON']==startyear) & (df['WEEK']==startweek)].index[0], df[(df['SEASON']==stopyear) & (df['WEEK']==stopweek)].index[-1]
		
		# Truncate DF to coaches active range
		df = df.iloc[start:stop+1]

		# Compare teams record to the record of other teams with common opponents
		df2 = df[df['TEAM']==self.team]
		opp = pd.DataFrame()
		for s in df2['SEASON'].unique().tolist():
			schedule = df2[df2['SEASON']==s].OPPONENT.unique().tolist()
			opp = opp.append(df[(df['TEAM'].isin(schedule)) & (df['OPPONENT'] != self.team) & (df['SEASON']==s)])        
			df2 = df2.append(opp)

		df2.reset_index(drop=True, inplace=True)
		df2.loc[(df2['TEAM']!=self.team)& (df2['TIES']==0) ,'WINS'] = 1-df2['WINS']
		df2.loc[(df2['TEAM']!=self.team)& (df2['TIES']==0) ,'LOSSES'] = 1-df2['LOSSES']
		df2.loc[df2['TEAM']!=self.team,'TEAM'] = 'Rest of NFL'        

		# Perform Chi-Sq Test of Independence
		wins = df2[df2['TEAM']==self.team].WINS.sum()
		losses = df2[df2['TEAM']==self.team].LOSSES.sum()
		ties = df2[df2['TEAM']==self.team].TIES.sum()
		oppwins = df2[df2['TEAM']!=self.team].WINS.sum()
		opplosses = df2[df2['TEAM']!=self.team].LOSSES.sum()
		oppties = df2[df2['TEAM']!=self.team].TIES.sum()		 
		comp = pd.np.array([[wins,losses,ties],[oppwins,opplosses,oppties]])

		chi2, p, dof, expected = stats.chi2_contingency(comp)

		# Format and prettify
		df2.columns = df2.columns.str.title()
		df2 = df2.melt(id_vars=['Season','Team','Seasontype','Week','Opponent'])
		df2.rename(columns={'value':'Win Percentage','variable':'Result'},inplace=True)
		data = df2[df2['Result']=='Wins']

		# Plot Overall Win Pct
		g = sns.barplot(x='Result', y='Win Percentage', hue='Team', data=data, order=None, hue_order=None, ci=95, n_boot=1000, units=None, orient=None, 
			color=None, palette=color_df.loc[self.team], saturation=0.75, errcolor=color_df.loc[self.team,'alt'], errwidth=None, capsize=None, dodge=True, 
			ax=None)
		
		for patch in g.patches:
			g.annotate(format(patch.get_height(), '.1%'), (patch.get_x() + patch.get_width() / 2, patch.get_height()/2), ha='center', color='white', 
				fontsize=14)
			if p <= .05:
				patch.set_edgecolor('#CCFF00')
				patch.set_linewidth(3)				
		g.yaxis.set_major_formatter(PercentFormatter(1))

		# Plot Time Series of Win Pct
		g = plt.figure()
		g = sns.lineplot(x='Season', y='Win Percentage', hue='Team', size=None, style='Team', data=data, palette=color_df.loc[self.team], 
			hue_order=None, hue_norm=None, sizes=None, size_order=None, size_norm=None, dashes=True, markers=None, style_order=None, units=None, 
			estimator='mean', ci=95, n_boot=1000, sort=True, err_style='band', err_kws=None, legend='brief', ax=None)
		g.set(xticks=list(range(startyear,stopyear+1)))
		g.set_xticklabels(list(range(startyear,stopyear+1)), rotation=45)
		g.yaxis.set_major_formatter(PercentFormatter(1))

		return comp, p
		
	def gamestat_analysis(self, year):
		df = self.gamestat_df
		df.loc[df['SEASONTYPE']=='POST', 'WEEK'] = df.loc[df['SEASONTYPE']=='POST', 'WEEK'] + 17
		opponents = df[(df['ABBREVIATION']==self.team) & (df['SEASON']==year)].OPPONENT_ABBREVIATION.unique().tolist()
		df2 = df[(df['SEASON']==year) & (df['ABBREVIATION']==self.team)]
		df3 = df[(df['SEASON']==year) & (df['ABBREVIATION'].isin(opponents)) & (df['OPPONENT_ABBREVIATION']!=self.team)]
		
		# Switch game stats for non self.team to compliment
		df3.rename(columns={'TEAMGAMESTATS_PASSINGNETYARDS':'OPPONENTGAMESTATS_PASSINGNETYARDS', 
			'TEAMGAMESTATS_RUSHINGYARDS':'OPPONENTGAMESTATS_RUSHINGYARDS', 'OPPONENTGAMESTATS_PASSINGNETYARDS':'TEAMGAMESTATS_PASSINGNETYARDS', 
			'OPPONENTGAMESTATS_RUSHINGYARDS':'TEAMGAMESTATS_RUSHINGYARDS'}, inplace=True)
		df = pd.concat([df2,df3], sort=False)
		df.loc[df['ABBREVIATION']!=self.team,'ABBREVIATION'] = 'Opponents'
		df.rename(columns={'TEAMGAMESTATS_PASSINGNETYARDS':'Passing Offense', 'TEAMGAMESTATS_RUSHINGYARDS':'Rushing Offense', 
			'OPPONENTGAMESTATS_PASSINGNETYARDS':'Passing Defense', 'OPPONENTGAMESTATS_RUSHINGYARDS': 'Rushing Defense'}, inplace=True)
		df.columns = df.columns.str.title()

		# Perform t-test
		data = []
		columns = ['Passing Offense', 'Rushing Offense', 'Passing Defense', 'Rushing Defense']
		for c in columns:
			statistic, pvalue = stats.ttest_ind(df.loc[df['Abbreviation']==self.team, c], df.loc[df['Abbreviation']!=self.team, c], equal_var=False)
			data.append((c, statistic, pvalue, df.loc[df['Abbreviation']==self.team, c].mean(), df.loc[df['Abbreviation']!=self.team, c].mean()))
		data = pd.DataFrame(data, columns=['Statistic','FStatistic','PValue','TeamMean','OpponentMean'])

		df = df.melt(id_vars=['Week', 'Season', 'Abbreviation', 'Opponent_Abbreviation'])
		df.rename(columns={'value': 'Yards Per Game','variable':'Category'},inplace=True)
		
		# Plot bar chart
		g = sns.barplot(x='Category', y='Yards Per Game', hue='Abbreviation', data=df, order=None, hue_order=None, ci=95, n_boot=1000, units=None, 
			orient=None, color=None, palette=color_df.loc[self.team], saturation=0.75, errcolor=color_df.loc[self.team,'alt'], errwidth=None, capsize=None, 
			dodge=True, ax=None)
		for patch in g.patches:
			g.annotate(format(patch.get_height(), '.1f'), (patch.get_x() + patch.get_width() / 2, patch.get_height()/2), ha='center', color='white')
		for i, t in enumerate(g.get_xticklabels()):
			if t.get_text() in data.loc[data['PValue']<=.05,'Statistic'].tolist():
				g.patches[i].set_edgecolor('#CCFF00')
				g.patches[i].set_linewidth(3)
		return data

	def passer_rating(self,year):
		df = self.playerdf
		df.loc[df['SEASONTYPE']=='POST', 'WEEK'] = df.loc[df['SEASONTYPE']=='POST', 'WEEK'] + 17
		df2 = df[(df['SEASON']==year) & (df['ABBREVIATION']==self.team) & (df['PASSINGATTEMPTS'] >=14)]
		
		# Calculate Rating
		df2.loc[:, 'CmpPct'] = (df2.loc [:, 'PASSINGCOMPLETIONS'] / df2.loc[:, 'PASSINGATTEMPTS'] - .3) * 5
		df2.loc[:, 'YPA'] = (df2.loc [:, 'PASSINGYARDS'] / df2.loc[:, 'PASSINGATTEMPTS'] - 3) * .25
		df2.loc[:, 'TDPct'] = (df2.loc [:, 'PASSINGTOUCHDOWNS'] / df2.loc[:, 'PASSINGATTEMPTS'] ) * 20
		df2.loc[:, 'INTPct'] = 2.375 - (df2.loc [:, 'PASSINGINTERCEPTIONS'] / df2.loc[:, 'PASSINGATTEMPTS'] * 25)
		for s in ['CmpPct', 'YPA', 'TDPct', 'INTPct']:
			df2.loc[df2[s] > 2.375, s] = 2.375
			df2.loc[df2[s] < 0, s] = 0			
		df2.loc[:, 'Rating'] = df2.loc[:,['CmpPct', 'YPA', 'TDPct', 'INTPct']].sum(axis=1) / 6 * 100
		
		# Prettify
		df2 = df2[['WEEK','DISPLAYNAME','ABBREVIATION','PASSINGATTEMPTS','Rating']]
		df2.rename(columns={'DISPLAYNAME':'Name', 'PASSINGATTEMPTS':'Attempts'}, inplace=True)
		df2.columns = df2.columns.str.title()

		# Find groupings of significant differences in ratings
		for p in df2['Name'].unique():
			g = plt.figure()
			data = []
			df3 = df2[df2['Name']==p].reset_index(drop=True)
			for i in df3['Attempts'].sort_values().unique().tolist():
				statistic, pvalue = stats.ttest_ind(df3.loc[df3['Attempts']<=i,'Rating'],df3.loc[df3['Attempts']>i,'Rating'],equal_var=False)
				data.append((p,i,statistic,pvalue,df3.loc[df3['Attempts']<=i,'Rating'].mean(),df3.loc[df3['Attempts']>i,'Rating'].mean()))
				df4 = pd.DataFrame(data,columns=['Name','Attempts','Statistic','P-Value','UnderMean','OverMean'])
				bins = [14]
				for a in df4[df4['P-Value']<=.05].Attempts.tolist():
					bins.append(a)
				bins.append(df4.Attempts.max())
				df5 = pd.concat([df3, pd.cut(df3.Attempts,bins=bins,duplicates='drop').rename('AttemptsRange')],axis=1)
			g = sns.scatterplot(x='Attempts', y='Rating', hue='Name', style=None, size=None, data=df5, palette=color_df.loc[self.team], hue_order=None, 
				hue_norm=None, sizes=None, size_order=None, size_norm=None, markers=True, style_order=None, x_bins=None, y_bins=None, units=None, 
				estimator=None, ci=95, n_boot=1000, alpha='auto', x_jitter=None, y_jitter=None, legend='brief', ax=None, marker='x')
 
			for a in df5.AttemptsRange.tolist():
				xmin, ymin = g.transLimits.transform((df5[df5['AttemptsRange']==a].Attempts.min(),0))
				xmax, ymax = g.transLimits.transform((df5[df5['AttemptsRange']==a].Attempts.max(),0)) 
				mean, sigma, length = df5[df5['AttemptsRange']==a].Rating.mean(), df5[df5['AttemptsRange']==a].Rating.std(), \
				len(df5[df5['AttemptsRange']==a].Rating)
				conf_int = stats.norm.interval(0.95, loc=mean, scale=sigma / pd.np.sqrt(length))
				x = [df5[df5['AttemptsRange']==a].Attempts.min(), df5[df5['AttemptsRange']==a].Attempts.min(), df5[df5['AttemptsRange']==a].Attempts.max(), 
				df5[df5['AttemptsRange']==a].Attempts.max()]
				y = [conf_int[0], conf_int[1], conf_int[1], conf_int[0]]
				g.fill(x, y, alpha=.05, color=color_df.loc[self.team,'alt'], hatch='x', antialiased=True)
				g.axhline(y=df5[df5['AttemptsRange']==a].Rating.mean(), xmin=xmin, xmax=xmax, color=color_df.loc[self.team,'secondary'])
				
				# Annotate the plot
				# g.annotate('Mean= '+format(df5[df5['AttemptsRange']==a].Rating.mean(), '.1f'), (df5[df5['AttemptsRange']==a].Attempts.min(),
				# 	df5[df5['AttemptsRange']==a].Rating.mean()+1), xycoords='data', color=color_df.loc[self.team,'primary'])
 
	def passer_score(self, year, week=21):
		df = self.playerdf
		df.loc[df['SEASONTYPE']=='POST', 'WEEK'] = df.loc[df['SEASONTYPE']=='POST', 'WEEK'] + 17
		df2 = df.loc[(df['SEASON']==year) & (df['WEEK']<=week), ['WEEK','SEASON', 'ABBREVIATION', 'PASSINGATTEMPTS', 
                                                         'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 
                                                         'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]
df2 = df2[['WEEK', 'ABBREVIATION', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 
           'PASSINGYARDS']].groupby(['WEEK','ABBREVIATION']).sum().reset_index()
for a in df2['ABBREVIATION'].unique(): 
    for w in list(range(1,22)):    
        if df2.loc[(df2['ABBREVIATION'] == a) & (df2['WEEK']==w), 'PASSINGATTEMPTS'].any() >= 1:
            pass
        else:
            df2 = df2.append(pd.DataFrame([(w, a)], columns = ['WEEK', 'ABBREVIATION']))
df2.set_index('WEEK', inplace=True)
df2 = df2.groupby('ABBREVIATION')[['PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 
           'PASSINGTOUCHDOWNS', 'PASSINGYARDS']].expanding().sum()
df2.reset_index(inplace=True)
# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)

# df3 = df2.loc[:,['WEEK', 'IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').mean()
# df3 = df3.add_suffix('_mean')
# df4 = df2.loc[:,['WEEK', 'IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').std()
# df4 = df4.add_suffix('_std')
# df3 = df3.join(df4)
# df2 = df.loc[(df['SEASON']==year) & (df['PASSINGATTEMPTS']>=1) & (df['ABBREVIATION'] == team), ['WEEK', 'SEASON', 
#                                                                                                 'ABBREVIATION', 
#                                                                                                 'DISPLAYNAME', 
#                                                                                                 'PASSINGATTEMPTS', 
#                                                                                                 'PASSINGCOMPLETIONS',
#                                                                                                 'PASSINGINTERCEPTIONS', 
#                                                                                                 'PASSINGTOUCHDOWNS', 
#                                                                                                 'PASSINGYARDS']]


# for n in df2['DISPLAYNAME'].unique(): 
#     for w in list(range(1,22)):    
#         if df2.loc[(df2['DISPLAYNAME'] == n) & (df2['WEEK']==w), 'PASSINGATTEMPTS'].any() >= 1:
#             pass
#         else:
#             df2 = df2.append(pd.DataFrame([(n, w, team)], columns = ['DISPLAYNAME', 'WEEK', 'ABBREVIATION']))
# df2.set_index('WEEK', inplace=True)
# df2.sort_index(inplace=True)
# df2 = df2.groupby(['DISPLAYNAME','ABBREVIATION'])[['PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 
#            'PASSINGTOUCHDOWNS', 'PASSINGYARDS']].expanding().sum()
# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']]\
# .div(df2['PASSINGATTEMPTS'].values, axis=0)

# df2 = df2.merge(df3, how='left', left_index=True, right_index=True)
# for s in ['IntPct','CmpPct', 'YardsPer', 'TDPct']:
#     df2.loc[:,'z_'+s] = (df2.loc[:,s] - df2.loc[:,s+'_mean'])/df2.loc[:,s+'_std'] 
# df2 = df2.loc[(df2['PASSINGATTEMPTS']>=14) & (df2['ABBREVIATION']==team),['ABBREVIATION','DISPLAYNAME','z_IntPct', 'z_CmpPct', 'z_YardsPer', 'z_TDPct']]
# df2[df2['WEEK']==17]
# df2[(df2['ABBREVIATION']==team) | (df2['ABBREVIATION']=='NE')]
df[(df['ABBREVIATION']==team) & (df['WEEK']==9) & (df['PASSINGATTEMPTS']>0)]
		# df2 = df.loc[(df['SEASON']==year) & (df['WEEK']<=week), ['WEEK','SEASON', 'ABBREVIATION', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 
		# 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]
		# df2 = df2[['WEEK', 'ABBREVIATION', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]\
		# .groupby(['WEEK','ABBREVIATION']).sum().reset_index()
		# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
		# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)
		# df3 = df2.loc[:,['WEEK', 'IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').mean()
		# df3 = df3.add_suffix('_mean')
		# df4 = df2.loc[:,['WEEK', 'IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').std()
		# df4 = df4.add_suffix('_std')
		# df3 = df3.join(df4)	
		# df2 = df.loc[(df['SEASON']==year) & (df['PASSINGATTEMPTS']>=1) & (df['ABBREVIATION'] == team), ['WEEK', 'SEASON', 'ABBREVIATION', 'DISPLAYNAME', 
		# 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]
		# for n in df2['DISPLAYNAME']:
		# 	for w in list(range(1,22)):
		# 		df.loc[df2['DISPLAYNAME'] == n, ['ABBREVIATION', 'WEEK']] == self.team, w	

		# df2 = df.loc[(df['SEASON']==year) & (df['WEEK']<=week), ['WEEK','SEASON', 'ABBREVIATION', 'DISPLAYNAME', 'PASSINGATTEMPTS', 
		# 'PASSINGCOMPLETIONS', 

		# 		'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]
		# df2 = df2[['ABBREVIATION', 'DISPLAYNAME', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]\
		# 		.groupby(['ABBREVIATION', 'DISPLAYNAME']).sum().reset_index()
		# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
		# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)
		# for v in df3.index:
		# 	df2.loc[:,v] = df3.get(v)
		# for s in ['IntPct','CmpPct', 'YardsPer', 'TDPct']:
		# 	df2.loc[:,'z_'+s] = (df2.loc[:,s] - df2.loc[:,s+'_mean'])/df2.loc[:,s+'_std']    
		# df2 = df2.loc[(df2['PASSINGATTEMPTS']>=224) & (df2['ABBREVIATION']==self.team),['ABBREVIATION','DISPLAYNAME','z_IntPct','z_CmpPct', 'z_YardsPer', 
		# 'z_TDPct']]
		# df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']] = df2.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]\
		# .apply(lambda x: stats.norm.cdf(x))
		# df2 = df2.melt(id_vars=['ABBREVIATION','DISPLAYNAME'])
		# df2.rename(columns={'ABBREVIATION':'Team','DISPLAYNAME':'Name', 'value':'Percentile', 'variable':'Statistic'}, inplace=True)

		# g = sns.catplot(x='Percentile', y='Statistic', hue=None, data=df2, row=None, col='Name', col_wrap=1, ci=95, n_boot=1000, units=None, 
  #       	order=['z_CmpPct','z_YardsPer', 'z_TDPct','z_IntPct'], hue_order=None, row_order=None, col_order=None, kind='bar', height=5, aspect=1, 
		# 	orient=None, color=color_df.loc[self.team,'primary'], palette=None, legend=True, legend_out=True, sharex=True, sharey=True, margin_titles=False, 
		# 	facet_kws=None, edgecolor=color_df.loc[self.team,'secondary']).set(xticks=[.16,.5,.84,]).despine(left=True).despine(bottom=True)

		# g = sns.barplot(x='Percentile', y='Statistic', hue=None, data=df2, order=['z_CmpPct','z_YardsPer', 'z_TDPct','z_IntPct'], hue_order=None, ci=95, 
		# 	n_boot=1000, units=None, orient=None, color=color_df.loc[self.team,'primary'], palette=None, saturation=0.75, errcolor='.26', errwidth=None, 
		# 	capsize=None, dodge=True, ax=None, edgecolor=color_df.loc[self.team,'secondary'])
		# g.set(xticks=[.16,.5,.84,])
		# sns.despine(left=True, bottom=True)
		return df
# for s in ['IntPct','CmpPct', 'YardsPer', 'TDPct']:
#     df2.loc[:,'z_'+s] = (df2.loc[:,s] - df2.loc[:,s+'_mean'])/df2.loc[:,s+'_std']
		# # Calculate z-score
		# df2 = df[df['SEASON']==year]
		# df2 = df2[['WEEK','ABBREVIATION', 'PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 'PASSINGYARDS']]\
		# .groupby(['WEEK','ABBREVIATION']).sum().reset_index()
		# for a in df2['ABBREVIATION'].unique().tolist():
		# 	for w in list(range(1,22)):
		# 		if len(df2.loc[(df2['ABBREVIATION']==a) & (df2['WEEK']==w), 'WEEK']) == 1:
		# 			pass
		# 		else :
		# 			df2.loc[(df2['ABBREVIATION']==a) & (df2['WEEK']==w), 'WEEK'] = w
		# 			df2.loc[(df2['ABBREVIATION']==a) & (df2['WEEK']==w), 'SEASON'] = year
		# 			df2.loc[(df2['ABBREVIATION']==a) & (df2['WEEK']==w), 'PASSINGATTEMPTS':] = pd.np.NaN
		# for a in df2['ABBREVIATION'].unique().tolist():
		# 	df2.loc[df2['ABBREVIATION']==a,['PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 'PASSINGTOUCHDOWNS', 
		#                                     'PASSINGYARDS']] = df2.loc[df2['ABBREVIATION']==a,['PASSINGATTEMPTS', 'PASSINGCOMPLETIONS', 'PASSINGINTERCEPTIONS', 
		#                                     'PASSINGTOUCHDOWNS', 'PASSINGYARDS']].expanding(1).sum()

		# # Find mean and standard dev
		# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
		# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)
		# df3 = df2.loc[:,['WEEK','IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').mean()
		# df3 = df3.add_suffix('_mean')
		# df4 = df2.loc[:,['WEEK','IntPct','CmpPct', 'YardsPer', 'TDPct']].groupby('WEEK').std()
		# df4 = df4.add_suffix('_std')
		# df3 = df3.join(df4)
		# df2 = df2.merge(df3,how='left',left_on='WEEK',right_index=True)

		# df2 = df[(df['SEASON']==year) & (df['ABBREVIATION']==self.team) & (df['PASSINGATTEMPTS'] >=14)]
		# df2.loc[:,'IntPct'] = 1 - df2.loc[:,'PASSINGINTERCEPTIONS']/df2.loc[:,'PASSINGATTEMPTS']
		# df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']].div(df2['PASSINGATTEMPTS'].values, axis=0)
		# df2 = df2.merge(df3,how='left',left_on='WEEK',right_index=True)

		# return df2



		# teamdf = teamdf[['CmpPct_mean','CmpPct_std','YardsPer_mean','YardsPer_std','TDPct_mean','TDPct_std','IntPct_mean', 'IntPct_std']]		
		# df = df.join(teamdf)

		# # Calcuculate z-scores
		# df.loc[:,'IntPct'] = 1 - df.loc[:,'PASSINGINTERCEPTIONS']/df.loc[:,'PASSINGATTEMPTS']
		# df[['CmpPct', 'YardsPer', 'TDPct']] = df[['PASSINGCOMPLETIONS', 'PASSINGYARDS', 'PASSINGTOUCHDOWNS']]\
		# .div(df['PASSINGATTEMPTS'].values, axis=0)
		# df.loc[:,'z_CmpPct'] = (df.loc[:,'CmpPct'] - df.loc[:,'CmpPct_mean'])/df.loc[:,'CmpPct_std']
		# df.loc[:,'z_YardsPer'] = (df.loc[:,'YardsPer'] - df.loc[:,'YardsPer_mean'])/df.loc[:,'YardsPer_std']
		# df.loc[:,'z_TDPct'] = (df.loc[:,'TDPct'] - df.loc[:,'TDPct_mean'])/df.loc[:,'TDPct_std']
		# df.loc[:,'z_IntPct'] = (df.loc[:,'IntPct'] - df.loc[:,'IntPct_mean'])/df.loc[:,'IntPct_std']


		# # Trim prettify df
		# df = df.reset_index()		
		# df = df[(df['PASSINGATTEMPTS']>=14*16) & (df['ABBREVIATION']==self.team)]
		# # df.columns = df.columns.str.title()
		# # ***TODO*** Change to work mid-season

		# # Format result
		# df.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']] = df.loc[:,['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]\
		# .apply(lambda x: stats.norm.cdf(x))





        
#         return df2[['Name','Team','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct','Cat']]
