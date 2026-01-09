/* This file provides the code for estimating the novelty effect on team winning percentage .

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Much of the analysis discussed in Chapter 6 draws from the follow study:
Bradbury, John Charles (2024) "Revisiting the novelty effect from new stadiums: An event study approach", Economic Inquiry, 62(4): 1722-1747
(https://onlinelibrary.wiley.com/doi/10.1111/ecin.13231). 
Further details on the emprical analysis and tables are available in the replication package for the article located here: https://doi.org/10.3886/E200122V2 .

Data Input (data\): 
mlb_did.dta
nfl_did.dta
nba_did.dta
nhl_did.dta

Intermediate Output (working directory): League-specific graphs conbined to produce Fig 6.6
wpct_mlb.gph
wpct_nfl.gph
wpct_nba.gph
wpct_nhl.gph

Final Output:
Figures(figs\): 6.6
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

/*MLB*/
use "$data\mlb_did.dta", clear

qui csdid wpct, ivar(franid) time(yearid) gvar(newstadium) notyet  method(reg) gvar(newstadium) notyet  method(reg) short
estat event,   window(0 7) estore(mlb_wpct)
event_plot mlb_wpct, plottype(connected) ciplottype(rarea) stub_lag(Tp#) stub_lead(Tm#) noautolegend ///
graph_opt( legend(off) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-.2(.1).2, angle(horizontal) format(%9.3fc)) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8"  ) /// 
  ytitle("Average Change in Winning %") xtitle("") ///
  name(mlb_post, replace) title("MLB", size(medlarge) ring(0) pos(12))  xsize(4) ysize(4) ) ///
lag_opt1(msymbol(Oh) color(black) lp(solid) )   lag_ci_opt1(color(gs6%50)) 
/* save graphs*/
graph save wpct_mlb.gph, replace

/*NFL*/
use "$data\nfl_did.dta", clear

qui csdid wpct, ivar(franid) time(year) gvar(newstadium) notyet method(reg)  gvar(newstadium) notyet  method(reg) short
estat event,   window(0 7) estore(nfl_wpct)
event_plot nfl_wpct, plottype(connected) ciplottype(rarea) stub_lag(Tp#) stub_lead(Tm#) noautolegend ///
graph_opt( legend(off) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-.2(.1).2, angle(horizontal) format(%9.3fc)) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8"  ) /// 
  ytitle("") xtitle("") ///
  name(nfl_post, replace) title("NFL", size(medlarge) ring(0) pos(12)) xsize(4) ysize(4)) ///
lag_opt1(msymbol(Oh) color(black) lp(solid) )   lag_ci_opt1(color(gs6%50)) 
/* save graphs*/
graph save wpct_nfl.gph, replace

/*NBA*/
use "$data\nba_did.dta", clear

qui csdid wpct, ivar(franid) time(year) gvar(newstadium) notyet  method(reg)  gvar(newstadium) notyet  method(reg) short
estat event,   window(0 7) estore(nba_wpct)
event_plot nba_wpct, plottype(connected) ciplottype(rarea) stub_lag(Tp#) stub_lead(Tm#) noautolegend ///
graph_opt( legend(order(1 "Average Difference") pos(6) size(medsmall) ) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-.2(.1).2, angle(horizontal) format(%9.3fc)) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8"  ) /// 
ytitle("Average Change in Winning %")  xtitle("Year In New Venue") ///
  name(nba_post, replace) title("NBA", size(medlarge) ring(0) pos(12)) xsize(4) ysize(4.5)) ///
lag_opt1(msymbol(Oh) color(black) lp(solid) )   lag_ci_opt1(color(gs6%50)) 
/* save graphs*/
graph save wpct_nba.gph, replace

/*NHL*/
use "$data\nhl_did.dta", clear

qui csdid wpct, ivar(franid) time(year) gvar(newstadium) notyet  method(reg)  gvar(newstadium) notyet  method(reg) short
estat event,   window(0 7) estore(nhl_wpct)
event_plot nhl_wpct, plottype(connected) ciplottype(rarea) stub_lag(Tp#) stub_lead(Tm#) noautolegend ///
graph_opt( legend(order(2 "Confidence Interval (95%)") pos(6) size(medsmall)) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-.2(.1).2, angle(horizontal) format(%9.3fc)) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" ) /// 
  ytitle("") xtitle("Year In New Venue") ///
  name(nhl_post, replace) title("NHL", size(medlarge) ring(0) pos(12)) xsize(4) ysize(4)) ///
lag_opt1(msymbol(Oh) color(black) lp(solid) )   lag_ci_opt1(color(gs6%50)) 
/* save graphs*/
graph save wpct_nhl.gph, replace


/* Fig 6.6 */
graph combine wpct_mlb.gph   wpct_nfl.gph wpct_nba.gph wpct_nhl.gph, cols(2)  name(winning_pct, replace) xsize(4) ysize(4) plotregion(margin(t=0 b=0 l=0 r=0))
/*
graph export "$figs\Fig6.6.pdf", as(pdf) replace
graph export "$tif\Fig6.6.tif", as(tif) width(3000)  replace
*/