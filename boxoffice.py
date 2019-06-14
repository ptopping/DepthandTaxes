import pandas as pd
import seaborn as sns
import requests
from bs4 import BeautifulSoup

r = requests.get('https://www.boxofficemojo.com/yearly/chart/?yr=2018&p=.htm')
soup = BeautifulSoup(r.text,'html.parser')
soup.find_all('a')



x = pd.read_html('https://www.boxofficemojo.com/yearly/chart/?yr=2018&p=.htm')
y = x[3]

y = pd.read_html('https://www.boxofficemojo.com/movies/?id=marvel2017b.htm')
y[4]
