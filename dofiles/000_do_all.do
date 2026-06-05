/* This runs all the do-files to generate the figures and tables in:

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

 ↓↓↓↓ IMPORTANT! ↓↓↓↓ 

*************************
**** SETUP **************
*************************

You must set you home directory in 00-setup.do  before running this file.

Follow the directions to set the home directory.

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

/*
cap log close _all
log using results, replace
*/
scalar t1 = c(current_time)
do "$dofiles\02-cited-intro.do"

do "$dofiles\02-fig3.1.do"

do "$dofiles\02-fig5.1.do"
do "$dofiles\02-fig5.2.do"
do "$dofiles\02-fig5.3_5.4_tab5.1.do"
do "$dofiles\02-fig5.5.do"
do "$dofiles\02-fig5.6.do"
do "$dofiles\02-fig5.7_tab5.4.do"
do "$dofiles\02-fig5.8.do"
do "$dofiles\02-fig5.9.do"
do "$dofiles\02-fig5.10.do"
do "$dofiles\02-tab5.2_5.3.do"
do "$dofiles\02-tab5.5.do"


do  "$dofiles\02-fig6.1.do"
do  "$dofiles\02-fig6.2_tab6.1.do"
do  "$dofiles\02-fig6.3_tab6.2.do"
do  "$dofiles\02-fig6.4.do"
do  "$dofiles\02-fig6.5.do"
do  "$dofiles\02-fig6.6.do"

do  "$dofiles\02-tab7.1.do"

do  "$dofiles\02-fig10.1.do"


do  "$dofiles\02-fig12.1_12.3.do"
do  "$dofiles\02-fig12.4.do"

do  "$dofiles\02-fig13.2_13.3_tab13.1.do"

do  "$dofiles\02-fig15.1.do"
do  "$dofiles\02-fig15.2.do"

do  "$dofiles\02-tab17.1.do"

do  "$dofiles\02-tab18.1.do"

do  "$dofiles\02-fig19.2.do"
do  "$dofiles\02-fig19.3.do"

do  "$dofiles\02-tabA.1.do"


scalar t2 = c(current_time)
display (clock(t2, "hms") - clock(t1, "hms")) / 1000 " seconds"
beep





