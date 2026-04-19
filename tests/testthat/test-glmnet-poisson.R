library(poissonreg)

test_that("glmnet model object", {
  skip_if_not_installed("glmnet")
  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  exp_fit <- glmnet::glmnet(
    x = seniors_x,
    y = seniors_y,
    family = "poisson",
    alpha = 0.3,
    nlambda = 15
  )

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)

  expect_no_error({
    f_fit <- fit(spec, count ~ ., data = seniors)
  })
  expect_no_error({
    xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)
  })

  expect_identical(f_fit$fit, xy_fit$fit)
  # removing call element
  expect_identical(f_fit$fit[-11], exp_fit[-11])
})

test_that("glmnet prediction: type numeric", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  exp_fit <- glmnet::glmnet(
    x = seniors_x,
    y = seniors_y,
    family = "poisson",
    alpha = 0.3,
    nlambda = 15
  )
  exp_pred <- predict(exp_fit, seniors_x, s = 0.1, type = "response")

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  f_pred <- predict(f_fit, seniors)
  xy_pred <- predict(xy_fit, seniors_x)
  expect_identical(f_pred, xy_pred)
  expect_identical(f_pred$.pred, as.vector(exp_pred))

  # check format
  expect_s3_class(f_pred, "tbl_df")
  expect_identical(names(f_pred), ".pred")
  expect_identical(nrow(f_pred), nrow(seniors))

  # single prediction
  skip_if_not_installed("poissonreg", minimum_version = "1.0.1.9000")
  f_pred_1 <- predict(f_fit, seniors[1, ])
  expect_identical(nrow(f_pred_1), 1L)
  xy_pred_1 <- predict(xy_fit, seniors_x[1, , drop = FALSE])
  expect_identical(nrow(xy_pred_1), 1L)
})

test_that('glmnet prediction: column order of `new_data` irrelevant', {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  expect_identical(
    predict(xy_fit, seniors_x[, 3:1]),
    predict(xy_fit, seniors_x)
  )
})

test_that("glmnet prediction: type raw", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  exp_fit <- glmnet::glmnet(
    x = seniors_x,
    y = seniors_y,
    family = "poisson",
    alpha = 0.3,
    nlambda = 15
  )
  exp_pred <- predict(exp_fit, seniors_x, s = 0.1)

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  f_pred <- predict(f_fit, seniors, type = "raw")
  xy_pred <- predict(xy_fit, seniors_x, type = "raw")
  expect_identical(f_pred, xy_pred)
  expect_identical(f_pred, exp_pred)

  # single prediction
  skip_if_not_installed("poissonreg", minimum_version = "1.0.1.9000")
  f_pred_1 <- predict(f_fit, seniors[1, ], type = "raw")
  expect_identical(nrow(f_pred_1), 1L)
  xy_pred_1 <- predict(xy_fit, seniors_x[1, , drop = FALSE], type = "raw")
  expect_identical(nrow(xy_pred_1), 1L)
})

test_that("formula interface can deal with missing values", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())

  seniors$alcohol[1] <- NA

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)

  f_pred <- predict(f_fit, seniors)
  expect_identical(nrow(f_pred), nrow(seniors))
  expect_identical(f_pred$.pred[1], NA_real_)
})

test_that("model errors on missing penalty value", {
  skip_if_not_installed("parsnip", minimum_version = "1.2.1.9003")
  skip_if_not_installed("glmnet")

  expect_snapshot(error = TRUE, {
    poisson_reg() %>%
      set_engine("glmnet") %>%
      fit(mpg ~ ., data = mtcars[-(1:4), ])
  })
})

test_that("predict() errors with multiple penalty values", {
  skip_if_not_installed("glmnet")
  skip_if_not_installed("parsnip", minimum_version = "1.2.1.9001")

  skip_if_not_installed("poissonreg", minimum_version = "1.0.1.9000")
  expect_snapshot(error = TRUE, {
    poisson_reg(penalty = 0.1) %>%
      set_engine("glmnet") %>%
      fit(mpg ~ ., data = mtcars[-(1:4), ]) %>%
      predict(mtcars[-(1:4), ], penalty = 0:1)
  })
})

test_that("multi_predict() errors with wrong type", {
  skip("until fixed")
  skip_if_not_installed("glmnet")
  skip_if_not_installed("parsnip", minimum_version = "1.2.1.9003")

  expect_snapshot(error = TRUE, {
    poisson_reg(penalty = 0.01) %>%
      set_engine("glmnet") %>%
      fit(mpg ~ ., data = mtcars) %>%
      multi_predict(mtcars, type = "class")
  })
})

test_that("glmnet multi_predict(): type numeric", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  penalty_values <- c(0.01, 0.1)

  exp_fit <- glmnet::glmnet(
    x = seniors_x,
    y = seniors_y,
    family = "poisson",
    alpha = 0.3
  )
  exp_pred <- predict(exp_fit, seniors_x, s = penalty_values, type = "response")

  spec <- poisson_reg(penalty = 0.123, mixture = 0.3) %>% set_engine("glmnet")
  f_fit <- fit(spec, count ~ ., data = seniors)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  expect_true(has_multi_predict(xy_fit))
  expect_identical(multi_predict_args(xy_fit), "penalty")

  f_pred <- multi_predict(
    f_fit,
    seniors,
    type = "numeric",
    penalty = penalty_values
  )
  xy_pred <- multi_predict(
    xy_fit,
    seniors_x,
    type = "numeric",
    penalty = penalty_values
  )
  expect_identical(f_pred, xy_pred)

  f_pred_001 <- f_pred %>%
    tidyr::unnest(cols = .pred) %>%
    dplyr::filter(penalty == 0.01) %>%
    dplyr::pull(.pred)
  f_pred_01 <- f_pred %>%
    tidyr::unnest(cols = .pred) %>%
    dplyr::filter(penalty == 0.1) %>%
    dplyr::pull(.pred)
  expect_identical(f_pred_001, unname(exp_pred[, 1]))
  expect_identical(f_pred_01, unname(exp_pred[, 2]))

  # check format
  expect_s3_class(f_pred, "tbl_df")
  expect_identical(names(f_pred), ".pred")
  expect_identical(nrow(f_pred), nrow(seniors))
  expect_all_equal(purrr::map(f_pred$.pred, dim), list(c(2, 2)))
  expect_all_equal(purrr::map(f_pred$.pred, names), list(c("penalty", ".pred")))

  # single prediction
  f_pred_1 <- multi_predict(
    f_fit,
    seniors[1, ],
    type = "numeric",
    penalty = penalty_values
  )
  xy_pred_1 <- multi_predict(
    xy_fit,
    seniors_x[1, , drop = FALSE],
    type = "numeric",
    penalty = penalty_values
  )
  expect_identical(f_pred_1, xy_pred_1)
  expect_identical(nrow(f_pred_1), 1L)
  expect_identical(nrow(f_pred_1$.pred[[1]]), 2L)
})

test_that("glmnet multi_predict(): type NULL", {
  skip_if_not_installed("glmnet")
  skip_if_not_installed("parsnip", minimum_version = "1.0.4.9002")

  data(seniors, package = "poissonreg", envir = rlang::current_env())

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)

  pred <- predict(f_fit, seniors[1:5, ])
  pred_numeric <- predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(pred, pred_numeric)

  mpred <- multi_predict(f_fit, seniors[1:5, ])
  mpred_numeric <- multi_predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(mpred, mpred_numeric)
})

test_that("multi_predict() with default or single penalty value", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())
  seniors_x <- model.matrix(~., data = seniors[, -4])[, -1]
  seniors_y <- seniors$count

  exp_fit <- glmnet::glmnet(
    x = seniors_x,
    y = seniors_y,
    family = "poisson",
    alpha = 0.3
  )

  spec <- poisson_reg(penalty = 0.123, mixture = 0.3) %>% set_engine("glmnet")
  f_fit <- fit(spec, count ~ ., data = seniors)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  # Can deal with single penalty value
  expect_no_error(
    f_pred <- multi_predict(f_fit, new_data = seniors, penalty = 0.1)
  )
  expect_no_error(
    xy_pred <- multi_predict(xy_fit, new_data = seniors_x, penalty = 0.1)
  )
  expect_identical(f_pred, xy_pred)
  exp_pred <- predict(exp_fit, seniors_x, s = 0.1, type = "response")
  f_pred_01 <- f_pred %>%
    tidyr::unnest(cols = .pred) %>%
    dplyr::pull(.pred)
  expect_identical(f_pred_01, unname(exp_pred[, 1]))

  # Can predict using default penalty. See #108
  expect_no_error(
    f_pred <- multi_predict(f_fit, new_data = seniors)
  )
  expect_no_error(
    xy_pred <- multi_predict(xy_fit, new_data = seniors_x)
  )
  expect_identical(f_pred, xy_pred)
  exp_pred <- predict(exp_fit, seniors_x, s = 0.123, type = "response")
  f_pred_0123 <- f_pred %>%
    tidyr::unnest(cols = .pred) %>%
    dplyr::pull(.pred)
  expect_identical(f_pred_0123, unname(exp_pred[, 1]))
})

test_that("base-R families: type numeric", {
  skip("until fixed")
  skip_if_not_installed("glmnet")
  skip_if_not_installed("parsnip", minimum_version = "1.0.4.9002")

  data(seniors, package = "poissonreg", envir = rlang::current_env())

  # quasipoisson() as an example for a base-R family
  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15, family = stats::quasipoisson())
  f_fit <- fit(spec, count ~ ., data = seniors)

  expect_true(has_multi_predict(f_fit))
  expect_identical(multi_predict_args(f_fit), "penalty")

  pred <- predict(f_fit, seniors[1:5, ], type = "numeric")
  pred_005 <- predict(f_fit, seniors[1:5, ], type = "numeric", penalty = 0.05)
  mpred <- multi_predict(f_fit, seniors[1:5, ], type = "numeric")
  mpred_005 <- multi_predict(
    f_fit,
    seniors[1:5, ],
    type = "numeric",
    penalty = 0.05
  )

  expect_identical(names(pred), ".pred")
  expect_all_equal(purrr::map(mpred$.pred, names), list(c("penalty", ".pred")))
  expect_identical(
    pred$.pred,
    mpred %>% tidyr::unnest(cols = .pred) %>% pull(.pred)
  )
  expect_identical(
    pred_005$.pred,
    mpred_005 %>% tidyr::unnest(cols = .pred) %>% pull(.pred)
  )

  mpred <- multi_predict(
    f_fit,
    seniors[1:5, ],
    type = "numeric",
    penalty = c(0.05, 0.1)
  )

  expect_all_equal(purrr::map(mpred$.pred, dim), list(c(2, 2)))
})

test_that("base-R families: prediction type NULL", {
  skip_if_not_installed("glmnet")
  skip_if_not_installed("parsnip", minimum_version = "1.0.4.9002")

  data(seniors, package = "poissonreg", envir = rlang::current_env())

  # quasipoisson() as an example for a base-R family
  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) %>%
    set_engine("glmnet", nlambda = 15, family = stats::quasipoisson())
  f_fit <- fit(spec, count ~ ., data = seniors)

  pred <- predict(f_fit, seniors[1:5, ])
  pred_numeric <- predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(pred, pred_numeric)

  mpred <- multi_predict(f_fit, seniors[1:5, ])
  mpred_numeric <- multi_predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(mpred, mpred_numeric)
})
