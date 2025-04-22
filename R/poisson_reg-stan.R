organize_stan_interval <- function(results, object, interval_type = "conf") {
  interval_type <- rlang::arg_match(interval_type, c("conf", "pred"))
  if (interval_type == "conf") {
    lvl <- object$spec$method$pred$conf_int$extras$level
    add_standard_error <- object$spec$method$pred$conf_int$extras$std_error
  } else {
    lvl <- object$spec$method$pred$pred_int$extras$level
    add_standard_error <- object$spec$method$pred$pred_int$extras$std_error
  }
  res <-
    tibble(
      .pred_lower = parsnip::convert_stan_interval(
        results,
        level = lvl
      ),
      .pred_upper = parsnip::convert_stan_interval(
        results,
        level = lvl,
        lower = FALSE
      ),
    )
  if (add_standard_error) {
    res$.std_error <- apply(results, 2, sd, na.rm = TRUE)
  }
  res
}
