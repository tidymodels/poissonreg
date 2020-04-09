
context("Poisson regression execution with glmnet")
source("helper-objects.R")

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

  expect_true(has_multi_predict(res))
  expect_equal(multi_predict_args(res), "penalty")

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


test_that('glmnet prediction, multiple lambda', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  lams <- c(0, 0.00001)

  glmn_mult <- poisson_reg(penalty = lams, mixture = .3) %>%
    set_engine("glmnet")

  res_xy <- fit_xy(
    glmn_mult,
    control = ctrl,
    x = senior_ind[, 1:3],
    y = senior_ind$count
  )

  # mult_pred <-
  #   predict(res_xy$fit,
  #           newx = as.matrix(senior_ind[1:5, 1:3]),
  #           s = lams,
  #           type = "response")
  # mult_pred <- stack(as.data.frame(mult_pred))
  # mult_pred$penalty <- rep(lams, each = 5)
  # mult_pred$rows <- rep(1:5, 2)
  # mult_pred <- mult_pred[order(mult_pred$rows, mult_pred$penalty), ]
  # mult_pred <- mult_pred[, c("penalty", "values")]
  # names(mult_pred) <- c("penalty", ".pred")
  # mult_pred <- tibble::as_tibble(mult_pred)
  mult_pred <-
    tibble::tribble(
      ~penalty,           ~.pred,
      0,  538.72595867201,
      1e-05,  538.72595867201,
      0, 735.342850038907,
      1e-05, 735.342850038907,
      0, 283.116497320853,
      1e-05, 283.116497320853,
      0, 386.444515401008,
      1e-05, 386.444515401008,
      0, 92.1247665366651,
      1e-05, 92.1247665366651
    )

  # expect_equal(
  #   as.data.frame(mult_pred),
  #   multi_predict(
  #     res_xy,
  #     new_data = senior_ind[1:5, 1:3],
  #     lambda = lams
  #   ) %>%
  #     unnest(cols = c(.pred)) %>%
  #     as.data.frame(),
  #   tolerance = 0.0001
  # )

  res_form <- fit(
    glmn_mult,
    count ~ .,
    data = seniors,
    control = ctrl
  )

  # form_pred <-
  #   predict(res_form$fit,
  #           newx = as.matrix(senior_ind[1:5, 1:3]),
  #           s = lams, type = "response")
  # form_pred <- stack(as.data.frame(form_pred))
  # form_pred$penalty <- rep(lams, each = 5)
  # form_pred$rows <- rep(1:5, 2)
  # form_pred <- form_pred[order(form_pred$rows, form_pred$penalty), ]
  # form_pred <- form_pred[, c("penalty", "values")]
  # names(form_pred) <- c("penalty", ".pred")
  # form_pred <- tibble::as_tibble(form_pred)

  form_pred <-
    tibble::tribble(
      ~penalty,           ~.pred,
      0,  538.72595867201,
      1e-05,  538.72595867201,
      0, 735.342850038907,
      1e-05, 735.342850038907,
      0, 283.116497320853,
      1e-05, 283.116497320853,
      0, 386.444515401008,
      1e-05, 386.444515401008,
      0, 92.1247665366651,
      1e-05, 92.1247665366651
    )

  # expect_equal(
  #   as.data.frame(form_pred),
  #   multi_predict(res_form, new_data = seniors[1:5, 1:3], lambda = lams) %>%
  #     unnest(cols = c(.pred)) %>%
  #     as.data.frame(),
  #   tolerance = 0.0001
  # )
})

test_that('glmnet prediction, all lambda', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  glmn_all <- poisson_reg(mixture = .3) %>%
    set_engine("glmnet")

  res_xy <- fit_xy(
    glmn_all,
    control = ctrl,
    x = senior_ind[, 1:3],
    y = senior_ind$count
  )

  all_pred <- predict(res_xy$fit, newx = as.matrix(senior_ind[1:5, 1:3]))
  all_pred <- stack(as.data.frame(all_pred))
  all_pred$penalty <- rep(res_xy$fit$lambda, each = 5)
  all_pred$rows <- rep(1:5, length(res_xy$fit$lambda))
  all_pred <- all_pred[order(all_pred$rows, all_pred$penalty), ]
  all_pred <- all_pred[, c("penalty", "values")]
  names(all_pred) <- c("penalty", ".pred")
  all_pred <- tibble::as_tibble(all_pred)

  expect_equal(all_pred,
               multi_predict(res_xy, new_data = senior_ind[1:5, 1:3]) %>% unnest(cols = c(.pred)))

  res_form <- fit(
    glmn_all,
    count ~ .,
    data = seniors,
    control = ctrl
  )


  form_pred <- predict(res_form$fit, newx = as.matrix(senior_ind[1:5, 1:3]))
  form_pred <- stack(as.data.frame(form_pred))
  form_pred$penalty <- rep(res_form$fit$lambda, each = 5)
  form_pred$rows <- rep(1:5, length(res_form$fit$lambda))
  form_pred <- form_pred[order(form_pred$rows, form_pred$penalty), ]
  form_pred <- form_pred[, c("penalty", "values")]
  names(form_pred) <- c("penalty", ".pred")
  form_pred <- tibble::as_tibble(form_pred)

  expect_equal(
    form_pred,
    multi_predict(res_form, seniors[1:5, 1:3], penalty = res_form$fit$lambda) %>%
      unnest(cols = c(.pred))
  )
})


test_that('submodel prediction', {
  skip_on_cran()
  skip_if_not_installed("glmnet")

  reg_fit <-
    poisson_reg(penalty = 0.01) %>%
    set_engine("glmnet") %>%
    fit(count ~ ., data = senior_ind[-(1:2), ])

  pred_glmn <- predict(reg_fit$fit, as.matrix(senior_ind[1:2, -4]), s = 0.01)

  mp_res <- multi_predict(reg_fit, new_data = senior_ind[1:2, -4], penalty = 0.01)
  mp_res <- do.call("rbind", mp_res$.pred)
  expect_equal(mp_res[[".pred"]], unname(pred_glmn[,1]))

  expect_error(
    multi_predict(reg_fit, newdata = mtcars[1:4, -1], penalty = .1),
    "Did you mean"
  )

  reg_fit <-
    poisson_reg() %>%
    set_engine("glmnet") %>%
    fit(count ~ ., data = senior_ind[-(1:2), ])


  pred_glmn_all <-
    predict(reg_fit$fit, as.matrix(senior_ind[1:2, -4])) %>%
    as.data.frame() %>%
    stack() %>%
    dplyr::arrange(ind)


  mp_res_all <-
    multi_predict(reg_fit, new_data = senior_ind[1:2, -4]) %>%
    tidyr::unnest(cols = c(.pred))

  expect_equal(sort(mp_res_all$.pred), sort(pred_glmn_all$values))

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

