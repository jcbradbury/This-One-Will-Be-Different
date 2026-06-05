/* This file provides the code for estimating the treatment effect of Truist Park on Cobb property values.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Much of the analysis discussed in Chapter 15 draws from the following study:
Bradbury, John Charles (2022a) "Does hosting a professional sports team benefit the local community? Evidence from property assessments," Economics of Governance, 23(1):219–252 (https://link.springer.com/article/10.1007/s10101-022-00268-z).

The paper provides a detailed explanation of the synthetic control method (SCM) application and robustness checks.

Data repository associated with original study: https://github.com/jcbradbury/CobbProperty

Data Input (data\): 
CPdata.dta

Sources:
- County property digests: Georgia Department of Revenue: https://sso.dor.ga.gov/ (link unstable)

- County millage rates: Georgia Department of Revenue
Annual data input manually from PDF files obtained from the following sites.  
https://dor.georgia.gov/local-government-services/digest-compliance/property-tax-millage-rates
https://dor.georgia.gov/historical-georgia-county-ad-valorem-tax-digest-millage-rates (defunct link)
These data now appear to be available from University of Georgia: https://georgiadata.org/depofrevdata

- County income and population from US BEA (CAINC1: Annual Personal Income by County), 2019 data release: 11/17/2020
Direct download link: https://apps.bea.gov/regional/downloadzip.htm
Main website: https://www.bea.gov/data/income-saving/personal-income-county-metro-and-other-areas

See Source Data Files description in original paper repository for information on how to the data were compiled: https://github.com/jcbradbury/CobbProperty/tree/main/sourcefiles

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

use "$data\CPdata.dta", clear 

/* Calculate annual percentage change*/
so countyid year
by countyid: g realgrossvpa_pctch = (realgrossvpa-L1.realgrossvpa)/L1.realgrossvpa
drop if year<2000

save "$outdat\CPdata_pct.dta", replace
export delimited "$data\CPdata_pct.csv", replace


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

save "$outdat\propvpa_pct2014.dta", replace

/*
Note: The `synth' opitmization routine with the recommended allopt and nested options for obtaining variable weights can generate minor differences in estimated treatment effects accross computing environments. Thus your machine may produce propvpa2014_pct.dta in `outdat\' that differs slightly from mine. 
*/

use "$data\propvpa2014_pct.dta", clear

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