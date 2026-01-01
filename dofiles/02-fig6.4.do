/* This file provides the code for displaying the distribution of venue lease teams.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

************************
**	IMPORTANT	**
Geoffrey Propheter kindly provided data from his book for me to conduct for the analyis below.
As a condition of use of these data, you must cite his book as the source.
Propheter, Geoffrey (2022) Major League Sports and the Property Tax. Series: Sports Economics, Management and Policy. Springer Nature.
(https://link.springer.com/book/10.1007/978-3-031-18790-2 )
************************

Data Input (data\): 
propheter_lease_data.dt

Intermediate Output (working directory):

Final Output:
Figures(figs\):
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

/* Data output into the data\ folder
save "$data\.dta", replace
export delimited "$data\.csv", replace
*/

use "$data\propheter_lease_data.dta" , clear

sum minimumleaselengthyears if facilitytype!="soccer" ,  detail

histogram minimumleaselengthyears if facilitytype!="soccer" ,  width(1) freq discrete ///
xlabel(0(10)50 55,  labsize(medium) gmax) ///
ylabel(0(5)45,labsize(medium)) ///
xtitle(Lease Term, size(medlarge)) ytitle(Venues, size(medlarge)) ///
plotregion(margin(l=0))
/*
graph export "$figs\Fig6.4.pdf", as(pdf)  replace
graph export "$figs\Fig6.4.tif", as(tif) width(3000)  replace
*/

sum leaseendsyear if facilitytype!="soccer", detail