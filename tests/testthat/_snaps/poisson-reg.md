# updating

    Code
      poisson_reg(penalty = 1) %>% set_engine("glmnet", lambda.min.ratio = 0.001) %>%
        update(mixture = tune())
    Output
      Poisson Regression Model Specification (regression)
      
      Main Arguments:
        penalty = 1
        mixture = tune()
      
      Engine-Specific Arguments:
        lambda.min.ratio = 0.001
      
      Computational engine: glmnet 
      

