/* This file provides the code for estimating price and revenue novelty effects for MLB and NFL.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
mlb_did.dta
nfl_did.dta
venuecosts2020.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.3
Tables (Stata viewer): 6.2
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

/*Estimating novelty effect on price of attendance for Fig. 6.3*/

/*MLB*/
use "$data\mlb_did.dta", clear

*>2001 when TMA began excluding club seats from calculation
qui csdid fci2020 wpct lagwpct population ypc2020 if year>2001 , ivar(franid) time(yearid) gvar(newstadium) notyet method(reg)  
estat event,   window(0 7) estore(mlb_short_fci)
event_plot mlb_short_fci, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

/*NFL*/
use "$data\nfl_did.dta", clear

*>2001 when TMA began excluding club seats from calculation
qui csdid fci2020 wpct lagwpct population if year>2001 , ivar(franid) time(year) gvar(newstadium) notyet method(reg) 
estat event,   window(0 7) estore(nfl_short_fci)
event_plot nfl_short_fci, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

/*Figure 6.3*/
mylabels -25(25)125, prefix($) myscale(@)  local(dollab) format(%2.0fc) last
event_plot  mlb_short_fci nfl_short_fci ,  plottype(connected) ciplottype(none) stub_lag(Tp# Tp#) stub_lead(Tm# Tm#)  shift(0)  ///
noautolegend ///
graph_opt( legend( order(1 "MLB" 2 "NFL") ring(0) pos(1) symxsize(15) size(medium)) ///
  yline(0, lcolor(gs10) lp(dash))  ///
  ylabel(`dollab', angle(horizontal) format(%9.0fc) labsize(medium)) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" , labsize(medium) ) /// 8 "9" 9"10" 
  ytitle("Average Change in Price of Attendance", size(medlarge)) xtitle("Year In New Venue", size(medlarge)) ///
  name(event_fci, replace)) ///
 lag_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lag_opt2(msymbol(Dh) color(gs6) lp(longdash))   ///
  lead_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lead_opt2(msymbol(Dh) color(gs6) lp(longdash)) 
/* save graphs
graph export "$figs\Fig6.3.pdf", as(pdf)  replace
graph export "$figs\Fig6.3.tif", as(tif) width(3000)  replace
*/

/*Generating information for Table 6.2*/
/*Novelty revenue estimates for left side of table*/

/*MLB*/
use "$data\mlb_did.dta", clear

qui csdid rev2020 wpct lagwpct population ypc2020 if !strike & !nyteam  , ivar(franid) time(yearid) gvar(newstadium) notyet method(reg) 
estat event,   window(0 11) estore(mlb_short_rev)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |    9.66996   13.52319     0.72   0.475    -16.83501    36.17493
         Tp0 |   42.61772   5.857801     7.28   0.000     31.13664     54.0988 <== Coefficient = MLB column 2 ($43)
         Tp1 |   26.36314   6.965445     3.78   0.000     12.71112    40.01516
         Tp2 |   25.30345   9.689703     2.61   0.009     6.311979    44.29492
         Tp3 |   15.10927   11.55058     1.31   0.191    -7.529447    37.74798 <== Sum coefficient Tp0→Tp3 = MLB column 3 ($109)
         Tp4 |   21.38021   11.48828     1.86   0.063    -1.136394    43.89682 <== Sum coefficient Tp0→Tp4 = MLB column 4 ($131)
         Tp5 |   17.40094   13.53636     1.29   0.199    -9.129846    43.93172 <== Sum coefficient Tp0→Tp4 = MLB column 5 ($148)
         Tp6 |  -1.643776   17.73441    -0.09   0.926    -36.40259    33.11503
         Tp7 |  -6.990617    16.9171    -0.41   0.679    -40.14751    26.16628
         Tp8 |  -3.601008   16.60032    -0.22   0.828    -36.13703    28.93502
         Tp9 |   -1.37363   21.24432    -0.06   0.948    -43.01174    40.26448
        Tp10 |  -6.120675   30.56807    -0.20   0.841    -66.03299    53.79164
        Tp11 |  -12.40549   36.72961    -0.34   0.736    -84.39421    59.58323
------------------------------------------------------------------------------
*/

/*NFL*/
use "$data\nfl_did.dta", clear

qui csdid rev2020  wpct lagwpct population ypc2020 , ivar(franid) time(year) gvar(newstadium) notyet method(reg) 
estat event,  window(0  11) estore(nfl_short_rev)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |   55.62041   19.03554     2.92   0.003     18.31144    92.92939
         Tp0 |   55.86225   10.42125     5.36   0.000     35.43697    76.28753 <== Coefficient = NFL column 2 ($56)
         Tp1 |   51.60629   9.075207     5.69   0.000     33.81921    69.39336
         Tp2 |   58.77043   12.82866     4.58   0.000     33.62672    83.91414
         Tp3 |     58.717   13.86802     4.23   0.000     31.53619    85.89782 <== Sum coefficient Tp0→Tp3 = NFL column 3 ($225)
         Tp4 |   56.87534   15.66511     3.63   0.000      26.1723    87.57839 <== Sum coefficient Tp0→Tp4 = NFL column 4 ($282)
         Tp5 |   66.18565   17.91156     3.70   0.000     31.07965    101.2917 <== Sum coefficient Tp0→Tp4 = NFL column 5 ($348)
         Tp6 |   58.08785   20.86473     2.78   0.005     17.19372    98.98197
         Tp7 |   55.34039   29.26085     1.89   0.059    -2.009814    112.6906
         Tp8 |   55.96885   28.76828     1.95   0.052    -.4159372    112.3536
         Tp9 |   57.70073   32.37562     1.78   0.075    -5.754306    121.1558
        Tp10 |   63.75248   37.32251     1.71   0.088    -9.398288    136.9033
        Tp11 |   28.57769   23.88286     1.20   0.231    -18.23186    75.38724
------------------------------------------------------------------------------
*/

/*Venue construction cost for right side of Table 6.2 
Dataset and data processing information available https://www.openicpsr.org/openicpsr/project/200122/version/V2/view
Download venuecosts2020.dta from the main/ folder
*/
use "$data\venuecosts2020.dta", clear //

tabstat  teamcost2020 subsidizecost2020 totalcost2020  subsidizedpct if nyteam!=1 &league=="MLB", by(league) stats(mean) format 
/* Yankees and Mets excluded due to unique attributes, discused in:
Bradbury, John Charles (2024) "Revisiting the novelty effect from new stadiums: An event study approach", Economic Inquiry, 62(4): 1722-1747
https://onlinelibrary.wiley.com/doi/10.1111/ecin.13231

Summary statistics: Mean
Group variable: league 

 league |  tea~2020  sub~2020  tot~2020  subsi~ct
--------+----------------------------------------
    MLB |       149       321       470        69 <== MLB columns 6→9
--------+----------------------------------------
  Total |       149       321       470        69 
-------------------------------------------------
*/

tabstat  teamcost2020 subsidizecost2020 totalcost2020  subsidizedpct if league=="NFL", by(league) stats(mean) format
/*
Summary statistics: Mean
Group variable: league 

 league |  tea~2020  sub~2020  tot~2020  subsi~ct
--------+----------------------------------------
    NFL |       405       312       717        51 <== NFL columns 6→9
--------+----------------------------------------
  Total |       405       312       717        51
-------------------------------------------------
*/

tabstat  teamcost2020 subsidizecost2020 totalcost2020  subsidizedpct if league=="NBA"|league=="NHL"|league=="NBA/NHL", by(league) stats(mean) format
/*
Summary statistics: Mean
Group variable: league 

 league |  tea~2020  sub~2020  tot~2020  subsi~ct
--------+----------------------------------------
    NBA |       144       160       304        52
NBA/NHL |       300        67       368        17
    NHL |       195       205       401        45
--------+----------------------------------------
  Total |       228       128       356        34 <== NBA/NHL columns 6→9
-------------------------------------------------
*/
