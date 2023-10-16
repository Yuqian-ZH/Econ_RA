
**********************************************************************
*** TABLE A3
*** Impact of Trump Rallies on the Probability of a Black Stop: 
*** Alternative Methods to Deal with Multiple Rallies
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

keep black dist* county_fips day_id

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

g TRUMP_POST_M30 = 0
forval ii = 1(1)9{ 
replace TRUMP_POST_M30 = 1 if (dist_event`ii' >=31 & dist_event`ii'!=.)
}
g TRUMP_PRE_M30 = 0
forval ii = 1(1)9{ 
replace TRUMP_PRE_M30 = 1 if (dist_event`ii' <=-31 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
		replace TRUMP_POST_1_30 = 1 if (dist_event1 >=1 & dist_event1<=30 & dist_event1!=.)
		replace TRUMP_POST_1_30 = 2 if (dist_event2 >=1 & dist_event2<=30 & dist_event2!=.)
		replace TRUMP_POST_1_30 = 3 if (dist_event3 >=1 & dist_event3<=30 & dist_event3!=.)
		replace TRUMP_POST_1_30 = 4 if (dist_event4 >=1 & dist_event4<=30 & dist_event4!=.)
		replace TRUMP_POST_1_30 = 5 if (dist_event5 >=1 & dist_event5<=30 & dist_event5!=.)
		replace TRUMP_POST_1_30 = 6 if (dist_event6 >=1 & dist_event6<=30 & dist_event6!=.)
		replace TRUMP_POST_1_30 = 7 if (dist_event7 >=1 & dist_event7<=30 & dist_event7!=.)
		replace TRUMP_POST_1_30 = 8 if (dist_event8 >=1 & dist_event8<=30 & dist_event8!=.)
		replace TRUMP_POST_1_30 = 9 if (dist_event9 >=1 & dist_event9<=30 & dist_event9!=.)

reghdfe black 1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_POST_M30 1.TRUMP_PRE_M30, a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA3.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) addtext("Sample","Sum Event") keep(1.TRUMP_POST_1_30) label nonotes nocons noni

**************************
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

keep black dist* county_fips day_id
g stopid = _n

g eventexists=0
forval ii=1/9 {
	replace  eventexists = eventexists+1 if dist_event`ii'!=.
}

expand eventexists, generate(copy)
sort stopid eventexists
by stopid eventexists: g number=cond(_N==1,0,_n)
replace number=1 if number==0 & dist_event1!=.
replace eventexists=1 if eventexists==0 
g invnrallies=1/(eventexists)
***
g dist_event=.
forval ii = 9(-1)1 {
	replace dist_event = dist_event`ii' if number==`ii' & dist_event==.
} 

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event == 0
}

g TRUMP_POST_1_30 = 0
replace TRUMP_POST_1_30 = 1 if (dist_event >=1 & dist_event<=30 & dist_event!=.)

g TRUMP_POST_M30 = 0
replace TRUMP_POST_M30 = 1 if (dist_event >=31 & dist_event!=.)

g TRUMP_PRE_M30 = 0
replace TRUMP_PRE_M30 = 1 if (dist_event <=-31 & dist_event!=.)

reghdfe black 1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_POST_M30 1.TRUMP_PRE_M30 [aweight=invnrallies], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA3.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) addtext("Sample","Event Panel") keep(1.TRUMP_POST_1_30) label nonotes nocons noni
