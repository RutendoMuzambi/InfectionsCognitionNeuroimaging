/*=========================================================================
DO FILE NAME:			maincohort_cognition.do

AUTHOR:					Rutendo Muzambi


DATE VERSION CREATED: 	04/2021
						
DESCRIPTION OF FILE:	
*=========================================================================*/

///////////////MAIN CHARACTERISTICS/////////////////////////////////////////////

*****1. Cognitive function tests

use "$cleandata\maincohort_cognition", clear
codebook patid // 16,728 
count if sepsis==1 // 23
count if uti==1 // 674
count if ssti==1 // 532
count if pneumonia==1 // 45
count if lrti_other==1 // 1,691
count if infection_cat==1 // 2,971
count if gp_infection==1 // 2,770
count if hospital_infection==1 // 201

sum age_bl, d // Mean           55.58626 Std. Dev.      7.499433

tab sex 
/*

        sex |      Freq.     Percent        Cum.
------------+-----------------------------------
     Female |      8,576       51.27       51.27
       Male |      8,152       48.73      100.00
------------+-----------------------------------
      Total |     16,728      100.00

*/

/////Missing/////////////

count if edu_yrs_bl==. //65
count if ant_bmi_bl==. //40
count if sep_townsend_bl==. //10
tab ethnic,m
/*

  Ethnicity: main |
           groups |      Freq.     Percent        Cum.
------------------+-----------------------------------
   White European |     16,323       97.58       97.58
      South Asian |        110        0.66       98.24
African Caribbean |         76        0.45       98.69
   Mixed or other |        177        1.06       99.75
                . |         42        0.25      100.00
------------------+-----------------------------------
            Total |     16,728      100.00

*/


tab ls_pa_days_bl,m
/*


   Baseline |
  number of |
  days/week |
   moderate |
   physical |
   activity |
   >10 mins |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,969       11.77       11.77
          1 |      1,631        9.75       21.52
          2 |      2,657       15.88       37.40
          3 |      2,671       15.97       53.37
          4 |      1,685       10.07       63.44
          5 |      2,207       13.19       76.64
          6 |        792        4.73       81.37
          7 |      2,669       15.96       97.33
          . |        447        2.67      100.00
------------+-----------------------------------
      Total |     16,728      100.00



*/


tab ls_alc_freq3cats_bl,m

/*

      Baseline alcohol intake |
     frequency - 3 categories |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
              Rarely or never |      2,192       13.10       13.10
          1-8 times per month |      6,159       36.82       49.92
16 times per month- every day |      8,374       50.06       99.98
                            . |          3        0.02      100.00
------------------------------+-----------------------------------
                        Total |     16,728      100.00


*/



tab smoking_cat,m
/*


 Smoking status |      Freq.     Percent        Cum.
----------------+-----------------------------------
   Never smoker |     12,060       72.09       72.09
Previous smoker |      3,650       21.82       93.91
 Current smoker |      1,001        5.98       99.90
              . |         17        0.10      100.00
----------------+-----------------------------------
          Total |     16,728      100.00


*/

codebook patid if edu_yrs_bl==. |ant_bmi_bl==. | ethnic==.| ls_alc_freq3cats_bl==. | ls_pa_days_bl==.| edu_yrs_bl==.|sep_townsend_bl==. // 585


sum time_since_bl, d

/*

. sum time_since_bl, d

        Time between baseline and most recent repeat
                     assessment (years)
-------------------------------------------------------------
      Percentiles      Smallest
 1%     2.696783       2.332649
 5%      3.22245       2.335387
10%     4.016427       2.335387       Obs              16,693
25%     5.305955       2.338125       Sum of Wgt.      16,693

50%     7.627652                      Mean           7.288307
                        Largest       Std. Dev.      2.285691
75%     9.180014       11.50171
90%     10.13552       11.51266       Variance       5.224384
95%     10.52156       11.54552       Skewness      -.3154508
99%     10.99795        11.7399       Kurtosis       2.000046
*/

gen cog_FUP2=0
replace cog_FUP2=1 if reaction_time_FU1==1 & reaction_time_FU2
replace cog_FUP2=1 if pairs_matching_FU1==1 & pairs_matching_FU2==1
replace cog_FUP2=1 if fluid_intel_FU1==1 & fluid_intel_FU2==1
replace cog_FUP2=1 if prosp_mem_FU1==1 & prosp_mem_FU2==1

*count if (reaction_time_FU1==1 & reaction_time_FU2)|(pairs_matching_FU1==1 & pairs_matching_FU2==1)|(fluid_intel_FU1==1 & fluid_intel_FU2==1)|prosp_mem_FU1==1 & prosp_mem_FU2==1)


table1_mc, by(infection_cat)  vars(time_since_bl_1 conts \ time_since_bl_2 conts \ time_since_bl conts \ age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \ ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin) missing format(%9.2f) clear //saving($results\table1_cognition, replace)
table1_mc_dta2docx using $results/table1_cognition, replace

/*
table1_mc, vars(mean_reaction_time0 contn \ mean_reaction_time1 contn \ mean_reaction_time2 contn \ pairs_match_score_0 contn \ pairs_match_score_1 contn \ pairs_match_score_2 contn \ fluid_intel_rvscore0 contn \ fluid_intel_rvscore0 contn \fluid_intel_rvscore1 contn \fluid_intel_rvscore2 contn \ prosp_mem_score_base bin\ prosp_mem_score_fup1 bin \ prosp_mem_score_fup2 bin) missing format(%9.2f) clear //saving($results\table0_cognition_fup, replace)
table1_mc_dta2docx using $results/table0_cognition_fup, replace
*/

*****2. Neuroimaging at baseline
use "$cleandata\maincohort_imaging", clear
codebook patid // 14,712
count if sepsis==1 // 17
count if uti==1 // 569
count if ssti==1 // 431
count if pneumonia==1 // 42
count if lrti_other==1 // 1,372
count if infection_cat==1 //  2,435
count if gp_infection==1 // 2,262
count if hospital_infection==1 // 173

sum age_bl, d // Mean             54.82225 Std. Dev.      7.462649

tab sex // 

/*
        sex |      Freq.     Percent        Cum.
------------+-----------------------------------
     Female |      7,781       52.89       52.89
       Male |      6,931       47.11      100.00
------------+-----------------------------------
      Total |     14,712      100.00


*/

/////Missing/////////////

count if edu_yrs_bl==. //53
count if ant_bmi_bl==. //28
count if sep_townsend_bl==. //
tab ethnic,m
/*


  Ethnicity: main |
           groups |      Freq.     Percent        Cum.
------------------+-----------------------------------
   White European |     14,275       97.03       97.03
      South Asian |        135        0.92       97.95
African Caribbean |         76        0.52       98.46
   Mixed or other |        185        1.26       99.72
                . |         41        0.28      100.00
------------------+-----------------------------------
            Total |     14,712      100.00

*/


tab ls_pa_days_bl,m
/*



   Baseline |
  number of |
  days/week |
   moderate |
   physical |
   activity |
   >10 mins |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,656       11.26       11.26
          1 |      1,437        9.77       21.02
          2 |      2,371       16.12       37.14
          3 |      2,354       16.00       53.14
          4 |      1,488       10.11       63.25
          5 |      1,926       13.09       76.35
          6 |        725        4.93       81.27
          7 |      2,396       16.29       97.56
          . |        359        2.44      100.00
------------+-----------------------------------
      Total |     14,712      100.00


*/


tab ls_alc_freq3cats_bl,m

/*

      Baseline alcohol intake |
     frequency - 3 categories |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
              Rarely or never |      1,860       12.64       12.64
          1-8 times per month |      5,399       36.70       49.34
16 times per month- every day |      7,447       50.62       99.96
                            . |          6        0.04      100.00
------------------------------+-----------------------------------
                        Total |     14,712      100.00


*/



tab smoking_cat,m
/*

    smoking_cat |      Freq.     Percent        Cum.
----------------+-----------------------------------
   Never smoker |     10,670       72.53       72.53
Previous smoker |      3,138       21.33       93.86
 Current smoker |        889        6.04       99.90
              . |         15        0.10      100.00
----------------+-----------------------------------
          Total |     14,712      100.00



*/

codebook patid if edu_yrs_bl==. |ant_bmi_bl==. | ethnic==.| ls_alc_freq3cats_bl==. | ls_pa_days_bl==.| edu_yrs_bl==.|sep_townsend_bl==. // 461


tab hippocampal_cat_bl wmh_cat_bl

/*
hippocampa |      wmh_cat_bl
  l_cat_bl |         0          1 |     Total
-----------+----------------------+----------
         0 |         0          2 |         2 
         1 |       315     14,395 |    14,710 
-----------+----------------------+----------
     Total |       315     14,397 |    14,712 
*/


table1_mc, by(infection_cat)  vars (age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \  ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) missing format(%9.2f) clear 
table1_mc_dta2docx using $results/table1_imaging, replace  






///////////////MISSING CHARACTERISTICS COGNITION TESTS//////////////////////////


***Missing on all cognitive function tests excluding those without baseline (n=200) and follow up


**************************with cognitive function tests

use "$cleandata\missingcohort_cognition_fup", clear
append using "$cleandata\maincohort_cognition"
gen cohort=0 if main==1
replace cohort=1 if missing==1

label define cohort 0"Main cohort" 1"Missing"
label val cohort cohort
label var cohort "Included/missing"

label var mean_reaction_time0 "Reaction time score baseline"

gen pairs_match_score_0=n_399_0_2+1
gen pairs_match_score_1=n_399_1_2+1
gen pairs_match_score_2=n_399_2_2+1

foreach x in 0 1 2 {
gen ln_pairs_match_score`x' = ln(pairs_match_score_`x')
}

label var ln_pairs_match_score0 "Pairs Matching score baseline"

foreach x in 0 1 2 {
gen fluid_intel_rvscore`x'=n_20016_`x'_0
}

***Reverse the scores of the variables
foreach var of varlist fluid_intel_rvscore0 fluid_intel_rvscore1 fluid_intel_rvscore2 {
       recode `var' (13=0) (12=1) (11=2) (10=3) (9=4) (8=5) (7=6) (6=7) (5=8) (4=9) (3=10) (2=11) (1=12) (0=13)
}

label var fluid_intel_rvscore0 "Verbal-numeric reasoning baseline"

label var prosp_mem_score_base "Prospective Memory (Baseline)"

table1_mc, by(cohort)  vars(infection_cat bin \ inf_alltypes cat \ gp_infection cat \ hospital_infection cat \ infection_number contn \ age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \ ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ mean_reaction_time0 contn \ pairs_match_score_0 contn \ fluid_intel_rvscore0 contn \ prosp_mem_score_base bin) missing format(%9.2f) clear
table1_mc_dta2docx using $results/table1_cognition_missing_bl, replace


***Missing on all cognitive function tests including baseline (n=200) and follow up

use "$cleandata\missingcohort_cognition_fup", clear
append using "$cleandata\maincohort_cognition"
gen cohort=0 if main==1
replace cohort=1 if missing==1

label define cohort 0"Main cohort" 1"Missing"
label val cohort cohort
label var cohort "Included/missing"


table1_mc, by(cohort)  vars(infection_cat cat \ inf_alltypes cat \ gp_infection cat \ hospital_infection cat \ consult_no contn \ consult_cat cat \ age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \ ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) format(%9.2f) clear
table1_mc_dta2docx using $results/table1_cognition_missing_fup, replace

***Missing on first repeat assessment only

use "$cleandata\missingcohort_cognition_repeat1", clear
table1_mc, by(infection_cat)  vars(age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ ant_bmi_bl contn \ edu_yrs_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) clear
table1_mc_dta2docx using $results/table1_cognition_missing_fup1, replace

***Missing on imaging visit only
/*
use "$cleandata\maincohort_cognition_repeat2", clear
table1_mc, by(infection_cat)  vars(age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \ ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) clear
table1_mc_dta2docx using $results/table1_cognition_missing_fup2, replace
*/

///////////////MISSING CHARACTERISTICS IMAGING TESTS//////////////////////////
***ALL

use "$cleandata\missingcohort_imaging_all", clear
append using "$cleandata\maincohort_imaging"

gen cohort=0 if main==1
replace cohort=1 if missing==1

label define cohort 0"Main cohort" 1"Missing"
label val cohort cohort
label var cohort "Included/missing"

merge 1:1 patid using "$cleandata\maincohort_cognition", keepusing(n_399_0_2 n_20016_0_0  mean_reaction_time0 prosp_mem_score_base)

br patid _merge n_399_0_2 n_20016_0_0  mean_reaction_time0

codebook patid if _m==3 //16,716

label var mean_reaction_time0 "Reaction time score baseline"

gen pairs_match_score0=n_399_0_2+1

label var pairs_match_score0 "Pairs Matching errors baseline"


gen fluid_intel_rvscore0=n_20016_0_0


***Reverse the scores of the variables
recode fluid_intel_rvscore0 (13=0) (12=1) (11=2) (10=3) (9=4) (8=5) (7=6) (6=7) (5=8) (4=9) (3=10) (2=11) (1=12) (0=13)

label var fluid_intel_rvscore0 "Verbal-numeric reasoning baseline"

label var prosp_mem_score_base "Prospective Memory (Baseline)"


table1_mc, by(cohort)  vars(infection_cat cat \ inf_alltypes cat \ gp_infection cat \ hospital_infection cat \ age_bl contn \ age_bl conts\ age_cat cat \ female cat \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \ ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \  smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin \ mean_reaction_time0 contn \ pairs_match_score0 contn \ fluid_intel_rvscore0 contn \ prosp_mem_score_base bin ) missing format(%9.2f) clear
table1_mc_dta2docx using $results/table1_imaging_missing_bl, replace



////////////////////////////HIPPOCAMPAL VOLUME//////////////////////////////////////////////////////////
use "$cleandata\maincohort_imaging", clear

keep if hippocampal_cat_bl==1

table1_mc, by(infection_cat)  vars (age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \  ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) missing format(%9.2f) clear 
table1_mc_dta2docx using $results/table1_hv, replace  


////////////////////////////WMH VOLUME//////////////////////////////////////////////////////////

use "$cleandata\maincohort_imaging", clear

keep if wmh_cat_bl==1

table1_mc, by(infection_cat)  vars (age_bl contn \ age_bl conts\ age_cat cat \ female bin \ ethnic cat \ diabetes_status cat \ edu_yrs_bl contn \  ant_bmi_bl contn \ ant_bmi_bl conts\ sep_townsend_bl contn\ ls_pa_days_bl conts \ smoking_cat cat \ ls_alc_freq3cats_bl cat \ anx_dep_cat bin \ smi_cat bin\ ibd_cat bin \ multiple_sclerosis_cat bin \ RA_cat bin \ psoriasis_cat bin \ asthma_cat bin \ ckd_cat bin \ cld_cat bin \ copd_cat bin \ heart_failure_cat bin\ hypertension_cat bin \ obs_sleep_cat bin \ stroke_cat bin\ tbi_cat bin \ steroids_cat bin \ benzodiazepines_cat bin \ ppi_cat bin) missing format(%9.2f) clear 
table1_mc_dta2docx using $results/table1_wmhv, replace  


/////////////////////INFECTION PROFILE//////////////////////////////////////////


use "$cleandata\missingcohort_cognition_fup", clear
append using "$cleandata\maincohort_cognition"
gen cohort=0 if main==1
replace cohort=1 if missing==1

label define cohort 0"Main cohort" 1"Missing"
label val cohort cohort
label var cohort "Included/missing"

keep if infection_cat==1

***Infection category

recode infection_number 1=0 2=1 3/max=2 , gen(inf_num_cat)
label values inf_num_cat inf_num_cat
label define inf_num_cat 0"1 infection" 1"2 infections" 2"3+ infections" 
label var inf_num_cat "Infection number category"
tab inf_num_cat

gen dead=0
replace dead=1 if !mi(dt_death)

label define dead 0"Alive" 1"Dead"
label val dead dead
label var dead "Mortality"

merge m:1 patid using "$datadir/infection_death"

gen inf_death_cat=0
replace inf_death_cat=1 if cod_lrti==1
replace inf_death_cat=1 if cod_uti==1
replace inf_death_cat=1 if cod_ssti==1
replace inf_death_cat=1 if cod_pneumonia==1
replace inf_death_cat=1 if cod_sepsis==1

table1_mc, by(cohort)  vars(infection_cat bin \ inf_alltypes cat \ gp_infection cat \ hospital_infection cat \ infection_number contn \ inf_num_cat cat \ dead bin \ inf_death_cat cat) missing format(%9.2f) clear
table1_mc_dta2docx using $results/tablex_inf_profile, replace


//////////////////////////////////////////////////////////////////////////////////

use "$cleandata\maincohort_cognition", clear
merge 1:1 patid using "$cleandata\maincohort_imaging"



