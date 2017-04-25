* Purpose: compute annualized (real) average growth rates

* Download data from the OECD site
* My preference: get data in local (constant!) currency to avoid dealing w/ exchagne rate movements
* The 2000-15 table was available at this url as of 4/21/17: https://stats.oecd.org/Index.aspx?DataSetCode=AV_AN_WAGE

import excel "OECD2015.xlsx", sheet("OECD") firstrow

gen wgrowth1215 = (y2015/y2012)^(1/3)-1
gen wgrowth0912 = (y2012/y2009)^(1/3)-1
gen wgrowth0006_precrisis = (y2006/y2000)^(1/6)-1
gen wgrowth0815_post_crisis = (y2015/y2008)^(1/7)-1

label var wgrowth1215 "Real wage growth (2012-15)" 
label var wgrowth0912 "Real wage growth (2009-12)" 
label var wgrowth0006_precrisis "Real wage growth (2000-06)"
label var wgrowth0815_post_crisis "Real wage growth (2008-15)"

keep country w*
save "wages_annualized.dta", replace
export delimited using "wages_annualized.csv", replace

