/* This runs all the do-files to generate the figures and tables in:

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

cap log close _all
log using results, replace

do "$dofiles\02-fig3.1.do"
do "$dofiles\02-fig5.1.do"
do "$dofiles\02-fig5.2.do"
do "$dofiles\02-fig5.3_5.4_tab5.1.do"
do "$dofiles\02-fig5.3_5.4_tab5.1.do"
do "$dofiles\02-fig5.5.do"
do "$dofiles\02-fig5.6.do"
do "$dofiles\02-fig5.7_tab5.4.do"
do "$dofiles\02-fig5.8.do"
do "$dofiles\02-fig5.9.do"
do "$dofiles\02-fig5.10.do"
do "$dofiles\02-tab5.2_5.3.do"
do "$dofiles\02-tab5.2_5.3.do"
do "$dofiles\02-tab5.5.do"
