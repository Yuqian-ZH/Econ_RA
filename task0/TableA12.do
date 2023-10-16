
**********************************************************************
*** TABLE A12
*** Role of Local Characteristics in the Eff ect of Trump Rallies on 
*** the Probability of a Black Stop Controlling for a Linear Time
*** Trend Interacted with the Share of Black People in the County
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

mat treat = J(11,4,1)

keep black county_fips day_id TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 racial_resent_a racial_resent_b any_slaves_1860 alt_cottonsui ihsbl_lynch ihsbl_exec dem_p rep medianincome coll d_tradeusch_pw d_tradeotch_pw_lag countyblack
drop if black==.

summ  racial_resent_a
g  racial_resent_asd = ( racial_resent_a - r(mean))/r(sd)
g interaction = TRUMP_POST_1_30 * racial_resent_asd
reghdfe black 1.TRUMP_* interaction c.day_id#c.racial_resent_a c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", replace dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","Racial Resentment A","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

summ  racial_resent_b 
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)
g  interaction = TRUMP_POST_1_30 * racial_resent_bsd
reghdfe black 1.TRUMP_* interaction c.day_id#c.racial_resent_b c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","Racial Resentment B","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

g  interaction = TRUMP_POST_1_30 * any_slaves_1860
reghdfe black 1.TRUMP_* interaction c.day_id#1.any_slaves_1860 c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","Any Slaves","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su alt_cottonsui  , detail
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)
g  interaction = TRUMP_POST_1_30 * alt_cottonsuisd
reghdfe black 1.TRUMP_* interaction c.day_id#c.alt_cottonsui c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","Cotton","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su ihsbl_lynch  , detail
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)
g  interaction = TRUMP_POST_1_30 * ihsbl_lynchsd
reghdfe black 1.TRUMP_* interaction c.day_id#c.ihsbl_lynch c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","IHS Slaves","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su ihsbl_exec  , detail
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)
g  interaction = TRUMP_POST_1_30 * ihsbl_execsd
reghdfe black 1.TRUMP_* interaction c.day_id#c.ihsbl_exec c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","IHS Executations","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

**** PANEL B
su dem_p  , detail
g  dem_psd = ( dem_p - r(mean))/r(sd)
local sd = r(sd)
g interaction = TRUMP_POST_1_30 * dem_psd 
reghdfe black 1.TRUMP_* interaction c.day_id#c.dem_p c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","DEM Share","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

g interaction = TRUMP_POST_1_30 * rep
reghdfe black 1.TRUMP_* interaction  c.day_id#c.rep c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","County Sheriff","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su medianincome , detail
g  incomesd = ( medianincome - r(mean))/r(sd)
g interaction = TRUMP_POST_1_30 * incomesd
reghdfe black 1.TRUMP_* interaction c.day_id#c.medianincome c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","Income","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su coll , detail
g  collsd = ( coll - r(mean))/r(sd)
g interaction = TRUMP_POST_1_30 * collsd
reghdfe black 1.TRUMP_* interaction c.day_id#c.coll c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","College","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su d_tradeusch_pw , detail
g  d_tradeusch_pwsd = ( d_tradeusch_pw - r(mean))/r(sd)
g interaction = TRUMP_POST_1_30 * d_tradeusch_pwsd
reghdfe black 1.TRUMP_* interaction  c.day_id#c.d_tradeusch_pw c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","China Shock","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction

su d_tradeotch_pw_lag , detail
g  dtrdothchsd = ( d_tradeotch_pw_lag - r(mean))/r(sd)
g interaction = TRUMP_POST_1_30 * dtrdothchsd
reghdfe black 1.TRUMP_* interaction  c.day_id#c.dtrdothch c.day_id#c.countyblack, a(i.county_fips i.day_id) cluster(county_fips)
outreg2 using "/home/yz6572/task2/results/TableA12.txt", append dec(3) keep(1.TRUMP_POST_1_30 interaction) addtext("Interaction","China Shock IV","County FE", "YES", "Daily FE", "YES") label nonotes nocons noni
drop interaction
