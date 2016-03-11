****************************************************************
* PROGRAM: MMoulton
* PROGRAMMER: Simone Schaner (sschaner@mit.edu)
* PURPOSE: This creates a program
*	that adjusts regression standard errors
*	for clustering using the method in 
*	Moulton (1986)
* DATE CREATED: 8/10/07
* NOTE1: you can save this as an ado file as well
* NOTE2: This program remains a work in progress. If 
*	you find mistakes or find ways to improve the
*	efficiency, email me at sschaner@mit.edu to
*	let me know.
******************************************************************

* SYNTAX: 
	* OLS: mmoulton depvar inddepvars [if] [in] [weight], cluvar(clustervar)
	* 2SLS: mmoulton depvar (enog=inst) exog [if] [in] [weight], cluvar(clustervar) 2sls
	
cap prog drop mmoulton
program define mmoulton, eclass

syntax anything [if] [in] [aw fw iw pw], [2sls] CLuvar(string)

preserve
marksample touse
qui {

if "`weight'"=="" local wt=""	
else local wt="`weight'=`exp'"

tempvar res2 sum_j sum_k sum_jk test res kr sorter
tempfile bigset

g `sorter'=`cluvar'
sort `sorter'

	keep if `touse'

	tempvar count res2 sum_j sum_k sum_jk test res kr2
	g byte `count'=1

	/* ICC FOR RESIDUAL */
	if "`2sls'"=="" {
		reg `anything' [`wt']	
		}
	else {
		ivreg `anything' [`wt']
		local exog=e(insts)
		local endog=e(instd)
		}
		
local depn=e(depvar)
local S_E_df=e(df_m)
local S_E_nobs=e(N)
local S_E_r2=e(r2)
local S_E_ar2=e(r2_a)
local S_E_rmse=e(rmse)

predict `res', res
	sum `res'
keep if e(sample)


local kr=e(df_m)+1		
scalar r2=e(r2)
scalar rmse=e(rmse)

g `res2'=`res'^2
 sum `res2' [`wt']
local var_v=r(sum)/(r(N)-`kr') /*S-SQUARED*/

	mat coeff=e(b)
	mat var=e(V)

save "`bigset'"

collapse (sum) `count' [`wt'], by(`sorter') fast
*******************************************************************************
* STEP 1) GET ALL INFO BESIDES ICCs FOR MOULTON
*******************************************************************************

qui sum `count'
	local mbar=r(mean)
	local varm=r(Var)
	local N=r(sum)
	local k=r(N)	

	drop _all
	use "`bigset'"
	
********************************************************************************
* STEP 2) CALCULATE THE ICC OF RESID AND CLUSTER VAR (rho_e)
********************************************************************************

* SUM RESIDUALS WITHIN CLUSTERS
tempfile sigma1
collapse (sum) `res' [`wt'], by(`sorter') fast
	g `sum_j'=`res'
	drop `res'
	
sort `sorter'
save "`sigma1'"
use "`bigset'"

sort `sorter'

merge `sorter' using "`sigma1'"
	drop _merge

* DOUBLE SUM W/IN GROUP, i~=k

g `sum_k'= `res'* (`sum_j'-`res')

save "`bigset'", replace

collapse (sum) `sum_k' `count' [`wt'], by(`sorter') fast
	rename `sum_k' `sum_jk'
	g `test'=`count'*(`count'-1)
	qui sum `test'
		local denom=r(sum) /* THIS IS THE DENOM OF MOULTON (1986) EQ 1 */
	qui sum `sum_jk'
		local num=r(sum) /* THIS IS THE DOUBLE SUM IN NUM, MOULTON EQ 1 */
	drop `test' `count'
sort `sorter'

drop _all
use "`bigset'"

global rho_e=`num'/(`var_v'*`denom')

************************************************************
* STEP 3) CALCULATE THE ICC OF Xs AND CLUSTER VAR (rho_x)
************************************************************
	drop `res2' `sum_j' `sum_k' `res'
	local i=2
	while `i'<=`kr' {
		tempvar res`i' res`i'2 sum_j`i' sum_k`i' sum_jk`i' 
		local ++i
		}
if "`2sls'"=="" tokenize `anything'

else {         /*FIRST HAVE TO GET FIRST STAGE PREDICTED X VALUES, THEN DO AS BEFORE*/
	tokenize "`endog'"
	local f=1
	local i=1
	local anything2=""
	while "``i''"~="" {
		tempvar ``i''
		reg ``i'' `exog'
		predict ```i''', xb
		local anything2= "`anything2' ```i'''"
		local ++i
		local ++f
		}		
	local anything2= "`depn' `anything2' `exog'" /*EXOG AND FITTED*/
	tokenize `anything2'
}	

		local i=2
		local saving=""
		while `i'<=`kr' {
			local x1="``i''"
			local xvars=""
				local j=2
				while `j'<=`kr' {
					if `i'!=`j' {
						local xvars= "`xvars' ``j''"
					}
					local ++j
				}	
		reg `x1' `xvars' [`wt'] /*PARTIAL OUT X VARS*/
		predict `res`i'', r
		g `res`i'2'= `res`i''^2
			qui sum `res`i'2' [`wt']
			local var_v`i'= r(sum)/(r(N)-`kr'-1)
			drop `res`i'2'
		local saving="`saving' `res`i''"
		local ++i
	}
	
* SUM RESIDUALS WITHIN CLUSTERS

save "`bigset'", replace

tempfile sigma3

collapse (sum) `saving' [`wt'], by(`sorter') fast
		local i=2
		while `i'<=`kr' {
			rename `res`i'' `sum_j`i''
		local ++i
		}
	sort `sorter'

save "`sigma3'"
use "`bigset'"

sort `sorter'
merge `sorter' using "`sigma3'"
	drop _merge

* DOUBLE SUM W/IN GROUP, i~=k
local saving=""
local i=2
	while `i'<=`kr' {	
	g `sum_k`i''= `res`i''* (`sum_j`i''-`res`i'')
	local saving="`saving' `sum_k`i''"
	local ++i
	}

tempfile sigma4

collapse (sum) `saving' `count' [`wt'], by(`sorter') fast
	local i=2
	while `i'<=`kr' {
		rename `sum_k`i'' `sum_jk`i''
		local ++i
	}

	g `test'=`count'*(`count'-1)
	qui sum `test'
		local denom=r(sum) /* THIS IS THE DENOM OF MOULTON (1986) EQ 1 */

	local i=2
	while `i'<=`kr' {
		qui sum `sum_jk`i''
			local num`i'=r(sum) /* THIS IS THE DOUBLE SUM IN NUM, MOULTON EQ 1 */
		local ++i
	}

	drop `test' `count'
	drop _all
	
use "`bigset'"
mat se= J(`kr',1,.)
	local i=2
	while `i'<=`kr' {
		global rho_x`i'=`num`i''/(`var_v`i''*`denom')
		global moulton`i'=(1+(`varm'/`mbar'+`mbar'-1)*$rho_e*(`num`i''/(`var_v`i''*`denom')))^.5
		mat se[`i'-1,1]= ((var[`i'-1,`i'-1])^.5)*(1+(`varm'/`mbar'+`mbar'-1)*$rho_e*(`num`i''/(`var_v`i''*`denom')))^.5
		mat var[`i'-1,`i'-1]=var[`i'-1,`i'-1]*(1+(`varm'/`mbar'+`mbar'-1)*$rho_e*(`num`i''/(`var_v`i''*`denom')))

	local ++i
	}
	local ct=`kr'+1
	global moulton`ct'=(1+(`varm'/`mbar'+`mbar'-1)*$rho_e*1)^.5
	mat var[`kr',`kr']=var[`kr',`kr']*(1+(`varm'/`mbar'+`mbar'-1)*$rho_e*1)
}

        if "`2sls'"=="" {
		#delimit ;
		di _n in gr
        "OLS Regression: standard errors " _col(55)
        "Number of obs  =" in yel %8.0f `S_E_nobs' _n
        in gr "adjusted for cluster effects using Moulton"
        _col(55) in gr "R-squared      ="
        in yel %8.4f `S_E_r2' _n
        _col(55) in gr "Adj R-squared  ="
        in yel %8.4f `S_E_ar2' _n
        _col(55) in gr "Root MSE       ="
        in yel %8.0g `S_E_rmse' _n `addline'  ;
        #delimit cr
		}
		else {
		#delimit ;
		di _n in gr
        "2SLS Regression: standard errors " _col(55)
        "Number of obs  =" in yel %8.0f `S_E_nobs' _n
        in gr "adjusted for cluster effects using Moulton"
        _col(55) in gr "R-squared      ="
        in yel %8.4f `S_E_r2' _n
        _col(55) in gr "Adj R-squared  ="
        in yel %8.4f `S_E_ar2' _n
        _col(55) in gr "Root MSE       ="
        in yel %8.0g `S_E_rmse' _n `addline'  ;
        #delimit cr
		}
       ereturn post coeff var, esample(`touse') depname(`depn') dof(`S_E_df') obs(`S_E_nobs')
	   ereturn display

	  ereturn local clustvar "`cluvar'"
	  ereturn local cmd "moulton"
	  

end
