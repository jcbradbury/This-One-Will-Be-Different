/* This file provides the code for tracking MLS stadium openings.

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
Figures(figs\): 5.8
Tables (Stata viewer): 
Data (outdat\): venue_count_mls.dta
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

/* Generate MLS stadium counts by category*/
by year: egen mlscount= sum(stadium) if mls==1
by year: egen mlsNFL= sum(stadium) if league=="NFL/MLS"
by year: egen mlsMLB= sum(stadium) if league=="MLB/MLS"
by year: egen mlsCFL= sum(stadium) if league=="MLS/CFL"
by year: egen mlscollege= sum(stadium) if venuename_tex =="Snapdragon Stadium"
by year: egen mlsonly= sum(stadium) if league=="MLS" & venuename_tex !="Snapdragon Stadium"

collapse mls mlscount mlsNFL mlsMLB mlsCFL mlscollege mlsonly, by(year)

replace mlscount= 0 if mlscount==.
replace mlsNFL= 0 if mlsNFL==.
replace mlsMLB= 0 if mlsMLB==.
replace mlsCFL= 0 if mlsCFL==.
replace mlscollege= 0 if mlscollege==.
replace mlsonly= 0 if mlsonly==.

save "$outdat\venue_count_mls.dta", replace


tabstat mls*, by(year) stats(sum)

/*Figure 5.8*/
twoway bar mlscount year if mls==1 & year>1979, bc(gs15) blc(gs8) blw(thin) /// 
|| bar mlscollege year if year>1979, bc(gs12) blc(gs8) blw(thin) ///
|| bar mlsCFL year if mls==1 & year>1979, bc(gs8) blc(gs6) blw(thin) ///
|| bar mlsNFL year if year>1979, bc(gs0) blc(gs8) blw(thin) ///
|| bar mlsMLB year if year>1979, bc(gs3) blc(gs8) blw(thin) ///
ytitle("MLS Stadiums Opened", size(medlarge)) ///
xtitle(,size(medlarge)) ///
xlabel(1980(5)2030,labsize(medlarge)) ///
ylabel(0(1)3,labsize(medlarge)) ///
legend(order(1 "MLS only (25)" 2 "MLS/CFB (1)"  3 "MLS/CFL (2)"  5 "MLS/MLB (1)"     4  "MLS/NFL (4)"  ) ring(0) pos(11) cols(1) size(medium)) ///
name(mls_count, replace)
/*
graph export "$figs\Fig5.8.pdf", as(pdf) replace
graph export "$tif\Fig5.8.tif", as(tif) width(3000)  replace
*/