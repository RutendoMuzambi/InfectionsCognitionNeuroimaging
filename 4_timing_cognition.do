/*=========================================================================
DO FILE NAME:		   an_timing_cognition.do

AUTHOR:					Rutendo Muzambi

DATE VERSION CREATED: 	07/2021
						
DESCRIPTION OF FILE:	
*=========================================================================*/

*do "J:\EHR-Working\Rutendo\Infections_cognition_UKB\Data\Dofiles\globals"

clear all
capture log close
log using "$logfiles\timing.log", replace 


*===============================DISCRETE========================================*/

********************************************************************************
*******************************Reaction time************************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear
gen time0=date_assess_bl-ts_53_0_0
gen time1=(ts_53_1_0-date_assess_bl)/365.25
gen time2=(ts_53_2_0-date_assess_bl)/365.25

drop if mean_reaction_time0==. //
drop if mean_reaction_time1==. & mean_reaction_time2==. //

****Reshape
reshape long mean_reaction_time time, i(patid) j(occasion)

***Export output
file open csvfile_rt using "$results\timing_discrete.csv", write replace
file write csvfile_rt "sep=;" _n
file write csvfile_rt "Association between infections and cognitive decline" _n _n 
file write csvfile_rt ";" "Fully adjusted*** (95% CI)" ";" _n  

file write csvfile_rt "Reaction time" _n

*age and sex adjusted
forval i=1/5 {
capture file close csvfile_rt
file open csvfile_rt using "$results\timing_discrete.csv", write append
**Fully adjusted models

mixed mean_reaction_time i.inf_year`i'##c.time age_bl i.sex i.ethnic ant_bmi_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.multiple_sclerosis_cat i.hypertension_cat i.heart_failure_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.inf_year`i'#c.time])
local lci_ful=(_b[1.inf_year`i'#c.time]-1.96*_se[1.inf_year`i'#c.time]) 
local uci_ful=(_b[1.inf_year`i'#c.time]+1.96*_se[1.inf_year`i'#c.time])


file write csvfile_rt "Any Infection `i' year before baseline" ";"  
file write  csvfile_rt (`coef_ful') " (" (`lci_ful')  "-" (`uci_ful') ")"  _n
file close csvfile_rt
}

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

file open csvfile_pm using "$results\timing_discrete.csv", write append
file write csvfile_pm "Pairs Matching" _n

***Export output
forval i=1/5 {
capture file close csvfile_pm
file open csvfile_pm using "$results\timing_discrete.csv", write append

**Fully adjusted models

mixed ln_pairs_match_score i.inf_year`i'##c.time age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat sep_townsend_bl ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.anx_dep_cat i.copd_cat i.ibd_cat i.RA_cat i.obs_sleep_cat  i.multiple_sclerosis_cat i.hypertension_cat ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.inf_year`i'#c.time])
local lci_ful=(_b[1.inf_year`i'#c.time]-1.96*_se[1.inf_year`i'#c.time]) 
local uci_ful=(_b[1.inf_year`i'#c.time]+1.96*_se[1.inf_year`i'#c.time])


file write csvfile_pm "Any Infection `i' year before baseline" ";"  
file write  csvfile_pm(`coef_ful') " (" (`lci_ful')  "-" (`uci_ful') ")"  _n
file close csvfile_pm
}
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

file open csvfile_fi using "$results\timing_discrete.csv", write append
file write csvfile_fi "Fluid Intelligence" _n

***Export output
forval i=1/5 {
capture file close csvfile_fi
file open csvfile_fi using "$results\timing_discrete.csv", write append

**Fully adjusted models

mixed fluid_intel_rvscore i.inf_year`i'##c.time edu_yrs_bl ||patid: time, cov(unst) reml stddev //
local coef_ful=(_b[1.inf_year`i'#c.time])
local lci_ful=(_b[1.inf_year`i'#c.time]-1.96*_se[1.inf_year`i'#c.time]) 
local uci_ful=(_b[1.inf_year`i'#c.time]+1.96*_se[1.inf_year`i'#c.time])

local z_ful = _b[1.inf_year`i'#c.time]/_se[1.inf_year`i'#c.time]
local p_ful = 2*(normal(-(`z_ful')))

file write csvfile_fi "Any Infection `i' year before baseline" ";" 
file write  csvfile_fi (`coef_ful') " (" (`lci_ful')  "-"(`uci_ful') ")"  _n
file close csvfile_fi
}

********************************************************************************
***************************Prospective Memory***********************************
********************************************************************************
use "$cleandata\mainanalysis_cognition", clear

tab prosp_mem_score_base

keep if prosp_mem_score_base==0

gen pm_answer=1
replace pm_answer=0 if prosp_mem_fup1==1
replace pm_answer=0 if prosp_mem_fup2==1
label values pm_answer pm_answer
label define pm_answer 0"Correct" 1"Incorrect" 
label var pm_answer "Prospective Memory"

forval i=1/5 {
logistic pm_answer i.inf_year`i' age_bl i.sex ls_pa_days_bl, base //
}

log close



