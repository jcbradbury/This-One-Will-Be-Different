/* This file provides the code for extrapolating an expectation of future venue construction.

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
Figures(figs\): 5.2
Tables (Stata viewer): 
Data (data\): venue_forecast.dta
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

use "$data\venuesdb_base.dta", clear

/*Step 1: Forecast Replacements
Forecast future stadiums and arenas for venues that opened during 1990s-2000s. All stadiums +30 years MINUS already replaced and planned replacements (requires lastyear==.)
Use tabbed data to construct forecasts
*/

g forecastyear_arena_replaced = year +30 if year>1989&year<2010 &lastyear==. &arena
g forecastyear_stadium_replaced = year +30 if year>1989&year<2010 &lastyear==. &stadium

/*INPUT THE OUTPUT BELOW in Step 2b*/
tab forecastyear_arena_replaced
/*
forecastyea |
r_arena_rep |
      laced |      Freq.     Percent        Cum.
------------+-----------------------------------
       2020 |          1        2.94        2.94
       2021 |          1        2.94        5.88
       2022 |          1        2.94        8.82
       2023 |          2        5.88       14.71
       2024 |          3        8.82       23.53
       2025 |          3        8.82       32.35
       2026 |          5       14.71       47.06
       2027 |          1        2.94       50.00
       2028 |          1        2.94       52.94
       2029 |          8       23.53       76.47
       2030 |          2        5.88       82.35
       2031 |          1        2.94       85.29
       2033 |          1        2.94       88.24
       2034 |          2        5.88       94.12
       2035 |          1        2.94       97.06
       2037 |          1        2.94      100.00
------------+-----------------------------------
      Total |         34      100.00

*/
tab forecastyear_stadium_replaced
/*
forecastyea |
r_stadium_r |
    eplaced |      Freq.     Percent        Cum.
------------+-----------------------------------
       2020 |          1        2.94        2.94
       2021 |          1        2.94        5.88
       2022 |          1        2.94        8.82
       2024 |          1        2.94       11.76
       2025 |          2        5.88       17.65
       2026 |          1        2.94       20.59
       2028 |          3        8.82       29.41
       2029 |          1        2.94       32.35
       2030 |          4       11.76       44.12
       2031 |          4       11.76       55.88
       2032 |          4       11.76       67.65
       2033 |          2        5.88       73.53
       2034 |          2        5.88       79.41
       2036 |          2        5.88       85.29
       2038 |          2        5.88       91.18
       2039 |          3        8.82      100.00
------------+-----------------------------------
      Total |         34      100.00
*/

/*Step 2a: Aggregate venue openings by type and year */
so year
by year: egen scount= sum(stadium)
by year: egen acount= sum(arena)
g vens= acount +scount

collapse scount acount vens, by(year)

g future=0
replace future=1 if year>2024

tsset year
set obs `=_N+1'
replace year = 2039 in 93
tsfill

/*Step 2b : Input the forecasted replacement counts from Step 1 above.*/
g aforecast_r=.
replace aforecast_r=1 if year==2020
replace aforecast_r=1 if year==2021
replace aforecast_r=1 if year==2022
replace aforecast_r=2 if year==2023
replace aforecast_r=3 if year==2024
replace aforecast_r=3 if year==2025
replace aforecast_r=5 if year==2026
replace aforecast_r=1 if year==2027
replace aforecast_r=1 if year==2028
replace aforecast_r=8 if year==2029
replace aforecast_r=2 if year==2030
replace aforecast_r=1 if year==2031
*replace aforecast_r=1 if year==2032 // Spurs replacement
replace aforecast_r=1 if year==2033
replace aforecast_r=2 if year==2034
replace aforecast_r=1 if year==2035
replace aforecast_r=1 if year==2037

g sforecast_r=.
replace sforecast_r=1 if year==2020
replace sforecast_r=1 if year==2021
replace sforecast_r=1 if year==2022
replace sforecast_r=1 if year==2024
replace sforecast_r=2 if year==2025
replace sforecast_r=1 if year==2026
replace sforecast_r=3 if year==2028
replace sforecast_r=1 if year==2029
replace sforecast_r=4 if year==2030
replace sforecast_r=4 if year==2031 /*Leave in projected replacement for Denver Brocos bc tentative */
replace sforecast_r=4 if year==2032
replace sforecast_r=2 if year==2033
replace sforecast_r=2 if year==2034
replace sforecast_r=2 if year==2036
replace sforecast_r=2 if year==2038
replace sforecast_r=3 if year==2039


replace aforecast_r=0 if aforecast_r==. &year>2019
replace sforecast_r=0 if sforecast_r==. &year>2019


g vensforecast_r= aforecast_r+sforecast_r

g decade=.
replace decade = 1900 if year>1899& year<1910
replace decade = 1910 if year>1909& year<1920
replace decade = 1920 if year>1919& year<1930
replace decade = 1930 if year>1929& year<1940
replace decade = 1940 if year>1939& year<1950
replace decade = 1950 if year>1949& year<1960
replace decade = 1960 if year>1959& year<1970
replace decade = 1970 if year>1969& year<1980
replace decade = 1980 if year>1979& year<1990
replace decade = 1990 if year>1989& year<2000
replace decade = 2000 if year>1999& year<2010
replace decade = 2010 if year>2009& year<2020
replace decade = 2020 if year>2019& year<2030
replace decade = 2030 if year>2029& year<2040

/*Generate trends*/
tssmooth ma ma11vens = vens, window(5 1 5)
tssmooth ma ma11vensforecast_r = vensforecast_r, window(5 1 5)


*Connected trends
g ma11vensforecast_r_connect = ma11vensforecast_r
replace ma11vensforecast_r_connect= . if year<2020
replace ma11vensforecast_r_connect= ma11vens if year==2019


/*Figure 5.2*/
twoway bar vens year if year>1959,  bc(gs5)  ///
|| rbar vens scount year if year>1959 , bc(gs10) /// 
|| bar vensforecast_r year if vensforecast_r!=. ,  lc(gs2) lp(shortdash) lw(medium) fcolor(white%0) ///
||line ma11vensforecast_r_connect year if year>2018, lp(solid)  lc(gs10) lw(medthick) ///
||line ma11vens year if year>1959& year<2020, lp(solid) lw(medthick) ///
ytitle("Sports Venues Opened", size(medlarge)) ///
xtitle(,size(medlarge)) ///
xlabel(1960(10)2040,labsize(medium)) ///
ylabel(0(2)12, angle(horizontal) labsize(medium))  ///
name(forecast_r60s_c, replace) ///
legend(order(2 "Arenas" 1 "Stadiums" 3 "Projected Replacements" "(1990s and 2000s venues)" 5 "Observed Trend (1960s-2010s)" 4 "Projected Trend (2020s-2030s)" ) ///
ring(0) pos(11) cols(1) size(medsmall) symxsize(7) ) ///
scheme(plotplain)

/*
graph export "$figs\Fig5.2.pdf", as(pdf) replace
graph export "$tif\Fig5.2.tif", as(tif) width(3000)  replace
*/

save "$data\venue_forecast.dta", replace
