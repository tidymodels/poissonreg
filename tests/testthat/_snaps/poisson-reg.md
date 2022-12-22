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
      
      $path_values
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
      

