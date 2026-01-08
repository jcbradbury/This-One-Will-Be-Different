/* This file provides the code to produce a table of privately financed venues.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
msarank2023.dta
venuesdb_all.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\):
Other: 
CITED in text: Total teams hosted in primarily privately financed venues
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

/* Data output into the data\ folder
save "$data\.dta", replace
export delimited "$data\.csv", replace
*/

/*Sort the population data by city*/
use "$data\msarank2023.dta", clear

so city 
save combine_msarank2023_temp, replace

/*Make adjustments in venues data for amibiguity in city names*/
use "$data\venuesdb_all.dta", clear

replace city="Columbus, OH" if city=="Columbus"
replace city="Portland, OR" if city =="Portland"

replace venuename_tex="Oracle Park$^\dagger$" if venuename_tex=="Oracle Park"
so city

/*Merge the datasets*/
merge m:m city using combine_msarank2023_temp  


/*build the tables*/
gsort -year venuename_tex

replace team_current_tex = teams_tex if league=="MLS"
replace team_current_tex = teams_tex if league=="NFL/MLS"
replace team_current_tex = teams_tex if league=="MLB/MLS"

list rankmsa2023 venuename_tex team_current_tex league year  totalcost2024 totalcost publiccost pubpct100  if pubpct100<=5 &current
listtab rankmsa2023 venuename_tex team_current_tex league year  totalcost2024  if pubpct100<=5 &current, type rstyle(tabular)

tabstat current_*  if pubpct100<=5 &current, stats(sum)
/*CITED in text: Total teams hosted in primarily privately financed venues
46 total teams (also hand-counted)
   Stats |  curren~b  curre~fl  curren~a  curre~hl  curren~s
---------+--------------------------------------------------
     Sum |         3         6        13        16         8
------------------------------------------------------------
*/

