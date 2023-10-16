
**********************************************************************
*** FIGURE A3
*** Distribution of Weights of the Difference-in-Differences Estimator
**********************************************************************

use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

egen county_id = group(county_fips)
g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
*
g TRUMP_POST30 = 0
forval ii = 1/9 {
replace TRUMP_POST30 = 1 if  (dist_event`ii' >= 1 & dist_event`ii'<=30 & dist_event`ii'!=.)
}
g TRUMP_PREM30 = 0
forval ii = 1/9 {
replace TRUMP_PREM30 = 1 if  (dist_event`ii' < -30 & dist_event`ii'!=.)
}
g TRUMP_POSTM30 = 0
forval ii = 1/9 {
replace TRUMP_POSTM30 = 1 if  (dist_event`ii' > 30 & dist_event`ii'!=.)
}

forval i = 1/1478 {
    g trend_`i' = (county_id==`i') * day_id
}
twowayfeweights black_ps county_id day_id TRUMP_POST30, type(feTR) controls(TRUMP_PREM30 TRUMP_0 TRUMP_POSTM30 trend_*) path("/home/yz6572/task2/results/weights_u")

use "/home/yz6572/task2/results/weights_u",clear
hist weight if weight!=0, graphregion(color(white)) bin(50) percent graphregion(color(white)) scheme(s1mono)
graph export "/home/yz6572/task2/results/figureA3A.pdf", as(pdf) name("Graph") replace

***
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

g n_stops = 1
foreach var of varlist black hispanic white api {
	replace `var' = `var'/100
}

collapse (sum) n_stops black (first) dist_event* year , by(county_fips day_id)

g black_ps = black / n_stops
keep if year==2015 | year==2016 | year==2017

egen county_id = group(county_fips)

g TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}
*
g TRUMP_POST30 = 0
forval ii = 1/9 {
replace TRUMP_POST30 = 1 if  (dist_event`ii' >= 1 & dist_event`ii'<=30 & dist_event`ii'!=.)
}
g TRUMP_PREM30 = 0
forval ii = 1/9 {
replace TRUMP_PREM30 = 1 if  (dist_event`ii' < -30 & dist_event`ii'!=.)
}
g TRUMP_POSTM30 = 0
forval ii = 1/9 {
replace TRUMP_POSTM30 = 1 if  (dist_event`ii' > 30 & dist_event`ii'!=.)
}

forval i = 1/1478 {
    g trend_`i' = (county_id==`i') * day_id
}
twowayfeweights black_ps county_id day_id TRUMP_POST30, type(feTR) controls(TRUMP_PREM30 TRUMP_0 TRUMP_POSTM30 trend_*) weight(n_stops) path("/home/yz6572/task2/results/weights_w")

use "/home/yz6572/task2/results/weights_w",clear
hist weight if weight!=0 & weight<0.0005, graphregion(color(white)) bin(50) percent graphregion(color(white)) scheme(s1mono)
graph export "/home/yz6572/task2/results/figureA3B.pdf", as(pdf) name("Graph") replace
