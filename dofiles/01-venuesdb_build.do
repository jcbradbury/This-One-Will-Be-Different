/*
This file builds the base venue database (venuedb_base) used in:
**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_raw.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\): venuesdb_base.dta

This is the primary dataset of venue construction costs, which is used as the base for constructing other datasets.
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\venuesdb_raw.dta", clear 

do "$dofiles\01-cpi2024_convert.do"
do "$dofiles\01-cpi2024_reno.do"

label variable 	venuename	"Venue Name"	// 	Venue name (current/most common)
label variable 	year	"Year"	// 	Year opened
label variable 	teams	"Teams"	// 	Teams hosted

/*_tex suffix denotes LaTeX friendly names for tables*/
label variable 	venuename_tex	"VenueName_tex"	// 	Tex friendly version for tables
label variable 	teams_tex	"Teams_tex"	// 	Tex friendly version for tables
label variable 	team_current_tex	"Team_Current_Tex"	// 	Tex friendly version for tables

label variable 	city	"City"	// 	Host city
label variable 	league	"League"	// 	League
label variable 	type	"Type"	// 	Arena (A) / Stadium (S)
label variable 	decade	"Decade"	// 	Decade opened (numeric)
label variable 	typelabel	"Typelabel"	// 	Arenas / Stadiums
label variable 	canada	"Canada"	// 	Canadian team indicator
label variable 	totalcost	"Total Cost"	// 	Total cost (current dollars)
label variable 	publiccost	"Public Cost"	// 	Public cost (current dollars)
label variable 	pubpct100	"Public Share (%)"	// 	(Public Cost / Total Cost) *100
label variable 	decades	"Decades"	// 	Decade label (string, plural)
label variable 	nfl	"NFL"	// 	NFL indicator
label variable 	mlb	"MLB"	// 	MLB indicator
label variable 	nba	"NBA"	// 	NBA indicator
label variable 	nhl	"NHL"	// 	NHL indictor
label variable 	current_mlb	"Current MLB"	// 	MLB indicator (current team)
label variable 	current_nfl	"Current NFL"	// 	NFL indicator (current team)
label variable 	current_nba	"Current NBA"	// 	NBA indicator (current team)
label variable 	current_nhl	"Current NHL"	// 	NHL indicator (current team)
label variable 	current	"Current Team"	// 	Current team indicator (all leagues)
label variable 	label_mlb	label_mlb	// 	Short label (MLB)
label variable 	label_nfl	label_nfl	// 	Short label (NFL)
label variable 	label_nba	label_nba	// 	Short label (NBA)
label variable 	label_nhl	label_nhl	// 	Short label (NHL)
label variable 	future	"Future"	// 	Future venue indicator 
label variable 	stadium	"Stadium"	// 	Stadium indicator
label variable 	arena	"Arena"	// 	Arena indicator
label variable 	team_mlb	"Team Name (MLB)"	// 	Team name (MLB)
label variable 	team_nfl	"Team Name (NFL)"	// 	Team name (NFL)
label variable 	team_nba	"Team Name (NBA)"	// 	Team name (NBA)
label variable 	team_nhl	"Team Name (NHL)"	// 	Team name (NHL)
label variable 	team_current	"Team Name (current)"	// 	Team name (all leagues)
label variable 	lastyear	"Last Year"	// 	Last year venue open
label variable 	stillopen	"Still Open"	// 	Venue open in 2025
label variable 	lastrenovation	"Last Renovation Year"	// 	First year open after last renovation
label variable 	renovation_amount	"Last Renovation Cost"	// 	Total cost of last renovation (current dollars)
label variable 	future_renovation	"Future Renovation Cost"	// 	Total cost of future renovation (current dollars)
label variable 	future_reno_public	"Future Public Renovation Cost"	// 	First year open after future renovation
label variable 	planned_renovation	"Planned Renovation"	// 	Planned renovation indicator (1)
label variable 	replacement_planned	"Planned Replacement"	// 	Planned replacement indicator (1)
label variable 	recent_renovation	"Recent Renovation"	// 	Recent renovation indicator
label variable 	future_renovation_complete	"Future Renovation Completion Year"	// 	Expected first year open after future renovation complete
label variable 	wave	"Wave"	// 	Construction wave (1,2,3,4)

/* 0 indicators used for Figure 5 dot plots*/
label variable 	announced0	announced0	// 	Tentative replacement venue announced indicator (0)
label variable 	planned0	planned0	// 	Planned renovation indicator (0)
label variable 	replacement0	replacement0	// 	Planned replacement indicator (0)

label variable 	source	"Source"	// 	List of sources that document values (not exhaustive)
label variable 	totalcost2024	"Total Cost (2024)"	// 	Total cost in real 2024 dollars
label variable 	publiccost2024	"Public Cost (2024)"	// 	Public cost in real 2024 dollars
label variable 	renovation_amount2024	"Renovation Cost (2024)"	// 	Total cost of last renovation in real 2024 dollars


save "$outdat\venuesdb_base.dta", replace
