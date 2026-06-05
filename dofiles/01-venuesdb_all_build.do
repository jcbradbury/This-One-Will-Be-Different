/* This file provides the code for merging MLS stadium costs and tracking MLS stadium openings.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
mls_stadiums_raw.dta
venuesdb_base.dta

Other Inputs:
Do-files: 01_cpi2024_convert.do

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\): mls_stadiums_base.dta, venuesdb_all.dta
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

use "$data\mls_stadiums_raw.dta", clear

do "$dofiles\01-cpi2024_convert.do"

so venuename_tex year

save "$outdat\mls_stadiums_base.dta", replace


use "$data\venuesdb_base.dta", clear

/*append MLS data*/
append using "$data\mls_stadiums_base.dta"

replace teams_tex = "New England Patriots \& Revolution" if venuename_tex=="Gillette Stadium"
replace teams_tex = "Carolina Panthers \& Charlotte FC" if venuename_tex=="Bank of America Stadium"
replace teams_tex = "Seattle Seahawks \& Sounders" if venuename_tex=="Lumen Field"
replace teams_tex = "Atlanta Falcons \& United" if venuename_tex=="Mercedes-Benz Stadium"
replace teams_tex = "Chicago Bears \& Fire" if venuename_tex=="Soldier Field"
replace teams_tex = "New York Yankees \& NYFC" if venuename_tex=="Yankee Stadium" &year==2009

replace league = "NFL/MLS" if venuename_tex=="Gillette Stadium"|venuename_tex=="Bank of America Stadium"
replace league = "NFL/MLS" if venuename_tex=="Lumen Field"|venuename_tex=="Mercedes-Benz Stadium"|venuename_tex=="Soldier Field"
replace league = "MLB/MLS" if venuename_tex=="Yankee Stadium" &year==2009

so year venuename_tex

replace current_mls =0 if current_mls==.
replace current_mls=1 if venuename_tex=="Gillette Stadium"|venuename_tex=="Bank of America Stadium"|venuename_tex=="Lumen Field"|venuename_tex=="Mercedes-Benz Stadium"|venuename_tex=="Soldier Field"
replace current_mls=1 if venuename_tex=="Yankee Stadium" & year==2009

g team_mls = teams_tex if current_mls==1
replace team_mls="New England Revolution"   if teams_tex=="New England Patriots \& Revolution"
replace team_mls="Vancouver Whitecaps"   if teams_tex=="Vancouver Whitecaps \& BC Lions"
replace team_mls="Toronto FC"   if teams_tex=="Toronto FC \& Argonauts"
replace team_mls="Charlotte FC"  if teams_tex=="Carolina Panthers \& Charlotte FC"
replace team_mls="Seattle Sounders"   if teams_tex=="Seattle Seahawks \& Sounders"
replace team_mls="Atlanta United"  if teams_tex=="Atlanta Falcons \& United"
replace team_mls="Chicago Fire"  if teams_tex=="Chicago Bears \& Fire"
replace team_mls="NYFC"   if teams_tex=="New York Yankees \& NYFC"
replace team_mls="Inter Miami" if teams_tex=="Inter Miami"

g mls=0
replace mls=1 if league=="MLS"|league=="NFL/MLS"|league=="MLB/MLS"|league=="MLS/CFL"

replace  lastrenovation = 2016 if team_mls=="Toronto FC"
replace renovation_amount = 80 if team_mls=="Toronto FC" /* All public. Converted for exchnage rate.*/
replace  lastrenovation = 2011 if team_mls=="Vancouver Whitecaps"
replace renovation_amount = 516 if team_mls=="Vancouver Whitecaps" /* All public. Converted for exchnage rate.*/

/*save the curated file that adds MLS venues to venues database */
save "$outdat\venuesdb_all.dta", replace
