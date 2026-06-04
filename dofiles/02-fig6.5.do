
/* This file provides the code for tracking the Atlanta Braves annual payroll rank.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
payroll2025.dta

Annual payroll rank data culled from annual Baseball-Reference  Miscellaneous Team Info pages. For example, the 2025 can be found here: https://www.baseball-reference.com/leagues/majors/2025-misc.shtml.

Note about MLB payroll data: 
There are many other sources for MLB payroll data, which do not all agree. I use the Baseball-Reference collection because the data source is credible, and its payroll calculations are consistently available for the longest period. Other databases may calculate payroll burdens differently, but in general the ranks do not differ considerably. I would describe these data as reasonably accurate, but perhaps not precise. 

The Baseball-Reference ranking is more favorable to the Atlanta Braves than others.
Source: 2025 Payroll Rank (Link)
Baseball-Reference: 6 (https://www.baseball-reference.com/leagues/majors/2025-misc.shtml)
USA Today:	8 (https://www.usatoday.com/story/sports/mlb/2025/10/13/mlb-teams-payroll-2025-highest-lowest/86667489007/)
Fangraphs: 10 (https://blogs.fangraphs.com/the-2025-payrolls-and-beyond/)

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.5
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

use "$data\payroll2025.dta", clear



/*Figure 6.5*/
twoway bar mlbrank year if year>2016 ,   connect(stair) ysc(reverse) barw(.75) mlab(mlbrank) mlabpos(6) mlabsize(large) ///
|| bar mlbrank year if year>1996&year<2017,   connect(stair) ysc(reverse) barw(.75) mlab(mlbrank) mlabpos(6) mlabsize(large) /// if year>1999 &year<2024
|| bar mlbrank year if year<1997 ,   connect(stair) ysc(reverse) barw(.75) mlab(mlbrank) mlabpos(6) mlabsize(large) /// if year>1999 &year<2024
xlabel(1990(5)2020 2025, labsize(vlarge)) legend(off) ///
ylabel(1 5 10 15 20 25 30, labsize(vlarge)) ///
ytitle(MLB Team Payroll Rank, size(vlarge))  ///
xtitle(Season, size(vlarge))  ///
text(25 2020 "Truist Park", placement(s) box bc(white) fc(white) size(vlarge)) ///
text(25 2006.5  "Turner Field", placement(s) box bc(white) fc(white) size(vlarge)) ///
text(25 1992.5  "Atlanta–Fulton" "County Stadium", placement(s) box bc(white) fc(white) size(vlarge)) ///
xsize(2) ysize(1) ///
xline(1996.5, lp(dash) lw(medthick) lc(black)) xline(2016.5, lp(dash) lw(medthick) lc(black)) ///
plotregion(margin(t=1 b=1 l=5 r=5)) ///
name(payroll25, replace)
/*
graph export "$figs\Fig6.5.pdf", as(pdf) replace
graph export "$tif\Fig6.5.tif", as(tif) width(3000)  replace
*/