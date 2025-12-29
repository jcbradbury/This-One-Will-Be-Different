/*
Convert current to real 2024 dollars (Renovations costs)

Consumer Price Index for All Urban Consumers (CPI-U)					
Original Data Value					
					
Series Id:	CUUR0000SA0				
Not Seasonally Adjusted					
Series Title:	All items in U.S. city average, all urban consumers, not seasonally adjusted				
Area:	U.S. city average				
Item:	All items				
Base Period:	1982-84=100				
Years:	1913 to 2024				

Input: cpi2024.xlsx : Used for generating converstions to construct real dollars conversion code using the annual average of Consumer Price Index for All Urban Consumers.
Output: Code for converting current to real 2024 dollars

Raw data location: https://data.bls.gov/timeseries/CUUR0000SA0 
Download names file as string of characters based on download date (e.g., SeriesReport-20251213112419_52ffa4.xlsx), so I changed name to cpi2024.xlsx

Canadian observations already converted to US dollars. 
Sources for conversions is Bank of Canada (for example): 
https://www.bankofcanada.ca/rates/exchange/annual-average-exchange-rates/
https://www.bankofcanada.ca/rates/exchange/legacy-noon-and-closing-rates/

**************************************************************
** See cpi2024_convert.do for instructions for building 2024 deflator code from raw data
**************************************************************
*/

/*Renovation costs*/
g renovation_amount2024=.
replace renovation_amount2024=renovation_amount*2.06 if lastrenovation ==1995
replace renovation_amount2024=renovation_amount*2 if lastrenovation ==1996
replace renovation_amount2024=renovation_amount*1.95 if lastrenovation ==1997
replace renovation_amount2024=renovation_amount*1.92 if lastrenovation ==1998
replace renovation_amount2024=renovation_amount*1.88 if lastrenovation ==1999
replace renovation_amount2024=renovation_amount*1.82 if lastrenovation ==2000
replace renovation_amount2024=renovation_amount*1.77 if lastrenovation ==2001
replace renovation_amount2024=renovation_amount*1.74 if lastrenovation ==2002
replace renovation_amount2024=renovation_amount*1.7 if lastrenovation ==2003
replace renovation_amount2024=renovation_amount*1.66 if lastrenovation ==2004
replace renovation_amount2024=renovation_amount*1.61 if lastrenovation ==2005
replace renovation_amount2024=renovation_amount*1.56 if lastrenovation ==2006
replace renovation_amount2024=renovation_amount*1.51 if lastrenovation ==2007
replace renovation_amount2024=renovation_amount*1.46 if lastrenovation ==2008
replace renovation_amount2024=renovation_amount*1.46 if lastrenovation ==2009
replace renovation_amount2024=renovation_amount*1.44 if lastrenovation ==2010
replace renovation_amount2024=renovation_amount*1.39 if lastrenovation ==2011
replace renovation_amount2024=renovation_amount*1.37 if lastrenovation ==2012
replace renovation_amount2024=renovation_amount*1.35 if lastrenovation ==2013
replace renovation_amount2024=renovation_amount*1.33 if lastrenovation ==2014
replace renovation_amount2024=renovation_amount*1.32 if lastrenovation ==2015
replace renovation_amount2024=renovation_amount*1.31 if lastrenovation ==2016
replace renovation_amount2024=renovation_amount*1.28 if lastrenovation ==2017
replace renovation_amount2024=renovation_amount*1.25 if lastrenovation ==2018
replace renovation_amount2024=renovation_amount*1.23 if lastrenovation ==2019
replace renovation_amount2024=renovation_amount*1.21 if lastrenovation ==2020
replace renovation_amount2024=renovation_amount*1.16 if lastrenovation ==2021
replace renovation_amount2024=renovation_amount*1.07 if lastrenovation ==2022
replace renovation_amount2024=renovation_amount*1.03 if lastrenovation ==2023
replace renovation_amount2024=renovation_amount*1 if lastrenovation ==2024
replace renovation_amount2024=renovation_amount*1 if lastrenovation >2024

format  renovation_amount2024 %9.0fc