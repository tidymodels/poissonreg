test_that('updating', {
  expect_snapshot(
    poisson_reg(penalty = 1) %>%
      set_engine("glmnet", lambda.min.ratio = 0.001) %>%
      update(mixture = tune())
  )
})

test_that('bad input', {
  expect_error(poisson_reg(mode = "bogus"))
  expect_error(translate(poisson_reg(mode = "regression"), engine = NULL))
  expect_error(translate(poisson_reg(formula = y ~ x)))
})

# ------------------------------------------------------------------------------
# glm execution tests

test_that("glm execution", {
  expect_error(
    res <- fit(
      glm_spec,
      count ~ .,
      data = seniors,
      control = ctrl
    ),
    regexp = NA
  )
  expect_error(
    res <- fit_xy(
      glm_spec,
      x = seniors[, 1:3],
      y = seniors$count,
      control = ctrl
    ),
    regexp = NA
  )

  expect_error(
    res <- fit(
      glm_spec,
      y ~ x,
      data = seniors,
      control = ctrl
    )
  )
})

test_that("glm prediction", {
  glm_fit <- glm(count ~ ., data = seniors, family = "poisson")
  glm_pred <- unname(predict(glm_fit, seniors[1:3, 1:3], type = "response"))

  res_xy <- fit_xy(
    glm_spec,
    x = seniors[, 1:3],
    y = seniors$count,
    control = ctrl
  )

  expect_equal(glm_pred, predict(res_xy, seniors[1:3, 1:3])$.pred)

  res_form <- fit(
    glm_spec,
    count ~ .,
    data = seniors,
    control = ctrl
  )
  expect_equal(glm_pred, predict(res_form, seniors[1:3, ])$.pred)
})

