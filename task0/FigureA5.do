
**********************************************************************
*** FIGURE A5
*** Impact of Trump Rallies on the Probability of a Black Stop: Event-study
*** Results Corrected using Sun and Abraham (2021) Methodology
**********************************************************************
qui: do "/home/yz6572/task2/do/preparing_abrahamsun_es.do"

use  "/home/yz6572/task2/results/SA_TRUMP_POST_1_15.dta", clear
g x = 15

append using "/home/yz6572/task2/results/SA_TRUMP_POST_16_30.dta"
replace x = 30 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_31_45.dta"
replace x = 45 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_46_60.dta"
replace x = 60 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_61_75.dta"
replace x = 75 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_76_90.dta"
replace x = 90 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_91_105.dta"
replace x = 105 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_0.dta"
replace x = 0 if _n == _N

set obs `=_N+1'
replace x = -15 if _n == _N
replace beta = 0 if _n == _N
replace CI_lb = . if _n == _N
replace CI_ub = . if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_30_16.dta"
replace x = -30 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_45_31.dta"
replace x = -45 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_60_46.dta"
replace x = -60 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_75_61.dta"
replace x = -75 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_90_76.dta"
replace x = -90 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_105_91.dta"
replace x = -105 if _n == _N

sort x
replace CI_lb = CI_lb * 100 
replace CI_ub = CI_ub * 100
replace beta = beta * 100

twoway (rcap CI_lb CI_ub x) (scatter beta x)(line beta x, xline(0,lp(-)) yline(0,lc(red) lp(-))) , ylabel(-2(0.5)2.5)  xtitle("Days From Trump") ytitle("Effect on Stops") legend(order(1 "95% confidence interval" 2 "Effect")) graphregion(fcolor(white))
graph export "/home/yz6572/task2/results/FigureA5A.pdf", as(pdf) name("Graph") replace

***
use  "/home/yz6572/task2/results/SA_TRUMP_POST_1_15_NT.dta", clear
g x = 15

append using "/home/yz6572/task2/results/SA_TRUMP_POST_16_30_NT.dta"
replace x = 30 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_31_45_NT.dta"
replace x = 45 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_46_60_NT.dta"
replace x = 60 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_61_75_NT.dta"
replace x = 75 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_76_90_NT.dta"
replace x = 90 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_POST_91_105_NT.dta"
replace x = 105 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_0_NT.dta"
replace x = 0 if _n == _N

set obs `=_N+1'
replace x = -15 if _n == _N
replace beta = 0 if _n == _N
replace CI_lb = . if _n == _N
replace CI_ub = . if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_30_16_NT.dta"
replace x = -30 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_45_31_NT.dta"
replace x = -45 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_60_46_NT.dta"
replace x = -60 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_75_61_NT.dta"
replace x = -75 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_90_76_NT.dta"
replace x = -90 if _n == _N

append using "/home/yz6572/task2/results/SA_TRUMP_PRE_105_91_NT.dta"
replace x = -105 if _n == _N

sort x
replace CI_lb = CI_lb * 100 
replace CI_ub = CI_ub * 100
replace beta = beta * 100

twoway (rcap CI_lb CI_ub x) (scatter beta x)(line beta x, xline(0,lp(-)) yline(0,lc(red) lp(-))) , ylabel(-2(0.5)2.5)  xtitle("Days From Trump") ytitle("Effect on Stops") legend(order(1 "95% confidence interval" 2 "Effect")) graphregion(fcolor(white))
graph export "/home/yz6572/task2/results/FigureA5B.pdf", as(pdf) name("Graph") replace
