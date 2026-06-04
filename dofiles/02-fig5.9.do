/* This file provides the code for tracking MLS stadium costs over time.

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
Figures(figs\): 5.9
Tables (Stata viewer): 
Data (outdat\): mls_median_collapse.dta
Other: 
CITED in text: Summary stats of MLS stadium costs
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

keep if year>1995&mls==1
keep if league=="MLS"|league=="MLS/CFL"

/*CITED in text: Median and cumulative MLS stadium costs*/
tabstat publiccost2024 totalcost2024 pubpct100, stats(median, sum) format
/*
   Stats |  pub~2024  tot~2024  pubp~100
---------+------------------------------
     p50 |        67       278        40
     Sum |     2,790     7,647     1,097
----------------------------------------
*/

/*Add decades for tracking median public share*/
*replace decade =1990 if year>1989&year<2000 // only Crew Stadium opened in 1990s (0%)
replace decade =2000 if year>1999&year<2010
replace decade =2010 if year>2009&year<2020
replace decade =2020 if year>2019&year<2030

insobs 4
replace decade=2000 in 28
replace decade=2010 in 29
replace decade=2020 in 30
replace decade=2030 in 31

so decade
by decade: egen medianpubpct = median(pubpct100)

collapse  (sum) stadium (median) pubpct100 totalcost2024 publiccost2024 medianpubpct decade, by(year)

replace decade=2030  if decade==2015
replace medianpubpct =26.5 if decade==2030

save "$outdat\mls_median_collapse.dta", replace


/*Adjust bar spacing on graph*/
g decade_pl10= decade+10
g decade_pl5= decade+5

g medpubpctst = string(medianpubpct,"%9.0f")
g medpubpctstpct = medpubpctst+"%"

/*Figure 5.9*/
so year
mylabels 0(200)800, prefix($) myscale(@)  local(dollab) format(%4.0fc) 
mylabels 0(25)100, suffix(%) myscale(@)  local(pct)
twoway bar totalcost2024 year, barwidth(1) yaxis(1) fcolor(none) lc(gs6) lw(medthick)  ///
|| bar publiccost2024 year, barwidth(1) yaxis(1) bcolor(gs6) ///
|| line medianpubpct decade , yaxis(2) ms(|) mc(black) connect(stair) msize(medsmall) lc(black) ///|| scatter medianpubpct decade_pl10 if decade_pl10<2030, yaxis(2) ms(|) mc(black) msize(medsmall)  ///
|| scatter medianpubpct decade_pl5 if year==2005|year==2015 , yaxis(2) ms(i) mlabel(medpubpctstpct) mlabpos(12) mlabgap(0) ///
ylabel(`dollab', axis(1) labsize(medium)) ///
ylabel(`pct', axis(2) labsize(medium)) ///
xlabel(1996 2000(5)2030, labsize(medium)) ///
ytitle("Median Construction Cost" "(millions of 2024 dollars)", axis(1) size(medlarge)) ///
ytitle("Median Public Share (%)", axis(2) size(medlarge)) ///
xtitle("Year", size(medlarge)) ///
legend(order(1 "Total Cost" 2 "Public Cost" 3 "Public Share (decade)" ) ring(0) pos(11) size(medium) symxsize(6) symysize(3)) ///
ttext( 28.5 2024.5 "27%", yaxis(2) box bcolor(white)  size(small)) ///
name(mls_costs, replace)
/*
graph export "$figs\Fig5.9.pdf", as(pdf) replace
graph export "$tif\Fig5.9.tif", as(tif) width(3000)  replace
*/

