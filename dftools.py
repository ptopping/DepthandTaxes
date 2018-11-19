import pandas as pd
import numpy as np

def make_labels(label_sheet,year):
	label_sheet.rename(columns={0 : 'ABBREVIATION', 2 : 'PARTYNAME'}, inplace=True)
	label_sheet.set_index('ABBREVIATION', inplace=True)
	label_sheet.index = label_sheet.index.str.replace(' ','')
	label_sheet.index = label_sheet.index.str.strip()
	label_sheet.PARTYNAME = label_sheet.PARTYNAME.str.strip()
	return label_sheet['PARTYNAME']

class FECLoad(object):
	"""docstring for ElectionResults"""
	def __init__(self, excel, year, is_pres=True, is_primary=False, is_house=False):
		self.year = year
		self.is_pres = is_pres
		self.is_primary = is_primary
		self.is_house = is_house
		if year == 2016:
			self.excel = pd.read_excel('C:\\Users\\ptopp\\Documents\\DepthandTaxes\\{file}.xlsx'.format(file=excel), header=None, sheet_name=None)
			self.pres_general = self.excel.get('2016 Pres General Results')
			self.pres_primary = self.excel.get('2016 Pres Primary Results')
			self.senate = self.excel.get('2016 US Senate Results by State')
			self.house = self.excel.get('2016 US House Results by State')
			self.labels = self.excel.get('2016 Party Labels')
			self.dates = self.excel.get('2016 Primary Dates')

		else:
			self.excel = pd.read_excel('C:\\Users\\ptopp\\Documents\\DepthandTaxes\\{file}.xls'.format(file=excel), header=None, sheet_name=None)

			if year == 2000:
				if is_pres == True:
					if is_primary == False:
						self.pres_general = self.excel.get('Master By State')

					if is_primary == True:
						self.pres_primary = self.excel.get('Primary Results by State')
						self.dates = self.excel.get('2000 Primary Dates (President)')
				
				if is_pres == False:
					if is_house == False:
						self.senate = self.excel.get('U.S. Senate (Master by State)')
						
					if is_house ==True:
						self.house = self.excel.get('U.S. House (Master by State)')
					
					self.dates = self.excel.get('2000 Primary Dates (Congress)')

				self.labels = self.excel.get('Guide to 2000 Party Labels')

			if year == 2002:
				self.congress = self.excel.get('2002 House & Senate Results')
				self.labels = self.excel.get('2002 Party Labels')
				self.dates = self.excel.get('2002 Primary Dates (Congress)')

			if year == 2004:
				self.pres_general = self.excel.get('2004 PRES GENERAL RESULTS')
				self.pres_primary = self.excel.get('2004 PRES GENERAL RESULTS')
				self.congress = self.excel.get('2004 US HOUSE & SENATE RESULTS')
				self.labels = self.excel.get('2004 Party Labels')
				self.dates = self.excel.get('2004 Primary Dates (Congress)')

			if year == 2006:
				self.congress = self.excel.get('2006 US House & Senate Results')
				self.labels = self.excel.get('2006 Party Labels')
				self.dates = self.excel.get('2006 Primary Dates (Congress)')

			if year == 2008:
				self.pres_general = self.excel.get('2008 Pres General Results')
				self.pres_primary = self.excel.get('2008 Pres Primary Results')
				self.congress = self.excel.get('2008 House and Senate Results')
				self.labels = self.excel.get('2008 Party Labels')
				self.dates = self.excel.get('2008 Primary Dates')

			if year == 2010:
				self.congress = self.excel.get('2010 US House & Senate Results')
				self.labels = self.excel.get('2010 Party Labels')
				self.dates = self.excel.get('2010 Primary Dates')

			if year == 2012:
				self.pres_general = self.excel.get('2012 Pres General Results')
				self.pres_primary = self.excel.get('2012 Pres Primary Results')
				self.congress = self.excel.get('2012 US House & Senate Resuts')
				self.labels = self.excel.get('2012 Party Labels')
				self.dates = self.excel.get('2012 Primary Dates')

			if year == 2014:
				self.senate = self.excel.get('2014 US Senate Results by State')
				self.house = self.excel.get('2014 US House Results by State')
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
			if is_pres == True:
				if is_primary == False:
					#Set variables
					col_list = ['STATE', 'CANDIDATE', 'PARTY', '#OFVOTES']
					col_dict = {'STATE' : 'POSTAL', '#OFVOTES' : 'GENERAL'}
					party_dict = {'I(GRN)' : 'GRN', 'I(LBT)' : 'LBT', 'I(REF)' : 'REF', 'I(I)' : 'I', 'I(SOC)' : 'SOC', 'I(CON)' : 'CON', 'I(SWP)' : 'SWP', 'PRO/GRN' : 'PRO'}
					pesky_labels = {'Republican Party' : 'Republican', 'Democratic Party' : 'Democratic'}
					
					#Set column headers
					df1 = self.pres_general
					df1.rename(columns=df1.iloc[0],inplace=True)
					df1.drop(df1.index[0],inplace=True)
					df1.columns = df1.columns.str.replace(' ','')

					#Remove extraneous records
					df1.dropna(subset=['PARTY'],how='any',inplace=True)

					#Select and rename wanted columns
					cols = [c for c in col_list if c in df1.columns]
					df = df1[cols]
					df.rename(columns=col_dict,inplace=True)

					#Tidy columns
					df.loc[:,'POSTAL'] = df.POSTAL.str.strip()
					df.loc[:,'CANDIDATE'] = df.CANDIDATE.str.strip()
					df.loc[:,'PARTY'] = df.PARTY.str.replace(' ','')
					df.loc[:,'PARTY'] = df.PARTY.str.strip()
					df.loc[:,'PARTY'].replace(party_dict,inplace=True)
					df.loc[:,'PARTY'].replace(label_dict,inplace=True)
					df.loc[:,'PARTY'].replace(pesky_labels,inplace=True)
					df.loc[:,'GENERAL'] = df.GENERAL.apply(pd.to_numeric)

				if is_primary == True:
					#Set variables
					col_list = ['STATE', 'CANDIDATE', 'PARTY', '#OFVOTES']
					col_dict = {'STATE' : 'POSTAL', '#OFVOTES' : 'PRIMARY'}
					party_dict = {'W(D)' : 'D', 'W(R)' : 'R', 'W(GRN)' : 'GRN', 'W(REF)' : 'REF', 'W(N)' :'N', 'UN(R)' : 'R', 'UN(D)' :'D'}
					pesky_labels = {'Republican Party' : 'Republican', 'Democratic Party' : 'Democratic'}
					
					#Set column headers
					df1 = self.pres_primary
					df1.rename(columns=df1.iloc[0],inplace=True)
					df1.drop(df1.index[0],inplace=True)
					df1.columns = df1.columns.str.replace(' ','')

					#Remove extraneous records
					df1.dropna(subset=['PARTY'],how='any',inplace=True)
					df1 = df1[df1['CANDIDATE'] != 'Total Party Votes']

					#Select and rename wanted columns
					cols = [c for c in col_list if c in df1.columns]
					df = df1[cols]
					df.rename(columns=col_dict,inplace=True)

					#Tidy columns
					df.loc[:,'POSTAL'] = df.POSTAL.str.strip()
					df.loc[:,'CANDIDATE'] = df.CANDIDATE.str.strip()
					df.loc[:,'PARTY'] = df.PARTY.str.replace(' ','')
					df.loc[:,'PARTY'] = df.PARTY.str.strip()
					df.loc[:,'PARTY'].replace(party_dict,inplace=True)
					df.loc[:,'PARTY'].replace(label_dict,inplace=True)
					df.loc[:,'PARTY'].replace(pesky_labels,inplace=True)
					df.loc[:,'PRIMARY'] = df.PRIMARY.apply(pd.to_numeric)

		return df


class ElectionResults(FECLoad):
	"""docstring for ElectionResults"""
	def __init__(self, excel, year, is_pres=True, is_primary=False, is_house=False):
		super().__init__(excel, year, is_pres=True, is_primary=False, is_house=False)
		self.excel = excel
		
