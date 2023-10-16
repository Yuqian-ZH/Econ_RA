
**********************************************************************
*** FIGURE 1
*** Counties with Campaign Events and Police Stops
**********************************************************************

shp2dta using "/home/yz6572/task2/data/county_shapefile/cb_2016_us_county_500k", replace data("/home/yz6572/task2/data/county_shapefile/county_data")  coor("/home/yz6572/task2/data/county_shapefile/county_coordinates")
use "/home/yz6572/task2/data/stoplevel_data.dta", clear

collapse trumpcounties, by(county_fips)
g stopsdata=1

merge n:1 county_fips using "/home/yz6572/task2/data/allcandidates_rallies.dta"
drop _merge
replace stopsdata=0 if stopsdata==.
replace trumpcounties=0 if trumpcounties==.
g stopsNtrump=(stopsdata==1 & trumpcounties==1)
g stopsNONtrump=(stopsdata==1 & trumpcounties==0)
g category=0 if stopsdata==0
replace category=1 if trumpcounties==1
replace category=2 if stopsNONtrump==1
g county_fips2=string(county_fips)
replace county_fips2="0"+county_fips2 if length(county_fips2)==4
drop if county_fips>72000
label define category 0 "Not In Sample" 1 "Stops Data with Trump Rally" 2 "Stops Data without Trump Rally", modify

g GEOID=string(county_fips)
replace GEOID="0"+GEOID if length(GEOID)==4
drop if county_fips>72000
merge 1:1 GEOID using "/home/yz6572/task2/data/county_shapefile/county_data"
replace category=0 if _merge==2
*keep if _merge==3
drop if STATEFP=="02" | STATEFP=="15" | STATEFP=="72" | STATEFP=="60" | STATEFP=="66" | STATEFP=="69" | STATEFP=="78"
keep county_fips category GEOID GEOID2 _ID

label values category category 
spmap category using "/home/yz6572/task2/data/county_shapefile/county_coordinates", id(_ID)          ///
        clmethod(unique) fcolor(Greys) ocolor(Black)                       ///
        legstyle(3) legend(ring(1) position(3))                          ///
        plotregion(margin(vlarge))  legenda(on) legtitle("Legend")
