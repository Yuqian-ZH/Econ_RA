
**********************************************************************
*** TABLE A5
*** Impact of Trump Rallies on the Number of Stops by Race or Ethnicity
**********************************************************************

use "/home/yz6572/task2/data/county_day_data.dta", clear

reghdfe ihsblack 1.TRUMP_0 1.TRUMP_PRE* 1.TRUMP_POST* ihsstops [aweight=n_stops], a(i.county_fips i.day_id i.county_fips##c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA5.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30) label nonotes nocons noni

reghdfe ihshispanic 1.TRUMP_0 1.TRUMP_PRE* 1.TRUMP_POST* ihsstops [aweight=n_stops], a(i.county_fips i.day_id i.county_fips##c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA5.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30) label nonotes nocons noni

reghdfe ihswhite 1.TRUMP_0 1.TRUMP_PRE* 1.TRUMP_POST* ihsstops [aweight=n_stops], a(i.county_fips i.day_id i.county_fips##c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA5.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30) label nonotes nocons noni

reghdfe ihsapi 1.TRUMP_0 1.TRUMP_PRE* 1.TRUMP_POST* ihsstops [aweight=n_stops], a(i.county_fips i.day_id i.county_fips##c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA5.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.TRUMP_POST_1_30) label nonotes nocons noni

summ ihsblack_pc ihshispanic_pc ihswhite_pc ihsapi_pc [aweight=n_stops]

