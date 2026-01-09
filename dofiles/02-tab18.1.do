/* This file provides the code for producing a table of privately financed venues.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
population_msa.dta

US MSA population from US Census: Metropolitan and Micropolitan Statistical Areas Population Totals: 2020-2023
Main website: https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-metro-and-micro-statistical-areas.html

Series: Annual Estimates of the Resident Population for Metropolitan Statistical Areas in the United States and Puerto Rico: April 1, 2020 to July 1, 2023
Series archive: https://www2.census.gov/programs-surveys/popest/tables/2020-2023/metro/totals/
File: cbsa-met-est2023-pop.xlsx
Release date: March 2024

Canada CMA population from Statistics Canada: Population estimates, July 1, by census metropolitan area and census agglomeration, 2021 boundaries
Current website (minor updates): https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1710014801
Version when analysis done (Release date: 2024-05-22): https://web.archive.org/web/20240522211916/https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?
pid=1710014801

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 18.1
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

use "$data\population_msa.dta", clear

egen rankmsa2023 = rank(-pop2023)
g popmil2023 = pop2023/1000000
format popmil2023 %9.2fc
egen usrankmsa2023 = rank(-pop2023) if canada==0
gsort - pop2023

g mlbst = string(mlb,"%9.0fc")
g nbast = string(nba,"%9.0fc")
g nflst = string(nfl,"%9.0fc")
g nhlst = string(nhl,"%9.0fc")
g mlsst = string(mls,"%9.0fc")
g totalst = string(total,"%9.0fc")

/*\hphantom adds invisible text for centering table numbers.*/

replace nflst="\hphantom{*}0$^c$" if cfl==1 

replace mlbst= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"
replace nbast= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"
replace nflst= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"
replace nhlst= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"
replace mlsst= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"
replace totalst= "\hphantom{*}0*" if msa=="Riverside-San Bernardino-Ontario, CA"

replace mlbst= "\hphantom{**}1$^{-\dagger}$" if msa=="San Francisco-Oakland-Fremont, CA"
replace nflst= "\hphantom{***}0$^{--}$*" if msa=="San Francisco-Oakland-Fremont, CA"
replace nhlst= "\hphantom{*}0*" if msa=="San Francisco-Oakland-Fremont, CA"
replace mlsst= "\hphantom{*}0*" if msa=="San Francisco-Oakland-Fremont, CA"
replace totalst= "\hphantom{*}3*" if msa=="San Francisco-Oakland-Fremont, CA"

replace nbast= "\hphantom{*}0*" if msa=="Baltimore-Columbia-Towson, MD"
replace nhlst= "\hphantom{*}0*" if msa=="Baltimore-Columbia-Towson, MD"
replace mlsst= "\hphantom{*}0*" if msa=="Baltimore-Columbia-Towson, MD"
replace totalst= "\hphantom{*}2*" if msa=="Baltimore-Columbia-Towson, MD"

replace mlbst= "\hphantom{*}0*" if msa=="San Jose-Sunnyvale-Santa Clara, CA"
replace nbast= "\hphantom{*}0*" if msa=="San Jose-Sunnyvale-Santa Clara, CA"
replace totalst= "\hphantom{*}3*" if msa=="San Jose-Sunnyvale-Santa Clara, CA"

replace mlbst= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"
replace nbast= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"
replace nflst= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"
replace nhlst= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"
replace mlsst= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"
replace totalst= "\hphantom{*}0*" if msa=="Providence-Warwick, RI-MA"


replace mlbst= "\hphantom{*}0$^{\dagger}$" if msa=="Sacramento-Roseville-Folsom, CA"
replace mlbst= "\hphantom{*}0$^{\dagger}$" if msa=="Las Vegas-Henderson-North Las Vegas, NV"

	
/* Lost teams since 1990 */
/*Net Losers*/
replace nhlst= "\hphantom{*}0$^-$" if msa=="Atlanta-Sandy Springs-Roswell, GA" /*Winnepeg*/
replace nhlst= "\hphantom{**}0$^{+-}$" if msa=="Phoenix-Mesa-Chandler, AZ" /*Utah*/
replace mlbst= "\hphantom{*}0$^-$" if msa=="Montréal (CMA), Quebec" /*Washington*/
replace nbast= "\hphantom{*}0$^-$" if msa=="Seattle-Tacoma-Bellevue, WA" /*OKC*/
replace mlsst= "\hphantom{*}0$^-$" if msa=="Tampa-St. Petersburg-Clearwater, FL" /*CONTRACTED*/
replace nflst= "\hphantom{*}0$^-$" if msa=="San Diego-Chula Vista-Carlsbad, CA" /*LA*/
replace nbast= "\hphantom{**}0$^{x-}$" if msa=="Vancouver (CMA), British Columbia" /*Memphis*/
replace nflst= "\hphantom{*}0$^-$" if msa=="St. Louis, MO-IL" /*LA*/
replace nhlst= "\hphantom{*}0$^-$" if msa=="Hartford-West Hartford-East Hartford, CT"  /*Raleigh*/
replace nhlst= "\hphantom{*}0$^-$" if msa=="Quebec (CMA), Quebec"  /*Colorado*/

/* Relocated teams gained since 1990 */
replace mlsst= "\hphantom{*}1$^+$" if msa=="Houston-Pasadena-The Woodlands, TX" /*San Jose*/
replace mlbst= "\hphantom{*}1$^+$" if msa=="Washington-Arlington-Alexandria, DC-VA-MD-WV" /*Montreal*/
replace nflst= "\hphantom{*}1$^+$" if msa=="Baltimore-Columbia-Towson, MD" /*Cleveland*/
replace nflst= "\hphantom{*}1$^+$" if msa=="Nashville-Davidson--Murfreesboro--Franklin, TN" /*Houston*/
replace nflst= "\hphantom{*}1$^+$" if msa=="San Jose-Sunnyvale-Santa Clara, CA" /*San Francisco*/
replace nflst= "\hphantom{*}1$^+$" if msa=="Las Vegas-Henderson-North Las Vegas, NV" /*Oakland*/
replace nflst= "\hphantom{****}2$^{--++}$" if msa=="Los Angeles-Long Beach-Anaheim, CA" /*SD and Oakland*/
replace nbast= "\hphantom{*}1$^+$" if msa=="Oklahoma City, OK" /*Seattle*/
replace nbast= "\hphantom{*}1$^+$" if msa=="Memphis, TN-MS-AR" /*Vancouver*/
replace nbast= "\hphantom{*}1$^+$" if msa=="New Orleans-Metairie, LA" /*Charlotte*/
replace nhlst= "\hphantom{**}1$^{-+}$" if msa=="Winnipeg (CMA), Manitoba" /*Atlanta*/
replace nhlst= "\hphantom{*}1$^+$" if msa=="Salt Lake City-Murray, UT" /*Arizona*/
replace nhlst= "\hphantom{*}1$^+$" if msa=="Dallas-Fort Worth-Arlington, TX" /*Minnesota*/
replace nhlst= "\hphantom{*}1$^+$" if msa=="Raleigh-Cary, NC" /*Hartford*/

/* Expansion teams added since 1990 */
replace mlsst= "\hphantom{*}2$^x$" if msa=="New York-Newark-Jersey City, NY-NJ"
replace mlsst= "\hphantom{***}2$^{x-x}$" if msa=="Los Angeles-Long Beach-Anaheim, CA"
replace nflst= "\hphantom{**}1$^{-x}$" if msa=="Houston-Pasadena-The Woodlands, TX"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Toronto (CMA), Ontario"
replace nbast= "\hphantom{*}1$^{x}$" if msa=="Toronto (CMA), Ontario"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Philadelphia-Camden-Wilmington, PA-NJ-DE-MD"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Atlanta-Sandy Springs-Roswell, GA"
replace mlsst= "\hphantom{**}1$^{-x}$" if msa=="Miami-Fort Lauderdale-West Palm Beach, FL"
replace mlbst= "\hphantom{*}1$^x$" if msa=="Miami-Fort Lauderdale-West Palm Beach, FL"
replace mlbst= "\hphantom{*}1$^x$" if msa=="Phoenix-Mesa-Chandler, AZ"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Montréal (CMA), Quebec"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Seattle-Tacoma-Bellevue, WA"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Seattle-Tacoma-Bellevue, WA"
replace nbast= "\hphantom{*}1$^x$" if msa=="Minneapolis-St. Paul-Bloomington, MN-WI"
replace nhlst= "\hphantom{**}1$^{-x}$" if msa=="Minneapolis-St. Paul-Bloomington, MN-WI"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Minneapolis-St. Paul-Bloomington, MN-WI"
replace mlbst= "\hphantom{*}1$^x$" if msa=="Tampa-St. Petersburg-Clearwater, FL"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Tampa-St. Petersburg-Clearwater, FL"
replace mlsst= "\hphantom{*}1$^x$" if msa=="San Diego-Chula Vista-Carlsbad, CA"
replace mlbst= "\hphantom{*}1$^x$" if msa=="Denver-Aurora-Centennial, CO"
replace nhlst= "\hphantom{*}1$^+$" if msa=="Denver-Aurora-Centennial, CO"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Vancouver (CMA), British Columbia"
replace mlsst= "\hphantom{*}1$^x$" if msa=="St. Louis, MO-IL"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Orlando-Kissimmee-Sanford, FL"
replace nflst= "\hphantom{*}1$^x$" if msa=="Charlotte-Concord-Gastonia, NC-SC"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Charlotte-Concord-Gastonia, NC-SC"
replace nbast= "\hphantom{**}1$^{-x}$" if msa=="Charlotte-Concord-Gastonia, NC-SC"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Las Vegas-Henderson-North Las Vegas, NV"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Columbus, OH"
replace nflst= "\hphantom{**}1$^{-x}$" if msa=="Cleveland, OH"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Portland-Vancouver-Hillsboro, OR-WA"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Austin-Round Rock-San Marcos, TX"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Cincinnati, OH-KY-IN"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Nashville-Davidson--Murfreesboro--Franklin, TN"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Nashville-Davidson--Murfreesboro--Franklin, TN"
replace nhlst= "\hphantom{*}1$^{x}$" if msa=="San Jose-Sunnyvale-Santa Clara, CA"
replace mlsst= "\hphantom{**}1$^{-x}$" if msa=="San Jose-Sunnyvale-Santa Clara, CA"
replace nflst= "\hphantom{*}1$^x$" if msa=="Jacksonville, FL"
replace nhlst= "\hphantom{*}1$^x$" if msa=="Ottawa - Gatineau (CMA), Ontario/Quebec"
replace mlsst= "\hphantom{*}1$^x$" if msa=="Salt Lake City-Murray, UT"

replace city = "Regina" if shortmsa=="Regina (CMA), SK"
replace city = "Hamilton" if shortmsa=="Hamilton (CMA), ON"

save "$outdat\msarank2023.dta", replace

/* Data output into the data\ folder
save "$data\msarank2023.dta", replace
export delimited "$data\msarank2023.csv", replace
*/

/*Table 18.1*/
*Stata viewer friendly
list rankmsa2023 shortmsa  popmil2023  mlb nba nfl nhl mls total if rankmsa<71| total>0 |lost==1|cfl==1,

*Output for Tex-friendly table
listtab rankmsa2023 shortmsa blank popmil2023 blank mlbst nbast nflst nhlst mlsst totalst if rankmsa<61| total>0 |lost==1|cfl==1, type rstyle(tabular)
