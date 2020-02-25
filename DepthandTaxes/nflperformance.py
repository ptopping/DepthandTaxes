import cx_Oracle
import itertools
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
from  matplotlib.ticker import PercentFormatter
from matplotlib.ticker import MaxNLocator

# Global Color Palette Variables
dat_pal = ['#29506D', '#AA3939', '#2D882D', '#AA7939', '#718EA4', '#FFAAAA',
           '#88CC88', '#FFDBAA', '#042037', '#550000', '#004400', '#553100',
           '#496D89', '#D46A6A', '#55AA55', '#D4A76A', '#123652', '#801515',
           '#116611', '#805215']

light_seq_dat_pal = sns.light_palette('#29506D')

# NFL Team Specific Hex Colors
colors = {'primary' : ['#97233F', '#A71930', '#241773', '#00338D', '#0085CA',
                       '#0B162A', '#FB4F14', '#311D00', '#041E42', '#FB4F14',
                       '#0076B6', '#203731', '#03202F', '#002C5F', '#101820',
                       '#E31837', '#002244', '#002A5E', '#008E97', '#4F2683',
                       '#002244', '#D3BC8D', '#0B2265', '#125740', '#000000',
                       '#004C54', '#FFB612', '#002244', '#AA0000', '#D50A0A',
                       '#0C2340', '#773141'],
          'secondary' : ['#000000', '#000000', '#000000', '#C60C30',
                         '#101820', '#C83803', '#000000', '#FF3C00',
                         '#869397', '#002244', '#B0B7BC', '#FFB612',
                         '#A71930', '#A2AAAD', '#D7A22A', '#FFB81C',
                         '#866D4B', '#FFC20E', '#FC4C02', '#FFC62F',
                         '#C60C30', '#101820', '#A71930', '#000000',
                         '#A5ACAF', '#A5ACAF', '#101820', '#69BE28',
                         '#B3995D', '#FF7900', '#418FDE', '#FFB612'],
          'alt': ['#FFB612', '#A5ACAF', '#9E7C0C', '#C60C30', '#BFC0BF',
                  '#C83803', '#000000', '#FFFFFF', '#FFFFFF', '#002244',
                  '#000000', '#FFB612', '#A71930', '#A2AAAD', '#006778',
                  '#FFB81C', '#FFFFFF', '#0080C6', '#005778', '#FFC62F',
                  '#B0B7BC', '#101820', '#A5ACAF', '#FFFFFF', '#A5ACAF',
                  '#000000', '#003087', '#A5ACAF', '#B3995D', '#0A0A08',
                  '#C8102E', '#FFB612']}

index = ['ARI', 'ATL', 'BAL', 'BUF', 'CAR', 'CHI', 'CIN', 'CLE', 'DAL', 'DEN',
         'DET', 'GB', 'HOU', 'IND', 'JAX', 'KC', 'LA', 'LAC', 'MIA', 'MIN',
         'NE', 'NO', 'NYG', 'NYJ', 'OAK', 'PHI', 'PIT', 'SEA', 'SF', 'TB',
         'TEN', 'WAS']
color_df = pd.DataFrame(colors, index=index)

nfl_pal = color_df['primary'].to_dict()
secondary_pal = color_df['secondary'].to_dict()

# Global Graph Styles
sns.set_style('whitegrid')
sns.set_palette(dat_pal)

class NFLPerformance(object):
    '''
    Top level class for performance analysis of NFL teams

    Parameters:
        team: str
            NFL team abbreviation

        con: SQL connection to database
    '''


    def __init__(self, team, con):
        self.team = team
        self.con = con
        self.name_df = self.rename_players()


    def gamecount(self, year):
        '''
        Function which returns the number of games a team has played
        in the regular and post season in a season

        Parameters:
            year: int
                Year between 2001 and present inclusive.

        Returns:
            int: Number of games played. 
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_gamecount.sql',
                    'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Return the number of games
        return int(df.loc[df['ABBREVIATION'] == self.team, 'GAMES'])

    def complements(self, data):
        '''
        Class utilityy method that allows for the comparison of a team
        in a category versus what the opposition's complement

        Parameters:
            data: DataFrame
                Pandas DataFrame.

        Returns:
            Transformed DataFrame.
        '''
        # Find offense and defense when the team is away
        df = data[data['AWAYTEAM_ABBREVIATION']==self.team]
        df.rename(columns={'AWAYTEAM_ABBREVIATION':'Abbreviation',
                  'HOMETEAM_ABBREVIATION':'Opponent_Abbreviation'},
                  inplace=True)
        df.columns = df.columns.str.replace('_AWAY', '_OFF')
        df.columns = df.columns.str.replace('_HOME', '_DEF')

        # Find Offense and Defense when the team is home
        df2 = data[data['HOMETEAM_ABBREVIATION']==self.team]
        df2.rename(columns={'HOMETEAM_ABBREVIATION':'Abbreviation',
                   'AWAYTEAM_ABBREVIATION':'Opponent_Abbreviation'},
                   inplace=True)
        df2.columns = df2.columns.str.replace('_AWAY', '_DEF')
        df2.columns = df2.columns.str.replace('_HOME', '_OFF')
        df = df.append(df2, sort=True)

        # Find the team's opposition
        opponents = df.Opponent_Abbreviation.unique()

        # Find opponenet's offense and defense when the team is away
        df3 = data[(data['AWAYTEAM_ABBREVIATION'].isin(opponents))\
                   & (data['HOMETEAM_ABBREVIATION']!=self.team)]
        df3.rename(columns={'AWAYTEAM_ABBREVIATION':'Abbreviation',
                   'HOMETEAM_ABBREVIATION':'Opponent_Abbreviation'},
                   inplace=True)
        df3.columns = df3.columns.str.replace('_AWAY', '_DEF')
        df3.columns = df3.columns.str.replace('_HOME', '_OFF')
        df = df.append(df3, sort=True)

        # Find opponenet's offense and defense when the team is home
        df4 = data[(data['HOMETEAM_ABBREVIATION'].isin(opponents))\
                   & (data['AWAYTEAM_ABBREVIATION']!=self.team)]
        df4.rename(columns={'HOMETEAM_ABBREVIATION':'Abbreviation',
                   'AWAYTEAM_ABBREVIATION':'Opponent_Abbreviation'},
                   inplace=True)
        df4.columns = df4.columns.str.replace('_AWAY', '_OFF')
        df4.columns = df4.columns.str.replace('_HOME', '_DEF')
        df = df.append(df4, sort=True)

        # Rename opponents to a generic 'NFL'
        df.loc[df['Abbreviation']!=self.team, 'Abbreviation'] = 'NFL'

        return df

    def get_qualifiers(self, df, qual_num, qual_var, year):
        # Find qualifying number of attempts
        min_att = self.gamecount(year) * qual_num

        # Calculate total number of attempts for each player
        tot_att = df.groupby(['GSISPLAYER_ID', 'ABBREVIATION'])\
                    .sum()\
                    .reset_index()

        # Find all qualifying players
        players = tot_att.loc[(tot_att[qual_var] >= min_att)
                              & (tot_att['ABBREVIATION'] == self.team),
                              'GSISPLAYER_ID'].unique()

        return players

    def filter_players(self, df, filter_var, playerid, qual_num, qual_var):
        # Find the opponents a player played against
        opps = df.loc[df['GSISPLAYER_ID'] == playerid, 'OPPONENT'].unique()

        # Trim the dataframe to qualifying games against common 
        # opponents
        df2 = df.loc[(df['OPPONENT']).isin(opps) & (df[qual_var] >= qual_num)]

        # Find the min and max range to compare against
        min_att = df2.loc[df2['GSISPLAYER_ID'] == playerid, filter_var].min()
        max_att = df2.loc[df2['GSISPLAYER_ID'] == playerid, filter_var].max()

        # Trim the dataframe to the min and max range
        df3 = df2[(df2[filter_var] >= min_att) & (df2[filter_var] <= max_att)]

        # Rename non-players to a generic 'Rest of NFL'
        df3.loc[(df3['GSISPLAYER_ID'] != playerid)
                | (df3['ABBREVIATION'] == self.team),
                'PLAYERNAME'] = 'Rest of NFL'

        # Change PLAYERNAME where multiple values exist for 
        # GSISPLAYER_ID
        df3.loc[df3['GSISPLAYER_ID'] == playerid, 'PLAYERNAME']\
                = self.name_df.loc[playerid, 'PLAYERNAME']

        return df3
            
    def cumulative_filter(self, df, playerid, qual_num, qual_var, year):
        # Find qualifying number of attempts
        min_att = self.gamecount(year) * qual_num

        # Find the opponents a player played against
        opps = df.loc[df['GSISPLAYER_ID'] == playerid, 'OPPONENT'].unique()

        # Find all players with qualifying attempts against
        # opposition
        df2 = df.loc[df['OPPONENT'].isin(opps)]\
                .groupby(['GSISPLAYER_ID', 'ABBREVIATION'])\
                .sum()\
                .reset_index()
        df2 = df2.loc[df2[qual_var] >= min_att]

        return df2

    def ttest_iterator(self, df, filter_var, playerid, response_var):
        # Iteratively perform a t-test to determine what number of
        # attempts sees a significant differance between a players
        # performance and that of the rest of the nfl
        data = []
        for i in df[filter_var].sort_values().unique().tolist():
            rvs1 = df.loc[(df[filter_var] <= i)
                          & (df['GSISPLAYER_ID'] == playerid), response_var]
            rvs2 = df.loc[(df[filter_var] <= i)
                          & (df['GSISPLAYER_ID'] != playerid), response_var]
            stat, pvalue = stats.ttest_ind(rvs1, rvs2, equal_var=False)

            # Append t-test results to data list
            data.append((df.loc[df['GSISPLAYER_ID'] == playerid, 'PLAYERNAME']\
                           .iloc[0],
                         i, stat, pvalue, rvs1.mean(), rvs2.mean()))

        # Create dataframe of t-test results and trim to significant
        columns=['Name', filter_var, 'Statistic', 'P-Value', 'PlayerMean',
                 'NFLMean']
        df2 = pd.DataFrame(data, columns=columns)
        df2 = df2[df2['P-Value'] <= .05]
        return df2

    def transform(self, df, cols):
        '''
        Performs data transformation and scores multiple variables
        '''        
        # Calculate the mean and standard deviation
        for c in cols:
            df.loc[:,c + '_mean'] = df.loc[:,c].mean()
        for c in cols:
            df.loc[:,c + '_std'] = df.loc[:,c].std()

        # Find the z-score from the mean and standard deviation
        for c in cols:
            df.loc[:,'z_' + c] = (df.loc[:, c]
                                       - df.loc[:, c + '_mean'])\
                                      / df.loc[:,c + '_std']    
        zcol = ['z_' + c for c in cols]
        df.loc[:,zcol] = df.loc[:,zcol]\
                             .apply(lambda x: stats.norm.cdf(x))
        
        # Trim the dataframe to needed columns
        zcol.append('GSISPLAYER_ID')
        zcol.append('PLAYERNAME')
        df2 = df[zcol].reset_index(drop=True)

        return df2


    def rename_players(self):
        '''
        Class method which renames players who have multiple spellings
        of their name

        Parameters
            df: dataframe
                Dataframe from SQL query

        Returns:
            Renamed dataframe
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_name.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con)
        
        return df.set_index('GSISPLAYER_ID')

    def coach_analysis(self, coachname, startyear, stopyear=2019, startweek=1,
                       stopweek=21):
        '''
        Function which calculates a coach's winning percentage and
        compares it against the winning percentage of other NFL
        coaches against the same opposition

        Parameters:
            coachname: str
                The name of the Head Coach
            startyear: int
                The year the coach started his position
            stopyear: int, optional
                The year the head coach ended his position
            startweek: int, optional
                The week the head coach started his position
            stopweek: int, optional
                The week the head coach ended his position
        Returns:
            Results of a two-tailed Chi-2 test of independence

            A bar graph of a coach's win percentagae record compared
            to the rest of the NFL against the same opposition.

            A time series of a coach's win percentage compared to the
            rest of the NFL against the same opposition.
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_record.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con)

        # Post season is a continuation of regular season
        df.loc[df['SEASONTYPE'] == 'POST', 'WEEK'] = df.loc[df['SEASONTYPE']\
                                                            == 'POST', 'WEEK'\
                                                            ]\
                                                     + 17

        # Sort the dataframe to allow for week|season slicing 
        df = df.sort_values(by=['SEASON', 'WEEK'])\
               .reset_index(drop=True)

        # Find index of start and stop points
        start = df[(df['SEASON'] == startyear) & (df['WEEK'] == startweek)]\
                  .index[0]
        stop = df[(df['SEASON'] == stopyear) & (df['WEEK'] == stopweek)]\
                 .index[-1]

        # Truncate DF to coaches active range
        df = df.iloc[start : stop + 1]

        # Iterate through seasons to find common opponents
        df2 = pd.DataFrame()
        for s in df['SEASON'].unique()\
                             .tolist():
            # Find opponents
            schedule = df.loc[(df['SEASON'] == s) & (df['TEAM'] == self.team),
                              'OPPONENT']\
                         .unique()\
                         .tolist()
            # All games against common opponents for each season
            df3 = df[(df['OPPONENT'].isin(schedule)) & (df['SEASON'] == s)]
            df2 = df2.append(df3)

        # Housekeeping tasks
        df2.reset_index(drop=True, inplace=True)
        df2[['LOSSES','TIES','WINS']] = df2[['LOSSES','TIES','WINS']]\
                                           .astype('bool')
        df2.loc[df2['TEAM'] != self.team,'TEAM'] = 'NFL'

        # Find sums for Chi-2 test
        wins = df2.loc[df2['TEAM'] == self.team, 'WINS'].sum()
        losses = df2.loc[df2['TEAM'] == self.team, 'LOSSES'].sum()
        ties = df2.loc[df2['TEAM'] == self.team, 'TIES'].sum()
        oppwins = df2.loc[df2['TEAM'] != self.team, 'WINS'].sum()
        opplosses = df2.loc[df2['TEAM'] != self.team, 'LOSSES'].sum()
        oppties = df2.loc[df2['TEAM'] != self.team, 'TIES'].sum()

        # Create array of sums
        comp = pd.np.array([[wins, losses, ties],
                            [oppwins, opplosses, oppties]])

        # Perform Chi-Sq Test of Independence
        chi2, p, dof, expected = stats.chi2_contingency(comp)

        # Format and prettify
        df2.columns = df2.columns.str.title()
        df2 = df2.melt(id_vars=['Season', 'Team', 'Seasontype', 'Week',
                                'Opponent'])
        df2.rename(columns={'value':'Win Percentage', 'variable':'Result'},
                   inplace=True)
        data = df2[df2['Result'] == 'Wins']

        # Plot Overall Win Pct
        g = sns.barplot(x='Result', y='Win Percentage', hue='Team', data=data,
                        hue_order=[self.team, 'NFL'], ci=None,
                        palette=color_df.loc[self.team])

        # Annotate the plot
        for patch in g.patches:
            g.annotate(format(patch.get_height(), '.1%'),
                       (patch.get_x()
                        + patch.get_width()
                        / 2,
                        patch.get_height()
                        / 2),
                       ha='center', color='white', fontsize=14,
                       family=['sans-serif'], name='Arial')

            # Highlight the bars if significant difference exists
            if p <= .05:
                patch.set_edgecolor('#CCFF00')
                patch.set_linewidth(3)

        # Format the y-axis to show percentage
        g.yaxis.set_major_formatter(PercentFormatter(1))

        # Plot Time Series of Win Pct
        g = plt.figure()
        g = sns.lineplot(x='Season', y='Win Percentage', hue='Team',
                         style='Team', data=data, 
                         palette=color_df.loc[self.team],
                         hue_order=[self.team, 'NFL'],
                         style_order=[self.team, 'NFL'])

        # Limit x-axis to the range of years
        g.set(xticks=list(range(startyear, stopyear+1)))

        # Rotate x-labels for readability with long ranges
        g.set_xticklabels(list(range(startyear, stopyear+1)), rotation=45)

        # Format the y-axis to show percentage
        g.yaxis.set_major_formatter(PercentFormatter(1))

        return (pd.DataFrame(comp, columns=['Wins', 'Losses', 'Ties']), p)

    def gamestat_analysis(self, year):
        '''
        Performs analysis of a team's passing and rushing offense and 
        defense versus their opponents

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Results of a two-tailed t-test for difference in means

            A bar graph of a team's performance in four categories and 
            their opponenent's average performance
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_gamestats.sql',
            'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        data = pd.read_sql(sql=sql_string, con=self.con,
                           params={'year': year})

        # Find the complement statistic in each category
        df = self.complements(data=data)
        
        # Rename columns for pretty graphs
        df.rename(columns={'PASSING_YARDS_OFF': 'Passing Offense',
                           'RUSHING_YARDS_OFF': 'Rushing Offense',
                           'PASSING_YARDS_DEF': 'Passing Defense',
                           'RUSHING_YARDS_DEF': 'Rushing Defense'},
                  inplace=True)

        # Perform t-test
        data = []
        columns = ['Passing Offense', 'Rushing Offense', 'Passing Defense',
                   'Rushing Defense']

        # Iterate through each statistic
        for c in columns:
            statistic, pvalue = stats.\
            ttest_ind(df.loc[df['Abbreviation'] == self.team, c],
                      df.loc[df['Abbreviation'] != self.team, c],
                      equal_var=False)
            data.append((c, statistic, pvalue, 
                        df.loc[df['Abbreviation'] == self.team, c].mean(),
                        df.loc[df['Abbreviation'] != self.team, c].mean()))

        # Create dataframe for t-test observations
        data = pd.DataFrame(data, columns=['Statistic', 'FStatistic',
                                           'PValue', 'TeamMean',
                                           'OpponentMean'])

        # Transform teamstats dataframe for graphing
        df = df.melt(id_vars=['Abbreviation', 'Opponent_Abbreviation',
                              'GAME_ID', 'WEEK'])
        df.rename(columns={'value': 'Yards Per Game', 'variable':'Category'},
                  inplace=True)

        # Plot bar chart
        g = sns.barplot(x='Category', y='Yards Per Game', hue='Abbreviation',
                        data=df, order=columns, hue_order=[self.team, 'NFL'],
                        ci=None, palette=color_df.loc[self.team])

        # Annotate the plots
        for patch in g.patches:
            g.annotate(format(patch.get_height(), '.1f'),
                       (patch.get_x()
                        + patch.get_width()
                        / 2,
                        patch.get_height()
                        / 2),
                       ha='center', color='white')

        # Highlight bars where significant differences occur
        for i, t in enumerate(g.get_xticklabels()):
            if t.get_text() in data.loc[data['PValue']<=.05, 'Statistic']\
                                   .tolist():
                g.patches[i].set_edgecolor('#CCFF00')
                g.patches[i].set_linewidth(3)

        return data

    def conversion_analysis(self,year):
        '''
        Performs analysis of a team's 3rd and 4th down offensive and
        defensive conversion rate and compares against how the rest of
        the NFL fared against common opponents
        
        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Results of a Chi-2 test for independent means
            
            A bar graph of a team's performance in four categories and
            their opponenent's average performance
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_conversion.sql',
                    'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        data = pd.read_sql(sql=sql_string, con=self.con,
                           params={'year': year})

        # Find the complement statistic in each category
        df = self.complements(data=data)

        # Rename columns for pretty graphs
        df.rename(columns={'FOURTH_DOWN_CONVERTED_DEF': '4th Down Defense',
                           'FOURTH_DOWN_CONVERTED_OFF': '4th Down Offense',
                           'THIRD_DOWN_CONVERTED_DEF': '3rd Down Defense',
                           'THIRD_DOWN_CONVERTED_OFF': '3rd Down Offense'},
                  inplace=True)

        # Perform Chi-Sq Test of Independence
        pairs = [('3rd Down Offense', 'THIRD_DOWN_FAILED_OFF'),
                 ('3rd Down Defense', 'THIRD_DOWN_FAILED_DEF'),
                 ('4th Down Offense', 'FOURTH_DOWN_FAILED_OFF'),
                 ('4th Down Defense', 'FOURTH_DOWN_FAILED_DEF')]

        # Perform Chi-2 test
        data = []

        # Iterate through each statistic and find sums for Chi-2
        for k,v in pairs:
            conv = df.loc[df['Abbreviation'] == self.team, k].sum()
            fail = df.loc[df['Abbreviation'] == self.team, v].sum()
            oppconv = df.loc[df['Abbreviation'] != self.team, k].sum()
            oppfail = df.loc[df['Abbreviation'] != self.team, v].sum()
            
            # Create array of sums
            comp = pd.np.array([[conv, fail], [oppconv, oppfail]])

            # Chi-2 test and append to list
            chi2, p, dof, expected = stats.chi2_contingency(comp)
            data.append((k, chi2, p, dof, expected))

        # Create dataframe of test results
        data = pd.DataFrame(data, columns=['Situation', 'TestStatistic',
                                           'PValue', 'dof', 'expected'])

        # Transform conversion rate dataframe for graphing
        df = df[['4th Down Defense', '4th Down Offense', '3rd Down Defense',
                '3rd Down Offense', 'Abbreviation', 'Opponent_Abbreviation',
                'NFL_GAME_PLAYSTATS_ID', 'WEEK']]\
               .melt(id_vars=['Abbreviation', 'Opponent_Abbreviation',
                              'NFL_GAME_PLAYSTATS_ID', 'WEEK'])
        df.dropna(inplace=True)
        df.rename(columns={'value': 'Conversion Rate', 
                           'variable': 'Category'}, inplace=True)

        order = ['3rd Down Offense', '3rd Down Defense', '4th Down Offense',
                 '4th Down Defense']

        # Plot bar chart
        g = sns.barplot(x='Category', y='Conversion Rate', hue='Abbreviation',
                        data=df, order=order, hue_order=[self.team, 'NFL'], 
                        ci=None, palette=color_df.loc[self.team])

        # Annotate the plot
        for patch in g.patches:
            g.annotate(format(patch.get_height(), '.1%'),
                       (patch.get_x()
                       + patch.get_width()
                       / 2,
                       patch.get_height()
                       / 2), 
                       ha='center', color='white')
        
        # Format the y-axis to show percentage
        g.yaxis.set_major_formatter(PercentFormatter(1))

        # Highlight bars where significant differences occur
        for i, t in enumerate(g.get_xticklabels()):
            if t.get_text() in data.loc[data['PValue'] <= .05, 'Situation']\
                                   .tolist():
                g.patches[i].set_edgecolor('#CCFF00')
                g.patches[i].set_linewidth(3)

        return pd.DataFrame(data) 

    def return_analysis(self, year):
        '''
        Performs analysis of a team's kicking and punting returns and
        coverage versus hwo the rest of the NFL fared against common
        opponents

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Results of a two-tailed t-test for difference in means

            A bar graph of a team's performance in four categories and 
            their opponenent's average performance
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_return.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        data = pd.read_sql(sql=sql_string, con=self.con,
                           params={'year': year})

        # Find the complement statistic in each category
        df = self.complements(data=data)

        # Rename columns for pretty graphs
        df.rename(columns={'KICK_RETURN_YARDS_OFF': 'Kick Returns',
                           'PUNT_RETURN_YARDS_OFF': 'Punt Returns',
                           'KICK_RETURN_YARDS_DEF': 'Kick Coverage',
                           'PUNT_RETURN_YARDS_DEF': 'Punt Coverage'},
                  inplace=True)

        # Perform t-test
        data = []
        columns = ['Kick Returns', 'Punt Returns', 'Kick Coverage',
                   'Punt Coverage']

        # Iterate through each statistic
        for c in columns:
            statistic, pvalue = stats.ttest_ind(df.loc[df['Abbreviation']
                                                       == self.team, c]
                                                  .dropna(),
                                                df.loc[df['Abbreviation']
                                                       != self.team, c]
                                                  .dropna(), equal_var=False)
            data.append((c, statistic, pvalue, 
                         df.loc[df['Abbreviation']==self.team, c].dropna()\
                                                                 .mean(),
                         df.loc[df['Abbreviation']!=self.team, c].dropna()\
                                                                 .mean()))

        # Create dataframe of test statistics
        data = pd.DataFrame(data, columns=['Statistic', 'FStatistic',
                                           'PValue', 'TeamMean',
                                           'OpponentMean'])

        # Transform return and coverage dataframe for graphing
        df = df.melt(id_vars=['Abbreviation', 'Opponent_Abbreviation',
                              'NFL_GAME_PLAYSTATS_ID', 'WEEK'])
        df.rename(columns={'value': 'Yards Per Return',
                           'variable': 'Category'}, inplace=True)

        # Plot bar chart
        g = sns.barplot(x='Category', y='Yards Per Return',
                        hue='Abbreviation', data=df, order=columns,
                        hue_order=[self.team, 'NFL'],
                        ci=None, palette=color_df.loc[self.team])

        # Annotate the plot
        for patch in g.patches:
            g.annotate(format(patch.get_height(), '.1f'),
                       (patch.get_x()
                        + patch.get_width()
                        / 2, 
                       patch.get_height()
                        / 2),
                       ha='center', color='white')

        # Highlight bars where significant differences occur
        for i, t in enumerate(g.get_xticklabels()):
            if t.get_text() in data.loc[data['PValue']<=.05,'Statistic']\
                                   .tolist():
                g.patches[i].set_edgecolor('#CCFF00')
                g.patches[i].set_linewidth(3)

        return data

    def turnover_analysis(self, year):
        '''
        Performs analysis of a team's giveaways and takeaways versus
        how the rest of the NFL fared against common opponents

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Results of a two-tailed t-test for difference in means

            A bar graph of a team's performance in four categories and 
            their opponenent's average performance
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_turnover.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        data = pd.read_sql(sql=sql_string, con=self.con,
                           params={'year': year})

        # Find the complement statistic in each category
        df = self.complements(data=data)

        # Rename columns for pretty graphs
        df.rename(columns={'INTERCEPTIONS_OFF': 'Interceptions Lost',
                           'FUMBLES_OFF': 'Fumbles Lost',
                           'INTERCEPTIONS_DEF': 'Interceptions Forced',
                           'FUMBLES_DEF': 'Fumbles Forced'}, inplace=True)

        # Perform t-test
        data = []
        columns = ['Interceptions Lost', 'Fumbles Lost',
                   'Interceptions Forced', 'Fumbles Forced']

        # Iterate through each statistic
        for c in columns:
            statistic, pvalue = stats.ttest_ind(df.loc[df['Abbreviation']
                                                       == self.team, c]
                                                  .dropna(),
                                                df.loc[df['Abbreviation']
                                                       != self.team, c]
                                                  .dropna(), equal_var=False)
            data.append((c, statistic, pvalue, 
                         df.loc[df['Abbreviation']==self.team, c].dropna()\
                                                                 .mean(),
                         df.loc[df['Abbreviation']!=self.team, c].dropna()\
                                                                 .mean()))

        # Create dataframe of test statistics
        data = pd.DataFrame(data, columns=['Statistic', 'FStatistic',
                                           'PValue', 'TeamMean',
                                           'OpponentMean'])

        # Transform turnover dataframe for graphing
        df = df.melt(id_vars=['Abbreviation', 'Opponent_Abbreviation',
                              'GAME_ID', 'WEEK'])
        df.rename(columns={'value': 'Turnovers Per Game',
                           'variable': 'Category'}, inplace=True)

        # Plot bar chart
        g = sns.barplot(x='Category', y='Turnovers Per Game',
                        hue='Abbreviation', data=df, order=columns,
                        hue_order=[self.team, 'NFL'], ci=None,
                        palette=color_df.loc[self.team])

        # Annotate the plot
        for patch in g.patches:
            g.annotate(format(patch.get_height(), '.2f'),
                       (patch.get_x()
                        + patch.get_width()
                        / 2, 
                       patch.get_height()
                        / 2),
                       ha='center', color='white')

        # Highlight bars where significant differences occur
        for i, t in enumerate(g.get_xticklabels()):
            if t.get_text() in data.loc[data['PValue']<=.05,'Statistic']\
                                   .tolist():
                g.patches[i].set_edgecolor('#CCFF00')
                g.patches[i].set_linewidth(3)

        return data

    def passer_rating(self, year, order=1):
        '''
        Performs analysis of qualified quarterbacks passer rating in
        qualifying games versus the passer rating of other quarterbacks
        in the NFL against common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

            order: int
                The order of a polynomial fit line for regression

        Returns:
            Plot of a quarterbacks attempts by passer rating
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_passing.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Calculate score components of rating
        df.loc[:, 'CmpPct'] = (df.loc [:, 'COMPLETIONS']
                               / df.loc[:, 'ATTEMPTS']
                               - .3)\
                              * 5
        df.loc[:, 'YPA'] = (df.loc [:, 'YARDS']
                            / df.loc[:, 'ATTEMPTS']
                            - 3)\
                           * .25
        df.loc[:, 'TDPct'] = (df.loc [:, 'TOUCHDOWNS']
                              / df.loc[:, 'ATTEMPTS'])\
                             * 20
        df.loc[:, 'INTPct'] = 2.375\
                              - (df.loc [:, 'INTERCEPTIONS']
                                 / df.loc[:, 'ATTEMPTS']
                                 * 25)

        # Set min and max values
        cols = ['CmpPct', 'INTPct', 'TDPct', 'YPA']
        for c in cols:
            df.loc[df[c] > 2.375, c] = 2.375
            df.loc[df[c] < 0, c] = 0

        # Calculate rating
        df.loc[:, 'Rating'] = df.loc[:, cols].sum(axis=1)\
                              / 6\
                              * 100

        df2 = pd.DataFrame()
        
        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=14,
                                      qual_var='ATTEMPTS', year=year)

        for p in players:
            df3 = self.filter_players(df=df, filter_var='ATTEMPTS',
                                      playerid=p, qual_num=14,
                                      qual_var='ATTEMPTS')
            df4 = self.ttest_iterator(df=df3, filter_var='ATTEMPTS',
                                      playerid=p, response_var='Rating')
            df2 = df2.append(df4, sort=True)
            df3.rename(columns={'ATTEMPTS':'Attempts', 'PLAYERNAME':'Name'},
                       inplace=True)

            # Plot regression plot
            palette = color_df.loc[self.team]
            hue_order = [df3.loc[df3['GSISPLAYER_ID'] == p, 'Name'].iloc[0],
                         'Rest of NFL']
            g = sns.lmplot(x='Attempts', y='Rating', data=df3,
                           hue='Name', palette=palette, hue_order=hue_order,
                           legend_out=False, scatter=False, order=order)

            # Only integers on x-axis
            for ax in g.axes[:,0]:
                ax.get_xaxis()\
                  .set_major_locator(MaxNLocator(integer=True))

        return df2
    
    def passer_score(self, year):
        '''
        Performs analysis of qualified quarterbacks passing statistics
        against other quarterbacks in the NFL against common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Percentile plot of quarterbacks statistics
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_passing.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=14,
                                      qual_var='ATTEMPTS', year=year)

        # Iterate through the player list
        for p in players:

            df2 = self.cumulative_filter(df=df, playerid=p, qual_num=14,
                                      qual_var='ATTEMPTS', year=year)

            # Calculate rates
            df2.loc[:,'IntPct'] = 1\
                                  - df2.loc[:,'INTERCEPTIONS']\
                                  / df2.loc[:,'ATTEMPTS']
            df2.loc[:,'SackRate'] = 1\
                                    - df2.loc[:,'SACKS']\
                                    / df2.loc[:,'ATTEMPTS_INC_SACKS']
            df2[['CmpPct', 'YardsPer', 'TDPct']] = df2[['COMPLETIONS',
                                                        'YARDS',
                                                        'TOUCHDOWNS']]\
                                                      .div(df2['ATTEMPTS']
                                                              .values,
                                                           axis=0)

            # Rename non-players to a generic 'Rest of NFL'
            df2.loc[df2['GSISPLAYER_ID'] != p, 'PLAYERNAME'] = 'Rest of NFL'

            df2.loc[df2['GSISPLAYER_ID'] == p, 'PLAYERNAME']\
                = self.name_df.loc[p, 'PLAYERNAME']

            # # Calculate the mean and standard deviation
            df3 = self.transform(df=df2, cols=['CmpPct', 'IntPct', 'SackRate',
                                               'TDPct', 'YardsPer'])

            # Rename columns for pretty graphing
            df3.rename(columns={'PLAYERNAME': 'Name', 'z_IntPct': 'IntPct',
                                'z_CmpPct': 'CmpPct',
                                'z_YardsPer': 'YardsPer', 'z_TDPct': 'TDPct',
                                'z_SackRate': 'SackRate'}, inplace=True)

            # Transform the dataframe for graphing
            df3 = df3.loc[df3['GSISPLAYER_ID'] == p]
            df3 = df3.melt(id_vars=['Name', 'GSISPLAYER_ID'])
            df3.rename(columns={'variable': 'Statistic',
                                'value': 'Percentile'}, inplace=True)

            # Plot bar plot
            palette = sns.light_palette(color_df.loc[self.team, 'primary'],
                                        reverse=True)
            edgecolor = color_df.loc[self.team, 'secondary']
            order = ['CmpPct', 'IntPct', 'SackRate', 'TDPct', 'YardsPer']
            g = plt.figure()
            g = sns.barplot(x='Percentile', y='Statistic', hue='Name',
                            data=df3, order=order, ci=None, palette=palette,
                            edgecolor=edgecolor)

            # Set xlabels on plot
            g.set(xticks=[.16,.5,.84,])
            sns.despine(left=True, bottom=True)
            g.xaxis.set_major_formatter(PercentFormatter(1))

    def rusher_ypa(self, year, order=1):
        '''
        Performs analysis of qualified rushers yards per attempt in
        qualifying games versus the yards per attempt of other rushers
        in the NFL against common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

            order: int
                The order of a polynomial fit line for regression

        Returns:
            Plot of a rusher attempts by YPA
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_rushing.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Calculate YPA
        df.loc[:, 'YPA'] = df.loc [:, 'YARDS'] / df.loc[:, 'ATTEMPTS']

        df2 = pd.DataFrame()
        
        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=6.25,
                                      qual_var='ATTEMPTS', year=year)

        for p in players:
            df3 = self.filter_players(df=df, filter_var='ATTEMPTS',
                                      playerid=p, qual_num=6.25,
                                      qual_var='ATTEMPTS')
            df4 = self.ttest_iterator(df=df3, filter_var='ATTEMPTS',
                                      playerid=p, response_var='YPA')
            df2 = df2.append(df4, sort=True)
            df3.rename(columns={'ATTEMPTS':'Attempts', 'PLAYERNAME':'Name'},
                       inplace=True)

            # Plot regression plot
            palette = color_df.loc[self.team]
            hue_order = [df3.loc[df3['GSISPLAYER_ID'] == p, 'Name'].iloc[0],
                         'Rest of NFL']
            g = sns.lmplot(x='Attempts', y='YPA', data=df3,
                           hue='Name', palette=palette, hue_order=hue_order,
                           legend_out=False, scatter=False, order=order)

            # Only integers on x-axis
            for ax in g.axes[:,0]:
                ax.get_xaxis()\
                  .set_major_locator(MaxNLocator(integer=True))

        return df2
        # return self.rater(df=df, filter_var='ATTEMPTS', qual_num=6.25,
        #                   qual_var='ATTEMPTS', response_var='YPA',
        #                   year=2019)

    def rusher_score(self, year):
        '''
        Performs analysis of qualified rusher rushing statistics
        against other rushers in the NFL with common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Percentile plot of rusher statistics
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_rushing.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=6.25,
                                      qual_var='ATTEMPTS', year=year)

        # Iterate through the player list
        for p in players:
            df2 = self.cumulative_filter(df=df, playerid=p, qual_num=6.25,
                                      qual_var='ATTEMPTS', year=year)

            # Calculate rates
            df2.loc[:,'FumRate'] = 1\
                                  - df2.loc[:,'FUMBLES']\
                                  / df2.loc[:,'ATTEMPTS']
            df2[['YardsPer', 'TDPct']] = df2[['YARDS', 'TOUCHDOWNS']]\
                                          .div(df2['ATTEMPTS'].values, axis=0)

            # Rename non-players to a generic 'Rest of NFL'
            df2.loc[df2['GSISPLAYER_ID'] != p, 'PLAYERNAME'] = 'Rest of NFL'

            df2.loc[df2['GSISPLAYER_ID'] == p, 'PLAYERNAME']\
                = self.name_df.loc[p, 'PLAYERNAME']

            # # Calculate the mean and standard deviation
            df3 = self.transform(df=df2, cols=['FumRate', 'TDPct',
                                               'YardsPer'])

            # Rename columns for pretty graphing
            df3.rename(columns={'PLAYERNAME': 'Name', 'z_FumRate': 'FumRate',
                                'ATTEMPTS': 'Attempts',
                                'z_YardsPer': 'YardsPer', 'z_TDPct': 'TDPct'},
                       inplace=True)
            
            # Transform the dataframe for graphing
            df3 = df3.loc[df3['GSISPLAYER_ID'] == p]
            df3 = df3.melt(id_vars=['Name', 'GSISPLAYER_ID'])
            df3.rename(columns={'variable': 'Statistic',
                                'value': 'Percentile'}, inplace=True)

            # Plot bar plot
            palette = sns.light_palette(color_df.loc[self.team, 'primary'],
                                        reverse=True)
            edgecolor = color_df.loc[self.team, 'secondary']
            order = ['FumRate', 'TDPct', 'YardsPer']
            g = plt.figure()
            g = sns.barplot(x='Percentile', y='Statistic', hue='Name',
                            data=df3, order=order, ci=None,
                            palette=palette, edgecolor=edgecolor)

            # Set xlabels on plot
            g.set(xticks=[.16,.5,.84,])
            sns.despine(left=True, bottom=True)
            g.xaxis.set_major_formatter(PercentFormatter(1))

    def receiver_rating(self, year, order=1):
        '''
        Performs analysis of passer rating when qualified receivers are
        targeted in qualifying games versus the passer rating of other
        targeted receivers in the NFL against common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

            order: int
                The order of a polynomial fit line for regression

        Returns:
            Plot of a passer rating by receiver targets
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_receiving.sql',
                    'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # # Change PLAYERNAME where multiple values exist for 
        # # GSISPLAYER_ID
        # df = self.rename_players(df)

        # Calculate score components of rating
        df.loc[:, 'CmpPct'] = (df.loc [:, 'RECEPTIONS']
                               / df.loc[:, 'TARGETS']
                               - .3)\
                              * 5
        df.loc[:, 'YPA'] = (df.loc [:, 'YARDS']
                            / df.loc[:, 'TARGETS']
                            - 3)\
                           * .25
        df.loc[:, 'TDPct'] = (df.loc [:, 'TOUCHDOWNS']
                              / df.loc[:, 'TARGETS'])\
                             * 20
        df.loc[:, 'INTPct'] = 2.375\
                              - (df.loc [:, 'INTERCEPTIONS']
                                 / df.loc[:, 'TARGETS']
                                 * 25)

        # Set min and max values
        cols = ['CmpPct', 'INTPct', 'TDPct', 'YPA']
        for c in cols:
            df.loc[df[c] > 2.375, c] = 2.375
            df.loc[df[c] < 0, c] = 0

        # Calculate rating
        df.loc[:, 'Rating'] = df.loc[:, cols].sum(axis=1)\
                              / 6\
                              * 100

        df2 = pd.DataFrame()
        
        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=1.875,
                                       qual_var='RECEPTIONS', year=year)

        for p in players:
            df3 = self.filter_players(df=df, filter_var='TARGETS',
                                      playerid=p, qual_num=1.875,
                                      qual_var='RECEPTIONS')
            df4 = self.ttest_iterator(df=df3, filter_var='TARGETS',
                                      playerid=p, response_var='Rating')
            df2 = df2.append(df4, sort=True)
            df3.rename(columns={'TARGETS':'Targets', 'PLAYERNAME':'Name'},
                       inplace=True)

            # Plot regression plot
            palette = color_df.loc[self.team]
            hue_order = [df3.loc[df3['GSISPLAYER_ID'] == p, 'Name'].iloc[0],
                         'Rest of NFL']
            g = sns.lmplot(x='Targets', y='Rating', data=df3,
                           hue='Name', palette=palette, hue_order=hue_order,
                           legend_out=False, scatter=False, order=order)

            # Only integers on x-axis
            for ax in g.axes[:,0]:
                ax.get_xaxis()\
                  .set_major_locator(MaxNLocator(integer=True))

        return df2

        # return self.rater(df=df, filter_var='TARGETS', qual_num=1.875,
        #                   qual_var='RECEPTIONS', response_var='Rating',
        #                   year=2019)

    def receiver_score(self, year):
        '''
        Performs analysis of qualified receiver receiving statistics
        against other receivers in the NFL with common opponents 

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Percentile plot of receiver statistics
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_receiving.sql',
                    'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Find players with a qualifying number of attempts against
        # common opposition
        players = self.get_qualifiers(df=df, qual_num=1.875,
                                      qual_var='RECEPTIONS', year=year)

        # Iterate through the player list
        for p in players:
            df2 = self.cumulative_filter(df=df, playerid=p, qual_num=1.875,
                                      qual_var='RECEPTIONS', year=year)

            # Calculate rates
            df2.loc[:,'FumRate'] = 1\
                                  - df2.loc[:,'FUMBLES']\
                                  / df2.loc[:,'RECEPTIONS']
            df2[['CatchRate', 'YardsPer', 'TDPct']] = df2[['RECEPTIONS', 
                                                           'YARDS',
                                                           'TOUCHDOWNS']]\
                                                         .div(df2['TARGETS']
                                                                 .values,
                                                              axis=0)
            
            # Rename non-players to a generic 'Rest of NFL'
            df2.loc[df2['GSISPLAYER_ID'] != p, 'PLAYERNAME'] = 'Rest of NFL'

            df2.loc[df2['GSISPLAYER_ID'] == p, 'PLAYERNAME']\
                = self.name_df.loc[p, 'PLAYERNAME']

            # # Calculate the mean and standard deviation
            df3 = self.transform(df=df2, cols=['CatchRate', 'FumRate',
                                               'TDPct', 'YardsPer'])

            # Rename columns for pretty graphing
            df3.rename(columns={'PLAYERNAME': 'Name', 'z_FumRate': 'FumRate',
                                'ATTEMPTS': 'Attempts',
                                'z_YardsPer': 'YardsPer', 'z_TDPct': 'TDPct',
                                'z_CatchRate' : 'CatchRate'},
                       inplace=True)
            
            # Transform the dataframe for graphing
            df3 = df3.loc[df3['GSISPLAYER_ID'] == p]
            df3 = df3.melt(id_vars=['Name', 'GSISPLAYER_ID'])
            df3.rename(columns={'variable': 'Statistic',
                                'value': 'Percentile'}, inplace=True)

            # Plot bar plot
            palette = sns.light_palette(color_df.loc[self.team, 'primary'],
                                        reverse=True)
            edgecolor = color_df.loc[self.team, 'secondary']
            order = ['CatchRate', 'FumRate', 'TDPct', 'YardsPer']
            g = plt.figure()
            g = sns.barplot(x='Percentile', y='Statistic', hue='Name',
                            data=df3, order=order, ci=None,
                            palette=palette, edgecolor=edgecolor)

            # Set xlabels on plot
            g.set(xticks=[.16,.5,.84,])
            sns.despine(left=True, bottom=True)
            g.xaxis.set_major_formatter(PercentFormatter(1))

    def kicker_score(self, year):
        '''
        Performs analysis of kicker success rate against other kickers
        in the NFL 

        Parameters:
            year: int
                The year to perform the analysis for

        Returns:
            Regression plot of success rate vs distance
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_kicking.sql', 'r')
        sql_string = file.read()
        
        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Convert field goal result to boolean
        df['ATTEMPTS'] = df['MADE'] + df['MISSED']
        df[['MADE', 'MISSED']] = df[['MADE', 'MISSED']].astype('bool')

        players = self.get_qualifiers(df=df, qual_num=.75,
                                      qual_var='ATTEMPTS', year=year)

        # Iterate through the player list
        for p in players:
            # Rename non-players to a generic 'Rest of NFL'
            df.loc[(df['GSISPLAYER_ID'] != p)
                    | (df['ABBREVIATION'] == self.team),
                    'PLAYERNAME'] = 'Rest of NFL'

            # Change PLAYERNAME where multiple values exist for 
            # GSISPLAYER_ID
            df.loc[df['GSISPLAYER_ID'] == p, 'PLAYERNAME']\
                = self.name_df.loc[p, 'PLAYERNAME']

            # Rename columns for pretty graphing
            df.rename(columns={'ABBREVIATION': 'Team','MADE': 'Accuracy',
                               'YARDS':'Distance', 'PLAYERNAME':'Name'},
                      inplace=True)

            # Plot regression plot
            palette=color_df.loc[self.team]
            hue_order = [df.loc[df['GSISPLAYER_ID'] == p, 'Name'].iloc[0],
                         'Rest of NFL']
            g = sns.lmplot(x='Distance', y='Accuracy', data=df, hue='Name', 
                           palette=palette, hue_order=hue_order, 
                           legend_out=False, scatter=False, logistic=True)

        # Format the y-axis to show percentage
        for ax in g.axes[:,0]:
            ax.yaxis.set_major_formatter(PercentFormatter(1))

    def punter_score(self, year, order):
        '''
        Performs analysis of qualified punters net punting yards
        against net yards of other qualified punters in the nfl

        Parameters:
            year: int
                The year to perform the analysis for

            order: int
                The order of a polynomial fit line for regression

        Returns:
            Plot of a net yards by distance from goal
        '''
        # Open and read the .sql file
        file = open('..\\DepthandTaxes\\DepthandTaxes\\nfl_punting.sql', 'r')
        sql_string = file.read()

        # Convert the sql query to a pandas DataFrame
        df = pd.read_sql(sql=sql_string, con=self.con, params={'year': year})

        # Calculate Net Yards
        df['NetYards'] = df['PUNTYARDS'] - df['RETURNYARDS']

        # Find qualifying number of attempts
        min_att = self.gamecount(year) * .75

        # Calculate total number of attempts for each player
        tot_att = df.groupby('GSISPLAYER_ID')\
                    .count()\
                    .reset_index()

        # Find all qualifying players
        players = tot_att.loc[tot_att['PUNTYARDS'] >= min_att,
                              'GSISPLAYER_ID']

        # Find qualifying players for team
        players = df.loc[(df['ABBREVIATION'] == self.team)
                         & (df['GSISPLAYER_ID'].isin(players)), 'GSISPLAYER_ID']\
                    .unique()

        # Iterate through the player list
        for p in players:

            # Rename non-players to a generic 'Rest of NFL'
            df.loc[(df['GSISPLAYER_ID'] != p)
                    | (df['ABBREVIATION'] == self.team),
                    'PLAYERNAME'] = 'Rest of NFL'

            # Change PLAYERNAME where multiple values exist for 
            # GSISPLAYER_ID
            df.loc[df['GSISPLAYER_ID'] == p, 'PLAYERNAME']\
                = self.name_df.loc[p, 'PLAYERNAME']

            # Rename columns for pretty graphing
            df.rename(columns={'ABBREVIATION': 'Team',
                               'DISTANCE': 'Distance from Goal',
                               'PLAYERNAME': 'Name'}, inplace=True)

            # Plot regression plot
            palette = color_df.loc[self.team]
            hue_order = [df.loc[df['GSISPLAYER_ID'] == p, 'Name'].iloc[0],
                         'Rest of NFL']
            g = sns.lmplot(x='Distance from Goal', y='NetYards', data=df,
                           hue='Name', palette=palette, hue_order=hue_order,
                           legend_out=False, scatter=False, order=order)

            # Only integers n x-axis
            for ax in g.axes[:, 0]:
                ax.get_xaxis()\
                  .set_major_locator(MaxNLocator(integer=True))