
**********************************************************************
*** TABLE A13
*** Correlations Between Trumps' Rally Speech and County Covariates
**********************************************************************

use "/home/yz6572/task2/data/speech_countydata.dta", clear

foreach y in Explicit Implicit  trade clinton terror business corruption {
	gen ihs`y'= log(`y'+(`y'^2+1)^0.5)
	reg ihs`y' racial_resent_asd racial_resent_bsd any_slaves_1860 cottonmeansd bexecrtsd blynchtsd  popsd  dem_psd rep medianincomesd collsd d_tradeusch_pwsd $miss, rob 
	xi: outreg2 racial_resent_asd racial_resent_bsd any_slaves_1860 cottonmeansd bexecrtsd blynchtsd   dem_psd rep medianincomesd collsd d_tradeusch_pwsd  using "/home/yz6572/task2/results/TableA13.xls", se bdec(3) sdec(3) rdec(3)  coefastr alpha(0.01, 0.05, 0.10)  symbol(***, **, *)  nocons   bfmt(fc) append

}




