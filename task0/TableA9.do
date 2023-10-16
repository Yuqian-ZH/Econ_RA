
**********************************************************************
*** TABLE A9
*** Impact of Trump Rallies on BLM Protests
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

merge m:1 county_fips day_id using "/home/yz6572/task2/data/blm.dta"
drop if _merge==2
replace blm_protest = 0 if blm_protest==.
replace blm_protest = 100*blm_protest

reghdfe blm_protest TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id c.day_id#i.county_fips) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA9.txt", replace keep(1.TRUMP_POST_1_30) dec(3) nocons
g esample = (e(sample)==1)
summ blm_protest if esample==1 
