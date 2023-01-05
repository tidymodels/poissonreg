# this tests primary and engine args here rather than in parsnip because
# it requires the engines to be loaded

test_that("arguments", {
  basic <- poisson_reg()
  penalty <- poisson_reg(penalty = 1)
  mixture <- poisson_reg(penalty = 1, mixture = 0.128)
  mixture_tune <- poisson_reg(penalty = 1, mixture = tune())

  expect_snapshot(translate_args(basic))
  expect_snapshot(translate_args(penalty %>% set_engine("glmnet")))
  expect_snapshot(translate_args(penalty %>% set_engine("glmnet", path_values = 4:2)))
  expect_snapshot(translate_args(mixture %>% set_engine("glmnet")))
  expect_snapshot(translate_args(mixture_tune %>% set_engine("glmnet")))
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

