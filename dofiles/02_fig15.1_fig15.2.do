/* This file provides the code for estimating the effect of Truist Park on Cobb property values.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
county_digests_ypc_gdp_hpi.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\):
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

/* Data output into the data\ folder
save "$data\.dta", replace
export delimited "$data\.csv", replace
*/

use "$data\county_digests_ypc_gdp_hpi.dta", clear
so countyid year
by countyid: g realgrossvpa_pctch = (realgrossvpa-L1.realgrossvpa)/L1.realgrossvpa
drop if year<2000

synth realgrossvpa_pctch logrealypc sq_miles commercialpct popdens  millage hpiwith2000base distanceturner  ///
realgrossvpa_pctch(2000(1)2013) realgrossvpa_pctch(2000)  realgrossvpa_pctch(2006) realgrossvpa_pctch(2013), ///
trunit(7) trperiod(2014)   ///
counit(1 2 3 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29) ///
nested allopt figure ///
keep(propvpa2014_pct_temp.dta, replace)

use propvpa2014_pct_temp.dta, clear

keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time year
rename _Y_treated  treat
rename _Y_synthetic counterfact2014_alt
gen predgap=treat-counterfact2014_alt

g treat100 = treat*100
g counterfact100 = counterfact2014_alt*100
sort year 

save "$outdat\propvpa2014_pct.dta", replace

/*
Note: The `synth' opitmization routine with the recommended allopt and nested options for obtaining variable weights can generate minor differences in estimated treatment effects accross computing environments. Thus your machine may produce propvpa2014_pct.dta in `outdat\' that differs slightly from mine. 
*/

use "$data\propvpa2014_pct.dta", clear

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
	name(countyvpasynth_pct, replace)/*
graph export "$figs\Fig15.2..Y.pdf", as(pdf) replace
graph export "$tif\Fig15.2.tif", as(tif) width(3000)  replace
*/

