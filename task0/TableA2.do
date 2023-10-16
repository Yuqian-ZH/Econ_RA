
**********************************************************************
*** TABLE A2
*** Differences in the Probability of a Black Stop Before Treatment
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

forvalues j=5(5)30 {
g TRUMP_PRE`j' = 0
forval ii = 1/9 {
replace TRUMP_PRE`j' = 1 if (dist_event`ii' < 0 & dist_event`ii'>=-`j' & dist_event`ii'!=.)
}

bysort day_id: egen insample`j' = max(TRUMP_PRE`j')
label variable TRUMP_PRE`j' "Pre-Trump `j'"

}

keep black TRUMP* insample* day_id county_fips
compress

reghdfe black TRUMP_PRE5 if insample5==1 , a(i.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA2.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_PRE5) addtext("Window", "5 days") label nonotes nocons noni

forvalues j=10(5)30 {
reghdfe black TRUMP_PRE`j' if insample`j'==1 , a(i.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA2.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(TRUMP_PRE`j') addtext("Window", "`j' days") label nonotes nocons noni
}

forvalues j=5(5)30 {
	summ black if insample`j'==1
}
