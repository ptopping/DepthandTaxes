import pandas as pd
import seaborn as sns
import requests
import re
import numpy as np
from bs4 import BeautifulSoup
from statistics import mean
import matplotlib.pyplot as plt

# df = pd.read_html('https://www.boxofficemojo.com/yearly/chart/?yr=2018&p=.htm')
# df = df[3]
# df.columns = df.iloc[0]
# df = df.reindex(df.index.drop(0))
# df.rename(columns={df.columns[2]: 'Studio'}, inplace=True)

r = requests.get('https://www.boxofficemojo.com/yearly/chart/?yr=2018&p=.htm')
soup = BeautifulSoup(r.text,'html.parser')
movies = soup.find_all(href=re.compile('movies'))[1:]

df = pd.DataFrame()

for m in movies:
	url = 'https://www.boxofficemojo.com'+m.get('href')
	r = requests.get(url)
	movie_df = pd.read_html(url)
	title = m.string
	DTG = float(''.join(re.findall('\d+',movie_df[8].iloc[0,1])))
	dis = movie_df[4].iloc[1,0][13:]
	genre = movie_df[4].iloc[2,0][7:]
	rating = movie_df[4].iloc[3,0][13:]
	if len(re.findall('\d+\.*\d*',movie_df[4].iloc[3,1])) != 0:
		budget = float(''.join(re.findall('\d+\.*\d*',movie_df[4].iloc[3,1])))
	else:
		budget = np.nan
	try:
		foreign = float(''.join(re.findall('\d+',movie_df[8].iloc[1,1])))
	except IndexError:
		foreign = np.nan
	except TypeError:
		foreign = np.nan
	df2 = pd.DataFrame([[title, DTG, dis, genre, rating, budget, foreign]], 
	columns = ['Title','DomesticTotalGross', 'Distributor', 'Genre', 'MPAARating', 'ProductionBudget', 'Foreign'])
	df = df.append(df2)

studio = [1710.2/3385, 1604.3/3229.5, 1089.5/2049.4, 1021.4/1892.0, 934.3/1765.4, 856388/1644169, 945640/1765519, 962655/1789137, 966510/1794982, 999755/1834173]
studio = mean(studio)
sga = [369/3041, 342/3289, 445.4/3680.50, 454.4/4129.10]
sga = mean(sga)
market = [835.5/2028.20, 897.6/2309.6, 1783/3446, 1559/3500, 1600/2881]
market = mean(market)

df['Worldwide'] = df[['DomesticTotalGross','Foreign']].sum(axis=1)
df['ProductionBudget'] = df['ProductionBudget'] * 1000000
df['Revenue'] = df['Worldwide'] * studio
df['SGA'] = df['Worldwide'] * sga
df['Marketing'] = df['ProductionBudget'] * market
df['Expenses'] = df['ProductionBudget'] + df['SGA'] + df['Marketing']
df['Net'] = df['Revenue'] - df['Expenses']
df['ROI'] = df['Net'] / (df['ProductionBudget'] + df['Marketing'])

df.dropna(axis=0, inplace=True)

test = test.reset_index(drop=True)

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='Net').head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}','Worldwide' : '${:,.2f}',
'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='ROI').head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}','Worldwide' : '${:,.2f}',
'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='Net', ascending=False).head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}',
'Worldwide' : '${:,.2f}', 'ProductionBudget' : '${:,.2f}'})

test[['Title','Distributor','ProductionBudget','Worldwide','Net','ROI']].sort_values(by='ROI', ascending=False).head().style.format({'ROI': '{:.2%}', 'Net' : '${:,.2f}',
'Worldwide' : '${:,.2f}','ProductionBudget' : '${:,.2f}'})
