# function to write a table displaying summary statistics

summary_statistics <- function(data, grade){
  classes <- nrow(data)
  schools <- length(unique(data$schlcode))
  stargazer(data, nobs = FALSE, mean.sd = TRUE, iqr = TRUE, type = "latex",
            median = TRUE, title = paste("Unweighted Descriptive Statistics for", grade, "Grade: ", classes, " classes, ", schools, " schools, tested in 1991"),
            covariate.labels = c("Class size", "Enrollment", "Percent disadvantaged", "Reading size", "Math size", "Average verbal", "Average math"))
}

### Function to create the discontinuity sample

discontinuity <- function(full_sample){
  full_sample <- subset(full_sample, full_sample$c_size>=36 & full_sample$c_size<=45 | full_sample$c_size>=76 & full_sample$c_size<=85 | full_sample$c_size>=116 & full_sample$c_size<=125)
}

# and for the +/- 3 discontinuity:

discontinuity3 <- function(full_sample){
  full_sample <- subset(full_sample, full_sample$c_size>=38 & full_sample$c_size<=43 | full_sample$c_size>=78 & full_sample$c_size<=83 | full_sample$c_size>=118 & full_sample$c_size<=123)
}

#Create a function to create vectors of expected class sizes according to Maiomedes rule 

expected_classize <- function(enrollment) {
  y <- c()
  for (i in 1:length(enrollment)) {
    denominator <- as.integer((enrollment[i] - 1) / 40) + 1
    y[i] <- enrollment[i] / denominator
  }
  y
}

### FUNCTION TO CORRECT STANDARD ERRORS FOR CLUSTERING (clustering to control for correlated intraschool error terms)

robust.se <- function(model, cluster){
  require(sandwich)
  require(lmtest)
  M <- length(unique(cluster))
  N <- length(cluster)
  K <- model$rank
  dfc <- (M/(M - 1)) * ((N - 1)/(N - K))
  uj <- apply(estfun(model), 2, function(x) tapply(x, cluster, sum));
  rcse.cov <- dfc * sandwich(model, meat = crossprod(uj)/N)
  rcse.se <- coeftest(model, rcse.cov)
  return(list(rcse.cov, rcse.se))
}

### CREATING THE E(CLASS SIZE | ENROLLMENT) FUNCTION
expected_classize <- function(enrollment) {
  y <- c()
  for (i in 1:length(enrollment)) {
    denominator <- as.integer((enrollment[i] - 1) / 40) + 1
    y[i] <- enrollment[i] / denominator
  }
  y
}

### CREATING THE TREND
trend_2sls <- function(enrollment) {
  y <- c()
  for (i in 1:length(enrollment)) {
    if (enrollment[i] >= 0 & enrollment[i] <= 40) {
      y[i] <- enrollment[i]
    }
    else if (enrollment[i] >= 41 & enrollment[i] <= 80) {
      y[i] <- (20 + enrollment[i]/2)
    }
    else if (enrollment[i] >= 81 & enrollment[i] <= 120) {
      y[i] <- (100/3 + enrollment[i]/3)
    }
    else if (enrollment[i] >= 121 & enrollment[i] <= 160) {
      y[i] <- (130/3 + enrollment[i]/4)
    }
  }
  y
}
