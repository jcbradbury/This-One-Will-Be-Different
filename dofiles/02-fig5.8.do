/* This file provides the code for merging MLS stadium costs and tracking MLS stadium openings.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
mls_stadiums_only.dta
venuesdb_base.dta

Other Inputs:
Do-files: 01_cpi2024_convert.do

Intermediate Output (working directory):

Final Output:
Figures(figs\): 5.8
Tables (Stata viewer): 
Data (outdat\): mls_stadiums.dta, venuesdb_mls.dta
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

use "$data\mls_stadiums_only.dta", clear

do "$dofiles\01-cpi2024_convert.do"

so venuename_tex year

save "$outdat\mls_stadiums.dta", replace

/* Data output into the data\ folder
save "$data\mls_stadiums.dta", replace
export delimited "$data\mls_stadiums.csv", replace
*/

use "$data\venuesdb_base.dta", clear

/*append MLS data*/
append using "$data\mls_stadiums.dta"

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
replace team_mls="New England  Revolution"   if teams_tex=="New England Patriots \& Revolution"
replace team_mls="Vancouver Whitecaps"   if teams_tex=="Vancouver Whitecaps \& BC Lions"
replace team_mls="Toronto FC"   if teams_tex=="Toronto FC \& Argonauts"
replace team_mls="Charlotte FC"  if teams_tex=="Carolina Panthers \& Charlotte FC"
replace team_mls="Seattle Sounders"   if teams_tex=="Seattle Seahawks \& Sounders"
replace team_mls="Atlanta United"  if teams_tex=="Atlanta Falcons \& United"
replace team_mls="Chicago Fire"  if teams_tex=="Chicago Bears \& Fire"
replace team_mls="NYFC"   if teams_tex=="New York Yankees \& NYFC"

g mls=0
replace mls=1 if league=="MLS"|league=="NFL/MLS"|league=="MLB/MLS"|league=="MLS/CFL"

replace  lastrenovation = 2016 if team_mls=="Toronto FC"
replace renovation_amount = 80 if team_mls=="Toronto FC" /* All public. Converted for exchnage rate.*/
replace  lastrenovation = 2011 if team_mls=="Vancouver Whitecaps"
replace renovation_amount = 516 if team_mls=="Vancouver Whitecaps" /* All public. Converted for exchnage rate.*/

/*save the curated file that adds MLS venues to venues database */
save "$outdat\venuesdb_mls.dta", replace

/* Data output into the data\ folder
save "$data\venuesdb_mls.dta", replace
export delimited "$data\venuesdb_mls.csv", replace
*/

/*Count MLS stadium construction by year*/
keep if mls==1 

so year
by year: egen scount= sum(stadium)
by year: egen acount= sum(arena)
g vens= acount +scount

* Generate MLS stadium counts by category
by year: egen mlscount= sum(stadium) if mls==1
by year: egen mlsNFL= sum(stadium) if league=="NFL/MLS"
by year: egen mlsMLB= sum(stadium) if league=="MLB/MLS"
by year: egen mlsCFL= sum(stadium) if league=="MLS/CFL"
by year: egen mlscollege= sum(stadium) if venuename_tex =="Snapdragon Stadium"
by year: egen mlsonly= sum(stadium) if league=="MLS" & venuename_tex !="Snapdragon Stadium"

replace mlscount= 0 if mlscount==.
replace mlsNFL= 0 if mlsNFL==.
replace mlsMLB= 0 if mlsMLB==.
replace mlsCFL= 0 if mlsCFL==.
replace mlscollege= 0 if mlscollege==.
replace mlsonly= 0 if mlsonly==.

/*Figure 5.8*/
twoway bar mlscount year if mls==1 & year>1979, bc(gs15) blc(gs8) blw(thin) /// 
|| bar mlscollege year if year>1979, bc(gs12) blc(gs8) blw(thin) ///
|| bar mlsCFL year if mls==1 & year>1979, bc(gs8) blc(gs6) blw(thin) ///
|| bar mlsNFL year if year>1979, bc(gs0) blc(gs8) blw(thin) ///
|| bar mlsMLB year if year>1979, bc(gs3) blc(gs8) blw(thin) ///
ytitle("MLS Stadiums Opened", size(medlarge)) ///
xtitle(,size(medlarge)) ///
xlabel(1980(5)2030,labsize(medlarge)) ///
ylabel(0(1)3,labsize(medlarge)) ///
legend(order(1 "MLS only (25)" 2 "MLS/CFB (1)"  3 "MLS/CFL (2)"  5 "MLS/MLB (1)"     4  "MLS/NFL (4)"  ) ring(0) pos(11) cols(1) size(medium)) ///
name(mls_count, replace)
/*
graph export "$figs\Fig5.8.pdf", as(pdf) replace
graph export "$tif\Fig5.8.tif", as(tif) width(3000)  replace
*/