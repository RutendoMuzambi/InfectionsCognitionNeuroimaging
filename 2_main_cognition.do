/*=========================================================================
DO FILE NAME:			cognition_tests_output.do

AUTHOR:					Rutendo Muzambi

DATE VERSION CREATED: 	06/2021
						
DESCRIPTION OF FILE:	Output of linear mixed models of infections and 
                        cognitive decline
*=========================================================================*/

clear all

capture log close
log using "$logfiles\LMM_type_set.log", replace 

********************************************************************************
*******************************Reaction time************************************
********************************************************************************

use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25

drop if mean_reaction_time0==. //40
drop if mean_reaction_time1==. & mean_reaction_time2==. //61

****Reshape
reshape long mean_reaction_time time, i(patid) j(occasion)

***Export output

capture file close csvfile_rt
file open csvfile_rt using "$results\LMM_type_set.csv", write replace
file write csvfile_rt "sep=;" _n
file write csvfile_rt "Association between infections and cognitive decline" _n _n 
file write csvfile_rt ";" "Age and sex adjusted** (95% CI)" ";" "Fully adjusted*** (95% CI)" ";"  _n  

file write csvfile_rt "Reaction time" _n

*age and sex adjusted
mixed mean_reaction_time i.infection_cat##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.infection_cat#c.time])
local lci_age_sex=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_age_sex=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])

codebook patid if infection_cat==0 // 13,707
codebook patid if infection_cat==1 //  2,956 


**Fully adjusted models

mixed mean_reaction_time i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.infection_cat#c.time])
local lci_ful=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_ful=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid 
codebook patid if infection_cat==0 // 
codebook patid if infection_cat==1 //  
restore

file write csvfile_rt "Any Infection" ";"  
file write  csvfile_rt (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_rt ";" %3.2f  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")" _n
file close csvfile_rt

*===================================TYPE=======================================*

file open csvfile_rt_type using "$results\LMM_type_set.csv", write append


*age and sex adjusted
mixed mean_reaction_time i.inf_type##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_age_sex_`x'=(_b[`x'.inf_type#c.time]) 
local lci_age_sex_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_age_sex_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}

*matrix list r(table)

codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //


**Fully adjusted models
mixed mean_reaction_time i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_ful_`x'=(_b[`x'.inf_type#c.time]) 
local lci_ful_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_ful_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //
restore


file write csvfile_rt_type "Other LRTI" ";"   
file write  csvfile_rt_type  %3.2f  (`coef_age_sex_1') " (" (`lci_age_sex_1')  " to " (`uci_age_sex_1') ")"   
file write  csvfile_rt_type ";" %3.2f  (`coef_ful_1') " (" (`lci_ful_1')  " to " (`uci_ful_1') ")" ";"   _n

file write csvfile_rt_type "UTI" ";" 
file write  csvfile_rt_type  (`coef_age_sex_2') " ("  (`lci_age_sex_2')  " to " %3.2f  (`uci_age_sex_2') ")" 
file write  csvfile_rt_type ";"  (`coef_ful_2') " ("  (`lci_ful_2')  " to " (`uci_ful_2') ")" _n

file write csvfile_rt_type "SSTI" ";" 
file write  csvfile_rt_type  (`coef_age_sex_3') " ("  (`lci_age_sex_3')  " to " (`uci_age_sex_3') ")" 
file write  csvfile_rt_type ";"  (`coef_ful_3') " ("  (`lci_ful_3')  " to " (`uci_ful_3') ")" ";" _n
file close csvfile_rt_type

*===================================Setting=======================================*

*========GP infection

file open csvfile_rt_gp using "$results\LMM_type_set.csv", write append
file write csvfile_rt_gp "clinical setting" _n

mixed mean_reaction_time i.gp_infection##c.time ||patid: time, cov(unst) reml stddev 

*age and sex adjusted
mixed mean_reaction_time i.gp_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.gp_infection#c.time])
local lci_age_sex=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_age_sex=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])

codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //  

**Fully adjusted models

mixed mean_reaction_time i.gp_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev
local coef_ful=(_b[1.gp_infection#c.time])
local lci_ful=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_ful=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])


preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //
restore


file write csvfile_rt_gp "GP infection" ";" 
file write  csvfile_rt_gp %3.2f  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_rt_gp ";" %3.2f  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")" ";" _n
file close csvfile_rt_gp


*=======HOSPITAL

file open csvfile_rt_hp using "$results\LMM_type_set.csv", write append

*age and sex adjusted
mixed mean_reaction_time i.hospital_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.hospital_infection#c.time])
local lci_age_sex=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_age_sex=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])


codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //

**Fully adjusted models

mixed mean_reaction_time i.hospital_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev
local coef_ful=(_b[1.hospital_infection#c.time])
local lci_ful=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_ful=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid
codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //
restore

file write csvfile_rt_hp "Hospital infection" ";" 
file write  csvfile_rt_hp %3.2f  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_rt_hp ";" %3.2f  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close csvfile_rt_hp

********************************************************************************
*******************************Pairs Matching***********************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25

drop if ln_pairs_match_score0==. //0
drop if ln_pairs_match_score1==. & ln_pairs_match_score2==. //0

****Reshape

reshape long ln_pairs_match_score time, i(patid) j(occasion)
***Export output

capture file close csvfile_pm
file open csvfile_pm using "$results\LMM_type_set.csv", write append

file write csvfile_pm "Pairs Matching test" _n


*age and sex adjusted
mixed ln_pairs_match_score i.infection_cat##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.infection_cat#c.time])
local lci_age_sex=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_age_sex=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])

codebook patid if infection_cat==0 //
codebook patid if infection_cat==1 //  

**Fully adjusted models

mixed ln_pairs_match_score i.infection_cat##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.infection_cat#c.time])
local lci_ful=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_ful=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|smoking_cat==.| sep_townsend_bl==.
codebook patid
codebook patid if infection_cat==0 // 
codebook patid if infection_cat==1 //
restore

file write csvfile_pm "Any Infection" ";" 
file write  csvfile_pm   (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")"  
file write  csvfile_pm ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close csvfile_pm

*===================================TYPE=======================================*

file open csvfile_pm_type using "$results\LMM_type_set.csv", write append

*age and sex adjusted
mixed ln_pairs_match_score i.inf_type##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_age_sex_`x'=(_b[`x'.inf_type#c.time]) 
local lci_age_sex_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_age_sex_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}


codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //

**Fully adjusted models
mixed ln_pairs_match_score i.inf_type##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //


preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|smoking_cat==.| sep_townsend_bl==.
codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //
restore


local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_ful_`x'=(_b[`x'.inf_type#c.time]) 
local lci_ful_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_ful_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}

file write csvfile_pm_type "Other LRTI" ";" 
file write  csvfile_pm_type   (`coef_age_sex_1') " (" (`lci_age_sex_1')  " to " (`uci_age_sex_1') ")"   
file write  csvfile_pm_type ";"  (`coef_ful_1') " (" (`lci_ful_1')  " to " (`uci_ful_1') ")"   _n

file write csvfile_pm_type "UTI" ";" 
file write  csvfile_pm_type  (`coef_age_sex_2') " (" (`lci_age_sex_2')  " to " (`uci_age_sex_2') ")" 
file write  csvfile_pm_type ";"  (`coef_ful_2') " (" (`lci_ful_2')  " to " (`uci_ful_2') ")" _n

file write csvfile_pm_type "SSTI" ";"  
file write  csvfile_pm_type  (`coef_age_sex_3') " (" (`lci_age_sex_3')  " to " (`uci_age_sex_3') ")" 
file write  csvfile_pm_type ";"  (`coef_ful_3') " (" (`lci_ful_3')  " to " (`uci_ful_3') ")"  _n
file close csvfile_pm_type

*===================================Setting=======================================*

*===GP INFECTION
file open csvfile_pm_gp using "$results\LMM_type_set.csv", write append
file write csvfile_pm_gp "clinical setting" _n

*age and sex adjusted
mixed ln_pairs_match_score i.gp_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.gp_infection#c.time])
local lci_age_sex=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_age_sex=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])


codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //


**Fully adjusted models

mixed ln_pairs_match_score i.gp_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //


preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|sep_townsend_bl==.|smoking_cat==.
codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //
restore


local coef_ful=(_b[1.gp_infection#c.time])
local lci_ful=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_ful=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])


file write csvfile_pm_gp "GP infection" ";"   
file write  csvfile_pm_gp  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_pm_gp ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close csvfile_pm_gp

*===HOSPITAL INFECTION
file open csvfile_pm_hp using "$results\LMM_type_set.csv", write append

*age and sex adjusted
mixed ln_pairs_match_score i.hospital_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev

codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //

local coef_age_sex=(_b[1.hospital_infection#c.time])
local lci_age_sex=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_age_sex=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])

local z_age = _b[1.hospital_infection#c.time]/_se[1.hospital_infection#c.time]
local p_age = 2*(normal(-(`z_age')))

**Fully adjusted models

mixed ln_pairs_match_score i.hospital_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|sep_townsend_bl==.|smoking_cat==.
codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //
restore

local coef_ful=(_b[1.hospital_infection#c.time])
local lci_ful=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_ful=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])

file write csvfile_pm_hp "GP infection" ";"   
file write  csvfile_pm_hp  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_pm_hp ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close csvfile_pm_hp



********************************************************************************
***************************FLUID INTELLIGENCE***********************************
********************************************************************************

use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25


drop if fluid_intel_rvscore0==. //10,928 
drop if fluid_intel_rvscore1==. & fluid_intel_rvscore2==. //81

****Reshape
reshape long fluid_intel_rvscore time, i(patid) j(occasion)

***Export output

capture file close csvfile_fi
file open csvfile_fi using "$results\LMM_type_set.csv", write append

file write csvfile_fi "Fluid Intelligence" _n

*age and sex adjusted
mixed fluid_intel_rvscore i.infection_cat##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev

codebook patid if infection_cat==0 // 
codebook patid if infection_cat==1 //

local coef_age_sex=(_b[1.infection_cat#c.time])
local lci_age_sex=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_age_sex=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])


**Fully adjusted models

mixed fluid_intel_rvscore i.infection_cat##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.infection_cat#c.time])
local lci_ful=(_b[1.infection_cat#c.time]-1.96*_se[1.infection_cat#c.time]) 
local uci_ful=(_b[1.infection_cat#c.time]+1.96*_se[1.infection_cat#c.time])

preserve
drop if edu_yrs_bl==.
codebook patid if infection_cat==0 // 
codebook patid if infection_cat==1 //
restore

file write csvfile_fi "Any Infection" ";" 
file write  csvfile_fi  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_fi ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close csvfile_fi

*===================================TYPE=======================================*

file open csvfile_fi_type using "$results\LMM_type_set.csv", write append

*age and sex adjusted
mixed fluid_intel_rvscore i.inf_type##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev

codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //

local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_age_sex_`x'=(_b[`x'.inf_type#c.time]) 
local lci_age_sex_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_age_sex_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}


**Fully adjusted models
mixed fluid_intel_rvscore i.inf_type##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //

preserve
drop if edu_yrs_bl==.
codebook patid if inf_type==0 // 
codebook patid if inf_type==1 //  
codebook patid if inf_type==2 // 
codebook patid if inf_type==3 //  

codebook patid if inf_alltypes==4 // 
codebook patid if inf_alltypes==5 //
codebook patid if inf_alltypes==6 //
restore

local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_ful_`x'=(_b[`x'.inf_type#c.time]) 
local lci_ful_`x'=(_b[`x'.inf_type#c.time]-1.96*_se[`x'.inf_type#c.time]) 
local uci_ful_`x'=(_b[`x'.inf_type#c.time]+1.96*_se[`x'.inf_type#c.time]) 
}

file write csvfile_fi_type "Other LRTI" ";"  
file write  csvfile_fi_type  (`coef_age_sex_1') " (" (`lci_age_sex_1')  " to " (`uci_age_sex_1') ")"
file write  csvfile_fi_type ";"  (`coef_ful_1') " (" (`lci_ful_1')  " to " (`uci_ful_1') ")"   _n

file write csvfile_fi_type "UTI" ";" 
file write  csvfile_fi_type  (`coef_age_sex_2') " (" (`lci_age_sex_2')  " to " (`uci_age_sex_2') ")"   
file write  csvfile_fi_type ";"  (`coef_ful_2') " (" (`lci_ful_2')  " to " (`uci_ful_2') ")" ";" _n

file write csvfile_fi_type "SSTI" ";" 
file write  csvfile_fi_type (`coef_age_sex_3') " (" (`lci_age_sex_3')  " to " (`uci_age_sex_3') ")" 
file write  csvfile_fi_type ";"  (`coef_ful_3') " (" (`lci_ful_3')  " to " (`uci_ful_3') ")" _n
file close csvfile_fi_type


*===================================Setting=======================================*

*====GP INFECTIONS
file open csvfile_fi_gp using "$results\LMM_type_set.csv", write append
file write csvfile_fi_gp "clinical setting" _n

*age and sex adjusted
mixed fluid_intel_rvscore i.gp_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev

codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //

local coef_age_sex=(_b[1.gp_infection#c.time])
local lci_age_sex=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_age_sex=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])


**Fully adjusted models

mixed fluid_intel_rvscore i.gp_infection##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //

preserve
drop if edu_yrs_bl==.
codebook patid if gp_infection==0 // 
codebook patid if gp_infection==1 //  
restore


local coef_ful=(_b[1.gp_infection#c.time])
local lci_ful=(_b[1.gp_infection#c.time]-1.96*_se[1.gp_infection#c.time]) 
local uci_ful=(_b[1.gp_infection#c.time]+1.96*_se[1.gp_infection#c.time])


file write csvfile_fi_gp "gp_infection" ";"  
file write  csvfile_fi_gp (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_fi_gp ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")" _n

file close csvfile_fi_gp

*===========HOSPITAL

file open csvfile_fi_hp using "$results\LMM_type_set.csv", write append

*age and sex adjusted
mixed fluid_intel_rvscore i.hospital_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev

codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //  

local coef_age_sex=(_b[1.hospital_infection#c.time])
local lci_age_sex=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_age_sex=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])


**Fully adjusted models

mixed fluid_intel_rvscore i.hospital_infection##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //

preserve
drop if edu_yrs_bl==.
codebook patid if hospital_infection==0 // 
codebook patid if hospital_infection==1 //  
restore

local coef_ful=(_b[1.hospital_infection#c.time])
local lci_ful=(_b[1.hospital_infection#c.time]-1.96*_se[1.hospital_infection#c.time]) 
local uci_ful=(_b[1.hospital_infection#c.time]+1.96*_se[1.hospital_infection#c.time])


file write csvfile_fi_hp "hospital_infection" ";"  
file write  csvfile_fi_hp (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  csvfile_fi_hp ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n

file close csvfile_fi_hp

*=====================PROSPECTIVE MEMORY

use "$cleandata\mainanalysis_cognition", clear


tab prosp_mem_score_base
/*

Prospective |
   Memory - |
    Correct |
     Answer |
 (Baseline) |      Freq.     Percent        Cum.
------------+-----------------------------------
  Incorrect |        762       12.99       12.99
    Correct |      5,103       87.01      100.00
------------+-----------------------------------
      Total |      5,865      100.00
*/

keep if prosp_mem_score_base==0

gen pm_answer=1
replace pm_answer=0 if prosp_mem_fup1==1
replace pm_answer=0 if prosp_mem_fup2==1
label values pm_answer pm_answer
label define pm_answer 0"Correct" 1"Incorrect" 
label var pm_answer "Prospective Memory"

**Any infection

logistic pm_answer i.infection_cat age_bl i.sex , base //

tab infection_cat

logistic pm_answer i.infection_cat age_bl i.sex ls_pa_days_bl, base //

preserve
drop if ls_pa_days_bl==.
tab infection_cat
restore

***type of infection

logistic pm_answer i.inf_type age_bl i.sex, base //

tab inf_type
tab inf_alltypes

logistic pm_answer i.inf_type age_bl i.sex ls_pa_days_bl, base //

preserve
drop if ls_pa_days_bl==.
tab inf_type
tab inf_alltypes
restore


***gp infection
 

logistic pm_answer i.gp_infection age_bl i.sex, base //

tab gp_infection

logistic pm_answer i.gp_infection age_bl i.sex ls_pa_days_bl, base //

preserve
drop if ls_pa_days_bl==.
tab gp_infection
restore

***hospital infection


logistic pm_answer i.hospital_infection age_bl i.sex, base //

tab hospital_infection

logistic pm_answer i.hospital_infection age_bl i.sex ls_pa_days_bl, base //

preserve
drop if ls_pa_days_bl==.
tab hospital_infection
restore

log close


