/* How data was generated: 
global dir_rec "--specify path here--"
replace country = "Slovak Republic" if country=="Slovakia"
gen gdpbase = y2007
gen gr00to07 = (y2007/y2000-1)*100
gen gr08to15 = (y2015/y2007-1)*100
gen gr00to07ANN = (((y2007/y2000)^(1/7))-1)*100
gen gr08to15ANN = (((y2015/y2007)^(1/7))-1)*100
*merge 1:1 country using "$dir_rec\resources\ECON_DATA.dta", keepusing(euroarea) keep(1 3)
reshape long y, i(country) j(year)
rename y gdp
replace country = "U.K." if country=="United Kingdom"
replace country = "Slovakia" if country == "Slovak Republic"
egen c_id = group(country)
tsset c_id year
gen gdpindex=(gdp/gdpbase)*100
keep if year >=2007
*/

import delimited "https://raw.githubusercontent.com/zilinskyjan/datasets/master/blogs/EU-recovery/recovery_ameco-based-gdp.csv"

gen show = (euroarea==1)
gen show2 = (country != "EA")
	
sort country year


	local lines1 ""
	levelsof country if show==1, local(countries1)
	foreach y of local countries1 {
		local lines1 "`lines1' (line gdpindex year if country=="`y'", lcolor(gs10) lwidth(vthin))"
	}
	
	egen maxyears=max(year) if !missing(gdpindex)
	twoway ///
		`lines1' ///
		(line gdpindex year if country=="EA", lcolor(navy) lwidth(*2.5)) ///
		(line gdpindex year if country=="Greece", lcolor(red) lwidth(*1.5)) ///
		(line gdpindex year if country=="Malta", lcolor(midgreen) lwidth(*1.5)) ///
		(scatter gdpindex year if year==maxyears & country=="EA", mlab(country) mlabcolor(navy) mcolor(navy)) ///
		(scatter gdpindex year if year==maxyears & country=="Italy", mlab(country) mlabcolor(gs8) mcolor(gs9)) ///
		(scatter gdpindex year if year==maxyears & country=="Greece", mlab(country) mlabcolor(red) mcolor(red)) ///
		(scatter gdpindex year if year==maxyears & country=="Germany", mlab(country) mlabcolor(gs8) mcolor(gs9)) ///
		(scatter gdpindex year if year==maxyears & country=="Malta", mlab(country) mlabcolor(midgreen) mcolor(midgreen)) ///
		(scatter gdpindex year if year==maxyears & country=="Slovak Republic", mlab(country) mlabcolor(gs8) mcolor(gs9)) ///
		, ///
		plotregion(margin(r=12)) ///
		graphregion(color(white)) ///
		xlabel(2007(2)2015) ///
		xtitle("Year",placement(se)) ///
		ylabel(,angle(0)) ///
		ytitle("Real GDP" "2007=100") ///
		title("Cumulative change of real GDP since 2007",pos(12) size(*.9)) ///
		subtitle("Euro area countries only", pos(12)) ///
		legend(off) xsize(12) ysize(10) name(g_gdp_ea, replace)		
	graph save "H:\temp\chart-ea.gph", replace
	graph export "H:\temp\chart-ea.png", replace
	drop maxyears
	

* SHOW all EU countries
	
	local lines2 ""
	levelsof country if show2==1, local(countries)
	foreach y of local countries {
		local lines2 "`lines2' (line gdpindex year if country=="`y'", lcolor(gs10) lwidth(vthin))"
	}
	
	bysort country: egen maxyears=max(year) if !missing(gdpindex) /* must do this for each country, in case some have missing latest data */
	twoway ///
		`lines2' ///
		(line gdpindex year if country=="EU", lcolor(navy) lwidth(*2.5)) ///
		(line gdpindex year if country=="Poland", lcolor(orange) lwidth(*1.5)) ///
		(line gdpindex year if country=="Croatia", lcolor(purple) lwidth(*1.5)) ///
		(scatter gdpindex year if year==maxyears & country=="EU", mlab(country) mlabcolor(navy) mcolor(navy*.5)) ///
		(scatter gdpindex year if year==maxyears & country=="Poland", mlab(country) mlabcolor(orange) mcolor(orange*.5)) ///
		(scatter gdpindex year if year==maxyears & country=="U.K.", mlab(country) mlabcolor(gs7) mcolor(gs9)) ///
		(scatter gdpindex year if year==maxyears & country=="Greece", mlab(country) mlabcolor(gs7) mcolor(gs9)) ///
		(scatter gdpindex year if year==maxyears & country=="Denmark", mlab(country) mlabcolor(gs7) mcolor(gs9)) ///
		(scatter gdpindex year if year==maxyears & country=="Croatia", mlab(country) mlabcolor(purple) mcolor(purple*.5)) ///
		, ///
		plotregion(margin(r=12)) ///
		xlabel(2007(2)2015) ///
		graphregion(color(white)) ///
		xtitle("Year",placement(se)) ///
		ylabel(,angle(0)) ///
		ytitle("Real GDP" "2007=100") ///
		title("Cumulative change of real GDP since 2007",pos(12) size(*.9)) ///
		subtitle("All EU countries", pos(12)) ///
		legend(off) xsize(12) ysize(10) name(g_gdp_eu, replace)		
	graph save "H:\temp\chart-EU.gph", replace
	graph export "H:\temp\chart-EU.png", replace
	drop maxyears

	
* EU DOT CHART

graph dot (asis) gr00to07a gr08to15a if year==2015 & euroarea==1, over(country, sort(gr00to07a) descending) ///
ytitle("Annual real GDP growth (percent)") ///
title("Pre-crisis and post-crisis growth in the euro area") ///  
graphregion(color(white)) nofill ///  
marker(1,mcolor(purple*.65) msize(*1.3)) ///  
marker(2,mcolor(orange*.76) msize(*1.3)) ///  
legend(label(1 "2000-07") label(2 "2008-15") order(2 1) rows(1) pos(12) region(lcolor(white)) size(*1.2)) ///
xsize(13) ysize(10)
graph save "H:\temp\dot-eu.gph", replace
graph export "H:\temp\dot-eu.png", replace 

* A LONG DOT PLOT (nearly all EU countries)

drop if country=="Czech Republic"
* CZE does not year have 2015 data
graph dot (asis) gr00to07a gr08to15a if year==2015, over(country, sort(gr00to07a) descending) ///
ytitle("Annual real GDP growth (percent)") ///
title("Annual pre-crisis and post-crisis Real GDP growth" "Performance comparison of EU economies", size(small)) ///  
graphregion(color(white)) nofill ///  
marker(1,mcolor(green*.65) msize(*1.3)) ///  
marker(2,mcolor(red*.76) msize(*1.3)) ///  
legend(label(1 "2000-07") label(2 "2008-15") order(2 1) rows(1) pos(12) region(lcolor(white)) size(*1.2)) ///
xsize(14) ysize(20)
graph save "H:\temp\dot-euxx.gph", replace
graph export "H:\temp\RT-Figure3-blog.png", width(1600) replace 
