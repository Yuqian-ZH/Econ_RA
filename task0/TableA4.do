
**********************************************************************
*** TABLE A4
*** Impact of Trump Rallies on the Relative Probability that a Stopped 
*** Driver is of a Race or Ethnicity Relative to Another: Split Samples
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if black==100 | white==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if black==100 | hispanic==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if black==100 | api==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe hispanic TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if hispanic==100 | white==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe hispanic TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if hispanic==100 | api==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe api TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if api==100 | white==100, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

