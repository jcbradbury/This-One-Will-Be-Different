/* This file provides the code for estimating the percentage change Cobb property values.

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
CPdata_2020_2023.dta

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

Intermediate Output (working directory):

Final Output:
Figures(figs\): 15.1
Tables (Stata viewer): 
Data (outdat\): propertyvpa2014_meanch.dta
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
drop if year<2003
append using  "$data\CPdata_2020_2023.dta", // adds recent data

so countyid year

/*Identify each county's Gross Digest Value per Acre in 2013*/
g grossvpa2013 = grossvpa if year==2013
by countyid: egen meangrossvpa2013 = mean(grossvpa2013)
replace grossvpa2013 = meangrossvpa2013 if grossvpa2013==.

/*Record the change in property value in percentage terms*/
g pctdifgrossvpa2013 = ((grossvpa-grossvpa2013)/grossvpa2013)*100
label variable pctdifgrossvpa2013 "% Difference from 2013"
format pctdifgrossvpa2013 %9.2f

save "$outdat\propertyvpa2014_meanch.dta", replace

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
