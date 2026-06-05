/* This file provides the code for tabulating construction costs for current host venues

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\):
venuesdb_all.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 5.5
Data (outdat\): ven_cost_current.dta
Other: 
CITED in text: Public cost of venue subsidies to US households 
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

g main_mlb =0
replace main_mlb=1 if current_mlb==1
g main_nfl =0
replace main_nfl=1 if current_nfl==1

g main_lg =league if current==1
replace main_lg ="MLB" if main_mlb==1
replace main_lg="NFL" if main_nfl==1
replace main_lg="NBA" if current_nba==1 & current_nhl!=1
replace main_lg="NHL" if current_nhl==1 & current_nba!=1
replace main_lg="NBA/NHL" if current_nba==1 & current_nhl==1
replace main_lg ="MLS" if current_mls==1 & league!="MLB/MLS" & league!="NFL/MLS"

keep if current
drop if team_current=="Seattle Kraken" /*Unique construction/reconstruction history, not included in aggregate costs*/

collapse (count) year (sum) publiccost2024 totalcost2024, by(main_lg)

g pubpct100= (publiccost2024/totalcost2024)*100
format pubpct100 %9.0fc
rename year venues

/*Table 5.5*/
tabstat venues publiccost2024 totalcost2024 pubpct100, by(main_lg) stats(sum) format(%9.0fc)
/* 
Summary statistics: Sum
Group variable: main_lg 

main_lg |    venues  pub~2024  tot~2024  pubp~100
--------+----------------------------------------
    MLB |        29    10,349    18,083        57
    MLS |        23     2,476     5,944        42
    NBA |        19     4,405    10,767        41
NBA/NHL |        11       636     6,028        11
    NFL |        30    11,311    29,863        38
    NHL |        20     3,363     7,683        44
--------+----------------------------------------
  Total |       132    32,540    78,369       232 <== ignore Total pubpct100 (see below)
-------------------------------------------------
*/

/*Calcuate overall public share*/
egen sumpubliccost2024 = sum(publiccost2024)
egen sumtotalcost2024 = sum(totalcost2024)
g sumpubpct100 = (sumpubliccost2024/sumtotalcost2024)*100
format sumpubliccost2024 sumtotalcost2024 sumpubpct100 %9.0fc

sum sumpubpct100 if main_lg!="", format
/*
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
sumpubpct100 |          6          42           0         42         42
*/

save "$outdat\ven_cost_current.dta", replace


/*CITED in text: Public cost of venue subsidies to US households 

Total public outlays to stadium construction: $32,540 million
US households: 129,227,496 // Link: https://www.census.gov/quickfacts/fact/table/US/PST045224 (accessed: 3/18/2026)

$32,540,000,000 /  129,227,496 = $252
*/

*/

