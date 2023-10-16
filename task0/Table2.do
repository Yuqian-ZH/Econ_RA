
**********************************************************************
*** TABLE 2
*** Triple Difference Results: Probability and Number of Stops by Race or Ethnicity
**********************************************************************

*do "Do\preparing_countydayrace_data"

use "/home/yz6572/task2/data/countydayrace_data.dta", clear


reghdfe prob_stop_race 1.TRUMP_*30#1.black 1.TRUMP_*30#1.hispanic 1.TRUMP_*30#1.asian [w=n_stops] if subject_race!=4, a(i.county_id##i.hispanic i.county_id##i.asian i.day_id##i.hispanic i.day_id##i.asian i.hispanic#i.county_id#c.day_id i.asian#i.county_id#c.day_id i.county_id#c.day_id) cluster(county_id day_id)
***Effect on blacks (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.black]
local est_black_white = `r(estimate)'
local se_black_white = `r(se)'
***Effect on blacks (vs hispanics)
lincom _b[1.TRUMP_POST_1_30#1.black] - _b[1.TRUMP_POST_1_30#1.hispanic]
local est_black_hisp = `r(estimate)'
local se_black_hisp = `r(se)'
***Effect on blacks (vs asians)
lincom _b[1.TRUMP_POST_1_30#1.black] - _b[1.TRUMP_POST_1_30#1.asian]
local est_black_api = `r(estimate)'
local se_black_api = `r(se)'
***Effect on hispanics (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.hispanic]
***Effect on asian (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.asian]
***Effect on asian (vs hispanic)
lincom _b[1.TRUMP_POST_1_30#1.asian] - _b[1.TRUMP_POST_1_30#1.hispanic]
outreg2 using "/home/yz6572/task2/results/Table2.txt", replace se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) label nonotes nocons noni
summ prob_stop_race if subject_race!=4

reghdfe ihs_stop_race 1.TRUMP_*30#1.black 1.TRUMP_*30#1.hispanic 1.TRUMP_*30#1.asian ihn_stops [w=n_stops] if subject_race!=4, a(i.county_id##i.hispanic i.county_id##i.asian i.day_id##i.hispanic i.day_id##i.asian i.hispanic#i.county_id#c.day_id i.asian#i.county_id#c.day_id i.county_id#c.day_id) cluster(county_id day_id)
***Effect on blacks (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.black]
local est_black_white = `r(estimate)'
local se_black_white = `r(se)'
***Effect on blacks (vs hispanics)
lincom _b[1.TRUMP_POST_1_30#1.black] - _b[1.TRUMP_POST_1_30#1.hispanic]
local est_black_hisp = `r(estimate)'
local se_black_hisp = `r(se)'
***Effect on blacks (vs asians)
lincom _b[1.TRUMP_POST_1_30#1.black] - _b[1.TRUMP_POST_1_30#1.asian]
local est_black_api = `r(estimate)'
local se_black_api = `r(se)'
***Effect on hispanics (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.hispanic]
***Effect on asian (vs whites)
lincom _b[1.TRUMP_POST_1_30#1.asian]
***Effect on asian (vs hispanic)
lincom _b[1.TRUMP_POST_1_30#1.asian] - _b[1.TRUMP_POST_1_30#1.hispanic]
outreg2 using "/home/yz6572/task2/results/Table2.txt", append se bdec(3) sdec(3) rdec(3) coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *) bfmt(fc) label nonotes nocons noni
summ ihs_stop_race if subject_race!=4


