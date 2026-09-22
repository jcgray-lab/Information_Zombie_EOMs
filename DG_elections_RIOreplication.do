********************************************************************************
* REPLICATION FILE: MAIN ANALYSES
*
* This do-file reproduces the main tables and figures in "The Informational Effects of Institutional Crowding: Evidence from Zombie Election Monitors"
*
* Outputs:
*   Table 1   Main models of election-monitor presence and composition
*   Figure 1  Coefficient plots for Any EOM and Mixed-Quality EOMs
*   Figure 2  Number of EOMs and agreement/disagreement
*   Table 2   Media coverage analysis
*
* Required input:
*   DG_elections.dta
*
* Run this file from the project root directory. All input data should be
* stored in /data and all generated tables and figures will be written to
* /output.
********************************************************************************


clear all
set more off

* Set project root directory before running
* cd "/path/to/project"

* Create directory output if it doesn't exist
capture mkdir output 


use "data/DG_elections_RIOreplication.dta", clear

label var nelda29_num_l1el "Previous Election Protests"
label var nelda27_num_l1el "Previous Opp. Gain"
label var wb_gdp_growth_l1 "GDP Growth"
label var v2x_regime_autoc_l1yr "Autocracy (t-1)"
label var wb_oda_usd_k_l1yr_log "ODA log (t-1)"
label var wb_gdp_pc_usd_k_l1yr_log "GDP percap log (t-1)"
label var v2xel_frefair_l1el "Previous Elec. Quality"
label var time "Time"
label var eom_multiple "Multiple EOMs Present"
label var qual_both "Mixed EOM Quality"


** FIGURE 1 

set scheme sj

twoway (lfit All_obsgrps_max year, lcolor(black) lwidth(medium) lpattern(solid)) (scatter All_obsgrps_max year, mcolor(black) msymbol(circle_hollow) msize(small)) if All_obsgrps_max < 12, by(region_name, note("") graphregion(color(white)) legend(off)) legend(off) xtitle("Year") ytitle("Max Observation Group") graphregion(color(white) lcolor(white)) plotregion(color(white) lcolor(black)) ylabel(, angle(horizontal) nogrid glcolor(gs14)) xlabel(, nogrid)


********************************************************************************
* TABLE 1: ELECTION-MONITOR PRESENCE AND COMPOSITION
********************************************************************************

* MODEL 1: MIXED-QUALITY EOMs PRESENT

logit qual_both nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el i.region_num time if exec==1 & elecround==1, cluster(ccode)

estimates store table1_m1, title("Mixed EOM Quality")

* MODEL 2: ANY EOM PRESENT

logit eom_present nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el i.region_num time if exec==1 & elecround==1, cluster(ccode)

estimates store table1_m2, title("Any EOM")


* MODEL 3: MULTIPLE EOMs PRESENT

logit eom_multiple nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el i.region_num time if exec==1 & elecround==1, cluster(ccode)

estimates store table1_m3, title("Multiple EOMs")


* MODEL 4: NUMBER OF EOM GROUPS

zinb eom_countgrp nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el i.o10.region_num time if exec==1 & elecround==1, inflate(v2xel_frefair_l1el v2x_regime_ld_l1yr region_num_1 region_num_4) cluster(ccode)

estimates store table1_m4, title("EOM count")


* EXPORT TABLE 1

estout table1_m1 table1_m2 table1_m3 table1_m4 using "output/table1_EOMs.txt", cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tex) legend label varlabels(_cons Constant) stats(N r2_p , fmt(0 3) label(N PseudoR2)) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace order(v2x_regime_ld_l1yr nelda29_num_l1el nelda27_num_l1el wb_gdp_growth_l1 v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el) eqlabel("" "Inflation equation") indicate("Region indicators" = *region*) 


********************************************************************************
* FIGURE 2: COEFFICIENT PLOTS
********************************************************************************

coefplot table1_m2, bylabel("Any EOM") || table1_m1, bylabel("Mixed Quality EOMs") || , drop(_cons wb_gdp_growth_l1 v2xel_frefair_l1el 2.region_num 3.region_num 5.region_num 6.region_num 7.region_num time) xline(0, lcolor(black) lpattern(dash)) mcolor(black) msymbol(circle_hollow) msize(small) ciopts(lcolor(black)) lcolor(black) scheme(sj) graphregion(color(white) lcolor(white)) plotregion(color(white) lcolor(black)) ylabel(, angle(horizontal)) xlabel(, nogrid)

graph export "output/figure2_coefficients.png", as(png) replace



********************************************************************************
* FIGURE 3 - Stacked bar - Divergent EOM assessments
********************************************************************************

gen eom_num_3cat=0 if eom_countgrp==0
replace eom_num_3cat=1 if eom_countgrp==1
replace eom_num_3cat=2 if eom_countgrp==2
replace eom_num_3cat=3 if eom_countgrp==3|eom_countgrp==4
replace eom_num_3cat=4 if eom_countgrp>=5&eom_countgrp!=.
label define eom_gps 0 "0" 1 "1 EOM" 2 "2 EOMs" 3 "3-4 EOMs" 4 "5+ EOMs"
label val eom_num_3cat eom_gps

gen Intobs_verd_agree_any = abs(Intobs_verd_disagree_any-1)

graph bar Intobs_verd_agree_any Intobs_verd_disagree_any if election==1 & exec==1 & eom_multiple==1, over(eom_num_3cat) stack scheme(sj) bar(1, color(gs14) lcolor(black)) bar(2, color(gs4) lcolor(black)) legend(label(1 "Agreement") label(2 "Disagreement") region(lcolor(white))) graphregion(color(white) lcolor(white)) plotregion(color(white) lcolor(black)) ylabel(, angle(horizontal) nogrid) ytitle("Share") b1title("")

graph export "output\figure3_stackedbar.png", as(png) name("Graph") replace


********************************************************************************
* TABLE 2: MEDIA COVERAGE
********************************************************************************

xtreg pos_sum v2mebias v2xel_frefair qual_both eom_multiple, cluster(ccode) fe
estimates store m1, title("Positive words")
xtreg media_i v2mebias v2xel_frefair  qual_both eom_multiple, cluster(ccode) fe
estimates store m2, title("Pos/neg words")
xtreg media_3 v2mebias v2xel_frefair  qual_both eom_multiple, cluster(ccode) fe
estimates store m3, title("Ratio")

* EXPORT TABLE 2

estout m1 m2 m3 using "output/table2_media.txt", order(qual_both eom_multiple v2mebias v2xel_frefair) starlevels(+ .1 ** .05 *** .01) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N rmse, fmt(%9.0f %9.3f) labels(N "Root MSE")) replace legend label style(tex) varlabels(_cons Constant)


********************************************************************************
*** FIGURE 4
********************************************************************************

set scheme sj

histogram verdict_diff_S2S4 if election==1 & exec==1 & elecround==1, discrete by(eom_multiple, note("") graphregion(color(white))) color(gs12) lcolor(black) lwidth(thin) fintensity(100) xtitle("Verdict Difference (S2 - S4)") ytitle("Frequency") graphregion(color(white) lcolor(white)) plotregion(color(white) lcolor(black)) ylabel(, angle(horizontal) nogrid)
