#' We'll model the number of articles published by graduate students in biochemistry Ph.D. programs.

#+ results = "hide", messages = FALSE
library(tidymodels)
library(poissonreg)
tidymodels_prefer()

data(bioChemists, package = "pscl")

biochemists_train <- bioChemists[-c(1:5), ]
biochemists_test <- bioChemists[1:5, ]
