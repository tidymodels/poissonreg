#' @import parsnip
#' @importFrom rlang enquo expr enquos
#' @importFrom purrr map_lgl map
#' @importFrom tibble is_tibble as_tibble tibble
#' @importFrom stats predict sd setNames quantile

# ------------------------------------------------------------------------------

# The functions below define the model information. These access the model
# environment inside of parsnip so they have to be executed once parsnip has
# been loaded.

.onLoad <- function(libname, pkgname) {
  # This defines poisson_reg in the model database
  make_poisson_reg()
}

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# nocov

#' @importFrom utils globalVariables
utils::globalVariables(
  c(".pred", "group", "level", "new_data", "object")
)

# nocov end
