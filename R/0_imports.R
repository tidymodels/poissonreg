# nocov
#' @import parsnip
#' @importFrom rlang enquo expr enquos
#' @importFrom purrr map_lgl map
#' @importFrom tibble is_tibble as_tibble tibble
#' @importFrom stats predict sd setNames quantile

# ------------------------------------------------------------------------------

#' @importFrom utils globalVariables
utils::globalVariables(
  c(".pred", "group", "level", "new_data", "object")
)

# nocov end

# ------------------------------------------------------------------------------

# The functions below define the model information. These access the model
# environment inside of parsnip so they have to be executed once parsnip has
# been loaded.

.onLoad <- function(libname, pkgname) {
  # This defines poisson_reg in the model database
  make_poisson_reg()
}

# ------------------------------------------------------------------------------
# The generic for predict_raw is not exported so make one here (if needed)

if (!any(getNamespaceExports("parsnip") == "predict_raw")) {
  predict_raw <- function(object, ...) {
    UseMethod("predict_raw")
  }
}

