test_that("glm execution", {
  glm_spec <- poisson_reg() |> set_engine("glm")
  ctrl <- control_parsnip(verbosity = 1, catch = FALSE)

  expect_no_error(
    fit(glm_spec, count ~ ., data = seniors, control = ctrl)
  )
  expect_no_error(
    fit_xy(glm_spec, x = seniors[, 1:3], y = seniors$count, control = ctrl)
  )
})

test_that("glm prediction", {
  glm_spec <- poisson_reg() |> set_engine("glm")
  ctrl <- control_parsnip(verbosity = 1, catch = FALSE)

  glm_fit <- glm(count ~ ., data = seniors, family = "poisson")
  glm_pred <- unname(predict(glm_fit, seniors[1:3, 1:3], type = "response"))

  res_xy <- fit_xy(
    glm_spec,
    x = seniors[, 1:3],
    y = seniors$count,
    control = ctrl
  )

  expect_equal(
    predict(res_xy, seniors[1:3, 1:3])$.pred,
    glm_pred
  )

  res_form <- fit(
    glm_spec,
    count ~ .,
    data = seniors,
    control = ctrl
  )
  expect_equal(
    predict(res_form, seniors[1:3, ])$.pred,
    glm_pred
  )
})
