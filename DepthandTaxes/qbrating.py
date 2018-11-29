from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import matplotlib.pyplot as plt
import pandas as pd
from math import pi
import seaborn as sns

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/spreadsheets.readonly'
NFLSpread = '1WHcRMJTwwbnYicswXiuPvkjEx1sak5O9GeUj2UiiY6s'
nfl_pal = {'ARI':'#97233F','ATL':'#A71930','BAL':'#241773','BUF':'#00338D','CAR':'#0085CA','CHI':'#0B162A',
'CIN':'#FB4F14','CLE':'#311D00','DAL':'#041E42','DEN':'#FB4F14','DET':'#0076B6','GNB':'#203731','HOU':'#03202F',
'IND':'#002C5F','JAX':'#101820','KAN':'#E31837','LAC':'#002A5E','LAR':'#002244','MIA':'#008E97','MIN':'#4F2683',
'NOR':'#D3BC8D','NWE':'#002244','NYG':'#0B2265','NYJ':'#003F2D','OAK':'#000000','PHI':'#004C54','PIT':'#FFB612',
'SEA':'#002244','SFO':'#AA0000','TAM':'#D50A0A','TEN':'#002A5C','WAS':'#773141'}

week1 = make_df(main(NFLSpread,'Week 1!A1:AE'))
week2 = make_df(main(NFLSpread,'Week 2!A1:AE'))
week3 = make_df(main(NFLSpread,'Week 3!A1:AE'))
week4 = make_df(main(NFLSpread,'Week 4!A1:AE'))
week5 = make_df(main(NFLSpread,'Week 5!A1:AE'))
week6 = make_df(main(NFLSpread,'Week 6!A1:AE'))
week7 = make_df(main(NFLSpread,'Week 7!A1:AE'))
week8 = make_df(main(NFLSpread,'Week 8!A1:AE'))
week9 = make_df(main(NFLSpread,'Week 9!A1:AE'))
week10 = make_df(main(NFLSpread,'Week 10!A1:AE'))
week11 = make_df(main(NFLSpread,'Week 11!A1:AE'))
week12 = make_df(main(NFLSpread,'Week 12!A1:AE'))

def main(SPREADSHEET_ID,RANGE_NAME):
    """Calls Google Sheets API.
    Returns value from QB Stats spreadsheet.
    """
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    service = build('sheets', 'v4', http=creds.authorize(Http()))

    # Call the Sheets API
    result = service.spreadsheets().values().get(spreadsheetId=SPREADSHEET_ID,
                                                range=RANGE_NAME).execute()
    values = result.get('values', [])
    return values

Class QBStats(object):
	def __init__(self,SPREADSHEET_ID, RANGE_NAME):
		self.SPREADSHEET_ID = SPREADSHEET_ID
		self.RANGE_NAME = RANGE_NAME
    
	def zscore(dataframe):
		'''Creates a DataFrame of Passer Rating Components and performs a z transform
		'''
		df = dataframe
		df = pd.DataFrame(df,columns=df[0])
		df = df.iloc[1:]
	#     df['Cmp'] = df['Cmp'].astype('float')
	#     df['Att'] = df['Att'].astype('float')
	#     df['Yds'] = df['Yds'].astype('float')
	#     df['TD'] = df['TD'].astype('float')
	#     df['Int'] = df['Int'].astype('float')
	#     df['G'] = df['G'].astype('float')
		df[['Cmp', 'Att', 'Yds', 'TD', 'Int', 'G']] = df[['Cmp', 'Att', 'Yds', 'TD', 'Int', 'G']].astype('float')
	#     df['CmpPct'] = df['Cmp']/df['Att']
	#     df['YardsPer'] = df['Yds']/df['Att']
	#     df['TDPct'] = df['TD']/df['Att']
		df['IntPct'] = 1 - df['Int']/df['Att']
		df['AttPer'] = df['Att']/df['G']
		df[['CmpPct', 'YardsPer', 'TDPct', 'IntPct']] = df[['Cmp', 'Yds', 'TD']].div(df['Att'].values, axis=0)
		df = df[['Name','Tm','Cmp','Att','Yds','TD','Int','AttPer','CmpPct','YardsPer','TDPct','IntPct']]
		df['Wins'] = df['QBrec'].str.split('-',expand=False)[0]
		df = df[['Name','Tm','Cmp','Att','Yds','TD','Int','AttPer','CmpPct','YardsPer','TDPct','IntPct','Wins']]
		df['z_CmpPct'] = (df.CmpPct - df.CmpPct.mean())/df.CmpPct.std()
		df['z_YardsPer'] = (df.YardsPer - df.YardsPer.mean())/df.YardsPer.std()
		df['z_TDPct'] = (df.TDPct - df.TDPct.mean())/df.TDPct.std()
		df['z_IntPct'] = (df.IntPct - df.IntPct.mean())/df.IntPct.std()
		df['Above'] = (df[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]>=1).sum(1)
		df['Below'] = (df[['z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]<=-1).sum(1)
		df.loc[df['Above'] == 4, 'Cat'] = 'GOAT'
		df.loc[df['Below'] == 4, 'Cat'] = 'Train'
		df.loc[(df['Above'] == 0) & (df['Below'] == 0), 'Cat'] = 'Mediocre'
		df.loc[(df['Above'] >= 1) & (df['Above'] <= 3) & (df['Below'] == 0), 'Cat'] = 'Good'
		df.loc[(df['Above'] >= 1) & (df['Below'] >= 1), 'Cat'] = 'Mixed'
		df.loc[(df['Above'] == 0) & (df['Below'] <= 3) & (df['Below'] >= 1), 'Cat'] = 'Bad'
		df = df[['Name','Tm','Cat','Wins','Rate','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]
		df.reset_index(drop=True,inplace=True)
		return df

def spider(df):
    '''Creates faceted radar charts for Standardized Passing statistics
    '''
    df.reset_index(drop=True,inplace=True)
    categories=list(df)[5:]
    N = len(categories)

    # What will be the angle of each axis in the plot? (we divide the plot / number of variable)
    angles = [n / float(N) * 2 * pi for n in range(N)]
    angles += angles[:1]

    df['Close'] = df['z_CmpPct']
    df1 = df.melt(id_vars=['Name','Tm','Cat','Wins','Rate'])

    map_loc = dict(zip(categories,angles))
    map_loc['Close'] = 0
    df1.variable = df1.variable.map(map_loc)
    
    sns.set_style('whitegrid')

    g = sns.FacetGrid(df1, col='Name', hue="Tm", subplot_kws=dict(projection='polar'), col_wrap=3,
    sharex=False, sharey=False, despine=False, palette=nfl_pal)
    g = (g.map(plt.plot,'variable','value')).set(ylim = (-3,3), xticks = angles[:-1], rlabel_position = 45,
    theta_offset = (pi / 3), theta_direction = -1)
    g = g.map(plt.fill,'variable','value',alpha=.5).set_axis_labels('','')
    g = g.set_xticklabels(['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct'])
    g = g.set_titles('{col_name}')
    plt.tight_layout()
    g.savefig('{}.png'.format(df.iloc[0,3]))

def uniplot(df):
    sns.set_style('darkgrid')
    g = sns.FacetGrid(data=df, sharex=False, sharey=False)
    g.map(plt.hist, 'Rate')
    plt.tight_layout()
    g.savefifg('{}.png'.format()) #TODO
    
    g2 = sns.FacetGrid(data=df, sharex=False, sharey=False)
    g2.map(plt.hist, 'Wins')
    plt.tight_layout()
    g2.savefig('{}.png'.format()) #TODO
    
    df1 = df.melt(id_vars=['Name','Tm','Cat','Wins','Rate'])
    g3 = sns.FacetGrid(data=df1, cols=variable, col_wrap=2, sharex=False, sharey=False)
    g3 = g.map(plt.hist, 'value')
    plt.tight_layout()
    g3.savefig('{}.png'.format()) #TODO
    
def biplot(df):
    sns.set_style('darkgrid')
    df1 = df.melt(id_vars=['Name','Tm','Cat','Wins','Rate'])
    df1.reset_index(inplace=True)
    g = sns.relplot(x='value', y='Wins', data=df1, col='variable', col_wrap=2, kind='scatter')
    g.savefig('{}.png'.format())
    
    g1 = sns.pairplot(df[['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct']])
    g1.savefig('{}.png'.format())
