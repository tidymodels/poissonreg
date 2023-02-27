test_that("prediction of single row", {
  skip_if_not_installed("glmnet")

  m <- poisson_reg(penalty = 0.1) %>%
    set_engine("glmnet") %>%
    fit(count ~ (.)^2, data = seniors[,2:4])

  pred_1 <- predict(m, new_data = seniors[1,], penalty = 0.1)
  expect_equal(nrow(pred_1), 1)

  multi_pred_1 <- multi_predict(m, new_data = seniors[1,])
  expect_equal(nrow(multi_pred_1), 1)
})
