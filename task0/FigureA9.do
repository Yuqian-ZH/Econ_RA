
**********************************************************************
*** FIGURE A9
*** Impact of Trump Rallies on the Number of Stops: Event-study Results
**********************************************************************

global start = -105
global end = 105
global bin_l = 15
global var = "ihs_black"
global trend = 1

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black hispanic white api (first) dist_event* , by(county_fips day_id)

g black_ps = 100*black / n_stops
g hispanic_ps = 100*hispanic / n_stops
g white_ps = 100*white / n_stops
g asian_ps = 100*api / n_stops
g ln_stops = ln(n_stops)
g hispanic_nbps = 100*hispanic / (n_stops-black)
g white_nbps = 100*white / (n_stops-black)
g asian_nbps = 100*asian / (n_stops-black)

g ihs_black= log(black +(black +1)^(1/2))
g ln_black = ln(black +1)
g ihs_hispanic = log(hispanic+(hispanic+1)^(1/2))
g ln_hispanic = ln(hispanic+1)
g ihs_white = log(white+(white+1)^(1/2))
g ln_white = ln(white+1)
g ihs_asian = log(api+(api+1)^(1/2))
g ln_asian = ln(api+1)

g ihs_stops = log(n_stops+(n_stops+1)^(1/2))

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1($bin_l)$end{ 
	local jj = `ii' + $bin_l - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g TRUMP_POST_M$end = 0
forval ii = 1/9 {
	replace TRUMP_POST_M$end = 1 if (dist_event`ii' > $end & dist_event`ii'!=.)
}
*

forval ii = $start($bin_l)0 { 
if `ii' < -$bin_l {
	local jj = abs(`ii')
	local zz = `jj' - $bin_l + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs($start)
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < $start & dist_event`ii'!=.)
}

if $trend==1 {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
}
else {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
}
local temp =  1/$bin_l
local bin_neg = abs($start * `temp')
local bin_pos = $end * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = $start + $bin_l*`pos' - $bin_l
	if `lag' > 0 {
		local lag = $start + $bin_l*`pos' - $bin_l - $bin_l + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
	}
	else if `lag' < -$bin_l {
		local num2 = `num' - $bin_l + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
	}
	else if `lag' == -$bin_l {
		mat treat[`pos',1] = -$bin_l
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + $bin_l - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = $start - $bin_l - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

mat treat[`range',1] = $end + $bin_l + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M$end]
mat treat[`range',3] = _b[1.TRUMP_POST_M$end] + _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M$end] - _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_5 = treat[_n,3] in 1/`range'
g eff_95 = treat[_n,4] in 1/`range'
sort yy

*keep if yy>`start'-1 & yy<`end'+1  
duplicates drop yy, force
keep eff eff_5 eff_95 yy 

twoway (rcap eff_5 eff_95 yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1) (scatter eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1)(line eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) ylabel(-0.1(0.05)0.1) graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Black Stops") legend(order(1 "95% Confidence Interval" 2 "Effect"))
graph export "/home/yz6572/task2/results/FigureA9A.pdf", as(pdf) replace 

******************************************************************************************************************************************************************

global start = -105
global end = 105
global bin_l = 15
global var = "ihs_hispanic"
global trend = 1

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black hispanic white api (first) dist_event* , by(county_fips day_id)
g black_ps = 100*black / n_stops
g hispanic_ps = 100*hispanic / n_stops
g white_ps = 100*white / n_stops
g asian_ps = 100*api / n_stops
g ln_stops = ln(n_stops)
g hispanic_nbps = 100*hispanic / (n_stops-black)
g white_nbps = 100*white / (n_stops-black)
g asian_nbps = 100*asian / (n_stops-black)

g ihs_black= log(black +(black +1)^(1/2))
g ln_black = ln(black +1)
g ihs_hispanic = log(hispanic+(hispanic+1)^(1/2))
g ln_hispanic = ln(hispanic+1)
g ihs_white = log(white+(white+1)^(1/2))
g ln_white = ln(white+1)
g ihs_asian = log(api+(api+1)^(1/2))
g ln_asian = ln(api+1)

g ihs_stops = log(n_stops+(n_stops+1)^(1/2))


g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1($bin_l)$end{ 
	local jj = `ii' + $bin_l - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g TRUMP_POST_M$end = 0
forval ii = 1/9 {
	replace TRUMP_POST_M$end = 1 if (dist_event`ii' > $end & dist_event`ii'!=.)
}
*

forval ii = $start($bin_l)0 { 
if `ii' < -$bin_l {
	local jj = abs(`ii')
	local zz = `jj' - $bin_l + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs($start)
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < $start & dist_event`ii'!=.)
}

if $trend==1 {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
}
else {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
}
local temp =  1/$bin_l
local bin_neg = abs($start * `temp')
local bin_pos = $end * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = $start + $bin_l*`pos' - $bin_l
	if `lag' > 0 {
		local lag = $start + $bin_l*`pos' - $bin_l - $bin_l + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
	}
	else if `lag' < -$bin_l {
		local num2 = `num' - $bin_l + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
	}
	else if `lag' == -$bin_l {
		mat treat[`pos',1] = -$bin_l
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + $bin_l - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = $start - $bin_l - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

mat treat[`range',1] = $end + $bin_l + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M$end]
mat treat[`range',3] = _b[1.TRUMP_POST_M$end] + _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M$end] - _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_5 = treat[_n,3] in 1/`range'
g eff_95 = treat[_n,4] in 1/`range'
sort yy

*keep if yy>`start'-1 & yy<`end'+1  
duplicates drop yy, force
keep eff eff_5 eff_95 yy 

twoway (rcap eff_5 eff_95 yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1) (scatter eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1)(line eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) ylabel(-0.1(0.05)0.1) graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Hispanic Stops") legend(order(1 "95% Confidence Interval" 2 "Effect"))
graph export "/home/yz6572/task2/results/FigureA9B.pdf", as(pdf) replace 

******************************************************************************************************************************************************************

global start = -105
global end = 105
global bin_l = 15
global var = "ihs_white"
global trend = 1

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black hispanic white api (first) dist_event* , by(county_fips day_id)

g black_ps = 100*black / n_stops
g hispanic_ps = 100*hispanic / n_stops
g white_ps = 100*white / n_stops
g asian_ps = 100*api / n_stops
g ln_stops = ln(n_stops)
g hispanic_nbps = 100*hispanic / (n_stops-black)
g white_nbps = 100*white / (n_stops-black)
g asian_nbps = 100*asian / (n_stops-black)

g ihs_black= log(black +(black +1)^(1/2))
g ln_black = ln(black +1)
g ihs_hispanic = log(hispanic+(hispanic+1)^(1/2))
g ln_hispanic = ln(hispanic+1)
g ihs_white = log(white+(white+1)^(1/2))
g ln_white = ln(white+1)
g ihs_asian = log(api+(api+1)^(1/2))
g ln_asian = ln(api+1)

g ihs_stops = log(n_stops+(n_stops+1)^(1/2))


g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1($bin_l)$end{ 
	local jj = `ii' + $bin_l - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g TRUMP_POST_M$end = 0
forval ii = 1/9 {
	replace TRUMP_POST_M$end = 1 if (dist_event`ii' > $end & dist_event`ii'!=.)
}
*

forval ii = $start($bin_l)0 { 
if `ii' < -$bin_l {
	local jj = abs(`ii')
	local zz = `jj' - $bin_l + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs($start)
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < $start & dist_event`ii'!=.)
}

if $trend==1 {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
}
else {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
}
local temp =  1/$bin_l
local bin_neg = abs($start * `temp')
local bin_pos = $end * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = $start + $bin_l*`pos' - $bin_l
	if `lag' > 0 {
		local lag = $start + $bin_l*`pos' - $bin_l - $bin_l + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
	}
	else if `lag' < -$bin_l {
		local num2 = `num' - $bin_l + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
	}
	else if `lag' == -$bin_l {
		mat treat[`pos',1] = -$bin_l
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + $bin_l - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = $start - $bin_l - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

mat treat[`range',1] = $end + $bin_l + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M$end]
mat treat[`range',3] = _b[1.TRUMP_POST_M$end] + _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M$end] - _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_5 = treat[_n,3] in 1/`range'
g eff_95 = treat[_n,4] in 1/`range'
sort yy

*keep if yy>`start'-1 & yy<`end'+1  
duplicates drop yy, force
keep eff eff_5 eff_95 yy 

twoway (rcap eff_5 eff_95 yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1) (scatter eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1)(line eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) ylabel(-0.1(0.05)0.1) graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on White Stops") legend(order(1 "95% Confidence Interval" 2 "Effect"))
graph export "/home/yz6572/task2/results/FigureA9D.pdf", as(pdf) replace 

******************************************************************************************************************************************************************

global start = -105
global end = 105
global bin_l = 15
global var = "ihs_asian"
global trend = 1

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black hispanic white api (first) dist_event* , by(county_fips day_id)

g black_ps = 100*black / n_stops
g hispanic_ps = 100*hispanic / n_stops
g white_ps = 100*white / n_stops
g asian_ps = 100*api / n_stops
g ln_stops = ln(n_stops)
g hispanic_nbps = 100*hispanic / (n_stops-black)
g white_nbps = 100*white / (n_stops-black)
g asian_nbps = 100*asian / (n_stops-black)

g ihs_black= log(black +(black +1)^(1/2))
g ln_black = ln(black +1)
g ihs_hispanic = log(hispanic+(hispanic+1)^(1/2))
g ln_hispanic = ln(hispanic+1)
g ihs_white = log(white+(white+1)^(1/2))
g ln_white = ln(white+1)
g ihs_asian = log(api+(api+1)^(1/2))
g ln_asian = ln(api+1)

g ihs_stops = log(n_stops+(n_stops+1)^(1/2))


g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1($bin_l)$end{ 
	local jj = `ii' + $bin_l - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g TRUMP_POST_M$end = 0
forval ii = 1/9 {
	replace TRUMP_POST_M$end = 1 if (dist_event`ii' > $end & dist_event`ii'!=.)
}
*

forval ii = $start($bin_l)0 { 
if `ii' < -$bin_l {
	local jj = abs(`ii')
	local zz = `jj' - $bin_l + 1
	g TRUMP_PRE_`jj'_`zz' = 0
	forval ee = 1/9 {
		replace TRUMP_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs($start)
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < $start & dist_event`ii'!=.)
}

if $trend==1 {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id)
}
else {
	reghdfe $var 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_* ihs_stops [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)
}
local temp =  1/$bin_l
local bin_neg = abs($start * `temp')
local bin_pos = $end * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',4,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = $start + $bin_l*`pos' - $bin_l
	if `lag' > 0 {
		local lag = $start + $bin_l*`pos' - $bin_l - $bin_l + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
	}
	else if `lag' < -$bin_l {
		local num2 = `num' - $bin_l + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
	}
	else if `lag' == -$bin_l {
		mat treat[`pos',1] = -$bin_l
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + $bin_l - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = $start - $bin_l - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

mat treat[`range',1] = $end + $bin_l + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M$end]
mat treat[`range',3] = _b[1.TRUMP_POST_M$end] + _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M$end] - _se[1.TRUMP_POST_M$end] *invttail(e(N),0.025)

g yy = treat[_n,1] in 1/`range'
g eff = treat[_n,2] in 1/`range'
g eff_5 = treat[_n,3] in 1/`range'
g eff_95 = treat[_n,4] in 1/`range'
sort yy

duplicates drop yy, force
keep eff eff_5 eff_95 yy 

twoway (rcap eff_5 eff_95 yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1) (scatter eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1)(line eff yy if yy>$start - $bin_l - 1 & yy<$end + $bin_l + 1, xline(0,lp(-)) yline(0,lp(-)))  ,  xlabel(-105(15)105) ylabel(-0.1(0.05)0.1) graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on API Stops") legend(order(1 "95% Confidence Interval" 2 "Effect"))
graph export "/home/yz6572/task2/results/FigureA9C.pdf", as(pdf) replace 
