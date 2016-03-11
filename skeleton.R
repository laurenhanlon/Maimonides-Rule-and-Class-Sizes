# SKELETON

dir <- "~/stat133final"
setwd(dir)
getwd()

# create subdirectories
dir.create("code") #functions and scripts
dir.create("rawdata") #only raw data files
dir.create("data") #clean data for analysis
dir.create("resources") #articles, references, inspiring things
dir.create("report") #final report, slides
dir.create("images") #images, plots, figures

# Download datasets

dir <- "~/stat133final/rawdata/"
setwd(dir)

library('rio')

download.file("http://economics.mit.edu/files/1358", destfile = "final5_raw_data.dta")
raw_data_final5 <- import('final5_raw_data.dta')
View(raw_data_final5)

download.file("http://economics.mit.edu/files/1359", destfile = "final4_raw_data.dta")
raw_data_final4 <- import('final4_raw_data.dta')
View(raw_data_final4)

# Download paper and other resources

dir <- "~/stat133final/resources"
setwd(dir)

download.file("http://economics.mit.edu/files/8273", destfile = "Using Maimonides' Rule to Estimate the Effect of Class Size on Scholastic Achievement")

#Notes: These programs produce Tables II-V in the published paper. The program mmoulton_post.do implements a Moulton (1986) clustering adjustment for OLS and 2SLS and is used by the other .do files. 
#These are STATA translations of the original SAS programs. The switch in software generates slightly different RMSEs.
#Files downloaded from http://economics.mit.edu/faculty/angrist/data1/data/anglavy99

download.file("http://economics.mit.edu/files/1373", destfile = "AngristLavy_Table2.do")
download.file("http://economics.mit.edu/files/1374", destfile = "AngristLavy_Table3.do")
download.file("http://economics.mit.edu/files/1375", destfile = "AngristLavy_Table4.do")
download.file("http://economics.mit.edu/files/1376", destfile = "AngristLavy_Table5.do")
download.file("http://economics.mit.edu/files/1377", destfile = "mmoulton_post.do")

