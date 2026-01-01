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

*FCI*

*MLB
use "$data\mlb_did.dta", clear

*>2001 when TMA began excluding club seats from calculation
qui csdid fci2020 wpct lagwpct population ypc2020 if year>2001 , ivar(franid) time(yearid) gvar(newstadium) notyet method(reg)  
estat event,   window(0 7) estore(mlb_short_fci)
event_plot mlb_short_fci, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

*NFL
use "$data\nfl_did.dta", clear

*>2001 when TMA began excluding club seats from calculation
qui csdid fci2020 wpct lagwpct population if year>2001 , ivar(franid) time(year) gvar(newstadium) notyet method(reg) 
estat event,   window(0 7) estore(nfl_short_fci)
event_plot nfl_short_fci, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

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