clear all
set more off
cd "C:\Users\RENET\OneDrive\Desktop\MOUA STATA TRAINING"
capture log close
log using "Log\moualog", replace 
/*Date cleaning and analysis work at mouau 
Stata training exercise
objective1*/
import excel using "Data\hhdata", sheet("esut") firstrow case(preserve) clear
label var s1q2 "sex of household members"
label var s1q3 "Relationship to household head"
label define s1q2 1"Male" 0"Female", replace 
label value s1q2 sex
label value s1q2 s1q2
save "Output\hhdata2", replace

use "Data\hhdata", clear 
*to check for consistency in data
sum  //summarize//
sum s1q4
sum s1q4, detail
describe
codebook s1q3, tab(1000)
codebook s1q7, tab(1000)
sort hhid
order s1q2, after(state)
order s1q7, before(s1q12b)
sort state lga
sort hhid indiv

/*STATA operators
Addition +
substaraction -
Division /
Multiplication *
power ^
and &
greater than >
less than <
greater or equal to >= and so on as seen in the manual*/
/*generating variables*/
gen hhsex=s1q2 if s1q3==1
replace hhsex=0 if hhsex==2
label define hhsex 1 "Male" 0 "Female", replace
label value hhsex hhsex
tab hhsex
gen hhage=s1q4 if s1q3==1
recode s1q7 (1 2 =1) (3 =2) (4 5 6=3) (7 =4) if s1q3==1, gen(mstat)
label define mstat 1 "married" 2 " informal Union" 3 "once married" 4 "never married",replace
label value mstat mstat
tab mstat
*Extended generate (egen)
egen mphone=min(s1q12b), by(hhid)

egen hhsize=count(indiv), by(hhid)
tab hhage
/* 16 - 20
21 - 40
41 - 60
61 - 80
81 - 100
101 - 120*/
egen hhsize_grp=cut(hhage), at (16 21 41 61 81 101 121)
tab hhsize_grp
label define hhsize_grp 16 "16 - 20" 21 "21 - 40" 41 "41 - 60" 61 "61-80" 81 "81 - 100" 101 "101 - 120", replace
label value hhsize_grp hhsize_grp
label var hhsex "sex of the household head"
label var hhage "Age of the hosuehold head"
label var mphone "Mobile phone status of the household"
label var hhsize "household size"
label var hhsize_grp "household size grouping"
label var mstat "marital status of the household head"
drop s1q2 s1q3 s1q4 s1q12b s1q7 s2aq9
keep if hhsex==1| hhsex==0
tab hhsex
drop indiv
sum
*bys hhid: keep if_n==1
save "Output\dataclean", replace

use "Data\plotdata", clear
codebook sa3iq5b
gen plotsize=.
*conversion factors
/*plots=0.0667
Accres=0.4
Hectare=1
sq Meters= 0.0001*/
*North central = 1
replace plotsize=sa3iq5a*0.00012 if sa3iq5b==1 & zone==1 //heaps//
replace plotsize=sa3iq5a*0.0027 if sa3iq5b==2 & zone==1  //ridges//
replace plotsize=sa3iq5a*0.00006 if sa3iq5b==3 & zone==1 //stands//
replace plotsize=sa3iq5a*0.667 if sa3iq5b==4 & zone==1   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==1   //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==1     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==1  //sqm//
*north east = 2
replace plotsize=sa3iq5a*0.00016 if sa3iq5b==1 & zone==2 //heaps//
replace plotsize=sa3iq5a*0.004 if sa3iq5b==2 & zone==2  //ridges//
replace plotsize=sa3iq5a*0.00016 if sa3iq5b==3 & zone==2 //stands//
replace plotsize=sa3iq5a*0.667 if sa3iq5b==4 & zone==2   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==2   //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==2     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==2  //sqm//
*North west =3 
replace plotsize=sa3iq5a*0.00011 if sa3iq5b==1 & zone==3 //heaps//
replace plotsize=sa3iq5a*0.00494 if sa3iq5b==2 & zone==3  //ridges//
replace plotsize=sa3iq5a*0.00006 if sa3iq5b==3 & zone==3 //stands//
replace plotsize=sa3iq5a*0.00004 if sa3iq5b==4 & zone==3   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==3   //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==3     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==3  //sqm//
*south east =4 
replace plotsize=sa3iq5a*0.00019 if sa3iq5b==1 & zone==4 //heaps//
replace plotsize=sa3iq5a*0.0023 if sa3iq5b==2 & zone==4  //ridges//
replace plotsize=sa3iq5a*0.00004 if sa3iq5b==3 & zone==4 //stands//
replace plotsize=sa3iq5a*0.667 if sa3iq5b==4 & zone==4   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==4   //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==4     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==4  //sqm//
*south south =5 
replace plotsize=sa3iq5a*0.00021 if sa3iq5b==1 & zone==5 //heaps//
replace plotsize=sa3iq5a*0.0023 if sa3iq5b==2 & zone==5  //ridges//
replace plotsize=sa3iq5a*0.00004 if sa3iq5b==3 & zone==5 //stands//
replace plotsize=sa3iq5a*0.667 if sa3iq5b==4 & zone==5   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==5   //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==5     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==5  //sqm//
*North west =6 
replace plotsize=sa3iq5a*0.00012 if sa3iq5b==1 & zone==6 //heaps//
replace plotsize=sa3iq5a*0.0027 if sa3iq5b==2 & zone==6  //ridges//
replace plotsize=sa3iq5a*0.00006 if sa3iq5b==3 & zone==6 //stands//
replace plotsize=sa3iq5a*0.667 if sa3iq5b==4 & zone==6   //plot//
replace plotsize=sa3iq5a*0.04 if sa3iq5b==5 & zone==6  //acres//
replace plotsize=sa3iq5a*1 if sa3iq5b==6 & zone==6     //ha//
replace plotsize=sa3iq5a*0.0001 if sa3iq5b==7 & zone==6  //sqm//



*generating the quantity of agrochemical used per plot

gen agrchm = (s11c2q11a + s11c2q2a)*plotsize

*generating the quanitity of maize harveted in naira

gen qtymz = sa3iq6a*plotsize

label var agrchm "qunatity of agrochemical used"
label var qtymz "Qunatity of maize harvested per plot"
*generating the quantity of maize harvested in naira
gen harvalue=sa3iq6a

label var harvalue "naira value of maize harvest"



*Agrochemicals
gen pesti=.
replace pesti=s11c2q2a/1000 if s11c2q2b==2 //gram//
replace pesti=s11c2q2a/100 if s11c2q2b==4 //centilitre//
replace pesti=s11c2q2a if s11c2q2b==1 //kg//
replace pesti=s11c2q2a if s11c2q2b==3 //Litre//

gen herb=. 
replace herb=s11c2q11a/1000 if s11c2q11b==2 //gram//
replace pesti=s11c2q11a/100 if s11c2q11b==4 //centilitre//
replace pesti=s11c2q11a if s11c2q11b==1 //kg//
replace pesti=s11c2q11a if s11c2q11b==3 //Litre//


gen agro=pesti + herb
egen agrochem=rowtotal (pesti herb)
replace agrochem=. if s11c2q1==.
egen totchem=sum(agrochem), by(hhid)

*fertilizer use 
gen fertuse=s11dq1a
recode fertuse (2 =0)
egen hhfertuse=max(fertuse), by(hhid)
egen plotnumb=count(plotid),by(hhid)
egen avgplotsize=mean(plotsize), by(hhid)
egen avharvalue=mean(harvalue), by(hhid)
gen yield= avharvalue/avgplotsize

*keep the first row for each observation
bys hhid: keep if _n==1
keep zone state lga sector hhid hhfertuse plotnumb avgplotsize avharvalue yield totchem

label var totchem "Total agrochemical used by hhd"
label var hhfertuse "status of household on fertilizer use"
label var plotnumb "total number of plot owned by hhid"
label var avgplotsize "average plot size owned by hhid"
label var avharvalue "average value of qty harvest"
label var yield "yield in naira per ha"
label define hhfertuse 1 "fertilizer used" 0 "no feritilizer use", replace
label value hhfertuse hhfertuse
save "output\plotdataclean", replace

*combining data
use "output\dataclean", clear
merge 1:1 hhid using "output\plotdataclean"
keep if _merge==3
drop _merge
duplicates report
duplicates list

bys hhid hhsex hhsize hhsize plotnumb: gen dup=cond(_N==1,0,_n)
duplicates drop
drop if dup>1
drop dup
save "Output\mergeddata", replace

*Transformation of data
hist yield, norm
gen lnyield=ln(yield)
hist lnyield, norm
gen logyield=log(yield)

label var lnyield "log of yield"

*graphics
graph pie, over(hhsize_grp) plabel(_all percent, size(*1.0) color(white)) legend (on) plotregion(lstyle(none)) title("Demographics Characteristics") subtitle("Sex of Household Head") note("Source: LSMS-ISA, 2018")

graph save "Output\hhgrp", replace
graph pie, over(hhsex) plabel(_all percent, size(*1.0) color(white)) legend (on) plotregion(lstyle(none)) title("Demographics Characteristics") subtitle("Sex of Household Head") note("Source: LSMS-ISA, 2018")
graph save "Output\hhsex", replace
graph bar hhage, over(hhsex)
graph save "output\agesex", replace
graph bar, over (hhsex) over (hhsize_grp)

graph box avgplotsize
graph hbox avgplotsize
graph hbox lnyield
graph save "Output\yield", replace

*combining graphics
graph combine "Output\hhsex" "Output\agesex" "Output\yield"
*Descriptive statistics
tabstat avgplotsize hhsize totchem plotnumb avharvalue yield, stat(n min max mean sd var)
tabstat avgplotsize, by(hhsize_grp) stat(n min max mean median sd var)
tab avgplotsize hhsize_grp
tab hhsize_grp hhsex
tab avgplotsize by(hhsex)

*ANOVA
robvar avgplotsize, by (hhsex) //Levene's test of equal variance assumption//
swilk avgplotsize //Test for normality of data assumption// 261 graph hbox avgplotsiz //Check for significant outliers//
oneway avgplotsize hhsex, tab

*post ANOVA test

pwmean avgplotsize, over (hhsex) mcompare (tukey) effects I

anova avgplotsize hhsex##hhfertuse

***Append

use "Data\Wave1_Plotdata", clear

recode wave (2 =1)

append using "Data\Wave3_Plotdata"
sort hhid wave
bys hhid wave: gen dupl=cond(_N==1,0,_n) //Check for repeated time values within panel//
drop if dup>1
drop dup
xtset hhid wave //hhid is Observation dimension;Gwave is the time dimension; unbalanced panel//
xtdes   //describing panel data sets  
ssc install xtbalance
xtbalance, range(1 2) //download the user-written command: xtbalance and execute to transform unbalanced to balanced panel data. Note wave is 1 and 2//
*xtreg depvar indvar, fe//fixed effects//
*xtreg depvar indvar, re //random effects//
*Regression analysis

use "Output\mergeddata", clear
reg yield avgplotsiz plotnumb hhfertuse totchem hhsize hhage hhsex
gen Inyield=ln(yield)
reg Inyield avgplotsiz plotnumb hhfertuse totchem hhsize hhage hhsex
probit hhfertuse hhsex hhage mphone hhsize plotnumb
margins, dydx(*)



