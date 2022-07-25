
*=====================================================================================
*Plots corresponding to manuscript table 2's mixed effects analyses

*=====================================================================================
*ssc install combomarginsplot
*ssc install coefplot
clear all
********************************************************************************
*******************************Reaction time************************************
********************************************************************************

*===============================ANY INFECTION===================================*
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if mean_reaction_time0==. //40
drop if mean_reaction_time1==. & mean_reaction_time2==. //61
reshape long mean_reaction_time time, i(patid) j(occasion)

mixed mean_reaction_time i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev 

cd "$results"

margins infection_cat, at(time=(0(1)12)) 
marginsplot, title(Any infection)  xtitle("") ytitle("") ylabel(, labsize(small)) xlab(, nolabels) recast(line) recastci(rarea) ciopt(color(%25))  //xtitle(Time (years)) ytitle(Mean reaction time (milliseconds))  noci
gr save any_RT.gph, replace

*===================================TYPE=======================================*


mixed mean_reaction_time i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev

margins inf_type, at(time=(0(1)12)) 
marginsplot, title(Site of Infection)  xtitle("") ytitle("") ylabel(, labsize(small)) xlab(, nolabels) recast(line) recastci(rarea) ciopt(color(%20)) legend(row (1) symxsize(*.5))   //xtitle(Time (years)) ytitle(Mean reaction time (milliseconds))  noci
gr save type_RT.gph, replace

*===================================Setting=======================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed mean_reaction_time i.`var'_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title(`var' recorded infections)  xtitle("") ytitle("") ylabel(, labsize(small))  xlab(, nolabels)  recast(line) recastci(rarea) ciopt(color(%25)) //xtitle(Time (years)) ytitle(Mean reaction time (milliseconds))  noci
gr save `var'_RT.gph, replace
}

gr combine any_RT.gph type_RT.gph GP_RT.gph Hospital_RT.gph, l1(Mean reaction time (milliseconds), size (vsmall)) title("A. Reaction Time", size(small) position(11)) saving(RT_graphs, replace) row(1) iscale(0.5) xsize(10) 


********************************************************************************
*******************************Visual Memory************************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if ln_pairs_match_score0==. 
drop if ln_pairs_match_score1==. & ln_pairs_match_score2==. 

reshape long ln_pairs_match_score time, i(patid) j(occasion)


*===============================ANY INFECTION===================================*
mixed ln_pairs_match_score i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev 
margins infection_cat, at(time=(0(1)12)) 
marginsplot, title(Any infection)  xtitle("") ytitle("")  xlab(, nolabels) ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%25))  //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save any_VM.gph, replace

*===================================TYPE=======================================*
mixed ln_pairs_match_score i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
margins inf_type, at(time=(0(1)12))
marginsplot, title(Site of Infection)   xtitle("") ytitle("")  xlab(, nolabels) ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%20)) legend(row (1) symxsize(*.5))  //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save type_VM.gph, replace

*===================================Setting=======================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed ln_pairs_match_score i.`var'_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title(`var' recorded infections)  xtitle("") ytitle("") xlab(, nolabels) ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%25))  //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save `var'_VM.gph, replace
}

*xlab(, nolabels) ylab(, nolabels)

gr combine any_VM.gph type_VM.gph GP_VM.gph Hospital_VM.gph, l1(Log of mean errors, size (vsmall)) title("B. Visual Memory", size(small) position(11)) saving(VM_graphs, replace) row(1) iscale(0.5) xsize(10) 

********************************************************************************
**********************Fluid Intelligence/Reasoning****************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if fluid_intel_rvscore0==. //10,928 
drop if fluid_intel_rvscore1==. & fluid_intel_rvscore2==. //81

****Reshape
reshape long fluid_intel_rvscore time, i(patid) j(occasion)

*===============================ANY INFECTION===================================*
mixed fluid_intel_rvscore i.infection_cat##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins infection_cat, at(time=(0(1)12)) 
marginsplot, title(Any infection) xtitle("") xtitle(Time (years)) ytitle("") recast(line) recastci(rarea) ciopt(color(%25)) ylabel(, labsize(small))   // 
gr save any_FI.gph, replace

*===================================TYPE=======================================*
mixed fluid_intel_rvscore i.inf_type##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins inf_type, at(time=(0(1)12))
marginsplot, title(Site of Infection)  xtitle(Time (years)) ytitle("")  legend(row (1) symxsize(*.5)) recast(line) recastci(rarea) ciopt(color(%20)) ylabel(, labsize(small)) // 
gr save type_FI.gph, replace

*===================================Setting=====================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed fluid_intel_rvscore i.`var'_infection##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title(`var' recorded infections)  xtitle(Time (years)) ytitle("") recast(line) recastci(rarea) ciopt(color(%25)) ylabel(, labsize(small)) // 
gr save `var'_FI.gph, replace
}

gr combine any_FI.gph type_FI.gph GP_FI.gph Hospital_FI.gph, l1(Mean number of errors , size (vsmall)) title("C. Verbal and Numerical Reasoning",  size(small) position(11)) saving(FI_graphs, replace) row(1) iscale(0.5) xsize(10) 


*+++++++++++++++++++++++++++++++ALL GRAPHS++++++++++++++++++++++++++++++++++++++
*gr combine "$results/RT_graphs.gph" "$results/VM_graphs.gph" "$results/FI_graphs.gph", row(3) iscale(0.75) xsize(10) b1(Time (years), size (vsmall)) 
gr combine "$results/RT_graphs.gph" "$results/VM_graphs.gph" "$results/FI_graphs.gph", row(3) iscale(0.75) xsize(10) 
graph export LMM_marginplots.png, replace
*graph export LMM_marginplots.png, height(16000) 
























*********************************************
*********LESS LABELS
********************************************

























*=====================================================================================
*Plots corresponding to manuscript table 2's mixed effects analyses

*=====================================================================================
*ssc install combomarginsplot
*ssc install coefplot
clear all
********************************************************************************
*******************************Reaction time************************************
********************************************************************************

*===============================ANY INFECTION===================================*
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if mean_reaction_time0==. //40
drop if mean_reaction_time1==. & mean_reaction_time2==. //61
reshape long mean_reaction_time time, i(patid) j(occasion)

mixed mean_reaction_time i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev //

cd "$results"

margins infection_cat, at(time=(0(1)12)) 
marginsplot, title(Any infection, color(black))  xtitle(Time (years)) ytitle("") ylabel(, labsize(small))  recast(line) recastci(rarea) ciopt(color(%25)) leg(off) graphregion(color(white))
gr save any_RT_2.gph, replace

*===================================TYPE=======================================*


mixed mean_reaction_time i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev

margins inf_type, at(time=(0(1)12)) 
marginsplot, title(Site of Infection,color(black))  xtitle(Time (years)) ytitle("") ylabel(, labsize(small))  recast(line) recastci(rarea) ciopt(color(%20)) legend(row (1) symxsize(*.5)) leg(off)  graphregion(color(white))
gr save type_RT_2.gph, replace

*===================================Setting=======================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed mean_reaction_time i.`var'_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title(`var' recorded infections, color(black))  xtitle(Time (years)) ytitle("") ylabel(, labsize(small))    recast(line) recastci(rarea) ciopt(color(%25)) leg(off) graphregion(color(white))
gr save `var'_RT_2.gph, replace
}

gr combine any_RT_2.gph type_RT_2.gph GP_RT_2.gph Hospital_RT_2.gph, l1(Mean reaction time (milliseconds), size (vsmall)) title("A. Reaction Time", size(small) color(black) position(11)) saving(RT_2_graphs, replace) row(1) iscale(0.5) xsize(10) graphregion(color(white))


********************************************************************************
*******************************Visual Memory************************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if ln_pairs_match_score0==. 
drop if ln_pairs_match_score1==. & ln_pairs_match_score2==. 

reshape long ln_pairs_match_score time, i(patid) j(occasion)


*===============================ANY INFECTION===================================*
mixed ln_pairs_match_score i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev 
margins infection_cat, at(time=(0(1)12)) 
marginsplot, title("")  xtitle(Time (years)) ytitle("")   ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%25)) leg(off) graphregion(color(white)) //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save any_VM_2.gph, replace

*===================================TYPE=======================================*
mixed ln_pairs_match_score i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
margins inf_type, at(time=(0(1)12))
marginsplot, title("")  xtitle(Time (years)) ytitle("")   ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%20)) legend(row (1) symxsize(*.5)) leg(off) graphregion(color(white)) //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save type_VM_2.gph, replace

*===================================Setting=======================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed ln_pairs_match_score i.`var'_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title("") xtitle(Time (years)) ytitle("")  ylabel(, labsize(small)) recast(line) recastci(rarea) ciopt(color(%25)) leg(off) graphregion(color(white)) //xtitle(Time (years)) ytitle(Log of errors on visual memory test)  noci
gr save `var'_VM_2.gph, replace
}

* ylab(, nolabels)

gr combine any_VM_2.gph type_VM_2.gph GP_VM_2.gph Hospital_VM_2.gph, l1(Log of mean errors, size (vsmall)) title("B. Visual Memory", size(small) color(black) position(11)) saving(VM_2_graphs, replace) row(1) iscale(0.5) xsize(10) graphregion(color(white)) // 
********************************************************************************
**********************Fluid Intelligence/Reasoning****************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25
drop if fluid_intel_rvscore0==. //10,928 
drop if fluid_intel_rvscore1==. & fluid_intel_rvscore2==. //81

****Reshape
reshape long fluid_intel_rvscore time, i(patid) j(occasion)

*===============================ANY INFECTION===================================*
mixed fluid_intel_rvscore i.infection_cat##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins infection_cat, at(time=(0(1)12)) 
marginsplot, title("") xtitle("") xtitle(Time (years)) ytitle("") recast(line) recastci(rarea) ciopt(color(%25)) ylabel(, labsize(small)) graphregion(color(white)) // 
gr save any_FI_2.gph, replace

*===================================TYPE=======================================*
mixed fluid_intel_rvscore i.inf_type##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins inf_type, at(time=(0(1)12))
marginsplot, title("") xtitle(Time (years)) ytitle("")  legend(row (1) symxsize(*.5)) recast(line) recastci(rarea) ciopt(color(%20)) ylabel(, labsize(small)) graphregion(color(white)) // 
gr save type_FI_2.gph, replace

*===================================Setting=====================================*
rename gp_infection GP_infection
rename hospital_infection Hospital_infection
foreach var in GP Hospital {
mixed fluid_intel_rvscore i.`var'_infection##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
margins `var'_infection, at(time=(0(1)12)) 
marginsplot, title("") xtitle(Time (years)) ytitle("") recast(line) recastci(rarea) ciopt(color(%25)) ylabel(, labsize(small)) graphregion(color(white)) // 
gr save `var'_FI_2.gph, replace
}

gr combine any_FI_2.gph type_FI_2.gph GP_FI_2.gph Hospital_FI_2.gph, l1(Mean number of errors , size (vsmall)) title("C. Fluid Intelligence",  size(small) color(black) position(11)) saving(FI_2_graphs, replace) row(1) iscale(0.5) xsize(10) graphregion(color(white))

*+++++++++++++++++++++++++++++++ALL GRAPHS++++++++++++++++++++++++++++++++++++++
*gr combine "$results/RT_graphs.gph" "$results/VM_graphs.gph" "$results/FI_graphs.gph", row(3) iscale(0.75) xsize(10) b1(Time (years), size (vsmall)) 
gr combine "$results/RT_2_graphs.gph" "$results/VM_2_graphs.gph" "$results/FI_2_graphs.gph", row(3) iscale(0.9) xsize(10) graphregion(color(white))
graph export LMM_marginplots_2.png, replace




