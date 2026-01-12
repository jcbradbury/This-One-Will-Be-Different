/* This file provides the code for tracking metro-Atlanta CID property values.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
CIDgrossdigest.dta

CID Tax Digest data in this file manually input from Georgia Department of Revenue, County Services Portal (no stable URL)
Website: https://apps.dor.ga.gov/
1. Click on  Digest Summaries under "Property Taxes"
2. From drop-down menu, select Year:[year] and County: [County]
3. Once County slected, select District: [CID] from drop-down menu

Intermediate Output (working directory):

Final Output:
Figures(figs\): 12.1, 12.3
Tables (Stata viewer): 
Data (outdat\): CID_vpa.dta
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

use "$data\CIDgrossdigest.dta", clear

/* Input CID acreage 
Distance measured using Google maps distance tool. Rounded to closest km
Acres convered from miles by multiplying by 640
*/

g cidacresgoog=.

replace cidacresgoog=4352 if cidid==1
replace cidacresgoog=4339.2 if cidid==2
replace cidacresgoog=1017.6 if cidid==7
replace cidacresgoog=1120 if cidid==5
replace cidacresgoog=934.4 if cidid==3
replace cidacresgoog=678.4 if cidid==4
replace cidacresgoog=3635.2 if cidid==9
replace cidacresgoog=1580.8 if cidid==6
replace cidacresgoog=6528 if cidid==8
replace cidacresgoog=2240 if cidid==11
replace cidacresgoog=11456 if cidid==10
replace cidacresgoog=6150.4 if cidid==12

/*Normalize CID property values per acre*/
g vpa = grossdigestvalue/cidacresgoog
label variable vpa "Value per Acre"

so cidid year

/*Register what the CID's value per acre was in 2013*/
g vpa2013 = vpa if year==2013
by cidid: egen meanvpa2013 = mean(vpa2013)
replace vpa2013 = meanvpa2013 if vpa2013==.

g vpa2013pct = ((vpa -vpa2013)/vpa2013)*100
label variable vpa2013pct "% Difference from 2013"

format vpa2013pct %9.0fc

g fairmarket = grossdigestvalue/.4
format fairmarket %15.0fc
label variable fairmarket "Fair Market Value"

g fm_bil = fairmarket/1000000000
format fm_bil  %9.2fc
label variable fm_bil "Fair Market Value (in billions)"

/*Identify Cumberland values in 2012 and 2017 for comparison*/
g cumberland12_17 =0
replace cumberland12_17=1 if cidid==1 &year==2012
replace cumberland12_17=1 if cidid==1 &year==2017

save "$outdat\CID_vpa.dta", replace

/* Data output into the data\ folder
save "$data\CID_vpa.dta", replace
export delimited "$data\CID_vpa.csv", replace
*/

*Cumberland CID only, Fair market value
/*Fig 12.1*/
mylabels 2.5(.25)4, prefix($) myscale(@)  local(dol) format(%4.2fc)
#delimit;
twoway 
(connected fm_bil year if cumberland12_17==1 , lp(longdash))
(line fm_bil year if cidid==1,legend(label( 1 "Cumberland")) lp(solid) lc(gs0) lw(medthick)),
xline(2013, lpattern(shortdash) lcolor(black)) legend( cols(3)) yline(0, lp(shortdash)) 
ylabel(`dol', angle(horizontal) labsize(medium))
xlabel(2010(1)2023, labsize(medium)) 
ytitle("Fair Market Value" "(in billions of dollars)" , size(medlarge)) xtitle(,size(medlarge))
legend(order(2 "Cumberland CID" 1 "Change (2012-2017)") ring(0) pos(12) cols(1) size(medlarge) symxsize(15))
text( 2.6 2013 "← Truist Park announced", placement(e) size(medium))
name(fairmarket, replace)
;
#delimit cr
/*
graph export "$figs\Fig12.1.pdf", as(pdf) replace
graph export "$tif\Fig12.1.tif", as(tif) width(3000)  replace
*/

*All CIDs Value per acre % of 2013 (nominal dollars for simplicity)
/*Fig 12.3 */ 
mylabels -50(25)150, suffix(%) myscale(@)  local(pct) format(%2.0fc)
#delimit;
twoway
(line vpa2013pct year if cidid==2 ,legend(label( 2 "Other Metro CIDs"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==7 ,legend(label( 3 "Perimeter-DeKalb"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==5 ,legend(label( 4 "Buckhead"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==3 ,legend(label( 5 "Downtown"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==4 ,legend(label( 6 "Midtown"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==9 ,legend(label( 7 "North Fulton"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==6 ,legend(label( 8 "Perimeter-Fulton"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==8 ,legend(label( 9 "South Fulton"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==11 ,legend(label( 10 "Evermore"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==10 ,legend(label( 11 "Gwinnett Village"))lp(solid) lw(vthin) lc(gs8)) ///(line vpa2013pct year if cidid==12 ,legend(label( 12 "Lilburn"))lp(solid) lw(vthin) lc(gs8))
(line vpa2013pct year if cidid==1 ,legend(label( 1 "Cumberland")) lp(solid) lc(gs0) lw(medthick)),
xline(2013, lpattern(shortdash) lcolor(black)) legend( cols(3)) yline(0, lp(shortdash)) 
xlabel(2010(1)2023, labsize(medium)) 
ylabel(`pct', angle(horizontal) labsize(medium))
legend(order(11 "Cumberland CID" 2) ring(0) pos(12) cols(1) size(medlarge) symxsize(15))
ytitle("Change in Property Value per Acre" "(% difference from 2013)", size(medlarge))  xtitle(,size(medlarge))
plotregion(margin())
text( -40 2013 "← Truist Park announced", placement(e) size(medium) )
name(cidsgr,replace)
;
#delimit cr
/*
graph export "$figs\Fig12.3.pdf", as(pdf) replace
graph export "$tif\Fig12.3.tif", as(tif) width(3000)  replace
*/



