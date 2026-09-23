
/*APPENDIX */

summ eom_present eom_countgrp eom_3plus eom_multiple nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log v2xel_frefair_l1el

/*these tables shows regional results*/



* POSTSOVIET
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el time  if exec==1&elecround==1&region_num!=3, cluster(ccode)
est store m1app,  title("Exclude Post-Soviet")

* SIGNIFICANCE ALSO DECLINES WHEN TAKING OUT AFRICA ESP FOR PROTEST VARIABLE (NELDA29) - 
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el time  if exec==1&elecround==1&region_num!=6, cluster(ccode)
est store m2app, title("Exclude Africa")

*TAKING OUT ASIA SIG FOR NELDA27 (OPP GAIN) DECLINES
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el time  if exec==1&elecround==1&region_num!=1, cluster(ccode)
est store m3app, title("Exclude Asia")

*TAKING OUT LATAM SIG FOR NELDA VARS DECLINES
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el  time if exec==1&elecround==1&region_num!=7, cluster(ccode)
est store m4app, title("Exclude LatAm")

*TAKING OUT POSTCOMM
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el  time if exec==1&elecround==1&region_num!=2, cluster(ccode)
est store m5app, title("Exclude Postcomm")




estout m1app m2app m3app m4app m5app using "appendix1.txt" , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace



*WEST/NONWEST AS ALTERNATE MEASURE OF QUALITY - ROBUSTNESS
 
logit All_westonly nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m1app2

logit All_nonwestonly nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m2app2

logit All_westnonwest nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m3app2

estout m1app2 m2app2 m3app2  using "appendix2.txt"   , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace

 ** TABLE 1 ROBUSTNESS CHECKS FEB2025 - LAG

 sort country year month
 by country: gen eom_present_lag=eom_present[_n-1]
 by country: gen eom_multiple_lag=eom_multiple[_n-1]
 by country: gen eom_3plus_lag=eom_3plus[_n-1]
 by country: gen eom_countgrp_lag=eom_countgrp[_n-1]
 by country: gen qual_both_lag=qual_both[_n-1]
 label var eom_present_lag "Any EOM lag"
 label var eom_multiple_lag "Many EOMs lag"
 label var eom_3plus_lag ">3 EOMs lag"
 label var eom_countgrp_lag "EOM count lag"
 label var qual_both_lag "Mixed EOM Quality lag"
  
 

logit eom_present eom_present_lag nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num if exec==1&elecround==1, cluster(ccode)
est store m1t1a, title("Any EOM")

logit eom_multiple eom_multiple_lag nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num if exec==1&elecround==1, cluster(ccode)
est store m2t1a, title("Many EOMs")

logit eom_3plus eom_3plus_lag nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num if exec==1&elecround==1, cluster(ccode)
est store m3t1a, title(">3 EOMs")

zinb eom_countgrp eom_countgrp_lag nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.o10.region_num if exec==1&elecround==1, inflate(v2x_regime_ld_l1yr v2xel_frefair_l1el region_num_1 region_num_4) cluster(ccode)
est store m4t1a, title("EOM count")

logit qual_both nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m5t1a, title("Mixed EOM Quality")


estout m1t1a m2t1a m3t1a m4t1a m5t1a using "table1a.txt", cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 


logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_eiec!=7, cluster(ccode)
est store p0, title("Mixed EOM quality")


logit eom_3plus nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1&nelda24=="no", cluster(ccode)
est store p1, title(">3 EOMs")

logit qual_both nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1&nelda24=="no", cluster(ccode)
est store p2, title("Mixed EOM quality")

estout p1 p2 p9 using "Elections.txt", cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 


*MEDIA VARIABLES FOR CENSORSHIP, RANGE OF PERSPECTIVES

logit qual_both nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el  region_num_3 region_num_5 region_num_6 region_num_7 time if exec==1&elecround==1, cluster(ccode)

logit eom_present  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m1t1b, title("Any EOM")

logit eom_multiple  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m2t1b, title("Many EOMs")

logit eom_3plus  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m3t1b, title(">3 EOMs")

zinb eom_countgrp  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.o10.region_num time v2mecenefm  v2merange if exec==1&elecround==1, inflate(v2x_regime_ld_l1yr v2xel_frefair_l1el region_num_1 region_num_4) cluster(ccode)
est store m4t1b, title("EOM count")

logit qual_both nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1&elecround==1, cluster(ccode)
est store m5t1b, title("Mixed EOM Quality")


estout m1t1b m2t1b m3t1b m4t1b m5t1b using "table_mediafree.txt", cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace

*adding more democracy variables 
logit eom_present  nelda29_num_l1el nelda27_num_l1el wb_gdp_growth_l1  v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode)
est store d1

logit eom_multiple  nelda29_num_l1el nelda27_num_l1el wb_gdp_growth_l1  v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode)
est store d2


logit eom_3plus nelda29_num_l1el nelda27_num_l1el wb_gdp_growth_l1  v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode)
est store d3


logit eom_countgrp  nelda29_num_l1el nelda27_num_l1el wb_gdp_growth_l1  v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode
est store d4

logit aual_both  nelda29_num_l1el nelda27_num_l1el  wb_gdp_growth_l1 v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode)
est store d4



*recoding missing
summ dpi_liec dpi_eiec
replace dpi_liec=. if dpi_liec==-999
replace dpi_eiec=. if dpi_eiec==-999
logit qual_both  nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el v2mecenefm  v2merange i.region_num time if exec==1& elecround==1 & dpi_liec==7, cluster(ccode)

*3/11/26 incumbent lost eleciton 
logit eom_3p nelda29_num_l1el wb_gdp_growth_l1 nelda27_num_l1el v2x_regime_autoc_l1yr wb_oda_usd_k_l1yr_log wb_gdp_pc_usd_k_l1yr_log  v2xel_frefair_l1el i.region_num time if exec==1&elecround==1&nelda24=="yes", cluster(ccode)

*above on intl newspapers
gen intlmedia=1 if S1_num_art>0| S4_num_art>0

xtreg media_i v2mebias v2xel_frefair  qual_both eom_multiple if intlmedia==1, cluster(ccode) fe
estimates store im1, title("Pos/neg words")
xtreg pos_sum v2mebias v2xel_frefair qual_both eom_multiple if intlmedia==1, cluster(ccode) fe
estimates store im2, title("Positive assessments")
xtreg media_3 v2mebias v2xel_frefair  qual_both eom_multiple if intlmedia==1, cluster(ccode) fe
estimates store im3, title("Ratio")
xtreg pos_sum v2mebias v2xel_frefair  qual_both verdict_diff_S2S4 eom_multiple if intlmedia==1, cluster(ccode) fe
estimates store im4, title("Positive assessments")
xtreg media_3 v2mebias v2xel_frefair  qual_both verdict_diff_S2S4 eom_multiple  if intlmedia==1, cluster(ccode) fe
estimates store im5, title("Ratio")
estout 
estout im1 im2 im3 im4 im5 using "Int_media_analysis.txt"   , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N r2_p rmse , fmt(0 3) label(N PseudoR2 )) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace

