/* This file provides the code for mapping Braves franchise historical attendance.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
1901-2024 data from Lahman Baseball Database: https://sabr.org/lahman-database/ (Teams.csv file)
The SABR Lahman Baseball Database 1871-2024, Release Date: Oct 30, 2025

2025 attendance data from Baseball-Reference: https://www.baseball-reference.com/teams/ATL/attend.shtml

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.1
Tables (Stata viewer): 
Data (outdat\): attend_atl.dta
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

/*Import the raw Teams.csv file*/
import delimited "$data\Teams.csv", clear

g x1915 = 1915
g x1953 = 1953
g x1966 = 1966
g x1997 = 1997
g x2017 = 2017

keep if franchid=="ATL"
drop if year<1901

insobs 1
replace yearid = 2025 if year==.

replace attendance = 2903167	if yearid==2025
replace ghome = 81 if yearid ==2025
replace franchid ="ATL" if year ==2025

g attg = attendance/ghome
format attg %9.0fc

save "$outdat\attend_atl.dta", replace

/* Data output into the data\ folder
save "$data\attend_atl.dta", replace
export delimited "$data\attend_atl.csv", replace
*/

/*Fig 6.1*/
twoway bar attg year if franchid=="ATL" ,  bc(gs10)  ///
|| dropline attg x1915 if franchid=="ATL" ,  lpattern(longdash) mcolor(none) lcolor(black) lw(vthin) ,  ///
|| dropline attg x1953 if franchid=="ATL" ,  lpattern(longdash) mcolor(none) lcolor(black) lw(vthin),  ///
|| dropline attg x1966 if franchid=="ATL" ,  lpattern(longdash) mcolor(none) lcolor(black) lw(vthin), ///
|| dropline attg x1997 if franchid=="ATL" ,  lpattern(longdash) mcolor(none) lcolor(black) lw(vthin),  ///
|| dropline attg x2017 if franchid=="ATL" ,  lpattern(longdash) mcolor(none) lcolor(black) lw(vthin)  ///
ytitle("Attendance (per game)", axis(1) size(medium))  ///
text(49000 1915  "Braves" "Field", placement(n) box bc(white) fc(white)) ///
text(49000 1953  "Milwaukee  " "Stadium  ", placement(n) box bc(white) fc(white)) ///
text(49000 1966  " Atlanta" " Stadium", placement(n) box bc(white) fc(white)) ///
text(49000 1997  "Turner" "Field", placement(n) box bc(white) fc(white)) ///
text(49000 2017  "Truist" "Park", placement(n) box bc(white) fc(white)) ///
ylabel(,angle(horizontal) axis(1)) ///
xtitle(Season) ///
xlabel(1900(10)2020 2025 "   2025") ///
legend(order(1 "Attendance" 2 "New Stadium")  bmargin(l=20 b=50) pos(9) ring(0) rows(2) size(small) symxsize(10) region(lcolor(black)) ) ///
plotregion(margin(t=6 b=1 )) ///
name(atl_attend2025a, replace) scheme(plotplain)
/*
graph export "$figs\Fig6.1.pdf", as(pdf) replace
graph export "$tif\Fig6.1.tif", as(tif) width(3000)  replace
*/