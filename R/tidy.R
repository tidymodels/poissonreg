#' Turn zero-inflated model results into a tidy tibble
#'
#' @param x A `hurdle` or `zeroinfl` model object.
#' @param model A character string for which model coefficients to return:
#' "all", "count", or "zero".
#' @param ... Not currently used.
#' @return A tibble
#'
#' @name tidy_zip

tidy_mat <- function(x, model) {
  ret <- tibble::as_tibble(x, rownames = "term")
  colnames(ret) <- c("term", "estimate", "std.error", "statistic", "p.value")
  ret$model <- model
  dplyr::relocate(ret, model, .after = "term")
}

.tidy <- function(x, model = "count") {
  model <- rlang::arg_match0(model, c("count", "zero", "all"), "model")
  x <- summary(x)
  if (model == "count") {
    res <- tidy_mat(x$coefficients$count, "count")
  } else if (model == "zero") {
    res <- tidy_mat(x$coefficients$count, "zero")
  } else {
    res <-
      dplyr::bind_rows(
        tidy_mat(x$coefficients$count, "count"),
        tidy_mat(x$coefficients$count, "zero")
      )
  }
  res
}

#' @export
#' @rdname tidy_zip
tidy.zeroinfl <- tidy_mat

#' @export
#' @rdname tidy_zip
tidy.hurdle <- tidy_mat




