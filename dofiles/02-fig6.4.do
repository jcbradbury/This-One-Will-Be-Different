/* This file provides the code for displaying the distribution of venue lease teams.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 

************************
**	IMPORTANT	**
Geoffrey Propheter kindly provided data from his book for me to conduct for the analyis below.
As a condition of use of these data, you must cite his book as the source.
Propheter, Geoffrey (2022) Major League Sports and the Property Tax. Series: Sports Economics, Management and Policy. Springer Nature.
(https://link.springer.com/book/10.1007/978-3-031-18790-2 )
************************

Data Input (data\): 
propheter_lease_data.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\):
Tables (Stata viewer): 
Data (outdat\):
Other: 
CITED in text: Distribution of lease term length
*/

*************************
**** SETUP **************
*************************
/*Run code below first if have not set up home directory

global path ="[PATH]" // <== Replace [PATH] with home directory
cd "$path" // Set your working directory

do "00-setup.do"
*/

use "$data\propheter_lease_data.dta" , clear
/* Data output into the data\ folder
export delimited "$data\.csv", replace
*/

/*Fig 6.4*/
histogram minimumleaselengthyears if facilitytype!="soccer" ,  width(1) freq discrete ///
xlabel(0(10)50 55,  labsize(medium) gmax) ///
ylabel(0(5)45,labsize(medium)) ///
xtitle(Lease Term, size(medlarge)) ytitle(Venues, size(medlarge)) ///
plotregion(margin(l=0))
/*
graph export "$figs\Fig6.4.pdf", as(pdf)  replace
graph export "$figs\Fig6.4.tif", as(tif) width(3000)  replace
*/

/*CITED in text: Distribution of lease term lengths*/
tab minimumleaselengthyears if facilitytype!="soccer",
/*
    minimum |
      lease |
     length |
      years |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |          1        1.10        1.10
          3 |          1        1.10        2.20
         12 |          1        1.10        3.30
         13 |          1        1.10        4.40
         15 |          3        3.30        7.69
         20 |          6        6.59       14.29
         22 |          2        2.20       16.48 ___
         25 |          9        9.89       26.37 
         26 |          1        1.10       27.47
         29 |          2        2.20       29.67
         30 |         42       46.15       75.82 Sum Freq 25-35 = 66
         31 |          1        1.10       76.92
         32 |          1        1.10       78.02
         33 |          1        1.10       79.12
         35 |          9        9.89       89.01 ___
         37 |          2        2.20       91.21
         40 |          3        3.30       94.51
         48 |          1        1.10       95.60
         49 |          1        1.10       96.70
         50 |          2        2.20       98.90
         55 |          1        1.10      100.00
------------+-----------------------------------
      Total |         91      100.00

66/91 = 73%
*/

