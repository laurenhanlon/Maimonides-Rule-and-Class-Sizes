cap log close
log using "Z:\Angrist Work\Web Papers\AngristLavy_1999\AngristLavy_Table3.log", replace

*******************************************************
* PROGRAM: AngristLavy_Table3
* PROGRAMMER: Simone Schaner (sschaner@mit.edu)
* PURPOSE: Recreates Table 3 of Angrist and Lavy (1999)
*	including Moulton ses
* DATE CREATED: 8/10/07
*******************************************************
clear
set mem 50m
set more off

cd "Z:\Angrist Work\Web Papers\AngristLavy_1999"

* YOU MUST INCLUDE THIS DO FILE TO IMPLEMENT THE OLS MOULTONS
do "Z:\Angrist Work\Web Papers\AngristLavy_1999\mmoulton_post.do"

foreach dset in final5 final4 {
drop _all
use `dset'
replace avgverb= avgverb-100 if avgverb>100
replace avgmath= avgmath-100 if avgmath>100

g func1= c_size/(int((c_size-1)/40)+1)
g func2= cohsize/(int(cohsize/40)+1)

replace avgverb=. if verbsize==0
replace passverb=. if verbsize==0

replace avgmath=. if mathsize==0
replace passmath=. if mathsize==0

keep if 1<classize & classize<45 & c_size>5
keep if c_leom==1 & c_pik<3
keep if avgverb~=.

g byte disc= (c_size>=36 & c_size<=45) | (c_size>=76 & c_size<=85) | ///
	(c_size>=116 & c_size<=125)

g byte all=1

foreach samp in all disc {
	foreach var in classize avgverb avgmath {

di " "
di "SAMPLE IS `samp'"
di "DATASET IS `dset'"
di " "	
sum `var' if `samp'==1
mmoulton `var' func1 tipuach if `samp'==1, clu(schlcode) 	
mmoulton `var' func1 tipuach c_size if `samp'==1, clu(schlcode) 
}
}
}

log close

