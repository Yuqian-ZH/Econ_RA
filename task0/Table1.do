
**********************************************************************
*** TABLE 1
*** Impact of Trump Rallies on the Probability of a Black Stop
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_31_60 TRUMP_POST_61_90 TRUMP_POST_M90 TRUMP_PRE_M90, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30 TRUMP_POST_31_60 TRUMP_POST_61_90)  label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id i.county_fips#c.day_sq) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  label nonotes nocons noni
summ black

reghdfe black TRUMP_0 TRUMP_POST_1_30 if around30days==1 | trumpcounties==0, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  label nonotes nocons noni
summ black if around30days==1 | trumpcounties==0

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 if trumpcounties==1, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table1.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  label nonotes nocons noni
summ black if trumpcounties==1

