# Changelog

## poissonreg (development version)

- Predictions via
  [`multi_predict()`](https://parsnip.tidymodels.org/reference/multi_predict.html)
  for glmnet models now correctly default to mean counts instead of the
  linear predictor
  ([\#89](https://github.com/tidymodels/poissonreg/issues/89)).

- Predictions for a single observation now work for
  [`poisson_reg()`](https://parsnip.tidymodels.org/reference/poisson_reg.html)
  with the `"glmnet"` engine
  ([\#48](https://github.com/tidymodels/poissonreg/issues/48)).

- Removed the now obsolete registration of the
  [`predict_raw()`](https://parsnip.tidymodels.org/reference/predict.model_fit.html)
  generic as it is now exported from parsnip
  ([\#52](https://github.com/tidymodels/poissonreg/issues/52)).

- Removed the unused internal `s3_register()` function
  ([\#53](https://github.com/tidymodels/poissonreg/issues/53)).

- Tests on the model specification have been updated to the current
  testing pattern in parsnip and other extension packages
  ([\#55](https://github.com/tidymodels/poissonreg/issues/55)).

- The [`predict()`](https://rdrr.io/r/stats/predict.html) method for the
  `"glmnet"` engine now checks the penalty value via
  [`parsnip::.check_glmnet_penalty_predict()`](https://parsnip.tidymodels.org/reference/glmnet_helpers.html)
  instead of a copied version of the function
  ([\#57](https://github.com/tidymodels/poissonreg/issues/57)).

- Moved imports and declaration of global variables into the standard
  place ([\#59](https://github.com/tidymodels/poissonreg/issues/59)).

- Tests are now self-contained
  ([\#60](https://github.com/tidymodels/poissonreg/issues/60)).

- Predictions of type `"conf_int"` for the `"stan"` engine now use the
  function suggested by rstanarm
  ([\#86](https://github.com/tidymodels/poissonreg/issues/86)).

- Removed obsolete check on supplying `newdata` as an argument to
  [`predict()`](https://rdrr.io/r/stats/predict.html) or
  [`multi_predict()`](https://parsnip.tidymodels.org/reference/multi_predict.html)
  ([\#87](https://github.com/tidymodels/poissonreg/issues/87)).

## poissonreg 1.0.1

CRAN release: 2022-08-22

- Update to the .Rd files to generate valid HTML5

## poissonreg 1.0.0

CRAN release: 2022-06-15

- Changes for using case weights with parsnip 1.0.0.

## poissonreg 0.2.0

CRAN release: 2022-03-09

- Model definition functions
  (e.g. [`poisson_reg()`](https://parsnip.tidymodels.org/reference/poisson_reg.html))
  were moved to the parsnip package.

## poissonreg 0.1.1

CRAN release: 2021-08-07

- A default engine of `glm` was added for
  [`poisson_reg()`](https://parsnip.tidymodels.org/reference/poisson_reg.html).

- Added [`tidy()`](https://generics.r-lib.org/reference/tidy.html)
  methods for
  [`pscl::hurdle()`](https://rdrr.io/pkg/pscl/man/hurdle.html) and
  [`pscl::zeroinfl()`](https://rdrr.io/pkg/pscl/man/zeroinfl.html).

## poissonreg 0.1.0

CRAN release: 2020-10-28

- Work-around for a `glmnet` bug where different column order will
  silently produce incorrect predictions.

- [`multi_predict()`](https://parsnip.tidymodels.org/reference/multi_predict.html)
  was enabled.

- Updates to go along with new version of `parsnip`.

## poissonreg 0.0.1

CRAN release: 2020-04-14

- Added a `NEWS.md` file to track changes to the package.
