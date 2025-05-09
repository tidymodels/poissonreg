# glmnet call stack for poissom regression using `predict` when object has
# classes "_fishnet" and "model_fit":
#
#  predict()
# 	predict._fishnet(penalty = NULL)   <-- checks and sets penalty
#    predict.model_fit()             <-- checks for extra vars in ...
#     predict_numeric()
#      predict_numeric._fishnet()
#       predict_numeric.model_fit()
#        predict.fishnet()

# glmnet call stack for poisson regression using `multi_predict` when object has
# classes "_fishnet" and "model_fit":
#
# 	multi_predict()
#    multi_predict._fishnet(penalty = NULL)
#      predict._fishnet(multi = TRUE)          <-- checks and sets penalty
#       predict.model_fit()                  <-- checks for extra vars in ...
#        predict_raw()
#         predict_raw._fishnet()
#          predict_raw.model_fit(opts = list(s = penalty))
#           predict.fishnet()

#' @export
predict._fishnet <-
  function(
    object,
    new_data,
    type = NULL,
    opts = list(),
    penalty = NULL,
    multi = FALSE,
    ...
  ) {
    # See discussion in https://github.com/tidymodels/parsnip/issues/195
    if (is.null(penalty) & !is.null(object$spec$args$penalty)) {
      penalty <- object$spec$args$penalty
    }

    object$spec$args$penalty <- .check_glmnet_penalty_predict(
      penalty,
      object,
      multi
    )

    object$spec <- parsnip::eval_args(object$spec)
    predict.model_fit(
      object,
      new_data = new_data,
      type = type,
      opts = opts,
      ...
    )
  }

#' @export
predict_numeric._fishnet <- function(object, new_data, ...) {
  object$spec <- parsnip::eval_args(object$spec)
  parsnip::predict_numeric.model_fit(object, new_data = new_data, ...)
}

#' Model predictions across many sub-models
#'
#' For some models, predictions can be made on sub-models in the model object.
#' @param object A `model_fit` object.
#' @param new_data A rectangular data object, such as a data frame.
#' @param opts A list of options..
#' @param ... Optional arguments to pass to `predict.model_fit(type = "raw")`
#'  such as `type`.
#' @return A tibble with the same number of rows as the data being predicted.
#'  There is a list-column named `.pred` that contains tibbles with
#'  multiple rows per sub-model.
#' @export
#' @keywords internal
predict_raw._fishnet <- function(object, new_data, opts = list(), ...) {
  object$spec <- parsnip::eval_args(object$spec)
  opts$s <- object$spec$args$penalty
  parsnip::predict_raw.model_fit(object, new_data = new_data, opts = opts, ...)
}

#' @importFrom dplyr full_join as_tibble arrange
#' @importFrom tidyr gather
#' @export
#' @rdname predict_raw._fishnet
#' @param penalty A numeric vector of penalty values.
multi_predict._fishnet <-
  function(object, new_data, type = NULL, penalty = NULL, ...) {
    dots <- list(...)

    object$spec <- eval_args(object$spec)

    if (is.null(penalty)) {
      # See discussion in https://github.com/tidymodels/parsnip/issues/195
      if (!is.null(object$spec$args$penalty)) {
        penalty <- object$spec$args$penalty
      } else {
        penalty <- object$fit$lambda
      }
    }

    if (is.null(type)) {
      type <- "numeric"
    }
    if (type == "numeric") {
      # `glmnet:::predict.fishnet()` will receive `type = "response"`
      # via `parsnip:::predict_raw.model_fit` (#89)
      dots$type <- "response"
    }

    pred <- predict._fishnet(
      object,
      new_data = new_data,
      type = "raw",
      opts = dots,
      penalty = penalty,
      multi = TRUE
    )
    param_key <- tibble(group = colnames(pred), penalty = penalty)
    pred <- as_tibble(pred)
    pred$.row <- seq_len(nrow(pred))
    pred <- gather(pred, group, .pred, -.row)
    if (utils::packageVersion("dplyr") >= "1.0.99.9000") {
      pred <- full_join(param_key, pred, by = "group", multiple = "all")
    } else {
      pred <- full_join(param_key, pred, by = "group")
    }
    pred$group <- NULL
    pred <- arrange(pred, .row, penalty)
    .row <- pred$.row
    pred$.row <- NULL
    pred <- split(pred, .row)
    names(pred) <- NULL
    tibble(.pred = pred)
  }
