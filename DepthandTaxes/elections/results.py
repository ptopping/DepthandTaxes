import pandas as pd
import numpy as np

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
# 		self.results_cleanup = {'*' : np.nan, 'Unopposed' : np.nan, ' ' : np.nan, '**' : np.nan, 'WINNER' : np.nan, '  ' : np.nan, '#' : np.nan, 'Winner' : np.nan, 'Unopposed   ': np.nan,
# 								'Withdrew -- after primary?': np.nan, 'Withdrew' : np.nan, 'Loser' : np.nan, '??' : np.nan, '?' : np.nan, 'C': np.nan, 'Winner*' : np.nan, 'Unopposed (R)' : np.nan,
# 								'Unopposed (C)': np.nan, '##': np.nan}
		self.col_list = ['YEAR', 'STATE', 'STATEABBREVIATION', 'DISTRICT', 'FECID', 'INCUMBENTINDICATOR', 'CANDIDATENAME', 'PARTY', 'PRIMARYVOTES', 'RUNOFFVOTES', 'GENERALVOTES', 'GERUNOFFELECTIONVOTES',
						 'GENERALELECTIONDATE', 'PRIMARYDATE']
		self.senate_dict = {'S' : 'Senator', 'S - FULL TERM' : 'Senator', 'S - UNEXPIRED TERM' : 'Senator', 'SFULL' : 'Senator', 'SUN' : 'Senator', 'S - Unexpired Term': 'Senator', 
							'S  - FULL TERM': 'Senator', 'S-UNEXPIRED TERM': 'Senator', 'S   (Full Term)': 'Senator', 'S   (Unexpired Term)': 'Senator'}
		self.postal_codes = {'AL': 'Alabama', 'AK': 'Alaska', 'AS': 'American Samoa', 'AZ': 'Arizona', 'AR': 'Arkansas', 'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
							'DC': 'District of Columbia', 'FL': 'Florida', 'GA': 'Georgia', 'GU': 'Guam', 'HI': 'Hawaii', 'ID': 'Idaho', 'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas',
							'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland', 'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi', 'MO': 'Missouri',
							'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada', 'NH': 'New Hampshire', 'NJ': 'New Jersey', 'NM': 'New Mexico', 'NY': 'New York', 'NC': 'North Carolina', 'ND': 'North Dakota',
							'MP': 'Northern Mariana Islands', 'OH': 'Ohio', 'OK': 'Oklahoma', 'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island', 'SC': 'South Carolina', 'SD': 'South Dakota',
							'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah', 'VT': 'Vermont', 'VA': 'Virginia', 'VI': 'Virgin Islands', 'WA': 'Washington', 'WV': 'West Virginia', 'WI': 'Wisconsin',
							'WY': 'Wyoming'}

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
				self.dates = make_headers(self.excel.get('2002 Primary Dates (Congress)'),year)

			if year == 2004:
				self.pres_general =  make_headers(self.excel.get('2004 PRES GENERAL RESULTS'), year)
				self.pres_primary = make_headers(self.excel.get('2004 PRES PRIMARY RESULTS'), year)
				self.congress = make_headers(self.excel.get('2004 US HOUSE & SENATE RESULTS'), year)
				self.labels = self.excel.get('2004 Party Labels')
				self.dates = make_headers(self.excel.get('2004 Primary Dates (Congress)'),year)

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

	def make_labels(self):
		'''Creates a dictionary to map Party Abbreviations to Party Names
		Inputs
		label_sheet = Spreadsheet with party abbreviations in column 0 and party names in column 2
		year = Election year
		Outputs
		dictionary of {party abbreviation : party name}
		'''
		label_sheet = self.labels
		label_sheet.rename(columns={0 : 'ABBREVIATION', 2 : 'PARTYNAME'}, inplace=True)
		label_sheet.set_index('ABBREVIATION', inplace=True)
		label_sheet.index = label_sheet.index.str.replace(' ','')
		label_sheet.index = label_sheet.index.str.strip()
		label_sheet.PARTYNAME = label_sheet.PARTYNAME.str.strip()
		return label_sheet['PARTYNAME']
	
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
		label_dict = self.make_labels()

		if year == 2000:
			#Create label cleanup dictionaries
			party_dict = {'I(GRN)' : 'GRN', 'I(LBT)' : 'LBT', 'I(REF)' : 'REF', 'I(I)' : 'I', 'I(SOC)' : 'SOC', 'I(CON)' : 'CON', 'I(SWP)' : 'SWP', 'PRO/GRN' : 'PRO', 'W(D)' : 'D', 'W(R)' : 'R', 
			'W(GRN)' : 'GRN', 'W(REF)' : 'REF', 'W(N)' : 'N', 'UN(R)' : 'R', 'UN(D)' : 'D', 'W(LBT)' : 'LBT', 'N(D)' : 'D', 'N(R)' : 'R', '(N)LBT' : 'LBT', '(N)NL' : 'NL', 'I(TG)' : 'TG', 'I(GBJ)' : 'GBJ', 
			'I(NJC)' : 'NJC', 'W(IDP)' : 'IDP', 'W(RTL)' : 'RTL', 'W(CON)' : 'CON', 'W(WG)' : 'WG'}

			if is_pres == True:
				if is_primary == False:			
					#Make column dictionary
					col_dict = {'STATE' : 'STATEABBREVIATION', 'CANDIDATE' : 'CANDIDATENAME', '#OFVOTES' : 'GENERALVOTES'}
					
					#Remove extraneous records
					df = self.pres_general
					df.dropna(subset=['PARTY'],how='any',inplace=True)

					#Rename local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
					df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')

				if is_primary == True:
					#Make column dictionary
					col_dict = {'STATE' : 'STATEABBREVIATION', 'CANDIDATE' : 'CANDIDATENAME', '#OFVOTES' : 'PRIMARYVOTES'}
					
					#Remove extraneous records
					df = self.pres_primary
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['CANDIDATE'] != 'Total Party Votes']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)
			
					#Make sure numeric dtypes are numeric
					df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			
				#Add needed columns
				df.loc[:,'YEAR'] = year #TODO unmangle 2000 Presidential Primary dates
				df.loc[:, 'DISTRICT'] = 'President'
				df['STATE'] = df['STATEABBREVIATION'].map(self.postal_codes)

			if is_pres == False:
				if is_house == True:
					#Make column dictionary
					col_dict = {'STATE' : 'STATEABBREVIATION', 'NAME' : 'CANDIDATENAME', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'RUNOFFRESULTS' : 'RUNOFFVOTES', 'GENERALRESULTS' : 'GENERALVOTES'}
					
					#Remove extraneous records
					df = self.house
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)
					
					#Make sure numeric dtypes are numeric
					df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
					df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
					df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
					
				if is_house == False:
					#Make column dictionary
					col_dict = {'STATE' : 'STATEABBREVIATION', 'NAME' : 'CANDIDATENAME', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'RUNOFFRESULTS' : 'RUNOFFVOTES', 'GENERALRESULTS' : 'GENERALVOTES'}
					
					#Remove extraneous records
					df = self.senate
					df.dropna(subset=['PARTY'],how='any',inplace=True)
					df = df[df['PARTY'] != 'Combined']

					#Rename Local columns
					df.rename(columns=col_dict,inplace=True)

					#Make sure numeric dtypes are numeric
					df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
					df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
					df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')

				#Add needed columns
				df.loc[:,'YEAR'] = year #TODO unmangle 2000 Primary dates
				df['STATE'] = df['STATEABBREVIATION'].map(self.postal_codes)

		elif year == 2002:
			#Create local dictionaries
			party_dict = {'W(D)' : 'D','W(LBT)/LBT' : 'LBT', 'W(LBT)' : 'LBT', 'R/W' : 'R', 'W(R)' : 'R', 'W(DCG)' : 'DCG', 'W(IG)' : 'IG', 'W(GRN)' : 'GRN', 'W(R)/W' : 'R', 'DFL/W' : 'DFL', 
			'GRN/W' : 'GRN', 'N(R)' : 'R', 'N(D)' : 'D', 'N(LBT)' : 'LBT', 'I(GRN)' : 'GRN', 'I(LBT)' : 'LBT', 'I(NJC)' : 'NJC', 'I(SOC)' : 'SOC', 'I(AF)' : 'AF', 'I(HHD)' : 'HHD', 'I(LTI)' : 'LTI', 
			'I(HRA)' : 'HRA', 'I(AM,AC)' : 'AM', 'I(PLC)' : 'PLC', 'I(PC)' : 'PC', 'W(C)' : 'C', 'W(RTL)/RTL' : 'RTL', 'W(RTL)' : 'RTL', 'I(HP)' : 'HP', 'PROANDLU/PRO' : 'PRO', 'W(PRO)' : 'PRO',
			'RandR/D' : 'R', 'W(WG)' : 'WG', 'W(CON)' : 'CON'}
			col_dict = {'STATE' : 'STATEABBREVIATION', 'LASTNAME,FIRST' : 'CANDIDATENAME', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'RUNOFFRESULTS' : 'RUNOFFVOTES', 'GENERALRESULTS' : 'GENERALVOTES', 
			'GENERALRUNOFFRESULTS' : 'GERUNOFFELECTIONVOTES'}

			#Remove extraneous records
			df = self.congress
			df.dropna(subset=['PARTY'],how='any',inplace=True)
			df = df[df['TOTALVOTES'] != 'Total Party Votes:']
			df = df[(df['PARTY'] != 'D/WF') & (df['PARTY'] != 'R/IDP/C/RTL') & (df['PARTY'] != 'D/IDP/WF') & (df['PARTY'] != 'R/C/RTL') & (df['PARTY'] != 'R/C/IDP/RTL') & (df['PARTY'] != 'D/IDP/L/WF')
			& (df['PARTY'] != 'D/L/WF') & (df['PARTY'] != 'R/C') & (df['PARTY'] != 'R/IDP') & (df['PARTY'] != 'D/L') & (df['PARTY'] != 'R/IDP/C') & (df['PARTY'] != 'D/IDP/C/WF') & (df['PARTY'] != 'D/UC')]

			#Rename Local columns
			df.rename(columns=col_dict,inplace=True)
			
			#Make sure numeric dtypes are numeric
			df['GENERALVOTES'].replace(regex=r'\D+',value='',inplace=True)
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df['STATE'] = df['STATEABBREVIATION'].map(self.postal_codes)
			df.loc[:,'YEAR'] = year
			dates = self.dates
			dates.STATE = dates.STATE.str.strip()
			dates.STATE = dates.STATE.str.title()
			df = df.merge(dates, how='left', left_on='STATE', right_on='STATE')
			# df.loc[:,'YEAR'] = pd.to_datetime(df[:,'PRIMARYDATE']).year #TODO fix dates

		elif year == 2004:
			#Create local dictionaries
			party_dict = {'UN(D)' : 'D', 'W(R)' : 'R', 'UN(AIP)' : 'AIP', 'W(PFP)' : 'PFP', 'W(GRN)' : 'GRN', 'W(D)' : 'D', 'W(LBT)' : 'LBT', 'W(D)/D' : 'D', 'W(DCG)'  :'DCG', 'D/NP' : 'D', 
			'U(SEP)' : 'SEP', 'D/W' : 'D', 'R/W' : 'R', 'W(GR)' : 'GR', 'N(R)': 'R', 'N(D)': 'D', 'N(GRN)': 'GRN', 'N(LBT)': 'LBT', 'N(NB)': 'NB', 'W(R)/R': 'R', 'W(WF)': 'WF', 'W(C)': 'C', 
			'W(NPP)' :'NPP', 'W(R)/W': 'R', 'W(PRO)': 'PRO', 'W(WG)': 'WG', 'W(CON)': 'CON'}
			col_dict = {'LASTNAME,FIRST' : 'CANDIDATENAME', 'GENERALRESULTS' : 'GENERALVOTES', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'RUNOFF' : 'RUNOFFVOTES', 'GERUNOFF' : 'GERUNOFFELECTIONVOTES', 
			'PRIMARY' : 'PRIMARYVOTES', 'GENERAL' : 'GENERALVOTES'}

			#Remove extraneous records
			df_pg = self.pres_general
			df_pp = self.pres_primary
			df_con = self.congress
			df_pg.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)
			df_pp.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)
			df_con.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)

			#Rename Local columns
			df_pg.rename(columns=col_dict,inplace=True)
			df_pp.rename(columns=col_dict,inplace=True)
			df_con.rename(columns=col_dict,inplace=True)
			# dates = self.dates.rename(columns={self.dates.columns[0] : 'STATE', self.dates.columns[2] : 'PRIMARYDATE', self.dates.columns[3] : 'RUNOFFDATE'})

			#Merge and append
			merge_cols = ['FECID', 'STATE', 'STATEABBREVIATION','FIRSTNAME', 'LASTNAME', 'CANDIDATENAME', 'PARTY']
			df = df_pg.merge(df_pp, how='outer', left_on = merge_cols, right_on=merge_cols)
			df.loc[:, 'DISTRICT'] = 'President'
			# df_con = df_con.merge(dates, how= 'left', left_on= 'STATE', right_on= 'STATE')
			df = df.append(df_con,sort=True)

			#Make sure numeric dtypes are numeric
			df['GENERALVOTES'].replace(regex=r'\D+',value='',inplace=True)
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates
			# df['GENERALELECTIONDATE'] = pd.to_datetime(df['GENERALELECTIONDATE'],errors= 'ignore')
			# df.loc[df['GENERALELECTIONDATE'].notnull(),'YEAR'] = df['GENERALELECTIONDATE'].dt.year
			# df.loc[df['GENERALELECTIONDATE'].isnull(),'YEAR'] = year

		elif year == 2006:
			#Create local dictionaries
			party_dict = {'W(REP)' : 'REP', 'W(DEM)' : 'DEM', 'W(LBT)/LBT' : 'LBT', 'GRE/W' : 'GRE', 'REP/W' : 'REP', 'W(PAF)' : 'PAF', 'W(LBT)' : 'LBT', 'DEM/CFL*' : 'DEM', 'GRE*' : 'GRE', 
			'W(DCG)' : 'DCG', 'REP*' : 'REP', 'W(IND)' : 'IND', 'W(DEM)/DEM*' : 'DEM', 'U(IND)' : 'IND', 'N(DEM)' : 'DEM', 'N(REP)' : 'REP', 'W(IDP)' : 'IDP', 'W(DEM)/DEM' :'DEM', 
			'W(REP)/REP' : 'REP', 'DEM/W' :'DEM', 'REP/IND' : 'REP', 'W(LU)' :'LU', 'W(PRO)' :'PRO', 'W(CON)' : 'CON', 'W(WG)' : 'WG'}
			col_dict = {'LASTNAME,FIRST' : 'CANDIDATENAME', 'RUNOFF' : 'RUNOFFVOTES', 'GERUNOFF' : 'GERUNOFFELECTIONVOTES', 'PRIMARY' : 'PRIMARYVOTES', 'GENERAL' : 'GENERALVOTES'}
			
			#Remove extraneous records
			df = self.congress
			df.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)

			#Rename Local columns
			df.rename(columns=col_dict,inplace=True)

			#Make sure numeric dtypes are numeric
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates

		elif year == 2008:
			#Create label cleanup dictionaries
			party_dict = {'W(D)' : 'D', 'W(R)' : 'R', 'W(AIP)' : 'AIP', 'W(LIB)' : 'LIB', 'W(DCG)' : 'DCG', 'W(LU)' : 'LU', 'W(LBT)/LBT' : 'LBT', 'W(LBT)/W' : 'LBT', 'D/W' : 'D', 'NPA*' : 'NPA',
       		'W(D)/W' : 'D', 'R/W' : 'R', 'W(GR)' : 'GR', 'W(WF)' : 'WF', 'N(R)' : 'R', 'N(D)' : 'D', 'N(NB)' : 'NB', 'N(GRE)' : 'GRE', 'W(CON)' : 'CON', 'W(LBT)' : 'LBT', 'R/IP#' :'R','D/IP' : 'D', 
       		'W(R)/R' : 'R', 'W(NPP)'  :'NPP', 'W(LBT)/I' : 'LBT', 'W(R)/W' : 'R', 'D/R' : 'D', 'W(WG)' : 'WG'}
			col_dict = {'LASTNAME,FIRST' : 'CANDIDATENAME', 'GENERALRESULTS' : 'GENERALVOTES', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'RUNOFF' : 'RUNOFFVOTES', 'GERUNOFF' : 'GERUNOFFELECTIONVOTES', 
			'PRIMARY' : 'PRIMARYVOTES', 'GENERAL' : 'GENERALVOTES', 'FECID#' : 'FECID', 'INCUMBENTINDICATOR(I)' : 'INCUMBENTINDICATOR'}

			#Remove extraneous records
			df_pg = self.pres_general
			df_pp = self.pres_primary
			df_con = self.congress
			df_pg.dropna(subset=['PARTY'],how='any',inplace=True)
			df_pg = df_pg[df_pg['PARTY'] != 'Combined Parties:']
			df_pp.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)
			df_con.dropna(subset=['PARTY', 'CANDIDATENAME'],how='any',inplace=True)

			#Rename Local columns
			df_pg.rename(columns=col_dict,inplace=True)
			df_pp.rename(columns=col_dict,inplace=True)
			df_con.rename(columns=col_dict,inplace=True)

			#Merge and append
			merge_cols = ['FECID', 'STATE', 'STATEABBREVIATION','FIRSTNAME', 'LASTNAME', 'CANDIDATENAME', 'PARTY']
			df = df_pg.merge(df_pp, how='outer', left_on = merge_cols, right_on=merge_cols)
			df.loc[:, 'DISTRICT'] = 'President'
			df = df.append(df_con,sort=True)

			#Make sure numeric dtypes are numeric
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates

		elif year == 2010:
			#Create local dictionaries
			party_dict = {'REP/W***' : 'REP', 'W(LIB)/LIB': 'LIB', 'W(LIB)': 'LIB', 'W(GRE)/GRE': 'GRE', 'W(GRE)': 'GRE', 'W(DEM)': 'DEM', 'W(AIP)': 'AIP', 'W(REP)': 'REP', 'W(REP)/REP': 'REP', 
						'DEM/W': 'DEM', 'DEM/IND': 'DEM', 'W(DCG)': 'DCG', 'W(DEM': 'DEM', 'REP/W': 'REP', 'W(REP)/W': 'REP', 'W(DEM)/DEM': 'DEM', 'DFL': 'DFL', 'N(REP)': 'REP', 
						'N(DEM)': 'DEM', 'W(CRV)': 'CRV', 'REP/TRP': 'REP', 'CRV/TX': 'CRV', 'APP/LIB': 'APP', 'W(DNL)': 'DNL', 'W(CON)/CON': 'CON', 'PG/PRO': 'PG', 'LIB/IP*': 'LIB', 'IP*': 'IP', 
						'W(IP)*': 'IP', 'DEM/PRO/WF': 'DEM', 'REP/CON/IP*': 'REP', 'REP/IP*': 'REP', 'W(PRO)': 'PRO', 'W(WG)': 'WG'}
			col_dict = {'FECID#' : 'FECID', 'INCUMBENTINDICATOR(I)' : 'INCUMBENTINDICATOR', 'CANDIDATENAME(Last,First)' : 'CANDIDATENAME', 'PRIMARY': 'PRIMARYVOTES', 'RUNOFF': 'RUNOFFVOTES',
						'GENERAL': 'GENERALVOTES'}
			
			#Remove extraneous records
			df = self.congress
			df.dropna(subset=['PARTY', 'CANDIDATENAME(Last,First)'],how='any',inplace=True)
			df = df[df['RUNOFF'] != 'Combined Parties:']

			#Rename Local columns
			df.rename(columns=col_dict,inplace=True)
			
			#Make sure numeric dtypes are numeric
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates

		elif year == 2012:
			#Create label cleanup dictionaries
			party_dict = {'W(D)': 'D', 'W(R)': 'R', 'W(AIP)': 'AIP', 'W(DCG)': 'DCG', 'W(GR)': 'GR', 'W(LIB)/LIB': 'LIB', 'W(AE)/AE': 'AE', 'W(GRE)/GRE': 'GRE', 'W(R)/R': 'R', 'W(PAF)': 'PAF', 
						'W(LIB)': 'LIB', 'D*': 'D', 'R*': 'R', 'W(IND)': 'IND', 'D/W': 'D', 'W(D)/D': 'D', 'W(R)/W': 'R', 'N(R)': 'R', 'N(D)': 'D', 'R/TRP' : 'R', 'CRV/LIB' : 'CRV', 'W(DNL)': 'DNL', 
						'W(CON)': 'CON', 'W(GRE)': 'GRE', 'D/WF': 'D', 'LIB/PG/PRO': 'LIB', 'PG/PRO': 'PG', 'D/PRO/WF': 'D', 'R/CON': 'R', 'W(PRO)': 'PRO', 'D/IND': 'D', 'W(AE)': 'AE'}
			col_dict = {'D' : 'DISTRICT', 'FECID#': 'FECID', '(I)': 'INCUMBENTINDICATOR', 'GERUNOFFELECTIONVOTES(LA)': 'GERUNOFFELECTIONVOTES', 'LASTNAME,FIRST': 'CANDIDATENAME', 
						'GENERALRESULTS': 'GENERALVOTES', 'PRIMARYRESULTS': 'PRIMARYVOTES'}

			#Remove extraneous records
			df_pg = self.pres_general
			df_pp = self.pres_primary
			df_con = self.congress
			df_pg.dropna(subset=['PARTY'],how='any',inplace=True)
			df_pg = df_pg[df_pg['PARTY'] != 'Combined Parties:']
			df_pp.dropna(subset=['PARTY', 'LASTNAME,FIRST'],how='any',inplace=True)
			df_con.dropna(subset=['PARTY', 'CANDIDATENAME'],how='any',inplace=True)
			df_con = df_con[(df_con['PARTY'] != 'D/WF Combined Parties') & (df_con['PARTY'] != 'R/CRV/IDP Combined Parties') & (df_con['PARTY'] != 'R/CRV/IDP/TRP Combined Parties') &
					(df_con['PARTY'] != 'D/WF/IDP Combined Parties') & (df_con['PARTY'] != 'R/CRV/TRP Combined Parties') & (df_con['PARTY'] != 'D/IDP/WF Combined Parties') & 
					(df_con['PARTY'] != 'R/TRP Combined Parties') & (df_con['PARTY'] != 'R/CRV Combined Parties') & (df_con['PARTY'] != 'R/IDP Combined Parties') & 
					(df_con['PARTY'] != 'R/CRV/LIB Combined Parties')]

			#Rename Local columns
			df_pg.rename(columns=col_dict,inplace=True)
			df_pp.rename(columns=col_dict,inplace=True)
			df_con.rename(columns=col_dict,inplace=True)

			#Merge and append
			merge_cols = ['FECID', 'STATE', 'STATEABBREVIATION','FIRSTNAME', 'LASTNAME', 'CANDIDATENAME', 'PARTY']
			df = df_pg.merge(df_pp, how='outer', left_on = merge_cols, right_on=merge_cols)
			df.loc[:, 'DISTRICT'] = 'President'
			df = df.append(df_con,sort=True)

			#Make sure numeric dtypes are numeric
			df['GENERALVOTES'].replace(regex=r'\D+',value='',inplace=True)
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates

		elif year == 2014:
			#Create label cleanup dictionaries
			party_dict = {'W(LIB)/LIB': 'LIB', 'W(AE)/AE': 'AE', 'W(NOP)': 'NOP', 'W(AIP)': 'AIP', 'W(R)': 'R', 'W(LIB)': 'LIB', 'W(PAF)/PAF': 'PAF', 'W(D)': 'D', 'W(DCG)': 'DCG', 'R/W': 'R', 
						'D/W': 'D', 'N(D)': 'D', 'N(R)': 'R', 'N(LIB)': 'LIB', 'W(R)/R': 'R', 'R/TRP': 'R', 'CRV/LIB': 'CRV', 'W(DNL)': 'DNL', 'D/WF*': 'D', 'R/CON*': 'R', 'PRO/PG': 'PRO', 
						'R/CON*/IP*': 'R', 'D/PRO/WF*': 'D', 'W(LBU)': 'LBU', 'W(PRO)': 'PRO', 'W(CON)': 'CON', 'W(R)/W': 'R', 'N(DEM)': 'DEM', 'DEM/IP/PRO/WF': 'DEM'}
			col_dict = {'D': 'DISTRICT', 'FECID#': 'FECID','(I)': 'INCUMBENTINDICATOR', 'GERUNOFFELECTIONVOTES(LA)': 'GERUNOFFELECTIONVOTES'}

			#Remove extraneous records
			df_house= self.house
			df_sen = self.senate
			df_house.dropna(subset=['PARTY', 'CANDIDATENAME'],inplace= True)
			df_house=df_house[df_house['PARTY'] != 'Combined Parties:']
			df_sen.dropna(subset=['PARTY', 'CANDIDATENAME'],inplace= True)

			#Rename Local columns
			df_house.rename(columns=col_dict,inplace=True)
			df_sen.rename(columns=col_dict,inplace=True)

			#Combine dataframes
			df = df_house.append(df_sen, sort= True)

			#Make sure numeric dtypes are numeric
			df['PRIMARYVOTES'].replace(regex=r'\D+',value='',inplace=True)
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates

		elif year == 2016:
			#Create label cleanup dictionaries
			party_dict = {'REP/AIP' : 'REP','W(D)': 'D', 'W(R)': 'R','W(GR)': 'GR', 'W(IP)': 'IP', 'W(GRE)/GRE': 'GRE', 'W(LIB)': 'LIB', 'W(GRE)': 'GRE', 'W(R)/R': 'R', 'W(NOP)': 'NOP', 'R/W': 'R', 
						'W(DCG)': 'DCG', 'W(IND)': 'IND',  'W(D)/D': 'D', 'W(DNL)': 'DNL', 'D/IP': 'D', 'R/IP': 'R', 'IP/R': 'IP', 'D/PRO/WF/IP': 'D', 'R/CON': 'R', 'W(D)/W': 'D', 'W(NPP)': 'NPP', 
						'W(PPD)': 'PPD', 'D/R': 'D', 'W(PRO)': 'PRO', 'W(WG)': 'WG', 'W(CON)': 'CON'}
			col_dict = {'LASTNAME,FIRST' : 'CANDIDATENAME', 'GENERALRESULTS': 'GENERALVOTES', 'PRIMARYRESULTS' : 'PRIMARYVOTES', 'D' : 'DISTRICT', 'FECID#'  : 'FECID',
						'(I)' : 'INCUMBENTINDICATOR', 'GERUNOFFELECTIONVOTES(LA)': 'GERUNOFFELECTIONVOTES'}

			#Remove extraneous records
			df_pg = self.pres_general
			df_pp = self.pres_primary
			df_house = self.house
			df_sen = self.senate
			df_pg.dropna(subset=['PARTY', 'LASTNAME,FIRST'],inplace= True)
			df_pg = df_pg[df_pg['PARTY'] != 'Combined Parties:']
			df_pp.dropna(subset=['PARTY', 'LASTNAME,FIRST'],inplace= True)
			df_house.dropna(subset=['PARTY', 'CANDIDATENAME'],inplace= True)
			df_sen.dropna(subset=['PARTY', 'CANDIDATENAME'],inplace= True)
			
			#Rename Local columns
			df_pg.rename(columns=col_dict,inplace=True)
			df_pp.rename(columns=col_dict,inplace=True)
			df_house.rename(columns=col_dict,inplace=True)
			df_sen.rename(columns=col_dict,inplace=True)

			#Merge and append
			merge_cols = ['FECID', 'STATE', 'STATEABBREVIATION','FIRSTNAME', 'LASTNAME', 'CANDIDATENAME', 'PARTY']
			df = df_pg.merge(df_pp, how='outer', left_on = merge_cols, right_on=merge_cols)
			df.loc[:, 'DISTRICT'] = 'President'
			df = df.append(df_house,sort=True)
			df= df.append(df_sen, sort= True)
			
			#Make sure numeric dtypes are numeric
			df.loc[:,'GENERALVOTES'] = df['GENERALVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'PRIMARYVOTES'] = df['PRIMARYVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'RUNOFFVOTES'] = df['RUNOFFVOTES'].apply(pd.to_numeric, errors= 'coerce')
			df.loc[:,'GERUNOFFELECTIONVOTES'] = df['GERUNOFFELECTIONVOTES'].apply(pd.to_numeric, errors= 'coerce')			

			#Add needed columns
			df.loc[:,'YEAR'] = year #TODO unmangle Dates
			
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
		pass
