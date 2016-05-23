freduse GDPC1
gen dd=yq(year(daten), quarter(daten))
tsset dd, quarterly
* Compute annualized quarterly growth:
gen ann_growth = ((GDPC1/l.GDPC1)^4-1)*100
* Generate variables for observation tagging:
gen quarter = substr(date,6,2)
gen q1 = (quarter == "01")
gen year = substr(date,1,4)
destring year, replace

* Compute average growth rates in Q1 and the remainder of each year
egen avg = mean(ann_growth), by(year q1)
collapse (mean) ann_growth, by(year q1)

* Reshape the dataset in order for each row to correspond to ONE year
reshape wide ann_growth, i(year) j(q1)

* Set a new indicator variable equal to 1 if Q1 is slower than Q2-Q4 in the given year

gen q1SlowerThanRest = (ann_growth1 < ann_growth0) if ~missing(ann_growth0)

keep if year >=1960
gen decade=year
recode decade (1960/1969 = 1960) ///
(1970/1979 = 1970) ///
(1980/1989 = 1980) ///
(1990/1999 = 1990) ///
(2000/2009 = 2000) ///
(2010/2016 = 2010)

* Count the number of times Q1 was slower since 2000
tabstat q1Slower if year>=2000, stat(sum)
* Count the number of time Q1 was slower since 2000 
tabstat q1Slower, by(decade) stat(sum)
* Calculate the share of such years, by decade
tabstat q1Slower, by(decade) stat(mean)
