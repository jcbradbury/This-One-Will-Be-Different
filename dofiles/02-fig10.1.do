/* This file provides the code for comparing MLB ballpark construction costs.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): venuesdb_base.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 10.1
Tables (Stata viewer): 
Data (outdat\): compare_mlb.dta
Other:
CITED in text: How Truist Park public share compares to same-era MLB stadiums 
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

/*Comparison era & stadiums*/
keep if year >1999 &year<2021 &mlb

/*Convert costs to 2017 dollars*/
g publiccost2017=.
replace publiccost2017=publiccost*1.42 if year==2000
replace publiccost2017=publiccost*1.38 if year==2001
replace publiccost2017=publiccost*1.36 if year==2002
replace publiccost2017=publiccost*1.33 if year==2003
replace publiccost2017=publiccost*1.3 if year==2004
replace publiccost2017=publiccost*1.26 if year==2005
replace publiccost2017=publiccost*1.22 if year==2006
replace publiccost2017=publiccost*1.18 if year==2007
replace publiccost2017=publiccost*1.14 if year==2008
replace publiccost2017=publiccost*1.14 if year==2009
replace publiccost2017=publiccost*1.12 if year==2010
replace publiccost2017=publiccost*1.09 if year==2011
replace publiccost2017=publiccost*1.07 if year==2012
replace publiccost2017=publiccost*1.05 if year==2013
replace publiccost2017=publiccost*1.04 if year==2014
replace publiccost2017=publiccost*1.03 if year==2015
replace publiccost2017=publiccost*1.02 if year==2016
replace publiccost2017=publiccost*1 if year==2017
replace publiccost2017=publiccost*0.98 if year==2018
replace publiccost2017=publiccost*0.96 if year==2019
replace publiccost2017=publiccost*0.95 if year==2020

g totalcost2017=.
replace totalcost2017=totalcost*1.42 if year==2000
replace totalcost2017=totalcost*1.38 if year==2001
replace totalcost2017=totalcost*1.36 if year==2002
replace totalcost2017=totalcost*1.33 if year==2003
replace totalcost2017=totalcost*1.3 if year==2004
replace totalcost2017=totalcost*1.26 if year==2005
replace totalcost2017=totalcost*1.22 if year==2006
replace totalcost2017=totalcost*1.18 if year==2007
replace totalcost2017=totalcost*1.14 if year==2008
replace totalcost2017=totalcost*1.14 if year==2009
replace totalcost2017=totalcost*1.12 if year==2010
replace totalcost2017=totalcost*1.09 if year==2011
replace totalcost2017=totalcost*1.07 if year==2012
replace totalcost2017=totalcost*1.05 if year==2013
replace totalcost2017=totalcost*1.04 if year==2014
replace totalcost2017=totalcost*1.03 if year==2015
replace totalcost2017=totalcost*1.02 if year==2016
replace totalcost2017=totalcost*1 if year==2017
replace totalcost2017=totalcost*0.98 if year==2018
replace totalcost2017=totalcost*0.96 if year==2019
replace totalcost2017=totalcost*0.95 if year==2020

format publiccost2017 totalcost2017 %9.0fc

save "$outdat\compare_mlb.dta", replace 

/* Data output into the data\ folder
save "$data\compare_mlb.dta", replace
export delimited "$data\compare_mlb.csv", replace
*/

tabstat publiccost2017 totalcost2017 pubpct100, stats(median) format(%9.0fc)
/*
   Stats |  pub~2017  tot~2017  pubp~100
---------+------------------------------
     p50 |       316       568        68
----------------------------------------
*/

g droppublic=316
g droptotal=568

g yearstring = string(year)
g nameyear = venuename+" ("+yearstring+")"
g pubpct100st = string(pubpct100,"%9.0fc")
g pubpct100string = pubpct100st+"%"

so year venuename
g number = _n
labmask number, value(nameyear)

/*Fig 10.1*/
twoway bar publiccost2017 number, ylabel(1(1)16,valuelabel labsize(medium)) horizontal ysc(reverse) bcolor(gs10%50)  ///
|| bar totalcost2017 number if venuename_tex!="American Family Field" & venuename_tex!="Target Field", ylabel(1(1)16,valuelabel) horizontal fcolor(none) ysc(reverse) bcolor(gs0) mlabel(pubpct100string) mlabpos(3) mlabcolor(black)  ///
|| dropline number droppublic , vertical m(i) lc(gs0) lp(shortdash) ///
|| dropline number droptotal , vertical m(i) lc(gs0)  lp(solid) ///
|| bar totalcost2017 number if venuename_tex=="American Family Field" , ylabel(1(1)16,valuelabel) horizontal fcolor(none) ysc(reverse) bcolor(gs0) mlabel(pubpct100string) mlabpos(3) mlabcolor(black) mlabgap(1.5) ///
|| bar totalcost2017 number if venuename_tex=="Target Field", ylabel(1(1)16,valuelabel) horizontal fcolor(none) ysc(reverse) bcolor(gs0) mlabel(pubpct100string) mlabpos(3) mlabcolor(black) mlabgap(4.5) ///
ytitle("") /// 
xlabel(0 "$0" 250 "$250" 500 "$500" 750 "$750" 1000 "$1,000" 1250 "$1,250" 1500 "$1,500", labsize(medium)) ///
xline(316, lc(gs0) lw(medthick) lp(shortdash)) xline(568, lc(gs0) lw(medium) lp(solid) )  ///
xtitle("Construction Cost (millions of 2017 dollars)", size(medium)) ///
legend(order(2 "Total Cost" 1 "Public Cost" 4 "Median Total Cost" 3 "Median Public Cost" ) ring(0) pos(2) size(medium) symxsize(7) note("(labels report public share)", justification(center))) scheme(plotplain) ///
plotregion(margin(r=5))  ///
name(mlbcomp, replace)
/*
graph export "$figs\Fig10.1.pdf", as(pdf) replace
graph export "$tif\Fig10.1.tif", as(tif) width(3000)  replace
*/

/* CITED in text: How Truist Park public share compares to same-era MLB stadiums */
gsort pubpct100
list nameyear pubpct100
tab pubpct100
sum pubpct100, detail