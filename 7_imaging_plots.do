
*****Hippocampal volume***********

clear all
import excel "$results/neuroimaging plots", cellrange(A2:F10) firstrow

label values Adjust Adjust
label define Adjust 0"Minimally adjusted model" 1"Fully adjusted model" 
label var Adjust "Adjustment"

*save "$cleandata\plot_hv", replace

*metan Coefficient lci uci, effect(Coefficient) lcols(Infection) by(Adjust) astext(75) xsize(26) ysize(25) nowt nobox nooverall xlabel(-100,52) graphregion(color(white))

metan Coefficient lci uci, effect(Coefficient) lcols(Infection) by(Adjust) astext(50) xsize(26) ysize(17) nowt nobox nooverall nosubgroup xlabel(-100,100) graphregion(color(white)) pointopt ( msymbol(s)  msize(small)) title("A. Hippocampal volume", position(11) color(black) size(medsmall))  bgcolor(white)


graph save "Graph" "$results/hippocampal_plot.gph", replace


*****White matter hyperintensities volume***********

clear all
import excel "$results/neuroimaging plots", cellrange(H2:M10) firstrow

label values Adjust Adjust
label define Adjust 0"Minimally adjusted model" 1"Fully adjusted model" 
label var Adjust "Adjustment"

rename Exp Coefficient

metan Coefficient lci uci, effect(Coefficient) lcols(Infection) by(Adjust) astext(50) xsize(25) ysize(15) null(1) nowt nobox nooverall nosubgroup  xlabel(0.9, 1, 1.2) graphregion(color(white)) pointopt ( msymbol(s)  msize(small)) title("B. WMH volume", position(11) color(black) size(medsmall)) bgcolor(white)


graph save "Graph" "J:\EHR-Working\Rutendo\Infections_cognition_UKB\Data\results\wmh_plot.gph", replace

graph combine "$results/hippocampal_plot.gph" "$results/wmh_plot.gph", iscale(0.5) xsize(12) graphregion(color(white))



********************************************************************************
***************************************TIMING***********************************
********************************************************************************


clear all
import excel "$results/timing plots", cellrange(A2:F22) firstrow

gen OR=Coefficient if test_cat==3
gen Exp=Coefficient if test_cat==1

label var Time "Year(s) before baseline"

preserve
keep if test_cat==0
drop OR
drop Exp
metan Coefficient lci uci, effect(Coefficient) lcols(Time) astext(75) xsize(26) ysize(26) nowt nobox nooverall xlabel(-2,2) graphregion(color(white)) pointopt ( msymbol(s)  msize(small)) title("A. Mean correct response time", position(11) color(black) size(medsmall)) 

graph save "Graph" "$results\RT_timing.gph", replace

restore

preserve
keep if test_cat==1
drop Coefficient
drop OR

rename Exp Coefficient

metan Coefficient lci uci, effect(Coefficient) lcols(Time) astext(75) xsize(26) ysize(26) nowt nobox nooverall xlabel(-0.02,0.02) graphregion(color(white)) pointopt ( msymbol(s)  msize(small)) title("B. Visual Memory", position(11) color(black) size(medsmall)) dp(2)

graph save "Graph" "$results/pairs_timing.gph", replace

restore

preserve
keep if test_cat==2
drop OR
drop Exp
metan Coefficient lci uci, effect(Coefficient) lcols(Time) astext(75) xsize(26) ysize(26) nowt nobox nooverall xlabel(-0.05,0.1) graphregion(color(white)) pointopt ( msymbol(s)  msize(small)) title("C. Fluid Intelligence", position(11) color(black) size(medsmall)) dp(2)

graph save "Graph" "$results/fluid_timing.gph", replace
restore

keep if test_cat==3
drop Exp
drop Coefficient

metan OR lci uci, effect(OR) lcols(Time) astext(75) xsize(26) ysize(26) nowt nobox nooverall null(1) xlabel(0,3) graphregion(color(white)) pointopt ( msymbol(s)  msize(small))  title("D. Prospective memory", position(11) color(black) size(medsmall)) 

graph save "Graph" "$results/prosp_mem.gph", replace



graph combine "$results/RT_timing.gph" "$results/pairs_timing.gph" "$results/fluid_timing.gph" "$results/prosp_mem.gph", iscale(0.6) xsize(6) graphregion(color(white))





