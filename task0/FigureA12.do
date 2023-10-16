
**********************************************************************
*** FIGURE A12
*** Geographic Spillovers
**********************************************************************

use "/home/yz6572/task2/data/distance_spillovers_004.dta", clear

g black_ps = black / n_stops

mat treat = J(15,4,1)

qui:{
forval kk = 10(10)150 {

noisily: di `kk' "km out of 150"

g TRUMP_POST_1_30_`kk'km = 0
forval ii = 1/30 {
replace TRUMP_POST_1_30_`kk'km = 1 if (dist_event_`kk'km_`ii' > 0 & dist_event_`kk'km_`ii'<=30 & dist_event_`kk'km_`ii'!=.)
}
g TRUMP_POST_M30_`kk'km = 0
forval ii = 1/30 {
replace TRUMP_POST_M30_`kk'km = 1 if (dist_event_`kk'km_`ii' >30 & dist_event_`kk'km_`ii'!=.)
}

g TRUMP_PRE_M30_`kk'km = 0
forval ii = 1/30 {
replace TRUMP_PRE_M30_`kk'km = 1 if (dist_event_`kk'km_`ii' <-30 & dist_event_`kk'km_`ii'!=.)
}


noisily: reghdfe black_ps 1.TRUMP_*_`kk'km   [w=n_stops], a(i.county_id i.day_id  i.county_id#c.day_id) cluster(county_fips day_id )


lincom (1.TRUMP_POST_1_30_`kk'km)  

local pos = `kk'/10
mat treat[`pos',1] = `kk'
mat treat[`pos',2] = r(estimate)
mat treat[`pos',3] = r(estimate) +  r(se)*invttail(e(N),0.025)
mat treat[`pos',4] = r(estimate) -  r(se)*invttail(e(N),0.025)

}
} 
g xx = treat[_n,1] in 1/15

g eff = treat[_n,2] in 1/15
g eff10 = treat[_n,3] in 1/15
g eff90 = treat[_n,4] in 1/15

twoway (rcap eff10 eff90 xx) (scatter eff xx,yline(0,lp(-) lc(red))) , scheme(s1mono) title(" ") ytitle("Effect of Trump Rally") xtitle(Distance in Km) xlabel(10 "(0,10)"  20 "(0,20)"  30 "(0,30)"  40 "(0,40)"  50 "(0,50)" 60 "(0,60)" 70 "(0,70)" 80 "(0,80)" 90 "(0,90)" 100 "(0,100)" 110 "(0,110)" 120 "(0,120)" 130 "(0,130)" 140 "(0,140)" 150 "(0,150)", angle(45)) legend(order(1 "95% Confidence Interval" 2 "Effect"))
graph export "/home/yz6572/task2/results/FigureA12.pdf", as(pdf) name("Graph") replace
