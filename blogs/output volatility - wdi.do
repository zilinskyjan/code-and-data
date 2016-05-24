* Purpose: Calculate rolling GDP growth and output growth volatility from WDI database
* Code: Jan Zilinsky

* Download data:
wbopendata, language(en - English) country() topics() indicator(NY.GDP.MKTP.KD.ZG) long
keep if countrycode=="WLD"
drop if ny==.
tsset year

* Calculate world-wide 5-year rolling windows:
rolling FiveYrSD = r(sd) FiveYrAverageGDPgrowth = r(mean), window(5) step(1) keep(countrycode) clear: summarize ny

* Connected scatterplot
scatter FiveYrSD FiveYrAverageGDPgrowth if end>=2005, ///
mlab(end) connect(l) mlabpos(12) ///
title("Global growth and output volatility") ///
xtitle("Average GDP growth over the preceding 5 years") ytitle("Std. deviation of growth over the preceding 5 years") ///
graphregion(color(white)) ///
xsize(12) ysize(8) name(g_globa_line, replace)	
graph export "H:\temp\WorldScatter.png", width(1600) replace


***********
* USA CHART
***********

clear
wbopendata, language(en - English) country() topics() indicator(NY.GDP.MKTP.KD.ZG) long
drop if region=="Aggregates"
egen c_id = group(countrycode)
tsset c_id year
keep if year >=1997

rolling FiveYrSD = r(sd) FiveYrAverageGDPgrowth = r(mean), window(5) step(1) keep(countrycode) clear: summarize ny

tsset c_id end
* Line chart
tsline FiveYrAverage FiveYrSD if date=="USA" & tin(1997,2014), ///
	xtitle("Year") ytitle("") ///
	lw(1.2 1.2) ///
	title("5-year indicators",pos(11)) ///
	legend(ring(0) pos(2) rows(2) label(1 "Average GDP growth over the preceding 5 years") label(2 "Std. deviation of growth over the preceding 5 years")) ///
	graphregion(color(white)) ///
	xsize(10) ysize(7) name(g_sd_gdp, replace)	
graph export "H:\temp\US_5yr.png", replace


******************
* EAST EUROPE ONLY
******************

clear
wbopendata, language(en - English) country() topics() indicator(NY.GDP.MKTP.KD.ZG) long
egen c_id = group(countrycode)
tsset c_id year
keep if year >=1997
keep if inlist(countrycode,"SVK","POL","CZE","HUN")


rolling FiveYrSD = r(sd) FiveYrAverageGDPgrowth = r(mean), window(5) step(1) keep(countrycode) clear: summarize ny

* Change dataset share; long -> wide
drop c_id
reshape wide Five*, i(end) j(date) string

* Calculate the average for the 4 EE countries:
egen ee_avg = rowmean(FiveYrSDCZE FiveYrSDHUN FiveYrSDPOL FiveYrSDSVK)

tsset end

tsline ee_avg FiveYrSDCZE FiveYrSDHUN FiveYrSDSVK FiveYrSDPOL if tin(1997,2014), ///
	xtitle("Year") ytitle("Growth volatility") ///
	title("5-year std. deviation of GDP growth") ///
	lcolor(ebblue black gs6 gs11 red) ///
	lwidth(*2.5 *1 *1 *.9 *1.5) ///
	lpattern(solid solid dash solid dash) ///
	legend(ring(0) pos(10) rows(5) label(1 "EE average")) ///
	graphregion(color(white)) ///
	xsize(10) ysize(7.5) name(g_sd, replace)	
graph export "H:\temp\sd_ee2.png", replace

