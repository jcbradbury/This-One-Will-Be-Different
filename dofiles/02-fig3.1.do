/*This file provides the code for tracking historical US major league sports venue construction. 

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_base.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 3.1
Tables (Stata viewer): 
Data (outdat\):
Other: 
CITED in text: Summary of public/private arenas opened since 2000
CITED in text: Public funding of venues that opened in 1990s and 2000s

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

/*CITED in text: Summary of public/private arenas opened since 2000*/
list venuename year pubpct if arena &year>1999 &pubpct!=.
list venuename year pubpct if arena &year>1999 &pubpct==0
sum publiccost2024 pubpct if arena &year>1999

/*CITED in text: Public funding of venues that opened in 1990s and 2000s*/
sum pubpct100 if year > 1989 & year <2010, detail

so year
by year: egen scount= sum(stadium)
by year: egen acount= sum(arena)
g vens= acount +scount

collapse scount acount vens, by(year)

tsset year
tsfill
tssmooth ma ma11vens = vens, window(5 1 5)

save "$outdat\venue_count.dta", replace


/*Figure 3.1*/
twoway bar vens year if year<2020,  bc(gs5)  ///
|| rbar vens scount year if year<2020, bc(gs10) /// ||
||line ma11vens year if year<2020, lp(solid) lc(black) lw(medium) ///
ytitle("Sports Venues Opened", size(medlarge)) ///
xtitle(,size(medlarge)) ///
xlabel(1910(10)2020,labsize(medium)) ///
ylabel(0(2)12, angle(horizontal) labsize(medium))  ///
legend(order(2 "Arenas" 1 "Stadiums" 3 "Trend") ring(0) pos(11) cols(1) size(medium) symxsize(7)) ///
xline(1960, lp(dash)) xline(1990, lp(dash)) xline(2020, lp(dash)) ///
text(6 1935 "Inaugural" "Era", box bcolor(white) size(medlarge) ) ///
text(8 1975 "Superstadium" "Era", box bcolor(white) size(medlarge)) ///
text(11.25 2007 "Stadium" "Mania", box bcolor(white) size(medlarge)) ///
name(counts_3eras, replace) scheme(plotplain)
/*
graph export "$figs\Fig3.1.pdf", as(pdf) replace
graph export "$tif\Fig3.1.tif", as(tif) width(3000)  replace
*/