
<!-- README.md is generated from README.Rmd. Please edit that file -->

# poissonreg

<!-- badges: start -->

[![R build
status](https://github.com/tidymodels/poissonreg/workflows/R-CMD-check/badge.svg)](https://github.com/tidymodels/poissonreg/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/poissonreg)](https://CRAN.R-project.org/package=poissonreg)
[![Codecov test
coverage](https://codecov.io/gh/tidymodels/poissonreg/branch/master/graph/badge.svg)](https://codecov.io/gh/tidymodels/poissonreg?branch=master)
[![R-CMD-check](https://github.com/tidymodels/poissonreg/workflows/R-CMD-check/badge.svg)](https://github.com/tidymodels/poissonreg/actions)
<!-- badges: end -->

poissonreg enables the parsnip package to fit various types of Poisson
regression models including ordinary generalized linear models, simple
Bayesian models (via rstanarm), and two zero-inflated Poisson models
(via pscl).

## Installation

You can install the released version of poissonreg from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("poissonreg")
```

Install the development version from GitHub with:

``` r
require("devtools")
install_github("tidymodels/poissonreg")
```

## Example

A log-linear model for categorical data analysis:

``` r
library(poissonreg)
#> Loading required package: parsnip

# 3D contingency table from Agresti (2007): 
poisson_reg() %>% 
  set_engine("glm") %>% 
  fit(count ~ (.)^2, data = seniors)
#> parsnip model object
#> 
#> Fit time:  6ms 
#> 
#> Call:  stats::glm(formula = count ~ (.)^2, family = stats::poisson, 
#>     data = data)
#> 
#> Coefficients:
#>               (Intercept)               marijuanayes  
#>                    5.6334                    -5.3090  
#>              cigaretteyes                 alcoholyes  
#>                   -1.8867                     0.4877  
#> marijuanayes:cigaretteyes    marijuanayes:alcoholyes  
#>                    2.8479                     2.9860  
#>   cigaretteyes:alcoholyes  
#>                    2.0545  
#> 
#> Degrees of Freedom: 7 Total (i.e. Null);  1 Residual
#> Null Deviance:       2851 
#> Residual Deviance: 0.374     AIC: 63.42
```

## Contributing

This project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

  - For questions and discussions about tidymodels packages, modeling,
    and machine learning, please [post on RStudio
    Community](https://rstd.io/tidymodels-community).

  - If you think you have encountered a bug, please [submit an
    issue](https://github.com/tidymodels/poissonreg/issues).

  - Either way, learn how to create and share a
    [reprex](https://rstd.io/reprex) (a minimal, reproducible example),
    to clearly communicate about your code.

  - Check out further details on [contributing guidelines for tidymodels
    packages](https://www.tidymodels.org/contribute/) and [how to get
    help](https://www.tidymodels.org/help/).
