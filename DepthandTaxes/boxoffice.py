import pandas as pd
import seaborn as sns
import requests
import re
import numpy as np
from bs4 import BeautifulSoup
from statistics import mean
from sklearn import tree
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

# url = 'https://www.boxofficemojo.com/movies/?id=marvel2019.htm'
# df = pd.read_html(url)

class YearlyData(object):
	"""docstring for YearlyData"""
	def __init__(self, yr):
		self.yr = yr
		self.data = self.scrape_mojo().merge(self.scrape_numbers(),left_on=['Title','ReleaseYear'],right_on=['Title','ReleaseYear'],how='left')
	
	def scrape_mojo(self):
		df = pd.DataFrame()
		for p in list(range(1,15)):
			r = requests.get('https://www.boxofficemojo.com/yearly/chart/?page={}&view=releasedate&view2=domestic&yr={}&p=.htm'.format(p,self.yr))
			soup = BeautifulSoup(r.text,'html.parser')
			movies = soup.find_all(href=re.compile('movies'))[1:]
			for m in movies:
				url = 'https://www.boxofficemojo.com'+m.get('href')
				if requests.get(url).status_code == 200:
					df2 = pd.read_html(url)
					cols = []
					values = []
					cols.append('Title')
					values.append(m.string)
					try:
						if df2[4].iat[0,0].count('Domestic') > 1:
							spl = df2[4].iat[0,0].find('Dom',1)
							cols.append('DomesticTotalGross')
							values.append(df2[4].iat[0,0][:spl].split(':')[1].strip())
							cols.append('DomesticLifetimeGross')
							values.append(df2[4].iat[0,0][spl:].split(':')[1].strip())
						else:
							cols.append('DomesticTotalGross')
							values.append(df2[4].iat[0,0].split(':')[1].strip())			
						cols.append(''.join(df2[4].iat[1,0][:11].split()))
						values.append(df2[4].iat[1,0][12:].strip())
						cols.append(''.join(df2[4].iat[2,0][:5].split()))
						values.append(df2[4].iat[2,0][6:].strip())
						cols.append(''.join(df2[4].iat[3,0][:11].split()))
						values.append(df2[4].iat[3,0][12:].strip())
						cols.append(''.join(df2[4].iat[1,1][:12].split()))
						values.append(df2[4].iat[1,1][13:].strip())
						cols.append(''.join(df2[4].iat[2,1][:7].split()))
						values.append(df2[4].iat[2,1][8:].strip())
						cols.append(''.join(df2[4].iat[3,1][:17].split()))
						values.append(df2[4].iat[3,1][18:].strip())
					except IndexError:
						pass
					try:
						cols.append(df2[8].iat[0,0].split(':')[0].replace('+','').strip())
						values.append(df2[8].iat[0,1])
					except IndexError:
						pass
					try:
						cols.append(df2[8].iat[1,0].split(':')[0].replace('+','').strip())
						values.append(df2[8].iat[1,1])
					except IndexError:
						pass			
					for i in range(9,22):
						try:
							if 'Widest' in df2[i].iat[0,0]:
								cols.append(''.join(df2[i].iat[0,0][:14].split()))
								values.append(df2[i].iat[0,1])
							else:
								pass
						except IndexError:
							pass
						except HTTPError:
							pass
				df3 = pd.DataFrame([values], columns=cols)
				df = df.append(df3)
		df.reset_index(drop=True,inplace=True)
		float_cols = ['Domestic','DomesticLifetimeGross','DomesticTotalGross','Foreign','WidestRelease']
		df[float_cols] = df[float_cols].replace(to_replace='[^0-9.]',value='',regex=True).astype(float)
		df.loc[df['ProductionBudget'].str.contains('million', na=False),'ProductionBudget'] = df.loc[df['ProductionBudget'].str.contains('million', na=False),'ProductionBudget'].replace(to_replace='[^0-9.]',value='',regex=True).astype(float) * 1000000
		df['ProductionBudget'] = df['ProductionBudget'].replace(to_replace='[^0-9.]',value='',regex=True).apply(pd.to_numeric, errors='coerce')
		df['ReleaseDate'] = df['ReleaseDate'].apply(pd.to_datetime,errors='coerce')
		df['ReleaseYear'] = df['ReleaseDate'].dt.year
		df['ReleaseMonth'] = df['ReleaseDate'].dt.month_name()
		df['Runtime'] = df['Runtime'].replace({'hrs.' : 'hours', 'min.' : 'minutes'}, regex=True).apply(pd.to_timedelta, errors='coerce').dt.seconds
		return df[['Title','Distributor','Genre','MPAARating','ReleaseDate','ReleaseYear','ReleaseMonth','Runtime','ProductionBudget',
		'DomesticTotalGross','DomesticLifetimeGross','Foreign','WidestRelease']]

	def scrape_numbers(self):
		df = pd.DataFrame()
		r = requests.get('https://www.the-numbers.com/box-office-records/worldwide/all-movies/cumulative/released-in-{}'.format(self.yr))
		soup = BeautifulSoup(r.text,'html.parser')
		movies = soup.find_all(href=re.compile('/movie/'))[1:]
		for m in movies:
			url = 'https://www.the-numbers.com'+m.get('href')
			if requests.get(url).status_code == 200:
				df2 = pd.read_html(requests.get(url).text)
				cols = []
				values = []
				cols.append('Title')
				values.append(m.string)
				try:
					cols.append(df2[0].iat[1,0])
					values.append(df2[0].iat[1,1])
				except IndexError:
					pass
				try:
					cols.append(df2[0].iat[2,0])
					values.append(df2[0].iat[2,1])
				except IndexError:
					pass
				try:
					cols.append(df2[0].iat[3,0])
					values.append(df2[0].iat[3,1])
				except IndexError:
					pass
				try:
					for x in df2[2][0]:
						cols.append(x)
					for y in df2[2][1]:
						values.append(y)
				except IndexError:
					pass
				except KeyError:
					pass
			df3 = pd.DataFrame([values], columns=cols)
			df = df.append(df3)
		df = df[[x for x in df.columns if isinstance(x,str)]]
		df.rename(columns=lambda x: ''.join(x.split()).split(':')[0], inplace=True)
		df.reset_index(drop=True,inplace=True)
		df['ProductionBudget'] = df['ProductionBudget'].replace(to_replace='[^0-9.]',value='',regex=True).astype(float)
		df.rename(columns={'ProductionBudget':'NumbersProductionBudget'},inplace=True)
		df['DomesticReleases'] = df['DomesticReleases'].str.split('(',expand=True)[0].str.strip()
		df['DomesticReleases'] = df['DomesticReleases'].apply(pd.to_datetime,errors='coerce')
		df['ReleaseYear'] = df['DomesticReleases'].dt.year
		df = df[['Title','ReleaseYear','NumbersProductionBudget']]
		return df.drop_duplicates()  

def prod_est(df):
	df2 = df[['Distributor','DomesticTotalGross','ReleaseYear']].groupby(['Distributor','ReleaseYear']).sum().reset_index()
	df3 = df[['DomesticTotalGross','ReleaseYear']].groupby('ReleaseYear').sum().reset_index()
	df3.rename(columns={'DomesticTotalGross' : 'YearlyDomesticGross'}, inplace=True)
	df2 = df2.merge(df3, how='inner', left_on='ReleaseYear', right_on='ReleaseYear')
	df2['MarketShare'] = df2['DomesticTotalGross'] / df2['YearlyDomesticGross']
	major = df2.loc[df2['MarketShare'] >= .05, 'Distributor'].unique()
	midmajor = df2.loc[(df2['MarketShare'] < .05) & (df2['MarketShare'] >= .01), 'Distributor'].unique()
	minor = df2.loc[df2['MarketShare'] < .01, 'Distributor'].unique()
	df.loc[df['Distributor'].isin(minor), 'DistributorType'] = 'Minor'
	df.loc[df['Distributor'].isin(midmajor), 'DistributorType'] = 'Mid-Major'
	df.loc[df['Distributor'].isin(major), 'DistributorType'] = df['Distributor']
	train = df.dropna(axis=0, subset=['ProductionBudget','ReleaseYear','WidestRelease','Runtime'])
	X = pd.merge(train[['ReleaseYear','WidestRelease','Runtime']], pd.get_dummies(df[['Genre','MPAARating','DistributorType','ReleaseMonth']], dummy_na = True), 
	how='left', left_index=True, right_index=True)
	y = train['ProductionBudget']
	clf = tree.DecisionTreeRegressor()
	clf = clf.fit(X,y)

	test = pd.merge(df[['ReleaseYear','WidestRelease','Runtime']], pd.get_dummies(df[['Genre','MPAARating','DistributorType','ReleaseMonth']], dummy_na = True),
	how='left', left_index=True, right_index=True)
	test.dropna(axis=0, inplace=True)
	test['EstimatedBudget'] = clf.predict(test)


	df = pd.merge(df,test['EstimatedBudget'], how='left', left_index=True, right_index=True)
	df.loc[df['ProductionBudget'].isnull(),'Est'] = '*'
	df['ProductionBudget'] = df['ProductionBudget'].fillna(df['EstimatedBudget'])
	return df

def financials(df):
	studio = [1710.2/3385, 1604.3/3229.5, 1089.5/2049.4, 1021.4/1892.0, 934.3/1765.4, 856388/1644169, 945640/1765519, 962655/1789137, 966510/1794982, 999755/1834173]
	studio = mean(studio)
	sga = [369/3041, 342/3289, 445.4/3680.50, 454.4/4129.10]
	sga = mean(sga)
	market = [835.5/2028.20, 897.6/2309.6, 1783/3446, 1559/3500, 1600/2881]
	market = mean(market)
	df['Worldwide'] = df[['DomesticTotalGross','Foreign']].sum(axis=1)
	df['Revenue'] = df['Worldwide'] * studio
	df['SGA'] = df['Worldwide'] * sga
	df['Marketing'] = df['ProductionBudget'] * market
	df['Expenses'] = df['ProductionBudget'] + df['SGA'] + df['Marketing']
	df['Net'] = df['Revenue'] - df['Expenses']
	df['ROI'] = df['Net'] / (df['ProductionBudget'] + df['Marketing'])
	return df

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='Net').head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}','Worldwide' : '${:,.2f}',
'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='ROI').head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}','Worldwide' : '${:,.2f}',
'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='Net', ascending=False).head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}',
'Worldwide' : '${:,.2f}', 'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='ROI', ascending=False).head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}',
'Worldwide' : '${:,.2f}','ProductionBudget' : '${:,.2f}'})

df = pd.DataFrame()
r = requests.get('https://www.the-numbers.com/box-office-records/worldwide/all-movies/cumulative/released-in-2019')
soup = BeautifulSoup(r.text,'html.parser')
movies = soup.find_all(href=re.compile('/movie/'))[1:]
for m in movies:
	url = 'https://www.the-numbers.com'+m.get('href')
	if requests.get(url).status_code == 200:
		df2 = pd.read_html(requests.get(url).text)
		cols = []
		values = []
		cols.append('Title')
		values.append(m.string)
		try:
			cols.append(df2[0].iat[1,0])
			values.append(df2[0].iat[1,1])
		except IndexError:
			pass
		try:
			cols.append(df2[0].iat[2,0])
			values.append(df2[0].iat[2,1])
		except IndexError:
			pass
		try:
			cols.append(df2[0].iat[3,0])
			values.append(df2[0].iat[3,1])
		except IndexError:
			pass
		try:
			for x in df2[2][0]:
				cols.append(x)
			for y in df2[2][1]:
				values.append(y)
		except IndexError:
			pass
		except KeyError:
			pass
	df3 = pd.DataFrame([values], columns=cols)
	df = df.append(df3)
df = df[[x for x in df.columns if isinstance(x,str)]]
df.rename(columns=lambda x: ''.join(x.split()).split(':')[0], inplace=True)
df.reset_index(drop=True,inplace=True)
df = df[['CreativeType', 'DomesticBoxOffice', 'DomesticReleases','Est.DomesticDVDSales', 'Franchise', 'Furtherfinancialdetails...', 'Genre', 'HomeMarketPerformance', 
'InternationalBoxOffice','InternationalReleases', 'Keywords', 'MPAARating','ProductionCompanies', 'ProductionCountries', 'ProductionBudget','ProductionMethod', 
'RunningTime', 'Source', 'Title', 'VideoRelease','WorldwideBoxOffice']]
float_cols = ['DomesticBoxOffice','InternationalBoxOffice','ProductionBudget','WorldwideBoxOffice']
df[float_cols] = df[float_cols].replace(to_replace='[^0-9.]',value='',regex=True).astype(float)
df['DomesticReleases'] = df['DomesticReleases'].str.split('(',expand=True)[0].str.strip()
df['InternationalReleases'] = df['InternationalReleases'].str.split('(',expand=True)[0].str.strip()
df['VideoRelease'] = df['VideoRelease'].str.split('(',expand=True)[0].str.strip()
df['RunningTime'] = df['RunningTime'].str.split(expand=True)[0]
df['MPAARating'] = df['MPAARating'].str.split(expand=True)[0]
df[['DomesticReleases','InternationalReleases']] = df[['DomesticReleases','InternationalReleases']].apply(pd.to_datetime,errors='coerce')
df['ReleaseYear'] = df['DomesticReleases'].dt.year
df['ReleaseMonth'] = df['DomesticReleases'].dt.month_name()
df['RunningTime'] = df['RunningTime'].apply(pd.to_timedelta, errors='coerce').dt.seconds
