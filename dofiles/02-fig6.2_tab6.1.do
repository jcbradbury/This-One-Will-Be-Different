/* This file provides the code for .

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
mlb_did.dta
nfl_did.dta
nba_did.dta
nhl_did.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.2
Tables (Stata viewer): 6.1
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

qui csdid attg wpct lagwpct population ypc2020 if !nyteam , ivar(franid) time(yearid) gvar(newstadium) notyet  method(reg) short
estat event,   window(0 11) estore(mlb_short_nony)
event_plot mlb_short_nony, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)
 
/*NFL*/
use "$data\nfl_did.dta", clear

qui csdid attg_combine wpct lagwpct population ypc2020 , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short 
estat event,  window(0  11) estore(nfl_short)
event_plot nfl_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

/*NBA*/
use "$data\nba_did.dta",clear

csdid attg wpct lagwpct population , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short
estat event,  window(0  11) estore(nba_short)
event_plot nba_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)

/*NHL*/
use "$data\nhl_did.dta", clear

qui csdid attg wpct lagwpct  , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short 
estat event,  window(0  11) estore(nhl_short)
event_plot nhl_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)


*Combined
/*Fig 6.2*/
event_plot  mlb_short_nony nfl_short nba_short nhl_short,  plottype() ciplottype(none) stub_lag(Tp# Tp# Tp# Tp#) stub_lead(Tm# Tm# Tm# Tm# )  shift(0)  ///
noautolegend ///
graph_opt( legend( order(1 "MLB" 2 "NFL" 3 "NBA"  4 "NHL") ring(0) pos(1) symxsize(15) size(medium)) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-4000(2000)10000, angle(horizontal) format(%9.0fc) labsize(medium) ) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9"10" 10 "11" 11 "12", labsize(medium) ) /// -6(1)-1
  ytitle("Average Change in Attendance per Game", size(medlarge)) xtitle("Year In New Venue", size(medlarge)) ///
  name(event_all, replace)) ///
 lag_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lag_opt2(msymbol(Dh) color(gs6) lp(longdash))   ///
 lag_opt3(msymbol(Th) color(gs8) lp(dash))   ///
 lag_opt4(msymbol(Sh) color(gs10) lp(vshortdash))  ///
  lead_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lead_opt2(msymbol(Dh) color(gs6) lp(longdash)) ///
 lead_opt3(msymbol(Th) color(gs8) lp(dash))   ///
 lead_opt4(msymbol(Sh) color(gs10) lp(vshortdash))  
/*
graph export "C:\Users\jcbra\OneDrive\AtlStadium\Figures\Fig6.2.pdf", as(pdf)  replace
graph export "C:\Users\jcbra\OneDrive\AtlStadium\Figures\Fig6.2.tif", as(tif) width(3000)  replace
*/

/*
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
graph export "C:\Users\jcbra\OneDrive\AtlStadium\Figures\Fig6.3.pdf", as(pdf)  replace
graph export "C:\Users\jcbra\OneDrive\AtlStadium\Figures\Fig6.3.tif", as(tif) width(3000)  replace
*/
 
 
 