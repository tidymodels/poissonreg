test_that("prediction of single row", {
  skip_if_not_installed("glmnet")

  m <- poisson_reg(penalty = 0.1) |>
    set_engine("glmnet") |>
    fit(count ~ (.)^2, data = seniors[, 2:4])

  pred_1 <- predict(m, new_data = seniors[1, ], penalty = 0.1)
  expect_equal(nrow(pred_1), 1)

  multi_pred_1 <- multi_predict(m, new_data = seniors[1, ])
  expect_equal(nrow(multi_pred_1), 1)
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
    alpha = 0.3,
    nlambda = 15
  )
  exp_pred <- predict(exp_fit, seniors_x, s = penalty_values, type = "response")

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) |>
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)
  xy_fit <- fit_xy(spec, x = seniors_x, y = seniors_y)

  expect_true(has_multi_predict(xy_fit))
  expect_equal(multi_predict_args(xy_fit), "penalty")

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
  expect_equal(f_pred, xy_pred)

  f_pred_001 <- f_pred |>
    tidyr::unnest(cols = .pred) |>
    dplyr::filter(penalty == 0.01) |>
    dplyr::pull(.pred)
  f_pred_01 <- f_pred |>
    tidyr::unnest(cols = .pred) |>
    dplyr::filter(penalty == 0.1) |>
    dplyr::pull(.pred)
  expect_equal(f_pred_001, unname(exp_pred[, 1]))
  expect_equal(f_pred_01, unname(exp_pred[, 2]))

  # check format
  expect_s3_class(f_pred, "tbl_df")
  expect_equal(names(f_pred), ".pred")
  expect_equal(nrow(f_pred), nrow(seniors))
  expect_true(
    all(purrr::map_lgl(f_pred$.pred, \(.x) all(dim(.x) == c(2, 2))))
  )
  expect_true(
    all(purrr::map_lgl(
      f_pred$.pred,
      \(.x) all(names(.x) == c("penalty", ".pred"))
    ))
  )

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
  expect_equal(f_pred_1, xy_pred_1)
  expect_equal(nrow(f_pred_1), 1)
  expect_equal(nrow(f_pred_1$.pred[[1]]), 2)
})

test_that("glmnet prediction type NULL", {
  skip_if_not_installed("glmnet")

  data(seniors, package = "poissonreg", envir = rlang::current_env())

  spec <- poisson_reg(penalty = 0.1, mixture = 0.3) |>
    set_engine("glmnet", nlambda = 15)
  f_fit <- fit(spec, count ~ ., data = seniors)

  pred <- predict(f_fit, seniors[1:5, ])
  pred_numeric <- predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(pred, pred_numeric)

  mpred <- multi_predict(f_fit, seniors[1:5, ])
  mpred_numeric <- multi_predict(f_fit, seniors[1:5, ], type = "numeric")
  expect_identical(mpred, mpred_numeric)

  mpred_pred <- mpred |>
    tidyr::unnest(cols = .pred) |>
    dplyr::pull(.pred)
  expect_identical(pred$.pred, mpred_pred)
})
