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
