
**********************************************************************
*** TABLE A10
*** Role of Estimated Officer Bias in the Effect of Trump Rallies on 
*** the Probability of a Black Stop: Robustness to Agency-Day Fixed 
*** Effects
**********************************************************************

use "/home/yz6572/task2/data/officerbias.dta", clear

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off1 bias_int1 if officer_id_hash!=""  , a(i.county_id i.day_id  i.county_id#c.day_id i.county_id#i.state_pd#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA10.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30 bias_off1 bias_int1) label nonotes nocons noni addtext("Officer FE", "NO", "Bias Measure", "Method 1")

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off1 bias_int1 if officer_id_hash!=""  , a(i.officer_id i.county_id i.day_id  i.county_id#c.day_id i.county_id#i.state_pd#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA10.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30 bias_off1 bias_int1) label nonotes nocons noni addtext("Officer FE", "YES", "Bias Measure", "Method 1")

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off2 bias_int2 if officer_id_hash!=""  , a(i.county_id i.day_id i.county_id#c.day_id i.county_id#i.state_pd#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA10.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30 bias_off2 bias_int2) label nonotes nocons noni  addtext("Officer FE", "NO", "Bias Measure", "Method 2")

reghdfe black TRUMP_0 TRUMP_POST_1_30 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off2 bias_int2 if officer_id_hash!=""  , a(i.officer_id i.county_id i.day_id  i.county_id#c.day_id i.county_id#i.state_pd#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA10.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TRUMP_POST_1_30 bias_off2 bias_int2) label nonotes nocons noni  addtext("Officer FE", "YES", "Bias Measure", "Method 1")
