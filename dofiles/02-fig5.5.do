/* This file provides the code for forcasting cumulative public funding of sports venues.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venue_forecast.dta
venuesdb_base.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 5.5
Tables (Stata viewer): 
Data (data\): forecast_cost.dta
Other:  Information on the expected number and public cost of venues in 2020s and 2030s.
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/


use "$data\venue_forecast.dta", clear /*Data used for Figure 5.2*/

keep year vensforecast_r

/*Extropolate cost of future venues (see 02-fig5.3_5.4_tab5.1.do for explanation) */
*Extrapolate replacement cost of 1990s-2000s venues not already replaced using 2020s median, which is $605 million
g pubforecast605 = vensforecast_r*605 if year>2019&year<2030

*Extrapolate replacement cost of 1990s-2000s venues not already replaced using 42.2% increase from 2020s median for 2030 venues $860 million
g pubforecast860 =  vensforecast_r*860  if year>2029

drop if year<2020

so year
save "$data\forecast_cost.dta", replace

use "$data\venuesdb_base.dta", clear

collapse (sum) publiccost publiccost2024 totalcost totalcost2024 , by(year)

so year
tsset year

/*Sum up public costs until that year. Convert to billions*/
g cumpc2024 = sum(publiccost2024) if year<=year
g cumpc2024bil = cumpc2024/1000

format cumpc2024 %9.0fc
format cumpc2024bil %9.0fc

so year

/*Merge observed costs with forecasted costs*/
merge year using "$data\forecast_cost.dta"
drop _m
so year

/*Create variable that combines public costs and forecasted costs by year*/
g combinedpub = publiccost2024 if year<2020
replace combinedpub = publiccost2024 + pubforecast605 if combinedpub ==. &year>2019 &year<2030
replace combinedpub = pubforecast605 if combinedpub ==. &year>2019 &year<2030

replace combinedpub = publiccost2024 + pubforecast860 if combinedpub ==. &year>2029&year<2040 
replace combinedpub = pubforecast860 if combinedpub ==. & year>2029


/*Generate cumulative costs with forecasted venues*/
g forecast_cumpc2024 = sum(combinedpub) if year<=year
g forecast_cumpc2024bil = forecast_cumpc2024/1000

/*This fills out the planned spending through 2039, rather than stopping*/
replace cumpc2024bil =cumpc2024bil[_n-1] if year>2032
	
format forecast_cumpc2024 %9.0fc
format forecast_cumpc2024bil %9.0fc

/*Generate strings for labels */
g cumpc2024bst= string(cumpc2024bil,"%9.0fc")
g cumpc2024bdol = "$"+cumpc2024bst
g cumpc2024bdolB = "$"+cumpc2024bst+" B"

g forecast_cumpc2024bst= string(forecast_cumpc2024bil,"%9.0fc")
g forecast_cumpc2024bdol = "$"+forecast_cumpc2024bst
g forecast_cumpc2024bdolB = "$"+forecast_cumpc2024bst+" B"

/*Figure 5.5*/
so year
mylabels 0(10)100, prefix($) myscale(@) local(dollab)
twoway area forecast_cumpc2024bil year if year>2019, fcolor(gs15) lc(black) lp(dot) lw(thin) ///
|| line cumpc2024bil year if year>1920 &year<2020, lc(gs10) lp(solid) lw(thin)  ///
|| area cumpc2024bil year if year>1920, bcolor(gs10) ///
|| line forecast_cumpc2024bil year if year>2018, lc(gs6) lp(shortdash)  ///
|| scatter forecast_cumpc2024bil year if year==2039 , ms(i) mlabel(forecast_cumpc2024bdolB) mlabpos(11) mlabs(medium)  mlabg(-.25) /// 
|| scatter cumpc2024bil year if year==2010, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) ///
|| scatter cumpc2024bil year if year==1980, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) /// 
|| scatter cumpc2024bil year if year==1960, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) /// 
|| scatter cumpc2024bil year if year==2032 , ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(*1) mc(black) ///
scheme(plotplain) ///
xlabel(1920(10)2040, labsize(medium)) ///
ylabel(`dollab', labsize(medium)) ///
ytitle("Construction Cost" "(in billions of 2024 dollars)", size(medlarge)  ) ///
xtitle(, size(medium)) ///
name(f_cumpc2024_comb, replace) ///
legend(subtitle("Cumulative Public Funding", size(medlarge)) order(3 "Venues Opened/Approved" 1 "Venues Forecast") ring(0) pos(11) cols(1) size(medlarge) symxsize(10) bmargin(t=5)) ///
text(54 2028 "Committed (so far) through 2032 →", place(w) size(medium)) ///
text(102 2028  "Projected through 2039 →", place(w) size(medium)) ///
text(41.5 2005.5  "Committed through 2010 →", place(w) size(medium)) ///
text(25 1990  "Committed through 1980" "                     ↓", place(w) size(medium)) ///
text(15 1970  "Committed through 1960" "                     ↓", place(w) size(medium)) 
/*
graph export "$figs\Fig5.5.pdf", as(pdf) replace
graph export "$tif\Fig5.5.tif", as(tif) width(3000)  replace
*/

/* oldFig5.5 before update
so year
mylabels 0(10)100, prefix($) myscale(@) local(dollab)
twoway area forecast_cumpc2024bil year if year>2019, fcolor(gs15) lc(black) lp(dot) lw(thin) ///
|| line cumpc2024bil year if year>1920 &year<2020, lc(gs10) lp(solid) lw(thin)  ///
|| area cumpc2024bil year if year>1920, bcolor(gs10) ///
|| line forecast_cumpc2024bil year if year>2018, lc(gs6) lp(shortdash)  ///
|| scatter forecast_cumpc2024bil year if year==2039 , ms(i) mlabel(forecast_cumpc2024bdolB) mlabpos(11) mlabs(medium)  mlabg(-.25) /// 
|| scatter cumpc2024bil year if year==2010, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) ///
|| scatter cumpc2024bil year if year==1980, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) /// 
|| scatter cumpc2024bil year if year==1960, ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(2) mc(black) /// 
|| scatter cumpc2024bil year if year==2032 , ms(|) mlabel(cumpc2024bdolB) mlabpos(12) mlabs(medium) mlabg(*1) mc(black) ///
scheme(plotplain) ///
xlabel(1920(10)2040, labsize(medium)) ///
ylabel(`dollab', labsize(medium)) ///
ytitle("Construction Cost" "(in billions of 2024 dollars)", size(medlarge)  ) ///
xtitle(, size(medium)) ///
name(f_cumpc2024_comb, replace) ///
legend(subtitle("Cumulative Public Funding", size(medlarge)) order(3 "Venues Opened/Approved" 1 "Venues Forecast") ring(0) pos(11) cols(1) size(medlarge) symxsize(10) bmargin(t=5)) ///
text(52.5 2028.3 "Committed (so far) through 2032 →", place(w) size(medium)) ///
text(101 2030  "Projected through 2039 →", place(w) size(medium)) ///
text(41.5 2005.5  "Committed through 2010 →", place(w) size(medium)) ///
text(25 1990  "Committed through 1980" "                     ↓", place(w) size(medium)) ///
text(15 1970  "Committed through 1960" "                     ↓", place(w) size(medium)) 
*/

/*Cited in text for projecting costs by decade*/
tabstat  vensforecast pubforecast605 if pubforecast605!=., stats(sum) format(%9.0fc)
/*
   Stats |  vensfo~r  pubf~605
---------+--------------------
     Sum |        37    22,385
------------------------------
2020s: 37 venues * $605m = $22.39 Billion
*/
tabstat vensforecast pubforecast860  if pubforecast860!=., stats(sum) format(%9.0fc)
/*
   Stats |  vensfo~r  pubf~860
---------+--------------------
     Sum |        31    26,660
------------------------------
2030s: 31 venues * $860m = $26.66 Billion

Total: 68 venues ==> 49 Billion
*/

save "$data\cumulative_cost.dta", replace
