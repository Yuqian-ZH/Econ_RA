

**********************************************************************
*** FIGURE A4
*** Distribution of the Difference-in-Differences Effects
**********************************************************************

use "/home/yz6572/task2/data/county_day_data.dta", clear

keep if year==2015 | year==2016 | year==2017

rename TRUMP_POST_1_30  TRUMP_POST30
rename TRUMP_PRE_M30 TRUMP_PREM30
rename TRUMP_POST_M30 TRUMP_POSTM30

***number of counties 1,478
qui: {
forval ii = 1/1478 {
	su n_stops if county_id==`ii' & TRUMP_POST30==1
	if r(N) != 0 {
		total n_stops if county_id==`ii' & TRUMP_POST30==1
		global stops`ii' = _b[n_stops]
		g TREATED_COUNTY_`ii' = (county_id==`ii')
	}
}
}
**I drop the first for collinearity
drop TREATED_COUNTY_9

reghdfe black_ps  1.TRUMP_POST30 1.TRUMP_POST30#1.TREATED_COUNTY_* [w=n_stops], a(county_id  day_id  i.county_id#c.day_id TRUMP_PREM30 TRUMP_0 TRUMP_POSTM30) cluster(county_id day_id)

mat treat = 999* J(1478,2,1)

local numerator = 0
local denominator = 0
forval ii = 1/1478 {
qui: su n_stops if county_id==`ii' & TRUMP_POST30==1
	if r(N) != 0 {
		if `ii' == 9{
			mat treat[`ii',1] = (_b[1.TRUMP_POST30]) 
			mat treat[`ii',2] = (${stops`ii'})
			local numerator = `numerator' +  ((_b[1.TRUMP_POST30]) * ${stops`ii'})
			local denominator = `denominator' + ${stops`ii'}
		}
		else {
			mat treat[`ii',1] = (_b[1.TRUMP_POST30] + _b[1.TRUMP_POST30#1.TREATED_COUNTY_`ii']) 
			mat treat[`ii',2] = (${stops`ii'})
			local numerator = `numerator' +  ((_b[1.TRUMP_POST30] + _b[1.TRUMP_POST30#1.TREATED_COUNTY_`ii']) * ${stops`ii'})
			local denominator = `denominator' + ${stops`ii'}
		}
	}
}

local effect =  `numerator' / `denominator'

di `effect'

g yy = treat[_n,1] in 1/1478
g ww = treat[_n,2] in 1/1478
replace yy = . if yy==999
replace ww = . if ww==999

graph twoway (hist yy [fweight=ww] if yy>-10 & yy<10, frac xtitle("Treatment Effects")) (scatteri 0 1.053357 0.2 1.053357, recast(line) lw(0.5)), legend(label(1 "Distribution Effects") label(2 "Average Effect")) graphregion(color(white)) scheme(s1mono)
graph export "/home/yz6572/task2/results/figureA4.pdf", as(pdf) name("Graph") replace

keep yy ww
drop if yy==.
save "/home/yz6572/task2/results/SA.dta", replace

