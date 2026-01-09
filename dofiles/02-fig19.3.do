/* This file provides the code for measuring the distribution MiLB ballpark costs.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

Much of the analysis discussed in Chapter 19 draws from the follow study:
Bradbury, John Charles (2026) "The public cost of Minor League Baseball stadium subsidies," Economic Inquiry, In Press
(LINK). 
Further details on the emprical analysis and tables are available in the replication package for the article located here: LINK .

Data Input (data\): 
milb_ballparkcosts.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 19.3
Tables (Stata viewer): 
Data (outdat\): milb_median.dta
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

use "$data\milb_ballparkcosts.dta", clear

so decade
by decade: egen medpc2024_all = median(publiccost2024)
by decade: egen low25pc2024_all = pctile(publiccost2024), p(25)
by decade: egen hi75pc2024_all= pctile(publiccost2024), p(75)

by decade: egen medtc2024_all = median(totalcost2024)
by decade: egen low25tc2024_all = pctile(totalcost2024), p(25)
by decade: egen hi75tc2024_all= pctile(totalcost2024), p(75)

format medpc2024* low25pc2024* hi75pc2024*  medtc2024* low25tc* hi75tc2024* %9.0f

collapse (median) medpc2024_all low25pc2024_all hi75pc2024_all  medtc2024_all low25tc2024_all hi75tc2024_all, by(decade)

save "$outdat\milb_median.dta", replace
/* Data output into the data\ folder
save "$data\milb_median.dta", replace
export delimited "$data\milb_median.csv", replace
*/

g medpc2024_allst= string(medpc2024_all,"%9.0fc")
g medpc2024_alldol = "$" +medpc2024_allst

g medtc2024_allst= string(medtc2024_all,"%9.0fc")
g medtc2024_alldol = "$" +medtc2024_allst

so decade

/* Fig 19.3 */
mylabels 0(10)120, prefix($) myscale(@) local(dollab)
twoway rbar low25tc2024_all hi75tc2024_all decade if decade>1980,  bc(gs11) barw(.75) ///
|| rcap low25pc2024_all hi75pc2024_all decade if decade>1980, lc(black) lw(thin) msize(2) ///
|| rcap medtc2024_all medtc2024_all decade if decade>1980, lc(white) msize(4) ///
|| connect medpc2024_all decade if decade>1980, lc(black) lp(vshortdash) ms(Oh) mc(black) lw(thin) mlabel(medpc2024_alldol) mlabpos(4) mlabgap(*2) /// 
|| connect medtc2024_all decade if decade>1980, lc(black) lp(dash) ms(Sh) mc(black) lw(thin) mlabel(medtc2024_alldol) mlabpos(1) mlabgap(*3) /// 
ylabel(`dollab', labsize(medlarge)) ///
xlabel(, labsize(medium)) ///
ytitle("Public Cost (in millions of 2024 dollars)", size(medlarge))  ///
xtitle("Decade", size(medlarge)) ///
plotregion(margin(l=3 r=3)) ///
legend(order(- "{bf:Total Cost}" 1 "Middle 50%" 5  "Median" - - "{bf:Public Cost}"  2 "Middle 50%" 4 "Median ") cols(1) size(medium) symxsize(11) ring(0) pos(11)) name(all_tcpc, replace)