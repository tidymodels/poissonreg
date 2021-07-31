# These functions are tested indirectly when the models are used. Since this
# function is executed on package startup, you can't execute them to test since
# they are already in the parsnip model database. We'll exclude them from
# coverage stats for this reason.

# nocov
make_poisson_reg <- function() {
  parsnip::set_new_model("poisson_reg")

  parsnip::set_model_mode("poisson_reg", "regression")

  # ------------------------------------------------------------------------------

  parsnip::set_model_engine("poisson_reg", "regression", "glm")
  parsnip::set_dependency("poisson_reg", "glm", "stats")
  parsnip::set_dependency("poisson_reg", "glm", "poissonreg")

  parsnip::set_fit(
    model = "poisson_reg",
    eng = "glm",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "weights"),
      func = c(pkg = "stats", fun = "glm"),
      defaults = list(family = expr(stats::poisson))
    )
  )

  parsnip::set_encoding(
    model = "poisson_reg",
    eng = "glm",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = TRUE,
      remove_intercept = TRUE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "glm",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = expr(object$fit),
          newdata = expr(new_data),
          type = "response"
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "glm",
    mode = "regression",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(object = expr(object$fit), newdata = expr(new_data))
    )
  )

  # ------------------------------------------------------------------------------

  parsnip::set_model_engine("poisson_reg", "regression", "hurdle")
  parsnip::set_dependency("poisson_reg", "hurdle", "pscl")
  parsnip::set_dependency("poisson_reg", "hurdle", "poissonreg")

  parsnip::set_fit(
    model = "poisson_reg",
    eng = "hurdle",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "weights"),
      func = c(pkg = "pscl", fun = "hurdle"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "poisson_reg",
    eng = "hurdle",
    mode = "regression",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "hurdle",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = expr(object$fit),
          newdata = expr(new_data)
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "hurdle",
    mode = "regression",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(object = expr(object$fit), newdata = expr(new_data))
    )
  )

  # ------------------------------------------------------------------------------

  parsnip::set_model_engine("poisson_reg", "regression", "zeroinfl")
  parsnip::set_dependency("poisson_reg", "zeroinfl", "pscl")
  parsnip::set_dependency("poisson_reg", "zeroinfl", "poissonreg")

  parsnip::set_fit(
    model = "poisson_reg",
    eng = "zeroinfl",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "weights"),
      func = c(pkg = "pscl", fun = "zeroinfl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "poisson_reg",
    eng = "zeroinfl",
    mode = "regression",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "zeroinfl",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = expr(object$fit),
          newdata = expr(new_data)
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "zeroinfl",
    mode = "regression",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(object = expr(object$fit), newdata = expr(new_data))
    )
  )

  # ------------------------------------------------------------------------------

  parsnip::set_model_engine("poisson_reg", "regression", "glmnet")
  parsnip::set_dependency("poisson_reg", "glmnet", "glmnet")
  parsnip::set_dependency("poisson_reg", "glmnet", "poissonreg")

  parsnip::set_model_arg(
    model = "poisson_reg",
    eng = "glmnet",
    parsnip = "penalty",
    original = "lambda",
    func = list(pkg = "dials", fun = "penalty"),
    has_submodel = TRUE
  )


  parsnip::set_model_arg(
    model = "poisson_reg",
    eng = "glmnet",
    parsnip = "mixture",
    original = "alpha",
    func = list(pkg = "dials", fun = "mixture"),
    has_submodel = FALSE
  )

  parsnip::set_fit(
    model = "poisson_reg",
    eng = "glmnet",
    mode = "regression",
    value = list(
      interface = "matrix",
      protect = c("x", "y", "weights"),
      func = c(pkg = "glmnet", fun = "glmnet"),
      defaults = list(family = "poisson")
    )
  )

  parsnip::set_encoding(
    model = "poisson_reg",
    eng = "glmnet",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = TRUE,
      remove_intercept = TRUE,
      allow_sparse_x = TRUE
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "glmnet",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = organize_glmnet_pred,
      func = c(fun = "predict"),
      args =
        list(
          object = expr(object$fit),
          newx = expr(as.matrix(new_data[, rownames(object$fit$beta)])),
          type = "response",
          s = expr(object$spec$args$penalty)
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "glmnet",
    mode = "regression",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(object = expr(object$fit),
             newx = expr(as.matrix(new_data[, rownames(object$fit$beta)])))
    )
  )

  # ------------------------------------------------------------------------------

  parsnip::set_model_engine("poisson_reg", "regression", "stan")
  parsnip::set_dependency("poisson_reg", "stan", "rstanarm")
  parsnip::set_dependency("poisson_reg", "stan", "poissonreg")

  parsnip::set_fit(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "weights"),
      func = c(pkg = "rstanarm", fun = "stan_glm"),
      defaults = list(family = expr(stats::poisson))
    )
  )

  parsnip::set_encoding(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(object = expr(object$fit), newdata = expr(new_data))
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    type = "conf_int",
    value = list(
      pre = NULL,
      post = function(results, object) {
        res <-
          tibble(
            .pred_lower =
              parsnip::convert_stan_interval(
                results,
                level = object$spec$method$pred$conf_int$extras$level
              ),
            .pred_upper =
              parsnip::convert_stan_interval(
                results,
                level = object$spec$method$pred$conf_int$extras$level,
                lower = FALSE
              ),
          )
        if (object$spec$method$pred$conf_int$extras$std_error)
          res$.std_error <- apply(results, 2, sd, na.rm = TRUE)
        res
      },
      func = c(pkg = "rstanarm", fun = "posterior_linpred"),
      args =
        list(
          object = expr(object$fit),
          newdata = expr(new_data),
          transform = TRUE,
          seed = expr(sample.int(10^5, 1))
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    type = "pred_int",
    value = list(
      pre = NULL,
      post = function(results, object) {
        res <-
          tibble(
            .pred_lower =
              parsnip::convert_stan_interval(
                results,
                level = object$spec$method$pred$pred_int$extras$level
              ),
            .pred_upper =
              parsnip::convert_stan_interval(
                results,
                level = object$spec$method$pred$pred_int$extras$level,
                lower = FALSE
              ),
          )
        if (object$spec$method$pred$pred_int$extras$std_error)
          res$.std_error <- apply(results, 2, sd, na.rm = TRUE)
        res
      },
      func = c(pkg = "rstanarm", fun = "posterior_predict"),
      args =
        list(
          object = expr(object$fit),
          newdata = expr(new_data),
          seed = expr(sample.int(10^5, 1))
        )
    )
  )

  parsnip::set_pred(
    model = "poisson_reg",
    eng = "stan",
    mode = "regression",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(object = expr(object$fit), newdata = expr(new_data))
    )
  )

}

# nocov end

