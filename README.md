# This-One-Will-Be-Different
This repository contains the data and Stata code associated with 
****************************************************************
* Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
* Author: J.C. Bradbury
* Publisher: Oxford University Press
* Year: 2026
***************************************************************

# Overview
This repository includes datasets and replication code files for generating the figures, tables, and other pertinent information reported in the book. The contents are organized into three folders:

- data\ Includes all input and final output data. The code in the do-files may generate intermediate output files that are used in constructing the tables and figures, which are saved only in the working directory.  All datasets are provided in .dta and .csv formats, and files of the same name except for their format suffix contain identical data. 

- dofiles\ Includes all Stata do-files used for conducting the analyis. Do-files include substantial notation explaining what is being implemented, and sometimes provides copies of the output. Non-Stata users may view these files with any text reader. 

- figs\ Location for the ouput of figures. The code for output as figures is suppressed by default in the do-files, but it can be turned on by removing the supression characters (/* */) around the "graph export" command line. I provide figures as .pdf files for reference. Figures output using other schemes (I use plotplain) and output formats may look slightly different from the published figures.  

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

## Instructions for Replicators
### Stata users
1. Download repository folders and their files to the desired location on your computer.
2. Open 00-setup.do, change [PATH] at with you home directory, and run the do-file in Stata.
    - This will set the home directory structure for running all do-files
3. Run do-file associated with desired figure, table, or figure.
    - Running 01-master.do will run all do-files.

### Non-Stata users
All data files provided in .csv format, which can be read by other data analysis software (e.g., R, Python, Excel, Google Sheets). Though I do not provide code for replcating the analysis in alternate formats, much of the analysis is simple enough that the reader can implement basic analyis routines available in these programs. More complex estimates (e.g., difference-in-differences, synthetic control method) may require more advanced software; however, corresponding platform-specific packages are available for implementing the described routines. Do-files include notation (and in some cases saved results) that provides instructions that can be translated to other programs. 

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



 