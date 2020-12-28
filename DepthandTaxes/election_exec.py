import cx_Oracle
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
# import geopandas as gpd
from DepthandTaxes.tools import dattools
from DepthandTaxes.tools import census
import glob
import os
import statsmodels.api as sm
from matplotlib import ticker
from statsmodels.graphics.tsaplots import plot_acf
from matplotlib.ticker import MaxNLocator
from statsmodels.tsa.arima.model import ARIMA

class ColoradoData(object):
    """docstring for ColoradoData"""
    def __init__(self, con):
        self.con = con
        self.data_dict = {'turnout':'co_elections_turnout',
                          'turnout_county':'co_elections_turnout_county',
                          'results':'co_elections_results',
                          'house':'co_elections_house'}

    def etl(self, subject):
        fname = self.data_dict.get(subject)
        file = open('..\\DepthandTaxes\\DepthandTaxes\\{}.sql'.format(fname),
                    'r')
        sql_string = file.read()
        df = pd.read_sql(sql=sql_string, con=self.con)

        return df   

    def calc_lean(self, year, cols):
        by = cols + ['PARTY']
        df = self.etl('results')
        df = df[df['YEAR'].dt.year == year]

        df2 = df.groupby(cols)\
                .sum()\
                .reset_index()
        df2.rename(columns={'VOTES':'TOTALVOTES'}, inplace=True)
        df3 = df.groupby(by=by)\
                .sum()\
                .reset_index()

        df3 = df3.merge(df2, left_on=cols, right_on=cols)
        return df3



    # def censuspull(self):
    #     data = census.CensusData('Colorado')
    #     data.compile_census()
    #     df = data.ratio(level=1)

    #     return df

    def tcc(self, df, var):
        df2 = df.loc[df['YEAR'].dt.year.isin(range(2004,2020,2)),
                     ['YEAR', var]]
        df2.dropna(inplace=True)
        df2['YEAR'] = df2['YEAR'].dt.year

        df2['MA3*'] = df2[var].rolling(3).mean()

        X = df2['YEAR']
        X = sm.add_constant(X)
        y = df2[var]
        model = sm.OLS(y, X)
        results = model.fit()
        df2['TREND*'] = results.predict()

        df3 = df.loc[df['YEAR'].dt.year.isin(range(2005,2021,2)),
                     ['YEAR', var]]
        df3.dropna(inplace=True)
        df3['YEAR'] = df3['YEAR'].dt.year

        df2 = df2.append(df3)

        df2 = df2[['YEAR', var, 'MA3*', 'TREND*']]
        df2 = df2.melt(id_vars='YEAR')
        df2.rename(columns={'variable':'Plot', 'value':var}, inplace=True)

        return df2

    def plot_tcc(self, df, var):
        df = self.tcc(df, var)
        # df['YEAR'] = df['YEAR'].dt.year
        g = sns.lineplot(data=df.dropna(), x='YEAR', y=var, hue='Plot',
                         style='Plot')
        
        if var == 'BALLOTSCAST':
            g.yaxis.set_major_formatter(ticker.StrMethodFormatter('{x:,.0f}'))
        if var in ['TURNOUT', 'DEMLEAN']:
            g.yaxis.set_major_formatter(ticker.PercentFormatter(1))

    def acf_plot(self, df, var):
        df = self.tcc(df, var)

        df2 = df.loc[df['YEAR'].isin(range(2004,2020,2)), ['YEAR', var]]
        df2.dropna(inplace=True)
        df2.set_index('YEAR', inplace=True)

        g = plot_acf(df2[var], adjusted=True, zero=False)
        ax = plt.gca()
        ax.xaxis.set_major_locator(MaxNLocator(integer=True,
                                               nbins=len(df2.index)))

    def forecast_plot(self, df, var):
        df2 = df.loc[df['YEAR'].dt.year.isin(range(2004,2020,2)),
                     ['YEAR', var]]

        df2.dropna(inplace=True)
        df2.set_index('YEAR', inplace=True)

        model = ARIMA(df2[var], order=(0,1,1))
        results = model.fit()
        df2['EXPSMOOTH'] = results.predict()

        df3 = df.loc[df['YEAR'].dt.year.isin(range(2005,2021,2)),
                     ['YEAR', var]]
        df3.dropna(inplace=True)
        df3.set_index('YEAR', inplace=True)
        df2 = df2.append(df3)

        df3 = results.get_forecast().summary_frame()

        df3.reset_index(inplace=True)
        df3.rename(columns={'index':'YEAR', 'mean':'EXPSMOOTH'}, inplace=True)

        df2.reset_index(inplace=True)
        df2 = df2.append(df3[['YEAR', 'EXPSMOOTH']])
        df2 = df2.melt(id_vars='YEAR')
        df2.rename(columns={'variable':'Plot', 'value':var},
                   inplace=True)
        df2 = df2[df2[var] > 0]
        df2['YEAR'] = df2['YEAR'].dt.year

        g = sns.lineplot(data=df2.dropna(), x='YEAR', y=var,
                         hue='Plot', style='Plot')

        if var == 'BALLOTSCAST':
            g.yaxis.set_major_formatter(ticker.StrMethodFormatter('{x:,.0f}'))
        if var in ['TURNOUT', 'DEMLEAN']:
            g.yaxis.set_major_formatter(ticker.PercentFormatter(1))


    def turnout(self):
        df = self.etl('turnout_county')

        state_avg = df['TURNOUT'].mean()
        df['COMP'] = df['TURNOUT'] - state_avg
        df['YEAR'] = df['YEAR'].dt.year

        df = df.style.format({'COMP':'{:+.2%}', 'TURNOUT':'{:.2%}'})

        return df, state_avg

    def partisan_lean(self):
        df = self.etl('results')
        cols = ['OFFICEISSUEJUDGESHIP', 'YEAR']
        
        df = df[~df['OFFICEISSUEJUDGESHIP'].str.contains('District')]
        df = df[~df['OFFICEISSUEJUDGESHIP'].str.contains('DISTRICT')]

        df2 = df.groupby(cols).sum().reset_index()
        df2.rename(columns={'VOTES':'TOTALVOTES'}, inplace=True)
        df3 = df.groupby(['OFFICEISSUEJUDGESHIP', 'PARTY', 'YEAR'])\
                .sum()\
                .reset_index()
        df2 = df2.merge(df3, left_on=cols, right_on=cols)
        df2['PERCENTAGE'] = df2['VOTES'] / df2['TOTALVOTES']
        df2['YEAR'] = df2['YEAR'].dt.year

        hue_order = ['Democratic', 'Republican', 'Minor']
        g = sns.lineplot(data=df2, x='YEAR', y='PERCENTAGE', hue='PARTY',
                         hue_order=hue_order)
        g.yaxis.set_major_formatter(ticker.PercentFormatter(1))

    def county_lean(self):
        df = self.etl('results')
        df = df[df['YEAR'].dt.year == 2018]
        
        cols = ['OFFICEISSUEJUDGESHIP']
        df2 = df.groupby(cols).sum().reset_index()
        df2.rename(columns={'VOTES':'TOTALVOTES'}, inplace=True)
        df3 = df.groupby(['OFFICEISSUEJUDGESHIP', 'PARTY']).sum().reset_index()
        df3 = df3.merge(df2, left_on=cols, right_on=cols)
        df3['STATEPERCENTAGE'] = df3['VOTES'] / df3['TOTALVOTES']
        df3 = df3[['OFFICEISSUEJUDGESHIP', 'PARTY', 'STATEPERCENTAGE']]

        cols2 = ['OFFICEISSUEJUDGESHIP', 'COUNTY']
        df4 = df.groupby(cols2).sum().reset_index()
        df4.rename(columns={'VOTES':'TOTALVOTES'}, inplace=True)
        df5 = df.groupby(['OFFICEISSUEJUDGESHIP', 'PARTY', 'COUNTY'])\
                .sum()\
                .reset_index()
        df5 = df5.merge(df4, left_on=cols2, right_on=cols2)
        df5['PERCENTAGE'] = df5['VOTES'] / df5['TOTALVOTES']
        df5 = df5.merge(df3, left_on=['OFFICEISSUEJUDGESHIP', 'PARTY'],
                        right_on=['OFFICEISSUEJUDGESHIP', 'PARTY'])
        df5['LEAN'] = df5['PERCENTAGE'] - df5['STATEPERCENTAGE']
        df5 = df5[['PARTY', 'COUNTY', 'LEAN']].groupby(['PARTY', 'COUNTY'])\
                                              .mean()\
                                              .reset_index()
        df5 = df5.style.format({'LEAN':'{:+.2%}'})

        return df5

    def partisan_trend(self):
        df = self.etl('results')
        cols = ['OFFICEISSUEJUDGESHIP', 'YEAR']
        df2 = df.groupby(cols).sum().reset_index()
        df2.rename(columns={'VOTES':'TOTALVOTES'}, inplace=True)
        df3 = df.groupby(['OFFICEISSUEJUDGESHIP', 'PARTY', 'YEAR']).sum().reset_index()
        df2 = df2.merge(df3, left_on=cols, right_on=cols)

        df2 = df2.pivot(index=['OFFICEISSUEJUDGESHIP', 'YEAR', 'TOTALVOTES'],
                        columns='PARTY', values='VOTES')\
                 .reset_index()

        df2['DEMLEAN'] = (df2['Democratic'] / df2['TOTALVOTES'])\
                         - (df2['Republican'] / df2['TOTALVOTES'])
        
        df2 = df2.groupby('YEAR')\
                 .mean()\
                 .reset_index()
        return df2

    def predic_prep(self):
        col = 'OFFICEISSUEJUDGESHIP'
        gov = ['GOV./LIEUTENANTGOV.', 'GOVERNOR/LIEUTENANTGOVERNOR']
        pres = ['PRESIDENT/VICEPRESIDENT', 'PRESIDENTIALELECTORS',
                'PRESIDENTIALELECTORS/PRESIDENTIALELECTORS(VICE)']
        reg = ['REGENTOFTHEUNIVERSITYOFCOLORADO-ATLARGE',
               'UOFCREGENT-ATLARGE','UOFCREGENTS-ATLARGE']
        df = self.censuspull()
        df.set_index(['YEAR', 'NAME'], inplace=True)
        
        df2 = self.etl('results')
        repl_dict = {'CONG.DISTRICT': 'USREPDISTRICT0',
                     'REPRESENTATIVETOTHE111THUNITEDSTATESCONGRESS-DISTRICT':\
                     'USREPDISTRICT0',
                     'REPRESENTATIVETOTHE112THUNITEDSTATESCONGRESS-DISTRICT':\
                     'USREPDISTRICT0',
                     'UNITEDSTATESREPRESENTATIVE-DISTRICT':'USREPDISTRICT0'}

        df2[col] = df2[col].apply(lambda x: ''.join(x.split()))
        df2[col] = df2[col].str.upper()
        df2.loc[df2[col].isin(gov), col] = 'GOVERNOR'
        df2.loc[df2[col].isin(pres), col] = 'PRESIDENT'
        df2.loc[df2[col].isin(reg), col] = 'UCREGENT'
        df2.loc[df2[col] == 'TREASURER', col] = 'STATETREASURER'
        df2.loc[df2[col] == 'UNITEDSTATESSENATOR', col] = 'USSENATOR'
        for k, v in repl_dict.items():
            df2[col] = df2[col].str.replace(k, v)


        df2 = df2.groupby(['OFFICEISSUEJUDGESHIP', 'PARTY', 'YEAR'])\
               .sum()\
               .reset_index()

        df2['YEAR'] = df2['YEAR'].dt.year
        to_replace = ['ATTORNEYGENERAL', 'GOVERNOR', 'PRESIDENT', 'UCREGENT',
                      'SECRETARYOFSTATE', 'STATETREASURER', 'USSENATOR']

        office = ['ATTORNEYGENERAL', 'GOVERNOR', 'PRESIDENT',
                  'SECRETARYOFSTATE', 'STATETREASURER', 'UCREGENT',
                  'USREPDISTRICT01', 'USREPDISTRICT02', 'USREPDISTRICT03',
                  'USREPDISTRICT04', 'USREPDISTRICT05', 'USREPDISTRICT06',
                  'USREPDISTRICT07', 'USSENATOR']
        party = ['Democratic', 'Minor', 'Republican']
        year = [2020, 2022, 2024]
        index = pd.MultiIndex.from_product([office, party, year], 
                                           names=['OFFICEISSUEJUDGESHIP',
                                                  'PARTY', 'YEAR'])
        df3 = pd.DataFrame(index=index).reset_index()
        df2 = df2.append(df3)

        df2['NAME'] = df2['OFFICEISSUEJUDGESHIP'].str.replace('USREPDISTRICT',
                                                              '')
        df2.loc[df2['NAME'].isin(to_replace), 'NAME'] = 'Colorado'
        df2.set_index(['YEAR', 'NAME'], inplace=True)


        df = df.join(df2).reset_index()
        # df.dropna(how='any', subset=['45TO64WHITE'], inplace=True)

        df = pd.get_dummies(df, columns=['OFFICEISSUEJUDGESHIP', 'PARTY'])
        df.columns = df.columns.str.upper()
        df.columns = df.columns.str.replace('OFFICEISSUEJUDGESHIP_', '')
        df.columns = df.columns.str.replace('PARTY_', '')        

        return df

    #     df['Year'] = df2['Year'].apply(pd.to_datetime, format='%Y')
    #     df = df[cols]
    #     return df

    # def turnout(self, general=True, level='state'):
    #     df = pd.DataFrame()
    #     years = range(2004,2021)

    #     if general == True:
    #         for y in years:
    #             try:
    #                 df2 = self.transform(y, results=False)
    #                 df = df.append(df2)
    #             except:
    #                 pass

    #     if level == 'state':
    #         df = df.groupby(['Year'])\
    #                .sum()\
    #                .reset_index()

    #     if level == 'county':
    #         df = df.groupby(['County', 'Year'])\
    #                .sum()\
    #                .reset_index()
    #         df['County'] = df['County'].str.title()

    #     df['Active Turnout'] = df['Ballots Cast'] / df['Active Voters']
    #     df['Total Turnout'] = df['Ballots Cast'] / df['Total Voters']
    #     df.replace([np.inf, -np.inf], np.nan, inplace=True)
    #     df.sort_values('Year', inplace=True)

    #     return df

    def ts_plot(self, df, level, var):
        if level != 'state':
            df = df[df['County'] == level]

        df2 = df.loc[df['YEAR'].dt.year.isin(range(2004,2020,2)), ['YEAR', var]]
        df2.dropna(inplace=True)
        df2.reset_index(drop=True, inplace=True)
        df2.index = df2.index + 1

        df2['MA3*'] = df2[var].rolling(3).mean()

        X = df2.index
        X = sm.add_constant(X)
        y = df2[var]
        model = sm.OLS(y, X)
        results = model.fit()
        df2['Trend*'] = results.predict()

        df3 = df.loc[df['Year'].isin(range(2005,2021,2)), ['Year', var]]
        df3.dropna(inplace=True)
        df3.reset_index(drop=True, inplace=True)

        df2 = df2.append(df3)

        df2['Year'] = df2['Year'].apply(pd.to_datetime, format='%Y')
        df2 = df2[['Year', var, 'MA3*', 'Trend*']]
        df2 = df2.melt(id_vars='Year')
        df2.rename(columns={'variable':'Plot', 'value':var},
                   inplace=True)

        g = sns.lineplot(data=df2.dropna(), x='Year', y=var,
                         hue='Plot', style='Plot')
        if level != 'state':
            g.set_title('Time Series of {} in {} County'.format(var, level))
        else:
            g.set_title('Time Series of {} in {}'.format(var, level))
        
        if var == 'Ballots Cast':
            g.yaxis.set_major_formatter(ticker.StrMethodFormatter('{x:,.0f}'))
        if var == 'Total Turnout':
            g.yaxis.set_major_formatter(ticker.PercentFormatter(1))

    # def acf_plot(self, df, level, var):
    #     if level != 'state':
    #         df = df[df['County'] == level]
    #     df2 = df.loc[df['Year'].isin(range(2004,2020,2)), ['Year', var]]
    #     df2['Year'] = df2['Year'].apply(pd.to_datetime, format='%Y')
    #     df2.dropna(inplace=True)
    #     df2.set_index('Year', inplace=True)

    #     g = plot_acf(df2[var], adjusted=True, zero=False)
    #     ax = plt.gca()
    #     ax.xaxis.set_major_locator(MaxNLocator(integer=True))

    # def forecast_plot(self, df, level, var):
    #     if level != 'state':
    #         df = df[df['County'] == level]

    #     df2 = df.loc[df['Year'].isin(range(2004,2020,2)), ['Year', var]]
    #     df2['Year'] = df2['Year'].apply(pd.to_datetime, format='%Y')
    #     df2.dropna(inplace=True)
    #     df2.set_index('Year', inplace=True)

    #     model = ARIMA(df2[var], order=(0,1,1))
    #     results = model.fit()
    #     df2['ExpSmooth'] = results.predict()

    #     df3 = df.loc[df['Year'].isin(range(2005,2021,2)), ['Year', var]]
    #     df3['Year'] = df3['Year'].apply(pd.to_datetime, format='%Y')
    #     df3.dropna(inplace=True)
    #     df3.set_index('Year', inplace=True)
    #     df2 = df2.append(df3)

    #     df3 = results.get_forecast().summary_frame()

    #     df3.reset_index(inplace=True)
    #     df3.rename(columns={'index':'Year', 'mean':'ExpSmooth'}, inplace=True)

    #     df2.reset_index(inplace=True)
    #     df2 = df2.append(df3[['Year', 'ExpSmooth']])
    #     df2 = df2.melt(id_vars='Year')
    #     df2.rename(columns={'variable':'Plot', 'value':var},
    #                inplace=True)
    #     df2 = df2[df2[var] > 0]

    #     g = sns.lineplot(data=df2.dropna(), x='Year', y=var,
    #                      hue='Plot', style='Plot')

    #     if level != 'state':
    #         g.set_title('Forecast of {} in {} County'.format(var, level))
    #     else:
    #         g.set_title('Forecast of {} in {}'.format(var, level))

    #     if var == 'Ballots Cast':
    #         g.yaxis.set_major_formatter(ticker.StrMethodFormatter('{x:,.0f}'))
    #     if var == 'Total Turnout':
    #         g.yaxis.set_major_formatter(ticker.PercentFormatter(1))






    #     #     df2 = pd.DataFrame(columns=columns)
    #     #     df[num_cols] = df[num_cols].apply(pd.to_numeric,
    #     #                                       downcast='integer')
    #     #     for c in nom_cols:
    #     #         df[c] = df[c].str.strip()
    #     #         df[c] = df[c].str.replace('', np.NaN)
    #     #     df['Precinct'] = df['Precinct'].astype('str').str.strip()

    #     #     df2 = df2.append(df)

    #     # for file in glob.glob(os.path.join(path, '*.xlsx')):
    #     #     df = pd.read_excel(file)
    #     #     self.df_dict[file] = df



    # def transform(self, df, df_type, year, general=True):
    #     map_dict = {'Election':'Election Type',
    #                 'Office/Ballot Issue':'Office/Issue/Judgeship'}
    #     df.columns = df.columns.str.strip()

    #     # 2006 and Prior
    #     if df_type == 'turnout':
    #         columns = ['Active Voters', 'Ballots Cast', 'County',
    #                    'Election Type', 'Inactive Voters', 'Party',
    #                    'Precinct', 'State', 'Total Voters', 'Year']
    #         num_cols = ['Active Voters', 'Ballots Cast', 'Inactive Voters',
    #                     'Total Voters', 'Year']
    #         nom_cols = ['County', 'Election Type', 'Party', 'State']
    #         df2 = pd.DataFrame(columns=columns)
    #         df[num_cols] = df[num_cols].apply(pd.to_numeric,
    #                                           downcast='integer')
    #         for c in nom_cols:
    #             df[c] = df[c].str.strip()
    #             df[c] = df[c].str.replace('', np.NaN)
    #         df['Precinct'] = df['Precinct'].astype('str').str.strip()

    #         df2 = df2.append(df)



    #     return df2
    #     df2 = pd.DataFrame(columns=['Candidate/Yes or No', 'County',
    #                                'EarlyVotes', 'Election Type', 'MailVotes',
    #                                'Office/Issue/Judgeship', 'Party',
    #                                'PollVotes', 'Precinct', 'ProvVotes',
    #                                'State', 'Votes', 'Year'])

    #     if year == 2004:
    #         cols = ['County', 'Election', 'State']
    #         for c in cols:
    #             df[c] = df[c].str.strip()
    #             df[c] = df[c].str.replace('', np.NaN)
    #         df['Precinct'] = df['Precinct'].astype('str').str.strip()

    #         df.loc[df['Voting Method'] == 'Early Voting', 'EarlyVotes']\
    #             = df.loc[df['Voting Method'] == 'Early Voting', 'Votes']
    #         df.loc[df['Voting Method'] == 'Early Voting', 'MailVotes']\
    #             = df.loc[df['Voting Method'] == 'Absentee Ballot', 'Votes']
    #         df.loc[df['Voting Method'] == 'Early Voting', 'PollVotes']\
    #             = df.loc[df['Voting Method'] == 'Regular Ballot', 'Votes']
    #         df.loc[df['Voting Method'] == 'Early Voting', 'ProvVotes']\
    #             = df.loc[df['Voting Method'] == 'Provisional Ballot', 'Votes']

    #         cols2 = ['EarlyVotes', 'MailVotes', 'PollVotes', 'ProvVotes',
    #                  'Votes', 'Year']
            
    #         df[cols2] = df[cols2].apply(pd.to_numeric, downcast='integer')

    #         df2 = df2.append(df)

    #     return df2
        
    #     ge_pre = ['2004GeneralPrecinctResults.xlsx', '2005Results.xlsx', 
    #               '2006GeneralPrecinctResults.xlsx',
    #               '2008GeneralPrecinctResults.xlsx',
    #               '2010GeneralPrecinctResults.xlsx']

    #     ge_results = []
    #     for g in ge_pre:
    #         df = pd.read_excel(path + g)
    #         df = self.read_ge(df, 2000)
    #         ge_results.append(df)

    #     self.ge_results = pd.concat(ge_results)



    # def read_ge(self, df, year):
    #     df2 = pd.DataFrame(columns=['State', 'Year', 'Election Type',
    #                                 'Office/Ballot Issue', 'County',
    #                                 'Precinct', 'Votes', 'Party',
    #                                 'Candidate/Yes or No'])

    #     # Dictionary to rename column labels
    #     col_dict = {'Ballot Issue':'Office/Ballot Issue',
    #                 'Ballot Question':'Office/Ballot Issue',
    #                 'Candidate':'Candidate/Yes or No',
    #                 'Candidate Votes':'Votes', 'Election':'Election Type',
    #                 'Issue':'Office/Ballot Issue',
    #                 'Office/Issue/Judgeship':'Office/Ballot Issue',
    #                 'Office/Question':'Office/Ballot Issue',
    #                 'Yes or No':'Candidate/Yes or No'}
        
    #     df.columns = df.columns.str.strip()
    #     df.rename(columns=col_dict, inplace=True)
    #     # df.replace(r'', value=np.NaN, inplace=True)

    #     col = df.select_dtypes('object').columns
    #     for c in col:
    #         df[c] = df[c].str.strip()

    #     df2 = df2.append(df)
    #     return df2
#         # Files name for extraction
#         ge = [, '2011Results.xlsx',
#               '2012GeneralPrecinctLevelResults.xlsx', '2013ElectionResults.xlsx',
#               '2014GeneralPrecinctResults.xlsx', '2015ResultsCountyLevel.xlsx',
#               '2016GeneralResultsPrecinctLevel.xlsx', '2018GEPrecinctLevelResults.xlsx',
#               '2019FinalResults.xlsx']
#         prim = ['2004PrimaryResults', '2006PrimaryResults',
#                 '2008PrimaryResults', '2010PrimaryResults',
#                 '2012PrimaryResults', '2014PrimaryElectionResults',
#                 '2016PrimaryAbstractResults','2018PrimaryResults',
#                 '2020PresPrimaryResultsByCountyFINAL']
#         ge_turn = ['2008GeneralPrecinctTurnout', '2010GeneralPrecinctTurnout',
#                    '2011Turnout', '2012GeneralPrecinctLevelTurnout',
#                    '2013Turnout', '2014GeneralPrecinctTurnout',
#                    '2015TurnoutCountyLevel',
#                    '2016GeneralTurnoutPrecinctLevel',
#                    '2018GEPrecinctLevelTurnout']
#         prim_turn = ['2008PrimaryTurnout', '2010PrimaryTurnout',
#                      '2012PrimaryTurnout', '2014PrimaryTurnout',
#                      '2016PrimaryTurnoutCountyLevel']

#         # General Election Results List
#         list_ge = []

#         # Primary Election Results List
#         list_prim = []

#         # General Election Turnout List
#         list_ge_turn = []

#         # Primary Election Turnout List
#         list_prim_turn = []

#         for file in glob.glob(os.path.join(path, '*.xlsx')):
#             base = os.path.basename(file)
#             f = os.path.splitext(base)[0]
#             excel = '..\\DATFiles\\Elections\\Colorado\\{}'.format(base)

#             df = pd.read_excel(excel)
#             if f in ge:
#                 list_ge.append(df)
#             if f in prim:
#                 list_prim.append(df)
#             if f in ge_turn:
#                 list_ge_turn.append(df)
#             if f in prim_turn:
#                 list_prim_turn.append(df)   

#         self.ge_results = pd.concat(list_ge, sort=True)
#         self.ge_turnout = pd.concat(list_prim, sort=True)
#         self.prim_results = pd.concat(list_ge_turn, sort=True)
#         self.prim_turnout = pd.concat(list_prim_turn, sort=True)

# ['State', 'Year', 'Election', 'Office/Ballot Issue', 'County',
#        'Precinct', 'Votes', 'Party', 'Candidate/Yes or No']


# ['Ballot Issue', 'Ballot Question', 'Candidate', 'Candidate Votes',
#        'Candidate/Yes or No', 'County', 'EarlyVotes', 'Election', 'Election ',
#        'Election Type', 'Issue', 'MailVotes', 'No Votes',
#        'Office/Ballot Issue', 'Office/Issue/Judgeship', 'Office/Question',
#        'Party', 'PollVotes', 'Precinct', 'ProvVotes', 'State', 'Votes', 'Year',
#        'Yes Votes', 'Yes or No']

# ['Candidate', 'Candidate Name', 'County', 'County ', 'County Name',
#        'Election', 'Election Type', 'Office', 'Party', 'State', 'Unnamed: 5',
#        'Votes', 'Votes/Percentage', 'Voting Method', 'Year']

# ['ACTIVE VOTERS', 'Active Voters', 'BALLOTS CAST', 'Ballots Cast',
#        'COUNTY', 'Comments', 'County', 'Election Type', 'Inactive Voters',
#        'PRECINCT', 'Precinct', 'State', 'TURNOUT %', 'Total Voters',
#        'Total Voters Turnout %', 'Turnout', 'Year']

# ['Active Voters', 'ActiveVoters', 'Ballots Cast', 'County',
#        'Election Type', 'Inactive Voters', 'State', 'Total Voters',
#        'Total Voters Turnout %', 'Turnout', 'Votes', 'Year']

                            
class ElectionData(object):
    """docstring for ElectionData"""
    def __init__(self, con):
        self.con = con
        self.url = 'https://api.census.gov/data/2010/dec/sf1?get=P001001,'\
                   'NAME,DIVISION&for=state:*'
        self.df = pd.read_json(self.url)
        self.df.columns = self.df.loc[0]
        self.df = self.df.drop(0)
        self.year_code_list_2010 = ['1', '5', '7', '9', '11', '12']
        self.data = None
    
    def load_results(self):
        df = pd.DataFrame()
        elec_list = ['2000', '2002', '2004', '2006', '2008', '2010', '2012',
                     '2014', '2016', '2018']
        cols = ['DISTRICT', 'STATENAME', 'YEAR']
        cols2 = ['DEMCAN', 'OTHCAN', 'REPCAN']

        for v in elec_list:
            file = open('..\\DepthandTaxes\\DepthandTaxes\\politics_'\
                        '{}_election.sql'.format(v), 'r')
            sql_string = file.read()
            df2 = pd.read_sql(sql=sql_string, con=self.con)
            df = df.append(df2)
        
        df.rename(columns={'GENERALDATE':'YEAR'}, inplace=True)
        df['YEAR'] = df['YEAR'].dt.year

        df2 = df[df['PARTYNAME'] == 'Democratic']
        df2 = df2.groupby(cols).count()
        df2['PARTYNAME'] = 1
        df2.rename(columns={'PARTYNAME':'DEMCAN'}, inplace=True)

        df = df.merge(df2['DEMCAN'], left_on=cols, right_index=True)
        
        df2 = df[df['PARTYNAME'] == 'Republican']
        df2 = df2.groupby(cols).count()
        df2['PARTYNAME'] = 1
        df2.rename(columns={'PARTYNAME':'REPCAN'}, inplace=True)

        df = df.merge(df2['REPCAN'], how='left', left_on=cols,
                      right_index=True)

        df2 = df[df['PARTYNAME'] == 'Other']
        df2 = df2.groupby(cols).count()
        df2['PARTYNAME'] = 1
        df2.rename(columns={'PARTYNAME':'OTHCAN'}, inplace=True)

        df = df.merge(df2['OTHCAN'], how='left', left_on=cols,
                      right_index=True)

        cols2 = ['DEMCAN', 'OTHCAN', 'REPCAN']
        df[cols2] = df[cols2].fillna(0)
        
        self.results_df = df

    def census_pull(self, date_code=None, year=2000):
        race_list = ['1', '2', '3', '4', '5', '6']
        hisp_dict = {'1':'Non-Hispanic', '2':'Hispanic'}
        race_dict = {'1':'White', '2':'Black',
                     '3':'American Indian and Alaska Native', '4':'Asian',
                     '5':'"Native Hawaiian and Other Pacific Islander',
                     '6':'Two or more races'}
        div_dict = {'1':'New England', '2':'Middle Atlantic',
                    '3':'East North Central', '4':'West North Central',
                    '5':'South Atlantic', '6':'East South Central',
                    '7':'West South Central', '8':'Mountain', '9':'Pacific'}

        if year == 2000:
            year_code_list = ['1', '4', '6', '8', '10']
            url = 'https://api.census.gov/data/2000/pep/int_charagegroups?'\
                  + 'get=DATE_,DATE_DESC,DIVISION,GEONAME,HISP,POP,RACE,SEX'\
                  + '&for=state:*&AGEGROUP=22'
            df = pd.read_json(url)
            df.columns = df.loc[0]
            df = df.drop(0)
            df.rename(columns={'GEONAME':'NAME'}, inplace=True)

            url2 = 'https://api.census.gov/data/2000/pep/int_charagegroups?'\
                   + 'get=DATE_,DATE_DESC,DIVISION,GEONAME,HISP,POP,RACE,SEX'\
                   + '&for=state:*&AGEGROUP=26'
            df2 = pd.read_json(url2)
            df2.columns = df2.loc[0]
            df2 = df2.drop(0)
            df2.rename(columns={'GEONAME':'NAME'}, inplace=True)

            df = df.append(df2)
        
            df = df[(df['DATE_'].isin(year_code_list))\
                    & (df['HISP'] != '0')\
                    & (df['RACE'].isin(race_list))\
                    & (df['SEX'] == '0')]

            df['POP'] = df['POP'].apply(pd.to_numeric)
            df['DATE_DESC'] = df['DATE_DESC'].str.extract(r'([0-9\/]+)')
            df['DATE_DESC'] = df['DATE_DESC'].apply(pd.to_datetime)
        
        if year == 2010:
            url = 'https://api.census.gov/data/2019/pep/charagegroups'\
                  + '?get=DATE_DESC,NAME,POP,RACE&for=state:*'\
                  + '&DATE_CODE={}&AGEGROUP=22&AGEGROUP=26'.format(date_code)\
                  + '&HISP!=0&SEX=0'
            df = pd.read_json(url)
            df.columns = df.loc[0]
            df = df.drop(0)

            df = df[df['RACE'].isin(race_list)]
            df['POP'] = df['POP'].apply(pd.to_numeric)
            df['DATE_DESC'] = df['DATE_DESC'].str.extract(r'([0-9\/]+)')
            df['DATE_DESC'] = df['DATE_DESC'].apply(pd.to_datetime)

            df2 = self.df[['NAME','DIVISION']]
            df = df.merge(df2, left_on='NAME', right_on='NAME')

        df['HISP'] = df['HISP'].map(hisp_dict)
        df['RACE'] = df['RACE'].map(race_dict)
        df['DIVISION'] = df['DIVISION'].map(div_dict)
        
        df = df.groupby(['DATE_DESC', 'DIVISION', 'NAME', 'HISP','RACE'])\
               .sum()
        df = df.unstack()\
               .unstack()

        df.columns = df.columns.map(''.join).str.strip()
        df = df.reset_index()
        return df

    def compile_census(self):
        df = pd.DataFrame()
        df = df.append(self.census_pull(year=2000))
        for v in self.year_code_list_2010:
            df = df.append(self.census_pull(date_code=v, year=2010))

        df.rename(columns={'DATE_DESC':'YEAR', 'NAME':'STATENAME'},
                  inplace=True)
        df['YEAR'] = df['YEAR'].dt.year

        self.census_df = df

    def merge_df(self):
        path = '..\\datfiles\\Form2Filer_2020.csv'
        merge_cols = ['STATENAME', 'YEAR']
        incumbents = ['BOOKER, CORY A', 'CAPITO, SHELLEY MOORE MS',
                      'CASSIDY, WILLIAM M', 'COLLINS, SUSAN M',
                      'COONS, CHRISTOPHER A', 'CORNYN, JOHN', 'COTTON, THOMAS',
                      'DAINES, STEVEN', 'DURBIN, RICHARD J', 'ERNST, JONI',
                      'GARDNER, CORY', 'GRAHAM, LINDSEY O',
                      'HYDE-SMITH, CINDY', 'INHOFE, JAMES M SEN',
                      'JONES, DOUG', 'MARKEY, EDWARD JOHN MR',
                      'MCCONNELL, MITCH', 'MERKLEY, JEFFREY ALAN',
                      'PERDUE, DAVID', 'PETERS, GARY', 'REED, JOHN F',
                      'RISCH, JAMES E MR', 'ROUNDS, MIKE', 'SASSE, BENJAMIN E',
                      'SHAHEEN, JEANNE', 'SMITH, TINA', 'SULLIVAN, DAN',
                      'TILLIS, THOM R', 'TRUMP, DONALD J',
                      'WARNER, MARK ROBERT']
        
        sen_can = ['AHLERS, DAN', 'AYYADURAI, SHIVA DR', 
                   'BARRON, STEPHEN BRADLEY', 'BEN DAVID, MERAV',
                   'BILLIOT, BERYL MR', 'BOLLIER, BARBARA', 'BOND, TIFFANY',
                   'BOOKER, CORY A', 'BOURGEOIS, JOHN PAUL',
                   'BRADSHAW, MARQUITA', 'BRAY, SHANNON', 'BROYLES, ABBY',
                   'BUCKLEY, JASON', 'BULLOCK, STEVE', 'BURKE, DANIEL C. MR.',
                   'CAPITO, SHELLEY MOORE MS', 'CASSIDY, WILLIAM M',
                   'COLLINS, SUSAN M', 'COONS, CHRISTOPHER A', 'CORNYN, JOHN',
                   'COTTON, THOMAS', 'CUNNINGHAM, CAL', 'CURRAN, MARK',
                   'DAINES, STEVEN', 'DOANE, RAYMON ANTHONY',
                   'DURBIN, RICHARD J', 'ERNST, JONI', 'ESPY, MICHAEL',
                   'EVANS, STEPHAN', 'FAPARUSI, YOMI DR. SR', 'FARR, JOAN',
                   'FERNANDEZ, VERONICA', 'FLEMING, NATALIE M',
                   'GADE, DANIEL MACARTHUR MR.', 'GARDNER, CORY',
                   'GIDEON, SARA', 'GRAHAM, LINDSEY O', 'GREENFIELD, THERESA',
                   'GROSS, AL DR.', 'HAGERTY, BILL',
                   'HARRINGTON, RICKY DALE MR. JR', 'HARRISON, JAIME',
                   'HAZEL, SHANE', 'HEGAR, MARY JENNINGS MJ',
                   'HERZOG, SUZANNE', 'HICKENLOOPER, JOHN W.',
                   'HILL, GARLAND DEAN II', 'HOFFMAN, MADELYN R',
                   'HYDE-SMITH, CINDY', 'INHOFE, JAMES M SEN', 'JAMES, JOHN',
                   'JANICEK, CHRIS EDWARD MR', 'JOHN, XAN MR.', 'JONES, DOUG',
                   'JORDAN, PAULETTE', 'LEWIS, JASON', 'LINN, MAX MR.',
                   'LUJAN, BEN R', 'LUMMIS, CYNTHIA MARIE', 'MALOUF, DANNY',
                   'MARKEY, EDWARD JOHN MR', 'MARSHALL, ROGER W',
                   'MCCONNELL, MITCH', 'MCGRATH, AMY',
                   'MCKENNON, KERRY DOUGLAS', 'MCLEOD, ELIZABETH D',
                   'MEHTA, RIKIN', 'MERKLEY, JEFFREY ALAN',
                   "MESSNER, BRYANT 'CORKY' S.", 'MURPHY, DUSTIN',
                   "MYERS-MONTGOMERY, JAMAR 'DOC'", 'NESBIT, APRIL',
                   "O'CONNOR, KEVIN J", "O'DONNELL, JUSTIN F",
                   'OSSOFF, T. JONATHAN', 'PERDUE, DAVID', 'PERKINS, ADRIAN',
                   'PERKINS, JO RAE', 'PETERS, GARY', 'PIERCE, ANTOINE',
                   'REED, JOHN F', 'RISCH, JAMES E MR', 'RONCHETTI, MARK',
                   'ROUNDS, MIKE', 'SASSE, BENJAMIN E', 'SAVAGE, LISA JILL',
                   'SHAHEEN, JEANNE', 'SIADEK, EUGENE',
                   'SIGLER, AARON CHARLES DR', 'SMITH, TINA', 'STEWART, RICK',
                   'SULLIVAN, DAN', 'SWEARENGIN, PAULA JEAN',
                   'TAHER, IBRAHIM', 'TILLIS, THOM R', 'TUBERVILLE, THOMAS H',
                   'TURLEY, MARK WILLIAM', 'TURULLOLS-BONILLA, RICARDO',
                   'VERGARA, LUIS ED', 'WALSH, BOB', 'WARNER, MARK ROBERT',
                   'WATERS, ALLEN', 'WENSTRUP, PETER', 'WILSON, WILLIE',
                   'WITZKE, LAUREN ELENA', 'WRITZ, RAY']
        
        pres_can = ['BIDEN, JOSEPH R JR', 'HAWKINS, HOWIE', 'JORGENSEN, JO',
                    'TRUMP, DONALD J']

        parties = ['Democratic Party', 'Republican Party', 'Write-In']

        cols = ['DISTRICT', 'STATENAME', 'YEAR']
        cols2 = ['DEMCAN', 'OTHCAN', 'REPCAN']
        cols3 = ['API', 'APIHISP', 'ASIAN', 'ASIANHISP', 'BLACK', 'BLACKHISP',
                 'CANDIDATENAME', 'DEMCAN', 'DEMPRES', 'DISTRICT', 'DIVISION',
                 'GENERALVOTES', 'INCUMBENTINDICATOR', 'MIDTERM', 'MULTI',
                 'MULTIHISP', 'NATIVE', 'NATIVEHISP', 'OTHCAN', 'PARTYNAME',
                 'REPCAN', 'STATENAME', 'WHITE', 'WHITEHISP', 'YEAR']

        rename_dict={'AMERICANINDIANANDALASKANATIVEHISPANIC':'NATIVEHISP',
                     'AMERICANINDIANANDALASKANATIVENON-HISPANIC':'NATIVE',
                     'ASIANHISPANIC':'ASIANHISP', 'ASIANNON-HISPANIC':'ASIAN',
                     'BLACKHISPANIC':'BLACKHISP', 'BLACKNON-HISPANIC':'BLACK',
                     'NATIVEHAWAIIANANDOTHERPACIFICISLANDERHISPANIC':'APIHISP',
                     'NATIVEHAWAIIANANDOTHERPACIFICISLANDERNON-HISPANIC':'API',
                     'TWOORMORERACESHISPANIC':'MULTIHISP',
                     'TWOORMORERACESNON-HISPANIC':'MULTI',
                     'WHITEHISPANIC':'WHITEHISP', 'WHITENON-HISPANIC':'WHITE'}
        
        df = self.census_df.merge(self.results_df, left_on=merge_cols,
                                  right_on=merge_cols)
        df.columns = df.columns.str.upper()
        df.columns = df.columns.str.replace('POP', '')
        df.columns = df.columns.str.replace(' ', '')
        df.columns = df.columns.str.replace('"', '')
        df.rename(columns=rename_dict, inplace=True)

        df2 = pd.read_csv(path)
        df2 = df2[(df2['CANDIDATE_OFFICE'] == 'President')\
                  | (df2['CANDIDATE_OFFICE'] == 'Senate')]
        df2 = df2[['CANDIDATE_NAME', 'CANDIDATE_OFFICE',
                   'CANDIDATE_OFFICE_STATE', 'CANDIDATE_OFFICE_STATE_CODE',
                   'PARTY']]
        df2.rename(columns={'CANDIDATE_OFFICE':'DISTRICT',
                            'CANDIDATE_OFFICE_STATE':'STATENAME',
                            'CANDIDATE_OFFICE_STATE_CODE':'POSTAL',
                            'PARTY':'PARTYNAME'}, inplace=True)
        df2['YEAR'] = 2019
        df2[['MIDTERM', 'INCUMBENTINDICATOR', 'DEMPRES']] = 0
        df2['GENERALVOTES'] = np.nan
        df2.loc[df2['CANDIDATE_NAME'].isin(incumbents),
                'INCUMBENTINDICATOR'] = 1
        df2.loc[~df2['PARTYNAME'].isin(parties), 'PARTYNAME'] = 'Other'
        df2.loc[df2['PARTYNAME'] == 'Republican Party', 'PARTYNAME']\
            = 'Republican'
        df2.loc[df2['PARTYNAME'] == 'Democratic Party', 'PARTYNAME']\
            = 'Democratic'
        df2.loc[df2['PARTYNAME'] == 'Write-In', 'PARTYNAME'] = 'Write-In'

        df3 = df2[df2['PARTYNAME'] == 'Democratic']
        df3 = df3.groupby(cols).count()
        df3['PARTYNAME'] = 1
        df3.rename(columns={'PARTYNAME':'DEMCAN'}, inplace=True)

        df2 = df2.merge(df3['DEMCAN'], left_on=cols, right_index=True)
        
        df3 = df2[df2['PARTYNAME'] == 'Republican']
        df3 = df3.groupby(cols).count()
        df3['PARTYNAME'] = 1
        df3.rename(columns={'PARTYNAME':'REPCAN'}, inplace=True)

        df2 = df2.merge(df3['REPCAN'], how='left', left_on=cols,
                        right_index=True)

        df3 = df2[df2['PARTYNAME'] == 'Other']
        df3 = df3.groupby(cols).count()
        df3['PARTYNAME'] = 1
        df3.rename(columns={'PARTYNAME':'OTHCAN'}, inplace=True)

        df2 = df2.merge(df3['OTHCAN'], how='left', left_on=cols,
                        right_index=True)

        df2[cols2] = df2[cols2].fillna(0)


        df3 = self.census_df.merge(df2[(df2['DISTRICT'] == 'Senate')\
                                   & (df2['CANDIDATE_NAME'].isin(sen_can))],
                                   left_on=merge_cols, right_on=merge_cols)
        df3.columns = df3.columns.str.upper()
        df3.columns = df3.columns.str.replace('POP', '')
        df3.columns = df3.columns.str.replace(' ', '')
        df3.columns = df3.columns.str.replace('"', '')
        df3.rename(columns=rename_dict, inplace=True)
        df3.rename(columns={'CANDIDATE_NAME':'CANDIDATENAME'}, inplace=True)
        df3['CANDIDATENAME'] = df3['CANDIDATENAME'].str.title()

        df5 = df2[(df2['DISTRICT'] == 'President')\
              & (df2['CANDIDATE_NAME'].isin(pres_can))]
        df5.drop(columns='STATENAME', inplace=True)

        df4 = self.census_df.merge(df5, left_on=['YEAR'], right_on=['YEAR'])
        df4.columns = df4.columns.str.upper()
        df4.columns = df4.columns.str.replace('POP', '')
        df4.columns = df4.columns.str.replace(' ', '')
        df4.columns = df4.columns.str.replace('"', '')
        df4.rename(columns=rename_dict, inplace=True)
        df4.rename(columns={'CANDIDATE_NAME':'CANDIDATENAME'}, inplace=True)
        df4['CANDIDATENAME'] = df4['CANDIDATENAME'].str.title()

        df = df[cols3]
        df3 = df3[cols3]
        df4 = df4[cols3]

        self.data = pd.concat([df, df3, df4])
# census2000 = census.CensusLoad('st-est00int-alldata',kind='group').pretty()
# census2010 = census.CensusLoad('sc-est2017-alldata6').projection()
# df = pd.concat([census2000, census2010],sort=True)
# df.columns = df.columns.str.upper()
# df.drop_duplicates(inplace=True)

# df = df.merge(results.GlobalVariables().df, how='left', left_on='YEAR', right_on='YEAR')
# df.drop(columns=0,inplace=True)

# presge2000 = results.FECLoad('presge',2000).pretty()
# presprim2000 = results.FECLoad('presprim',2000,is_primary=True).pretty()
# pres2000 = presge2000.merge(presprim2000, how='outer', left_on= ['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'], 
# 		right_on=['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'CANDIDATENAME', 'PARTY'])
# sen2000 = results.FECLoad('senate',2000,is_pres=False).pretty()
# house2000 = results.FECLoad('house',2000,is_pres=False,is_house=True).pretty()
# results2000 = pd.concat([pres2000, sen2000, house2000], sort=True)
# results2002 = results.FECLoad('2002fedresults',2002).pretty()
# results2004 = results.FECLoad('federalelections2004',2004).pretty()
# results2006 = results.FECLoad('federalelections2006',2006).pretty()
# results2008 = results.FECLoad('federalelections2008',2008).pretty()
# results2010 = results.FECLoad('federalelections2010',2010).pretty()
# results2012 = results.FECLoad('federalelections2012',2012).pretty()
# results2014 = results.FECLoad('federalelections2014',2014).pretty()
# results2016 = results.FECLoad('federalelections2016',2016).pretty()
# resultsall = pd.concat([results2000,results2002,results2004,results2006,results2008,results2010,results2012,results2014,results2016],sort=True)
# resultsall = results.ElectionAnalytics(resultsall).pretty()

# df = df.merge(resultsall, how='left', left_on=['YEAR','STATE','PARTY','DISTRICT'], right_on=['YEAR','STATE','PARTY','DISTRICT'])

# sns.set_style('darkgrid')
# sns.set_palette('seismic',7)
# political_pal = {'Democratic' : 'C0', 'Republican': 'C6', 'Other': 'g'}

# data = results.AllData(df).response()
# g = sns.FacetGrid(data=data, col='Party', col_wrap=3, sharex=False, sharey=False, hue='Party', palette=political_pal)
# g = g.map(plt.hist, 'Log10(Votes)')
# g.savefig('..\\DATFiles\\pres_uni_response.png')

# sns.set_palette('tab10')
# data = results.AllData(df).cont_var()
# g = sns.FacetGrid(data=data, col='Race', col_wrap=4, sharex=False, sharey=False)
# g = g.map(plt.hist, 'LOG10(Population)')
# g.savefig('..\\DATFiles\\pres_uni_continuous.png')

# data = results.AllData(df).cat_var()
# g = sns.catplot(data=data, x='Division', kind='count', aspect=1.25)
# g.set_xticklabels(rotation=45)
# g.savefig('..\\DATFiles\\pres_uni_categorical.png')

# sns.set_palette('seismic',7)
# data = results.AllData(df).cont_var()
# g = sns.relplot(data=data, col='Party', row='Race', hue='Party', palette=political_pal, x='LOG10(Population)', y='Log10(Votes)')
# g.savefig('..\\DATFiles\\pres_bi_continuous.png')

# sns.set_palette('tab10')
# data = results.AllData(df).train
# data = data[['ASIAN', 'BLACK', 'HAWAIIAN', 'HISPANIC', 'MULTI', 'NATIVE', 'WHITE']]
# data.drop_duplicates(inplace=True)
# data = data.apply(np.log10)
# data.columns = data.columns.str.title()
# g = sns.PairGrid(data)
# g = g.map(plt.scatter, edgecolor="w")
# g.savefig('..\\DATFiles\\corrmatrix.png')
# g2 = sns.FacetGrid(data)
# g2.axes = sns.heatmap(data.corr(), annot=True, annot_kws = {'fontsize': 'small'}, cmap='Blues')
# g2.savefig('..\\DATFiles\\correlations.png')

# sns.set_palette('seismic',7)
# data = results.AllData(df).cat_var()
# g = sns.catplot(data=data, x='Party', y='Log10(Votes)', hue='Party', col='Division', kind='box', col_wrap=3, palette=political_pal)
# g.savefig('..\\DATFiles\\pres_bi_categorical.png')

# data = results.AllData(df).regression(output='fit')
# data.to_html()

# data = results.AllData(df).residuals()
# g = sns.FacetGrid(data, col='Party', hue='Party', palette=political_pal, sharex=False, sharey=False)
# g = g.map(plt.scatter, 'Prelog10(Votes)', 'Residual', edgecolor='w')
# g.savefig('..\\DATFiles\\pres_residuals.png')

# data = results.AllData(df).regression(output='dataframe')
# data = data[['YEAR', 'STATE', 'PARTY', 'ACTUAL VOTES', 'PREDICTED VOTES']].set_index(['YEAR','STATE','PARTY']).unstack().reset_index()

# df1 = data[['YEAR', 'STATE', 'PARTY', 'ACTUAL VOTES', 'PREDICTED VOTES']].set_index(['YEAR','STATE','PARTY']).unstack()
# df1.loc[:,('ACTUAL LEAN','Democratic')] = df1['ACTUAL VOTES','Democratic'] - df1['ACTUAL VOTES','Republican']
# # df1.loc[(df1['ACTUAL VOTES','Democratic'] > df1['ACTUAL VOTES','Republican']),('ACTUAL WINNER','Democratic')] = 1
# df1.loc[:,('PREDICTED LEAN','Democratic')] = df1['PREDICTED VOTES','Democratic'] - df1['PREDICTED VOTES','Republican']
# # df1.loc[(df1['PREDICTED VOTES','Democratic'] > df1['PREDICTED VOTES','Republican']),('PREDICTED WINNER','Democratic')] = 1
# # df1 = df1[['YEAR','STATE','ACTUAL WINNER','PREDICTED WINNER']]
# # df1.loc[:,('LEAN DEM (PREDICTED)')] = df1['PREDICTED VOTES','Democratic'] - df1['PREDICTED VOTES','Republican']
# # df1.reset_index(drop=True)
# df1 = df1.stack().reset_index()
# df1.describe()
# states = gdp.read_file('..\\DATFiles\\tl_2018_us_state.shp')
# df1 = states.merge(df1[df1['PARTY']=='Democratic'], how='left', left_on='NAME', right_on='STATE')
# year = 2016
# united = df1[(df1['NAME']!='Alaska') & (df1['NAME']!='Hawaii') & (df1['YEAR']==year)]
# alaska = df1[(df1['NAME']=='Alaska') & (df1['YEAR']==year)]
# hawaii = df1[(df1['NAME']=='Hawaii') & (df1['YEAR']==year)]
# # united.sort_values('NAME')
# sns.set_style('white')
# # g = sns.FacetGrid(states)
# fig = plt.figure(constrained_layout=True,figsize=(10,4))
# gs = fig.add_gridspec(3, 3)
# ax1 = fig.add_subplot(gs[:,1:4])
# ax2 = fig.add_subplot(gs[0, 0])
# ax3 = fig.add_subplot(gs[1,0])

# # ax1 = plt.subplot(gs[:,1:4])
# ax1.axis('off')
# # ax2 = plt.subplot(gs[0, 0])
# ax2.axis('off')
# # ax3 = plt.subplot(gs[1, 0])
# ax3.axis('off')

# united.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax1, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# alaska.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax2, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# hawaii.plot(cmap='seismic_r', column=('ACTUAL LEAN'),ax=ax3, vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')

# ax2.set_xlim(right=-120)
# # ax.axis('off')
# # fig, ax = plt.subplots(1,figsize=(10,6))
# # united.plot(cmap='seismic_r', column=('PREDICTED LEAN'),ax=ax[1,0], vmin=-4.5e6, vmax=4.5e6, edgecolor='gray')
# # ax.axis('off')
# # fig.colorbar(united)
# # united.plot(cmap='seismic_r', column=('PREDICTED LEAN'), ax=ax[0,1])
# # fig.colorbar('seismic')

