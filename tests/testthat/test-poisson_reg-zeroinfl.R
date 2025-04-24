test_that("zeroinfl execution", {
  skip_if_not_installed("pscl")
  skip_on_cran()

  data("bioChemists", package = "pscl", envir = rlang::current_env())

  zeroinfl_spec <- poisson_reg() %>% set_engine("zeroinfl")
  ctrl <- control_parsnip(verbosity = 1, catch = FALSE)

  expect_no_error(
    fit(zeroinfl_spec, art ~ ., data = bioChemists, control = ctrl)
  )
  expect_no_error(
    res <- fit_xy(
      zeroinfl_spec,
      x = bioChemists[, 2:6],
      y = bioChemists$art,
      control = ctrl
    )
  )

  expect_false(has_multi_predict(res))
  expect_equal(multi_predict_args(res), NA_character_)
})

test_that("zeroinfl prediction", {
  skip_if_not_installed("pscl")
  skip_on_cran()

  data("bioChemists", package = "pscl", envir = rlang::current_env())

  zeroinfl_spec <- poisson_reg() %>% set_engine("zeroinfl")
  quiet_ctrl <- control_parsnip(verbosity = 0, catch = TRUE)

  zeroinfl_pred <- c(
    2.03795552288294,
    1.32312378302603,
    1.30870432888435,
    1.43998196151274,
    2.36323310634688
  )

  res_xy <- fit_xy(
    zeroinfl_spec,
    x = bioChemists[, 2:6],
    y = bioChemists$art,
    control = quiet_ctrl
  )

  expect_equal(
    predict(res_xy, bioChemists[1:5, 2:6])$.pred,
    zeroinfl_pred,
    tolerance = 0.001
  )

  form_pred <- c(
    1.95901387152585,
    1.33126661829735,
    1.33699534952439,
    1.51045647275656,
    2.05706336705877
  )

  res_form <- fit(
    zeroinfl_spec,
    art ~ . | 1,
    data = bioChemists,
    control = quiet_ctrl
  )
  expect_equal(
    predict(res_form, bioChemists[1:5, ])$.pred,
    form_pred,
    tolerance = 0.001
  )
})
