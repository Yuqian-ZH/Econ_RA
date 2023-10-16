
**********************************************************************
*** FIGURE A13
*** Role of Local Characteristics in the Effect of Trump Rallies on the 
*** Probability of a Black Stop: Event-study Results
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec any_slaves_1860, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "racial_resent_a"

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
	
local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0


g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy

twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Racial Resentment A") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect")) 
graph export "/home/yz6572/task2/results/FigureA13A.pdf", as(pdf) name("Graph") replace

******************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "racial_resent_b"

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'
*

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
	
local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy

twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Racial Resentment B") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect")) 
graph export "/home/yz6572/task2/results/FigureA13B.pdf", as(pdf) name("Graph") replace

******************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec any_slaves_1860, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "any_slaves_1860"
 
g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'
*

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)

local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)


local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0


g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy

twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Presence of Slaves") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect")) 
graph export "/home/yz6572/task2/results/FigureA13C.pdf", as(pdf) name("Graph") replace


******************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "alt_cottonsui"

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'
*

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
	
local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0


g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy

twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Cotton Suitability") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect")) 
graph export "/home/yz6572/task2/results/FigureA13D.pdf", as(pdf) name("Graph") replace

******************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "ihsbl_lynch"

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'
*

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
	
local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0


g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy

twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Lynchings") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect"))  
graph export "/home/yz6572/task2/results/FigureA13E.pdf", as(pdf) name("Graph") replace

******************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event* racial_resent_a racial_resent_b alt_cottonsui ihsbl_lynch ihsbl_exec, by(county_fips day_id)

g black_ps = 100*black / n_stops

summ racial_resent_a [aweight=n_stops]
g  racial_resent_asd =  ( racial_resent_a - r(mean))/r(sd)

summ racial_resent_b [aweight=n_stops]
g  racial_resent_bsd = ( racial_resent_b - r(mean))/r(sd)

summ alt_cottonsui [aweight=n_stops]
g  alt_cottonsuisd = ( alt_cottonsui - r(mean))/r(sd)

su ihsbl_lynch [aweight=n_stops]
g  ihsbl_lynchsd = ( ihsbl_lynch - r(mean))/r(sd)

su ihsbl_exec [aweight=n_stops]
g  ihsbl_execsd = ( ihsbl_exec - r(mean))/r(sd)

local start = -105
local end = 105
local bin_l = 15
local var_het = "ihsbl_exec"

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
g INT_TRUMP_0 = TRUMP_0 * `var_het'
*

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}
	g INT_TRUMP_POST_`ii'_`jj' = TRUMP_POST_`ii'_`jj' * `var_het'
}
g TRUMP_POST_M`end' = 0
forval ii = 1/9 {
	replace TRUMP_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}
	g INT_TRUMP_PRE_`jj'_`zz' = TRUMP_PRE_`jj'_`zz' * `var_het'
}
}
*

local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}
*
g TRUMP_POST_M15 = 0
forval ii = 1/9 {
replace TRUMP_POST_M15 = 1 if (dist_event`ii' >15 & dist_event`ii'!=.)
}

g TRUMP_PRE_M15 = 0
forval ii = 1/9 {
replace TRUMP_PRE_M15 = 1 if (dist_event`ii' <-15 & dist_event`ii'!=.)
}

g TRUMP_POST_1_30 = 0
forval ii = 1/9 {
replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
}

reghdfe black_ps 1.TRUMP_PRE_M15 1.TRUMP_0 1.TRUMP_POST_1_30 TRUMP_POST_M15  INT_* c.day_id#c.`var_het' [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
	
local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[INT_TRUMP_0]
		mat treat[`pos',3] = _b[INT_TRUMP_0] + _se[INT_TRUMP_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_0] - _se[INT_TRUMP_0]*invttail(e(N),0.05)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[INT_TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_PRE_`num'_`num2'] + _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_PRE_`num'_`num2'] - _se[INT_TRUMP_PRE_`num'_`num2']*invttail(e(N),0.05)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[INT_TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[INT_TRUMP_POST_`num'_`num2'] + _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[INT_TRUMP_POST_`num'_`num2'] - _se[INT_TRUMP_POST_`num'_`num2']*invttail(e(N),0.05)
	}
}
local jj = abs(`start')
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = 0
mat treat[`range'-1,3] = 0
mat treat[`range'-1,4] = 0

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = 0
mat treat[`range',3] = 0
mat treat[`range',4] = 0

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_10 = treat[_n,3] in 1/`range'
g eff_90 = treat[_n,4] in 1/`range'
sort yy


twoway (rcap eff_10 eff_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1) (scatter eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1)(line eff yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) graphregion(fcolor(white)) title("Executions") xtitle("Days From Trump") ytitle("Differential Trump Effect on Black Stops by") legend(order(1 "90% CI" 2 "Effect")) 
graph export "/home/yz6572/task2/results/FigureA13F.pdf", as(pdf) name("Graph") replace








