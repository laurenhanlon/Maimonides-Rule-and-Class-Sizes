# DATA CLEANING

download.file("http://economics.mit.edu/files/1358", destfile = "final5_raw_data.dta")
raw_data_final5 <- import('final5_raw_data.dta')
View(raw_data_final5)

download.file("http://economics.mit.edu/files/1359", destfile = "final4_raw_data.dta")
raw_data_final4 <- import('final4_raw_data.dta')
View(raw_data_final4)

# inspect the data
dim(raw_data_final5)
head(raw_data_final5)
summary(raw_data_final5)
colnames(raw_data_final5)

# function to reformat data from .dta to .csv

clean_data <- function(rawdata, cleandata, filename){
  cleandata <- rawdata[-19]
  cleandata <- sapply(cleandata, as.numeric)
  cleandata <- as.data.frame(cleandata)
  
  dir <- "~/stat133final/rawdata/"
  setwd(dir)
  write.csv(cleandata, file = filename)
}

clean_data(raw_data_final4, working_data_final4, "cleaner_data_final4.csv")
clean_data(raw_data_final5, working_data_final5, "cleaner_data_final5.csv")

# load data in correct format

working_data_final4 <- read.csv("cleaner_data_final4.csv", header = TRUE)
working_data_final5 <- read.csv("cleaner_data_final5.csv", header = TRUE)

# fixing avgmath and avgverb

working_data_final5$avgmath[which(working_data_final5$avgmath > 100)] <- working_data_final5$avgmath[which(working_data_final5$avgmath > 100)] - 100
working_data_final5$avgverb[which(working_data_final5$avgverb > 100)] <- working_data_final5$avgverb[which(working_data_final5$avgverb > 100)] - 100

working_data_final4$avgmath[which(working_data_final4$avgmath > 100)] <- working_data_final4$avgmath[which(working_data_final4$avgmath > 100)] - 100
working_data_final4$avgverb[which(working_data_final4$avgverb > 100)] <- working_data_final4$avgverb[which(working_data_final4$avgverb > 100)] - 100

# replace avgmath and passmath with NA if mathsize == 0

working_data_final5$avgmath[working_data_final5$mathsize == 0] <- NA
working_data_final5$passmath[working_data_final5$mathsize == 0] <- NA

# remove impossible values

working_data_final5 <- subset(working_data_final5, 1 < working_data_final5$classize & 
                                working_data_final5$classize < 45 &
                                working_data_final5$c_size > 5)

working_data_final4 <- subset(working_data_final4, 1 < working_data_final4$classize & 
                                working_data_final4$classize < 45 &
                                working_data_final4$c_size > 5)
# remove NAs

new_working_data_final5 <- subset(working_data_final5, is.na(working_data_final5$avgverb) == FALSE)
new_working_data_final4 <- subset(working_data_final4, is.na(working_data_final4$avgverb) == FALSE)
# All we needed to do was remove the 5 observations that had NA's for avgmath and avgverb (it was the same 5 observations). 
# It was purely by chance that when we cleaned the data we removed 5 observations, so the old regressions worked with the new class codes, but just by luck
# We should double check that this isn't a problem with other variables in our regression

# save the data in data folder

save_data <- function(cleandata, filename){
  dir <- "~/stat133final/data/"
  setwd(dir)
  write.csv(cleandata, file = filename)
}

save_data(new_working_data_final4, "final4.csv")
save_data(new_working_data_final5, "final5.csv")
