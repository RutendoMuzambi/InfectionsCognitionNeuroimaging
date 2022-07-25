/*=========================================================================
DO FILE NAME:			frequency_infections.do

AUTHOR:					Rutendo Muzambi

DATE VERSION CREATED: 	06/2021
						
DESCRIPTION OF FILE:	Frequency of infections on cognitive decline
*=========================================================================*/
clear all
cap log close
log using "$logfiles\cog_decl_freq.log", replace

********************************************************************************
*******************************Reaction time************************************
********************************************************************************

*=============================First infection==================================*

use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25

drop if mean_reaction_time0==. //
drop if mean_reaction_time1==. & mean_reaction_time2==. //

****Reshape
reshape long mean_reaction_time time, i(patid) j(occasion)

***Export output

capture file close textfile_rt
file open textfile_rt using "$results\cognitive_decline_freq.csv", write replace
file write textfile_rt "sep=;" _n
file write textfile_rt "Association between infections and cognitive decline" _n _n 
file write textfile_rt ";" "Age and sex adjusted (95% CI)" ";"  "Fully adjusted (95% CI)" ";"  _n  


file write textfile_rt "Reaction time" _n

*age and sex adjusted
mixed mean_reaction_time i.first_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.first_infection#c.time])
local lci_age_sex=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_age_sex=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])

codebook patid if first_infection==0 // 14,494
codebook patid if first_infection==1 //  2,169


**Fully adjusted models

mixed mean_reaction_time i.first_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.first_infection#c.time])
local lci_ful=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_ful=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])


preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid 
codebook patid if first_infection==0 // 14,006
codebook patid if first_infection==1 //  2,078
restore


file write textfile_rt "First infection" ";" 
file write  textfile_rt  (`coef_age_sex') " (" (`lci_age_sex')  " to "  (`uci_age_sex') ")"  
file write  textfile_rt ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close textfile_rt

*===================Second and additional infections===========================*

file open textfile_rt_freq using "$results\cognitive_decline_freq.csv", write append

*age and sex adjusted
mixed mean_reaction_time c.additional_infections##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[c.additional_infections#c.time])
local lci_age_sex=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_age_sex=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

codebook patid if additional_infections==. // 15,846
codebook patid if additional_infections>=2 & additional_infections!=. //  817

**Fully adjusted models

mixed mean_reaction_time c.additional_infections##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[c.additional_infections#c.time])
local lci_ful=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_ful=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.
codebook patid
codebook patid if additional_infections==. // 
codebook patid if additional_infections>=2 & additional_infections!=. //  
restore


file write textfile_rt_freq "Second and additional infections" ";" 
file write  textfile_rt_freq (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")"  
file write  textfile_rt_freq ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")" _n
file close textfile_rt_freq


********************************************************************************
*******************************Pairs Matching***********************************
********************************************************************************

*=============================First infection==================================*

use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25

drop if ln_pairs_match_score0==. //0
drop if ln_pairs_match_score1==. & ln_pairs_match_score2==. //0

****Reshape
list patid time_since_bl time0 time1 time2 ln_pairs_match_score* in 1/20

reshape long ln_pairs_match_score time, i(patid) j(occasion)

***Export output

capture file close textfile_rt_freq
file open textfile_pm using "$results\cognitive_decline_freq.csv", write append

file write textfile_pm "Pairs Matching" _n

*age and sex adjusted
mixed ln_pairs_match_score i.first_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.first_infection#c.time])
local lci_age_sex=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_age_sex=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])

codebook patid if first_infection==0 //
codebook patid if first_infection==1 //  

**Fully adjusted models

mixed ln_pairs_match_score i.first_infection##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.first_infection#c.time])
local lci_ful=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_ful=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|smoking_cat==.| sep_townsend_bl==.
codebook patid
codebook patid if first_infection==0 // 12,136
codebook patid if first_infection==1 // 1,781
restore

file write textfile_pm "First infection" ";" 
file write  textfile_pm  (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  textfile_pm ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close textfile_pm

*===================Second and additional infections===========================*
file open textfile_pm_freq using "$results\cognitive_decline_freq.csv", write append

*age and sex adjusted
mixed ln_pairs_match_score c.additional_infections##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[c.additional_infections#c.time])
local lci_age_sex=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_age_sex=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

codebook patid if additional_infections==. // 13,707
codebook patid if additional_infections>=2 & additional_infections!=. //  728

**Fully adjusted models

mixed ln_pairs_match_score c.additional_infections##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[c.additional_infections#c.time])
local lci_ful=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_ful=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

preserve
drop if ethnic==.|ant_bmi_bl==. |ls_pa_days_bl==.| ls_alc_freq3cats_bl==.|edu_yrs_bl==.|smoking_cat==.| sep_townsend_bl==.
codebook patid
codebook patid if additional_infections==. // 13,238
codebook patid if additional_infections>=2 & additional_infections!=. //  679
restore


file write textfile_pm_freq "Second and additional infections" ";" 
file write  textfile_pm_freq (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")"  
file write  textfile_pm_freq ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close textfile_pm_freq



********************************************************************************
*******************************FLUID INTELLIGENCE*******************************
********************************************************************************

*=============================First infection==================================*
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25


drop if fluid_intel_rvscore0==. //10,928 
drop if fluid_intel_rvscore1==. & fluid_intel_rvscore2==. //81

****Reshape

reshape long fluid_intel_rvscore time, i(patid) j(occasion)

***Export output

capture file close textfile_pm_freq
file open textfile_fi using "$results\cognitive_decline_freq.csv", write append

file write textfile_fi "Fluid Intelligence" _n


*age and sex adjusted
mixed fluid_intel_rvscore i.first_infection##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[1.first_infection#c.time])
local lci_age_sex=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_age_sex=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])

codebook patid if first_infection==0 //
codebook patid if first_infection==1 //  

**Fully adjusted models

mixed fluid_intel_rvscore i.first_infection##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.first_infection#c.time])
local lci_ful=(_b[1.first_infection#c.time]-1.96*_se[1.first_infection#c.time]) 
local uci_ful=(_b[1.first_infection#c.time]+1.96*_se[1.first_infection#c.time])

preserve
drop if edu_yrs_bl==.
codebook patid if first_infection==0 // 
codebook patid if first_infection==1 //
restore

file write textfile_fi "First infection" ";"  
file write  textfile_fi (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")" 
file write  textfile_fi ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close textfile_fi


*===================Second and additional infections===========================*

file open textfile_fi_freq using "$results\cognitive_decline_freq.csv", write append

*age and sex adjusted
mixed fluid_intel_rvscore c.additional_infections##c.time age_bl i.sex ||patid: time, cov(unst) reml stddev
local coef_age_sex=(_b[c.additional_infections#c.time])
local lci_age_sex=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_age_sex=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

codebook patid if additional_infections==. // 
codebook patid if additional_infections>=2 & additional_infections!=. //  

**Fully adjusted models

mixed fluid_intel_rvscore c.additional_infections##c.time age_bl i.sex edu_yrs_bl ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[c.additional_infections#c.time])
local lci_ful=(_b[c.additional_infections#c.time]-1.96*_se[c.additional_infections#c.time]) 
local uci_ful=(_b[c.additional_infections#c.time]+1.96*_se[c.additional_infections#c.time])

preserve
drop if edu_yrs_bl==.
codebook patid
codebook patid if additional_infections==. // 
codebook patid if additional_infections>=2 & additional_infections!=. //  
restore


file write textfile_fi_freq "Second and additional infections" ";"  
file write  textfile_fi_freq (`coef_age_sex') " (" (`lci_age_sex')  " to " (`uci_age_sex') ")"  
file write  textfile_fi_freq ";"  (`coef_ful') " (" (`lci_ful')  " to " (`uci_ful') ")"  _n
file close textfile_fi_freq

*===================PROSPECTIVE MEMORY===========================*

use "$cleandata\mainanalysis_cognition", clear

tab prosp_mem_score_base

keep if prosp_mem_score_base==0

gen pm_answer=1
replace pm_answer=0 if prosp_mem_fup1==1
replace pm_answer=0 if prosp_mem_fup2==1
label values pm_answer pm_answer
label define pm_answer 0"Correct" 1"Incorrect" 
label var pm_answer "Prospective Memory"

**Frequency
logistic pm_answer i.first_infection age_bl i.sex, base  

tab first_infection

logistic pm_answer i.first_infection age_bl i.sex ls_pa_days_bl, base

preserve
drop if ls_pa_days_bl==.
tab first_infection
restore

**additional infections
logistic pm_answer additional_infections age_bl i.sex, base  

codebook patid if additional_infections==. // 
codebook patid if additional_infections>=2 & additional_infections!=. //

logistic pm_answer additional_infections age_bl i.sex ls_pa_days_bl, base

preserve
drop if ls_pa_days_bl==.
codebook patid if additional_infections==. // 
codebook patid if additional_infections>=2 & additional_infections!=. //
restore

log close

