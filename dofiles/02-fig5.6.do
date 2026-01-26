/* This file provides the code for generating age and renovation status of sports venues.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 

Intermediate Output (working directory):

Final Output:
Figures(figs\): 5.6a, 5.6b, 5.6c, 5.6d,
Tables (Stata viewer): 
Data (outdat\): ven_lifespans.dta
Other: 
CITED in text: Venues hosting teams 30+ years by the end of 2020s
CITED in text: Venues hosting teams 30+ years and last renovatin 15+ years by the end of 2020s

*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\venuesdb_base.dta", clear

/*Lifespan of current venues in 2025*/
g lifespan2025 = lastyear-year+1
replace lifespan2025 = lastyear-year+1
replace lifespan2025 = 2026-year if lifespan2025==.
replace lifespan2025 = 2026-year if lastyear>2025 &lastyear!=. /*Keeps age for future closures in 2025 terms*/
replace lifespan2025 = . if lifespan2025<1

sum lifespan2025 if current, detail
sum lifespan2025 if current_mlb, detail
sum lifespan2025 if current_nfl, detail
sum lifespan2025 if current_nba, detail
sum lifespan2025 if current_nhl, detail

/*Lifespan of venues in 2029 that are not scheduled to close*/
g lifespan2029 = lastyear-year+1
replace lifespan2029 = lastyear-year+1
replace lifespan2029 = 2030-year if lifespan2029==.
replace lifespan2029 = . if lifespan2029<1

g renovationspan_2025 = 2025-lastrenovation+1
g renovationspan_2029 = 2029-lastrenovation+1
replace renovationspan_2029 = 2029-future_renovation_complete+1 if future_renovation_complete!=.

save "$outdat\ven_lifespans.dta", replace

/* Data output into the data\ folder
save "$data\ven_lifespans.dta", replace
export delimited "$data\ven_lifespans.csv", replace
*/

/* Hosting Lifespan Graphs */
/*MLB*/
graph dot lifespan2025 renovationspan_2025 planned0 replacement0 if current_mlb==1, over(team_mlb, sort(1) descending label(labsize(*1.05) labgap(medsmall)) ) linetype(line) lines(lp(solid) lw(vthin) lc(gs12) ) ///
ytitle(Years, size(medsmall)) name(mlb, replace)  /// 
marker(1, msymbol(O)) marker(2, msymbol(S)) marker(3, msymbol(Sh))  marker(4, msymbol(D)) marker(5, msymbol(Dh)) ///
yline(26, lp(dash)) ylabel(0(10)20 26 30(10)110 ,grid gmax  ) /// 
plotregion(margin(zero)) ///
legend(order(1 "Hosting Tenure" 2 "Last Renovated" 4 "Future Replacement" 3 "Future Renovation"  ) ring(0) pos(5) cols(1) size(medsmall))
/*
graph export "$figs\Fig5.6a.pdf", as(pdf) replace
graph export "$tif\Fig5.6a.tif", as(tif) width(3000)  replace
*/

/*NFL*/
graph dot lifespan2025 renovationspan_2025 planned0 replacement0 announced  if current_nfl==1, over(team_nfl, sort(1) descending label(labsize(*1.05) labgap(small)) ) linetype(line) lines(lp(solid) lw(vthin) lc(gs12))  name(nfl, replace) /// 
ytitle(Years, size(medsmall)) ///
marker(1, msymbol(O)) marker(2, msymbol(S)) marker(3, msymbol(Sh)) marker(4, msymbol(D)) marker(5, msymbol(Dh)) ///
yline(25, lp(dash)) ylabel(0(10)20 25 30(10)110,grid gmax   ) /// 
plotregion(margin(zero)) ///
legend(order(1 "Hosting Tenure" 2 "Last Renovated" 4 "Future Replacement" 3 "Future Renovation" 5 "Tentative Replacement" ) ring(0) pos(5) cols(1) size(medsmall))
/*
graph export "$figs\Fig5.6b.pdf", as(pdf) replace
graph export "$tif\Fig5.6b.tif", as(tif) width(3000)  replace
*/

/*NBA*/
graph dot lifespan2025 renovationspan_2025 planned0 replacement0 if current_nba==1, over(team_nba, sort(1) descending label(labsize(*1.05) labgap(medsmall))) linetype(line) lines(lp(solid) lw(vthin) lc(gs12)) name(nba, replace)  /// 
ytitle(Years, size(medsmall)) ///
marker(1, msymbol(O)) marker(2, msymbol(S)) marker(3, msymbol(Sh)) marker(4, msymbol(D)) ///
yline(27, lp(dash)) ylabel(0(10)20 27 30(10)110,grid gmax ) /// 
plotregion(margin(zero)) ///
legend(order(1 "Hosting Tenure" 2 "Last Renovated"  4 "Future Replacement" 3 "Future Renovation" ) ring(0) pos(5) cols(1) size(medsmall))
/*
graph export "$figs\Fig5.6c.pdf", as(pdf) replace
graph export "$tif\Fig5.6c.tif", as(tif) width(3000)  replace
*/

/*NHL*/
graph dot lifespan2025 renovationspan_2025 planned0 announced0 replacement0 if current_nhl==1, over(team_nhl, sort(1) descending label(labsize(*1.05) labgap(medsmall)) ) linetype(line) lines(lp(solid) lw(vthin) lc(gs12)) ///
ytitle(Years, size(medsmall)) name(nhl, replace)  /// 
marker(1, msymbol(O)) marker(2, msymbol(S)) marker(3, msymbol(Sh)) marker(4, msymbol(Th)) marker(5, msymbol(D)) ///
yline(28, lp(dash)) ylabel(0(10)20 28 "28  " 30 "  30" 40(10)110,grid gmax ) /// Median is 28.5, but set it at 28 bc 50% obs at least 28 years old and eases interpretation
plotregion(margin(zero)) ///
legend(order(1 "Hosting Tenure" 2 "Last Renovated" 5 "Future Replacement" 3 "Future Renovation" ) ring(0) pos(5) cols(1) size(medsmall) bmargin(r=-2))
/*
graph export "$figs\Fig5.6d.pdf", as(pdf) replace
graph export "$tif\Fig5.6d.tif", as(tif) width(3000)  replace
*/

/*CITED in text: Venues hosting teams 30+ years by the end of 2020s*/
tab typelabel if lifespan2029>29 &current & lastyear==.
/*
  typelabel |      Freq.     Percent        Cum.
------------+-----------------------------------
     Arenas |         29       53.70       53.70
   Stadiums |         25       46.30      100.00
------------+-----------------------------------
      Total |         54      100.00
*/

/*CITED in text: Venues hosting teams 30+ years and last renovatin 15+ years by the end of 2020s */
tab typelabel if lifespan2029>29 &current & lastyear==. &renovationspan_2029>14 &planned_renovation!=1
/*
  typelabel |      Freq.     Percent        Cum.
------------+-----------------------------------
     Arenas |         11       50.00       50.00
   Stadiums |         11       50.00      100.00
------------+-----------------------------------
      Total |         22      100.00
	  
Forecasted replacement cost: 22 * $860 million = $18.92 billion 	  
*/