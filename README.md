# This-One-Will-Be-Different
This repository contains the data and Stata code associated with 
***
* Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
* Author: J.C. Bradbury
* Publisher: Oxford University Press
* Year: 2026
***

# Overview
This is an overview of the repository.

 # Data

 ## Data Availability

 ## Datasets

|Dataset|Description|How Created|Sources|
|----|----|----|----|
|venuesdb_raw.dta|Historical databse of stadium construction costs (MLB, NFL, NBA, NHL)|Collected by author|See Appedix A, Bradbury (2026)|
|venuesdb_base.dta|Historical databse of stadium construction costs, processsed for analysis|venuesdb_build.do; cpi2024.do|venuesdb_raw.dta; BLS (2025)|
|leagues_revenue.dta|Average annual revenue for US major sports leagues|Collected by author|Forbes (various webpages)|
|venuesdb_mls.dta|Historical databse of stadium construction costs, processsed for analysis (includes MLS)|02-fig5.8.do|See Appedix A, Bradbury (2026)|
|mls_stadiums_only.dta|Historical databse of stadium construction costs (MLS)|Collected by author|See Appedix A, Bradbury (2026)|
|venue_forecast.dta|Extrapolation of future venue construction|Processed by author|venuesdb_base.dta|
|forecast_cost.dta|Estimate of future venue construction costs|Processed by author|venuesdb_base.dta|
|attend_lg.dta|Braves franchise attendance by year|Collected by author|Lahman (2024), Baseball-Reference|

# Replication files

**Instructions for Replicators**
1. Download repository folders to the desired location on your computer.
2. Open 00-setup.do, change [PATH] with you home directory, and run the do-file in Stata.
3. Run do-file associated with desired figure, table, or figure.
    - Running 01-master.do will run all do-files.

## Chapter 3

### Figures
| Figure | Do-file | Input | Output| Line #|
|----|----|----|----|----|
|3.1|02-fig3.1.do|venuesdb_base.dta||###|

## Chapter 5

### Figures
| Figure | Do-file | Input | Output| Line #|
|----|----|----|----|----|
|5.1|02-fig5.1.do|venuesdb_base.dta||###|
|5.2|02-fig5.2.do|venuesdb_base.dta|venue_forecast.dta|###|
|5.3|02-fig5.3_5.4_tab5.1.do|venuesdb_base.dta||###|
|5.4|02-fig5.3_5.4_tab5.1.do|venuesdb_base.dta||###|
|5.5|02-fig5.5.do|venue_forecast.dta; venuesdb_base.dta|forecast_cost.dta|###|
|5.6|02-fig5.6.do|venuesdb_base.dta||###|
|5.7|02-fig5.7_tab5.4.do|leagues_revenue.dta||###|
|5.8|02-fig5.8.do|mls_stadiums_only.dta; venuesdb_base.dta|mls_stadiums.dta; venuesdb_mls.dta|###|
|5.9|02-fig5.9.do|venuesdb_mls.dta||###|
|5.10 |02-fig5.10.do|venuesdb_mls.dta||###|

### Tables
| Table | Do-file | Input | Output| Line #|
|----|----|----|----|----|
|5.1|02-fig5.3_5.4_tab5.1.do|venuesdb_base.dta|Stata viewer|###|
|5.2|02-tab5.2_5.3.do|venuesdb_base.dta|Stata viewer|###|
|5.3|02-tab5.2_5.3.do|venuesdb_base.dta|Stata viewer|###|
|5.4|02-fig5.7_tab5.4.do|leagues_revenue.dta|Stata viewer|###|
|5.5|02-tab5.5.do|venuesdb_mls.dta|Stata viewer|###|

### Other Information
| Information| Line #|
|----|----|
|Venues to be replaced|27|


## Chapter 6
### Figures
### Tables

## Chapter 7
### Figures
### Tables

## Chapter 10

## Chapter 12

## Chapter 13

## Chapter 14

## Chapter 15

## Chapter 17

## Chapter 18

## Chapter 19



 