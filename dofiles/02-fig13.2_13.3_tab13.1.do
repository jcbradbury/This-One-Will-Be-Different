/* This file provides the code for estimating the effect of Truist Park opening on sales tax collections.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Much of the analysis discussed in Chapter 13 draws from the following study:
Bradbury, John Charles (2024) "Sports stadiums and local economic activity: Evidence from sales tax collections," Journal of Urban Affairs, 46(1):139-159 (https://doi.org/10.1080/07352166.2022.2044837).

The paper provides a detailed explanation of the synthetic control method (SCM) application and robustness checks.

Data Input (data\): 
county_synthdata_2010_2019.dta

See DataNotes_Ch13.md in this repository for more information on how tax distributions were aggregated.

County Tax Revnue data manually collected from Georgia Department of Revenue, Georgia Tax Center
Website: https://gtc.dor.ga.gov/_/
1.Click on "Search Sales Tax Distribution" under the Sales Tax menue
Make the following selections for each Atlanta MSA county:
Select County: [Cobb]
Leave jurisdiction blank.
Select Distribution start date: 01-Jan-1999
Select Distribution end date: 31-Dec-2020

Atlanta MSA County list: Barrow, Bartow, Butts, Carroll, Cherokee, Clayton, Cobb, Coweta, Dawson, Dekalb, Douglas, Fayette, Forsyth, Fulton, Gwinnett, Haralson, Heard, Henry, Jasper, Lamar, Meriwether, Morgan, Newton, Paulding, Pickens, Pike, Rockdale, Spalding, Walton

County sales tax rates from Department of Revenue, Historical Sales Tax Chart (https://dor.georgia.gov/historical-sales-tax-chart)
Data were gathered from the October 2020 release (https://dor.georgia.gov/document/document/october-2020-historical-sales-tax-chart/download)

County econ demographics from BEA. https://apps.bea.gov/regional/downloadzip.cfm CAINC1: Annual Personal Income by County
Website: https://www.bea.gov/data/income-saving/personal-income-county-metro-and-other-areas
2019 data release: 11/17/2020

Intermediate Output (working directory): cobb_stsynth_temp.dta

Final Output:
Figures(figs\): 13.2, 13.3
Tables (Stata viewer): 13.1
Data (outdat\): county_synthdata_2010_2019_noSTch_q.dta ; cobb_stsynth.dta
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

use "$data\county_synthdata_2010_2019.dta", replace

/**Remove unsuitable control counties**/
drop if countyid==14 // Fulton, reverse treatment of losing ballpark

/*Drop counties with post-2016 sales tax rate increaes*/ 
drop if countyid==10 // DeKalb
drop if countyid==12 // Fayette
drop if countyid==16 // Haralson
drop if countyid==22 // Morgan 

/*Convert monthly observations to quarterly*/
g qdate = qofd(date)

collapse salestax_pc  logypc salestaxrate popdens sq_miles distanceturner sumcollections population year , by(county qdate)

g  sumcollections3 =  sumcollections*3
g sumcollections3_pc = sumcollections3/popul

encode county, g(countyid)
tsset countyid qdate

g quarter = quarter(dofq(qdate))

format  qdate %tq

save "$outdat\county_synthdata_2010_2019_noSTch_q.dta", replace

/* Data output into the data\ folder
save "$data\county_synthdata_2010_2019_noSTch_q.dta", replace
export delimited "$data\county_synthdata_2010_2019_noSTch_q.csv", replace
*/

so qdate
by qdate: egen meannonCobbsumcollections3_pc = mean( sumcollections3_pc) if county!="Cobb"
by qdate: egen mednonCobbsumcollections3_pc = median( sumcollections3_pc) if county!="Cobb"

/*Fig 13.2*/
mylabels 80(5)150, prefix($) myscale(@)  local(dollab) format(%2.0fc)
twoway (line  meannonCobbsumcollections3_pc qdate if county !="Cobb",  lp(solid) lc(gray) xtick(200(4)239, tlength(*1)  ) ) ///
(line sumcollections3_pc qdate if county =="Cobb", lw(medthick) lp(solid) lc(black) xtick(200(4)239 ))  ///Cobb
(lfit  meannonCobbsumcollections3_pc qdate if county !="Cobb"& qdate>228, lp(shortdash) lc(gray) xtick(200(4)239 ))  ///Other 
(lfit sumcollections3_pc qdate if county =="Cobb" & qdate>228, lp(shortdash) lc(black) xtick(200(4)239, tlength(*1) )),  ///Cobb
xline(229, lp(longdash) lc(black)lw(medthick))  ///
tline(200(4)240, lp(dot)) ///
xlabel(202(4)238 240 " ", noticks format(%tqCY) nogrid labsize(medium)) /// 
xtitle("Year (quarterly)", size(medium)) ///
 ytitle("Sales Tax Revenue (per capita)", size(medlarge))  ///
ylabel(`dollab', angle(horizontal ) labsize(medium))  ///
ttext( 120 229 "   April 2017  →" "Truist Park opens ", place(w) yaxis(1) xaxis(1))  ///
legend(order( 1 "Atlanta MSA Counties (non-Cobb mean)"  2 "Cobb County" - "{bf: Post-Stadium Linear Trends}"  3 "Atlanta non-Cobb" 4 "Cobb" ) ring(0) cols(1) pos(10) symxsize(9) size(medium)) ///
plotregion(margin(t=3 b=3 l=3 r=3) ) ///
name(st_means, replace)

gr_edit	.legend.plotregion1.label[3].xoffset = -12.25
gr_edit	.legend.plotregion1.label[3].yoffset = -.75
/*
graph export "$figs\Fig13.2.pdf", as(pdf) replace
graph export "$tif\Fig13.2.tif", as(tif) width(3000)  replace
*/

/*Run SCM analysis*/
synth sumcollections3_pc  logypc salestaxrate popdens sq_miles distanceturner ///
sumcollections3_pc(200(4)227) ///  1Q average all years
sumcollections3_pc(200(1)203) ///  first calendar year
sumcollections3_pc(212(1)215) /// 2013 middle year /// 4 Qs of pre-treatment sample 
sumcollections3_pc(224(1)227),  /// last calendar year before treatment 
trunit(7) trperiod(229) resultsperiod(200(1)239) ///
counit(1 2 3 4 5 6  8 9  11 13 15  17 18 19 20 21  23 24 25 26 27 28 29) /// 10 12 16 22
figure allopt nested ///
keep(cobb_stsynth_temp.dta, replace) 

use cobb_stsynth_temp.dta, clear // Saved results to make a cleaner graph

keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time quarteryr
rename _Y_treated  treat
rename _Y_synthetic counterfact
gen predgap=treat-counterfact // Treatment Effect
sort quarteryr

format  quarteryr %tq
label variable counterfact "Synthetic Cobb"

g quarter = quarter(dofq(quarteryr))
g year = year(dofq(quarteryr))
g baseball = 0
replace baseball =1 if quarter>1 & quarter<4

g upper = 110
label variable upper "Baseball Season"

save "$outdat\cobb_stsynth.dta", replace

/*
Note: The `synth' opitmization routine with the recommended allopt and nested options for obtaining variable weights can generate minor differences in estimated treatment effects accross computing environments. Thus your machine may produce cobb_stsynth.dta in `outdat\' that differs slightly from mine. 
*/

use  "$data\cobb_stsynth.dta", replace

/*Fig 13.3*/
mylabels 80(5)110, prefix($) myscale(@)  local(dollab) format(%2.0fc)
twoway (bar upper quarteryr if inrange(quarteryr,229.1,230 &upper>80), barwidth(.1) bcolor(gs14) ) ///
(line treat quarteryr, lp(solid) lc(black) lw(vthin) xtick(200(4)239, tlength(*1) ) ) /// 
(line counterfact quarteryr, lp(shortdash) lc(black) lw(thin) xtick(200(4)239,  )), ///
tline(229.5 233.5 237.5, lcolor(gs14) lw(3.5) lp(solid)) ///
tline(229, lpattern(longdash) lcolor(black) lw(medthick)) ///
tline(200(4)240, lp(dot)) ///
ttext( 105 229 "   April 2017  →" "Truist Park opens ", place(w) yaxis(1) xaxis(1))  ///
xtitle("Year (quarterly)", size(medium)) ///
xlabel(202(4)238 240 " ", noticks format(%tqCY) nogrid labsize(medium)) ///
ytitle("Sales Tax Revenue (per capita)", size(medlarge)) ///
ylabel(`dollab', angle(horizontal ) labsize(medium))  /// 
legend(order(2 3 1) cols(1) ring(0) pos(10) symxsize(15) size(medium)) ///
plotregion(margin(t=3 b=3 l=3 r=3) ) ///
name(st_synth, replace)		
/*
graph export "$figs\Fig13.3.pdf", as(pdf) replace
graph export "$tif\Fig13.3.tif", as(tif) width(3000)  replace
*/

/*Table 13.1*/
tabstat predgap if quarteryr>228, by(baseball) // Average treatment effect of Truist Park measured by differnce between observed and synthetic Cobb 

/*
Summary for variables: predgap
Group variable: baseball 

baseball |      Mean
---------+----------
       0 |  .4432074
       1 |  1.446454
---------+----------
   Total |  .9904331
--------------------

The results above reflect the estimated treatment effects that I use for estimating crowding out.

This is a quarterly estimate of sales tax revenue per capita
Multipled by 4 for annual: 4 * $0.99 = $3.96
Cobb 2019 population estimte: 760,141 (US Census: https://web.archive.org/web/20201031053126/https://www.census.gov/quickfacts/cobbcountygeorgia)
Estimated tax revenue added by Truist Park: $3.96 * 760,141 = $3,011,475 <==  Column 2, Row 2

		Battery			County+schools
Year	County/School	Total Sales Tax Revenue (*2)
		
2017	$1,600,000		$3,200,000 (Source: BOC Year in Review for 2017, p. 8)
2018	$2,482,550		$4,965,100 (Source: BOC Year in Review for 2018, p. 12)
2019	$2,743,463		$5,486,926 (Source: BOC Year in Review for 2019, p. 10)
Mean	$2,275,338		$4,550,675 <==  Column 2, Row 1

Total Spending = Tax Revenue/Local sales tax rate (2%)
Spending at The Battery: $4.55 mil /0.02 = $228 mil <== Column 3, Row 1
Total new Cobb spending: $3.00 mil /0.02 = $150 mil <== Column 3, Row 2

Crowding out
$4.55 mil - 3.00 mil = $1.55 mil <== Column 2, Row 3
$1.55 mil /0.02 = $78 mil <== Column 3, Row 3
$1.55 mil/ $4.55 mil = 34%	<== Column 3, Row 4
*/

