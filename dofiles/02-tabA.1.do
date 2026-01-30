/* This file provides the code for constructing the table of venue construction cost in the appendix.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Data Input (data\): 
venuesdb_mls.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): Table A.1
Data (outdat\):
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

g yearst = string(year,"%9.0f")
replace yearst = "TBD" if year==.

g tc2024st= string(totalcost2024,"%9.0fc")
replace tc2024st= string(totalcost2024,"%9.2fc") if totalcost2024<1 & totalcost2024>0

g tcst= string(totalcost,"%9.0fc")
replace tcst= string(totalcost,"%9.2fc") if totalcost<1 & totalcost>0

g pc2024st= string(publiccost2024,"%9.0fc")
replace pc2024st= string(publiccost2024,"%9.2fc") if publiccost2024<1 & publiccost2024>0 

g pcst= string(publiccost,"%9.0fc")
replace pcst= string(publiccost,"%9.2fc") if publiccost<1 & publiccost>0

g tc2024dol = "\\$" +tc2024st
g pc2024dol = "\\$" +pc2024st
g tcdol = "\\$" +tcst
g pcdol = "\\$" +pcst
g pubpct100st = string(pubpct100,"%9.0f")
g pubpct100stpct = pubpct100st+"\%"
replace tcdol="" if totalcost ==.
replace pcdol ="" if publiccost ==.
replace tc2024dol ="" if totalcost2024 ==.
replace pc2024dol ="" if publiccost2024 ==.
replace pubpct100stpct ="" if pubpct100 ==.

g venuename_tex_bold = venuename_tex
replace  venuename_tex_bold = "\textbf{"+venuename_tex+"}" if current
replace  venuename_tex_bold = "\emph{"+venuename_tex+"}" if year>2024
replace venuename_tex_bold = "Turner Field\$^\ddagger\$" if venuename_tex=="Turner Field"
replace venuename_tex_bold = "\emph{New Athletics Stadium$^\S$}" if venuename_tex=="New Athletics Stadium"
*replace venuename_tex_bold = "\emph{New Browns Stadium$^\P$}" if venuename_tex=="New Browns Stadium"
*replace venuename_tex_bold = "\emph{New Fire Stadium$^\|$}" if venuename_tex=="New Fire Stadium"

replace tcdol="[\\$1,150]" if venuename_tex=="Climate Pledge Arena*"
replace tc2024dol="[\\$1,334]" if venuename_tex=="Climate Pledge Arena*"
replace pcdol="[\\$0]" if venuename_tex=="Climate Pledge Arena*"
replace pc2024dol="[\\$0]" if venuename_tex=="Climate Pledge Arena*"
replace pubpct100stpct="[0\%]" if venuename_tex=="Climate Pledge Arena*"

replace tcdol="[\\$750]" if venuename_tex=="New Fire Stadium"

g lastyearst  = string(lastyear,"%9.0f")
replace lastyearst="" if lastyear==.
replace lastyearst ="[2030]" if venuename_tex=="Empower Field at Mile High" /*Announced tentative replacement date*/


replace tc2024dol="" if year>2024
replace pc2024dol="" if year>2024

g lifespan2025 = lastyear-year+1
replace lifespan2025 = lastyear-year+1
replace lifespan2025 = 2026-year if lifespan2025==.
replace lifespan2025 = 2026-year if lastyear>2025 &lastyear!=. /*Keeps age for future closures in 2025 terms*/
replace lifespan2025 = . if lifespan2025<1

so year venuename_tex

/*Table A.1*/
list venuename_tex_bold teams_tex yearst lastyearst lifespan2025 totalcost publiccost totalcost2024 publiccost2024 pubpct100

listtab venuename_tex_bold teams_tex yearst lastyearst lifespan2025 tcdol pcdol tc2024dol pc2024dol pubpct100stpct , type rstyle(tabular)

/*Optional Code for exporting table as csv
export delimited venuename teams yearst lastyearst lifespan2025 tcst pcst tc2024st pc2024st pubpct100st using TableA1.csv, replace
*/