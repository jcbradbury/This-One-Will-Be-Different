/* This file provides the code for recording growth in MLS.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
leagues_revenue.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 5.7
Tables (Stata viewer): 5.4
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

use "$data\leagues_revenue.dta", clear 

/*Figure 5.7 */
mylabels 0(5)75, prefix($) myscale(@) local(dollab)
twoway line teams_mls year, connect(stair) yaxis(1) lp(dash) lc(gs4) lw(thin) ///
|| line  mls_rev year, yaxis(2) lp(solid) lc(gs0) lw(medthick) ///
xlabel(1996 2000(5)2025, labsize(medium)) ///
ylabel(10(2)30, axis(1) labsize(medium)) ///
ylabel(`dollab', axis(2) labsize(medium)) ///
ytitle(MLS Teams, axis(1) size(medlarge)) ///
ytitle(Average Team Revenue (in millions),axis(2) size(medlarge)) ///
xtitle(, size(medlarge)) ///
name(mls_ref, replace) ///
legend(order(1 "Teams" 2 "Revenue" ) ring(0) pos(11) size(medlarge) symxsize(11))
/*
graph export "$figs\Fig5.7.pdf", as(pdf) replace
graph export "$tif\Fig5.7.tif", as(tif) width(3000)  replace
*/


/*Table 5.4*/
list nfl_*  mlb_* nba_* nhl_* mls_* if year==2024
/*Min and Max in table tabulated from Forbes websites (various years):
NFL: https://www.forbes.com/nfl-valuations/list/;#tab:overall
MLB: https://www.forbes.com/mlb-valuations/list/;#tab:overall
NBA: https://www.forbes.com/nba-valuations/list/;#tab:overall
NHL: https://www.forbes.com/sites/justinteitelbaum/2025/12/11/the-nhls-most-valuable-teams-2025/
MLS: https://www.forbes.com/sites/justinbirnbaum/2025/02/21/the-most-valuable-mls-teams-2025/

Note: Annual rankings reflect revenue from previous year.
NBA and NHL years refer the year the season ended (i.e., 2024 value reflects 2023-2024 season).
*/


