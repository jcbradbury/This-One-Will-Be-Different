/*
This file builds the base venue database (venuedb_base) used in:
**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (data\):
Other: This file is used for information presented throughout the book, particularly Chapter 5.
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\venuesdb_raw.dta", clear //  adds new KC Chiefs  stadium and Columbus BJ arena renovation in Dec.
*use "$data\venuesdb_raw_preKC_SJS.dta", clear // update through November

do "$dofiles\01-cpi2024_convert.do"

save "$outdat\venuesdb_base.dta", replace
/* Data output into the data\ folder
save "$data\venuesdb_base.dta", replace
export delimited "$data\venuesdb_base.csv", replace
*/