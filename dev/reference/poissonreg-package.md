# parsnip methods for Poisson regression

poissonreg offers a function to fit model to count data using Poisson
generalized linear models or via different methods for zero-inflated
Poisson (ZIP) models.

## Details

The model function works with the tidymodels infrastructure so that the
model can be resampled, tuned, tided, etc.

## Example

Let’s fit a model to the data from Agresti (2007) Table 7.6:

    library(poissonreg)
    library(tidymodels)
    tidymodels_prefer()

    log_lin_fit <-
      # Define the model
      poisson_reg() |>
      # Choose an engine for fitting. The default is 'glm' so
      # this next line is not strictly needed:
      set_engine("glm") |>
      # Fit the model to the data:
      fit(count ~ (.)^2, data = seniors)

    log_lin_fit

    ## parsnip model object
    ##
    ##
    ## Call:  stats::glm(formula = count ~ (.)^2, family = stats::poisson,
    ##     data = data)
    ##
    ## Coefficients:
    ##               (Intercept)               marijuanayes
    ##                    5.6334                    -5.3090
    ##              cigaretteyes                 alcoholyes
    ##                   -1.8867                     0.4877
    ## marijuanayes:cigaretteyes    marijuanayes:alcoholyes
    ##                    2.8479                     2.9860
    ##   cigaretteyes:alcoholyes
    ##                    2.0545
    ##
    ## Degrees of Freedom: 7 Total (i.e. Null);  1 Residual
    ## Null Deviance:       2851
    ## Residual Deviance: 0.374     AIC: 63.42

The different engines for the model that are provided by this package
are:

    show_engines("poisson_reg")

    ## # A tibble: 5 x 2
    ##   engine   mode
    ##   <chr>    <chr>
    ## 1 glm      regression
    ## 2 hurdle   regression
    ## 3 zeroinfl regression
    ## 4 glmnet   regression
    ## 5 stan     regression

## See also

Useful links:

- <https://github.com/tidymodels/poissonreg>

- <https://poissonreg.tidymodels.org/>

- Report bugs at <https://github.com/tidymodels/poissonreg/issues>

## Author

**Maintainer**: Hannah Frick <hannah@posit.co>
([ORCID](https://orcid.org/0000-0002-6049-5258))

Authors:

- Max Kuhn <max@posit.co>
  ([ORCID](https://orcid.org/0000-0003-2402-136X))

Other contributors:

- Posit Software, PBC (03wc8by49) \[copyright holder, funder\]
