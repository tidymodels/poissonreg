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
      translate_args(set_engine(penalty, "glmnet"))
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
      translate_args(set_engine(penalty, "glmnet", path_values = 4:2))
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
      translate_args(set_engine(mixture, "glmnet"))
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
      translate_args(set_engine(mixture_tune, "glmnet"))
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
      spec <- set_mode(set_engine(poisson_reg(mixture = -1), "glm"), "regression")
      fit(spec, gear ~ ., data = mtcars)
    Condition
      Error in `fit()`:
      ! `mixture` must be a number between 0 and 1 or `NULL`, not the number -1.

---

    Code
      spec <- set_mode(set_engine(poisson_reg(penalty = -1), "glm"), "regression")
      fit(spec, gear ~ ., data = mtcars)
    Condition
      Error in `fit()`:
      ! `penalty` must be a number larger than or equal to 0 or `NULL`, not the number -1.

