
context("Poisson regression execution with glmnet")

source(test_path("helper-objects.R"))

# ------------------------------------------------------------------------------

test_that('glmnet execution', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  expect_error(
    res <- fit_xy(
      glmn_spec,
      control = ctrl,
      x = senior_ind[, 1:3],
      y = senior_ind$count
    ),
    regexp = NA
  )

  expect_false(has_multi_predict(res))

  expect_error(
    fit(
      glmn_spec,
      iris_bad_form,
      data = iris,
      control = ctrl
    )
  )

  expect_warning(
    glmnet_xy_catch <- fit_xy(
      glmn_spec,
      x = senior_ind[, 1:3],
      y = factor(senior_ind$count),
      control = caught_ctrl
    )
  )
  expect_true(inherits(glmnet_xy_catch$fit, "try-error"))

})

test_that('glmnet prediction, single lambda', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  res_xy <- fit_xy(
    glmn_spec,
    control = ctrl,
    x = senior_ind[, 1:3],
    y = senior_ind$count
  )

  uni_pred <- c(538.72595867201, 735.342850038907, 283.116497320853, 386.444515401008,
                92.1247665366651)

  expect_equal(uni_pred, predict(res_xy, senior_ind[1:5, 1:3])$.pred, tolerance = 0.0001)

  res_form <- fit(
    glmn_spec,
    count ~ .,
    data = seniors,
    control = ctrl
  )

  expect_equal(uni_pred, predict(res_form, seniors[1:5, 1:3])$.pred, tolerance = 0.0001)
})


test_that('error traps', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  expect_error(
    poisson_reg() %>%
      set_engine("glmnet") %>%
      fit(mpg ~ ., data = mtcars[-(1:4), ]) %>%
      predict(mtcars[-(1:4), ], penalty = 0:1)
  )
  expect_error(
    poisson_reg() %>%
      set_engine("glmnet") %>%
      fit(mpg ~ ., data = mtcars[-(1:4), ]) %>%
      predict(mtcars[-(1:4), ])
  )

})

