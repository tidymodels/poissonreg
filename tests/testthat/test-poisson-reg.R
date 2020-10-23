context("Poisson regression")

source(test_path("helpers.R"))
source(test_path("helper-objects.R"))

# ------------------------------------------------------------------------------

test_that('primary arguments', {
  basic <- poisson_reg()
  basic_lm <- translate(basic %>% set_engine("glm"))
  basic_glmnet <- translate(basic %>% set_engine("glmnet"))
  basic_stan <- translate(basic %>% set_engine("stan"))
  expect_equal(basic_lm$method$fit$args,
               list(
                 formula = expr(missing_arg()),
                 data = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 family = expr(stats::poisson)
               )
  )
  expect_equal(basic_glmnet$method$fit$args,
               list(
                 x = expr(missing_arg()),
                 y = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 family = "poisson"
               )
  )
  expect_equal(basic_stan$method$fit$args,
               list(
                 formula = expr(missing_arg()),
                 data = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 family = expr(stats::poisson)
               )
  )

  mixture <- poisson_reg(mixture = 0.128)
  mixture_glmnet <- translate(mixture %>% set_engine("glmnet"))
   expect_equal(mixture_glmnet$method$fit$args,
               list(
                 x = expr(missing_arg()),
                 y = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 alpha = new_empty_quosure(0.128),
                 family = "poisson"
               )
  )

  penalty <- poisson_reg(penalty = 1)
  penalty_glmnet <- translate(penalty %>% set_engine("glmnet"))
  expect_equal(penalty_glmnet$method$fit$args,
               list(
                 x = expr(missing_arg()),
                 y = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 family = "poisson"
               )
  )

  mixture_v <- poisson_reg(mixture = varying())
  mixture_v_glmnet <- translate(mixture_v %>% set_engine("glmnet"))
  expect_equal(mixture_v_glmnet$method$fit$args,
               list(
                 x = expr(missing_arg()),
                 y = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 alpha = new_empty_quosure(varying()),
                 family = "poisson"
               )
  )

})

test_that('engine arguments', {
  glm_fam <- poisson_reg() %>% set_engine("glm", model = FALSE)
  expect_equal(translate(glm_fam)$method$fit$args,
               list(
                 formula = expr(missing_arg()),
                 data = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 model = new_empty_quosure(FALSE),
                 family = expr(stats::poisson)
               )
  )

  glmnet_nlam <- poisson_reg() %>% set_engine("glmnet", nlambda = 10)
  expect_equal(translate(glmnet_nlam)$method$fit$args,
               list(
                 x = expr(missing_arg()),
                 y = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 nlambda = new_empty_quosure(10),
                 family = "poisson"
               )
  )

  stan_samp <- poisson_reg() %>% set_engine("stan", chains = 1, iter = 5)
  expect_equal(translate(stan_samp)$method$fit$args,
               list(
                 formula = expr(missing_arg()),
                 data = expr(missing_arg()),
                 weights = expr(missing_arg()),
                 chains = new_empty_quosure(1),
                 iter = new_empty_quosure(5),
                 family = expr(stats::poisson)
               )
  )

})


test_that('updating', {
  expr1     <- poisson_reg() %>% set_engine("glm", model = FALSE)
  expr1_exp <- poisson_reg(mixture = 0) %>% set_engine("glm", model = FALSE)

  expr2     <- poisson_reg(mixture = varying()) %>% set_engine("glmnet")
  expr2_exp <- poisson_reg(mixture = varying()) %>% set_engine("glmnet", nlambda = 10)

  expr3     <- poisson_reg(mixture = 0, penalty = varying()) %>% set_engine("glmnet")
  expr3_exp <- poisson_reg(mixture = 1) %>% set_engine("glmnet")

  expr4     <- poisson_reg(mixture = 0) %>% set_engine("glmnet", nlambda = 10)
  expr4_exp <- poisson_reg(mixture = 0) %>% set_engine("glmnet", nlambda = 10, pmax = 2)

  expr5     <- poisson_reg(mixture = 1) %>% set_engine("glmnet", nlambda = 10)
  expr5_exp <- poisson_reg(mixture = 1) %>% set_engine("glmnet", nlambda = 10, pmax = 2)

  expect_equal(update(expr1, mixture = 0), expr1_exp)
  expect_equal(update(expr3, mixture = 1, fresh = TRUE), expr3_exp)

  param_tibb <- tibble::tibble(mixture = 1/3, penalty = 1)
  param_list <- as.list(param_tibb)

  expr4_updated <- update(expr4, param_tibb)
  expect_equal(expr4_updated$args$mixture, 1/3)
  expect_equal(expr4_updated$args$penalty, 1)
  expect_equal(expr4_updated$eng_args$nlambda, rlang::quo(10))

  expr4_updated_lst <- update(expr4, param_list)
  expect_equal(expr4_updated_lst$args$mixture, 1/3)
  expect_equal(expr4_updated_lst$args$penalty, 1)
  expect_equal(expr4_updated_lst$eng_args$nlambda, rlang::quo(10))

})

test_that('bad input', {
  expect_error(poisson_reg(mode = "classification"))
  expect_error(translate(poisson_reg(), engine = "wat?"))
  expect_error(translate(poisson_reg(), engine = NULL))
  expect_error(translate(poisson_reg(formula = y ~ x)))
  expect_error(translate(poisson_reg(x = seniors[,1:3], y = factor(seniors$count)) %>% set_engine("glmnet")))
  expect_error(translate(poisson_reg(formula = y ~ x)  %>% set_engine("glm")))
})

test_that('printing', {
  expect_output(print(poisson_reg()))
})


# ------------------------------------------------------------------------------

test_that('glm execution', {

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

test_that('glm prediction', {
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

test_that('newdata error trapping', {
  res_xy <- fit_xy(
    glm_spec,
    x = seniors[, 1:3],
    y = seniors$count,
    control = ctrl
  )
  expect_error(predict(res_xy, newdata = seniors[1:3, 1:3]), "Did you mean")
})

test_that('default engine', {
  expect_warning(
    fit <- poisson_reg() %>% fit(mpg ~ ., data = mtcars),
    "Engine set to"
  )
  expect_true(inherits(fit$fit, "glm"))
})

