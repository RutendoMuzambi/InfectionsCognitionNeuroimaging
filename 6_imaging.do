/*=========================================================================
DO FILE NAME:			imaging_output.do

AUTHOR:					Rutendo Muzambi

DATE VERSION CREATED: 	06/2021
						
DESCRIPTION OF FILE:	Output of linear regression of infections and brain
                        imaging measures
*=========================================================================*/

clear all

cap log close 
log using "$logfiles\imaging_reg_output.log", replace


********************************************************************************
*****************************Hippocampal Volume*********************************
********************************************************************************

*===================================ANY=======================================*
clear all
use "$cleandata\mainanalysis_imaging", clear
capture file close csvfile_hv
file open csvfile_hv using "$results\imaging_regression.csv", write replace
file write csvfile_hv "sep=;" _n
file write csvfile_hv "Association between infections and baseline neuroimaging measures" _n _n 
file write csvfile_hv ";" "Crude (95% CI)" ";" "p value" ";" "Age and sex adjusted (95% CI)" ";" "p value" ";" "Fully adjusted (95% CI)" ";" "p value" ";" _n  

**Crude
file write csvfile_hv "Hippocampal Volume" _n

regress hippocampal_total_bl i.infection_cat 

local coef_crd=(_b[1.infection_cat])
local lci_crd=(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_crd=(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])

local t_crd = _b[1.infection_cat]/_se[1.infection_cat]
local p_crd = 2*ttail(e(df_r),abs(`t_crd'))

*age and sex adjusted
regress hippocampal_total_bl i.infection_cat age_bl i.sex
local coef_age_sex=(_b[1.infection_cat])
local lci_age_sex=(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_age_sex=(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])

local t_age = _b[1.infection_cat]/_se[1.infection_cat]
local p_age = 2*ttail(e(df_r),abs(`t_age'))

**Fully adjusted models

regress hippocampal_total_bl i.infection_cat age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.copd_cat i.asthma_cat i.hypertension_cat 
local coef_ful=(_b[1.infection_cat])
local lci_ful=(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_ful=(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])

local t_ful = _b[1.infection_cat]/_se[1.infection_cat]
local p_ful = 2*ttail(e(df_r),abs(`t_ful'))


file write csvfile_hv "Any Infection" ";" 
file write  csvfile_hv  %3.2f (`coef_crd') " (" %3.2f (`lci_crd')  " to " %3.2f (`uci_crd') ")" ";" (`p_crd')  
file write  csvfile_hv ";"  %3.2f (`coef_age_sex') " (" %3.2f (`lci_age_sex')  " to " %3.2f (`uci_age_sex') ")" ";" (`p_age') 
file write  csvfile_hv ";"  %3.2f (`coef_ful') " (" %3.2f (`lci_ful')  " to " %3.2f (`uci_ful') ")" ";" (`p_ful') _n
file close csvfile_hv


*===================================TYPE=======================================*

file open csvfile_hv_type using "$results\imaging_regression.csv", write append

regress hippocampal_total_bl i.inf_type 
matrix list r(table)

local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_crd_`x'=(_b[`x'.inf_type]) 
local lci_crd_`x'=(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_crd_`x'=(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_crd_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_crd_`x' = 2*ttail(e(df_r),abs(`t_crd_`x''))
}

*age and sex adjusted
regress hippocampal_total_bl i.inf_type age_bl i.sex
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_age_sex_`x'=(_b[`x'.inf_type]) 
local lci_age_sex_`x'=(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_age_sex_`x'=(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_age_sex_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_age_sex_`x' = 2*ttail(e(df_r),abs(`t_age_sex_`x''))
}

**Fully adjusted models
regress hippocampal_total_bl i.inf_type age_bl i.sex i.ethnic ant_bmi_bl i.smoking_cat ls_pa_days_bl i.ls_alc_freq3cats_bl edu_yrs_bl i.diabetes_status i.copd_cat i.asthma_cat i.hypertension_cat 
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_ful_`x'=(_b[`x'.inf_type]) 
local lci_ful_`x'=(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_ful_`x'=(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_ful_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_ful_`x' = 2*ttail(e(df_r),abs(`t_ful_`x''))
}

file write csvfile_hv_type "Other LRTI" ";" 
file write  csvfile_hv_type  %3.2f (`coef_crd_1') " (" %3.2f (`lci_crd_1')  " to " %3.2f (`uci_crd_1') ")" ";" (`p_crd_1')    
file write  csvfile_hv_type ";"  %3.2f (`coef_age_sex_1') " (" %3.2f (`lci_age_sex_1')  " to " %3.2f (`uci_age_sex_1') ")" ";" (`p_age_sex_1')  
file write  csvfile_hv_type ";"  %3.2f (`coef_ful_1') " (" %3.2f (`lci_ful_1')  " to " %3.2f (`uci_ful_1') ")" ";" (`p_ful_1')  _n

file write csvfile_hv_type "UTI" ";" 
file write  csvfile_hv_type  %3.2f (`coef_crd_2') " (" %3.2f (`lci_crd_2')  " to " %3.2f (`uci_crd_2') ")" ";" (`p_crd_2') 
file write  csvfile_hv_type ";"  %3.2f (`coef_age_sex_2') " (" %3.2f (`lci_age_sex_2')  " to " %3.2f (`uci_age_sex_2') ")" ";" (`p_age_sex_2')  
file write  csvfile_hv_type ";"  %3.2f (`coef_ful_2') " (" %3.2f (`lci_ful_2')  " to " %3.2f (`uci_ful_2') ")" ";" (`p_ful_2') _n

file write csvfile_hv_type "SSTI" ";" 
file write  csvfile_hv_type  %3.2f (`coef_crd_3') " (" %3.2f (`lci_crd_3')  " to " %3.2f (`uci_crd_3') ")" ";" (`p_crd_3') 
file write  csvfile_hv_type ";"  %3.2f (`coef_age_sex_3') " (" %3.2f (`lci_age_sex_3')  " to " %3.2f (`uci_age_sex_3') ")" ";" (`p_age_sex_3')
file write  csvfile_hv_type ";"  %3.2f (`coef_ful_3') " (" %3.2f (`lci_ful_3')  " to " %3.2f (`uci_ful_3') ")" ";" (`p_ful_3') _n
file close csvfile_hv_type


********************************************************************************
***********************White Matter Hypernsitensties****************************
********************************************************************************
*====================================ANY=======================================*

capture file close csvfile_wmh
file open csvfile_wmh using "$results\imaging_regression.csv", write append

**Crude
file write csvfile_wmh "Log of white matter hyperintensities" _n

regress log_wmh_bl i.infection_cat 

local coef_crd=exp(_b[1.infection_cat])
local lci_crd=exp(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_crd=exp(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])

local t_crd = exp(_b[1.infection_cat]/_se[1.infection_cat])
local b_crd = _b[1.infection_cat]/_se[1.infection_cat]
local p_crd = 2*ttail(e(df_r),abs(`b_crd'))


*age and sex adjusted
regress log_wmh_bl i.infection_cat age_bl i.sex
local coef_age_sex=exp(_b[1.infection_cat])
local lci_age_sex=exp(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_age_sex=exp(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])
local t_age = exp(_b[1.infection_cat]/_se[1.infection_cat])
local b_age = _b[1.infection_cat]/_se[1.infection_cat]
local p_age = 2*ttail(e(df_r),abs(`b_age'))

**Fully adjusted models

regress log_wmh_bl i.infection_cat age_bl i.sex ant_bmi_bl i.smoking_cat i.hypertension_cat
local coef_ful=exp(_b[1.infection_cat])
local lci_ful=exp(_b[1.infection_cat]- invttail(e(df_r),0.025)*_se[1.infection_cat]) 
local uci_ful=exp(_b[1.infection_cat]+ invttail(e(df_r),0.025)*_se[1.infection_cat])

local t_ful = exp(_b[1.infection_cat]/_se[1.infection_cat])
local b_ful = _b[1.infection_cat]/_se[1.infection_cat]
local p_ful = 2*ttail(e(df_r),abs(`b_ful'))


di `coef_crd'

file write csvfile_wmh "Any Infection" ";" 
file write  csvfile_wmh  %3.2f (`coef_crd') " (" %3.2f (`lci_crd')  " to " %3.2f (`uci_crd') ")" ";" (`p_crd')  
file write  csvfile_wmh ";"  %3.2f (`coef_age_sex') " (" %3.2f (`lci_age_sex')  " to " %3.2f (`uci_age_sex') ")" ";" (`p_age')
file write  csvfile_wmh ";"  %3.2f (`coef_ful') " (" %3.2f (`lci_ful')  " to " %3.2f (`uci_ful')  ")" ";" (`p_ful')  _n
file close csvfile_wmh


*===================================TYPE=======================================*

capture file close csvfile_wmh_type
file open csvfile_wmh_type using "$results\imaging_regression.csv", write append

regress log_wmh_bl i.inf_type 
matrix list r(table)

local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_crd_`x'=exp(_b[`x'.inf_type]) 
local lci_crd_`x'=exp(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_crd_`x'=exp(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_crd_`x' = exp(_b[`x'.inf_type]/_se[`x'.inf_type])
*local p_crd_`x' = 2*ttail(e(df_r),abs(`t_crd_`x''))
local b_crd_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_crd_`x' = 2*ttail(e(df_r),abs(`b_crd_`x''))

}

*age and sex adjusted
regress log_wmh_bl i.inf_type age_bl i.sex
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_age_sex_`x'=exp(_b[`x'.inf_type]) 
local lci_age_sex_`x'=exp(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_age_sex_`x'=exp(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_age_sex_`x' = exp(_b[`x'.inf_type]/_se[`x'.inf_type])
*local p_age_sex_`x' = 2*ttail(e(df_r),abs(`t_age_sex_`x''))

local b_age_sex_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_age_sex_`x' = 2*ttail(e(df_r),abs(`b_age_sex_`x''))

}

**Fully adjusted models
regress log_wmh_bl i.inf_type age_bl i.sex ant_bmi_bl i.smoking_cat i.hypertension_cat
local infectionregression_var 1 2 3
foreach x of local infectionregression_var {
local coef_ful_`x'=exp(_b[`x'.inf_type]) 
local lci_ful_`x'=exp(_b[`x'.inf_type]- invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local uci_ful_`x'=exp(_b[`x'.inf_type]+ invttail(e(df_r),0.025)*_se[`x'.inf_type]) 
local t_ful_`x' = exp(_b[`x'.inf_type]/_se[`x'.inf_type])
*local p_ful_`x' = 2*ttail(e(df_r),abs(`t_ful_`x''))
local b_ful_`x' = _b[`x'.inf_type]/_se[`x'.inf_type]
local p_ful_`x' = 2*ttail(e(df_r),abs(`b_ful_`x''))
}

file write csvfile_wmh_type "Other LRTI" ";" 
file write  csvfile_wmh_type  %3.2f (`coef_crd_1') " (" %3.2f (`lci_crd_1')  " to " %3.2f (`uci_crd_1') ")" ";" (`p_crd_1')    
file write  csvfile_wmh_type ";"  %3.2f (`coef_age_sex_1') " (" %3.2f (`lci_age_sex_1')  " to " %3.2f (`uci_age_sex_1') ")" ";" (`p_age_sex_1')  
file write  csvfile_wmh_type ";"  %3.2f (`coef_ful_1') " (" %3.2f (`lci_ful_1')  " to " %3.2f (`uci_ful_1') ")" ";" (`p_ful_1')  _n

file write csvfile_wmh_type "UTI" ";" 
file write  csvfile_wmh_type  %3.2f (`coef_crd_2') " (" %3.2f (`lci_crd_2')  " to " %3.2f (`uci_crd_2') ")" ";" (`p_crd_2') 
file write  csvfile_wmh_type ";"  %3.2f (`coef_age_sex_2') " (" %3.2f (`lci_age_sex_2')  " to " %3.2f (`uci_age_sex_2') ")" ";" (`p_age_sex_2')  
file write  csvfile_wmh_type ";"  %3.2f (`coef_ful_2') " (" %3.2f (`lci_ful_2')  " to " %3.2f (`uci_ful_2') ")" ";" (`p_ful_2') _n

file write csvfile_wmh_type "SSTI" ";" 
file write  csvfile_wmh_type  %3.2f (`coef_crd_3') " (" %3.2f (`lci_crd_3')  " to " %3.2f (`uci_crd_3') ")" ";" (`p_crd_3') 
file write  csvfile_wmh_type ";"  %3.2f (`coef_age_sex_3') " (" %3.2f (`lci_age_sex_3')  " to " %3.2f (`uci_age_sex_3') ")" ";" (`p_age_sex_3')
file write  csvfile_wmh_type ";"  %3.2f (`coef_ful_3') " (" %3.2f (`lci_ful_3')  " to " %3.2f (`uci_ful_3') ")" ";" (`p_ful_3') _n
file close csvfile_wmh_type

log close



