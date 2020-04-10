
context("Poisson regression execution with stan")

source(test_path("helpers.R"))
source(test_path("helper-objects.R"))

# ------------------------------------------------------------------------------

test_that('stan_glm execution', {
  skip_if_not_installed("rstanarm")
  skip_on_cran()

  expect_error(
    res <- fit(
      stan_spec,
      count ~ .,
      data = seniors,
      control = ctrl
    ),
    regexp = NA
  )
  expect_error(
    res <- fit_xy(
      stan_spec,
      x = seniors[, 1:3],
      y = seniors$count,
      control = ctrl
    ),
    regexp = NA
  )

  expect_false(has_multi_predict(res))
  expect_equal(multi_predict_args(res), NA_character_)

  expect_error(
    res <- fit(
      stan_spec,
      Species ~ term,
      data = seniors,
      control = ctrl
    )
  )

})


test_that('stan prediction', {
  skip_if_not_installed("rstanarm")
  skip_on_cran()

  stan_pred <- c(6.291754969016, 6.60564806379581, 5.64226626722825, 5.95615936200806,
                 4.509666320371)

  res_xy <- fit_xy(
    poisson_reg() %>% set_engine("stan", seed = 10, chains = 1, refresh = 0),
    x = seniors[, 1:3],
    y = seniors$count,
    control = quiet_ctrl
  )

  expect_equal(stan_pred, predict(res_xy, seniors[1:5, 1:3])$.pred, tolerance = 0.001)

  res_form <- fit(
    stan_spec,
    count ~ .,
    data = seniors,
    control = quiet_ctrl
  )
  expect_equal(stan_pred, predict(res_form, seniors[1:5, ])$.pred, tolerance = 0.001)
})


test_that('stan intervals', {
  skip_if_not_installed("rstanarm")
  skip_on_cran()

  res_xy <- fit_xy(
    poisson_reg() %>%
      set_engine("stan", seed = 1333, chains = 10, iter = 1000, refresh = 0),
    x = seniors[, 1:3],
    y = seniors$count,
    control = quiet_ctrl
  )

  confidence_parsnip <-
    predict(res_xy,
            new_data = seniors[1:5,],
            type = "conf_int",
            level = 0.93)

  prediction_parsnip <-
    predict(res_xy,
            new_data = seniors[1:5,],
            type = "pred_int",
            level = 0.93)

  ci_lower <- c(503.82551692366, 698.305441192173, 259.975461883233, 359.06627830285,
                80.6032220648686)
  ci_upper <- c(576.810144573584, 783.482928914321, 304.974935105559, 415.426474145917,
                101.122581030063)

  pi_lower <- c(483, 676, 244, 340, 71)
  pi_upper <- c(595, 808, 320, 433, 112)

  expect_equivalent(confidence_parsnip$.pred_lower, ci_lower, tolerance = 1e-2)
  expect_equivalent(confidence_parsnip$.pred_upper, ci_upper, tolerance = 1e-2)

  expect_equivalent(prediction_parsnip$.pred_lower,
                    pi_lower,
                    tolerance = 1e-2)
  expect_equivalent(prediction_parsnip$.pred_upper,
                    pi_upper,
                    tolerance = 1e-2)
})



