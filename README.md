# poissonreg

<!-- badges: start -->
[![R build status](https://github.com/tidymodels/poissonreg/workflows/R-CMD-check/badge.svg)](https://github.com/tidymodels/poissonreg/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/poissonreg)](https://CRAN.R-project.org/package=poissonreg)
[![Codecov test coverage](https://codecov.io/gh/tidymodels/poissonreg/branch/master/graph/badge.svg)](https://codecov.io/gh/tidymodels/poissonreg?branch=master)
<!-- badges: end -->

poissonreg enables the parsnip package to fit various types of Poisson regression models including ordinary generalized linear models, simple Bayesian models (via rstanarm), and two zero-inflated Poisson models (via pscl). 

## Installation

``` r
devtools::install_github("tidymodels/poissonreg")
```

## Example

A log-linear model for catgorical data analysis: 


```r
library(poissonreg)

# 3D contingency table from Agresti (2007): 
poisson_reg() %>% 
  set_engine("glm") %>% 
  fit(count ~ (.)^2, data = seniors)
#> parsnip model object
#> 
#> Fit time:  2ms 
#> 
#> Call:  stats::glm(formula = formula, family = stats::poisson, data = data)
#> 
#> Coefficients:
#>               (Intercept)               marijuanayes               cigaretteyes  
#>                    5.6334                    -5.3090                    -1.8867  
#>                alcoholyes  marijuanayes:cigaretteyes    marijuanayes:alcoholyes  
#>                    0.4877                     2.8479                     2.9860  
#>   cigaretteyes:alcoholyes  
#>                    2.0545  
#> 
#> Degrees of Freedom: 7 Total (i.e. Null);  1 Residual
#> Null Deviance:	    2851 
#> Residual Deviance: 0.374 	AIC: 63.42
```

