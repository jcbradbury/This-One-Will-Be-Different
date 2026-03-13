/* This file provides the code for summary costs of venue subsidies reported in the introduction

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_all.dta
milb_ballparkcosts.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\):
Other:
CITED in text: Public contributions to stadiums since 2000
CITED in text: Cumulative public funding to MLS teams
CITED in text: Cumulative public contributions to minor-league ballparks
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\venuesdb_all.dta", clear

/* CITED in text: Public contributions to stadiums since 2000 (see Chapter 5) */
tabstat publiccost2024 if year>1999 &year!=. & league!="MLS" & league!="MLS/CFL", stats(sum, median, mean) format
/*
    Variable |       Sum       p50      Mean
-------------+------------------------------
publicc~2024 |    28,284       383       442
--------------------------------------------
*/

/*CITED in text: Cumulative public funding to MLS teams (see Chapter 5) */
tabstat publiccost2024 if league=="MLS"|league=="MLS/CFL", stats(sum) format
/*
    Variable |       Sum
-------------+----------
publicc~2024 |     3,187
------------------------
*/

/*CITED in text: Cumulative public contributions to minor-league ballparks (see Chapter 19) */
use "$data\milb_ballparkcosts.dta", clear
 
tabstat publiccost2024 sumpublicrenovationcost2024 , stats(sum) format(%9.0fc)
/*
   Stats |  pub~2024  sumpub~4
---------+--------------------
     Sum |     5,430     1,377
------------------------------
$5,430 million + $1,377 million = $6,807 million ==> $6.81 billion
*/

