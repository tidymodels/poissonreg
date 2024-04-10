# arguments

    Code
      translate_args(basic)
    Output
      $formula
      missing_arg()
      
      $data
      missing_arg()
      
      $weights
      missing_arg()
      
      $family
      stats::poisson
      

---

    Code
      translate_args(penalty %>% set_engine("glmnet"))
    Output
      $x
      missing_arg()
      
      $y
      missing_arg()
      
      $weights
      missing_arg()
      
      $family
      [1] "poisson"
      

---

    Code
      translate_args(penalty %>% set_engine("glmnet", path_values = 4:2))
    Output
      $x
      missing_arg()
      
      $y
      missing_arg()
      
      $weights
      missing_arg()
      
      $lambda
      <quosure>
      expr: ^4:2
      env:  empty
      
      $family
      [1] "poisson"
      

---

    Code
      translate_args(mixture %>% set_engine("glmnet"))
    Output
      $x
      missing_arg()
      
      $y
      missing_arg()
      
      $weights
      missing_arg()
      
      $alpha
      <quosure>
      expr: ^0.128
      env:  empty
      
      $family
      [1] "poisson"
      

---

    Code
      translate_args(mixture_tune %>% set_engine("glmnet"))
    Output
      $x
      missing_arg()
      
      $y
      missing_arg()
      
      $weights
      missing_arg()
      
      $alpha
      <quosure>
      expr: ^tune()
      env:  empty
      
      $family
      [1] "poisson"
      

# check_args() works

    Code
      spec <- poisson_reg(mixture = -1) %>% set_engine("glm") %>% set_mode(
        "regression")
      fit(spec, gear ~ ., data = mtcars)
    Condition
      Error in `fit()`:
      ! `mixture` must be a number between 0 and 1 or `NULL`, not the number -1.

---

    Code
      spec <- poisson_reg(penalty = -1) %>% set_engine("glm") %>% set_mode(
        "regression")
      fit(spec, gear ~ ., data = mtcars)
    Condition
      Error in `fit()`:
      ! `penalty` must be a number larger than or equal to 0 or `NULL`, not the number -1.

