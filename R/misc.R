#' @importFrom stats quantile
convert_stan_interval <- function(x, level = 0.95, lower = TRUE) {
  alpha <- (1 - level) / 2
  if (!lower) {
    alpha <- 1 - alpha
  }
  res <- apply(x, 2, quantile, probs = alpha, na.rm = TRUE)
  res <- unname(res)
  res
}


eval_args <- function(spec, ...) {
  spec$args   <- purrr::map(spec$args,   maybe_eval)
  spec$eng_args <- purrr::map(spec$eng_args, maybe_eval)
  spec
}

maybe_eval <- function(x) {
  # if descriptors are in `x`, eval fails
  y <- try(rlang::eval_tidy(x), silent = TRUE)
  if (inherits(y, "try-error"))
    y <- x
  y
}
