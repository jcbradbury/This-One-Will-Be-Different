The table below provides information for all datasets included in the `data/` folder. These datasets were created for analysis provided throughout the book, particularly for constructing the figures and tables.  For simplicity, I list only the Stata file versions (.dta), but duplicate copies in comma-delimited (.csv) format---minus Stata-specific attributes (e.g, labels, number formatting)---are provided for non-Stata users. This way users have access to the processed data to replicate the information presented in the book. Non-Stata users should view the do-files (described in the replication section below) for notes on sources, data processing, and conducting the analysis.

The `CobbDocs/` subfolder includes documents relating to the Cobb-Braves stadium deal.

<!-- - See `sourcefiles/` for more descriptions of data sources, collection, and organization.  -->



### Full List (alphabetical)

|Dataset|Description|How Created|Used By|Sources|
|----|----|----|----|----|
|attend_atl.dta|Braves franchise attendance by year|02-fig6.1.do|02-fig6.1.do|Lahman (2024), Baseball-Reference|
|CID_vpa.dta|CID data processed for constructing Figs. 12.1 and 12.3|02-fig12.1_fig_12.3.do|02-fig12.1_fig_12.3.do|CIDgrossdigest.dta|
|CIDgrossdigest.dta|CID gross property value digest data (2010-2023)|Downloaded by author|02-fig12.1_fig_12.3.do|See Bradbury (2022b) [repository](https://github.com/jcbradbury/CIDproperty)|
|CIDproperty.dta|CID data for SCM analysis in Chap. 12|Compiled by author|02-fig12.4.do|See Bradbury (2022b) [repository](https://github.com/jcbradbury/CIDproperty)|
|CIDvpa2014_treat.dta|Cumberland CID property value post-SCM treatment effects|02-fig12.4.do|02-fig12.4.do|See Bradbury (2022b) [repository](https://github.com/jcbradbury/CIDproperty)|
|CPdata.dta|County gross property value digest data (1999-2019)|Compiled by author|02-fig15.1.do; 02-fig15.2.do|See Bradbury (2022a) [repository](https://github.com/jcbradbury/CobbProperty)|
|CPdata_2020_2023.dta|County gross property value digest data (2020-2023)|Compiled by author|02-fig15.1.do|See Bradbury (2022a) [repository](https://github.com/jcbradbury/CobbProperty)|
|CPdata_pct.dta|County gross property value digest data (1999-2019), percentage change|02-fig15.2.do|02-fig15.2.do|See Bradbury (2022a) [repository](https://github.com/jcbradbury/CobbProperty)|
|cobb_stsynth_noSTch_q.dta|Cobb sales tax post-SCM treatment effects|02-fig13.2_13.3_tab13.1.do|02-fig13.2_13.3_tab13.1.do|See Bradbury (2024) [repository](https://github.com/jcbradbury/CobbSalesTax)|
|compare_mlb.dta|MLB ballparks comparable to Truist Park|02-fig10.1.do|02-fig10.1.do|venuesdb_base.dta|
|countyST.dta|County sales tax data|Compiled by author|02-fig13.2_13.3_tab13.1.do|See Bradbury (2024) [repository](https://github.com/jcbradbury/CobbSalesTax)|
|countyST_q_noSTch.dta|County sales tax data processed for SCM analysis in Chap. 13|02-fig13.2_13.3_tab13.1.do|02-fig13.2_13.3_tab13.1.do|See Bradbury (2024) [repository](https://github.com/jcbradbury/CobbSalesTax)|
|countyST_q_noSTch_means.dta|County sales tax collection means|02-fig13.2_13.3_tab13.1.do|02-fig13.2_13.3_tab13.1.do|See Bradbury (2024) [repository](https://github.com/jcbradbury/CobbSalesTax)|
|cpi2024.xlsx|Consumer Price Index (CPI) used for real dollar conversions|Downloaded and processed by author|Many do-files|BLS (2025)|
|cumulative_cost.dta|Cumulative major-league venue construction costs over time|02-fig5.5.do|02-fig5.5.do|venue_forecast.dta; venuesdb_base.dta|
|forecast_cost.dta|Estimate of future venue construction costs|02-fig5.2.do|02-fig5.2.do; 02-fig5.5.do|venuesdb_base.dta|
|leagues_revenue.dta|Average annual team revenue for US major sports leagues|Compiled by author|02-fig5.7_tab5.4.do|Forbes (various webpages)|
|lifespan_collapse.dta|Distribution of venue hosting lifespans by decade|02-fig5.1.do|02-fig5.1.do|venuesdb_base.dta|
|milb_ballparkcosts.dta|MiLB (minor league) ballpark costs|Collected by author|02-fig19.2.do; 02-fig19.3do|Author|
|milb_cumulative.dta|Cumulative MiLB ballpark construction costs over time|02-fig19.2.do; 02-fig19.3do|02-fig19.2.do; 02-fig19.3do|milb_ballparkcosts.dta|
|milb_median.dta|Distribution of MiLB ballpark construction costs over time|02-fig19.2.do; 02-fig19.3do|02-fig19.2.do; 02-fig19.3do|milb_ballparkcosts.dta|
|mlb_did.dta|MLB data used for DiD estimates in Chap. 6|See Bradbury (2024)|02-fig6.2_tab6.1|Bradbury (2024)|
|mls_lifespans.dta|Hosting status of MLS stadiums|02-fig5.10.do|02-fig5.10.do|venuesdb_all.dta|
|mls_median_collapse.dta|MLS stadium construction costs by year|02-fig5.9.do|02-fig5.9.do|venuesdb_all.dta|
|mls_stadiums_base.dta|Historical databse of stadium construction costs (MLS)|01-venuesdb_all_build.do|01-venuesdb_all_build.do|mls_stadiums_raw.dta; BLS (2025)|
|mls_stadiums_raw.dta|Historical databse of stadium construction costs (MLS)|Compiled by author|01-venuesdb_all_build.do|See Appendix A, Bradbury (2026)|
|msa_vens_pvt.dta|Data on privately financed stadiums |02-tab17.1.do|02-tab17.1.do|msarank2023.dta; venuesdb_all.dta|
|msarank2023.dta|Major-league teams by metro area population rank|02-tab18.1.do|02-tab18.1.do|population_msa.dta|
|nba_did.dta|NBA data used for DiD estimates in Chap. 6|See Bradbury (2024)|02-fig6.2_tab6.1|Bradbury (2024)|
|nfl_did.dta|NHL data used for DiD estimates in Chap. 6|See Bradbury (2024)|02-fig6.2_tab6.1|Bradbury (2024)|
|nhl_did.dta|NHL data used for DiD estimates in Chap. 6|See Bradbury (2024)|02-fig6.2_tab6.1|Bradbury (2024)|
|opulence.dta|Estimated opulence of venues|02-tab7.1.do|02-tab7.1.do|venuesdb_base.dta; venue_acres.dta; venue_demo.dta|
|payroll2025.dta|Atlanta Braves annual payroll rank|02-fig6.5.do|02-fig6.5.do|Baseball-Reference|
|population_msa.dta|Population of US/Canada metro areas|Downloaded and processed by author|02-tab18.1.do|US Census/Statistics Canada|
|propvpa2014_meanch.dta|County gross property value digest data (2003-2023)|Compiled by author|02-fig15.1.do; 02-fig15.2.do|See Bradbury (2022a) [repository](https://github.com/jcbradbury/CobbProperty)|
|propvpa2014_pct100.dta|Cobb property value post-SCM treatment effects|02-fig15.2.do|02-fig15.2.do|See Bradbury (2022a) [repository](https://github.com/jcbradbury/CobbProperty)|
|propheter_lease_data.dta|Venues lease data |Compiled by Geoffrey Propheter (Attribution required as condition of use)|02-fig6.4.do|[Propheter, Geoffrey (2022)](https://doi.org/10.1007/978-3-031-18790-2) |
|Teams.csv|Annual data for MLB teams|Downloaded by author|02-fig6.1.do|Lahman (2025)|
|ven_cost_current.dta|Cumulative construction costs of current major-league venues|02-tab5.5.do|02-tab5.5.do|venuesdb_all.dta|
|ven_lifespans.dta|Hosting status of current major-league venues|02-fig5.6.do|02-fig5.6.do|venuesdb_base.dta|
|ven_median_collapse.dta|Medium public funding devoted to major-league venues, by decade|02-fig5.3_5.4_tab5.1.do|02-fig5.3_5.4_tab5.1.do|venuesdb_base.dta|
|venue_acres.dta|Acreage of venues|Compiled by author|02-tab7.1.do|Propheter (2017); Collected by author|
|venue_count.dta|New major-league venue openings by year (1909-2020)|02-fig3.1.do|02-fig3.1.do|venuesdb_base.dta|
|venue_count_mls.dta|||||
|venue_demo.dta|Demographics of venue metropolitan areas|Compiled by author||BEA (2024)|
|venue_forecast.dta|Extrapolation of future venue construction|02-fig5.2.do||venuesdb_base.dta|
|venuecosts2020.dta|||||
|venuesdb_all.dta|Historical database of venue construction costs (MLB, NFL, NBA, NHL with MLS)|01-venuesdb_all_ build.do||venuesdb_base.dta; mls_stadiums_base.dta|
|venuesdb_base.dta|Historical database of venue construction costs (MLB, NFL, NBA, NHL)|01-venuesdb_build.do||venuesdb_raw.dta; BLS (2025)|
|venuesdb_mls.dta|||||
|venuesdb_raw.dta|Historical database of venue construction costs (MLB, NFL, NBA, NHL)|Collected by author||See Appendix A, Bradbury (2026)|



