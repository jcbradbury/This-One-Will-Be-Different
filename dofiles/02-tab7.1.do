/* This file provides the code for estimating venue opulence.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\):
venuesdb_base.dta
venue_acres.dta
venue_demo.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 7.1
Data (outdat\):
Other: 
CITED in text: Truist Park opulence example
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

keep if year>1989 &year<2020 // Confine to Stadium Mania era

/*Merge in acreage */
so venuename_tex year
merge 1:1 venuename_tex year using "$data\venue_acres.dta"
drop _m

/*Merge in metro population and income */
so venuename_tex year
merge 1:1  venuename_tex year using "$data\venue_demo.dta"

/*Add in past team tenants for venues that do not currently host teams */
replace team_mlb="Atlanta Braves" if venuename_tex=="Turner Field"
replace team_mlb="Texas Rangers" if venuename_tex=="Globe Life Park"

replace team_nba="San Antonio Spurs" if venuename_tex=="Alamodome"
replace team_nba="Vancouver Grizzlies" if venuename_tex=="Rogers Arena"

replace team_nfl="St. Louis Rams" if venuename_tex=="Edwards Jones Dome"
replace team_nfl="Atlanta Falcons" if venuename_tex=="Georgia Dome"

replace team_nhl="New York Islanders" if venuename_tex=="Barclays Center"
replace team_nhl="Phoenix Coyotes" if venuename_tex=="PHX Arena"
replace team_nhl="Atlanta Thrashers" if venuename_tex=="State Farm Arena"

/* Estimate venue costs*/
g totalcost_acre2024 = totalcost2024/ acre_venue // Total cost per acre (real 2024 dollars)
label variable totalcost_acre2024 "Total Cost per Acre (2024)"

g teamcost = totalcost-publiccost
label variable teamcost "Team Cost"

g teamcost2024=  totalcost2024-publiccost2024
label variable teamcost2024 "Team Cost (2024)"

/*Correct for Turner Field Funding (private subsidy), see book for sources*/
replace teamcost = 35.5 if team_mlb=="Atlanta Braves" &year==1997
replace teamcost2024 = teamcost*1.95 if team_mlb=="Atlanta Braves" &year==1997 // Convert to real 2024 dollars using CPI defalor

g subsidizecost = totalcost-teamcost
label variable subsidizecost "Subsidized Cost"

g subsidizecost2024 = totalcost2024-teamcost2024
label variable subsidizecost2024 "Subsidized Cost (2024)"

g tmpct100 = (teamcost/totalcost)*100
label variable tmpct100 "Team Share (%)"

*g pubpct100 = (publiccost/totalcost)*100
g subsidizedpct = 100-tmpct100 // Use instead of pubpct100 because Turner Field's private (non-team) subsidy
label variable subsidizedpct "Subsidized Share (%)"

/* Estimate the opulence parameter using muliple regression estimation */ 
reg totalcost_acre2024  subsidizecost2024 ypc2024lag3thou poplag3mil mlb nfl nba, robust

/*
Linear regression                               Number of obs     =         90
                                                F(6, 83)          =       8.34
                                                Prob > F          =     0.0000
                                                R-squared         =     0.6748
                                                Root MSE          =     29.042

-----------------------------------------------------------------------------------
                  |               Robust
totalcost_ac~2024 | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
------------------+----------------------------------------------------------------
subsidizecost2024 |   .0546884   .0199321     2.74   0.007     .0150443    .0943325 <== Coefficient estimates opulence
  ypc2024lag3thou |   2.591953   .8072783     3.21   0.002     .9863091    4.197597
       poplag3mil |   2.287278   1.688324     1.35   0.179    -1.070731    5.645287
              mlb |  -33.90497   9.762167    -3.47   0.001    -53.32153   -14.48841
              nfl |  -29.75899   10.06138    -2.96   0.004    -49.77067   -9.747304
              nba |   25.93669   9.890087     2.62   0.010     6.265709    45.60768
            _cons |  -96.99899   39.40961    -2.46   0.016    -175.3831   -18.61486
-----------------------------------------------------------------------------------
*/

/*Extrapolating opulence in venues from subsidizecost2024 coefficient*/
g oppulence_acre2024 = 0.055*subsidizecost2024
label variable oppulence_acre2024 "Oppulence parameter"

g opulence2024 = acre_venue*oppulence_acre
label variable opulence2024 "Opulence Cost (2024)"

g opulencepct= (opulence2024/totalcost2024)*100
label variable opulencepct "Opulence Share (%)"

format totalcost totalcost2024 publiccost publiccost2024 subsidizecost subsidizecost2024 teamcost teamcost2024  opulence2024 opulencepct tmpct100 pubpct100 subsidizedpct %9.0fc

save "$outdat\opulence.dta", replace


/*Tex friendly string variables for table*/
g op2024st= string(opulence2024,"%9.0fc")
g teamc2024st= string(teamcost2024,"%9.0fc")
g subc2024st= string(subsidizecost2024,"%9.0fc")

g op2024dol = "\\$" +op2024st
g teamc2024dol = "\\$" +teamc2024st
g sub2024dol = "\\$" +subc2024st

g subsidizedpctst = string(subsidizedpct,"%9.0f")
g subsidizedpctstpct = subsidizedpctst+"\%"

g oppct100st = string(opulencepct,"%9.0f")
g oppct100sttpct = oppct100st+"\%"

g blank = ""
g league_venue = league
replace league_venue = "NHL & NBA" if arena

/*Table 7.1*/
/*Columns 3-8*/
tabstat totalcost2024 teamcost2024 subsidizecost2024  subsidizedpct opulence2024 opulencepct ,stats( median) by(league_venue) format
/*
Summary statistics: p50
Group variable: league_venue 

league_venue |  to~t2024  tea~2024  sub~2024  sub~dpct  opu~2024  opulen~t
-------------+------------------------------------------------------------
         MLB |       580       184       378        72       246        48
         NFL |       617       212       418        68       322        50
   NHL & NBA |       354       136       182        50        48        16
-------------+------------------------------------------------------------
       Total |       462       191       304        68       121        27
--------------------------------------------------------------------------
*/

/*Column 2 */
tabstat totalcost2024  ,stats(  count) by(league_venue) format
/*
Summary for variables: totalcost2024
Group variable: league_venue 

league_venue |         N
-------------+----------
         MLB |        24
         NFL |        24
   NHL & NBA |        48
-------------+----------
       Total |        96
------------------------
*/

/*CITED in text: Truist Park opulence example */
tabstat totalcost2024  publiccost2024 acre_venue oppulence_acre2024 opulence2024  opulencepct if venuename_tex=="Truist Park", format
/*
   Stats |  to~t2024  pub~2024  acre_v~e  opp~2024  opu~2024  opulen~t
---------+------------------------------------------------------------
    Mean |       860       384        12     21.12       253        29
----------------------------------------------------------------------
*/