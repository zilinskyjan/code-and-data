import delimited "https://raw.githubusercontent.com/zilinskyjan/datasets/master/fiscal/public%20debt%20postcrisis.csv"

histogram debt_2015, bin(22) frequency fcolor(teal) lcolor(gs16) ///
xtitle("Debt to GDP ratio in 2015") ytitle("Number of countries") ///
title("How indebted were governments in 2015?") ///
subtitle("World-wide distribution of public debt") ///
xsize(12) ysize(8) graphregion(fcolor(white)) 

