/* This file provides the code for aggregating cumulative MiLB ballpark costs.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

MiLB ballpark contruction costs discussed in Chapter 19 are presented in more detail in:
Bradbury, John Charles (2026) "The public cost of Minor League Baseball stadium subsidies," Economic Inquiry, In Press
(https://onlinelibrary.wiley.com/doi/10.1111/ecin.70055). 

Further details on the emprical analysis and tables are available in the replication package for the article located here: https://www.icpsr.umich.edu/sites/weai/view/studies/241242/versions/V3.1 .

Data Input (data\): 
milb_ballparkcosts.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 19.2
Tables (Stata viewer): 
Data (outdat\): milb_cumulative.dta
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
collapse (sum) publiccost2024 totalcost2024 sumpublicrenovationcost2024 sumtotalrenovationcost2024 , by(year)

so year
tsset year
tsfill

/*Observations per venue*/
g allpublic = publiccost2024 + sumpublicrenovationcost2024
g alltotal = totalcost2024 + sumtotalrenovationcost2024

tabstat allpublic alltotal, stats(sum)


/*Sum up public costs until that year. Convert to billions*/
g cumpc2024 = sum(publiccost2024) if year<=year
g cumpc2024bil = cumpc2024/1000

g cumpcreno2024 = sum(sumpublicrenovationcost2024) if year<=year
g cumpcreno2024bil = cumpcreno2024/1000


g cumallpub = sum(allpublic) if year<=year
g cumallpubbil = cumallpub/1000


format cumpc2024 cumpcreno2024 cumallpub cumallpubbil alltotal %9.0fc
format cumpc2024bil cumpcreno2024bil cumallpubbil %9.1fc

g cumpc2024bst= string(cumpc2024bil,"%9.1fc")
g cumpc2024bdol = "$"+cumpc2024bst
g cumpc2024bdolB = "$"+cumpc2024bst+" B"


g cumallpubbilbst= string(cumallpubbil,"%9.1fc")
g cumallpubbilbdol = "$"+cumallpubbilbs
g cumallpubdolB = cumallpubbilbdol+" B"


/*Sum up total costs until that year. Convert to billions*/
g cumtc2024 = sum(totalcost2024) if year<=year
g cumtc2024bil = cumtc2024/1000

g cumtcreno2024 = sum(sumtotalrenovationcost2024) if year<=year
g cumtcreno2024bil = cumtcreno2024/1000

g cumalltot = sum(alltotal) if year<=year
g cumalltotbil = cumalltot/1000

format cumtc2024 cumtcreno2024 cumalltot cumalltotbil alltotal %9.0fc
format cumtc2024bil cumtcreno2024bil cumalltotbil %9.1fc

g cumtc2024bst= string(cumtc2024bil,"%9.1fc")
g cumtc2024bdol = "$"+cumtc2024bst
g cumtc2024bdolB = "$"+cumtc2024bst+" B"

g cumalltotbilbst= string(cumalltotbil,"%9.1fc")
g cumalltotbilbdol = "$"+cumalltotbilbs
g cumalltotdolB = cumalltotbilbdol+" B"


/*Sum up total contruction costs pluse public renovations until that year. Convert to billions*/
g alltotal_plpubreno = totalcost2024 + sumpublicrenovationcost2024

g cum_plpubreno = sum(alltotal_plpubreno) if year<=year
g cum_plpubrenobil = cum_plpubreno/1000
g cumt_plbst= string(cum_plpubrenobil,"%9.1fc")
g cumt_plbdol = "$"+cumt_plbst
g cumt_plbdolB = cumt_plbdol+" B"

g cumallpubpct100 = (cumallpub/cumalltot)*100

format cumallpubpct100 %9.0fc

/*Private contribution to new construction*/
g cumpriv_nc = cumtc2024-cumpc2024
g cumpriv_ncbil =  cumpriv_nc/1000

g cumpriv_ncbst= string(cumpriv_ncbil,"%9.1fc")
g cumpriv_ncdol = "$"+cumpriv_ncbst
g cumpriv_ncdolB = cumpriv_ncdol+" B"

g cumpub_reno = cum_plpubreno-cumtc2024
g cumpub_renobil =  cumpub_reno/1000

g cumpub_renost= string(cumpub_renobil,"%9.1fc")
g cumpub_renodol = "$"+cumpub_renost
g cumpub_renodolB = cumpub_renodol+" B"

/* Private contibution to renovations*/
g cumpriv_reno = cumalltot-cum_plpubreno
g cumpriv_renobil =  cumpriv_reno/1000

g cumpriv_renost= string(cumpriv_renobil,"%9.1fc")
g cumpriv_renodol = "$"+cumpriv_renost
g cumpriv_renodolB = cumpriv_renodol+" B"

format cumpriv_ncbil cumpriv_renobil %9.1fc

so year

save "outdat\milb_cumulative.dta", replace


/* Cost summary*/
tabstat cumpc2024bil cumtc2024bil cumpcreno2024bil cumtcreno2024bil cumallpubbil cumalltotbil cumallpubpct100 if year==2025, format

/*Figure 19.2. */
mylabels 0(1)9, prefix($) myscale(@) local(dollab)
twoway area cumalltotbil year if year>1984, bcolor(gs14) ///
|| area cumallpubbil  year if year>1984, bcolor(gs10) ///
|| line cumallpubbil year if year>1984, lc(black) lp(vshortdash) lw(thin) ///
|| connected cumallpubbil year if year==2025, lc(black) lp(vshortdash) lw(thin)  ms(|) mc(black) ///
|| scatter cumallpubbil year if  year==2000 | year==2010| year==2020| year==2025, ms(|) mlabel(cumallpubdolB) mlabpos(11) mlabs(medium) mlabg(2) mc(black) mlabg(*.4)  ///
|| scatter cumallpubbil year if  year==1990, ms(|) mlabel(cumallpubdolB) mlabpos(4) mlabs(medium) mlabg(2) mc(black) mlabg(*.4)  ///
|| line cumalltotbil year if year>1984, lc(black) lp(dot) lw(thin) /// 
||scatter cumalltotbil year if year==1990| year==2000 | year==2010| year==2020| year==2025, ms(|) mlabel(cumalltotdolB) mlabpos(11) mlabs(medium) mlabg(2) mc(black) mlabg(*.4)  ///
|| connected cumalltotbil year if year==2025, lc(black) lp(dot) lw(thin)  ms(|) mc(black) ///
ylabel(`dollab', labsize(medium)) ///
xlabel(1985(5)2025, labsize(medium)) ///
ytitle("Cumulative Cost" "(in billions of 2024 dollars)", size(medium)) ///
xtitle("Year", size(medium)) ///
legend(order(4 "Cumulative Totals" 1 "Private Cost" 2 "Public Cost"   ) ring(0) pos(11) cols(1) size(medium) symysize(3) symxsize(12)) ///
name(cum_tot_pub_milb_share, replace) 
/*
graph export "$figs\Fig19.2.pdf", as(pdf) replace
graph export "$tif\Fig19.2.tif", as(tif) width(3000)  replace
*/

