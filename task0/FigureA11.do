
**********************************************************************
*** FIGURE A11
*** The Differential Effect of Trump and Other Political Rallies on the Probability
*** of a Black Stop: Event-study Results With and Without County-specific Linear Trends
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event*, by(county_fips day_id)

merge n:1 county_fips using "/home/yz6572/task2/data/allcandidates_rallies.dta"
drop if _merge==2
 
g black_ps = black / n_stops

local start = -105
local end = 105
local bin_l = 15

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
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
}
}
*
local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

drop dist_event*

forval ii = 1/4 {
	g dist_event`ii' = day_id - event_day_Cruz_`ii'
}

g CRUZ_0 = 0
forval ii = 1/4 {
replace CRUZ_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g CRUZ_POST_`ii'_`jj' = 0
	forval ee = 1/4 {
		replace CRUZ_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g CRUZ_POST_M`end' = 0
forval ii = 1/4 {
	replace CRUZ_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g CRUZ_PRE_`jj'_`zz' = 0
	forval ee = 1/4 {
		replace CRUZ_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs(`start')
g CRUZ_PRE_M`jj' = 0
forval ii = 1/4 {
	replace CRUZ_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

drop dist_event* 

forval ii = 1/10 {
	g dist_event`ii' = day_id - event_day_Clinton_`ii'
} 
g CLINTON_0 = 0
forval ii = 1/10 {
replace CLINTON_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g CLINTON_POST_`ii'_`jj' = 0
	forval ee = 1/10 {
		replace CLINTON_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g CLINTON_POST_M`end' = 0
forval ii = 1/10 {
	replace CLINTON_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g CLINTON_PRE_`jj'_`zz' = 0
	forval ee = 1/10 {
		replace CLINTON_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs(`start')
g CLINTON_PRE_M`jj' = 0
forval ii = 1/10 {
	replace CLINTON_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

g ANYCANDIDATE_0 = (TRUMP_0==1) | (CRUZ_0==1) | (CLINTON_0==1)

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g ANYCANDIDATE_POST_`ii'_`jj' = (TRUMP_POST_`ii'_`jj'==1) | (CRUZ_POST_`ii'_`jj'==1) | (CLINTON_POST_`ii'_`jj'==1)
}
g ANYCANDIDATE_POST_M`end' = (TRUMP_POST_M`end'==1) | (CRUZ_POST_M`end'==1) | (CLINTON_POST_M`end'==1)

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g ANYCANDIDATE_PRE_`jj'_`zz' = (TRUMP_PRE_`jj'_`zz'==1) | (CRUZ_PRE_`jj'_`zz'==1) | (CLINTON_PRE_`jj'_`zz'==1)
}
}
*
local jj = abs(`start')
g ANYCANDIDATE_PRE_M`jj' = (TRUMP_PRE_M`jj'==1) | (CRUZ_PRE_M`jj'==1) | (CLINTON_PRE_M`jj'==1)

reghdfe black_ps 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_*  1.ANYCANDIDATE_* 1.ANYCANDIDATE_0 1.ANYCANDIDATE_* [w=n_stops], a(i.county_fips i.day_id i.county_fips#c.day_id) cluster(county_fips day_id )

local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',7,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_0]
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_0] + _se[1.ANYCANDIDATE_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_0] - _se[1.ANYCANDIDATE_0]*invttail(e(N),0.05)
		
		
		lincom _b[1.ANYCANDIDATE_0] + _b[1.TRUMP_0]
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
		
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_PRE_`num'_`num2'] + _se[1.ANYCANDIDATE_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_PRE_`num'_`num2'] - _se[1.ANYCANDIDATE_PRE_`num'_`num2']*invttail(e(N),0.05)
		
		lincom _b[1.ANYCANDIDATE_PRE_`num'_`num2'] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
		
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
		
		mat treat[`pos',5] = 0
		mat treat[`pos',6] = 0
		mat treat[`pos',7] = 0
		
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_POST_`num'_`num2'] + _se[1.ANYCANDIDATE_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_POST_`num'_`num2'] - _se[1.ANYCANDIDATE_POST_`num'_`num2']*invttail(e(N),0.05)
		
		lincom _b[1.ANYCANDIDATE_POST_`num'_`num2'] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
	}
}
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = _b[1.ANYCANDIDATE_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.ANYCANDIDATE_PRE_M`jj'] + _se[1.ANYCANDIDATE_PRE_M`jj']*invttail(e(N),0.05)
mat treat[`range'-1,4] = _b[1.ANYCANDIDATE_PRE_M`jj'] - _se[1.ANYCANDIDATE_PRE_M`jj']*invttail(e(N),0.05)

lincom _b[1.ANYCANDIDATE_PRE_M`jj'] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,5] = r(estimate)
mat treat[`range'-1,6] = r(estimate) + r(se)*invttail(e(N),0.05)
mat treat[`range'-1,7] = r(estimate) - r(se)*invttail(e(N),0.05)

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = _b[1.ANYCANDIDATE_POST_M`end']
mat treat[`range',3] = _b[1.ANYCANDIDATE_POST_M`end'] + _se[1.ANYCANDIDATE_POST_M`end']*invttail(e(N),0.05)
mat treat[`range',4] = _b[1.ANYCANDIDATE_POST_M`end'] - _se[1.ANYCANDIDATE_POST_M`end']*invttail(e(N),0.05)

lincom _b[1.ANYCANDIDATE_POST_M`end'] + _b[1.TRUMP_POST_M`end']
mat treat[`range',5] = r(estimate)
mat treat[`range',6] = r(estimate) + r(se)*invttail(e(N),0.05)
mat treat[`range',7] = r(estimate) - r(se)*invttail(e(N),0.05)

g yy = treat[_n,1] in 1/`range'
g eff_any = treat[_n,2] in 1/`range'
g eff_any_10 = treat[_n,3] in 1/`range'
g eff_any_90 = treat[_n,4] in 1/`range'
g eff_tr = treat[_n,5] in 1/`range'
g eff_tr_10 = treat[_n,6] in 1/`range'
g eff_tr_90 = treat[_n,7] in 1/`range'
sort yy

duplicates drop yy, force
keep eff_* eff_*_10 eff_*_90 yy 

twoway  (rcap eff_tr_10 eff_tr_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(blue)) (scatter eff_tr yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(blue)) (line eff_tr yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(blue) xline(0,lp(-)) yline(0,lp(-)))  , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Probabilty Black Stop")  xlabel(-105(15)105) legend(off) xlabel(-105(15)105) ylabel(-0.01(0.005)0.02) saving(track,replace)
graph export "/home/yz6572/task2/results/FigureA11A.pdf", as(pdf) name("Graph") replace


**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
replace black = black/100

collapse (sum) n_stops black (first) dist_event*, by(county_fips day_id)

merge n:1 county_fips using "/home/yz6572/task2/data/allcandidates_rallies.dta"
drop if _merge==2
 
g black_ps = black / n_stops

local start = -105
local end = 105
local bin_l = 15

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g TRUMP_POST_`ii'_`jj' = 0
	forval ee = 1/9 {
		replace TRUMP_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
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
}
}
*
local jj = abs(`start')
g TRUMP_PRE_M`jj' = 0
forval ii = 1/9 {
	replace TRUMP_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

drop dist_event*

forval ii = 1/4 {
	g dist_event`ii' = day_id - event_day_Cruz_`ii'
}

g CRUZ_0 = 0
forval ii = 1/4 {
replace CRUZ_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g CRUZ_POST_`ii'_`jj' = 0
	forval ee = 1/4 {
		replace CRUZ_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g CRUZ_POST_M`end' = 0
forval ii = 1/4 {
	replace CRUZ_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g CRUZ_PRE_`jj'_`zz' = 0
	forval ee = 1/4 {
		replace CRUZ_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs(`start')
g CRUZ_PRE_M`jj' = 0
forval ii = 1/4 {
	replace CRUZ_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

drop dist_event* 

forval ii = 1/10 {
	g dist_event`ii' = day_id - event_day_Clinton_`ii'
} 
g CLINTON_0 = 0
forval ii = 1/10 {
replace CLINTON_0 = 1 if dist_event`ii' == 0
}

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g CLINTON_POST_`ii'_`jj' = 0
	forval ee = 1/10 {
		replace CLINTON_POST_`ii'_`jj' = 1 if (dist_event`ee' >= `ii' & dist_event`ee'<=`jj' & dist_event`ee'!=.)
	}	
}
g CLINTON_POST_M`end' = 0
forval ii = 1/10 {
	replace CLINTON_POST_M`end' = 1 if (dist_event`ii' > `end' & dist_event`ii'!=.)
}
*

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g CLINTON_PRE_`jj'_`zz' = 0
	forval ee = 1/10 {
		replace CLINTON_PRE_`jj'_`zz' = 1 if (dist_event`ee' <= -`zz' & dist_event`ee'>=-`jj'  & dist_event`ee'!=.)
	}	
}
}
*
local jj = abs(`start')
g CLINTON_PRE_M`jj' = 0
forval ii = 1/10 {
	replace CLINTON_PRE_M`jj' = 1 if (dist_event`ii' < `start' & dist_event`ii'!=.)
}

g ANYCANDIDATE_0 = (TRUMP_0==1) | (CRUZ_0==1) | (CLINTON_0==1)

forval ii = 1(`bin_l')`end'{ 
	local jj = `ii' + `bin_l' - 1
	g ANYCANDIDATE_POST_`ii'_`jj' = (TRUMP_POST_`ii'_`jj'==1) | (CRUZ_POST_`ii'_`jj'==1) | (CLINTON_POST_`ii'_`jj'==1)
}
g ANYCANDIDATE_POST_M`end' = (TRUMP_POST_M`end'==1) | (CRUZ_POST_M`end'==1) | (CLINTON_POST_M`end'==1)

forval ii = `start'(`bin_l')0 { 
if `ii' < -`bin_l' {
	local jj = abs(`ii')
	local zz = `jj' - `bin_l' + 1
	g ANYCANDIDATE_PRE_`jj'_`zz' = (TRUMP_PRE_`jj'_`zz'==1) | (CRUZ_PRE_`jj'_`zz'==1) | (CLINTON_PRE_`jj'_`zz'==1)
}
}
*
local jj = abs(`start')
g ANYCANDIDATE_PRE_M`jj' = (TRUMP_PRE_M`jj'==1) | (CRUZ_PRE_M`jj'==1) | (CLINTON_PRE_M`jj'==1)

reghdfe black_ps 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_*  1.ANYCANDIDATE_* 1.ANYCANDIDATE_0 1.ANYCANDIDATE_* [w=n_stops], a(i.county_fips i.day_id) cluster(county_fips day_id)

local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',7,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_0]
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_0] + _se[1.ANYCANDIDATE_0]*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_0] - _se[1.ANYCANDIDATE_0]*invttail(e(N),0.05)
		
		
		lincom _b[1.ANYCANDIDATE_0] + _b[1.TRUMP_0]
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
		
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_PRE_`num'_`num2'] + _se[1.ANYCANDIDATE_PRE_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_PRE_`num'_`num2'] - _se[1.ANYCANDIDATE_PRE_`num'_`num2']*invttail(e(N),0.05)
		
		lincom _b[1.ANYCANDIDATE_PRE_`num'_`num2'] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
		
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
		
		mat treat[`pos',5] = 0
		mat treat[`pos',6] = 0
		mat treat[`pos',7] = 0
		
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.ANYCANDIDATE_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.ANYCANDIDATE_POST_`num'_`num2'] + _se[1.ANYCANDIDATE_POST_`num'_`num2']*invttail(e(N),0.05)
		mat treat[`pos',4] = _b[1.ANYCANDIDATE_POST_`num'_`num2'] - _se[1.ANYCANDIDATE_POST_`num'_`num2']*invttail(e(N),0.05)
		
		lincom _b[1.ANYCANDIDATE_POST_`num'_`num2'] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.05)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.05)
	}
}
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = _b[1.ANYCANDIDATE_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.ANYCANDIDATE_PRE_M`jj'] + _se[1.ANYCANDIDATE_PRE_M`jj']*invttail(e(N),0.05)
mat treat[`range'-1,4] = _b[1.ANYCANDIDATE_PRE_M`jj'] - _se[1.ANYCANDIDATE_PRE_M`jj']*invttail(e(N),0.05)

lincom _b[1.ANYCANDIDATE_PRE_M`jj'] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,5] = r(estimate)
mat treat[`range'-1,6] = r(estimate) + r(se)*invttail(e(N),0.05)
mat treat[`range'-1,7] = r(estimate) - r(se)*invttail(e(N),0.05)

mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = _b[1.ANYCANDIDATE_POST_M`end']
mat treat[`range',3] = _b[1.ANYCANDIDATE_POST_M`end'] + _se[1.ANYCANDIDATE_POST_M`end']*invttail(e(N),0.05)
mat treat[`range',4] = _b[1.ANYCANDIDATE_POST_M`end'] - _se[1.ANYCANDIDATE_POST_M`end']*invttail(e(N),0.05)

lincom _b[1.ANYCANDIDATE_POST_M`end'] + _b[1.TRUMP_POST_M`end']
mat treat[`range',5] = r(estimate)
mat treat[`range',6] = r(estimate) + r(se)*invttail(e(N),0.05)
mat treat[`range',7] = r(estimate) - r(se)*invttail(e(N),0.05)

g yy = treat[_n,1] in 1/`range'
g eff_any = treat[_n,2] in 1/`range'
g eff_any_10 = treat[_n,3] in 1/`range'
g eff_any_90 = treat[_n,4] in 1/`range'
g eff_tr = treat[_n,5] in 1/`range'
g eff_tr_10 = treat[_n,6] in 1/`range'
g eff_tr_90 = treat[_n,7] in 1/`range'
sort yy

duplicates drop yy, force
keep eff_* eff_*_10 eff_*_90 yy 

twoway  (rcap eff_tr_10 eff_tr_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(blue)) (scatter eff_tr yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(blue)) (line eff_tr yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(blue) xline(0,lp(-)) yline(0,lp(-)))  , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Probabilty Black Stop")  xlabel(-105(15)105) legend(off) xlabel(-105(15)105) ylabel(-0.01(0.005)0.02) saving(track,replace)
graph export "/home/yz6572/task2/results/FigureA11B.pdf", as(pdf) name("Graph") replace
