import pandas as pd
import numpy as np

class FECPull(object):
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

		#Check election year
		if year == 2016:
			self.excel = pd.read_excel('..\\DATFiles\\{file}.xlsx'.format(file=excel), header=None, sheet_name=None)
			self.pres_general = self.excel.get('2016 Pres General Results')
			self.pres_primary = self.excel.get('2016 Pres Primary Results')
			self.senate = self.excel.get('2016 US Senate Results by State')
			self.house = self.excel.get('2016 US House Results by State')
			self.labels = self.excel.get('2016 Party Labels')
			self.dates = self.excel.get('2016 Primary Dates')

		else:
			self.excel = pd.read_excel('..\\DATFiles\\{file}.xls'.format(file=excel), header=None, sheet_name=None)

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
				self.pres_general =  self.excel.get('2004 PRES GENERAL RESULTS')
				self.pres_primary = self.excel.get('2004 PRES PRIMARY RESULTS')
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

	def make_headers(self,df,header_row):
		'''Makes the first line of results dataframes the column headers
		Inputs
		df = election results dataframe
		header_row = Election year
		Outputs
		Election results dataframe with new column headers''' 
		df.rename(columns=df.iloc[header_row],inplace=True)
		df.drop(df.index[header_row],inplace=True)
		df.columns = df.columns.str.replace(' ','')
		df.index.names = ['ROWID']
		return df

	def to_csv(self):
		year = self.year
		is_pres = self.is_pres
		is_primary = self.is_primary
		is_house = self.is_house
		cols = {np.nan:'UNUSED','LASTNAME,FIRST':'LASTNAMEFIRST','TOTALVOTES#':'TOTALVOTESNUMBER','GENERAL%':'GENERALPCT','PRIMARY%':'PRIMARYPCT','FECID#':'FECID','RUNOFF%':'RUNOFFPCT',
		'GERUNOFFELECTION%(LA)':'GERUNOFFELECTIONPCT','COMBINED%(CT,NY,SC)':'COMBINEDPCT',0:'ABBREVIATION', 1:'EQUALS', 2:'PARTYNAME','#OFVOTES':'NUMBEROFVOTES','#':'IDNUMBER', 
		'GERUNOFF%':'GERUNOFFPCT','COMBINED%(NY,SC)':'COMBINEDPCT', 'COMBINED%(CT,NY)':'COMBINEDPCT','(I)':'INCUMBENT','GENERALRUNOFF%':'GENERALRUNOFFPCT','NOTES(SeeEndnotesPage)':'NOTES',
		'Notes(SeeEndnotesTab)':'NOTES','COMBINEDGEPARTYTOTALS(NY,SC)':'COMBINEDGEPARTYTOTALS', 'INCUMBENTINDICATOR(I)':'INCUMBENTINDICATOR', 'CANDIDATENAME(First)': 'CANDIDATENAMEFIRST',
		'CandidateName(Last)':'CANDIDATENAMELAST','COMBINEDGEPARTYTOTALS(CT,NY)':'COMBINEDGEPARTYTOTALS','CANDIDATENAME(Last)':'CANDIDATENAMELAST','CANDIDATENAME(Last,First)':'CANDIDATENAME',
		'COMBINEDGEPARTYTOTALS(CT,NY,SC)':'COMBINEDGEPARTYTOTALS', 'GERUNOFFELECTIONVOTES(LA)':'GERUNOFFELECTIONVOTES'}

		if year == 2016:
			df = self.make_headers(self.pres_general,0)
			df.rename(columns=cols,inplace=True)
			csv = open('..\\DATFiles\\presgeneral2016.csv','w')
			csv.write(df.to_csv())
			csv.close()							

			df = self.make_headers(self.pres_primary,0)
			df.rename(columns=cols,inplace=True)		
			csv = open('..\\DATFiles\\presprimary2016.csv','w')
			csv.write(df.to_csv())
			csv.close()							

			df = self.make_headers(self.senate,0)
			df.rename(columns=cols,inplace=True)
			csv = open('..\\DATFiles\\senate2016.csv','w')
			csv.write(df.to_csv())
			csv.close()							

			df = self.make_headers(self.house,0)
			df.rename(columns=cols,inplace=True)
			csv = open('..\\DATFiles\\house2016.csv','w')
			csv.write(df.to_csv())
			csv.close()							
			
			df = self.labels
			df.rename(columns=cols,inplace=True)
			df = df.iloc[5:,]
			df.index.names = ['ROWID']
			csv = open('..\\DATFiles\\labels2016.csv','w')
			csv.write(df.to_csv())
			csv.close()

			df = self.make_headers(self.dates,4)
			df.columns = ['STATE1','PRESIDENTIALPRIMARYDATE', 'PRESIDENTIALCAUCUSDATE', 'UNUSED','SENATE','STATE','CONGRESSIONALPRIMARY','CONGRESSIONALRUNOFF']
			csv = open('..\\DATFiles\\dates2016.csv','w')
			csv.write(df.to_csv())
			csv.close()

		else:

			if year == 2000:
				if is_pres == True:
					if is_primary == False:
						df = self.make_headers(self.pres_general,0)
						df.rename(columns=cols,inplace=True)
						csv = open('..\\DATFiles\\presgeneral2000.csv','w')
						csv.write(df.to_csv())
						csv.close()							

					if is_primary == True:
						df = self.make_headers(self.pres_primary,0)
						df.rename(columns=cols,inplace=True)
						csv = open('..\\DATFiles\\presprimary2000.csv','w')
						csv.write(df.to_csv())
						csv.close()
						
						df = self.make_headers(self.dates,0)
						csv = open('..\\DATFiles\\presprimarydates2000.csv','w')
						csv.write(df.to_csv())
						csv.close()						

				if is_pres == False:
					if is_house == False:
						df = self.make_headers(self.senate,0)
						csv = open('..\\DATFiles\\senate2000.csv','w')
						csv.write(df.to_csv())
						csv.close()						
						
					if is_house ==True:
						df = self.make_headers(self.house,0)
						csv = open('..\\DATFiles\\house2000.csv','w')
						csv.write(df.to_csv())
						csv.close()						

					df = self.make_headers(self.dates,0)
					df.rename(columns=cols,inplace=True)
					csv = open('..\\DATFiles\\congressprimarydates2000.csv','w')
					csv.write(df.to_csv())
					csv.close()

				df = self.labels
				df.rename(columns=cols,inplace=True)
				df.index.names = ['ROWID']
				csv = open('..\\DATFiles\\labels2000.csv','w')
				csv.write(df.to_csv())
				csv.close()
					
			if year == 2002:
				df = self.make_headers(self.congress,0)
				df.rename(columns=cols,inplace=True)				
				csv = open('..\\DATFiles\\congress2002.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.labels
				df.rename(columns=cols,inplace=True)
				df = df.iloc[3:,]
				df.index.names = ['ROWID']			
				csv = open('..\\DATFiles\\labels2002.csv','w')
				csv.write(df.to_csv())
				csv.close()

				df = self.make_headers(self.dates,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\primarydates2002.csv','w')
				csv.write(df.to_csv())
				csv.close()

			if year == 2004:
				df = self.make_headers(self.pres_general,0)
				df.rename(columns=cols,inplace=True)				
				csv = open('..\\DATFiles\\presgeneral2004.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.pres_primary,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\presprimary2004.csv','w')
				csv.write(df.to_csv())
				csv.close()			
				
				df = self.make_headers(self.congress,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\congress2004.csv','w')
				csv.write(df.to_csv())
				csv.close()			
				
				df = self.labels
				df.rename(columns=cols,inplace=True)
				df = df.iloc[7:,]
				df.index.names = ['ROWID']
				csv = open('..\\DATFiles\\labels2004.csv','w')
				csv.write(df.to_csv())
				csv.close()

				df = self.make_headers(self.dates,2)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\primarydates2004.csv','w')
				csv.write(df.to_csv())
				csv.close()


			if year == 2006:
				df = self.make_headers(self.congress,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\congress2006.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.labels
				df.rename(columns=cols,inplace=True)
				df = df.iloc[7:,]			
				df.index.names = ['ROWID']
				csv = open('..\\DATFiles\\labels2006.csv','w')
				csv.write(df.to_csv())
				csv.close()

				df = self.make_headers(self.dates,2)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\primarydates2006.csv','w')
				csv.write(df.to_csv())
				csv.close()

			if year == 2008:
				df = self.make_headers(self.pres_general,0)
				df.rename(columns=cols,inplace=True)
				df = df.iloc[:,:-1]
				csv = open('..\\DATFiles\\presgeneral2008.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.pres_primary ,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\presprimary2008.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.congress ,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\congress2008.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.labels 
				df.rename(columns=cols,inplace=True)
				df = df.iloc[5:,]
				df.index.names = ['ROWID']
				csv = open('..\\DATFiles\\labels2008.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.dates,2)
				df.columns = ['STATE1',  'PRESIDENTIALPRIMARYDATE','PRESIDENTIALCAUCUSDATE','UNUSED','SENATEINDICATOR','STATE','CONGRESSIONALPRIMARYDATE','CONGRESSIONALRUNOFFDATE']
				csv = open('..\\DATFiles\\primarydates2008.csv','w')
				csv.write(df.to_csv())
				csv.close()			

			if year == 2010:
				df = self.make_headers(self.congress ,0)
				df.rename(columns=cols,inplace=True)
				df = df.iloc[:,:-1]
				csv = open('..\\DATFiles\\congress2010.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.labels 
				df.rename(columns=cols,inplace=True)
				df = df.iloc[5:,]
				df.index.names = ['ROWID']
				csv = open('..\\DATFiles\\labels2010.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.dates ,2)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\primarydates2010.csv','w')
				csv.write(df.to_csv())
				csv.close()			

			if year == 2012:
				df = self.make_headers(self.pres_general ,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\presgeneral2012.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.pres_primary ,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\presprimary2012.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.congress,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\congress2012.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.labels
				df.index.names = ['ROWID']
				df.rename(columns=cols,inplace=True)
				df = df.iloc[5:,]
				csv = open('..\\DATFiles\\labels2012.csv','w')
				csv.write(df.to_csv())
				csv.close()			

				df = self.make_headers(self.dates,4)
				df.columns = ['STATE1','PRESIDENTIALPRIMARYDATE','PRESIDENTIALCAUCUSDATE','UNUSED','SENATEINDICATOR','STATE','CONGRESSIONALPRIMARYDATE','CONGRESSIONALRUNOFFDATE']
				csv = open('..\\DATFiles\\primarydates2012.csv','w')
				csv.write(df.to_csv())
				csv.close()			

			if year == 2014:
				df = self.make_headers(self.senate ,0)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\senate2014.csv','w')
				csv.write(df.to_csv(encoding='utf-8'))
				csv.close()			

				df = self.make_headers(self.house ,0)
				df.loc[:,'CANDIDATENAME(First)'] = df.loc[:,'CANDIDATENAME(First)'].str.replace('\u0101','a')
				df.loc[:,'CANDIDATENAME(Last)'] = df.loc[:,'CANDIDATENAME(Last)'].str.replace('\u0101','a')
				df.loc[:,'CANDIDATENAME'] = df.loc[:,'CANDIDATENAME'].str.replace('\u0101','a')
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\house2014.csv','w')
				csv.write(df.to_csv(encoding='utf-8'))
				csv.close()			

				df = self.labels
				df.index.names = ['ROWID']
				df.rename(columns=cols,inplace=True)
				df = df.iloc[5:,]
				csv = open('..\\DATFiles\\labels2014.csv','w')
				csv.write(df.to_csv(encoding='utf-8'))
				csv.close()			

				df = self.make_headers(self.dates,4)
				df.rename(columns=cols,inplace=True)
				csv = open('..\\DATFiles\\primarydates2014.csv','w')
				csv.write(df.to_csv(encoding='utf-8'))
				csv.close()			
