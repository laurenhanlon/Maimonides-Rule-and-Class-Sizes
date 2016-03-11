cap log close
log using "Z:\Angrist Work\Web Papers\AngristLavy_1999\AngristLavy_Table2.log", replace

*******************************************************
* PROGRAM: AngristLavy_Table2
* PROGRAMMER: Simone Schaner (sschaner@mit.edu)
* PURPOSE: Recreates Table 2 of Angrist and Lavy (1999)
*	including Moulton ses
* DATE CREATED: 8/10/07
*******************************************************
clear
set mem 50m

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

sum avgverb
sum avgmath
	
* COL 1
mmoulton avgverb classize, cluvar(schlcode)
	
* COL 2
mmoulton avgverb classize tipuach, cluvar(schlcode)

* COL 3
mmoulton avgverb classize tipuach c_size, clu(schlcode)

* COL 4
mmoulton avgmath classize, cluvar(schlcode)
	
* COL 5
mmoulton avgmath classize tipuach, cluvar(schlcode)

* COL 6
mmoulton avgmath classize tipuach c_size, clu(schlcode)

*************************************************
* NOW DO 4th GRADE
*************************************************

clear
use final4
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

sum avgverb

sum avgmath

	
* COL 7
mmoulton avgverb classize, cluvar(schlcode)
	
* COL 8
mmoulton avgverb classize tipuach, cluvar(schlcode)

* COL 9
mmoulton avgverb classize tipuach c_size, clu(schlcode)

* COL 10
mmoulton avgmath classize, cluvar(schlcode)
	
* COL 11
mmoulton avgmath classize tipuach, cluvar(schlcode)

* COL 12
mmoulton avgmath classize tipuach c_size, clu(schlcode)

log close