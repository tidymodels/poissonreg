# These functions are tested indirectly when the models are used. Since this
# function is executed on package startup, you can't execute them to test since
# they are already in the parsnip model database. We'll exclude them from
# coverage stats for this reason.

# nocov start
make_poisson_reg_glm <- function() {
  parsnip::set_model_engine("poisson_reg", mode = "regression", eng = "glm")
  parsnip::set_dependency(
    "poisson_reg",
    eng = "glm",
    pkg = "stats",
    mode = "regression"
  )
  parsnip::set_dependency(
    "poisson_reg",
    eng = "glm",
    pkg = "poissonreg",
    mode = "regression"
  )

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
      args = list(
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
}

make_poisson_reg_hurdle <- function() {
  parsnip::set_model_engine("poisson_reg", "regression", "hurdle")
  parsnip::set_dependency(
    "poisson_reg",
    eng = "hurdle",
    pkg = "pscl",
    mode = "regression"
  )
  parsnip::set_dependency(
    "poisson_reg",
    eng = "hurdle",
    pkg = "poissonreg",
    mode = "regression"
  )

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
      args = list(
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
}

make_poisson_reg_zeroinfl <- function() {
  parsnip::set_model_engine("poisson_reg", "regression", "zeroinfl")
  parsnip::set_dependency(
    "poisson_reg",
    eng = "zeroinfl",
    pkg = "pscl",
    mode = "regression"
  )
  parsnip::set_dependency(
    "poisson_reg",
    eng = "zeroinfl",
    pkg = "poissonreg",
    mode = "regression"
  )

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
      args = list(
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
}

make_poisson_reg_glmnet <- function() {
  parsnip::set_model_engine("poisson_reg", "regression", "glmnet")
  parsnip::set_dependency(
    "poisson_reg",
    eng = "glmnet",
    pkg = "glmnet",
    mode = "regression"
  )
  parsnip::set_dependency(
    "poisson_reg",
    eng = "glmnet",
    pkg = "poissonreg",
    mode = "regression"
  )

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
      post = parsnip::.organize_glmnet_pred,
      func = c(fun = "predict"),
      args = list(
        object = expr(object$fit),
        newx = expr(as.matrix(new_data[,
          rownames(object$fit$beta),
          drop = FALSE
        ])),
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
      args = list(
        object = expr(object$fit),
        newx = expr(as.matrix(new_data[,
          rownames(object$fit$beta),
          drop = FALSE
        ]))
      )
    )
  )
}

make_poisson_reg_stan <- function() {
  parsnip::set_model_engine("poisson_reg", "regression", "stan")
  parsnip::set_dependency(
    "poisson_reg",
    eng = "stan",
    pkg = "rstanarm",
    mode = "regression"
  )
  parsnip::set_dependency(
    "poisson_reg",
    eng = "stan",
    pkg = "poissonreg",
    mode = "regression"
  )

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
        organize_stan_interval(results, object, interval_type = "conf")
      },
      func = c(pkg = "rstanarm", fun = "posterior_epred"),
      args = list(
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
    type = "pred_int",
    value = list(
      pre = NULL,
      post = function(results, object) {
        organize_stan_interval(results, object, interval_type = "pred")
      },
      func = c(pkg = "rstanarm", fun = "posterior_predict"),
      args = list(
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
