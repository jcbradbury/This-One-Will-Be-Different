# This-One-Will-Be-Different
This repository contains the data and Stata code associated with 
****************************************************************
* Title: This One Will Be Different: False Promises and Fiscal Realities of Publicly Funded Stadiums
* Author: J.C. Bradbury
* Publisher: Oxford University Press
* Year: 2026
***************************************************************

# Overview
This repository includes datasets and replication code files for generating the figures, tables, and other pertinent information reported in the book. This repository is designed to be simple and accessible, and thus its contents are organized into three folders:

- `data/` Includes all input and final output data, in order to allow replication and promote further research. The code in the do-files may generate intermediate data files that are used in constructing the tables and figures, which are saved only in the working directory.  All datasets are provided in .dta and .csv formats, and files of the same name except for their format suffix contain identical data. 

- `dofiles/` Includes all Stata do-files used for conducting the analyis. Do-files include substantial notation explaining what is being implemented, and in some cases the files include copies of the output. Non-Stata users may view these files with any text reader. 

- `figs/` Location for the ouput of figures. The code for output as figures is suppressed by default in the do-files, but it can be turned on by removing the supression characters (/* */) around the "graph export" command line. I provide figures as .pdf files for reference. Figures output using other schemes (I use plotplain) and output formats may look slightly different from the published figures.  


 # Data

 ## Data Availability

All data included in this repository were collected and organized by me (J.C. Bradbury) from public sources. 
I provide these data for replication purposes. To the best of my knowledge, this redistribution is permitted. 

Unless otherwise noted, the datasets in `data/` are licensed
under the Creative Commons Attribution 4.0 International License (CC-BY 4.0).

Original data sources are credited in accompanying documentation and
remain subject to their original terms.

 ## Datasets

|Dataset|Description|How Created|Sources|
|----|----|----|----|
|venuesdb_raw.dta|Historical databse of stadium construction costs (MLB, NFL, NBA, NHL)|Collected by author|See Appendix A, Bradbury (2026)|
|venuesdb_base.dta|Historical databse of stadium construction costs, processsed for analysis|venuesdb_build.do; cpi2024.do|venuesdb_raw.dta; BLS (2025)|
|leagues_revenue.dta|Average annual revenue for US major sports leagues|Collected by author|Forbes (various webpages)|
|venuesdb_mls.dta|Historical databse of stadium construction costs, processsed for analysis (includes MLS)|02-fig5.8.do|See Appendix A, Bradbury (2026)|
|mls_stadiums_only.dta|Historical databse of stadium construction costs (MLS)|Collected by author|See Appendix A, Bradbury (2026)|
|venue_forecast.dta|Extrapolation of future venue construction|02-fig5.2.do|venuesdb_base.dta|
|forecast_cost.dta|Estimate of future venue construction costs|02-fig5.5.do|venuesdb_base.dta|
|attend_lg.dta|Braves franchise attendance by year|Collected by author|Lahman (2024), Baseball-Reference|


# Replication files


## Instructions for Replicators
### Stata users
1. Download repository folders and their files to the desired location on your computer.
2. Open 00-setup.do, change [PATH] at the top of the file with your home directory where the folders are located, and run the do-file in Stata.
    - This will set the home directory structure for running all do-files
    - If you do not wish to run the setup file, all do-files contain suppressed [PATH] code that you can use for setting the home directory.  
3. Run do-files associated with desired figures, tables, or information.
    - Running 01-master.do will run all do-files. I recommend doing this first to verify the installation. 

### Non-Stata users
All data files provided in .csv format, which can be read by other data analysis software. Though I do not provide code for replcating the analysis in alternate formats, general analysis of the data can be conducted using spreadsheet programs (e.g., Excel, Google Sheets). More complex estimates (e.g., difference-in-differences, synthetic control method) may require more advanced software (e.g., R, Python); however, corresponding platform-specific packages are available for implementing the described routines. Do-files include notation (and in some cases saved results) that provides instructions that can be translated to other programs. 

**Code License:** The code in the do-files is governed by the MIT License, which permits users to use, copy, and modify the code for their own use, with the expectation that appropriate attribution will be provided. See the LICENSE file in this repository for explict terms.

## Dataset Construction

| Do-file|  Function| Output |
|----|----|----|
| 00-setup.do|  Sets up Stata to run do-files| |
| 01-venuesdb_build.do|Contructs primary base dataset of venue construction costs used in the analysis| venuesdb_base.dta|
| 01-cpi2024.do| Converts current dollar venue construction costs to real 2024 dollars| |
| 01-cpi2024_reno.do|  Converts current dollar venue renovations costs to real 2024 dollars| |


## Chapter 3

### Figures
| Figure | Do-file | Data Input | Data Output| Line #|
|----|----|----|----|----|
|3.1|02-fig3.1.do|venuesdb_base.dta||###|

## Chapter 5

### Figures
| Figure | Do-file | Data Input | Data Output| Line #|
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
| Table | Do-file | Data Input | Data Output| Line #|
|----|----|----|----|----|
|5.1|02-fig5.3_5.4_tab5.1.do|venuesdb_base.dta|Stata viewer|###|
|5.2|02-tab5.2_5.3.do|venuesdb_base.dta|Stata viewer|###|
|5.3|02-tab5.2_5.3.do|venuesdb_base.dta|Stata viewer|###|
|5.4|02-fig5.7_tab5.4.do|leagues_revenue.dta|Stata viewer|###|
|5.5|02-tab5.5.do|venuesdb_mls.dta|Stata viewer|###|

### Other Information
| Information| Do-file | Line #|
|----|----|----|
|Venues to be replaced| xyz.do |###|


## Chapter 6

### Figures
### Tables
### Other Information

The technical details of the analysis presented this chapter are described thoroughly in [Bradbury (2024)]( https://doi.org/10.1111/ecin.13231). The complete replication package associated with the academic article is avaiable [here](https://doi.org/10.1111/ecin.13231).

## Chapter 7
### Figures
### Tables

## Chapter 10

## Chapter 12

## Chapter 13

## Chapter 14
Much of the analysis described in this chapter is based on [Bradbury and Stephenson (2026)](https://doi.org/10.1177/13548166251405295). The hotel data are proprietary, and thus I do not provide the data or code for the figures in this chapter.

## Chapter 15

## Chapter 17

## Chapter 18

## Chapter 19


# References

 