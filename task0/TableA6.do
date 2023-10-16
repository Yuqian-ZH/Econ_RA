
**********************************************************************
*** TABLE A6
*** The Differential Effect of Trump and Other Political Rallies on 
*** the Probability of a Black Stop
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

merge n:1 county_fips using "/home/yz6572/task2/data/allcandidates_rallies.dta"

keep if year==2015 | year==2016 | year==2017
drop dist_event*

forval ii = 1/4 {
	g dist_event`ii' = day_id - event_day_Cruz_`ii'
} 
g CRUZ_0 = 0
forval ii = 1/4 {
replace CRUZ_0 = 1 if dist_event`ii' == 0 & dist_event`ii'!=.
}
*
g CRUZ_POST_1_30 = 0
forval ii = 1/4 {
replace CRUZ_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}
g CRUZ_POST_M30 = 0
forval ii = 1/4 {
replace CRUZ_POST_M30 = 1 if (dist_event`ii' >30 & dist_event`ii'!=.)
}
g CRUZ_PRE_M30 = 0
forval ii = 1/4 {
replace CRUZ_PRE_M30 = 1 if (dist_event`ii' <-30 & dist_event`ii'!=.)
}
drop dist_event* 

forval ii = 1/10 {
	g dist_event`ii' = day_id - event_day_Clinton_`ii'
} 
g CLINTON_0 = 0
forval ii = 1/10 {
replace CLINTON_0 = 1 if dist_event`ii' == 0 & dist_event`ii'!=.
}
*
g CLINTON_POST_1_30 = 0
forval ii = 1/10 {
replace CLINTON_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}
g CLINTON_POST_M30 = 0
forval ii = 1/10 {
replace CLINTON_POST_M30 = 1 if (dist_event`ii' >30 & dist_event`ii'!=.)
}
g CLINTON_PRE_M30 = 0
forval ii = 1/10 {
replace CLINTON_PRE_M30 = 1 if (dist_event`ii' <-30 & dist_event`ii'!=.)
}
drop dist_event*  
drop black
g black =  (subject_race==2) * 100

egen t = group(day_id)

g anyrally_0 = (TRUMP_0==1 | CRUZ_0==1 | CLINTON_0==1)  
g anyrally_1_30 = (TRUMP_POST_1_30==1 | CRUZ_POST_1_30==1 | CLINTON_POST_1_30==1)  
g anyrally_POST_M30 = (TRUMP_POST_M30==1 | CRUZ_POST_M30==1 | CLINTON_POST_M30==1)  
g anyrally_PRE_M30 = (TRUMP_PRE_M30==1 | CRUZ_PRE_M30==1 | CLINTON_PRE_M30==1)  

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 anyrally_0 anyrally_1_30 anyrally_POST_M30 anyrally_PRE_M30, absorb(county_fips day_id county_fips#c.day_id) cluster(county_fips day_id)
outreg2 using "/home/yz6572/task2/results/TableA6.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(anyrally_1_30 TRUMP_POST_1_30) label nonotes nocons noni

*******************************************************************************************************************
use   "/home/yz6572/task2/data/stops_2007_09_001.dta", clear 

forval ii = 1/3 {
	g dist_event`ii' = day_id - event_day_Obama_`ii'
} 

g OBAMA_0 = 0
forval ii = 1/3 {
replace OBAMA_0 = 1 if dist_event`ii' == 0 & dist_event`ii'!=.
}
*
g OBAMA_POST_1_30 = 0
forval ii = 1/3 {
replace OBAMA_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}
g OBAMA_POST_M30 = 0
forval ii = 1/3 {
replace OBAMA_POST_M30 = 1 if (dist_event`ii' >30 & dist_event`ii'!=.)
}
g OBAMA_PRE_M30 = 0
forval ii = 1/3 {
replace OBAMA_PRE_M30 = 1 if (dist_event`ii' <-30& dist_event`ii'!=.)
}
g black = 100*(subject_race == 2)

g sep = "-"
egen state_county = concat(state sep county_name)
drop sep
egen county_id = group(state_county)

reghdfe black 1.OBAMA_*  , a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id )
outreg2 using "/home/yz6572/task2/results/TableA6.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10) symbol(***, **, *) bfmt(fc) keep(1.OBAMA_POST_1_30) label nonotes nocons noni
