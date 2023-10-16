use "/home/yz6572/task2/data/allcandidates_words.dta", clear

egen race2=rowtotal(racial   race )
egen Race=rowtotal(race2  black african)

egen Crime2=rowtotal(crime   crimin)
 egen Crime=rowtotal(Crime2  drug    rape)
 egen Crime_strict=rowtotal(Crime2      rape)
gen Drug = drug


egen Terrorism =rowtotal(afghanistan  iraq  isi  isis  islam  jihad  syria  syrian  terror   terrorist )

egen Business=rowtotal(busi   businessman   businessmen   businesspeopl   job   tax  manufactur   manufacturing)

egen Corruption =rowtotal(rig   cnn   swamp   media   corrupt   washington)

egen Trade =rowtotal(trade   china   nafta )
 
egen Mexico =rowtotal(mexican   mexico )

egen OtherRace  =rowtotal(gun    prison   riot   thug    urban  )

egen Migration =rowtotal(migration   migrat   immigr   migrat )

egen Police =rowtotal( polic  policemen  police )



egen Clinton = rowtotal (hilari hillari  clinton  email lock)

egen Implicit = rowtotal (crime   crimin  drug    rape  gun prison riot thug urban) 
egen Allreferences=rowtotal(Implicit  Race ) 

bysort candidate: su Allreferences Implicit Race  Clinton  Trade Terrorism Business Corruption 


preserve
keep if candidate =="trump" 
pwcorr Mexi Implicit
su Implicit if Mexic>0
su Implicit if Mexic==0
gen D_Mexico=(Mexic>0)
gen D_Implicit=(Implicit>0)

restore 


foreach var of varlist Allreferences Implicit  race2 Race Crime2 Crime Crime_strict Drug Terrorism Business Corruption Trade Mexico OtherRace Migration Police {
	gen p`var'=(`var'/tot_words)*100
}

ren democrat democrat_trumpsp

gen democrat=.
replace democrat=0 if candidate == "mccain"|candidate == "romney"|candidate  == "cruz"   |candidate == "trump"  
replace democrat=1 if candidate == "clinton"  


gen pres_candidate_plot = . 
replace pres_candidate_plot = 5 if candidate == "trump"  
replace pres_candidate_plot = 4 if candidate  == "cruz"   
replace pres_candidate_plot = 3 if candidate  == "clinton"  
replace pres_candidate_plot = 2 if candidate == "romney"
replace pres_candidate_plot = 1 if candidate == "mccain"

label define pres_candidates  5 "Donald Trump (2016)" 4 "Ted Cruz (2016)" 3 "Hillary Clinton (2016)" 2 "Mitt Romney (2012)" 1 "John McCain (2008)"  

cap drop coef* se* 
cap drop  u_coef* l_coef*

foreach x of varlist Allreferences Implicit  race2 Race Crime2 Crime Crime_strict Drug Terrorism Business Corruption Trade Mexico OtherRace Migration Police  {

	bysort candidate: egen m`x'=mean(`x')
	bysort candidate: egen sd`x'=sd(`x')

	gen coef`x'=.
	gen se`x'=.

	bysort candidate: replace coef`x'=m`x'
}

	foreach x of varlist Allreferences Implicit  race2 Race Crime2 Crime Crime_strict Drug Terrorism Business Corruption Trade Mexico OtherRace Migration Police  {
replace se`x'=(1.960*sd`x')/13.78 if candidate=="trump"
replace se`x'=(1.960*sd`x')/2.45 if candidate=="cruz"
replace se`x'=(1.960*sd`x')/13.93 if candidate=="clinton"
replace se`x'=(1.960*sd`x')/10.05 if candidate=="romney"
replace se`x'=(1.960*sd`x')/13.229 if candidate=="mccain"
	}
		
	collapse (mean) coef* democrat  se*,  by(pres_candidate_plot candidate)

foreach x in Allreferences Implicit  race2 Race Crime2 Crime Crime_strict Drug Terrorism Business Corruption Trade Mexico OtherRace Migration Police {
*foreach x of varlist  addict-weapon race2 race3  Race Crime Mexico Migration Crime2{
	bysort candidate:  gen u_coef`x' = coef`x' + se`x'
	bysort candidate:  gen l_coef`x' = coef`x' - se`x'
}

label values pres_candidate_plot pres_candidates 

* Do plot
foreach x in Allreferences Implicit  Race Crime  {
	*foreach x of varlist  addict-weapon race2 race3   Race Crime Mexico Migration Crime2{
	
twoway (bar coef`x' pres_candidate_plot if democrat == 0, bcolor(black) ///
	barwidth(0.9) horizontal) (bar coef`x' pres_candidate_plot if democrat == 1, ///
	lcolor(black) fcolor(white) lwidth(medthick) barwidth(0.9) horizontal) (rcap l_coef`x' u_coef`x' ///
	pres_candidate_plot, horizontal lcolor(black)) , xlabel(0(3)12) ylabel(1(1)5, ///
	angle(horizontal) valuelabel labsize(*.8))  ytitle("") legend(off) ///
			title("Mentions of words: `x'", size(medium) color(black)) ///
	graphregion(fcolor(white) lcolor(white))

graph save /home/yz6572/task2/results/`x'_words.gph, replace 
graph export /home/yz6572/task2/results/`x'_words.eps, replace 

	}

twoway (bar coefAllreferences pres_candidate_plot if democrat == 0, bcolor(black) ///
	barwidth(0.9) horizontal) (bar coefAllreferences pres_candidate_plot if democrat == 1, ///
	lcolor(black) fcolor(white) lwidth(medthick) barwidth(0.9) horizontal) (rcap l_coefAllreferences u_coefAllreferences ///
	pres_candidate_plot, horizontal lcolor(black)) , xlabel(0(3)12) ylabel(1(1)5, ///
	angle(horizontal) valuelabel labsize(*.8))  ytitle("") legend(off) ///
			title("Explicit and Implicit Racial Mentions", size(medium) color(black)) ///
	graphregion(fcolor(white) lcolor(white))

graph save /home/yz6572/task2/results/Allreferences_words.gph, replace 
graph export /home/yz6572/task2/results/Allreferences_words.eps, replace 

twoway (bar coefImplicit pres_candidate_plot if democrat == 0, bcolor(black) ///
	barwidth(0.9) horizontal) (bar coefImplicit pres_candidate_plot if democrat == 1, ///
	lcolor(black) fcolor(white) lwidth(medthick) barwidth(0.9) horizontal) (rcap l_coefImplicit u_coefImplicit ///
	pres_candidate_plot, horizontal lcolor(black)) , xlabel(0(3)12) ylabel(1(1)5, ///
	angle(horizontal) valuelabel labsize(*.8))  ytitle("") legend(off) ///
			title("Implicit Racial Mentions", size(medium) color(black)) ///
	graphregion(fcolor(white) lcolor(white))

graph save /home/yz6572/task2/results/Implicit_words.gph, replace 
graph export /home/yz6572/task2/results/Implicit_words.eps, replace 

twoway (bar coefRace pres_candidate_plot if democrat == 0, bcolor(black) ///
	barwidth(0.9) horizontal) (bar coefRace pres_candidate_plot if democrat == 1, ///
	lcolor(black) fcolor(white) lwidth(medthick) barwidth(0.9) horizontal) (rcap l_coefRace u_coefRace ///
	pres_candidate_plot, horizontal lcolor(black)) , xlabel(0(3)12) ylabel(1(1)5, ///
	angle(horizontal) valuelabel labsize(*.8))  ytitle("") legend(off) ///
			title("Explicit Racial Mentions", size(medium) color(black)) ///
	graphregion(fcolor(white) lcolor(white))

graph save /home/yz6572/task2/results/Race_words.gph, replace 
graph export /home/yz6572/task2/results/Race_words.eps, replace 

twoway (bar coefCrime_strict pres_candidate_plot if democrat == 0, bcolor(black) ///
	barwidth(0.9) horizontal) (bar coefCrime_strict pres_candidate_plot if democrat == 1, ///
	lcolor(black) fcolor(white) lwidth(medthick) barwidth(0.9) horizontal) (rcap l_coefCrime_strict u_coefCrime_strict ///
	pres_candidate_plot, horizontal lcolor(black)) , xlabel(0(3)12) ylabel(1(1)5, ///
	angle(horizontal) valuelabel labsize(*.8))  ytitle("") legend(off) ///
			title("Crime", size(medium) color(black)) ///
	graphregion(fcolor(white) lcolor(white))

graph save /home/yz6572/task2/results/Crime_strict_words.gph, replace 
graph export /home/yz6572/task2/results/Crime_strict_words.eps, replace 
	
		graph combine /home/yz6572/task2/results/Allreferences_words.gph  /home/yz6572/task2/results/Race_words.gph  /home/yz6572/task2/results/Implicit_words.gph /home/yz6572/task2/results/Crime_strict_words.gph   , scheme(s1mono)
	
	graph export /home/yz6572/task2/results/FigureA1.pdf, replace 
	graph export /home/yz6572/task2/results/FigureA1.png, replace 
		
