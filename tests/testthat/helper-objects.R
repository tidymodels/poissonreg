library(rlang)
library(parsnip)
library(tidyr)

# ------------------------------------------------------------------------------

ctrl          <- control_parsnip(verbosity = 1, catch = FALSE)
caught_ctrl   <- control_parsnip(verbosity = 1, catch = TRUE)
quiet_ctrl    <- control_parsnip(verbosity = 0, catch = TRUE)

run_glmnet <- utils::compareVersion('3.6.0', as.character(getRversion())) < 0

senior_ind <- model.matrix(~ ., data = seniors)[, -1]
senior_ind <- tibble::as_tibble(senior_ind)

glm_spec <- poisson_reg() %>% set_engine("glm")
glmn_spec <- poisson_reg(penalty = .01, mixture = .3) %>% set_engine("glmnet")
stan_spec <- poisson_reg() %>% set_engine("stan", refresh = 0)
hurdle_spec <- poisson_reg() %>% set_engine("hurdle")
zeroinfl_spec <- poisson_reg() %>% set_engine("zeroinfl")

