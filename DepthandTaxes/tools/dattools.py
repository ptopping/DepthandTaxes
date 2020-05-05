from matplotlib.gridspec import GridSpec
from matplotlib.patches import Ellipse
import matplotlib.pyplot as plt
import matplotlib.transforms as transforms
import numpy as np
import pandas as pd
import seaborn as sns
from scipy import stats
import statsmodels.api as sm

dat_pal = ['#29506D', '#AA3939', '#2D882D', '#AA7939', '#718EA4', '#FFAAAA',
		   '#88CC88', '#FFDBAA', '#042037', '#550000', '#004400', '#553100',
		   '#496D89', '#D46A6A', '#55AA55', '#D4A76A', '#123652', '#801515',
		   '#116611', '#805215']
light_seq_dat_pal = sns.light_palette('#29506D')
sns.set_style('whitegrid')
sns.set_palette(dat_pal)

# plt.style.use('d://depthandtaxes//depthandtaxes//plotting//dat.mplstyle')

class DataTable(object):
	"""docstring for DataTable"""
	def __init__(self, df, num_vars, nom_vars, ord_vars, labels, resp_var):
		self.df = df
		self.num_vars = num_vars
		self.nom_vars = nom_vars
		self.ord_vars = ord_vars
		self.labels = labels
		self.resp_var = resp_var
		self.df[self.num_vars] = self.df[self.num_vars].apply(pd.to_numeric)
		for v in self.nom_vars:
			self.df[v] = self.df[v].astype('category')

	def univariate_numerical_analyis(self, var, plottype='box'):
		# Boxplot and Histogram
		# gridspec_kws = dict(hspace=.01, height_ratios=[.15,.85])
		# fig, axes = plt.subplots(nrows=2, ncols=1, sharex=True, sharey=False, gridspec_kw=gridspec_kws)
		# sns.boxplot(x=self.df[var], y=None, hue=None, data=self.df, order=None, hue_order=None, orient=None, color=None, palette=None, saturation=0.75, 
		# 	width=0.5, dodge=True, fliersize=5, linewidth=None, whis=1.5, notch=False, ax=axes[0], showmeans=True, flierprops={'markerfacecolor':'C0'}, 
		# 	medianprops={'color':'C2'},meanprops={'marker':'d','markerfacecolor':'C1','markeredgecolor':'C1'})		
		if plottype == 'box':
			g = sns.boxplot(x=var, y=None, hue=None, data=self.df, order=None, hue_order=None, orient=None, color=None, palette=None, saturation=0.75, 
				width=0.5, dodge=True, fliersize=5, linewidth=None, whis=1.5, notch=False, ax=None, showmeans=True, flierprops={'markerfacecolor':'C0'}, 
				medianprops={'color':'C2'},meanprops={'marker':'d','markerfacecolor':'C1','markeredgecolor':'C1'})

		if plottype == 'dist':
			g = sns.distplot(a=self.df[var], bins=None, hist=True, kde=False, rug=False, fit=None, hist_kws=None, kde_kws=None, rug_kws=None, fit_kws=None, 
				color=None, vertical=False, norm_hist=False, axlabel=None, label=None, ax=None)

		if plottype == 'quantile':
			fig, ax = plt.subplots()
			percentiles = [.005, .025, .1, .25, .5, .75, .9, .975, .995]
			quantiles = self.df[var].to_frame().describe(percentiles=percentiles).round(3).iloc[3:]
			ax.table(cellText=quantiles.values, cellColours=None, cellLoc='right', colWidths=[.25], rowLabels=quantiles.index, rowColours=None, 
				rowLoc='left', colLabels=['Quantiles'], colColours=['C4'], colLoc='center', loc='center', bbox=None, edges='closed')
			ax.axis('off')

		if plottype == 'summary':
			fig, ax = plt.subplots()
			percentiles = [.005, .025, .1, .25, .5, .75, .9, .975, .995]
			summary = self.df[var].to_frame().describe(percentiles=percentiles).round(3).iloc[:3]
			add_ons = {var: {'std mean':self.df[var].sem(), 'sum':self.df[var].sum(), 'variance':self.df[var].var(), 'skewness':self.df[var].skew(), 
			'kurtosis':self.df[var].kurtosis(),'N missing':self.df[var].isnull().sum(),'N zero':(self.df[var]==0).sum(),'mode':self.df[var].mode()[0],
			'N Unique':len(self.df[var].unique())}}
			summary = summary.append(pd.DataFrame(add_ons)).round(3)
			ax.table(cellText=summary.values, cellColours=None, cellLoc='right', colWidths=[.25], rowLabels=summary.index, rowColours=None, rowLoc='left', 
			colLabels=['Summary'], colColours=['C4'], colLoc='center', loc='center', bbox=None, edges='closed')
			ax.axis('off')
		
		# #Quantile Table 
		# percentiles = [.005, .025, .1, .25, .5, .75, .9, .975, .995]
		# quantiles = self.df[var].to_frame().describe(percentiles=percentiles).round(3).iloc[3:]
		# summary = self.df[var].to_frame().describe(percentiles=percentiles).round(3).iloc[:3]
		# add_ons = {var: {'std mean':self.df[var].sem(), 'sum':self.df[var].sum(), 'variance':self.df[var].var(), 'skewness':self.df[var].skew(), 
		# 'kurtosis':self.df[var].kurtosis(),'N missing':self.df[var].isnull().sum(),'N zero':(self.df[var]==0).sum(),'mode':self.df[var].mode()[0],
		# 'N Unique':len(self.df[var].unique())}}
		# summary = summary.append(pd.DataFrame(add_ons)).round(3)

		# axes[1,1].table(cellText=quantiles.values, cellColours=None, cellLoc='right', colWidths=[.5], rowLabels=quantiles.index, rowColours=None, rowLoc='left', 
		# 	colLabels=['Quant.'], colColours=['C4'], colLoc='center', loc='center', bbox=None, edges='closed')
		# axes[0,1].axis('off')
		# axes[1,1].axis('off')
		# axes[0,2].axis('off')
		# axes[1,2].table(cellText=summary.values, cellColours=None, cellLoc='right', colWidths=[.65], rowLabels=summary.index, rowColours=None, rowLoc='left', 
		# 	colLabels=['Summary'], colColours=['C4'], colLoc='center', loc='center', bbox=None, edges='closed')
		# axes[1,2].axis('off')

		# fig.suptitle('{}'.format(var))

		plt.show()

	def univariate_nominal_analyis(self, var, plottype='count'):
		if plottype == 'count':
			hue_order=list(self.df[var].value_counts().index)
			g = sns.countplot(x=None, y=var, hue=var, data=self.df, order=hue_order, hue_order=hue_order, orient=None, color=None, palette=None, saturation=0.75, 
				dodge=False, ax=None)
		
		if plottype == 'freq':
			fig, ax = plt.subplots()
			freq = self.df[var].value_counts().to_frame(name='Count').join(self.df[var].value_counts(normalize=True).round(5).to_frame(name='Prob'))
			ax.table(cellText=freq.values, cellColours=None, cellLoc='right', colWidths=[.2,.2], rowLabels=freq.index, rowColours=None, rowLoc='left', 
				colLabels=freq.columns, colColours=['C4','C4'], colLoc='center', loc='center', bbox=None, edges='closed')
			ax.axis('off')
		plt.show()

	def bivariate_numerical_analysis(self,var):
		gridspec_kws = dict(height_ratios=[3,1])
		f, axes = plt.subplots(nrows=2, ncols=1, gridspec_kw=gridspec_kws, sharex = 'col')

		sns.regplot(x=var, y=self.resp_var, data=self.df, ax=axes[0], color=dat_pal[0], line_kws={'color':dat_pal[1]})

		f.suptitle('Bivariate Fit of {} by {}'.format(self.resp_var,var))

		cov = np.cov(self.df[var], self.df[self.resp_var])
		pearson = cov[0, 1]/np.sqrt(cov[0, 0] * cov[1, 1])

		ell_radius_x = np.sqrt(1 + pearson)
		ell_radius_y = np.sqrt(1 - pearson)
		ellipse = Ellipse((0, 0), width=ell_radius_x * 2, height=ell_radius_y * 2, facecolor='None', edgecolor=dat_pal[2])

		transf = transforms.Affine2D().rotate_deg(45).scale(self.df[var].std()*3, self.df[self.resp_var].std()*3).translate(self.df[var].mean(), self.df[self.resp_var].mean())
		ellipse.set_transform(transf + axes[0].transData)    
		    
		axes[0].add_patch(ellipse)

		corr, pval = stats.pearsonr(x=self.df[var], y=self.df[self.resp_var])

		tbl = pd.DataFrame({'Mean' : [round(self.df[var].mean(),5),round(self.df[self.resp_var].mean(),5)], 
			'Std Dev' : [round(self.df[var].std(),5),round(self.df[self.resp_var].std(),5)], 'Correlation':[round(corr,5),pd.np.nan], 'Signif. Prob.':[round(pval,5),pd.np.nan],
			'Number':[round(self.df[var].count(),5),np.nan]},index=[var,self.resp_var])
		tbl.fillna('',inplace=True)

		slope, intercept, r_value, p_value, std_err = stats.linregress(self.df[var],self.df[self.resp_var])

		axes[0].annotate('{0} = {1} * {2} + {3}'.format(self.resp_var,round(slope,3),var,round(intercept,3)), xy=(0.01,0.9), xycoords='axes fraction')

		axes[1].table(cellText=tbl.values,rowLabels=tbl.index,loc='center',colLabels=tbl.columns)
		axes[1].axis('off')


	def bivariate_nominal_analyis(self, var):
		g = sns.boxplot(x=var, y=self.resp_var, hue=None, data=self.df, order=None, hue_order=None, orient=None, color=None, palette=None, saturation=0.75, 
			width=0.8, dodge=True, fliersize=5, linewidth=None, whis=1.5, notch=False, ax=None)

	def eda(self, wrap=3):
		for v in self.num_vars:
			for plot in ['box','dist','quantile','summary']:
				self.univariate_numerical_analyis(v,plot)

		for v in self.nom_vars:
			for plot in ['count', 'freq']:
				self.univariate_nominal_analyis(v,plot)
			
		if self.resp_var in self.num_vars:
			for v in self.num_vars:
				self.bivariate_numerical_analysis(v)

		if self.resp_var in self.num_vars:
			for v in self.num_vars:
				self.bivariate_nominal_analyis(v)
		
		g = sns.PairGrid(self.df[self.num_vars], palette=dat_pal)
		g = g.map(plt.scatter, edgecolor='white', color=dat_pal[0])

		g = sns.FacetGrid(self.df)
		g = sns.heatmap(self.df[self.num_vars].corr(), annot=True, cmap=light_seq_dat_pal, square=True)	

			
			


	def linreg(self):
		df = self.df
		y = df[self.resp_var]
		X = df.drop(self.resp_var,axis=1)
		X = sm.add_constant(X)
		model = sm.OLS(y, X)
		results = model.fit()
		df['Predicted{}'.format(self.resp_var)] = results.fittedvalues
		df['Residuals'] = results.resid

		fig, ax = plt.subplots()
		ax.text(x=0,y=0,s=str(results.summary()), fontproperties = 'monospace')
# 'font.family': ['sans-serif'],
#  'font.sans-serif': ['Arial',
#   'DejaVu Sans',
#   'Liberation Sans',
#   'Bitstream Vera Sans',
#   'sans-serif']
		ax.axis('off')
		plt.show()
		# gridspec_kws = dict(height_ratios=[1,2,1])
		# f, axes = plt.subplots(nrows=3, ncols=1, gridspec_kw=gridspec_kws)
		fig, ax = plt.subplots()
		ax = sns.distplot(df['Residuals'], kde=False, color=dat_pal[0])
		plt.show()
		fig, ax = plt.subplots()
		ax = sns.scatterplot(x=df['Predicted{}'.format(self.resp_var)],y=df['Residuals'], color=dat_pal[0])
		plt.show()
		fig, ax = plt.subplots()
		ax = sns.distplot(results.outlier_test()['student_resid'], kde=False, color=dat_pal[0])
		plt.show()
		# f.tight_layout()
		# print(results.summary())
		# g = sns.relplot(data=df, x='Predicted{}'.format(self.resp_var), y='Residuals')
		# g = sns.FacetGrid(data=df)
		# g = g.map(plt.hist, 'Residuals')
		# return df
