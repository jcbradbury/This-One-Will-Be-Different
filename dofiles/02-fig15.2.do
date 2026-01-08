/* This file provides the code for estimating the treatment effect of Truist Park on Cobb property values.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
propertyvpa2014_data.dta

Intermediate Output (working directory): propvpa2014pct_temp.dta

Final Output:
Figures(figs\): 15.2
Tables (Stata viewer): 
Data (outdat\): propvpa2014pct_synth.dta; propvpa2014pct.dta
Other: 
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\propertyvpa2014_data.dta", clear 

/*Include only pre-COVID years*/
drop if year>2019

/* 
CPI conversion to 2019 dollars
https://data.bls.gov/timeseries/CUUR0000SA0?amp%253bdata_tool=XGtable&output_view=data&include_graphs=true

CPI for All Urban Consumers (CPI-U)

Series Id:	CUUR0000SA0
Not Seasonally Adjusted
Series Title:	All items in U.S. city average, all urban consumers, not seasonally adjusted
Area:	U.S. city average
Item:	All items
Base Period:	1982-84=100
*/

so county year

g realgrossvpa =.
replace realgrossvpa = grossvpa*1.53 if year ==1999
replace realgrossvpa = grossvpa*1.48 if year ==2000
replace realgrossvpa = grossvpa*1.44 if year ==2001
replace realgrossvpa = grossvpa*1.42 if year ==2002
replace realgrossvpa = grossvpa*1.39 if year ==2003
replace realgrossvpa = grossvpa*1.35 if year ==2004
replace realgrossvpa = grossvpa*1.31 if year ==2005
replace realgrossvpa = grossvpa*1.27 if year ==2006
replace realgrossvpa = grossvpa*1.23 if year ==2007
replace realgrossvpa = grossvpa*1.19 if year ==2008
replace realgrossvpa = grossvpa*1.19 if year ==2009
replace realgrossvpa = grossvpa*1.17 if year ==2010
replace realgrossvpa = grossvpa*1.14 if year ==2011
replace realgrossvpa = grossvpa*1.11 if year ==2012
replace realgrossvpa = grossvpa*1.1 if year ==2013
replace realgrossvpa = grossvpa*1.08 if year ==2014
replace realgrossvpa = grossvpa*1.08 if year ==2015
replace realgrossvpa = grossvpa*1.07 if year ==2016
replace realgrossvpa = grossvpa*1.04 if year ==2017
replace realgrossvpa = grossvpa*1.02 if year ==2018
replace realgrossvpa = grossvpa*1 if year ==2019

g realincome=.
replace realincome = income*1.53 if year ==1999
replace realincome = income*1.48 if year ==2000
replace realincome = income*1.44 if year ==2001
replace realincome = income*1.42 if year ==2002
replace realincome = income*1.39 if year ==2003
replace realincome = income*1.35 if year ==2004
replace realincome = income*1.31 if year ==2005
replace realincome = income*1.27 if year ==2006
replace realincome = income*1.23 if year ==2007
replace realincome = income*1.19 if year ==2008
replace realincome = income*1.19 if year ==2009
replace realincome = income*1.17 if year ==2010
replace realincome = income*1.14 if year ==2011
replace realincome = income*1.11 if year ==2012
replace realincome = income*1.1 if year ==2013
replace realincome = income*1.08 if year ==2014
replace realincome = income*1.08 if year ==2015
replace realincome = income*1.07 if year ==2016
replace realincome = income*1.04 if year ==2017
replace realincome = income*1.02 if year ==2018
replace realincome = income*1 if year ==2019

g realypc = (realincome*1000)/population
g logrealypc = log(realypc)

so countyid year
by countyid: g realgrossvpa_pctch = (realgrossvpa-L1.realgrossvpa)/L1.realgrossvpa
drop if year<2000

save "$outdat\propvpa2014pct_synth.dta", replace

/* Data output into the data\ folder
save "$data\propvpa2014pct_synth.dta", replace
export delimited "$data\propvpa2014pct_synth.csv", replace
*/

/*SCM estimate of stadium treatment effect*/
synth realgrossvpa_pctch logrealypc sq_miles commercialpct popdens  millage hpiwith2000base distanceturner  ///
realgrossvpa_pctch(2000(1)2013) realgrossvpa_pctch(2000)  realgrossvpa_pctch(2006) realgrossvpa_pctch(2013), ///
trunit(7) trperiod(2014)   ///
counit(1 2 3 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29) ///
nested allopt figure ///
keep(propvpa2014pct_temp.dta, replace)

use propvpa2014pct_temp.dta, clear // Saved results to make a cleaner graph

keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time year
rename _Y_treated  treat
rename _Y_synthetic counterfact2014_alt
gen predgap=treat-counterfact2014_alt

g treat100 = treat*100
g counterfact100 = counterfact2014_alt*100
sort year 

save "$outdat\propvpa2014pct.dta", replace

/*
Note: The `synth' opitmization routine with the recommended allopt and nested options for obtaining variable weights can generate minor differences in estimated treatment effects accross computing environments. Thus your machine may produce propvpa2014_pct.dta in `outdat\' that differs slightly from mine. 
*/

use "$data\propvpa2014pct.dta", clear

/* Fig 15.2 */
mylabels -10(5)15, suffix(%) myscale(@) local(pctsyn) format(%2.0fc) 
twoway (line treat100 year , lp(solid) lc(black) lw(thin)) /// 
	(line counterfact100 year , lp(dash) lc(black) lw(vthin)), ///
	ttext( 10 2017 "Truist Park  ""opens →", place(w) yaxis(1) xaxis(1))  ///
	ttext(10  2014 "First assessment → ""post-announcement ", place(w)) ///
	xtitle("Year", size(medlarge))  ///
	ytitle("Assessed Value per Acre" "(Annual % change)", size(medlarge)) ///
	xline(2017, lpattern(longdash) lcolor(black) lw(medium)) ///
	xline(2014, lpattern(shortdash_dot) lcolor(black)) ///
	ylabel(`pctsyn', format(%9.2fc) angle(horizontal) labsize(medium)) ///
	xlabel(2000(1)2019, angle(45) labsize(medium)) ///
	legend(order(1 "Cobb" 2 "Synthetic Cobb") cols(1) ring(0) pos(7) symxsize(11) bmargin(small)  size(medium)) ///
	plotregion(margin() ) ///
	name(countyvpasynth_pct, replace)
/*
graph export "$figs\Fig15.2.pdf", as(pdf) replace
graph export "$tif\Fig15.2.tif", as(tif) width(3000)  replace
*/