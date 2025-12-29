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


*use "$data\venuesdb_raw.dta", clear // update through November
use "$data\venuesdb_raw2.dta", clear // adds new KC Chiefs  stadium and Columbus BJ arena renovation in Dec.

do "$dofiles\01-cpi2024_convert.do"

/*Save processed file*/
*save "$data\venuesdb_base.dta", replace