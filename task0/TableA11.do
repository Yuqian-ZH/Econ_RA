
**********************************************************************
*** TABLE A11
*** Role of Estimated Officer Bias in the Effect of Trump Rallies on 
*** the Probability of a Black Stop: Additional Robustness
**********************************************************************

use "/home/yz6572/task2/data/officerbias.dta", clear

drop if officer_id==.

forvalues j=1(1)2{ 
centile bias_off`j' if bias_off`j'!=., c(33)
local bias_p33 = `r(c_1)'

centile bias_off`j' if bias_off`j'!=., c(67)
local bias_p67 = `r(c_1)'

g bias_off`j'_33 = (bias_off`j'<`bias_p33')
g bias_off`j'_33_67 = (bias_off`j'>=`bias_p33' & bias_off`j'<`bias_p67')
g bias_off`j'_u67 = (bias_off`j'<`bias_p67')
g bias_off`j'_67 = (bias_off`j'>=`bias_p67')

g TP_1_30Xbias_off`j'_33 = TRUMP_POST_1_30*bias_off`j'_33
g TP_1_30Xbias_off`j'_33_67 = TRUMP_POST_1_30*bias_off`j'_33_67
g TP_1_30Xbias_off`j'_u67 = TRUMP_POST_1_30*bias_off`j'_u67
g TP_1_30Xbias_off`j'_67 = TRUMP_POST_1_30*bias_off`j'_67
}

reghdfe black TRUMP_0 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off1 TP_1_30Xbias_off1_33 TP_1_30Xbias_off1_33_67 TP_1_30Xbias_off1_67, a(i.county_id i.day_id  i.county_id#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA11.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TP_1_30Xbias_off1_33 TP_1_30Xbias_off1_33_67 TP_1_30Xbias_off1_67) label nonotes nocons noni 

reghdfe black TRUMP_0 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off1 TP_1_30Xbias_off1_u67 TP_1_30Xbias_off1_67 , a(i.county_id i.day_id  i.county_id#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA11.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TP_1_30Xbias_off1_u67 TP_1_30Xbias_off1_67) label nonotes nocons noni 

reghdfe black TRUMP_0 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off2 TP_1_30Xbias_off2_33 TP_1_30Xbias_off2_33_67 TP_1_30Xbias_off2_67, a(i.county_id i.day_id  i.county_id#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA11.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TP_1_30Xbias_off2_33 TP_1_30Xbias_off2_33_67 TP_1_30Xbias_off2_67) label nonotes nocons noni 

reghdfe black TRUMP_0 TRUMP_POST_M30 TRUMP_PRE_M30 bias_off2 TP_1_30Xbias_off2_u67 TP_1_30Xbias_off2_67 , a(i.county_id i.day_id  i.county_id#c.day_id) cluster(i.county_id i.day_id) 
outreg2 using "/home/yz6572/task2/results/TableA11.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) keep(TP_1_30Xbias_off2_u67 TP_1_30Xbias_off2_67) label nonotes nocons noni 

