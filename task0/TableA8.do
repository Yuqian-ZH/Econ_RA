
**********************************************************************
*** TABLE A8
*** Driver Behavior: Rectangular Panel
**********************************************************************

use "/home/yz6572/task2/data/fars_data.dta", clear 

egen county_id=group(county_fips)
drop if county_id==.
drop if date==.

xtset county_id date 

tsfill, full
sort county_id date 

bysort county_id: egen county_fips2 = mean(county_fips)
replace county_fips = county_fips2
drop county_fips2

foreach var of varlist incidents Fatal Violation Drug FatalViolation FatalDrug Black Mexican MexicanViolation MexicanDrug  Asian BlackViolation BlackDrug Hispanic HispanicViolation HispanicDrug  White {
	replace `var' = 0 if `var'==.
}

sort county_fips date
forval ii=1/9 {
	by county_fips: egen event_day_Trump2_`ii' = mean(event_day_Trump_`ii')
	replace event_day_Trump_`ii' = event_day_Trump2_`ii'
}

forval ii = 1/9 {
	g dist_event`ii' = date - event_day_Trump_`ii'
} 
 
replace TRUMP_0 = 0
forval ii = 1/9 {
replace TRUMP_0 = 1 if dist_event`ii' == 0
}

replace TRUMP_POST_1_30 = 0
forval ii = 1(1)9{ 
	forval ee = 1/9 {
		replace TRUMP_POST_1_30 = 1 if (dist_event`ee' >=1 & dist_event`ee'<=30 & dist_event`ee'!=.)
	}	
}

replace TRUMP_POST_M30 = 0
forval ii = 1(1)9{ 
	forval ee = 1/9 {
		replace TRUMP_POST_M30 = 1 if (dist_event`ee' >=31 & dist_event`ee'!=.)
	}	
}

replace TRUMP_PRE_M30 = 0
forval ii = 1(1)9{ 
	forval ee = 1/9 {
		replace TRUMP_PRE_M30 = 1 if (dist_event`ee' <=-31 & dist_event`ee'!=.)
	}	
}

replace nonblack=Fatal-Black

replace ihsblack=100*log(Black+(Black^2+1)^0.5)
replace ihsfatal=100*log(Fatal+(Fatal^2+1)^0.5)
replace ihsfatalviolation=100*log(FatalViolation+(FatalViolation^2+1)^0.5)
replace ihsfataldrug=100*log(FatalDrug+(FatalDrug^2+1)^0.5)
replace ihsnonblack=100*log(nonblack+(nonblack^2+1)^0.5)
replace ihswhite=100*log(White+(White^2+1)^0.5)
replace ihsmexican=100*log(Mexican+(Mexican^2+1)^0.5)
replace ihshispani=100*log(Hispanic+(Hispanic^2+1)^0.5)
replace ihsBlackViolation=100*log(BlackViolation+(BlackViolation^2+1)^0.5)
replace ihsBlackDrug=100*log(BlackDrug+(BlackDrug^2+1)^0.5)
foreach x in Violation Drug incidents HispanicViolation HispanicDrug MexicanViolation MexicanDrug{
replace ihs`x'=100*log(`x'+(`x'^2+1)^0.5)
}

reghdfe ihsinc  1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_PRE_M30 1.TRUMP_POST_M30, a(i.county_fips i.date) cluster(county_fips date)
outreg2 using "/home/yz6572/task2/results/TableA8.txt", replace keep(1.TRUMP_POST_1_30) dec(3) nocons

foreach y in ihsfatal ihsfatalviolation ihsblack ihsnonblack ihswhite ihshispani ihsmexican {
	reghdfe `y' 1.TRUMP_0 1.TRUMP_POST_1_30 1.TRUMP_PRE_M30 1.TRUMP_POST_M30 ihsincidents, a(i.county_fips i.date) cluster(county_fips date)
outreg2 using "/home/yz6572/task2/results/TableA8.txt", append keep(1.TRUMP_POST_1_30) dec(3) nocons

}
summ ihsinc ihsfatal ihsfatalviolation ihsblack ihsnonblack ihswhite ihshispani ihsmexican
