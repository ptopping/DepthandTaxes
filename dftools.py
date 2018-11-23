import pandas as pd
import numpy as np

def make_labels(label_sheet,year):
	label_sheet.rename(columns={0 : 'ABBREVIATION', 2 : 'PARTYNAME'}, inplace=True)
	label_sheet.set_index('ABBREVIATION', inplace=True)
	label_sheet.index = label_sheet.index.str.replace(' ','')
	label_sheet.index = label_sheet.index.str.strip()
	label_sheet.PARTYNAME = label_sheet.PARTYNAME.str.strip()
	return label_sheet['PARTYNAME']

def make_headers(df,year):
	df.rename(columns=df.iloc[0],inplace=True)
	df.drop(df.index[0],inplace=True)
	df.columns = df.columns.str.replace(' ','')
	return df

class FECLoad(object):
	"""docstring for ElectionResults"""
	def __init__(self, excel, year, is_pres=True, is_primary=False, is_house=False):
		self.year = year
		self.is_pres = is_pres
		self.is_primary = is_primary
		self.is_house = is_house
		self.results_cleanup = {'*' : np.nan, 'Unopposed' : np.nan, ' ' : np.nan}

# 'STATEABBREVIATION', 'STATE', 'DISTRICT', 'FECID', 'INCUMBENTINDICATOR', 'CANDIDATENAME', 'PARTY', 'PRIMARYVOTES', 'RUNOFFVOTES', 'GENERALVOTES', 'GERUNOFFELECTIONVOTES',
# 'GENERALELECTIONDATE', 'PRIMARYDATE'

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
					#Remove extraneous records
					df = self.pres_general
					df.dropna(subset=['PARTY'],how='any',inplace=True)

					#Make sure numeric dtypes are numeric
					df.loc[:,'#OFVOTES'] = df['#OFVOTES'].apply(pd.to_numeric)

				if is_primary == True:
					#Remove extraneous records
					df = self.pres_primary
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['CANDIDATE'] != 'Total Party Votes']

					#Make sure numeric dtypes are numeric
					df.loc[:,'#OFVOTES'] = df['#OFVOTES'].apply(pd.to_numeric)

				# 	#Rename Local columns
				# 	df.rename(columns={'#OFVOTES' : 'PRIMARYVOTES'},inplace=True)
				
				# #Add needed columns
				# df.loc[:,'YEAR'] = year #TODO unmangle 2000 Presidential Primary dates
				# df.loc[:, 'DISTRICT'] = 'President'

			if is_pres == False:
				if is_house == True:
					#Remove extraneous records
					df = self.house
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Make sure numeric dtypes are numeric
					df['PRIMARYRESULTS'].replace(self.results_cleanup,inplace=True)
					df.loc[:,'RUNOFFRESULTS'] = df['RUNOFFRESULTS'].apply(pd.to_numeric)
					df['GENERALRESULTS'].replace(self.results_cleanup,inplace=True)
					

				if is_house == False:
					#Remove extraneous records
					df = self.senate
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Make sure numeric dtypes are numeric
					df['PRIMARYRESULTS'].replace(self.results_cleanup,inplace=True)
					df.loc[:,'RUNOFFRESULTS'] = df['RUNOFFRESULTS'].apply(pd.to_numeric)
					df.loc[:,'GENERALRESULTS'] = df['GENERALRESULTS'].apply(pd.to_numeric)

			# 	#Add needed columns
			# 	df.loc[:,'YEAR'] = year #TODO unmangle 2000 Primary dates

			# #For 2000 need to rename STATE to STATEABBREVIATION
			# df.rename(columns={'STATE' : 'STATEABBREVIATION'},inplace=True)

		elif year == 2002:
			#Create label cleanup dictionaries
			party_dict = {}

			#Remove extraneous records
			df = self.congress
			df.dropna(subset=['PARTY'],how='any',inplace=True)
			df = df[df['TOTALVOTES'] != 'Total Party Votes:']

		elif year == 2004:
			#Create label cleanup dictionaries
			party_dict = {}
			pesky_labels = {} 

			#Remove extraneous records

		# 	#For 2002 need to rename STATE to STATEABBREVIATION
		# 	df.rename(columns={'STATE' : 'STATEABBREVIATION'},inplace=True)
	
		# #Select and rename wanted columns
		# cols = [c for c in self.col_list if c in df1.columns]
		# df = df[cols]
		# df.rename(columns=self.col_dict,inplace=True)

		# #Tidy columns
		# df.loc[:,'STATEABBREVIATION'] = df.STATEABBREVIATION.str.strip()
		# df.loc[:,'CANDIDATENAME'] = df.CANDIDATENAME.str.strip()
		df.loc[:,'PARTY'] = df.PARTY.str.replace(' ','')
		df.loc[:,'PARTY'] = df.PARTY.str.strip()
		df.loc[:,'PARTY'].replace(party_dict,inplace=True)
		df.loc[:,'PARTY'].replace(label_dict,inplace=True)
		# df.loc[:,'DISTRICT'].replace(senate_dict,inplace=True)

		return df


class ElectionResults(object):
	"""docstring for ElectionResults"""
	def __init__(self, type='President'):


	
