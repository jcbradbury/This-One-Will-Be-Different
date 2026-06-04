/* This file provides the code for measuring the hosting lifespans of sports venues over time.

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
Figures(figs\): 5.1
Tables (Stata viewer): 
Data (outdat\): lifespan_collapse.dta
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

/*Lifespan of current venues in 2025*/
g lifespan2025 = lastyear-year+1
replace lifespan2025 = lastyear-year+1
replace lifespan2025 = 2026-year if lifespan2025==.
replace lifespan2025 = 2026-year if lastyear>2025 &lastyear!=. /*Keeps age for future closures in 2025 terms*/
replace lifespan2025 = . if lifespan2025<1

/*Lifespan of venues in 2029 that are not scheduled to close*/
g lifespan2029 = lastyear-year+1
replace lifespan2029 = lastyear-year+1
replace lifespan2029 = 2030-year if lifespan2029==.
replace lifespan2029 = . if lifespan2029<1

g renovationspan_2025 = 2025-lastrenovation+1
g renovationspan_2029 = 2029-lastrenovation+1
replace renovationspan_2029 = 2029-lastrenovation+1
replace renovationspan_2029 = 2029-future_renovation_complete+1 if future_renovation_complete!=.
*/

so decade
by decade: egen medlifesp = median(lifespan2029)
by decade: egen low25lifesp = pctile(lifespan2029), p(25)
by decade: egen hi75lifesp = pctile(lifespan2029), p(75)
by decade: egen low5lifesp = pctile(lifespan2029), p(5)
by decade: egen hi95lifesp = pctile(lifespan2029), p(95)
by decade: egen minlifesp = min(lifespan2029)
by decade: egen maxlifesp = max(lifespan2029)

sum lifespan2029 if decade<2000, detail

collapse  medlifesp low25lifesp hi75lifesp low5lifesp hi95lifesp minlifesp maxlifesp, by(decade)

g x35 = 35

save "$outdat\lifespan_collapse.dta", replace


/*Figure 5.1 */
twoway rcap minlifesp maxlifesp decade if decade<2000, lc(black) lw(thin) ///
|| rbar low25lifesp hi75lifesp decade if decade<2000, fcolor(gs6) lcolor(gs6) barw(3) ///
|| rcap medlifesp medlifesp decade if decade<2000, lc(white) msize(4) ///
|| connect medlifesp decade if decade<2000, lc(black) lp(vshortdash) ms(o) mc(black) lw(thin) /// || line x35 decade if decade<2000, lc(black) lp(vshortdash) ///
|| line x35 decade if decade==1950, lc(gs7) lp(dash) /// || scatter lifespan2029 decade if decade<2000, ms(oh) mc(black) ///
ylabel(0(10)120, gmin gmax angle(horizonta) labsize(medium)) ///
xlabel(1900 "1900s" 1910 "1910s" 1920 "1920s" 1930 "1930s" 1940 "1940s" 1950 "1950s" 1960 "1960s" 1970 "1970s" 1980 "1980s" 1990 "1990s", labsize(medium) ) /// 
yline(35, lp(dash) )  ///
legend(order(4 "Decade Median" 2 "Decade Middle 50%"  1 "Decade Range (Min to Max)" 5 "Sample Median = 35" ) ring(0) pos(1) cols(1) symxsize(8) size(medium)) ///
xtitle(Decade Opened, size(medium)) ///
ytitle("Years Hosting Major-League Team", size(medlarge)) ///
text(84 1952 "(Hosting status through 2029)", placement(e)) ///
name(ls_minmax, replace) 
/*
graph export "$figs\Fig5.1.pdf", as(pdf) replace
graph export "$tif\Fig5.1.tif", as(tif) width(3000)  replace
*/
