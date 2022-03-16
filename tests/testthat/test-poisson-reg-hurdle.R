test_that("hurdle execution", {
  skip_if_not_installed("pscl")
  skip_on_cran()

  data("bioChemists", package = "pscl")

  expect_error(
    res <- fit(
      hurdle_spec,
      art ~ .,
      data = bioChemists,
      control = ctrl
    ),
    regexp = NA
  )
  expect_error(
    res <- fit_xy(
      hurdle_spec,
      x = bioChemists[, 2:6],
      y = bioChemists$art,
      control = ctrl
    ),
    regexp = NA
  )

  expect_false(has_multi_predict(res))
  expect_equal(multi_predict_args(res), NA_character_)

  expect_error(
    res <- fit(
      hurdle_spec,
      Species ~ term,
      data = bioChemists,
      control = ctrl
    )
  )
})


test_that("hurdle prediction", {
  skip_if_not_installed("pscl")
  skip_on_cran()

  hurdle_pred <- c(
    2.00569689955261, 1.29916133671851,
    1.30005204940495, 1.43756150261801,
    2.37677697507562
  )

  res_xy <- fit_xy(
    hurdle_spec,
    x = bioChemists[, 2:6],
    y = bioChemists$art,
    control = quiet_ctrl
  )

  expect_equal(hurdle_pred, predict(res_xy, bioChemists[1:5, 2:6])$.pred, tolerance = 0.001)

  form_pred <- c(
    1.83402584880366, 1.45332695575065,
    1.43412114470316, 1.58891378718055,
    1.855682964733
  )

  res_form <- fit(
    hurdle_spec,
    art ~ . | 1,
    data = bioChemists,
    control = quiet_ctrl
  )
  expect_equal(form_pred, predict(res_form, bioChemists[1:5, ])$.pred, tolerance = 0.001)
})
