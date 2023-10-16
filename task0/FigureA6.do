
**********************************************************************
*** FIGURE A6
*** Permutation Inference
**********************************************************************

use "/home/yz6572/task2/data/county_day_data.dta", clear

keep if year==2015 | year==2016 | year==2017
drop year TRUMP_*

***number of counties 1,478
***number of rallies 196
g FAKE_EFFECT = .
forval iter = 1/1000 {
    di "ITERATION " `iter'
	qui: {
	g random_date = floor(runiform(20256,20765))
	g random_order = runiform()
	g random_county = floor(runiform(1,1479))
	sort random_order
	
	g FAKE_event_day_Trump_1 = .
	g FAKE_event_day_Trump_2 = .
	g FAKE_event_day_Trump_3 = .
	g FAKE_event_day_Trump_4 = .
	g FAKE_event_day_Trump_5 = .
	g FAKE_event_day_Trump_6 = .
	g FAKE_event_day_Trump_7 = .
	g FAKE_event_day_Trump_8 = .
	g FAKE_event_day_Trump_9 = .
	
	forval ii=1/196 {
	    local completed = 0
		local counter = 1
	    while `completed' == 0 {
		    
		    su FAKE_event_day_Trump_`counter' if county_id == random_county[`ii']
			
			if r(N) == 0 {
				replace FAKE_event_day_Trump_`counter' = random_date[`ii'] if county_id==random_county[`ii']
				local completed = 1
				}
			else {
			    local counter = `counter' + 1
			}
		}
	}

	
	forval ii = 1/9 {
		g dist_event`ii' = day_id - FAKE_event_day_Trump_`ii'
	} 
	
	g TRUMP_0 = 0
	forval ii = 1/9 {
	replace TRUMP_0 = 1 if dist_event`ii' == 0 & dist_event`ii'!=.
	}
	*
	
	g TRUMP_POST_1_30 = 0
	forval ii = 1/9 {
	replace TRUMP_POST_1_30 = 1 if (dist_event`ii' > 0 & dist_event`ii'<=30 & dist_event`ii'!=.)
	}
	
	
	g TRUMP_POST_M30 = 0
	forval ii = 1/9 {
	replace TRUMP_POST_M30 = 1 if (dist_event`ii' >30 & dist_event`ii'!=.)
	}
	
	g TRUMP_PRE_M30 = 0
	forval ii = 1/9 {
	replace TRUMP_PRE_M30 = 1 if (dist_event`ii' <-30 & dist_event`ii'!=.)
	}
		
	reghdfe black_ps 1.TRUMP_*  [w=n_stops], a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
	replace FAKE_EFFECT = _b[1.TRUMP_POST_1_30] in `iter'
	
	drop FAKE_event_day_Trump_* random_* dist_event* TRUMP_*
	}
}

drop if FAKE_EFFECT == .

hist FAKE_EFFECT if FAKE_EFFECT>-1.5 & FAKE_EFFECT<2, xline(1.07, lwidth(1)) percent xtitle("Coefficient on Fake Trump Rally")  xlabel(-1.5(0.5)2) graphregion(color(white)) scheme(s1mono)
graph export "/home/yz6572/task2/results/FigureA6.pdf", as(pdf) name("Graph") replace
