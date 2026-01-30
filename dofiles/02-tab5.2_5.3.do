/* This file provides the code for generating tables of venue renovation costs.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_base.dta

Other Inputs:
Do-files:

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 5.2, 5.3
Data (outdat\):
Other:
CITED in text: Summary stats for the renovated venues in Table 5.2
CITED in text: Summary stats for future renovated venues in Table 5.3

*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\venuesdb_base.dta", clear

/*Create Tex friendly variables for table input*/
g reno2024st = string(renovation_amount2024,"%9.0fc")
g reno2024dol = "\\$" +reno2024st
replace reno2024dol ="" if renovation_amount2024 ==.

g future_renovation_st=string(future_renovation,"%9.0fc")
g future_reno_dol = "\\$" + future_renovation_st
replace future_reno_dol ="" if future_renovation ==.

g future_reno_pub_st=string(future_reno_public,"%9.0fc")
g future_reno_pub_dol = "\\$" + future_reno_pub_st
replace future_reno_pub_dol ="" if future_renovation ==.

g future_renovation_complete_st = string(future_renovation_complete ,"%9.0f")
replace future_renovation_complete_st = "Ongoing" if venuename_tex=="Bridgestone Arena"
replace future_renovation_complete_st = "Ongoing" if venuename_tex=="Nationals Park"
replace future_renovation_complete_st = "TBD" if venuename_tex=="FedEx Forum"
replace future_renovation_complete_st = "TBD" if venuename_tex=="American Family Field"
replace future_renovation_complete_st = "TBD" if venuename_tex=="Capital One Arena"
replace future_renovation_complete_st = "TBD" if venuename_tex=="Oriole Park at Camden Yards"
replace future_renovation_complete_st = "TBD" if venuename_tex=="Paycor Stadium"
replace future_renovation_complete_st = "TBD" if venuename_tex=="Chase Field"
replace future_renovation_complete_st = "TBD" if venuename_tex=="United Center"
replace future_renovation_complete_st = "TBD" if venuename_tex=="SAP Center"

g renolist=0
replace renolist=1 if lastrenovation!=.
replace renolist=1 if planned_renovation==1
replace renolist=0 if venuename_tex=="Key Arena"

g blank = ""

g venuename_reno = venuename_tex

replace venuename_reno = "Scotiabank Saddledome*" if venuename_reno == "Scotiabank Saddledome"
replace venuename_reno = "Oakland-Alameda County Coliseum*" if venuename_reno == "Oakland-Alameda County Coliseum"
replace venuename_reno = "Paycom Center*" if venuename_reno == "Paycom Center"
replace venuename_reno = "Highmark Stadium*" if venuename_reno == "Highmark Stadium"
replace venuename_reno = "GEHA Field at Arrowhead Stadium*" if venuename_reno == "GEHA Field at Arrowhead Stadium"
replace venuename_reno = "Huntington Bank Field*" if venuename_reno == "Huntington Bank Field"
replace venuename_reno = "Empower Field at Mile High*" if venuename_reno == "Empower Field at Mile High"
replace venuename_reno = "Xfinity Mobile Arena*" if venuename_reno == "Xfinity Mobile Arena"

replace venuename_reno = "EverBank Stadium$^\dagger$" if venuename_reno == "EverBank Stadium"
replace venuename_reno = "Delta Center$^\dagger$" if venuename_reno == "Delta Center"
replace venuename_reno = "Bank of America Stadium$^\dagger$" if venuename_reno == "Bank of America Stadium"
replace venuename_reno = "Capital One Arena$^\dagger$" if venuename_reno == "Capital One Arena"
replace venuename_reno = "M\&T Bank Stadium$^\dagger$" if venuename_reno == "M\&T Bank Stadium"

replace future_reno_pub_dol = "\\$600*" if venuename_tex == "M\&T Bank Stadium"|venuename_tex == "Oriole Park at Camden Yards"
replace future_reno_pub_dol = "\multicolumn{1}{c}{$\dagger$}" if venuename_tex == "Nationals Park" /*Ballpark Maintenance Fund for renovations of indeterminant amount*/
replace future_reno_dol  = "\multicolumn{1}{c}{$\dagger$}"   if venuename_tex == "Nationals Park" /*Ballpark Maintenance Fund for renovations of indeterminant amount*/

replace future_reno_dol  = "\multicolumn{1}{c}{$\ddagger$}"   if venuename_tex == "United Center" /*Ballpark Maintenance Fund for renovations of indeterminant amount*/

replace future_reno_pub_dol ="\\$0" if venuename_tex == "United Center" /*Ballpark Maintenance Fund for renovations of indeterminant amount*/

******************************
/*Table 5.2 (output created)*/
gsort lastrenovation venuename_tex 

listtab venuename_reno team_current_tex blank year blank lastrenovation   reno2024dol  if renolist==1 &lastrenovation!=. &stillopen, type rstyle(tabular)

list venuename_reno team_current_tex  year  lastrenovation   renovation_amount2024  if renolist==1 &lastrenovation!=. &stillopen,
*****************************

/*CITED in text: Summary stats for the renovated venues in Table 5.2*/
tabstat renovation_amount2024  if renolist==1 &lastrenovation!=. &stillopen, by(typelabel) stats(count min median max sd p25 p75)

/* 
Summary for variables: renovation_amount2024
Group variable: typelabel 

typelabel |         N       Min       p50       Max        SD       p25       p75
----------+----------------------------------------------------------------------
   Arenas |        18      61.8     152.6      1350  292.0163    102.85       250
 Stadiums |        23       103    219.96      1122  272.3953     147.6       540
----------+----------------------------------------------------------------------
    Total |        41      61.8     184.5      1350  282.4344       125       365
---------------------------------------------------------------------------------
*/

**************
/*Figure 5.3*/
gsort future_renovation_complete future_renovation_complete_st  venuename_tex

listtab venuename_tex team_current_tex blank year blank  future_renovation_complete_st    future_reno_dol future_reno_pub_dol if renolist==1 & planned_renovation==1, type rstyle(tabular)

list venuename_tex team_current_tex blank year blank  future_renovation_complete_st   future_renovation future_reno_public if renolist==1 & planned_renovation==1,
**************

/*CITED in text: Summary stats for future renovated venues in Table 5.3*/
tab typelabel  if renolist==1 & planned_renovation==1
/*
  typelabel |      Freq.     Percent        Cum.
------------+-----------------------------------
     Arenas |         12       52.17       52.17
   Stadiums |         11       47.83      100.00
------------+-----------------------------------
      Total |         23      100.00
*/

/*CITED in text: Summary stats for future renovated venues in Table 5.3*/
tabstat future_renovation if renolist==1 & planned_renovation==1 , by(typelabel) stats(count min median max sd p25 p75)
/* 
Summary for variables: future_renovation
Group variable: typelabel 

typelabel |         N       Min       p50       Max        SD       p25       p75
----------+----------------------------------------------------------------------
   Arenas |        11       150       400      1000  230.7454       226       500
 Stadiums |        10       200       450      1400  358.0205       350       750
----------+----------------------------------------------------------------------
    Total |        21       150       425      1400  298.2239       300       501
---------------------------------------------------------------------------------
**IMPORTANT**:  Nationals Park (revenue stream of indeterminant cost) and United Center (cost not reported) not included. 
See previous table for accurate count of future venue renovations
*/
