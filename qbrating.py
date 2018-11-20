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

def main(SPREADSHEET_ID,RANGE_NAME):
    """Shows basic usage of the Sheets API.
    Prints values from a sample spreadsheet.
    """
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    service = build('sheets', 'v4', http=creds.authorize(Http()))

    # Call the Sheets API
    #SPREADSHEET_ID = '1WHcRMJTwwbnYicswXiuPvkjEx1sak5O9GeUj2UiiY6s'
    #RANGE_NAME = 'Week 1!A1:AE'
    result = service.spreadsheets().values().get(spreadsheetId=SPREADSHEET_ID,
                                                range=RANGE_NAME).execute()
    values = result.get('values', [])
    return values

NFLSpread = '1WHcRMJTwwbnYicswXiuPvkjEx1sak5O9GeUj2UiiY6s'

# ------- PART 1: Define a function that do a plot for one line of the dataset!

# def make_spider( row, title, color):
#     # number of variable
#     categories=list(df)[3:]
#     N = len(categories)
#
#     # What will be the angle of each axis in the plot? (we divide the plot / number of variable)
#     angles = [n / float(N) * 2 * pi for n in range(N)]
#     angles += angles[:1]
#
#     # Initialise the spider plot
#     ax = plt.subplot(4,4,row+1, polar=True, )
#
#     # If you want the first axis to be on top:
#     ax.set_theta_offset(pi / 2)
#     ax.set_theta_direction(-1)
#
#     # Draw one axe per variable + add labels labels yet
#     plt.xticks(angles[:-1], categories, color='grey', size=8)
#
#     # Draw ylabels
#     ax.set_rlabel_position(45)
#     plt.yticks([-2,-1,0,1,2], ["-2","-1","0","1","2"], color="grey", size=7)
#     plt.ylim(-3,3)
#
#     # Ind1
#     values=df.loc[row].drop(['Name','Tm','Cat']).values.flatten().tolist()
#     values += values[:1]
#     ax.plot(angles, values, color=color, linewidth=2, linestyle='solid')
#     ax.fill(angles, values, color=color, alpha=0.4)
#
#     # Add a title
#     plt.title(title, size=11, color=color, y=1.1)
#     plt.tight_layout()
#
#
# # ------- PART 2: Apply to all individuals
# # initialize the figure
# my_dpi=96
# plt.figure(figsize=(1000/my_dpi, 1000/my_dpi), dpi=my_dpi)
#
# # Create a color palette:
# my_palette = plt.cm.get_cmap("Dark2", len(df.index))
#
# # Loop to plot
# for row in range(0, len(df.index)):
#     make_spider( row=row, title=df.loc[row,'Name']+' '+df.loc[row,'Tm'], color=my_palette(row))

def make_df(dataframe):
    df = dataframe
    df = pd.DataFrame(df,columns=df[0])
    df = df.iloc[1:]
    df['Cmp'] = df['Cmp'].astype('float')
    df['Att'] = df['Att'].astype('float')
    df['Yds'] = df['Yds'].astype('float')
    df['TD'] = df['TD'].astype('float')
    df['Int'] = df['Int'].astype('float')
    df['G'] = df['G'].astype('float')
    df['CmpPct'] = df['Cmp']/df['Att']
    df['YardsPer'] = df['Yds']/df['Att']
    df['TDPct'] = df['TD']/df['Att']
    df['IntPct'] = 1 - df['Int']/df['Att']
    df['AttPer'] = df['Att']/df['G']
    df = df[['Name','Tm','Cmp','Att','Yds','TD','Int','AttPer','CmpPct','YardsPer','TDPct','IntPct']]
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
    df = df[['Name','Tm','Cat','z_CmpPct','z_YardsPer','z_TDPct','z_IntPct']]
    df.reset_index(drop=True,inplace=True)
    return df

week1 = make_df(main(NFLSpread,'Week 1!A1:AE'))
week2 = make_df(main(NFLSpread,'Week 2!A1:AE'))
week3 = make_df(main(NFLSpread,'Week 3!A1:AE'))
week4 = make_df(main(NFLSpread,'Week 4!A1:AE'))
week5 = make_df(main(NFLSpread,'Week 5!A1:AE'))
week6 = make_df(main(NFLSpread,'Week 6!A1:AE'))
week7 = make_df(main(NFLSpread,'Week 7!A1:AE'))
week8 = make_df(main(NFLSpread,'Week 8!A1:AE'))
week9 = make_df(main(NFLSpread,'Week 9!A1:AE'))

sns.set_style('whitegrid')
my_pal = {'ARI':'#97233F','ATL':'#A71930','BAL':'#241773','BUF':'#00338D','CAR':'#0085CA','CHI':'#0B162A',
'CIN':'#FB4F14','CLE':'#311D00','DAL':'#041E42','DEN':'#FB4F14','DET':'#0076B6','GNB':'#203731','HOU':'#03202F',
'IND':'#002C5F','JAX':'#101820','KAN':'#E31837','LAC':'#002A5E','LAR':'#002244','MIA':'#008E97','MIN':'#4F2683',
'NOR':'#D3BC8D','NWE':'#002244','NYG':'#0B2265','NYJ':'#003F2D','OAK':'#000000','PHI':'#004C54','PIT':'#FFB612',
'SEA':'#002244','SFO':'#AA0000','TAM':'#D50A0A','TEN':'#002A5C','WAS':'#773141'}

# # Loop to plot
# for row in range(0, len(df.index)):
#     make_spider( row=row, title=df.loc[row,'Name']+' '+df.loc[row,'Tm'], color=my_palette(row))

def make_spider(df):
    df.reset_index(drop=True,inplace=True)
    categories=list(df)[4:]
    N = len(categories)

    # What will be the angle of each axis in the plot? (we divide the plot / number of variable)
    angles = [n / float(N) * 2 * pi for n in range(N)]
    angles += angles[:1]

    #values=df.loc[0].drop(['Name','Tm','Cat','Rate']).values.flatten().tolist()
    #values += values[:1]

    df['Close'] = df['z_CmpPct']
    df1 = df.melt(id_vars=['Name','Tm','Cat','Rate'])

    map_loc = dict(zip(categories,angles))
    map_loc['Close'] = 0
    df1.variable = df1.variable.map(map_loc)

    g = sns.FacetGrid(df1, col='Name', hue="Tm", subplot_kws=dict(projection='polar'), col_wrap=3,
    sharex=False, sharey=False, despine=False, palette=my_pal)
    g = (g.map(plt.plot,'variable','value')).set(ylim = (-3,3), xticks = angles[:-1], rlabel_position = 45,
    theta_offset = (pi / 3), theta_direction = -1)
    g = g.map(plt.fill,'variable','value',alpha=.5).set_axis_labels('','')
    g = g.set_xticklabels(['z_CmpPct', 'z_YardsPer', 'z_TDPct','z_IntPct'])
    g = g.set_titles('{col_name}')
    plt.tight_layout()
    g.savefig('{}.png'.format(df.iloc[0,3]))