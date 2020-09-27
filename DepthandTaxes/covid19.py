import matplotlib.pyplot as plt
import glob
import os
import pandas as pd
import re
import numpy as np
from scipy.optimize import curve_fit
# import datetime
import seaborn as sns
import matplotlib.dates as mdates
from matplotlib.offsetbox import AnchoredText
from scipy import stats

sns.set_style('whitegrid')

# Global Color Palette Variables
dat_pal = ['#29506D', '#AA3939', '#2D882D', '#AA7939', '#718EA4', '#FFAAAA',
           '#88CC88', '#FFDBAA', '#042037', '#550000', '#004400', '#553100',
           '#496D89', '#D46A6A', '#55AA55', '#D4A76A', '#123652', '#801515',
           '#116611', '#805215']

class CovidTimeSeries(object):
    """docstring for CovidTimeSeries"""
    def __init__(self):
        path = ('..\\COVID-19\\csse_covid_19_data\\UID_ISO_FIPS_LookUp'
                '_Table.csv')
        self.FIPS_df = pd.read_csv(path)

        columns = {'variable':'Date', 'value':'Confirmed'}
        path = ('..\\COVID-19\\csse_covid_19_data\\csse_covid_19_time_series'
                '\\time_series_covid19_confirmed_global.csv')
        self.confirmed_global = pd.read_csv(path)
        id_vars = ['Province/State', 'Country/Region', 'Lat', 'Long']
        self.confirmed_global = self.confirmed_global.melt(id_vars=id_vars)\
                                                     .rename(columns=columns)
        cols = ['Province_State', 'Country_Region', 'Population',
                'Combined_Key']
        lcols = ['Province/State', 'Country/Region']
        rcols = ['Province_State', 'Country_Region']
        self.confirmed_global = self.confirmed_global\
                                    .merge(self.FIPS_df[cols], how='left',
                                        left_on=lcols, right_on = rcols)
        self.confirmed_global.drop(columns=rcols, inplace=True)
        self.confirmed_global.loc[:, 'Date']\
            = self.confirmed_global.loc[:, 'Date'].apply(pd.to_datetime)


        path = ('..\\COVID-19\\csse_covid_19_data\\csse_covid_19_time_series'
                '\\time_series_covid19_confirmed_US.csv')
        self.confirmed_us = pd.read_csv(path)
        id_vars = ['Combined_Key', 'UID', 'iso2', 'iso3', 'code3', 'FIPS',
                   'Admin2', 'Province_State', 'Country_Region', 'Lat',
                   'Long_']
        self.confirmed_us = self.confirmed_us.melt(id_vars=id_vars)\
                                             .rename(columns=columns)
        cols = ['Combined_Key', 'Population']
        lcols = ['Combined_Key']
        rcols = ['Combined_Key']        
        self.confirmed_us = self.confirmed_us.merge(self.FIPS_df[cols],
                                                    how='left', left_on=lcols,
                                                    right_on = rcols)
        self.confirmed_us.loc[:, 'Date']\
            = self.confirmed_us.loc[:, 'Date'].apply(pd.to_datetime)
        
        columns = {'variable':'Date', 'value':'Deaths'}
        path = ('..\\COVID-19\\csse_covid_19_data\\csse_covid_19_time_series'
                '\\time_series_covid19_deaths_global.csv')
        self.deaths_global = pd.read_csv(path)
        id_vars = ['Province/State', 'Country/Region', 'Lat', 'Long']
        self.deaths_global = self.deaths_global.melt(id_vars=id_vars)\
                                               .rename(columns=columns)
        cols = ['Province_State', 'Country_Region', 'Population',
                'Combined_Key']
        lcols = ['Province/State', 'Country/Region']
        rcols = ['Province_State', 'Country_Region']
        self.deaths_global = self.deaths_global.merge(self.FIPS_df[cols],
                                                      how='left',
                                                      left_on=lcols,
                                                      right_on = rcols)
        self.deaths_global.drop(columns=rcols, inplace=True)
        self.deaths_global.loc[:, 'Date']\
            = self.deaths_global.loc[:, 'Date'].apply(pd.to_datetime)


        path = ('..\\COVID-19\\csse_covid_19_data\\csse_covid_19_time_series'
                '\\time_series_covid19_deaths_US.csv')
        self.deaths_us = pd.read_csv(path)
        self.deaths_us = pd.read_csv(path)
        id_vars = ['Combined_Key', 'Population', 'UID', 'iso2', 'iso3',
                   'code3', 'FIPS', 'Admin2', 'Province_State',
                   'Country_Region', 'Lat', 'Long_']
        self.deaths_us = self.deaths_us.melt(id_vars=id_vars)\
                                       .rename(columns=columns)
        self.deaths_us.loc[:, 'Date']\
            = self.deaths_us.loc[:, 'Date'].apply(pd.to_datetime)
        

        columns = {'variable':'Date', 'value':'Recovered'}
        path = ('..\\COVID-19\\csse_covid_19_data\\csse_covid_19_time_series'
                '\\time_series_covid19_recovered_global.csv')
        id_vars = ['Province/State', 'Country/Region', 'Lat', 'Long']        
        self.recovered_global = pd.read_csv(path)
        self.recovered_global = self.recovered_global.melt(id_vars=id_vars)\
                                                     .rename(columns=columns)
        cols = ['Province_State', 'Country_Region', 'Population',
                'Combined_Key']
        lcols = ['Province/State', 'Country/Region']
        rcols = ['Province_State', 'Country_Region']
        self.recovered_global = self.recovered_global\
                                    .merge(self.FIPS_df[cols], how='left',
                                           left_on=lcols, right_on = rcols)
        self.recovered_global.drop(columns=rcols, inplace=True)
        self.recovered_global.loc[:, 'Date']\
            = self.recovered_global.loc[:, 'Date'].apply(pd.to_datetime)
       

class CovidReportGlobal(object):
    '''
    Aggregates Daily Reports and Creates DataFrame with all COVID-19 Data
    
    Parameters:
        None

    Returns:
        DataFrame
    '''
    def __init__(self):
        path = ('..\\COVID-19\\csse_covid_19_data\\UID_ISO_FIPS_LookUp'
                '_Table.csv')
        self.FIPS_df = pd.read_csv(path)
        self.daily_reports = self.compile()

    def compile(self):
        # Create Blank dataframe to add reports to
        df = pd.DataFrame()

        # File path for Daily Situation Reports
        path = '..\\COVID-19\\csse_covid_19_data\\csse_covid_19_daily_reports'
        
        # Iterate through directory and append to DataFrame
        for filename in glob.glob(os.path.join(path, '*.csv')):
            base = os.path.basename(filename)
            f = os.path.splitext(base)[0]
            data = pd.read_csv(filename)
            data.loc[:, 'Date'] = pd.to_datetime(f)
            df = df.append(data, sort=True)        

        df = df.reset_index(drop=True)

        '''
        Iterative approach to find join key for Daily Report and Location data
        Search for keys at the province level first before moving on to the Country level
        '''

        plist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .notnull()), 'Province/State']\
                        .unique()\
                        .tolist()

        pdict = {}
        for p in plist:
            if len(self.FIPS_df[self.FIPS_df['Combined_Key'].str\
                                .contains(p)]) == 1:
                pdict[p] = self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str\
                                            .contains(p), 'Combined_Key']\
                                       .iat[0]
            else:
                pass

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].notnull())\
                         & (df['Province/State'].isin(pdict))]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'Province/State'].map(pdict)

        self.iter1 = pdict

        df.loc[:, 'P/SC/R']\
            = df.loc[:, 'Province/State']\
                + ', '\
                + df.loc[:, 'Country/Region']
        
        plist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .notnull()), 'P/SC/R']\
                        .unique()\
                        .tolist()

        pdict = {}
        for p in plist:
            if p in self.FIPS_df['Combined_Key'].tolist():
                pdict[p] = self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == p,
                                            'Combined_Key']\
                                       .iat[0]
            else:
                pass

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].notnull())\
                         & (df['Province/State'].notnull())\
                         & (df['P/SC/R'].isin(pdict))]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'P/SC/R'].map(pdict)

        self.iter2 = pdict

        df = df\
                                 .join(df['Province/State']\
                                           .str\
                                           .split(' County,', expand=True)\
                                           .add_prefix('key'))

        plist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                    .notnull())
                             & (df['Province/State']\
                                    .notnull())
                             & (df['key1']\
                                    .notnull()), 'key0']\
                        .unique()\
                        .tolist()
        
        pdict = {}
        for p in plist:
            if len(self.FIPS_df[self.FIPS_df['Combined_Key'].str\
                                .contains(p)]) == 1:
                pdict[p] = self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str\
                                            .contains(p), 'Combined_Key']\
                                       .iat[0]
            else:
                pass

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].notnull())\
                         & (df['Province/State'].notnull())\
                         & (df['key0'].isin(pdict))]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'key0'].map(pdict)

        self.iter3 = pdict

        plist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .notnull()), 'Province/State']\
                        .unique()\
                        .tolist()

        self.iter4 = plist

        pdict = {'Chicago':'Cook, Illinois, US', 'Bavaria':'Bayern, Germany',
                 'Chicago, IL':'Cook, Illinois, US',
                 'Boston, MA':'Suffolk, Massachusetts, US',
                 'Los Angeles, CA':'Los Angeles, California, US',
                 'Orange, CA':'Orange, California, US',
                 'Santa Clara, CA':'Santa Clara, California, US',
                 'Seattle, WA':'King, Washington, US',
                 'Tempe, AZ':'Maricopa, Arizona, US',
                 'San Benito, CA':'San Benito, California, US',
                 'Toronto, ON':'Ontario, Canada',
                 'London, ON':'Ontario, Canada',
                 'Madison, WI':'Dane, Wisconsin, US',
                 # 'Cruise Ship',
                 'Diamond Princess cruise ship':'Diamond Princess',
                 'San Antonio, TX':'Bexar, Texas, US',
                 'Ashland, NE':'Saunders, Nebraska, US',
                 'Travis, CA':'Solano, California, US',
                 'From Diamond Princess':'Diamond Princess',
                 'Lackland, TX':'Bexar, Texas, US',
                 # 'None',
                 'Humboldt County, CA':'Humboldt, California, US',
                 'Omaha, NE (From Diamond Princess)':'Diamond Princess, US',
                 'Travis, CA (From Diamond Princess)':'Diamond Princess, US',
                 'Lackland, TX (From Diamond Princess)':'Diamond Princess, US',
                 'Unassigned Location (From Diamond Princess)':'Diamond Princess',
                 ' Montreal, QC':'Quebec, Canada',
                 'Portland, OR':'Multnomah, Oregon, US',
                 'Providence, RI':'Providence, Rhode Island, US',
                 'King County, WA':'King, Washington, US',
                 'Cook County, IL':'Cook, Illinois, US',
                 'Hillsborough, FL':'Hillsborough, Florida, US',
                 'New York City, NY':'New York City, New York, US',
                 'San Mateo, CA':'San Mateo, California, US',
                 'Sarasota, FL':'Sarasota, Florida, US',
                 'Umatilla, OR':'Umatilla, Oregon, US',
                 'Fulton County, GA':'Fulton, Georgia, US',
                 'Washington County, OR':'Washington, Oregon, US',
                 ' Norfolk County, MA':'Norfolk, Massachusetts, US',
                 'Berkeley, CA':'Alameda, California, US',
                 'Orange County, CA':'Orange, California, US',
                 'Harris County, TX':'Harris, Texas, US',
                 'Clark County, NV':'Clark, Nevada, US',
                 'Grant County, WA':'Grant, Washington, US',
                 'Queens County, NY':'Queens, New York, US',
                 'Williamson County, TN':'Williamson, Tennessee, US',
                 'New York County, NY':'New York City, New York, US',
                 'Unassigned Location, WA':'Unassigned, Washington, US',
                 'Montgomery County, MD':'Montgomery, Maryland, US',
                 'Suffolk County, MA':'Suffolk, Massachusetts, US',
                 'Summit County, CO':'Summit, Colorado, US',
                 'Calgary, Alberta':'Alberta, Canada',
                 'Chatham County, NC':'Chatham, North Carolina, US',
                 'Delaware County, PA':'Delaware, Pennsylvania, US',
                 'Douglas County, NE':'Douglas, Nebraska, US',
                 'Fayette County, KY':'Fayette, Kentucky, US',
                 'Floyd County, GA':'Floyd, Georgia, US',
                 'Marion County, IN':'Marion, Indiana, US',
                 'Middlesex County, MA':'Middlesex, Massachusetts, US',
                 'Nassau County, NY':'Nassau, New York, US',
                 'Norwell County, MA':'Plymouth, Massachusetts, US',
                 'Ramsey County, MN':'Ramsey, Minnesota, US',
                 'Wayne County, PA':'Wayne, Pennsylvania, US',
                 # 'Grand Princess Cruise Ship',
                 'Douglas County, CO':'Douglas, Colorado, US',
                 'Fairfield County, CT':'Fairfield, Connecticut, US',
                 'Lee County, FL':'Lee, Florida, US',
                 'Edmonton, Alberta':'Alberta, Canada',
                 'Clark County, WA':'Clark, Washington, US',
                 'Davis County, UT':'Davis, Utah, US',
                 'El Paso County, CO':'El Paso, Colorado, US',
                 'Jackson County, OR ':'Jackson, Oregon, US',
                 'Jefferson County, WA':'Jefferson, Washington, US',
                 'Pierce County, WA':'Pierce, Washington, US',
                 'Plymouth County, MA':'Plymouth, Massachusetts, US',
                 'Santa Cruz County, CA':'Santa Cruz, California, US',
                 'Montgomery County, TX':'Montgomery, Texas, US',
                 'Norfolk County, MA':'Norfolk, Virginia, US',
                 'Montgomery County, PA':'Montgomery, Pennsylvania, US',
                 'Fairfax County, VA':'Fairfax, Virginia, US',
                 'Rockingham County, NH':'Rockingham, New Hampshire, US',
                 'Washington, D.C.':'District of Columbia, District of Columbia ,US',
                 'Davidson County, TN':'Davidson, Tennessee, US',
                 'Douglas County, OR':'Douglas, Oregon, US',
                 'Johnson County, KS':'Johnson, Kansas, US',
                 'Marion County, OR':'Marion, Oregon, US',
                 'Polk County, GA':'Polk, Georgia, US',
                 'Shelby County, TN':'Shelby, Tennessee, US',
                 'St. Louis County, MO':'St. Louis, Missouri, US',
                 'Suffolk County, NY':'Suffolk, New York, US',
                 'Unassigned Location, VT':'Unassigned, Vermont, US',
                 'Unknown Location, MA':'Unassigned, Massachusetts, US',
                 'Johnson County, IA':'Johnson, Iowa, US',
                 'Harrison County, KY':'Harrison, Kentucky, US',
                 'Charlotte County, FL':'Charlotte, Florida, US',
                 'Cherokee County, GA':'Cherokee, Georgia, US',
                 'Collin County, TX':'Collin, Texas, US',
                 'Jefferson County, KY':'Jefferson, Kentucky, US',
                 'Jefferson Parish, LA':'Jefferson, Louisiana, US',
                 'France':'France', 'Diamond Princess':'Diamond Princess',
                 'UK':'United Kingdom', 'Denmark':'Denmark',
                 'United Kingdom':'United Kingdom',
                 'Fench Guiana':'French Guiana, France',
                 'Virgin Islands, U.S.':'Virgin Islands, US',
                 'Netherlands':'Netherlands',
                 'United States Virgin Islands':'Virgin Islands, US',
                 'US':'US'}

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].notnull())\
                         & (df['Province/State'].isin(pdict))]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'Province/State'].map(pdict)

        plist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .notnull()), 'Province/State']\
                        .unique()\
                        .tolist()

        self.iter5 = plist

        clist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .isnull()), 'Country/Region']\
                        .unique()\
                        .tolist()

        self.iter6 = clist

        cdict = {}
        for c in clist:
            if len(self.FIPS_df[self.FIPS_df['Combined_Key'].str\
                                .contains(c)]) == 1:
                cdict[c] = self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str\
                                            .contains(c), 'Combined_Key']\
                                       .iat[0]
            else:
                pass

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].isin(cdict))\
                         & (df['Province/State'].isnull())]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'Country/Region'].map(cdict)

        clist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .isnull()), 'Country/Region']\
                        .unique()\
                        .tolist()

        self.iter7 = clist

        cdict = {}
        for c in clist:
            if c in self.FIPS_df['Combined_Key'].tolist():
                cdict[c] = self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == c,
                                            'Combined_Key']\
                               .iat[0]
            else:
                pass

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].isin(cdict))\
                         & (df['Province/State'].isnull())]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'Country/Region'].map(cdict)

        clist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .isnull()), 'Country/Region']\
                        .unique()\
                        .tolist()

        self.iter8 = clist

        cdict = {'South Korea':'Korea, South', 'Ivory Coast':"Cote d'Ivoire",
                 'UK':'United Kingdom', ' Azerbaijan':'Azerbaijan', 
                 'North Ireland':'United Kingdom', 'Czech Republic':'Czechia',
                 'Palestine':'West Bank and Gaza', 'Vatican City':'Holy See',
                 'Republic of Ireland':'Ireland',
                 'Iran (Islamic Republic of)':'Iran', 
                 'Republic of Korea':'Korea, South', 'Viet Nam':'Vietnam',
                 'occupied Palestinian territory':'West Bank and Gaza',
                 'Russian Federation':'Russia',
                 'Republic of Moldova':'Moldova',
                 'Saint Martin':'St Martin, France',
                 'Jersey':'Channel Islands, United Kingdom',
                 'Republic of the Congo':'Congo (Brazzaville)',
                 'The Bahamas':'Bahamas', 'The Gambia':'Gambia',
                 'Gambia, The':'Gambia', 'Bahamas, The':'Bahamas',
                 'Cape Verde':'Cabo Verde', 'East Timor':'Timor-Leste'}

        ndx = df\
                  .index[(df['Combined_Key'].isnull())\
                         & (df['Country/Region'].isin(cdict))\
                         & (df['Province/State'].isnull())]\
                  .tolist()

        df.loc[ndx, 'Combined_Key']\
            = df.loc[ndx, 'Country/Region'].map(cdict)

        clist = df\
                        .loc[(df['Combined_Key'].isnull())\
                             & (df['Country/Region']\
                                .notnull())
                             & (df['Province/State']\
                                .isnull()), 'Country/Region']\
                        .unique()\
                        .tolist()
        
        self.iter9 = clist

        cols = ['Combined_Key', 'Confirmed', 'Date', 'Deaths', 'Recovered']
        return df[cols]

class CovidReportRegion(CovidReportGlobal):
    '''
    Report of Coronavirus activity broken down to regional levels

    Parameters:

    '''
    def __init__(self):
        super().__init__()
        self.cols = ['Combined_Key', 'FIPS', 'Lat', 'Long_', 'Country_Region',
                     'Province_State', 'Admin2']
        self.df = self.daily_reports.merge(self.FIPS_df[self.cols],
                                           how='left', left_on='Combined_Key',
                                           right_on='Combined_Key')
        self.country_data = self.compile_country()
        self.state_data = self.compile_state()
        self.county_data = self.compile_county()

    def compile_country(self):

        df = self.df
        df = df.groupby(['Country_Region', 'Date'])\
                .sum()\
                .reset_index()


        df.rename(columns={'Lat':'Latitude',
                           'Long_':'Longitude',
                           'Country_Region':'Country/Region'}, inplace=True)

        # Calculate active cases
        df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
                                - df.loc[:, 'Deaths']\
                                - df.loc[:, 'Recovered']

        df = df.merge(self.FIPS_df[['Combined_Key', 'Population']],
                      how='left', left_on='Country/Region',
                      right_on='Combined_Key')
        
        return df

    def compile_state(self):
        
        df = self.df
        df = df.groupby(['Country_Region', 'Province_State', 'Date'])\
                .sum()\
                .reset_index()

        df.rename(columns={'Lat':'Latitude',
                           'Long_':'Longitude',
                           'Country_Region':'Country/Region',
                           'Province_State':'Province/State'}, inplace=True)

        # Calculate active cases
        df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
                                - df.loc[:, 'Deaths']\
                                - df.loc[:, 'Recovered']

        df = df.merge(self.FIPS_df.loc[self.FIPS_df['Admin2'].isnull(),
                      ['Population', 'Country_Region', 'Province_State']],
                      how='left',
                      left_on=['Country/Region', 'Province/State'],
                      right_on=['Country_Region', 'Province_State'])

        return df

    def compile_county(self):
        df = self.df
        df = df.groupby(['Combined_Key','Country_Region', 'Province_State', 'Admin2',
                         'Date'])\
                .sum()\
                .reset_index()


        df.rename(columns={'Lat':'Latitude',
                           'Long_':'Longitude',
                           'Country_Region':'Country/Region',
                           'Province_State':'Province/State'}, inplace=True)

        # Calculate active cases
        df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
                                - df.loc[:, 'Deaths']\
                                - df.loc[:, 'Recovered']
        
        df = df.merge(self.FIPS_df[['Combined_Key', 'Population']], how='left',
                       left_on=['Combined_Key'],
                       right_on=['Combined_Key'])

        return df

class CovidReportLocale(object):
    """docstring for CovidReportLocale"""
    def __init__(self, data, init_date=None, lockdown_date=None,
                 lockdown_end=None):
        self.base = data
        self.lockdown_date = np.datetime64(lockdown_date)
        self.init_date = np.datetime64(init_date)
        self.ifr = .0066
        self.df = self.prep()
        
    def log_func(self, x, L, k, x0, b):
        return L / (1 + np.exp(-k*(x-x0))) + b

    def prep(self):
        df = self.base
        # df.fillna(0, inplace=True)
        
        # Date Variables
        if pd.isnull(self.init_date):     
            init_date = df.loc[df['Confirmed'] >= 1, 'Date'].iat[0]
            df.loc[:, 'Days'] = df.loc[:, 'Date'] - init_date
            df.loc[:, 'Days'] = df.loc[:, 'Days'].dt.days
        else:
            df.loc[:, 'Days'] = df.loc[:, 'Date'] - self.init_date
            df.loc[:, 'Days'] = df.loc[:, 'Days'].dt.days

        # Calculate Case Fatatlity Rate
        df.loc[:, 'CFR'] = df.loc[:, 'Deaths'] / df.loc[:, 'Confirmed']

        # Calculate number of presumed cases based on mortality
        df.loc[:, 'EstimatedInfected'] = df.loc[:, 'Deaths']\
                                           .shift(periods=-14)
        df.loc[:, 'EstimatedInfected'] = df.loc[:, 'EstimatedInfected']\
                                         / self.ifr 
        df.loc[:, 'EstimatedInfected'] = df.loc[:, 'EstimatedInfected']\
                                           .round()

        df['NewConfirmed'] = df['Confirmed'].diff()
        df['NewDeaths'] = df['Deaths'].diff()

        return df
    
    def fit_logcurve(self, variable):
        # Fit Logarithmic Curve to Confirmed Growth Rate
        xdata = self.df.loc[self.df['Days'] > 0, 'Days']
        ydata = self.df.loc[self.df['Days'] > 0, variable]
        p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
        bounds = ([-np.inf, -np.inf, -np.inf, 0], 
                  [np.inf, np.inf, np.inf, np.inf])
        popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
                               bounds=bounds, maxfev=5000)
 
        # Calculate predicted confirmed based on logarithmic fit
        self.df.loc[self.df['Days'] >= 0, 'Predicted{}'.format(variable)]\
            = self.log_func(self.df.loc[self.df['Days'] >= 0, 'Days'],
                            *popt)

    def attack(self):
        # Calculate Uninfected Population and Attack Rate
        self.df.loc[:, 'AtRisk'] = self.df.loc[:, 'Population']\
                              - self.df.loc[:, 'PredictedConfirmed']
        self.df['AtRisk'] = self.df['AtRisk'].shift(1)
        self.df['NewPredicted'] = self.df['PredictedConfirmed'].diff()\
                                                               .round()
        self.df.loc[:, 'AttackRate'] = self.df.loc[:, 'NewPredicted']\
                                  / self.df.loc[:, 'AtRisk']\
                                  * 100000

    def rki_method(self):
        self.df['roll8'] = self.df['NewPredicted'].rolling(8, min_periods=8)\
                                               .sum()
        self.df['roll4'] = self.df['NewPredicted'].rolling(4, min_periods=4)\
                                               .sum()

        self.df.loc[:, 'R_eff'] = self.df.loc[:, 'roll4']\
                                / (self.df.loc[:, 'roll8']
                                    - self.df.loc[:, 'roll4'])

        self.df.drop(columns=['roll4', 'roll8'], inplace=True)

    # def decay_func(self, x, a, b):
    #     return a * np.exp(-b*x)

    # def get_data(self):
    #     '''
    #     Creates filtered data set for specified location
    #     Returns
    #         DataFrame
    #     '''
    #     # Trim DataFrame to location specific
    #     locations = ['Country/Region', 'Province/State', 'Admin2']
    #     if self.location_type in locations:
    #         df = self.daily_reports[self.daily_reports[self.location_type] == self.location]

    #     else:
    #         raise ValueError


        
    #     cols = ['Confirmed', 'Date', 'Deaths', 'Recovered']
    #     df3 = df[cols].groupby('Date')\
    #                   .sum()


    #     # Reset index
    #     df.reset_index(inplace=True)
    #     df.rename(columns={'index':'Date'}, inplace=True)


    #     # Add Population column
    #     df.loc[:, 'Location'] = self.geo_key
    #     df = df.merge(self.FIPS_df[['Combined_Key', 'Population']], 
    #                   left_on='Location', right_on='Combined_Key')

    #     # Calculate active cases
    #     df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
    #                             - df.loc[:, 'Deaths']\
    #                             - df.loc[:, 'Recovered']

    #     # Calculate number of presumed cases based on mortality
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'Deaths']\
    #                                        .shift(periods=-14)
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                      / 0.0066 
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                        .round()

    #     # Calculate Case Fatatlity Rate
    #     df.loc[:, 'CFR'] = df.loc[:, 'Deaths'] / df.loc[:, 'Confirmed']

    #     # Calculate percentage of "true" cases country has discovered
    #     df.loc[:, 'DiscoveryRate'] = df.loc[:, 'Confirmed']\
    #                                  / df.loc[:, 'PresumedInfected']

    #     df.fillna(0, inplace=True)

    #     df.loc[df['PresumedInfected'] == 0, 'PresumedInfected'] = np.NaN

    #     if self.lockdown_date == None:
    #         pass
    #     else:
    #         df['LockdownDays'] = df['Date'] - self.lockdown_date
    #         df['LockdownDays'] = df['LockdownDays'].dt.days

    #     # Fit Logarithmic Curve to Confirmed Growth Rate
    #     xdata = df.loc[df['Days'] > 0, 'Days']
    #     ydata = df.loc[df['Days'] > 0, 'Confirmed']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds, maxfev=5000)
 
    #     # Calculate predicted confirmed based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedConfirmed']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Death Growth Rate
    #     xdata = df.loc[df['Days'] > 0, 'Days']
    #     ydata = df.loc[df['Days'] > 0, 'Deaths']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds, maxfev=5000)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedDeaths']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Calculate At Risk Population and Attack Rate
    #     df.loc[:, 'AtRisk'] = df.loc[:, 'Population']\
    #                           - df.loc[:, 'PredictedConfirmed']
    #     df['AtRisk'] = df['AtRisk'].shift(1)
    #     df['NewConfirmed'] = df['PredictedConfirmed'].diff()
    #     df.loc[:, 'AttackRate'] = df.loc[:, 'NewConfirmed']\
    #                               / df.loc[:, 'AtRisk']

    #     return df

    # def track_hubei(self):
    #     '''
    #     Models the post lockdown growth in the Chinese Province of Hubei for
    #     comparison against other growth rates.
    #     '''

    #     df = self.df[self.df['Province/State'] == 'Hubei']
        
    #     # # Calculate active cases
    #     # df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
    #     #                         - df.loc[:, 'Deaths']\
    #     #                         - df.loc[:, 'Recovered']

    #     # Start of the Lockdown in Hubei Province
    #     start_date = np.datetime64('2020-01-23')

    #     # Calculate days since lockdown start
    #     df.loc[:, 'LockdownDays'] = df.loc[:, 'Date'] - start_date
    #     df.loc[:, 'LockdownDays'] = df.loc[:, 'LockdownDays'].dt.days

    #     # Calculate number of presumed cases based on mortality
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'Deaths']\
    #                                        .shift(periods=-14)
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                      / 0.0066 
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                        .round()

    #     df.fillna(0, inplace=True)

    #     df.loc[df['PresumedInfected'] == 0, 'PresumedInfected'] = np.NaN

    #     # Fit Logarithmic Curve to Hubei Death Growth Rate
    #     xdata = df.loc[df['LockdownDays'] >= 0, 'LockdownDays']
    #     ydata = df.loc[df['LockdownDays'] >= 0, 'Deaths']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['LockdownDays'] >= 0, 'PredictedDeaths']\
    #         = self.log_func(df.loc[df['LockdownDays'] >= 0, 'LockdownDays'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Hubei Confirmed Growth Rate
    #     xdata = df.loc[df['LockdownDays'] >= 0, 'LockdownDays']
    #     ydata = df.loc[df['LockdownDays'] >= 0, 'Confirmed']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)
 
    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['LockdownDays'] >= 0, 'PredictedConfirmed']\
    #         = self.log_func(df.loc[df['LockdownDays'] >= 0, 'LockdownDays'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Hubei Death Growth Rate
    #     xdata = df.loc[(df['LockdownDays'] >= 0)\
    #                    & (df['PresumedInfected'].notnull()), 'LockdownDays']
    #     ydata = df.loc[(df['LockdownDays'] >= 0)\
    #                    & (df['PresumedInfected'].notnull()),
    #                    'PresumedInfected']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # # Calculate predicted deaths based on logarithmic fit
    #     # df.loc[:, 'PredictedPresumed']\
    #     #     = self.log_func(df.loc[:, 'LockdownDays'],
    #     #                     *popt)

    #     # Calculate presumed infected based on moving average
    #     df['PredictedPresumed'] = df['PresumedInfected'].rolling(3)\
    #                                                     .mean()

    #     # Calculate predicted rate of change
    #     df.loc[:, 'DeathChange'] = df.loc[:, 'PredictedDeaths'].pct_change()
    #     df.loc[:, 'ConfirmedChange'] = df.loc[:, 'PredictedConfirmed']\
    #                                      .pct_change()
    #     df.loc[:, 'PresumedChange'] = df.loc[:, 'PredictedPresumed']\
    #                                     .pct_change()

    #     return df

    # def plot_hubei(self):
    #     '''
    #     Plots a time series of infections in Hubei against the polynomial fit
    #     Parameters:
    #         poly: Int
    #             An integer to plot an nth degree polynomial
    #     Returns
    #         Time Series plot
    #     '''

    #     cols = ['Date', 'Deaths', 'PredictedDeaths']
        
    #     # Transform the DataFrame
    #     data = self.hubei[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Deaths',
    #                                            'variable':'Type'
    #                                            })

    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Deaths', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of COVID-19 Deaths in Hubei')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}HubeiPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))

    #     g = plt.figure()

    #     cols = ['Date', 'Confirmed', 'PredictedConfirmed']

    #     # Transform the DataFrame
    #     data = self.hubei[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Cases',
    #                                            'variable':'Type'
    #                                            })
        
    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Cases', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of Confirmed COVID-19 Cases in Hubei')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}HubeiPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))

    #     g = plt.figure()

    #     cols = ['Date', 'PresumedInfected', 'PredictedPresumed']

    #     # Transform the DataFrame
    #     data = self.hubei[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Cases',
    #                                            'variable':'Type'
    #                                            })
        
    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Cases', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of Presumed COVID-19 Cases in Hubei')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}HubeiPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))

    # def track_korea(self):
    #     '''
    #     Models the post lockdown growth in the nation of South Korea for
    #     comparison against other growth rates.

    #     Returns:
    #         A DataFrame of the outbreak in Korea
    #     '''

    #     df = self.df[self.df['Country/Region'].str.contains('Korea')]

    #     df.loc[:, ['Confirmed', 'Deaths', 'Recovered']]\
    #         = df.loc[:, ['Confirmed', 'Deaths', 'Recovered']].fillna(0)
        
    #     # # Calculate active cases
    #     # df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
    #     #                         - df.loc[:, 'Deaths']\
    #     #                         - df.loc[:, 'Recovered']

    #     # Start of the Virus in South Korea
    #     init_date = np.datetime64('2020-01-20')

    #     # Calculate days since Initial Infection
    #     df.loc[:, 'Days'] = df.loc[:, 'Date'] - init_date
    #     df.loc[:, 'Days'] = df.loc[:, 'Days'].dt.days

    #     # Calculate number of presumed cases based on mortality
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'Deaths']\
    #                                        .shift(periods=-14)
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                      / 0.0066 
    #     df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
    #                                        .round() 

    #     # Fit Logarithmic Curve to Korea Death Growth Rate
    #     xdata = df.loc[df['Days'] >= 0, 'Days']
    #     ydata = df.loc[df['Days'] >= 0, 'Deaths']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedDeaths']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Korea Confirmed Growth Rate
    #     xdata = df.loc[df['Days'] >= 0, 'Days']
    #     ydata = df.loc[df['Days'] >= 0, 'Confirmed']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)
 
    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedConfirmed']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Korea Death Growth Rate
    #     xdata = df.loc[(df['Days'] >= 0)\
    #                    & (df['PresumedInfected'].notnull()), 'Days']
    #     ydata = df.loc[(df['Days'] >= 0)\
    #                    & (df['PresumedInfected'].notnull()),
    #                    'PresumedInfected']
    #     p0 = [max(ydata), 1,  np.median(xdata), min(ydata)]
    #     bounds = ([-np.inf, -np.inf, -np.inf, 0], 
    #               [np.inf, np.inf, np.inf, np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedPresumed']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Calculate predicted rate of change
    #     df.loc[:, 'DeathChange'] = df.loc[:, 'PredictedDeaths'].pct_change()
    #     df.loc[:, 'ConfirmedChange'] = df.loc[:, 'PredictedConfirmed']\
    #                                      .pct_change()
    #     df.loc[:, 'PresumedChange'] = df.loc[:, 'PredictedPresumed']\
    #                                     .pct_change()

    #     return df

    # def plot_korea(self):
    #     '''
    #     Plots a time series of infections in Hubei against the polynomial fit
    #     Parameters:
    #         poly: Int
    #             An integer to plot an nth degree polynomial
    #     Returns
    #         Time Series plot
    #     '''

    #     cols = ['Date', 'Deaths', 'PredictedDeaths']
        
    #     # Transform the DataFrame
    #     data = self.korea[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Deaths',
    #                                            'variable':'Type'
    #                                            })

    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Deaths', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of Covid-19 Deaths in South Korea')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}KoreaPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))
        
    #     g = plt.figure()

    #     cols = ['Date', 'Confirmed', 'PredictedConfirmed']

    #     # Transform the DataFrame
    #     data = self.korea[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Cases',
    #                                            'variable':'Type'
    #                                            })
        
    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Cases', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of Confirmed COVID-19 Cases in South Korea')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}KoreaPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))

    #     g = plt.figure()

    #     cols = ['Date', 'PresumedInfected', 'PredictedPresumed']

    #     # Transform the DataFrame
    #     data = self.korea[cols].melt(id_vars='Date')\
    #                            .rename(columns={
    #                                            'value':'Cases',
    #                                            'variable':'Type'
    #                                            })
        
    #     # Plot the Time-Series
    #     g = sns.lineplot(data=data, x='Date', y='Cases', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     # Set the x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title the chart
    #     g.set_title('Fit Line of Presumed COVID-19 Cases in South Korea')

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}KoreaPlot.png'
    #     #                  .format(str(pd.to_datetime('today').date())))

    # def hubei_comp(self):
    #     '''
    #     Compares the growth of the outbreak after lockdown measures have been
    #     taken and compares again'st China's Hubei province
        
    #     Returns
    #         Time-Series plot
    #     '''

    #     df = self.data
    #     df2 = df.copy()
    #     df3 = df.copy()
    #     df4 = df.copy()
        
    #     # Number of Deaths on 1st day of recorded deaths
    #     start_infect = df.loc[df['Deaths'] >= 1, 'Deaths'].iat[0]
        
    #     # Merge with Hubei data
    #     df2 = df2.merge(self.hubei[['DeathChange', 'LockdownDays']], how='left',
    #                   left_on='LockdownDays', right_on='LockdownDays')

    #     # Set initial value on lockdown date
    #     df2.loc[df2['LockdownDays'] == 0, 'Hubei Model']\
    #         = df2.loc[df2['LockdownDays'] == 0, 'Deaths']

    #     # Calculate projected cases
    #     for i in df2[df2['LockdownDays'] > 0].index:
    #         df2.loc[i, 'Hubei Model'] = df2.loc[i - 1, 'Hubei Model']\
    #                                    * (1 + df2.loc[i, 'DeathChange'])

    #     # Round to integer
    #     df2['Hubei Model'] = df2['Hubei Model'].round()

    #     # Create tidy dataframe
    #     cols = ['Date', 'Deaths', 'Hubei Model']
    #     data = df2[cols].melt(id_vars='Date')\
    #                    .rename(columns={'value':'Deaths', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data[data['Date'] >= self.lockdown_date],
    #                       x='Date', y='Deaths', palette=dat_pal[:2],
    #                       hue='Type')

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 Deaths in {}'
    #                 .format(self.location))

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}HubeiComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

    #     g = plt.figure()

    #     # Merge with Hubei data
    #     df3 = df3.merge(self.hubei[['ConfirmedChange', 'LockdownDays']], how='left',
    #                   left_on='LockdownDays', right_on='LockdownDays')

    #     # Set initial value on lockdown date
    #     df3.loc[df3['LockdownDays'] == 0, 'Hubei Model']\
    #         = df3.loc[df3['LockdownDays'] == 0, 'Confirmed']

    #     # Calculate projected cases
    #     for i in df3[df3['LockdownDays'] > 0].index:
    #         df3.loc[i, 'Hubei Model'] = df3.loc[i - 1, 'Hubei Model']\
    #                                    * (1 + df3.loc[i, 'ConfirmedChange'])

    #     # Round to integer
    #     df3['Hubei Model'] = df3['Hubei Model'].round()

    #     # Create tidy dataframe
    #     cols = ['Date', 'Confirmed', 'Hubei Model']
    #     data = df3[cols].melt(id_vars='Date')\
    #                    .rename(columns={'value':'Confirmed', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data[data['Date'] >= self.lockdown_date],
    #                       x='Date', y='Confirmed', palette=dat_pal[:2],
    #                       hue='Type')

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 Confirmed in {}'
    #                 .format(self.location))

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}HubeiComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

    #     g = plt.figure()
        
    #     # Merge with Hubei data
    #     df4 = df4.merge(self.hubei[['PresumedChange', 'LockdownDays']], how='left',
    #                   left_on='LockdownDays', right_on='LockdownDays')

    #     # Set initial value on lockdown date
    #     df4.loc[df4['LockdownDays'] == 1, 'Hubei Model']\
    #         = df4.loc[df4['LockdownDays'] == 1, 'PresumedInfected']

    #     # Calculate projected cases
    #     for i in df4[df4['LockdownDays'] > 1].index:
    #         df4.loc[i, 'Hubei Model'] = df4.loc[i - 1, 'Hubei Model']\
    #                                    * (1 + df4.loc[i, 'PresumedChange'])

    #     # Round to integer
    #     df4['Hubei Model'] = df4['Hubei Model'].round()

    #     # Create tidy dataframe
    #     cols = ['Date', 'PresumedInfected', 'Hubei Model']
    #     data = df4[cols].melt(id_vars='Date')\
    #                    .rename(columns={'value':'PresumedInfected', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data[data['Date'] >= self.lockdown_date],
    #                       x='Date', y='PresumedInfected', palette=dat_pal[:2],
    #                       hue='Type')

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 PresumedInfected in {}'
    #                 .format(self.location))

    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}HubeiComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

    # def korea_comp(self):
    #     '''
    #     Compares the growth of the outbreak compared to the growth of the
    #     virus in Sotuh Korea.  Plots where the lockdown took effect if a
    #     lockdown exists
        
    #     Returns
    #         Time-Series plot
    #     '''

    #     df = self.data
    #     df2 = df.copy()
    #     df3 = df.copy()
    #     df4 = df.copy()
      
    #     cols = ['Date', 'Confirmed', 'PresumedInfected']
    #     data = df[cols].melt(id_vars='Date')\
    #                    .rename(columns={'value':'Cases', 'variable':'Type'})

    #     g = sns.lineplot(data=data, x='Date', y='Cases', palette=dat_pal[:2],
    #                      hue='Type')
        
    #     g = plt.figure()

    #     # Number of Deaths on 1st day of recorded deaths
    #     start_infect = df2.loc[df2['Deaths'] >= 1, 'Deaths'].iat[0]
    
    #     # Korea Model Time Delta at similar number of infections
    #     korea_model = self.korea.copy()
    #     time_delta = korea_model.loc[korea_model['Deaths'] <= start_infect,
    #                                  'Days']\
    #                             .iat[-1]
    
    #     # Adjust Time delta
    #     korea_model['Days'] = korea_model['Days'] - time_delta
    
    #     # Compare to Korean Infection Model
    #     df2 = df2.merge(korea_model[['Days', 'PredictedDeaths']], how='left',
    #                   left_on='Days', right_on='Days')
    #     df2.rename(columns={'PredictedDeaths':'Korea Model'}, inplace=True)


    #     # Create tidy dataframe
    #     cols = ['Date', 'Deaths', 'Korea Model']
    #     data = df2[cols].melt(id_vars='Date')\
    #                     .rename(columns={'value':'Deaths', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data, x='Date', y='Deaths', palette=dat_pal[:2],
    #                      hue='Type')

    #     # Lockdown phaseline
    #     if np.isnat(self.lockdown_date):
    #         pass
    #     else:
    #         g.axvline(x=self.lockdown_date, color=dat_pal[3], linestyle='--')
    #         threshold = df2.loc[df2['Date'].dt.date\
    #                         == self.lockdown_date, 'Deaths']
    #         at = AnchoredText('{} Deaths at\n time of lockdown'\
    #                           .format(int(threshold.iat[0])),
    #                           prop=dict(size=10, color=dat_pal[3]),
    #                           frameon=True, loc='center left')
    #         at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    #         g.add_artist(at)

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 Deaths in {}'\
    #                 .format(self.location))


    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}KoreaComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

    #     g = plt.figure()

    #     # Number of Confirmed on 1st day of confirmed
    #     start_infect = df3.loc[df3['Confirmed'] >= 1, 'Confirmed'].iat[0]
    
    #     # Korea Model Time Delta at similar number of infections
    #     korea_model = self.korea.copy()
    #     time_delta = korea_model.loc[korea_model['Confirmed'] <= start_infect,
    #                                  'Days']\
    #                             .iat[-1]
    
    #     # Adjust Time delta
    #     korea_model['Days'] = korea_model['Days'] - time_delta
    
    #     # Compare to Korean Infection Model
    #     df3 = df3.merge(korea_model[['Days', 'PredictedConfirmed']], how='left',
    #                   left_on='Days', right_on='Days')
    #     df3.rename(columns={'PredictedConfirmed':'Korea Model'}, inplace=True)


    #     # Create tidy dataframe
    #     cols = ['Date', 'Confirmed', 'Korea Model']
    #     data = df3[cols].melt(id_vars='Date')\
    #                     .rename(columns={'value':'Confirmed', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data, x='Date', y='Confirmed', palette=dat_pal[:2],
    #                      hue='Type')

    #     # Lockdown phaseline
    #     if np.isnat(self.lockdown_date):
    #         pass
    #     else:
    #         g.axvline(x=self.lockdown_date, color=dat_pal[3], linestyle='--')
    #         threshold = df3.loc[df3['Date'].dt.date\
    #                         == self.lockdown_date, 'Confirmed']
    #         at = AnchoredText('{} Confirmed at\n time of lockdown'\
    #                           .format(int(threshold.iat[0])),
    #                           prop=dict(size=10, color=dat_pal[3]),
    #                           frameon=True, loc='center left')
    #         at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    #         g.add_artist(at)

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 Confirmed in {}'\
    #                 .format(self.location))


    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}KoreaComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

    #     g = plt.figure()

    #     # Number of Confirmed on 1st day of confirmed
    #     start_infect = df4.loc[df4['PresumedInfected'] >= 1, 'PresumedInfected'].iat[0]
    
    #     # Korea Model Time Delta at similar number of infections
    #     korea_model = self.korea.copy()
    #     time_delta = korea_model.loc[korea_model['PresumedInfected'] <= start_infect,
    #                                  'Days']\
    #                             .iat[-1]
    
    #     # Adjust Time delta
    #     korea_model['Days'] = korea_model['Days'] - time_delta
    
    #     # Compare to Korean Infection Model
    #     df4 = df4.merge(korea_model[['Days', 'PredictedPresumed']], how='left',
    #                   left_on='Days', right_on='Days')
    #     df4.rename(columns={'PredictedPresumed':'Korea Model'}, inplace=True)


    #     # Create tidy dataframe
    #     cols = ['Date', 'PresumedInfected', 'Korea Model']
    #     data = df4[cols].melt(id_vars='Date')\
    #                     .rename(columns={'value':'PresumedInfected', 'variable':'Type'})

    #     # Graph location-wide infection versus Hubei Infections
    #     g = sns.lineplot(data=data, x='Date', y='PresumedInfected', palette=dat_pal[:2],
    #                      hue='Type')

    #     # Lockdown phaseline
    #     if np.isnat(self.lockdown_date):
    #         pass
    #     else:
    #         g.axvline(x=self.lockdown_date, color=dat_pal[3], linestyle='--')
    #         threshold = df4.loc[df4['Date'].dt.date\
    #                         == self.lockdown_date, 'PresumedInfected']
    #         at = AnchoredText('{} PresumedInfected at\n time of lockdown'\
    #                           .format(int(threshold.iat[0])),
    #                           prop=dict(size=10, color=dat_pal[3]),
    #                           frameon=True, loc='center left')
    #         at.patch.set_boxstyle("round,pad=0.,rounding_size=0.2")
    #         g.add_artist(at)

    #     # Format x-axis
    #     g.xaxis.set_major_locator(self.days)

    #     # Title Graph
    #     g.set_title('Time Series of COVID-19 PresumedInfected in {}'\
    #                 .format(self.location))


    #     # # Save the plot
    #     # g.figure.savefig('..\\DATFiles\\{}{}KoreaComp.png'
    #     #                  .format(str(pd.to_datetime('today').date()),
    #     #                          self.location))

class FluReportUS(object):
    """docstring for FluReportUS"""
    def __init__(self):

        '''
        PERCENTAGE OF VISITS FOR INFLUENZA-LIKE-ILLNESS REPORTED BY 
        SENTINEL PROVIDERS
        '''
        self.ilinet = self.ilinet()

        '''
        Beginning for the 2015-16 season, reports from public health and
        clinical laboratories are presented separately in the weekly
        influenza update, FluView. Data from clinical laboratories include
        the weekly total number of specimens tested, the number of
        positive influenza test, and the percent positive by influenza
        type.
        '''
        self.labs = self.labs()

        '''
        Beginning for the 2015-16 season, reports from public health and
        clinical laboratories are presented separately in the weekly
        influenza update, FluView. This data file includes only data prior
        to the 2015-16 influenza season, and will be presented with the
        public health and clinical labs combined.
        '''
        self.prior = self.prior()

        '''
        Beginning for the 2015-16 season, reports from public health and
        clinical laboratories are presented separately in the weekly
        influenza update, FluView. Data presented from public health
        laboratories include the weekly total number of specimens tested,
        the number of positive influenza tests, and the number by
        influenza virus type, subtype, and influenza B lineage
        '''
        self.public = self.public()

    def load(self, csv):
        path = '..\\DATFiles\\FluViewPhase2Data\\'
        file = path + csv
        df = pd.read_csv(file, header=1)

        try:
            df.loc[:, ['WEEK', 'YEAR']] = df.loc[:, ['WEEK', 'YEAR']]\
                                            .astype(str)
            df.loc[:, 'WEEKOF'] = df.loc[:, 'WEEK'] + df.loc[:, 'YEAR'] + '0'
            df.loc[:, 'WEEKOF'] = df.loc[:, 'WEEKOF']\
                                    .apply(pd.to_datetime, format='%U%Y%w')
            df.loc[:, 'WEEK'] = df.loc[:, 'WEEKOF'].dt.week
            df.loc[:, 'YEAR'] = df.loc[:, 'WEEKOF'].dt.year


        except:
            pass

        return df

    def ilinet(self):
        df = self.load('ILINet.csv')

        num = ['% WEIGHTED ILI', '%UNWEIGHTED ILI', 'AGE 0-4', 'AGE 25-49',
               'AGE 25-64', 'AGE 5-24', 'AGE 50-64', 'AGE 65', 'ILITOTAL',
               'NUM. OF PROVIDERS', 'TOTAL PATIENTS']
        cat = ['REGION TYPE', 'REGION']
        df.loc[:, num] = df.loc[:, num].apply(pd.to_numeric, errors='coerce')
        df.loc[:, cat] = df.loc[:, cat].astype('category')
# , 'YEAR', 'WEEK'
        return df

    def labs(self):
        df = self.load('WHO_NREVSS_Clinical_Labs.csv')

        df.iloc[:, 4:-1] = df.iloc[:, 4:-1].apply(pd.to_numeric, errors='coerce')
        df.loc[:, 'TOTAL POSITIVE'] = df.loc[:, 'TOTAL A'] + df.loc[:, 'TOTAL B']

        return df
    
    def prior(self):
        df = self.load('WHO_NREVSS_Combined_prior_to_2015_16.csv')

        df.iloc[:, 4:-1] = df.iloc[:, 4:-1].apply(pd.to_numeric, errors='coerce')

        return df

    def public(self):
        df = self.load('WHO_NREVSS_Public_Health_Labs.csv')

        df.iloc[:, 3:] = df.iloc[:, 3:].apply(pd.to_numeric, errors='coerce')

        return df

{'AL':'Alabama', 'NE':'Nebraska','AK':'Alaska', 'NV':'Nevada', 'AZ':'Arizona',
'NH':'New Hampshire','AR':'Arkansas', 'NJ':'New Jersey', 'CA':'California',
'NM':'New Mexico', 'CO':'Colorado', 'NY':'New York', 'CT':'Connecticut',
'NC':'North Carolina', 'DE':'Delaware', 'ND':'North Dakota', 
'DC':'District of Columbia', 'OH':'Ohio', 'FL':'Florida', 'OK':'Oklahoma',
'GA':'Georgia', 'OR':'Oregon', 'HI':'Hawaii', 'PA':'Pennsylvania',
'ID':'Idaho', 'PR':'Puerto Rico', 'IL':'Illinois', 'RI':'Rhode Island',
'IN':'Indiana', 'SC':'South Carolina', 'IA':'Iowa', 'SD':'South Dakota',
'KS':'Kansas', 'TN':'Tennessee', 'KY':'Kentucky', 'TX':'Texas',
'LA':'Louisiana', 'UT':'Utah', 'ME':'Maine', 'VT':'Vermont', 'MD':'Maryland',
'VA':'Virginia', 'MA':'Massachusetts', 'VI':'Virgin Islands', 'MI':'Michigan',
'WA':'Washington', 'MN':'Minnesota', 'WV':'West Virginia', 'MS':'Mississippi',
'WI':'Wisconsin', 'MO':'Missouri', 'WY':'Wyoming', 'MT':'Montana'}