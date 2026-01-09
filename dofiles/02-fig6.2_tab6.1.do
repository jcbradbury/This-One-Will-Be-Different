/* This file provides the code for estimating attendance novelty effects by league.

**********************************************************************
** Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
** Author: Bradbury, J.C.
** Publisher: Oxford University Press
** Year: 2026
********************************************************************** 
Much of the analysis discussed in Chapter 6 draws from the follow study:
Bradbury, John Charles (2024) "Revisiting the novelty effect from new stadiums: An event study approach", Economic Inquiry, 62(4): 1722-1747
(https://onlinelibrary.wiley.com/doi/10.1111/ecin.13231). 
Further details on the emprical analysis and tables are available in the replication package for the article located here: https://doi.org/10.3886/E200122V2 .

Data Input (data\): 
mlb_did.dta
nfl_did.dta
nba_did.dta
nhl_did.dta

Intermediate Output (working directory):

Final Output:
Figures(figs\): 6.2
Tables (Stata viewer): 6.1
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

/*Code produces coefficent estimates for Fig 6.2 and Table 6.1*/
/*MLB*/
use "$data\mlb_did.dta", clear

qui csdid attg wpct lagwpct population ypc2020 if !nyteam , ivar(franid) time(yearid) gvar(newstadium) notyet  method(reg) short
estat event,   window(0 11) estore(mlb_short_nony)
event_plot mlb_short_nony, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |   3587.777   2056.333     1.74   0.081    -442.5609    7618.115
         Tp0 |     9207.5    1621.23     5.68   0.000     6029.948    12385.05 <== Coefficient = MLB column 2
         Tp1 |   6920.303   1846.262     3.75   0.000     3301.697    10538.91
         Tp2 |   4649.515   1599.316     2.91   0.004     1514.913    7784.117
         Tp3 |   4549.809   2167.619     2.10   0.036     301.3531    8798.264
         Tp4 |   4567.696   2149.137     2.13   0.034     355.4641    8779.928
         Tp5 |   3300.764   2374.367     1.39   0.164    -1352.909    7954.437
         Tp6 |   2414.701   2965.915     0.81   0.416    -3398.386    8227.787
         Tp7 |   2500.077   2653.759     0.94   0.346    -2701.195    7701.349
         Tp8 |   2884.356   2823.712     1.02   0.307    -2650.019     8418.73
         Tp9 |   1865.022   3097.537     0.60   0.547    -4206.039    7936.083
        Tp10 |   636.2493   3356.849     0.19   0.850    -5943.053    7215.552
        Tp11 |  -442.6661   3072.925    -0.14   0.885    -6465.488    5580.156
------------------------------------------------------------------------------
*/
 
/*NFL*/
use "$data\nfl_did.dta", clear

qui csdid attg_combine wpct lagwpct population ypc2020 , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short 
estat event,  window(0  11) estore(nfl_short)
event_plot nfl_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |   4368.204   2618.999     1.67   0.095    -764.9407    9501.349
         Tp0 |   5628.207   2418.914     2.33   0.020     887.2229    10369.19 <== Coefficient = NFL column 2
         Tp1 |   4552.133   2208.487     2.06   0.039     223.5784    8880.688
         Tp2 |   4819.572   2332.061     2.07   0.039     248.8171    9390.327
         Tp3 |   5675.778   2649.174     2.14   0.032     483.4915    10868.06
         Tp4 |   5403.482   2990.769     1.81   0.071    -458.3176    11265.28
         Tp5 |    5364.08   3083.064     1.74   0.082    -678.6141    11406.77
         Tp6 |   5668.921   3163.109     1.79   0.073    -530.6586     11868.5
         Tp7 |   3199.559   3853.068     0.83   0.406    -4352.316    10751.43
         Tp8 |    3794.98   3063.153     1.24   0.215    -2208.689    9798.649
         Tp9 |   3337.407   2779.329     1.20   0.230    -2109.977    8784.791
        Tp10 |   3981.323   3480.251     1.14   0.253    -2839.842    10802.49
        Tp11 |    993.006   4179.454     0.24   0.812    -7198.573    9184.585
------------------------------------------------------------------------------
*/

/*NBA*/
use "$data\nba_did.dta",clear

qui csdid attg wpct lagwpct population , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short
estat event,  window(0  11) estore(nba_short)
event_plot nba_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |   1011.595   963.0516     1.05   0.294    -875.9518    2899.141
         Tp0 |   3485.618   643.1304     5.42   0.000     2225.106    4746.131 <== Coefficient = NBA column 2
         Tp1 |   3367.752   764.0073     4.41   0.000     1870.325    4865.179
         Tp2 |   3320.398   824.4284     4.03   0.000     1704.548    4936.248
         Tp3 |   2979.725    852.715     3.49   0.000     1308.435    4651.016
         Tp4 |   3429.392   918.5108     3.73   0.000     1629.144     5229.64
         Tp5 |   3557.291   1161.164     3.06   0.002      1281.45    5833.132
         Tp6 |    748.511    1503.17     0.50   0.619    -2197.648     3694.67
         Tp7 |   778.7612   1399.578     0.56   0.578    -1964.361    3521.883
         Tp8 |  -1961.417    2061.39    -0.95   0.341    -6001.666    2078.832
         Tp9 |  -1859.933     1952.6    -0.95   0.341    -5686.958    1967.092
        Tp10 |  -2351.547   1497.824    -1.57   0.116    -5287.229    584.1339
        Tp11 |  -3355.415   1882.336    -1.78   0.075    -7044.726     333.897
------------------------------------------------------------------------------
*/

/*NHL*/
use "$data\nhl_did.dta", clear

qui csdid attg wpct lagwpct  , ivar(franid) time(year) gvar(newstadium) notyet method(reg) short 
estat event,  window(0  11) estore(nhl_short)
event_plot nhl_short, ciplottype(rcap) stub_lag(Tp#) stub_lead(Tm#)
/*
------------------------------------------------------------------------------
             | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     Pre_avg |          0  (omitted)
    Post_avg |   1614.709   528.7483     3.05   0.002     578.3815    2651.037
         Tp0 |   2034.632   474.6876     4.29   0.000     1104.261    2965.002 <== Coefficient = NHL column 2
         Tp1 |   1721.224   476.8194     3.61   0.000     786.6755    2655.773
         Tp2 |     1854.3   669.2348     2.77   0.006     542.6241    3165.976
         Tp3 |   2228.771   692.1682     3.22   0.001     872.1465    3585.396
         Tp4 |   2151.208   575.2222     3.74   0.000     1023.794    3278.623
         Tp5 |   1449.163    765.916     1.89   0.058    -52.00512     2950.33
         Tp6 |   1355.915   695.6324     1.95   0.051    -7.499245     2719.33
         Tp7 |   1454.264   774.1698     1.88   0.060     -63.0814    2971.608
         Tp8 |   1057.995   774.3612     1.37   0.172    -459.7248    2575.715
         Tp9 |   745.8811    771.042     0.97   0.333    -765.3335    2257.096
        Tp10 |   2193.286   623.0307     3.52   0.000     972.1686    3414.404
        Tp11 |    1129.87   956.7036     1.18   0.238     -745.235    3004.974
------------------------------------------------------------------------------
*/

/*Fig 6.2*/
event_plot  mlb_short_nony nfl_short nba_short nhl_short,  plottype() ciplottype(none) stub_lag(Tp# Tp# Tp# Tp#) stub_lead(Tm# Tm# Tm# Tm# )  shift(0)  ///
noautolegend ///
graph_opt( legend( order(1 "MLB" 2 "NFL" 3 "NBA"  4 "NHL") ring(0) pos(1) symxsize(15) size(medium)) ///
  yline(0, lcolor(gs10) lp(dash))  /// xline(0, lp(dash))
  ylabel(-4000(2000)10000, angle(horizontal) format(%9.0fc) labsize(medium) ) xlabel( 0 "1" 1 "2" 2 "3" 3 "4" 4 "5" 5 "6" 6 "7" 7 "8" 8 "9" 9"10" 10 "11" 11 "12", labsize(medium) ) /// -6(1)-1
  ytitle("Average Change in Attendance per Game", size(medlarge)) xtitle("Year In New Venue", size(medlarge)) ///
  name(event_all, replace)) ///
 lag_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lag_opt2(msymbol(Dh) color(gs6) lp(longdash))   ///
 lag_opt3(msymbol(Th) color(gs8) lp(dash))   ///
 lag_opt4(msymbol(Sh) color(gs10) lp(vshortdash))  ///
  lead_opt1(msymbol(Oh) color(black) lp(solid) )   ///
 lead_opt2(msymbol(Dh) color(gs6) lp(longdash)) ///
 lead_opt3(msymbol(Th) color(gs8) lp(dash))   ///
 lead_opt4(msymbol(Sh) color(gs10) lp(vshortdash))  
/*
graph export "$figs\Fig6.2.pdf", as(pdf)  replace
graph export "$tif\Fig6.2.tif", as(tif) width(3000)  replace
*/
