import matplotlib.pyplot as plt
import glob
import os
import pandas as pd
import re
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

class CovidReport_Global(object):
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

        # Data Cleansing
        df['Last Update'].fillna(df['Last_Update'], inplace=True)
        df['Latitude'].fillna(df['Lat'], inplace=True)
        df['Longitude'].fillna(df['Long_'], inplace=True)
        df['Province/State'].fillna(df['Province_State'],
                                         inplace=True)
        df['Country/Region'].fillna(df['Country_Region'],
                                         inplace=True)

        plist = df.loc[(df['Combined_Key'].isnull()) & (df['Province/State'].notnull()), 'Province/State'].unique()
        plist = [p for p in plist if len(self.FIPS_df[self.FIPS_df['Combined_Key'].str.contains(p)]) == 1]

        for p in plist:
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'FIPS'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'FIPS'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Admin2'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Admin2'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Country/Region'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Country_Region'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Latitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Lat'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Longitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Long_'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Combined_Key'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Combined_Key'].iat[0]
            df.loc[(df['Province/State'] == p) & (df['Combined_Key'].isnull()), 'Province/State'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(p),
                             'Province_State'].iat[0]

        clist = df.loc[(df['Combined_Key'].isnull()) & (df['Country/Region'].notnull()), 'Country/Region'].unique()
        clist = [c for c in clist if len(self.FIPS_df[self.FIPS_df['Combined_Key'].str.contains(c)]) == 1]

        for c in clist:
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'FIPS'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'FIPS'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Admin2'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Admin2'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Province/State'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Province_State'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Latitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Lat'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Longitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Long_'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Combined_Key'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Combined_Key'].iat[0]
            df.loc[(df['Country/Region'] == c) & (df['Combined_Key'].isnull()), 'Country/Region'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'].str.contains(c),
                             'Country_Region'].iat[0]
        
        pdict = {'Washington':'Washington, US', 
                 'Chicago':'Cook, Illinois, US', 'Illinois':'Illinois, US',
                 'California':'California, US', 'Arizona':'Arizona, US',
                 'Ontario':'Ontario, Canada',
                 'Victoria':'Victoria, Australia',
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
                 'San Diego County, CA':'San Diego, California, US',
                 'San Antonio, TX':'Bexar, Texas, US',
                 'Ashland, NE':'Saunders, Nebraska, US',
                 'Travis, CA':'Solano, California, US',
                 'From Diamond Princess':'Diamond Princess',
                 'Lackland, TX':'Bexar, Texas, US', 'None':'Lebanon',
                 'Humboldt County, CA':'Humboldt, California, US',
                 'Sacramento County, CA':'Sacramento, California, US',
                 'Omaha, NE (From Diamond Princess)':'Diamond Princess',
                 'Travis, CA (From Diamond Princess)':'Diamond Princess',
                 'Lackland, TX (From Diamond Princess)':'Diamond Princess',
                 'Unassigned Location (From Diamond Princess)':'Diamond Princess',
                 ' Montreal, QC':'Quebec, Canada',
                 'Portland, OR':'Multnomah, Oregon, US', 
                 'Snohomish County, WA':'Snohomish, Washington, US',
                 'Providence, RI':'Providence, Rhode Island, US',
                 'King County, WA':'King, Washington, US',
                 'Cook County, IL':'Cook, Illinois, US',
                 'Grafton County, NH':'Grafton, New Hampshire, US',
                 'Hillsborough, FL':'Hillsborough, Florida, US',
                 'New York City, NY':'New York City, New York, US',
                 'Placer County, CA':'Placer, California, US',
                 'San Mateo, CA':'San Mateo, California, US',
                 'Sarasota, FL':'Sarasota, Florida, US',
                 'Sonoma County, CA':'Sonoma, California, US',
                 'Umatilla, OR':'Umatilla, Oregon, US',
                 'Fulton County, GA':'Fulton, Georgia, US',
                 'Washington County, OR':'Washington, Oregon, US',
                 ' Norfolk County, MA':'Norfolk, Massachusetts, US',
                 'Berkeley, CA':'Alameda, California, US',
                 'Maricopa County, AZ':'Maricopa, Arizona, US',
                 'Wake County, NC':'Wake, North Carolina, US',
                 'Westchester County, NY':'Westchester, New York, US',
                 'Saint Barthelemy':'Saint Barthelemy, France',
                 'Orange County, CA':'Orange, California, US',
                 'Faroe Islands':'Faroe Islands, Denmark',
                 'Gibraltar':'Gibraltar, United Kingdom',
                 'Contra Costa County, CA':'Contra Costa, California, US',
                 'Bergen County, NJ':'Bergen, New Jersey, US',
                 'Harris County, TX':'Harris, Texas, US',
                 'San Francisco County, CA':'San Francisco, California, US',
                 'Clark County, NV':'Clark, Nevada, US',
                 'Fort Bend County, TX':'Fort Bend, Texas, US',
                 'Grant County, WA':'Grant, Washington, US',
                 'Queens County, NY':'Queens, New York, US',
                 'Santa Rosa County, FL':'Santa Rosa, Florida, US',
                 'Williamson County, TN':'Williamson, Tennessee, US',
                 'New York County, NY':'New York City, New York, US',
                 'Unassigned Location, WA':'Unassigned, Washington, US',
                 'Montgomery County, MD':'Montgomery, Maryland, US',
                 'Suffolk County, MA':'Suffolk, Massachusetts, US',
                 'Denver County, CO':'Denver, Colorado, US',
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
                 'Washoe County, NV':'Washoe, Nevada, US',
                 'Wayne County, PA':'Wayne, Pennsylvania, US',
                 'Yolo County, CA':'Yolo, California, US',
                 'Santa Clara County, CA':'Santa Clara, California, US',
                 'Grand Princess Cruise Ship':'Grand Princess, US',
                 'French Guiana':'French Guiana, France',
                 'Douglas County, CO':'Douglas, Colorado, US',
                 'Providence County, RI':'Providence, Rhode Island, US',
                 'Martinique':'Martinique, France',
                 'Alameda County, CA':'Alameda, California, US',
                 'Broward County, FL':'Broward, Florida, US',
                 'Fairfield County, CT':'Fairfield, Connecticut, US',
                 'Lee County, FL':'Lee, Florida, US',
                 'Pinal County, AZ':'Pinal, Arizona, US',
                 'Rockland County, NY':'Rockland, New York, US',
                 'Saratoga County, NY':'Saratoga, New York, US',
                 'Edmonton, Alberta':'Alberta, Canada',
                 'Charleston County, SC':'Charleston, South Carolina, US',
                 'Clark County, WA':'Clark, Washington, US',
                 'Cobb County, GA':'Cobb, Georgia, US',
                 'Davis County, UT':'Davis, Utah, US',
                 'El Paso County, CO':'El Paso, Colorado, US',
                 'Honolulu County, HI':'Honolulu, Hawaii, US',
                 'Jackson County, OR ':'Jackson, Oregon, US',
                 'Jefferson County, WA':'Jefferson, Washington, US',
                 'Kershaw County, SC':'Kershaw, South Carolina, US',
                 'Klamath County, OR':'Klamath, Oregon, US',
                 'Madera County, CA':'Madera, California, US',
                 'Pierce County, WA':'Pierce, Washington, US',
                 'Plymouth County, MA':'Plymouth, Massachusetts, US',
                 'Santa Cruz County, CA':'Santa Cruz, California, US',
                 'Tulsa County, OK':'Tulsa, Oklahoma, US',
                 'Montgomery County, TX':'Montgomery, Texas, US',
                 'Norfolk County, MA':'Norfolk, Massachusetts, US',
                 'Montgomery County, PA':'Montgomery, Pennsylvania, US',
                 'Fairfax County, VA':'Fairfax, Virginia, US',
                 'Rockingham County, NH':'Rockingham, New Hampshire, US',
                 'Washington, D.C.':'District of Columbia, US',
                 'Berkshire County, MA':'Berkshire, Massachusetts, US',
                 'Davidson County, TN':'Davidson, Tennessee, US',
                 'Douglas County, OR':'Douglas, Oregon, US',
                 'Fresno County, CA':'Fresno, California, US',
                 'Harford County, MD':'Harford, Maryland, US',
                 'Hendricks County, IN':'Hendricks, Indiana, US',
                 'Hudson County, NJ':'Hudson, New Jersey, US',
                 'Johnson County, KS':'Johnson, Kansas, US',
                 'Kittitas County, WA':'Kittitas, Washington, US',
                 'Manatee County, FL':'Manatee, Florida, US',
                 'Marion County, OR':'Marion, Oregon, US',
                 'Okaloosa County, FL':'Okaloosa, Florida, US',
                 'Polk County, GA':'Polk, Georgia, US',
                 'Riverside County, CA':'Riverside, California, US',
                 'Shelby County, TN':'Shelby, Tennessee, US',
                 'Spokane County, WA':'Spokane, Washington, US',
                 'St. Louis County, MO':'St. Louis, Missouri, US',
                 'Suffolk County, NY':'Suffolk, New York, US',
                 'Ulster County, NY':'Ulster, New York, US',
                 'Unassigned Location, VT':'Unassigned, Vermont, US',
                 'Unknown Location, MA':'Unassigned, Massachusetts, US',
                 'Volusia County, FL':'Volusia, Florida, US',
                 'Johnson County, IA':'Johnson, Iowa, US',
                 'Harrison County, KY':'Harrison, Kentucky, US',
                 'Bennington County, VT':'Bennington, Vermont, US',
                 'Carver County, MN':'Carver, Minnesota, US',
                 'Charlotte County, FL':'Charlotte, Florida, US',
                 'Cherokee County, GA':'Cherokee, Georgia, US',
                 'Collin County, TX':'Collin, Texas, US',
                 'Jefferson County, KY':'Jefferson, Kentucky, US',
                 'Jefferson Parish, LA':'Jefferson, Louisiana, US',
                 'Shasta County, CA':'Shasta, California, US',
                 'Spartanburg County, SC':'Spartanburg, South Carolina, US',
                 'New York':'New York, US',
                 'Massachusetts':'Massachusetts, US', 'Taiwan':'Taiwan*',
                 'Diamond Princess':'Diamond Princess',
                 'Grand Princess':'Grand Princess, US',
                 'Georgia':'Georgia, US', 'Colorado':'Colorado, US',
                 'Florida':'Florida, US', 'New Jersey':'New Jersey, US',
                 'Oregon':'Oregon, US', 'Texas':'Texas, US',
                 'Pennsylvania':'Pennsylvania, US', 'Iowa':'Iowa, US',
                 'Maryland':'Maryland, US',
                 'North Carolina':'North Carolina, US',
                 'South Carolina':'South Carolina, US',
                 'Tennessee':'Tennessee, US', 'Virginia':'Virginia, US',
                 'Indiana':'Indiana, US', 'Kentucky':'Kentucky, US',
                 'District of Columbia':'District of Columbia, US',
                 'Nevada':'Nevada, US',
                 'New Hampshire':'New Hampshire, US',
                 'Minnesota':'Minnesota, US', 'Nebraska':'Nebraska, US',
                 'Ohio':'Ohio, US', 'Rhode Island':'Rhode Island, US',
                 'Wisconsin':'Wisconsin, US', 'Connecticut':'Connecticut, US',
                 'Hawaii':'Hawaii, US', 'Oklahoma':'Oklahoma, US',
                 'Utah':'Utah, US',
                 'Channel Islands':'Channel Islands, United Kingdom',
                 'Kansas':'Kansas, US', 'Louisiana':'Louisiana, US',
                 'Missouri':'Missouri, US', 'Vermont':'Vermont, US',
                 'Alaska':'Alaska, US', 'Arkansas':'Arkansas, US',
                 'Delaware':'Delaware, US', 'Idaho':'Idaho, US',
                 'Maine':'Maine, US', 'Michigan':'Michigan, US',
                 'Mississippi':'Mississippi, US', 'Montana':'Montana, US',
                 'New Mexico':'New Mexico, US',
                 'North Dakota':'North Dakota, US',
                 'South Dakota':'South Dakota, US',
                 'West Virginia':'West Virginia, US', 'Wyoming':'Wyoming, US',
                 'France':'France', 'UK':'United Kingdom',
                 'Denmark':'Denmark', 'Reunion':'Reunion, France',
                 'United Kingdom':'United Kingdom',
                 'Cayman Islands':'Cayman Islands, United Kingdom',
                 'Guadeloupe':'Guadeloupe, France',
                 'Aruba':'Aruba, Netherlands', 'Alabama':'Alabama, US',
                 'Fench Guiana':'French Guiana, France',
                 'Curacao':'Curacao, Netherlands',
                 'Virgin Islands, U.S.':'Virgin Islands, US',
                 'Netherlands':'Netherlands', 'Guam':'Guam, US',
                 'Puerto Rico':'Puerto Rico, US',
                 'Greenland':'Greenland, Denmark',
                 'Mayotte':'Mayotte, France',
                 'Virgin Islands':'Virgin Islands, US',
                 'United States Virgin Islands':'Virgin Islands, US',
                 'US':'US'}
        
        for k,v in pdict.items():
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'FIPS'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'FIPS'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Admin2'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Admin2'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Country/Region'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Country_Region'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Latitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Lat'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Longitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Long_'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Combined_Key'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Combined_Key'].iat[0]
            df.loc[(df['Province/State'] == k) & (df['Combined_Key'].isnull()), 'Province/State'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Province_State'].iat[0]

        cdict = {'South Korea':'Korea, South', 'Australia':'Australia',
                 'Mexico':'Mexico', 'France':'France',
                 'Ivory Coast':"Cote d'Ivoire", 'India':'India',
                 'UK':'United Kingdom',
                 # 'Others',
                 'Lebanon':'Lebanon', 'Switzerland':'Switzerland',
                 'Georgia':'Georgia', 'Denmark':'Denmark',
                 'Netherlands':'Netherlands', ' Azerbaijan':'Azerbaijan',
                 'North Ireland':'United Kingdom', 'Czech Republic':'Czechia',
                 'Palestine':'West Bank and Gaza', 'Vatican City':'Holy See',
                 'Republic of Ireland':'Ireland',
                 'Iran (Islamic Republic of)':'Iran',
                 'Republic of Korea':'Korea, South', 'Viet Nam':'Vietnam',
                 'occupied Palestinian territory':'West Bank and Gaza',
                 'Russian Federation':'Russia',
                 'Republic of Moldova':'Moldova',
                 'Saint Martin':'St Martin, France', 'Mongolia':'Mongolia',
                 'Congo (Kinshasa)':'Congo (Kinshasa)', 'Sudan':'Sudan',
                 'Guinea':'Guinea', 'Jersey':'United Kingdom',
                 'Congo (Brazzaville)':'Congo (Brazzaville)',
                 'Republic of the Congo':'Congo (Brazzaville)',
                 'The Bahamas':'Bahamas', 'The Gambia':'Gambia',
                 'Gambia, The':'Gambia', 'Bahamas, The':'Bahamas',
                 'Niger':'Niger', 'Cape Verde':'Cabo Verde',
                 'East Timor':'Timor-Leste'}

        for k,v in cdict.items():
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'FIPS'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'FIPS'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Admin2'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Admin2'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Latitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Lat'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Longitude'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Long_'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Combined_Key'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Combined_Key'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Province/State'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Province_State'].iat[0]
            df.loc[(df['Country/Region'] == k) & (df['Combined_Key'].isnull()), 'Country/Region'] =\
                self.FIPS_df.loc[self.FIPS_df['Combined_Key'] == v,
                             'Country_Region'].iat[0]

        # Enfore datetime column is datetime
        df['Last Update'] = df['Last Update'].apply(pd.to_datetime)

        # Drop Duplicates and reset index
        df.drop_duplicates(inplace=True)
        df.reset_index(drop=True, inplace=True)

        # Trim DataFrame to necessary columns
        # df_cols = ['Active', 'Admin2', 'Combined_Key', 'Confirmed',
        #            'Country/Region', 'Date', 'Deaths', 'FIPS', 'Last Update',
        #            'Latitude', 'Longitude', 'Province/State', 'Recovered']

        # df = df[df_cols]

        return df
    
class CovidReport_Region(CovidReport_Global):
    '''
    Report of Coronavirus activity for a specifed region

    Parameters:
        location: str
            Geographic area
        location_type: str
            Type of location
    '''
    def __init__(self, location, location_type, lockdown_date=None):
        super().__init__()
        self.location = location
        self.location_type = location_type
        self.lockdown_date = pd.np.datetime64(lockdown_date)
        self.data = self.get_data()
        # self.hubei = self.track_hubei()
        # self.korea = self.track_korea()
        
    def log_func(self, x, L, k, x0, b):
        return L / (1 + pd.np.exp(-k*(x-x0))) + b

    def decay_func(self, x, a, b):
        return a * pd.np.exp(-b*x)

    def get_data(self):
        '''
        Creates filtered data set for specified location
        Returns
            DataFrame
        '''
        # Trim DataFrame to location specific
        locations = ['Country/Region', 'Province/State', 'Admin2']
        if self.location_type in locations:
            df = self.df[self.df[self.location_type] == self.location]

        else:
            raise ValueError

        # Create Time Index
        today = pd.to_datetime('today')
        df2 = pd.DataFrame(index=pd.date_range('01-22-2020', today))
        
        cols = ['Confirmed', 'Date', 'Deaths', 'Recovered']
        df3 = df[cols].groupby('Date')\
                      .sum()

        # Join location data with datetime index
        df = df2.join(df3, how='left', sort=True)

        # Reset index
        df.reset_index(inplace=True)
        df.rename(columns={'index':'Date'}, inplace=True)

        # Name the region
        df.loc[:, 'Region'] = self.location

        # Date Variables 
        init_date = df.loc[df['Confirmed'] >= 1, 'Date'].iat[0] 
        df.loc[:, 'Days'] = df.loc[:, 'Date'] - init_date
        df.loc[:, 'Days'] = df.loc[:, 'Days'].dt.days

        # # Calculate active cases
        # df.loc[:, 'Active'] = df.loc[:, 'Confirmed']\
        #                         - df.loc[:, 'Deaths']\
        #                         - df.loc[:, 'Recovered']

        # Calculate number of presumed cases based on mortality
        df.loc[:, 'PresumedInfected'] = df.loc[:, 'Deaths']\
                                           .shift(periods=-14)
        df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
                                         / 0.0066 
        df.loc[:, 'PresumedInfected'] = df.loc[:, 'PresumedInfected']\
                                           .round()

        # Calculate Case Fatatlity Rate
        df.loc[:, 'CFR'] = df.loc[:, 'Deaths'] / df.loc[:, 'Confirmed']

        # Calculate percentage of "true" cases country has discovered
        df.loc[:, 'DiscoveryRate'] = df.loc[:, 'Confirmed'] / df.loc[:, 'PresumedInfected']

        df.fillna(0, inplace=True)

        df.loc[df['PresumedInfected'] == 0, 'PresumedInfected'] = pd.np.NaN

        if self.lockdown_date == None:
            pass
        else:
            df['LockdownDays'] = df['Date'] - self.lockdown_date
            df['LockdownDays'] = df['LockdownDays'].dt.days

        return df

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
    #     start_date = pd.np.datetime64('2020-01-23')

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

    #     df.loc[df['PresumedInfected'] == 0, 'PresumedInfected'] = pd.np.NaN

    #     # Fit Logarithmic Curve to Hubei Death Growth Rate
    #     xdata = df.loc[df['LockdownDays'] >= 0, 'LockdownDays']
    #     ydata = df.loc[df['LockdownDays'] >= 0, 'Deaths']
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['LockdownDays'] >= 0, 'PredictedDeaths']\
    #         = self.log_func(df.loc[df['LockdownDays'] >= 0, 'LockdownDays'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Hubei Confirmed Growth Rate
    #     xdata = df.loc[df['LockdownDays'] >= 0, 'LockdownDays']
    #     ydata = df.loc[df['LockdownDays'] >= 0, 'Confirmed']
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
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
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
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
    #     init_date = pd.np.datetime64('2020-01-20')

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
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
    #     popt, pcov = curve_fit(self.log_func, xdata, ydata, p0=p0, 
    #                            bounds=bounds)

    #     # Calculate predicted deaths based on logarithmic fit
    #     df.loc[df['Days'] >= 0, 'PredictedDeaths']\
    #         = self.log_func(df.loc[df['Days'] >= 0, 'Days'],
    #                         *popt)

    #     # Fit Logarithmic Curve to Korea Confirmed Growth Rate
    #     xdata = df.loc[df['Days'] >= 0, 'Days']
    #     ydata = df.loc[df['Days'] >= 0, 'Confirmed']
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
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
    #     p0 = [max(ydata), 1,  pd.np.median(xdata), min(ydata)]
    #     bounds = ([-pd.np.inf, -pd.np.inf, -pd.np.inf, 0], 
    #               [pd.np.inf, pd.np.inf, pd.np.inf, pd.np.inf])
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
    #     if pd.np.isnat(self.lockdown_date):
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
    #     if pd.np.isnat(self.lockdown_date):
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
    #     if pd.np.isnat(self.lockdown_date):
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