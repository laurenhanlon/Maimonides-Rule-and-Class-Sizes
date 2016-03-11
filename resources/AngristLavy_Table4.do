cap log close
log using "Z:\Angrist Work\Web Papers\AngristLavy_1999\AngristLavy_Table4.log", replace

*******************************************************
* PROGRAM: AngristLavy_Table4
* PROGRAMMER: Simone Schaner (sschaner@mit.edu)
* PURPOSE: Recreates Table 4 of Angrist and Lavy (1999)
*	including Moulton ses
* DATE CREATED: 8/13/07
*******************************************************
clear
set mem 50m
set more off

cd "Z:\Angrist Work\Web Papers\AngristLavy_1999"

* YOU MUST INCLUDE THIS DO FILE TO IMPLEMENT THE OLS MOULTONS
do "Z:\Angrist Work\Web Papers\AngristLavy_1999\mmoulton_post.do"

use final5

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
g c_size2= (c_size^2)/100

* GENERATE TREND
g trend= c_size if c_size>=0 & c_size<=40
	replace trend= 20+(c_size/2) if c_size>=41 & c_size<=80
	replace trend= (100/3)+(c_size/3) if c_size>=81 & c_size<=120
	replace trend= (130/3)+(c_size/4) if c_size>=121 & c_size<=160

	
mmoulton avgverb (classize=func1) tipuach c_size c_size2, clu(schlcode) 2sls

foreach dvar in avgverb avgmath {

di " "
di "OUTCOME IS `dvar'"
di "FULL SAMPLE"
di " "
mmoulton `dvar' (classize=func1) tipu, clu(schlcode) 2sls
mmoulton `dvar' (classize=func1) tipu c_size, clu(schlcode) 2sls
mmoulton `dvar' (classize=func1) tipu c_size c_size2, clu(schlcode) 2sls
mmoulton `dvar' (classize=func1) trend, clu(schlcode) 2sls

di " "
di "OUTCOME IS `dvar'"
di "DISCONTINUITY SAMPLE"
di " "
mmoulton `dvar' (classize=func1) tipu if disc==1, clu(schlcode) 2sls
mmoulton `dvar' (classize=func1) tipu c_size if disc==1, clu(schlcode) 2sls

}

log close