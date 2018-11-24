# import pandas as pd
# import numpy as np

def make_labels(label_sheet,year):
	'''Creates a dictionary to map Party Abbreviations to Party Names
	Inputs
	label_sheet = Spreadsheet with party abbreviations in column 0 and party names in column2
	year = Election year
	Outputs
	dictionary of {party abbreviation : party name}
	'''
	label_sheet.rename(columns={0 : 'ABBREVIATION', 2 : 'PARTYNAME'}, inplace=True)
	label_sheet.set_index('ABBREVIATION', inplace=True)
	label_sheet.index = label_sheet.index.str.replace(' ','')
	label_sheet.index = label_sheet.index.str.strip()
	label_sheet.PARTYNAME = label_sheet.PARTYNAME.str.strip()
	return label_sheet['PARTYNAME']

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

class FECLoad(object):
	"""Read_excel is set up without column headers as they vary from sheet to sheet
	excel = str, Name of an excel spreadsheet
	year = int, Election year
	is_pres = Bool, presidential results or not
	is_primary = Bool, primary election or not
	is_house = Bool, house elections or not (otherwise is Senate elections)"""
	def __init__(self, excel, year, is_pres=True, is_primary=False, is_house=False):
		#Set global variables
		self.year = year
		self.is_pres = is_pres
		self.is_primary = is_primary
		self.is_house = is_house
		self.results_cleanup = {'*' : np.nan, 'Unopposed' : np.nan, ' ' : np.nan}
		self.col_list = ['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'FECID', 'INCUMBENTINDICATOR', 'CANDIDATENAME', 'PARTY', 'PRIMARYVOTES', 'RUNOFFVOTES', 'GENERALVOTES', 'GERUNOFFELECTIONVOTES',
				 'GENERALELECTIONDATE', 'PRIMARYDATE']
		self.senate_dict = {}

		#Check election year
		if year == 2016:
			self.excel = pd.read_excel('C:\\Users\\ptopp\\Documents\\DATFiles\\{file}.xlsx'.format(file=excel), header=None, sheet_name=None)
			self.pres_general = make_headers(self.excel.get('2016 Pres General Results'), year)
			self.pres_primary = make_headers(self.excel.get('2016 Pres Primary Results'), year)
			self.senate = make_headers(self.excel.get('2016 US Senate Results by State'), year)
			self.house = make_headers(self.excel.get('2016 US House Results by State'), year)
			self.labels = self.excel.get('2016 Party Labels')
			self.dates = self.excel.get('2016 Primary Dates')

		else:
			self.excel = pd.read_excel('C:\\Users\\ptopp\\Documents\\DATFiles\\{file}.xls'.format(file=excel), header=None, sheet_name=None)

			if year == 2000:
				if is_pres == True:
					if is_primary == False:
						self.pres_general = make_headers(self.excel.get('Master By State'), year)

					if is_primary == True:
						self.pres_primary = make_headers(self.excel.get('Primary Results by State'), year)
						self.dates = self.excel.get('2000 Primary Dates (President)')
				
				if is_pres == False:
					if is_house == False:
						self.senate = make_headers(self.excel.get('U.S. Senate (Master by State)'), year)
						
					if is_house ==True:
						self.house = make_headers(self.excel.get('U.S. House (Master by State)'), year)
					
					self.dates = self.excel.get('2000 Primary Dates (Congress)')

				self.labels = self.excel.get('Guide to 2000 Party Labels')

			if year == 2002:
				self.congress = make_headers(self.excel.get('2002 House & Senate Results'), year)
				self.labels = self.excel.get('2002 Party Labels')
				self.dates = self.excel.get('2002 Primary Dates (Congress)')

			if year == 2004:
				self.pres_general =  make_headers(self.excel.get('2004 PRES GENERAL RESULTS'), year)
				self.pres_primary = make_headers(self.excel.get('2004 PRES PRIMARY RESULTS'), year)
				self.congress = make_headers(self.excel.get('2004 US HOUSE & SENATE RESULTS'), year)
				self.labels = self.excel.get('2004 Party Labels')
				self.dates = self.excel.get('2004 Primary Dates (Congress)')

			if year == 2006:
				self.congress = make_headers(self.excel.get('2006 US House & Senate Results'), year)
				self.labels = self.excel.get('2006 Party Labels')
				self.dates = self.excel.get('2006 Primary Dates (Congress)')

			if year == 2008:
				self.pres_general = make_headers(self.excel.get('2008 Pres General Results'), year).iloc[:,0:13]
				self.pres_primary = make_headers(self.excel.get('2008 Pres Primary Results'), year)
				self.congress = make_headers(self.excel.get('2008 House and Senate Results'), year)
				self.labels = self.excel.get('2008 Party Labels')
				self.dates = self.excel.get('2008 Primary Dates')

			if year == 2010:
				self.congress = make_headers(self.excel.get('2010 US House & Senate Results'), year)
				self.labels = self.excel.get('2010 Party Labels')
				self.dates = self.excel.get('2010 Primary Dates')

			if year == 2012:
				self.pres_general = make_headers(self.excel.get('2012 Pres General Results'), year)
				self.pres_primary = make_headers(self.excel.get('2012 Pres Primary Results'), year)
				self.congress = make_headers(self.excel.get('2012 US House & Senate Resuts'), year)
				self.labels = self.excel.get('2012 Party Labels')
				self.dates = self.excel.get('2012 Primary Dates')

			if year == 2014:
				self.senate = make_headers(self.excel.get('2014 US Senate Results by State'), year)
				self.house = make_headers(self.excel.get('2014 US House Results by State'), year)
				self.labels = self.excel.get('2014 Party Labels')
				self.dates = self.excel.get('2014 Primary Dates')

	def pretty(self):
		'''Returns pretty dataframes of election results
		2000 = 4 Frames
		2002 and on = 1 Frame
		'''
		year = self.year
		is_pres = self.is_pres
		is_primary = self.is_primary
		is_house = self.is_house
		labels = self.labels

		#Make label dictionary
		label_dict = make_labels(labels,year)

		if year == 2000:
			#Create label cleanup dictionaries
			party_dict = {'I(GRN)' : 'GRN', 'I(LBT)' : 'LBT', 'I(REF)' : 'REF', 'I(I)' : 'I', 'I(SOC)' : 'SOC', 'I(CON)' : 'CON', 'I(SWP)' : 'SWP', 'PRO/GRN' : 'PRO', 'W(D)' : 'D', 'W(R)' : 'R', 
			'W(GRN)' : 'GRN', 'W(REF)' : 'REF', 'W(N)' : 'N', 'UN(R)' : 'R', 'UN(D)' : 'D', 'W(LBT)' : 'LBT', 'N(D)' : 'D', 'N(R)' : 'R', '(N)LBT' : 'LBT', '(N)NL' : 'NL', 'I(TG)' : 'TG', 'I(GBJ)' : 'GBJ', 
			'I(NJC)' : 'NJC', 'W(IDP)' : 'IDP', 'W(RTL)' : 'RTL', 'W(CON)' : 'CON', 'W(WG)' : 'WG'}

			if is_pres == True:
				if is_primary == False:			
					#Make column dictionary
					col_dict = {}
					
					#Remove extraneous records
					df = self.pres_general
					df.dropna(subset=['PARTY'],how='any',inplace=True)

					#Rename local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
# 					df.loc[:,'#OFVOTES'] = df['#OFVOTES'].apply(pd.to_numeric)

				if is_primary == True:
					#Make column dictionary
					col_dict = {}
					
					#Remove extraneous records
					df = self.pres_primary
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['CANDIDATE'] != 'Total Party Votes']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
# 					df.loc[:,'#OFVOTES'] = df['#OFVOTES'].apply(pd.to_numeric)
			
				#Add needed columns
				df.loc[:,'YEAR'] = year #TODO unmangle 2000 Presidential Primary dates
				df.loc[:, 'DISTRICT'] = 'President'

			if is_pres == False:
				if is_house == True:
					#Make column dictionary
					col_dict = {}
					
					#Remove extraneous records
					df = self.house
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
# 					df['PRIMARYRESULTS'].replace(self.results_cleanup,inplace=True)
# 					df.loc[:,'RUNOFFRESULTS'] = df['RUNOFFRESULTS'].apply(pd.to_numeric)
# 					df['GENERALRESULTS'].replace(self.results_cleanup,inplace=True)
					

				if is_house == False:
					#Make column dictionary
					col_dict = {}
					
					#Remove extraneous records
					df = self.senate
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
# 					df['PRIMARYRESULTS'].replace(self.results_cleanup,inplace=True)
# 					df.loc[:,'RUNOFFRESULTS'] = df['RUNOFFRESULTS'].apply(pd.to_numeric)
# 					df.loc[:,'GENERALRESULTS'] = df['GENERALRESULTS'].apply(pd.to_numeric)

				#Add needed columns
				df.loc[:,'YEAR'] = year #TODO unmangle 2000 Primary dates

			#For 2000 need to rename STATE to STATEABBREVIATION
			df.rename(columns={'STATE' : 'STATEABBREVIATION'},inplace=True)

		elif year == 2002:
			#Create local dictionaries
			party_dict = {}
			col_dict = {}

			#Remove extraneous records
			df = self.congress
			df.dropna(subset=['PARTY'],how='any',inplace=True)
			df = df[df['TOTALVOTES'] != 'Total Party Votes:']

			#Rename Local columns
			df.rename(columns=col_dict,inplace=True)
			
			#For 2002 need to rename STATE to STATEABBREVIATION
			df.rename(columns={'STATE' : 'STATEABBREVIATION'},inplace=True)
			
		elif year == 2004:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records

		elif year == 2006:
			#Create local dictionaries
			party_dict = {}
			col_dict = {}
			
			#Remove extraneous records

		elif year == 2008:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records

		elif year == 2010:
			#Create local dictionaries
			party_dict = {}
			col_dict = {}
			
			#Remove extraneous records

		elif year == 2012:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records

		elif year == 2014:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records

		elif year == 2016:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records

		#Select wanted columns
		cols = [c for c in self.col_list if c in df.columns]
		df = df[cols]

		#Tidy columns
		df.loc[:,'STATEABBREVIATION'] = df.STATEABBREVIATION.str.strip()
		df.loc[:,'CANDIDATENAME'] = df.CANDIDATENAME.str.strip()
		df.loc[:,'PARTY'] = df.PARTY.str.replace(' ','')
		df.loc[:,'PARTY'] = df.PARTY.str.strip()
		df.loc[:,'PARTY'].replace(party_dict,inplace=True)
		df.loc[:,'PARTY'].replace(label_dict,inplace=True)
		df.loc[:,'DISTRICT'].replace(self.senate_dict,inplace=True)

		return df


class ElectionResults(object):
	"""docstring for ElectionResults"""
	def __init__(self, type='President'):


	
