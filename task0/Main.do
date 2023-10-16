**********************************************************************
***	Replication File for "Inflammatory Political Campaigns and 
*** Racial Bias in Policing" by Pauline Grosjean, Federico Masera, and
*** Hasin Yousaf. For Publication at The Quarterly Journal of Economics
**********************************************************************

*** Define your own course directory.

ssc install reghdfe
ssc install ftools

timer on 1

set more off
cd "/home/yz6572/task2/do"


do "/home/yz6572/task2/do/Table1.do"
do "/home/yz6572/task2/do/Table2.do"
do "/home/yz6572/task2/do/Table3.do"
do "/home/yz6572/task2/do/Table4.do"
do "/home/yz6572/task2/do/Table5.do"
do "/home/yz6572/task2/do/Table6.do"
do "/home/yz6572/task2/do/Table7.do"


do "/home/yz6572/task2/do/Figure1.do"
do "/home/yz6572/task2/do/Figure2.do"

timer off 1
timer list 1
