
**********************************************************************
*** FIGURE A8
*** Impact of Trump Rallies on the Number of Stops With Respect to Whites: Event-study Results
**********************************************************************

use "/home/yz6572/task2/data/countydayrace_data.dta", clear

drop TRUMP*

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

reghdfe ihs_stop_race 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_*  1.TRUMP_PRE_*#1.black 1.TRUMP_0#1.black 1.TRUMP_POST_*#1.black 1.TRUMP_PRE_*#1.asian 1.TRUMP_0#1.asian 1.TRUMP_POST_*#1.asian ihs_stops [w=n_stops], a(i.county_id##i.black i.county_id##i.asian i.day_id##i.black i.day_id##i.asian i.county_id#c.day_id i.black#i.county_id#c.day_id i.asian#i.county_id#c.day_id) cluster(county_id day_id )

local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',10,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
		
		
		lincom _b[1.TRUMP_0#1.black] + _b[1.TRUMP_0]
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_0#1.asian] + _b[1.TRUMP_0]
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_PRE_`num'_`num2'#1.black] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_PRE_`num'_`num2'#1.asian] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
		
		mat treat[`pos',5] = 0
		mat treat[`pos',6] = 0
		mat treat[`pos',7] = 0
		
		mat treat[`pos',8] = 0
		mat treat[`pos',9] = 0
		mat treat[`pos',10] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_POST_`num'_`num2'#1.black] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_POST_`num'_`num2'#1.asian] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

lincom _b[1.TRUMP_PRE_M`jj'#1.black] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,5] = r(estimate)
mat treat[`range'-1,6] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range'-1,7] = r(estimate) - r(se)*invttail(e(N),0.025)

lincom _b[1.TRUMP_PRE_M`jj'#1.asian] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,8] = r(estimate)
mat treat[`range'-1,9] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range'-1,10] = r(estimate) - r(se)*invttail(e(N),0.025)		
		
		
mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M`end']
mat treat[`range',3] = _b[1.TRUMP_POST_M`end'] + _se[1.TRUMP_POST_M`end']*invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M`end'] - _se[1.TRUMP_POST_M`end']*invttail(e(N),0.025)

lincom _b[1.TRUMP_POST_M`end'#1.black] + _b[1.TRUMP_POST_M`end']
mat treat[`range',5] = r(estimate)
mat treat[`range',6] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range',7] = r(estimate) - r(se)*invttail(e(N),0.025)

lincom _b[1.TRUMP_POST_M`end'#1.asian] + _b[1.TRUMP_POST_M`end']
mat treat[`range',8] = r(estimate)
mat treat[`range',9] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range',10] = r(estimate) - r(se)*invttail(e(N),0.025)


g yy = treat[_n,1] in 1/`range'
g eff_hisp = treat[_n,2] in 1/`range'
g eff_hisp_10 = treat[_n,3] in 1/`range'
g eff_hisp_90 = treat[_n,4] in 1/`range'
g eff_bl = treat[_n,5] in 1/`range'
g eff_bl_10 = treat[_n,6] in 1/`range'
g eff_bl_90 = treat[_n,7] in 1/`range'
g eff_as = treat[_n,8] in 1/`range'
g eff_as_10 = treat[_n,9] in 1/`range'
g eff_as_90 = treat[_n,10] in 1/`range'
sort yy

*keep if yy>`start'-1 & yy<`end'+1  
duplicates drop yy, force
keep eff_* eff_*_10 eff_*_90 yy 

twoway (rcap eff_hisp_10 eff_hisp_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(green) ) (scatter eff_hisp yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(green) msymbol(triangle)) (line eff_hisp yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(green) xline(0,lp(-)) yline(0,lp(-))) , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Hispanics") legend(off)  xlabel(-105(15)105) ylabel(-0.15(0.05)0.25) saving(hisp,replace) 
graph export "/home/yz6572/task2/results/FigureA8A.pdf", as(pdf) replace 


twoway  (rcap eff_bl_10 eff_bl_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(blue)) (scatter eff_bl yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(blue)) (line eff_bl yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(blue) xline(0,lp(-)) yline(0,lp(-)))  , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Blacks")  xlabel(-105(15)105) legend(off) xlabel(-105(15)105) ylabel(-0.15(0.05)0.25) saving(black,replace)
graph export "/home/yz6572/task2/results/FigureA8B.pdf", as(pdf) replace 

twoway  (rcap eff_as_10 eff_as_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(red)) (scatter eff_as yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(red)) (line eff_as yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(red) xline(0,lp(-)) yline(0,lp(-))) , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on APIs")  legend(off) xlabel(-105(15)105) ylabel(-0.15(0.05)0.25) saving(asian,replace) 
graph export "/home/yz6572/task2/results/FigureA8C.pdf", as(pdf) replace 

****************************************************************************************************************************************

use "/home/yz6572/task2/data/countydayrace_data.dta", clear

drop TRUMP*

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

reghdfe ihs_stop_race 1.TRUMP_PRE_* 1.TRUMP_0 1.TRUMP_POST_*  1.TRUMP_PRE_*#1.black 1.TRUMP_0#1.black 1.TRUMP_POST_*#1.black  1.TRUMP_PRE_*#1.asian 1.TRUMP_0#1.asian 1.TRUMP_POST_*#1.asian ihs_stops [w=n_stops], a(i.county_id##i.black i.county_id##i.asian i.day_id##i.black i.day_id##i.asian) cluster(county_id day_id)


local temp =  1/`bin_l'
local bin_neg = abs(`start' * `temp')
local bin_pos = `end' * `temp'
local range = round(`bin_neg' + `bin_pos' + 3)

mat treat = J(`range',10,1)

local Nrange = `range' - 2

forval pos = 1/`Nrange' {
	local lag = `start' + `bin_l'*`pos' - `bin_l'
	if `lag' > 0 {
		local lag = `start' + `bin_l'*`pos' - `bin_l' - `bin_l' + 1
	}

	local num = abs(`lag')
	
	if `lag' == 0 {
		mat treat[`pos',1] = 0
		mat treat[`pos',2] = _b[1.TRUMP_0]
		mat treat[`pos',3] = _b[1.TRUMP_0] + _se[1.TRUMP_0]*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_0] - _se[1.TRUMP_0]*invttail(e(N),0.025)
		
		
		lincom _b[1.TRUMP_0#1.black] + _b[1.TRUMP_0]
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_0#1.asian] + _b[1.TRUMP_0]
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
	else if `lag' < -`bin_l' {
		local num2 = `num' - `bin_l' + 1
		local num1 = - `num'
		mat treat[`pos',1] = `num1'
		mat treat[`pos',2] = _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_PRE_`num'_`num2'] + _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_PRE_`num'_`num2'] - _se[1.TRUMP_PRE_`num'_`num2']*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_PRE_`num'_`num2'#1.black] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_PRE_`num'_`num2'#1.asian] + _b[1.TRUMP_PRE_`num'_`num2']
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
	else if `lag' == -`bin_l' {
		mat treat[`pos',1] = -`bin_l'
		mat treat[`pos',2] = 0
		mat treat[`pos',3] = 0
		mat treat[`pos',4] = 0
		
		mat treat[`pos',5] = 0
		mat treat[`pos',6] = 0
		mat treat[`pos',7] = 0
		
		mat treat[`pos',8] = 0
		mat treat[`pos',9] = 0
		mat treat[`pos',10] = 0
	}
	else {
			di "**"
	di `lag'
	di `pos'
		local num2 = `num' + `bin_l' - 1
		mat treat[`pos',1] = `num2'
		mat treat[`pos',2] = _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',3] = _b[1.TRUMP_POST_`num'_`num2'] + _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		mat treat[`pos',4] = _b[1.TRUMP_POST_`num'_`num2'] - _se[1.TRUMP_POST_`num'_`num2']*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_POST_`num'_`num2'#1.black] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',5] = r(estimate)
		mat treat[`pos',6] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',7] = r(estimate) - r(se)*invttail(e(N),0.025)
		
		lincom _b[1.TRUMP_POST_`num'_`num2'#1.asian] + _b[1.TRUMP_POST_`num'_`num2']
		mat treat[`pos',8] = r(estimate)
		mat treat[`pos',9] = r(estimate) + r(se)*invttail(e(N),0.025)
		mat treat[`pos',10] = r(estimate) - r(se)*invttail(e(N),0.025)
	}
}
mat treat[`range'-1,1] = `start' - `bin_l' - 1
mat treat[`range'-1,2] = _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,3] = _b[1.TRUMP_PRE_M`jj'] + _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)
mat treat[`range'-1,4] = _b[1.TRUMP_PRE_M`jj'] - _se[1.TRUMP_PRE_M`jj']*invttail(e(N),0.025)

lincom _b[1.TRUMP_PRE_M`jj'#1.black] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,5] = r(estimate)
mat treat[`range'-1,6] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range'-1,7] = r(estimate) - r(se)*invttail(e(N),0.025)

lincom _b[1.TRUMP_PRE_M`jj'#1.asian] + _b[1.TRUMP_PRE_M`jj']
mat treat[`range'-1,8] = r(estimate)
mat treat[`range'-1,9] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range'-1,10] = r(estimate) - r(se)*invttail(e(N),0.025)		
		
		
mat treat[`range',1] = `end' + `bin_l' + 1
mat treat[`range',2] = _b[1.TRUMP_POST_M`end']
mat treat[`range',3] = _b[1.TRUMP_POST_M`end'] + _se[1.TRUMP_POST_M`end']*invttail(e(N),0.025)
mat treat[`range',4] = _b[1.TRUMP_POST_M`end'] - _se[1.TRUMP_POST_M`end']*invttail(e(N),0.025)

lincom _b[1.TRUMP_POST_M`end'#1.black] + _b[1.TRUMP_POST_M`end']
mat treat[`range',5] = r(estimate)
mat treat[`range',6] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range',7] = r(estimate) - r(se)*invttail(e(N),0.025)

lincom _b[1.TRUMP_POST_M`end'#1.asian] + _b[1.TRUMP_POST_M`end']
mat treat[`range',8] = r(estimate)
mat treat[`range',9] = r(estimate) + r(se)*invttail(e(N),0.025)
mat treat[`range',10] = r(estimate) - r(se)*invttail(e(N),0.025)


g yy = treat[_n,1] in 1/`range'
g eff_hisp = treat[_n,2] in 1/`range'
g eff_hisp_10 = treat[_n,3] in 1/`range'
g eff_hisp_90 = treat[_n,4] in 1/`range'
g eff_bl = treat[_n,5] in 1/`range'
g eff_bl_10 = treat[_n,6] in 1/`range'
g eff_bl_90 = treat[_n,7] in 1/`range'
g eff_as = treat[_n,8] in 1/`range'
g eff_as_10 = treat[_n,9] in 1/`range'
g eff_as_90 = treat[_n,10] in 1/`range'
sort yy

*keep if yy>`start'-1 & yy<`end'+1  
duplicates drop yy, force
keep eff_* eff_*_10 eff_*_90 yy 

twoway (rcap eff_hisp_10 eff_hisp_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(green) ) (scatter eff_hisp yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(green) msymbol(triangle)) (line eff_hisp yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(green) xline(0,lp(-)) yline(0,lp(-))) , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Hispanics") legend(off)  xlabel(-105(15)105) ylabel(-0.15(0.05)0.2) saving(hisp,replace) 
graph export "/home/yz6572/task2/results/FigureA8D.pdf", as(pdf) replace 


twoway  (rcap eff_bl_10 eff_bl_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(blue)) (scatter eff_bl yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(blue)) (line eff_bl yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(blue) xline(0,lp(-)) yline(0,lp(-)))  , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on Blacks")  xlabel(-105(15)105) legend(off) xlabel(-105(15)105) ylabel(-0.15(0.05)0.2) saving(black,replace)
graph export "/home/yz6572/task2/results/FigureA8E.pdf", as(pdf) replace 

twoway  (rcap eff_as_10 eff_as_90 yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,lc(red)) (scatter eff_as yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1,mc(red)) (line eff_as yy if yy>`start' - `bin_l' - 1 & yy<`end' + `bin_l' + 1, lc(red) xline(0,lp(-)) yline(0,lp(-))) , graphregion(fcolor(white)) xtitle("Days From Trump") ytitle("Effect on APIs")  legend(off) xlabel(-105(15)105) ylabel(-0.15(0.05)0.2) saving(asian,replace) 
graph export "/home/yz6572/task2/results/FigureA8F.pdf", as(pdf) replace 

