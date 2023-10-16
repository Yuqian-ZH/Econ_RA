ssc install reghdfe
ssc install ftools

timer on 4

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_1_15==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_1_15==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_1_15 1.TRUMP_POST_1_15#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_1_15==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_1_15]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_1_15] + _b[1.TRUMP_POST_1_15#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_1_15_TE.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_16_30==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_16_30==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_16_30 1.TRUMP_POST_16_30#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_16_30==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_16_30]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_16_30] + _b[1.TRUMP_POST_16_30#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_16_30_TE.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/Jack Police\full_dataset_CD.dta", clear

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_31_45==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_31_45==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_31_45 1.TRUMP_POST_31_45#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_31_45==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_31_45]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_31_45] + _b[1.TRUMP_POST_31_45#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_31_45_TE.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_46_60==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_46_60==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_46_60 1.TRUMP_POST_46_60#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_46_60==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_46_60]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_46_60] + _b[1.TRUMP_POST_46_60#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_46_60_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_61_75==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_61_75==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_61_75 1.TRUMP_POST_61_75#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_61_75==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_61_75]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_61_75] + _b[1.TRUMP_POST_61_75#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_POST_61_75_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_76_90==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_76_90==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_76_90 1.TRUMP_POST_76_90#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_76_90==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_76_90]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_76_90] + _b[1.TRUMP_POST_76_90#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_76_90_TE.dta", replace


************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_91_105==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_91_105==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_91_105 1.TRUMP_POST_91_105#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_91_105==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_91_105]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_91_105] + _b[1.TRUMP_POST_91_105#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999



keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_POST_91_105_TE.dta", replace


************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

local start = -105
local end = 105
local bin_l = 15

forval ii = 1/9 {
	g dist_event`ii' = day_id - event_day_Trump_`ii'
} 
* 


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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_0==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_0==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9


reghdfe black_ps  1.TRUMP_0 1.TRUMP_0#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_0==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_0]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_0] + _b[1.TRUMP_0#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999



keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_0_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9


reghdfe black_ps  1.TRUMP_PRE_30_16 1.TRUMP_PRE_30_16#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46  TRUMP_PRE_45_31 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_30_16]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_30_16] + _b[1.TRUMP_PRE_30_16#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_30_16_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_45_31 1.TRUMP_PRE_45_31#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46  TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_45_31]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_45_31] + _b[1.TRUMP_PRE_45_31#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_45_31_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_60_46 1.TRUMP_PRE_60_46#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_60_46]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_60_46] + _b[1.TRUMP_PRE_60_46#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_PRE_60_46_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_75_61 1.TRUMP_PRE_75_61#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_60_46 TRUMP_PRE_45_31  TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_75_61]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_75_61] + _b[1.TRUMP_PRE_75_61#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_75_61_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_90_76 1.TRUMP_PRE_90_76#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_90_76]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_90_76] + _b[1.TRUMP_PRE_90_76#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_PRE_90_76_TE.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_105_91 1.TRUMP_PRE_105_91#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_105_91]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_105_91] + _b[1.TRUMP_PRE_105_91#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_105_91_TE.dta", replace



******************************************************************************************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_1_15==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_1_15==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_1_15 1.TRUMP_POST_1_15#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_1_15==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_1_15]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_1_15] + _b[1.TRUMP_POST_1_15#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_1_15_TE_NT.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_16_30==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_16_30==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_16_30 1.TRUMP_POST_16_30#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_16_30==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_16_30]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_16_30] + _b[1.TRUMP_POST_16_30#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_16_30_TE_NT.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/Jack Police\full_dataset_CD.dta", clear

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_31_45==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_31_45==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_31_45 1.TRUMP_POST_31_45#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_31_45==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_31_45]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_31_45] + _b[1.TRUMP_POST_31_45#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_31_45_TE_NT.dta", replace

************************************************************************************************************************************
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_46_60==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_46_60==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps 1.TRUMP_POST_46_60 1.TRUMP_POST_46_60#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_46_60==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_46_60]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_46_60] + _b[1.TRUMP_POST_46_60#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_46_60_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_61_75==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_61_75==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_61_75 1.TRUMP_POST_61_75#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_61_75==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_61_75]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_61_75] + _b[1.TRUMP_POST_61_75#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_POST_61_75_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_76_90==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_76_90==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_76_90 1.TRUMP_POST_76_90#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_76_90==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_76_90]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_76_90] + _b[1.TRUMP_POST_76_90#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_POST_76_90_TE_NT.dta", replace


************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST_91_105==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST_91_105==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST_91_105 1.TRUMP_POST_91_105#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST_91_105==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST_91_105]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST_91_105] + _b[1.TRUMP_POST_91_105#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999



keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_POST_91_105_TE_NT.dta", replace


************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

local start = -105
local end = 105
local bin_l = 15

forval ii = 1/9 {
	g dist_event`ii' = day_id - event_day_Trump_`ii'
} 
* 


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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_0==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_0==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9


reghdfe black_ps  1.TRUMP_0 1.TRUMP_0#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_0==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_0]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_0] + _b[1.TRUMP_0#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999



keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_0_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9


reghdfe black_ps  1.TRUMP_PRE_30_16 1.TRUMP_PRE_30_16#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46  TRUMP_PRE_45_31 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_30_16==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_30_16]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_30_16] + _b[1.TRUMP_PRE_30_16#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_30_16_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_45_31 1.TRUMP_PRE_45_31#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46  TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_45_31==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_45_31]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_45_31] + _b[1.TRUMP_PRE_45_31#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_45_31_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_60_46 1.TRUMP_PRE_60_46#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_60_46==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_60_46]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_60_46] + _b[1.TRUMP_PRE_60_46#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_PRE_60_46_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_75_61 1.TRUMP_PRE_75_61#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_90_76 TRUMP_PRE_60_46 TRUMP_PRE_45_31  TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_75_61==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_75_61]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_75_61] + _b[1.TRUMP_PRE_75_61#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_75_61_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_90_76 1.TRUMP_PRE_90_76#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_105_91 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)


mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_90_76==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_90_76]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_90_76] + _b[1.TRUMP_PRE_90_76#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478


save "/home/yz6572/task2/results/SA_TRUMP_PRE_90_76_TE_NT.dta", replace

************************************************************************************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

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

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
*** Drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_PRE_105_91 1.TRUMP_PRE_105_91#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id   TRUMP_0 TRUMP_POST_1_15 TRUMP_POST_16_30 TRUMP_POST_31_45 TRUMP_POST_46_60 TRUMP_POST_61_75 TRUMP_POST_76_90 TRUMP_POST_91_105 TRUMP_POST_M105 TRUMP_PRE_90_76 TRUMP_PRE_75_61 TRUMP_PRE_60_46 TRUMP_PRE_45_31 TRUMP_PRE_30_16 TRUMP_PRE_M105) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_PRE_105_91==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_105_91]) 
			mat treat[`ii',2] = (${stops`ii'})
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_PRE_105_91] + _b[1.TRUMP_PRE_105_91#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
		}
	}
}

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

keep yy ww

g county_id = _n
drop if county_id > 1478

save "/home/yz6572/task2/results/SA_TRUMP_PRE_105_91_TE_NT.dta", replace

timer off 4
timer list 4



