/* This file provides the code for mapping Braves franchise historical attendance.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
attend_lg.dta
Original from Lahman Baseball Database: https://sabr.org/lahman-database/ (teams.csv file)
More recent data updated from Baseball-Reference: https://www.baseball-reference.com/teams/ATL/attend.shtml

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.1
Tables (Stata viewer): 
Data (data\): 
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

use "$data\attend_lg.dta", clear

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
name(atl_attend2025, replace) scheme(plotplain)

/*
graph export "$figs\Fig6.1.pdf", as(pdf) replace
graph export "$tif\Fig6.1.tif", as(tif) width(3000)  replace
*/