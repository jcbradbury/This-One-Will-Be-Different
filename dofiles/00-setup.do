/*
This file sets up Stata to replicate the figures and tables presented in:
**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 
This setup file installs the necessary ado-files and sets directory structure. 
*/

set more off

/*Set home directory  */
global path ="C:\Users\jcbra\GitHub\This-One-Will-Be-Different" // <== Replace [PATH] with home directory
global data="$path\data" // Pull data from here
global dofiles="$path\dofiles" // Pull do-files from here
global outdat = "$path\outdat" // Created data output to this folder
global figs="$path\figs" // Sets output folder for pdf figures
global tif="$path\tif" // Sets output folder for hi-res figures

cd "$path" // Set your working directory

/* Install required ado-files 
local packages ///
	blindschemes ///
    estout ///
    eventdd ///
	event_plot ///
    reghdfe ///
    boottest ///
    matsort ///
    listtab

foreach pkg of local packages {
    capture which `pkg'
    if _rc {
        display as text "Installing `pkg'..."
        ssc install `pkg', replace
    }
}

* Notes:
* - estout includes esttab, estpost, estadd
* - reghdfe installs ftools automatically

*/



