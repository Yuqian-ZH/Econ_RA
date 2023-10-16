
**********************************************************************
*** TABLE 7
*** Role of Local Characteristics in the Effect of Trump Rallies on the Probability of a Black Stop
**********************************************************************

qui:{

import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="DRUG" | A=="CRIME" | A=="RAPE" | A=="CRIMIN" | A=="GUN" | A=="PRISON" | A=="RIOT" | A=="THUG" | A=="URBAN" | A=="AFRICAN"  | A=="BLACK" | A=="RACE" | A=="RACIAL" | A=="RACIST" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "ALL REFERENCES: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", replace dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Explicit+Implicit") label nonotes nocons noni

****explicit

import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="AFRICAN"  | A=="BLACK" | A=="RACE" | A=="RACIAL" | A=="RACIST"  | A=="totnonstopwords"
keep A v*


reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1


noisily: di "EXPLICIT REFERENCES"
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Explicit") label nonotes nocons noni



import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="DRUG" | A=="CRIME" | A=="RAPE" | A=="CRIMIN" | A=="GUN" | A=="PRISON" | A=="RIOT" | A=="THUG" | A=="URBAN" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "IMPLICIT: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Implicit") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="CHINA"  | A=="TRADE"  | A=="NAFTA" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "TRADE: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Trade") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="HILARI"  | A=="CLINTON"  | A=="EMAIL" | A=="LOCK" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "CLINTON: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Clinton") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="ISI" | A=="SYRIA" | A=="IRAQ" | A=="TERRORIST" | A=="AFGHANISTAN"  | A=="ISLAM" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "TERROR: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Terror") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="BUSI" | A=="JOB" | A=="MANUFACTUR" | A=="TAX" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "JOB: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Job") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="RIG" | A=="MEDIA" | A=="CNN" | A=="WASHINGTON" | A=="CORRUPT"  | A=="SWAMP" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off1 
replace bias_off1 = (bias_off1 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off1*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off1

noisily: di "CORRUPTION: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7A.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off1 TPXbias TPXbiasXnwords) addtext("Words","Corruption") label nonotes nocons noni







***********************************************************************************************************************************************************************************************************



**********************************************************************
*** TABLE 7
*** Role of Local Characteristics in the Effect of Trump Rallies on the Probability of a Black Stop
**********************************************************************

qui:{

import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="DRUG" | A=="CRIME" | A=="RAPE" | A=="CRIMIN" | A=="GUN" | A=="PRISON" | A=="RIOT" | A=="THUG" | A=="URBAN" | A=="AFRICAN"  | A=="BLACK" | A=="RACE" | A=="RACIAL" | A=="RACIST" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "ALL REFERENCES: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", replace dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Explicit+Implicit") label nonotes nocons noni

****explicit

import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="AFRICAN"  | A=="BLACK" | A=="RACE" | A=="RACIAL" | A=="RACIST"  | A=="totnonstopwords"
keep A v*


reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2


noisily: di "EXPLICIT REFERENCES"
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Explicit") label nonotes nocons noni



import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="DRUG" | A=="CRIME" | A=="RAPE" | A=="CRIMIN" | A=="GUN" | A=="PRISON" | A=="RIOT" | A=="THUG" | A=="URBAN" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "IMPLICIT: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Implicit") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="CHINA"  | A=="TRADE"  | A=="NAFTA" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "TRADE: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Trade") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="HILARI"  | A=="CLINTON"  | A=="EMAIL" | A=="LOCK" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "CLINTON: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Clinton") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="ISI" | A=="SYRIA" | A=="IRAQ" | A=="TERRORIST" | A=="AFGHANISTAN"  | A=="ISLAM" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "TERROR: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Terror") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if A=="BUSI" | A=="JOB" | A=="MANUFACTUR" | A=="TAX" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "JOB: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Job") label nonotes nocons noni


import excel "/home/yz6572/task2/data/wordcount-eachspeech-all.xlsx", sheet("Sheet1") firstrow clear
set obs 2655
replace A="totnonstopwords" in 2655
foreach v of varlist B-GI {
	egen totwordsX=total(`v')
    replace `v'=totwordsX in 2655
	drop totwordsX
}
foreach v of varlist B-GI {
   local x : variable label `v'
   rename `v' v`x'
   }
keep if  A=="RIG" | A=="MEDIA" | A=="CNN" | A=="WASHINGTON" | A=="CORRUPT"  | A=="SWAMP" | A=="totnonstopwords"
keep A v*

reshape long v, i(A) j(id)
sort id
by id: egen B = total(v) if A!="totnonstopwords"
by id: egen C = max(B)
keep if A=="totnonstopwords"
keep id v C
rename C A
replace A=0 if A==.
rename v totnonstopwords
rename A word
merge 1:1 id using "/home/yz6572/task2/data/speech_data.dta"
drop if _merge==2
replace totnonstopwords=-999 if totnonstopwords==0 | totnonstopwords==.
replace totwords=-999 if totnonstopwords==-999
g inspeechdata = (_merge==3)
drop state A _merge id
destring county_fips, replace
reshape wide word event_day_Trump_ totnonstopwords totwords inspeechdata, i(county_fips) j(rally_number)
drop if county_fips==.
egen inspeechdata=rowmax(inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9)
drop inspeechdata1 inspeechdata2 inspeechdata3 inspeechdata4 inspeechdata5 inspeechdata6 inspeechdata7 inspeechdata8 inspeechdata9 totwords*

merge 1:m county_fips using "/home/yz6572/task2/data/full_data_tomergewithspeech.dta"
keep if _merge!=1

*** event_day_Trump is missing if they are not in speech data, while dist_event & abs_dist_event are non-missing (because they are defined based on all rallies). 
	forval ee = 9(-1)1 {
		g abs_dist_event`ee' = abs(dist_event`ee')
		replace totnonstopwords`ee'=-999 if totnonstopwords`ee'==. & abs_dist_event`ee'!=.
	}
	
egen closestevent=rowmin(abs_dist_event1 abs_dist_event2 abs_dist_event3 abs_dist_event4 abs_dist_event5 abs_dist_event6 abs_dist_event7 abs_dist_event8 abs_dist_event9)
g nwords = .
	forval ee = 9(-1)1 {
		replace nwords = word`ee' if abs_dist_event`ee'==closestevent & totnonstopwords`ee'!=-999
	}

su nwords 
replace nwords = (nwords - r(mean)) / r(sd)

su bias_off2 
replace bias_off2 = (bias_off2 - r(mean)) / r(sd)

g TPXnwords = TRUMP_POST_1_30*nwords
replace TPXnwords = 0 if NEVER_TREATED==1

g TPXbiasXnwords=TRUMP_POST_1_30*bias_off2*nwords
replace TPXbiasXnwords = 0 if NEVER_TREATED==1

g TPXbias = TRUMP_POST_1_30 * bias_off2

noisily: di "CORRUPTION: "
noisily: reghdfe black 1.TRUMP_PRE_M30 1.TRUMP_0 1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords  1.TRUMP_POST_M30, a(i.county_id i.day_id i.county_id#c.day_id) cluster(county_id day_id)
outreg2 using "/home/yz6572/task2/results/Table7B.txt", append dec(3) keep(1.TRUMP_POST_1_30 TPXnwords bias_off2 TPXbias TPXbiasXnwords) addtext("Words","Corruption") label nonotes nocons noni

}

}
