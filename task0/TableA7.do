
**********************************************************************
*** TABLE A7
*** Social Spillover Effects of Trump Rallies
**********************************************************************

use "/home/yz6572/task2/data/network_spillovers.dta", clear

reghdfe black 1.TRUMP_* s_network_effect_TRUMP_POST_1_30, a(i.county_fips i.day_id  i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA7.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30 s_network_effect_TRUMP_POST_1_30) label nonotes nocons noni

