/*
Convert current to real 2024 dollars 

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
** Instructions for building 2024 deflator code from raw data
**************************************************************

Step 1. Download CPI data from BLS website (https://data.bls.gov/timeseries/CUUR0000SA0): 
	Select years [From: 1913 To: 2024] and check box to include annual averages.
	Download table as Excel file. 
	Rename file: cpi2024.xlsx
	Place in directory 

Step 2. Estimate dollar adjustment to deflate current dollars into 2024 terms:
 
<Begin Stata code (select code between Begin and /End and run) >
	import excel using "$data\cpi2024.xlsx", clear cellrange(A12) firstrow case(lower)

	keep year annual
	
	list year annual if year==2024 /*Base year = 2024*/
	
	/* 
	     +----------------+
     | year    annual |
     |----------------|
112. | 2024   313.689 |
     +----------------+
	*/
		
	g deflator = 313.689/annual /*Generate CPI deflator for each year*/
	g deflator2 = round(deflator,.01) /*Round to two decimal places for simplicity*/
</End Stata code>


Step 3: Convert current dollar to real 2024 dollars using the rounded deflator2 estimated in Step 2. 
There are numerous ways you could apply the deflator, but because I deflate dollar values for each observation for differenent expenditures in multiple years, it was easiest to use Excel's CONCATENATE function, and replacing the variable name in the spreadsheet column. 

(Example spreadsheet: Replace variables  in columns E [totalcost, publiccost, etc.], F[totalcost2024, publiccost2024, etc.], and G [year, ryear, etc]. )
A		|B		|C			|D		|E				|F			|G			|H
Year	Annual	deflator2	g 		totalcost2024=	.						=CONCATENATE(D1,E1,F1)
1913	9.9		31.69		replace totalcost2024=	totalcost*	if year ==	=CONCATENATE(D2,E2,F2,C2,G2,A2)
1914	10.0	31.37		replace totalcost2024=	totalcost*	if year ==	=CONCATENATE(D2,E2,F2,C2,G2,A2)
[1915-2022 ...]																[concatenated output shown below as demonstration]	
2023	304.702	1.03		replace totalcost2024=	totalcost*	if year ==	replace totalcost2024=totalcost*1.03 if year ==2023
2024	313.689	1			replace totalcost2024=	totalcost*	if year ==	replace totalcost2024=totalcost*1 if year ==2024
[Accounting for pre- and post-CPI observations]								replace totalcost2024=totalcost*1 if year >2024
																			replace totalcost2024=totalcost*31.69 if year <1913

Cell output in Column H used to convert nominal to real dollars, pasted into do-file below.

*/

/* Total capital construction costs*/
g totalcost2024=.
replace totalcost2024=totalcost*31.69 if year ==1913
replace totalcost2024=totalcost*31.37 if year ==1914
replace totalcost2024=totalcost*31.06 if year ==1915
replace totalcost2024=totalcost*28.78 if year ==1916
replace totalcost2024=totalcost*24.51 if year ==1917
replace totalcost2024=totalcost*20.77 if year ==1918
replace totalcost2024=totalcost*18.13 if year ==1919
replace totalcost2024=totalcost*15.68 if year ==1920
replace totalcost2024=totalcost*17.52 if year ==1921
replace totalcost2024=totalcost*18.67 if year ==1922
replace totalcost2024=totalcost*18.34 if year ==1923
replace totalcost2024=totalcost*18.34 if year ==1924
replace totalcost2024=totalcost*17.93 if year ==1925
replace totalcost2024=totalcost*17.72 if year ==1926
replace totalcost2024=totalcost*18.03 if year ==1927
replace totalcost2024=totalcost*18.34 if year ==1928
replace totalcost2024=totalcost*18.34 if year ==1929
replace totalcost2024=totalcost*18.78 if year ==1930
replace totalcost2024=totalcost*20.64 if year ==1931
replace totalcost2024=totalcost*22.9 if year ==1932
replace totalcost2024=totalcost*24.13 if year ==1933
replace totalcost2024=totalcost*23.41 if year ==1934
replace totalcost2024=totalcost*22.9 if year ==1935
replace totalcost2024=totalcost*22.57 if year ==1936
replace totalcost2024=totalcost*21.78 if year ==1937
replace totalcost2024=totalcost*22.25 if year ==1938
replace totalcost2024=totalcost*22.57 if year ==1939
replace totalcost2024=totalcost*22.41 if year ==1940
replace totalcost2024=totalcost*21.34 if year ==1941
replace totalcost2024=totalcost*19.24 if year ==1942
replace totalcost2024=totalcost*18.13 if year ==1943
replace totalcost2024=totalcost*17.82 if year ==1944
replace totalcost2024=totalcost*17.43 if year ==1945
replace totalcost2024=totalcost*16.09 if year ==1946
replace totalcost2024=totalcost*14.07 if year ==1947
replace totalcost2024=totalcost*13.02 if year ==1948
replace totalcost2024=totalcost*13.18 if year ==1949
replace totalcost2024=totalcost*13.02 if year ==1950
replace totalcost2024=totalcost*12.06 if year ==1951
replace totalcost2024=totalcost*11.84 if year ==1952
replace totalcost2024=totalcost*11.75 if year ==1953
replace totalcost2024=totalcost*11.66 if year ==1954
replace totalcost2024=totalcost*11.7 if year ==1955
replace totalcost2024=totalcost*11.53 if year ==1956
replace totalcost2024=totalcost*11.16 if year ==1957
replace totalcost2024=totalcost*10.85 if year ==1958
replace totalcost2024=totalcost*10.78 if year ==1959
replace totalcost2024=totalcost*10.6 if year ==1960
replace totalcost2024=totalcost*10.49 if year ==1961
replace totalcost2024=totalcost*10.39 if year ==1962
replace totalcost2024=totalcost*10.25 if year ==1963
replace totalcost2024=totalcost*10.12 if year ==1964
replace totalcost2024=totalcost*9.96 if year ==1965
replace totalcost2024=totalcost*9.68 if year ==1966
replace totalcost2024=totalcost*9.39 if year ==1967
replace totalcost2024=totalcost*9.01 if year ==1968
replace totalcost2024=totalcost*8.55 if year ==1969
replace totalcost2024=totalcost*8.08 if year ==1970
replace totalcost2024=totalcost*7.75 if year ==1971
replace totalcost2024=totalcost*7.5 if year ==1972
replace totalcost2024=totalcost*7.07 if year ==1973
replace totalcost2024=totalcost*6.36 if year ==1974
replace totalcost2024=totalcost*5.83 if year ==1975
replace totalcost2024=totalcost*5.51 if year ==1976
replace totalcost2024=totalcost*5.18 if year ==1977
replace totalcost2024=totalcost*4.81 if year ==1978
replace totalcost2024=totalcost*4.32 if year ==1979
replace totalcost2024=totalcost*3.81 if year ==1980
replace totalcost2024=totalcost*3.45 if year ==1981
replace totalcost2024=totalcost*3.25 if year ==1982
replace totalcost2024=totalcost*3.15 if year ==1983
replace totalcost2024=totalcost*3.02 if year ==1984
replace totalcost2024=totalcost*2.92 if year ==1985
replace totalcost2024=totalcost*2.86 if year ==1986
replace totalcost2024=totalcost*2.76 if year ==1987
replace totalcost2024=totalcost*2.65 if year ==1988
replace totalcost2024=totalcost*2.53 if year ==1989
replace totalcost2024=totalcost*2.4 if year ==1990
replace totalcost2024=totalcost*2.3 if year ==1991
replace totalcost2024=totalcost*2.24 if year ==1992
replace totalcost2024=totalcost*2.17 if year ==1993
replace totalcost2024=totalcost*2.12 if year ==1994
replace totalcost2024=totalcost*2.06 if year ==1995
replace totalcost2024=totalcost*2 if year ==1996
replace totalcost2024=totalcost*1.95 if year ==1997
replace totalcost2024=totalcost*1.92 if year ==1998
replace totalcost2024=totalcost*1.88 if year ==1999
replace totalcost2024=totalcost*1.82 if year ==2000
replace totalcost2024=totalcost*1.77 if year ==2001
replace totalcost2024=totalcost*1.74 if year ==2002
replace totalcost2024=totalcost*1.7 if year ==2003
replace totalcost2024=totalcost*1.66 if year ==2004
replace totalcost2024=totalcost*1.61 if year ==2005
replace totalcost2024=totalcost*1.56 if year ==2006
replace totalcost2024=totalcost*1.51 if year ==2007
replace totalcost2024=totalcost*1.46 if year ==2008
replace totalcost2024=totalcost*1.46 if year ==2009
replace totalcost2024=totalcost*1.44 if year ==2010
replace totalcost2024=totalcost*1.39 if year ==2011
replace totalcost2024=totalcost*1.37 if year ==2012
replace totalcost2024=totalcost*1.35 if year ==2013
replace totalcost2024=totalcost*1.33 if year ==2014
replace totalcost2024=totalcost*1.32 if year ==2015
replace totalcost2024=totalcost*1.31 if year ==2016
replace totalcost2024=totalcost*1.28 if year ==2017
replace totalcost2024=totalcost*1.25 if year ==2018
replace totalcost2024=totalcost*1.23 if year ==2019
replace totalcost2024=totalcost*1.21 if year ==2020
replace totalcost2024=totalcost*1.16 if year ==2021
replace totalcost2024=totalcost*1.07 if year ==2022
replace totalcost2024=totalcost*1.03 if year ==2023
replace totalcost2024=totalcost*1 if year ==2024
replace totalcost2024=totalcost*1 if year >2024
replace totalcost2024=totalcost*31.69 if year <1913

/* Public capital construction costs*/
g publiccost2024=.
replace publiccost2024=publiccost*31.69 if year ==1913
replace publiccost2024=publiccost*31.37 if year ==1914
replace publiccost2024=publiccost*31.06 if year ==1915
replace publiccost2024=publiccost*28.78 if year ==1916
replace publiccost2024=publiccost*24.51 if year ==1917
replace publiccost2024=publiccost*20.77 if year ==1918
replace publiccost2024=publiccost*18.13 if year ==1919
replace publiccost2024=publiccost*15.68 if year ==1920
replace publiccost2024=publiccost*17.52 if year ==1921
replace publiccost2024=publiccost*18.67 if year ==1922
replace publiccost2024=publiccost*18.34 if year ==1923
replace publiccost2024=publiccost*18.34 if year ==1924
replace publiccost2024=publiccost*17.93 if year ==1925
replace publiccost2024=publiccost*17.72 if year ==1926
replace publiccost2024=publiccost*18.03 if year ==1927
replace publiccost2024=publiccost*18.34 if year ==1928
replace publiccost2024=publiccost*18.34 if year ==1929
replace publiccost2024=publiccost*18.78 if year ==1930
replace publiccost2024=publiccost*20.64 if year ==1931
replace publiccost2024=publiccost*22.9 if year ==1932
replace publiccost2024=publiccost*24.13 if year ==1933
replace publiccost2024=publiccost*23.41 if year ==1934
replace publiccost2024=publiccost*22.9 if year ==1935
replace publiccost2024=publiccost*22.57 if year ==1936
replace publiccost2024=publiccost*21.78 if year ==1937
replace publiccost2024=publiccost*22.25 if year ==1938
replace publiccost2024=publiccost*22.57 if year ==1939
replace publiccost2024=publiccost*22.41 if year ==1940
replace publiccost2024=publiccost*21.34 if year ==1941
replace publiccost2024=publiccost*19.24 if year ==1942
replace publiccost2024=publiccost*18.13 if year ==1943
replace publiccost2024=publiccost*17.82 if year ==1944
replace publiccost2024=publiccost*17.43 if year ==1945
replace publiccost2024=publiccost*16.09 if year ==1946
replace publiccost2024=publiccost*14.07 if year ==1947
replace publiccost2024=publiccost*13.02 if year ==1948
replace publiccost2024=publiccost*13.18 if year ==1949
replace publiccost2024=publiccost*13.02 if year ==1950
replace publiccost2024=publiccost*12.06 if year ==1951
replace publiccost2024=publiccost*11.84 if year ==1952
replace publiccost2024=publiccost*11.75 if year ==1953
replace publiccost2024=publiccost*11.66 if year ==1954
replace publiccost2024=publiccost*11.7 if year ==1955
replace publiccost2024=publiccost*11.53 if year ==1956
replace publiccost2024=publiccost*11.16 if year ==1957
replace publiccost2024=publiccost*10.85 if year ==1958
replace publiccost2024=publiccost*10.78 if year ==1959
replace publiccost2024=publiccost*10.6 if year ==1960
replace publiccost2024=publiccost*10.49 if year ==1961
replace publiccost2024=publiccost*10.39 if year ==1962
replace publiccost2024=publiccost*10.25 if year ==1963
replace publiccost2024=publiccost*10.12 if year ==1964
replace publiccost2024=publiccost*9.96 if year ==1965
replace publiccost2024=publiccost*9.68 if year ==1966
replace publiccost2024=publiccost*9.39 if year ==1967
replace publiccost2024=publiccost*9.01 if year ==1968
replace publiccost2024=publiccost*8.55 if year ==1969
replace publiccost2024=publiccost*8.08 if year ==1970
replace publiccost2024=publiccost*7.75 if year ==1971
replace publiccost2024=publiccost*7.5 if year ==1972
replace publiccost2024=publiccost*7.07 if year ==1973
replace publiccost2024=publiccost*6.36 if year ==1974
replace publiccost2024=publiccost*5.83 if year ==1975
replace publiccost2024=publiccost*5.51 if year ==1976
replace publiccost2024=publiccost*5.18 if year ==1977
replace publiccost2024=publiccost*4.81 if year ==1978
replace publiccost2024=publiccost*4.32 if year ==1979
replace publiccost2024=publiccost*3.81 if year ==1980
replace publiccost2024=publiccost*3.45 if year ==1981
replace publiccost2024=publiccost*3.25 if year ==1982
replace publiccost2024=publiccost*3.15 if year ==1983
replace publiccost2024=publiccost*3.02 if year ==1984
replace publiccost2024=publiccost*2.92 if year ==1985
replace publiccost2024=publiccost*2.86 if year ==1986
replace publiccost2024=publiccost*2.76 if year ==1987
replace publiccost2024=publiccost*2.65 if year ==1988
replace publiccost2024=publiccost*2.53 if year ==1989
replace publiccost2024=publiccost*2.4 if year ==1990
replace publiccost2024=publiccost*2.3 if year ==1991
replace publiccost2024=publiccost*2.24 if year ==1992
replace publiccost2024=publiccost*2.17 if year ==1993
replace publiccost2024=publiccost*2.12 if year ==1994
replace publiccost2024=publiccost*2.06 if year ==1995
replace publiccost2024=publiccost*2 if year ==1996
replace publiccost2024=publiccost*1.95 if year ==1997
replace publiccost2024=publiccost*1.92 if year ==1998
replace publiccost2024=publiccost*1.88 if year ==1999
replace publiccost2024=publiccost*1.82 if year ==2000
replace publiccost2024=publiccost*1.77 if year ==2001
replace publiccost2024=publiccost*1.74 if year ==2002
replace publiccost2024=publiccost*1.7 if year ==2003
replace publiccost2024=publiccost*1.66 if year ==2004
replace publiccost2024=publiccost*1.61 if year ==2005
replace publiccost2024=publiccost*1.56 if year ==2006
replace publiccost2024=publiccost*1.51 if year ==2007
replace publiccost2024=publiccost*1.46 if year ==2008
replace publiccost2024=publiccost*1.46 if year ==2009
replace publiccost2024=publiccost*1.44 if year ==2010
replace publiccost2024=publiccost*1.39 if year ==2011
replace publiccost2024=publiccost*1.37 if year ==2012
replace publiccost2024=publiccost*1.35 if year ==2013
replace publiccost2024=publiccost*1.33 if year ==2014
replace publiccost2024=publiccost*1.32 if year ==2015
replace publiccost2024=publiccost*1.31 if year ==2016
replace publiccost2024=publiccost*1.28 if year ==2017
replace publiccost2024=publiccost*1.25 if year ==2018
replace publiccost2024=publiccost*1.23 if year ==2019
replace publiccost2024=publiccost*1.21 if year ==2020
replace publiccost2024=publiccost*1.16 if year ==2021
replace publiccost2024=publiccost*1.07 if year ==2022
replace publiccost2024=publiccost*1.03 if year ==2023
replace publiccost2024=publiccost*1 if year ==2024
replace publiccost2024=publiccost*1 if year >2024
replace publiccost2024=publiccost*31.69 if year <1913

format totalcost2024 publiccost2024  %9.0fc