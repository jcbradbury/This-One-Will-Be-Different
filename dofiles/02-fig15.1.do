/* This file provides the code for estimating the percentage change Cobb property values.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
propertyvpa2014_data.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 15.1
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

use "$data\propertyvpa2014_data.dta", clear 
drop if year<2003

/*Identify each county's Gross Digest Value per Acre in 2013*/
g grossvpa2013 = grossvpa if year==2013
by county: egen meangrossvpa2013 = mean(grossvpa2013)
replace grossvpa2013 = meangrossvpa2013 if grossvpa2013==.

/*Record the change in property value in percentage terms*/
g pctdifgrossvpa2013 = ((grossvpa-grossvpa2013)/grossvpa2013)*100
label variable pctdifgrossvpa2013 "% Difference from 2013"
format pctdifgrossvpa2013 %9.2f

save "$outdat\propertyvpa2014_meanch.dta", replace

/* Data output into the data\ folder
save "$data\.dta", replace
export delimited "$data\.csv", replace
*/

/* Fig 15.1 */
mylabels -50(25)225, suffix(%) myscale(@)  local(pct) format(%2.0fc)
#delimit;
twoway
(line pctdifgrossvpa2013  year if countyid==1, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==2, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==3, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==4, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==5, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==6, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==8, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==9, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==11, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==12, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==13, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==16, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==17, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==18, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==19, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==20, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==21, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==22, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==23, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==24, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==25, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==26, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==27, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==28, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==29, lp(solid) lw(vthin) lc(gs10))
(line pctdifgrossvpa2013  year if countyid==10, lp(longdash) lw(medthick) lc(black)) /// DeKalb
(line pctdifgrossvpa2013  year if countyid==14, lp(dash) lw(medthick) lc(black)) /// Fulton
(line pctdifgrossvpa2013  year if countyid==15, lp(shortdash) lw(medthick) lc(black)) /// Gwinnett
(line pctdifgrossvpa2013  year if county=="Cobb", lp(solid) lw(thick) lc(black)),
xline(2013, lp(vshortdash))
yline(0, lp(vshortdash))
ylabel(`pct', angle(horizontal) labsize(medlarge) gmin gmax)
xlabel(2003(1)2023, angle(45) labsize(medlarge))
legend(order(29 "Cobb" 26 "DeKalb" 27 "Fulton" 28 "Gwinnett" 1 "Other" ) ring(0) pos(11) cols(1) symxsize(12) bmargin(small) size(medium))
plotregion(margin())
ytitle("Change in Property Value per Acre" "(% difference from 2013)", size(medlarge))
xtitle("Year" , size(medlarge))
text( -40 2013 "← Truist Park announced", placement(e) size(medium) )
name(county_pctdiff, replace)
;
#delimit cr
/*
graph export "$figs\Fig15.1.pdf", as(pdf) replace
graph export "$tif\Fig15.1.tif", as(tif) width(3000)  replace
*/
