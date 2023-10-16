**********************************************************************
***	Replication File for "Inflammatory Political Campaigns and 
*** Racial Bias in Policing" by Pauline Grosjean, Federico Masera, and
*** Hasin Yousaf. For Publication at The Quarterly Journal of Economics
**********************************************************************

*** Define your own course directory.


ssc install reghdfe
ssc install ftools

timer on 2

set more off
cd "/home/yz6572/task2/do"

do "/home/yz6572/task2/do/TableA1.do"
do "/home/yz6572/task2/do/TableA2.do"
do "/home/yz6572/task2/do/TableA3.do"
do "/home/yz6572/task2/do/TableA4.do"
do "/home/yz6572/task2/do/TableA5.do"
do "/home/yz6572/task2/do/TableA6.do"
do "/home/yz6572/task2/do/TableA7.do"
do "/home/yz6572/task2/do/TableA8.do"
do "/home/yz6572/task2/do/TableA9.do"
do "/home/yz6572/task2/do/TableA10.do"
do "/home/yz6572/task2/do/TableA11.do"
do "/home/yz6572/task2/do/TableA12.do"
do "/home/yz6572/task2/do/TableA13.do"


do "/home/yz6572/task2/do/FigureA1.do"
do "/home/yz6572/task2/do/FigureA2.do"
do "/home/yz6572/task2/do/FigureA3.do"
do "/home/yz6572/task2/do/FigureA4.do"
do "/home/yz6572/task2/do/FigureA5.do"
do "/home/yz6572/task2/do/FigureA6.do"
do "/home/yz6572/task2/do/FigureA7.do"
do "/home/yz6572/task2/do/FigureA8.do"
do "/home/yz6572/task2/do/FigureA9.do"
do "/home/yz6572/task2/do/FigureA10.do"
do "/home/yz6572/task2/do/FigureA11.do"
do "/home/yz6572/task2/do/FigureA12.do"
do "/home/yz6572/task2/do/FigureA13.do"

timer off 2
timer list 2
