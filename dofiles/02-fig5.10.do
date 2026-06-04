/* This file provides the code for generating age and renovation status of MLS stadiums.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\):
venuesdb_all.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 5.10
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

use "$data\venuesdb_all.dta", clear

keep if mls==1

replace replacement0  =0 if team_mls=="NYFC"
replace replacement0  =0 if team_mls=="Inter Miami"
replace announced0=0 if team_mls=="Chicago Fire"
replace announced0=0 if team_mls=="New England Revolution" // agreement announced 12/31/2025

g lifespan2025= lastyear-year+1
replace lifespan2025 = 2026-year if lifespan2025==.
replace lifespan2025 = 2026-year if lastyear>2025 &lastyear!=. /*Keeps age for future closures in 2025 terms*/
replace lifespan2025 = . if lifespan2025<1

g renovationspan_2025 = 2025-lastrenovation+1

save "$outdat\mls_lifespans.dta", replace


sum lifespan2025 if current_mls, detail

/*Figure 5.10*/
graph dot lifespan2025  renovationspan_2025 planned0 replacement0 announced0 if current_mls==1 |team_mls=="Inter Miami", over(team_mls, sort(1) descending label(labsize(*1.05) labgap(medsmall)) ) linetype(line) lines(lp(solid) lw(vthin) lc(gs12) ) ///
ytitle(Years, size(medsmall)) name(mls, replace)  /// xsize(4) ysize(5)
marker(1, msymbol(O))  marker(2, msymbol(S)) marker(3, msymbol(Sh)) marker(4, msymbol(D)) marker(5, msymbol(Dh)) ///   marker(5, msymbol(Dh))
yline(15, lp(dash)) ///
ylabel(0(10)10 15 20(10)110 ,grid gmax  ) /// text(27.5 51.75 "← Median Lifespan = 25", placement(e) size(medlarge)  box bcolor(white) fcolor(white)) ///
plotregion(margin(zero)) ///
legend(order(1 "Hosting Tenure" 2 "Last Renovated" 4 "Future Replacement" 3 "Future Renovation" 5 "Tentative Replacement") ring(0) pos(5) cols(1) size(medsmall))
/*
graph export "$figs\Fig5.10.pdf", as(pdf) replace
graph export "$tif\Fig5.10.tif", as(tif) width(3000)  replace
*/

