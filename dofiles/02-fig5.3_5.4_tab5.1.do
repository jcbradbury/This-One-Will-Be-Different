/* This file provides the code for generating median venue funding.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_base.dta

Intermediate Output (working directory):
ven_median_collapse.dta
ven_median_collapse_arena.dta
ven_median_collapse_stadium.dta

Final Output:
Figures(figs\): 5.3, 5.4 
Tables (Stata viewer): 5.1 
Data (data\):
Other: 
*/

/**************Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"

*************/

use "$data\venuesdb_base.dta", clear

collapse  (sum) stadium arena (median) pubpct100 totalcost2024 publiccost2024 , by(decade)

save ven_median_collapse, replace

use "$data\venuesdb_base.dta", clear
collapse  (sum) arena (median) pubpct100 totalcost2024 publiccost2024 if arena, by(decade)
rename pubpct100 pubpct100a 
rename  totalcost2024 totalcost2024a
rename publiccost2024 publiccost2024a

so decade
save ven_median_collapse_arena, replace

use  "$data\venuesdb_base.dta", clear
collapse  (sum) stadium (median) pubpct100 totalcost2024 publiccost2024 if stadium, by(decade)

rename pubpct100 pubpct100s 
rename  totalcost2024 totalcost2024s
rename publiccost2024 publiccost2024s

so decade
save ven_median_collapse_stadium, replace

use ven_median_collapse, clear
so decade

merge 1:1 decade using ven_median_collapse_arena
drop _m

so decade
merge 1:1 decade using ven_median_collapse_stadium
drop _m

drop if decade==. /*Removes the Athletics non-specific new stadium*/
tsset decade

tabstat publiccost2024, by(decade) stats(median)

/*
Summary for variables: publiccost2024
Group variable: decade 

  decade |       p50
---------+----------
    1900 |         0
    1910 |         0
    1920 |         0
    1930 |   36.4525
    1940 |     39.54
    1950 |    64.625
    1960 |    78.765
    1970 |     232.5
    1980 |    148.05
    1990 |    204.64
    2000 |    345.27
    2010 |    399.36
    2020 |       605
    2030 |       930
---------+----------
   Total |  113.4075
--------------------

Average decade growth rate (1980-2020s): ~42.2% 
650*1.42179 = 860

Note: 3 venues annouced so far for 2030s
*/

/*Maunually rounding to 860 is more elegant than multiplying a rounded 2020s. Does not alter projections in rounding.*/
*replace publiccost2024= publiccost2024[_n-1]*1.42179  if decade==2030 
replace publiccost2024= 860 if decade==2030


g venue = stadium +arena
g decade_pl1 = decade+1
g decade_m1 = decade-1
g decade_pl2 = decade+2
g decade_m2 = decade-2

***** Pubpct strings
g pubpct100st = string(pubpct100,"%9.0f")
g pubpct100stpct = pubpct100st+"%"
g pubpct100stpct_tex = pubpct100st+"\%"


g pubpct100sta = string(pubpct100a,"%9.0f")
g pubpct100stpcta = pubpct100sta+"%"
g pubpct100stpcta_tex = pubpct100sta+"\%"
replace pubpct100stpcta_tex = "\emph{NR}" if pubpct100a==.

g pubpct100sts = string(pubpct100s,"%9.0f")
g pubpct100stpcts = pubpct100sts+"%"
g pubpct100stpcts_tex = pubpct100sts+"\%"
replace pubpct100stpcts_tex = "\emph{NA}" if pubpct100s==.

**********Total cost strings
g tc2024st= string(totalcost2024,"%9.0fc")
g tc2024dol = "\\$" +tc2024st

g tc2024sta= string(totalcost2024a,"%9.0fc")
g tc2024dola = "\\$" +tc2024sta
replace  tc2024dola ="\emph{NR}" if totalcost2024a==.

g tc2024sts= string(totalcost2024s,"%9.0fc")
g tc2024dols = "\\$" +tc2024sts
replace  tc2024dols ="\emph{NA}" if totalcost2024s==.


********** Public cost strings
g pc2024st= string(publiccost2024,"%9.0fc")
g pc2024dol = "\\$" +pc2024st

g pc2024sta= string(publiccost2024a,"%9.0fc")
g pc2024dola = "\\$" +pc2024sta
replace  pc2024dola ="\emph{NR}" if publiccost2024a==.

g pc2024sts= string(publiccost2024s,"%9.0fc")
g pc2024dols = "\\$" +pc2024sts
replace  pc2024dols ="\emph{NA}" if publiccost2024s==.




*** Decades

g decades=""
replace decades ="1900s" if decade==1900
replace decades ="1910s" if decade==1910
replace decades ="1920s" if decade==1920
replace decades ="1930s" if decade==1930
replace decades ="1940s" if decade==1940
replace decades ="1950s" if decade==1950
replace decades ="1960s" if decade==1960
replace decades ="1970s" if decade==1970
replace decades ="1980s" if decade==1980
replace decades ="1990s" if decade==1990
replace decades ="2000s" if decade==2000
replace decades ="2010s" if decade==2010
replace decades ="2020s" if decade==2020
replace decades ="2030s" if decade==2030

labmask decade_m2, value(decades)
labmask decade_pl2, value(decades)
labmask decade, value(decades)

g era = ""
replace era ="Inaugural" if decade==1920
replace era ="Era" if decade==1930
replace era ="Super-" if decade==1960
replace era ="stadium" if decade==1970
replace era ="Era" if decade==1980
replace era ="Stadium" if decade==1990
replace era ="Mania" if decade==2000
replace era ="Era" if decade==2010

g decadelabel= ""
replace decadelabel ="1900s" if decade==1900
replace decadelabel ="1910s" if decade==1910
replace decadelabel ="1920s" if decade==1920
replace decadelabel ="1930s" if decade==1930
replace decadelabel ="1940s" if decade==1940
replace decadelabel ="1950s" if decade==1950
replace decadelabel ="\rowcolor{gray!25}1960s" if decade==1960
replace decadelabel ="\rowcolor{gray!25}1970s" if decade==1970
replace decadelabel ="\rowcolor{gray!25}1980s" if decade==1980
replace decadelabel ="1990s" if decade==1990
replace decadelabel ="2000s" if decade==2000
replace decadelabel ="2010s" if decade==2010
replace decadelabel ="\rowcolor{gray!25}2020s" if decade==2020



g blank = ""

g decade_pl5 = decade+5
g decade_m5 = decade-5

*save venue_med_masks, replace
labmask decade, value(decades)

/*Figure 5.3*/
mylabels 0(250)2250, prefix($) myscale(@)  local(dollab) format(%5.0fc) 
mylabels 0(25)100, suffix(%) myscale(@)  local(pct)
twoway bar totalcost2024a decade_m2 if decade<2030, barwidth(4) yaxis(1) fcolor(none) lc(gs10) lw(medthick) ///
|| bar  publiccost2024a decade_m2 if decade<2030,  barwidth(4) yaxis(1) bcolor(gs10) ///
|| bar totalcost2024s decade_pl2 if decade<2030, barwidth(4) yaxis(1) fcolor(none) lc(gs6) lw(medthick) ///
|| bar  publiccost2024s decade_pl2 if decade<2030,  barwidth(4) yaxis(1) bcolor(gs6) ///
|| line pubpct100 decade_pl5 if  decade<2030 ,  mc(black)  lp(vshortdash) yaxis(2) lc(black)  connect(step)  /// 
|| scatter pubpct100 decade if decade>1970& decade<2010 , ms(i) mlabel(pubpct100stpct)   yaxis(2)  mlabpos(12) mlabgap(0)  ///
|| line pubpct100 decade_m5 if decade<1930 , ms(o) mc(black)  lp(vshortdash) yaxis(2) connect(step) lc(black) ///
|| line pubpct100 decade_pl5 if decade<1930 , ms(o) mc(black)  lp(vshortdash) yaxis(2) connect(step) lc(black) ///
ylabel(`dollab', axis(1) labsize(medsmall)) ///
ylabel(`pct', axis(2) labsize(medsmall)) ///
xlabel(1900(10)2020, valuelabel labsize(small)) ///
ytitle("Median Construction Cost" "(millions of 2024 dollars)", axis(1) size(medium)) /// 
ytitle("Median Public Share (%)", axis(2) size(medium)) ///
xtitle("Decade", size(medium)) ///
legend(order(- "{bf:Arenas}" 1 "Total Cost"  2 "Public Cost" - "{bf:Stadiums}" 3 "Total Cost" 4 "Public Cost"  - "{bf:All Venues}" 5 "Public Share" ) col(1) pos(11) ring(0) symxsize(4))  ///
xline(1955, lp(dash)) xline(1985, lp(dash)) xline(2015, lp(dash)) ///
ttext(40 1925 "Inaugural" "Era", box bcolor(white) yaxis(2) ) ///
text(40 1970 "Superstadium" "Era", box bcolor(white) yaxis(2)) ///
text(40 2000 "Stadium" "Mania", box bcolor(white) yaxis(2)) ///
scheme(plotplain) ///
ttext( 49.5 2009.5 "47%", yaxis(2) box bcolor(white) size(small)) ///
ttext( 41.25 2020 "38%", yaxis(2) box bcolor(white)  size(small)) ///
ttext( 2 1897 "0%", yaxis(2) box bcolor(white)  size(small)) ///
ttext( 102 1930 "100%", yaxis(2) box bcolor(white)  size(small)) ///
name(eras_all_flat, replace)
/*
graph export "$figs\Fig5.3.pdf", as(pdf) replace
graph export "$tif\Fig5.3.tif", as(tif) width(3000)  replace
*/

/*Figure 5.4*/
mylabels 0(100)900, prefix($) myscale(@) local(dollab)
twoway bar publiccost2024 decade if decade>1920, barwidth(5) yaxis(1) bcolor(gs10) ///
||bar publiccost2024 decade if decade==2030, barwidth(5) yaxis(1) fcolor(white) bcolor(gs10) lwidth(medthick) lp(dash)   ///
|| scatter publiccost2024 decade if decade>1920&decade<1980, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*2) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==1980, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*5) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==1990, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*5) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==2000, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*5) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==2010, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*10) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==2020, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*10) mlabs(medium) ///
|| scatter publiccost2024 decade if decade==2030, ms(i) mlabel(pc2024dol) mlabpos(12) mlabg(*5) mlabs(medium) ///
|| qfit publiccost2024 decade if decade>1970, lc(gs6) lp(shortdash) ///
ytitle("Construction Cost" "(millions of 2024 dollars)", axis(1) size(medlarge)) ///
scheme(plotplainblind)  ///
ylabel(`dollab' , axis(1)  labsize(medium) tstyle(major) ) /// 
xtitle("Decade", size(medlarge)) ///
xlabel(1930(10)2030, labsize(medium) valuelabel glp(blank))   ///
plotregion(margin(t=5 r=5 l=5 b=1)) ///
legend(title("Public Contribution", size(large)) order(1 "Decade Median" 2 "Projected Median" 10 "Trend (since 1980s)") ring(0) pos(11) cols(1) size(medlarge) symxsize(15) symysize(3)) ///
name(median_pub_fut, replace)
/*
graph export "$figs\Fig5.4.pdf", as(pdf) replace
graph export "$tif\Fig5.4.tif", as(tif) width(3000)  replace
*/

/*Table 5.1*/
*Tabular outut for tex
listtab decadelabel era  blank arena tc2024dola pc2024dola pubpct100stpcta_tex blank stadium tc2024dols pc2024dols pubpct100stpcts_tex blank venue tc2024dol pc2024dol pubpct100stpct_tex if decade<2030, type rstyle(tabular)
*List output (make screen viewer wide)
list decadelabel era  arena tc2024dola pc2024dola pubpct100stpcta_tex blank stadium tc2024dols pc2024dols pubpct100stpcts_tex blank venue tc2024dol pc2024dol pubpct100stpct_tex if decade<2030
