#' parsnip methods for Poisson regression
#'
#' \pkg{poissonreg} offers a function to fit model to count data using Poisson
#' generalized linear models or via different methods for zero-inflated Poisson
#' (ZIP) models.
#'
#' The model function works with the tidymodels infrastructure so that the model
#' can be resampled, tuned, tided, etc.
#'
#' @includeRmd man/rmd/example.Rmd
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
##' @import parsnip
#' @importFrom rlang enquo expr enquos
#' @importFrom purrr map_lgl map
#' @importFrom tibble is_tibble as_tibble tibble
#' @importFrom stats predict sd setNames quantile
## usethis namespace: end
NULL

utils::globalVariables(
  c(".pred", "group", "level", "new_data", "object")
)
