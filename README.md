# Maimonides-Rule-and-Class-Sizes
Using Maimonides' Rule to Estimate the Effect of Class Size on Scholastic Achievement

# README
-------

### Using Maimonides' Rule to Estimate the Effect of Class Size on Scholastic Achievement
### Lauren Hanlon, Nadav Tadelis, Daniel Saedi

### Description:  
We came into this project with the goal of developing our statistical analysis skills, by reproducing the analyses done in "Using Maimonides' Rule to Esimate the Effect of Class Size on Scholastic Achievement", by Joshua D. Angrist and Victor Lavy, published in The Quarterly Journal of Economics. May 1999.  Our main task was to see if our own findings would also be statistically significant using the same data as Angrist and Lavy. 
The abstract of paper:  

>"The twelfth century rabbinic scholar Maimonides proposed a maximum class size of 40. This same maximum induces a nonlinear and nonmonotonic relation- ship between grade enrollment and class size in Israeli public schools today. Maimonides’ rule of 40 is used here to construct instrumental variables estimates of effects of class size on test scores. The resulting identification strategy can be viewed as an application of Donald Campbell’s regression-discontinuity design to the class-size question. The estimates show that reducing class size induces a significant and substantial increase in test scores for fourth and fifth graders, although not for third graders." (Angrist, Lavy, 1999)  

We attempted to show, using several different regressions, whether a significant effect of class size reduction could be shown for increasing test scores. We included several tables and graphs similar to the ones in Angrist and Lavy's paper to show our analysis. 

### Project Organization:  
We created a R.proj file titled "stat133final". The skeleton.R file contains the code to download the raw data, and to create subdirectories. Subdirectories include:

* code - functions and scripts; contains our data_analysis.R file
* rawdata - raw data files
* data - clean data for analysis
* resources - contains the Angrist and Lavy paper and various functions that we used for reference throughtout the project
* report - our final Rmd file and the output of LaTeX code used to create graphs
* images - our saved pngs of graphs made  

### Comments and Instructions: 
We were able to access the data from Angrist's website http://economics.mit.edu/faculty/angrist. 
We used the following packages in r to help with regressions and presentation of data: 
* rio 
* lmtest 
* texreg
* stargazer 
* AER 
* multiwayvcov 
* sandwich  

Using texreg we were able to output our data into a table format, however texreg outputs our data in LaTeX code. We have included the LaTeX output in PDF format in the resources folder, but the actual .RMD file does not include the outputted tables because we could not figure out how to knit texreg outputs. 

### Thanks and Sources:  
Special thanks to Joshua Angrist for allowing us to use his data for our analysis.  
Sources:   
Hlavac, Marek (2015). stargazer: Well-Formatted Regression and Summary Statistics Tables. R
  package version 5.2. http://CRAN.R-project.org/package=stargazer  
  
Philip Leifeld (2013). texreg: Conversion of Statistical Model Output in R to LaTeX and HTML
  Tables. Journal of Statistical Software, 55(8), 1-24. URL http://www.jstatsoft.org/v55/i08/.  
  
Chung-hong Chan, Geoffrey CH Chan, and Thomas J. Leeper (2015). rio: A Swiss-army knife for
  data file I/O. R package version 0.2.  
Achim Zeileis, Torsten Hothorn (2002). Diagnostic Checking in Regression Relationships. R News
  2(3), 7-10. URL http://CRAN.R-project.org/doc/Rnews/  
  
Nathaniel Graham, Mahmood Arai and Björn Hagströmer (2015). multiwayvcov: Multi-way Standard
  Error Clustering. R package version 1.2.2. http://CRAN.R-project.org/package=multiwayvcov  
  
Achim Zeileis (2004). Econometric Computing with HC and HAC Covariance Matrix Estimators.
  Journal of Statistical Software 11(10), 1-17. URL http://www.jstatsoft.org/v11/i10/.  
  
Achim Zeileis (2006). Object-Oriented Computation of Sandwich Estimators. Journal of
  Statistical Software 16(9), 1-16. URL http://www.jstatsoft.org/v16/i09/.  





### Authors
Nadav Tadelis: ntadelis@berkeley.edu   
Lauren Hanlon: laurenhanlon@berkeley.edu   
Daniel Saedi: d.saedi@berkeley.edu   

