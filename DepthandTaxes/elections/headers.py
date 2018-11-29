import pandas as pd

def make_headers(df,year):
	'''Makes the first line of results dataframes the column headers
	Inputs
	df = election results dataframe
	year = Election year
	Outputs
	Election results dataframe with new column headers''' 
	df.rename(columns=df.iloc[0],inplace=True)
	df.drop(df.index[0],inplace=True)
	df.columns = df.columns.str.replace(' ','')
	return df
