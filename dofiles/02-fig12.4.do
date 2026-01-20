/* This file provides the code for .

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Much of the analysis discussed in Chapter 12 draws from the following study:
Bradbury, John Charles (2022b) "The impact of sports stadiums on localized commercial activity: Evidence from a business improvement district," Journal of Regional Science, 62(1):194-217 (https://doi.org/10.1111/jors.12560).

The paper provides a detailed explanation of the synthetic control method (SCM) application and robustness checks.

Data Input (data\): 
CIDanalysis.dta

Intermediate Output (working directory): vpa2014_temp.dta

Final Output:
Figures(figs\): 12.4
Tables (Stata viewer): 
Data (outdat\): CIDvpa2014_treat.dta
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

use "$data\CIDanalysis.dta", clear
/* Data output into the data\ folder
export delimited "$data\CIDanalysis.csv", replace
*/

synth realvpa  commercialpct   totalmillage_i realcountyvpa2018 logrealypc2018_epolate  realvpa(2010) realvpa(2013) realvpa(2010&2013), /// 
trunit(1)  trperiod(2014)  resultsperiod(2010(1)2019) ///
nested allopt figure ///
keep(vpa2014_temp.dta, replace)

use vpa2014_temp.dta, clear // Saved results to make a cleaner graph

keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time year
rename _Y_treated  treat
rename _Y_synthetic counterfact
gen predgap=treat-counterfact
sort year 

save "$outdat\CIDvpa2014_treat.dta", replace

/*
Note: The `synth' optimization routine with the recommended allopt and nested options for obtaining variable weights can generate minor differences in estimated treatment effects across computing environments. Thus your machine may produce vpa2014_treat.dta in `outdat/' that differs slightly from mine.
*/

use "$data\CIDvpa2014_treat.dta", clear

/*Fig 12.4*/
mylabels 250000(25000)350000, prefix($) myscale(@)  local(dol) format(%7.0fc)
twoway (line treat year, lp(solid) lc(black) lw(medium)) /// 
(line counterfact year, lp(dash) lc(black) lw(medium)), ///
ttext( 260000 2017 "Truist Park opens →", place(w) yaxis(1) xaxis(1))  ///
ttext( 260000 2014 "First assessment → ""post-announcement ", place(w) yaxis(1) xaxis(1))  ///
	xtitle("Year",size(medlarge))  ///
	ytitle("Assessed Value per Acre", size(medlarge)) ///
	xline(2014, lpattern(shortdash_dot) lcolor(black)) ////
	xline(2017, lpattern(longdash) lcolor(black) lw(medthick)) ///
	ylabel(`dol', format(%9.0fc) labsize(medium)) ///
	xlabel(2010(1)2019, labsize(medium)) ///
	legend(order(1 "Cumberland" 2 "Synthetic Cumberland") cols(1) ring(0) pos(10) size(medium) symxsize(11)) ///
	name(cidsynth, replace)	
/*
graph export "$figs\Fig12.4.pdf", as(pdf) replace
graph export "$tif\Fig12.4.tif", as(tif) width(3000)  replace
*/
