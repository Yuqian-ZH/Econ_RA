
**********************************************************************
*** TABLE 4
*** Police Behavior 
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

reghdfe black 1.TRUMP_POST_1_30 1.TRUMP_POST_1_30#0.state_pd TRUMP_0 TRUMP_POST_M30 TRUMP_PRE_M30 , a(i.state_pd i.county_fips i.day_id  i.county_fips#c.day_id) cluster(county_fips day_id )
outreg2 using "/home/yz6572/task2/results/Table4.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30 1.TRUMP_POST_1_30#0.state_pd)  addtext("County FE", "YES", "Day FE", "YES", "CountyXDay", "YES", "Additional FE" , "Agency") label nonotes nocons noni
lincom 1.TRUMP_POST_1_30 + 1.TRUMP_POST_1_30#0.state_pd

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id i.hour) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  addtext("County FE", "YES", "Day FE", "YES", "CountyXDay", "YES", "Additional FE" , "Hour of Stop") label nonotes nocons noni

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id i.county_fips#i.state_pd) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  addtext("County FE", "YES", "Day FE", "YES", "CountyXDay", "YES", "Additional FE" , "Agency") label nonotes nocons noni

egen officer_id=group(officer_id_hash)
reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id i.officer_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table4.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30)  addtext("County FE", "YES", "Day FE", "YES", "CountyXDay", "YES", "Additional FE" , "Officer") label nonotes nocons

summ black if state_pd!=.
summ black if hour!=.
summ black if officer_id_hash!=""
