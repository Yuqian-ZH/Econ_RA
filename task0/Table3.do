
**********************************************************************
*** TABLE 3
*** Driver Behavior 
**********************************************************************

*** Panel A
use "/home/yz6572/task2/data/fars_data.dta"

reghdfe ihsinc  1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_PRE_M30 1.TRUMP_POST_M30  [aweight=incidents], a(i.county_fips i.date) cluster(county_fips date)
outreg2 using "/home/yz6572/task2/results/Table3A.txt", replace keep(1.TRUMP_POST_1_30) dec(3) nocons

foreach y in ihsfatal ihsfatalviolation ihsblack ihsnonblack ihswhite ihshispani ihsmexican {
	reghdfe `y' 1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_PRE_M30 1.TRUMP_POST_M30  [aweight=incidents], a(i.county_fips i.date) cluster(county_fips date)
outreg2 using "/home/yz6572/task2/results/Table3A.txt", append keep(1.TRUMP_POST_1_30) dec(3) nocons

}

*** Panel B
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

reghdfe blackcollision TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table3B.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni

foreach var of varlist nonblackcollision whitecollision hispaniccollision blackradar nonblackradar whiteradar hispanicradar {
reghdfe `var' TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/Table3B.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30) label nonotes nocons noni
}

summ blackcollision
foreach var of varlist nonblackcollision whitecollision hispaniccollision blackradar nonblackradar whiteradar hispanicradar {
summ `var'
}
