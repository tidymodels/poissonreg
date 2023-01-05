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
