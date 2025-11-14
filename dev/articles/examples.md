# Fitting and Predicting with poissonreg

These examples illustrate which models, engines, and prediction types
are available in poissonreg. As a reminder, in parsnip,

- the **model type** differentiates basic modeling approaches, such as
  random forests, proportional hazards models, etc.,

- the **mode** denotes in what kind of modeling context it will be used
  (here: regression), and

- the computational **engine** indicates how the model is fit, such as
  with a specific R package implementation or even methods outside of R
  like Keras or Stan.

The following examples use the same data set throughout.

## `poisson_reg()` models

With the `"glm"` engine

We’ll model the number of articles published by graduate students in
biochemistry Ph.D. programs.

``` r
  library(tidymodels)
```

      ## ── Attaching packages ───────────────────────────── tidymodels 1.4.1 ──

      ## ✔ broom        1.0.10     ✔ rsample      1.3.1 
      ## ✔ dials        1.4.2      ✔ tailor       0.1.0 
      ## ✔ dplyr        1.1.4      ✔ tidyr        1.3.1 
      ## ✔ infer        1.0.9      ✔ tune         2.0.1 
      ## ✔ modeldata    1.5.1      ✔ workflows    1.3.0 
      ## ✔ parsnip      1.3.3      ✔ workflowsets 1.1.1 
      ## ✔ purrr        1.2.0      ✔ yardstick    1.3.2 
      ## ✔ recipes      1.3.1

      ## ── Conflicts ──────────────────────────────── tidymodels_conflicts() ──
      ## ✖ purrr::discard() masks scales::discard()
      ## ✖ dplyr::filter()  masks stats::filter()
      ## ✖ dplyr::lag()     masks stats::lag()
      ## ✖ recipes::step()  masks stats::step()

``` r
  library(poissonreg)
  tidymodels_prefer()
  
  data(bioChemists, package = "pscl")
  
  biochemists_train <- bioChemists[-c(1:5), ]
  biochemists_test <- bioChemists[1:5, ]
```

We can define the model:

``` r
  pr_spec <- 
    poisson_reg() |>
    set_engine("glm") |> 
    set_mode("regression") 
  pr_spec
```

      ## Poisson Regression Model Specification (regression)
      ## 
      ## Computational engine: glm

Now we create the model fit object:

``` r
  set.seed(1)
  pr_fit <- pr_spec |> fit(art ~ ., data = biochemists_train)
  pr_fit
```

      ## parsnip model object
      ## 
      ## 
      ## Call:  stats::glm(formula = art ~ ., family = stats::poisson, data = data)
      ## 
      ## Coefficients:
      ## (Intercept)     femWomen   marMarried         kid5          phd  
      ##     0.32187     -0.22207      0.14916     -0.18580      0.01003  
      ##        ment  
      ##     0.02559  
      ## 
      ## Degrees of Freedom: 909 Total (i.e. Null);  904 Residual
      ## Null Deviance:     1800 
      ## Residual Deviance: 1618    AIC: 3298

The holdout data can be predicted:

``` r
  predict(pr_fit, biochemists_test)
```

      ## # A tibble: 5 × 1
      ##   .pred
      ##   <dbl>
      ## 1  1.96
      ## 2  1.32
      ## 3  1.34
      ## 4  1.45
      ## 5  2.23

With the `"glmnet"` engine

We’ll model the number of articles published by graduate students in
biochemistry Ph.D. programs.

``` r
  library(tidymodels)
  library(poissonreg)
  tidymodels_prefer()
  
  data(bioChemists, package = "pscl")
  
  biochemists_train <- bioChemists[-c(1:5), ]
  biochemists_test <- bioChemists[1:5, ]
```

We can define the model with specific parameters:

``` r
  pr_spec <- 
    poisson_reg(penalty = 0.1) |>
    set_engine("glmnet") |> 
    set_mode("regression") 
  pr_spec
```

      ## Poisson Regression Model Specification (regression)
      ## 
      ## Main Arguments:
      ##   penalty = 0.1
      ## 
      ## Computational engine: glmnet

Now we create the model fit object:

``` r
  set.seed(1)
  pr_fit <- pr_spec |> fit(art ~ ., data = biochemists_train)
  pr_fit
```

      ## parsnip model object
      ## 
      ## 
      ## Call:  glmnet::glmnet(x = maybe_matrix(x), y = y, family = "poisson") 
      ## 
      ##    Df  %Dev  Lambda
      ## 1   0  0.00 0.59250
      ## 2   1  1.71 0.53980
      ## 3   1  3.03 0.49190
      ## 4   1  4.06 0.44820
      ## 5   1  4.88 0.40840
      ## 6   1  5.52 0.37210
      ## 7   1  6.04 0.33900
      ## 8   1  6.45 0.30890
      ## 9   1  6.78 0.28150
      ## 10  1  7.04 0.25650
      ## 11  1  7.26 0.23370
      ## 12  1  7.43 0.21290
      ## 13  1  7.58 0.19400
      ## 14  1  7.69 0.17680
      ## 15  2  7.80 0.16110
      ## 16  2  7.99 0.14680
      ## 17  2  8.14 0.13370
      ## 18  3  8.33 0.12180
      ## 19  3  8.58 0.11100
      ## 20  3  8.79 0.10120
      ## 21  3  8.96 0.09217
      ## 22  3  9.11 0.08398
      ## 23  3  9.22 0.07652
      ## 24  3  9.32 0.06972
      ## 25  4  9.45 0.06353
      ## 26  4  9.57 0.05789
      ## 27  4  9.67 0.05274
      ## 28  4  9.74 0.04806
      ## 29  4  9.81 0.04379
      ## 30  4  9.87 0.03990
      ## 31  4  9.91 0.03635
      ## 32  4  9.95 0.03312
      ## 33  4  9.98 0.03018
      ## 34  4 10.01 0.02750
      ## 35  4 10.03 0.02506
      ## 36  4 10.05 0.02283
      ## 37  4 10.06 0.02080
      ## 38  4 10.07 0.01896
      ## 39  5 10.08 0.01727
      ## 40  5 10.09 0.01574
      ## 41  5 10.10 0.01434
      ## 42  5 10.11 0.01306
      ## 43  5 10.11 0.01190
      ## 44  5 10.12 0.01085
      ## 45  5 10.12 0.00988
      ## 46  5 10.13 0.00901
      ## 47  5 10.13 0.00820
      ## 48  5 10.13 0.00748
      ## 49  5 10.13 0.00681
      ## 50  5 10.13 0.00621
      ## 51  5 10.14 0.00566
      ## 52  5 10.14 0.00515
      ## 53  5 10.14 0.00470
      ## 54  5 10.14 0.00428
      ## 55  5 10.14 0.00390
      ## 56  5 10.14 0.00355
      ## 57  5 10.14 0.00324
      ## 58  5 10.14 0.00295
      ## 59  5 10.14 0.00269
      ## 60  5 10.14 0.00245
      ## 61  5 10.14 0.00223
      ## 62  5 10.14 0.00203

The holdout data can be predicted:

``` r
  predict(pr_fit, biochemists_test)
```

      ## # A tibble: 5 × 1
      ##   .pred
      ##   <dbl>
      ## 1  1.67
      ## 2  1.51
      ## 3  1.51
      ## 4  1.49
      ## 5  2.36

With the `"hurdle"` engine

We’ll model the number of articles published by graduate students in
biochemistry Ph.D. programs.

``` r
  library(tidymodels)
  library(poissonreg)
  tidymodels_prefer()
  
  data(bioChemists, package = "pscl")
  
  biochemists_train <- bioChemists[-c(1:5), ]
  biochemists_test <- bioChemists[1:5, ]
```

We can define the model:

``` r
  pr_spec <- 
    poisson_reg() |>
    set_engine("hurdle") |> 
    set_mode("regression") 
  pr_spec
```

      ## Poisson Regression Model Specification (regression)
      ## 
      ## Computational engine: hurdle

Now we create the model fit object:

``` r
  set.seed(1)
  pr_fit <- pr_spec |> fit(art ~ . | ., data = biochemists_train)
  pr_fit
```

      ## parsnip model object
      ## 
      ## 
      ## Call:
      ## pscl::hurdle(formula = art ~ . | ., data = data)
      ## 
      ## Count model coefficients (truncated poisson with log link):
      ## (Intercept)     femWomen   marMarried         kid5          phd  
      ##     0.67114     -0.22858      0.09648     -0.14219     -0.01273  
      ##        ment  
      ##     0.01875  
      ## 
      ## Zero hurdle model coefficients (binomial with logit link):
      ## (Intercept)     femWomen   marMarried         kid5          phd  
      ##     0.28643     -0.24805      0.30873     -0.29088      0.01038  
      ##        ment  
      ##     0.08317

The holdout data can be predicted:

``` r
  predict(pr_fit, biochemists_test)
```

      ## # A tibble: 5 × 1
      ##   .pred
      ##   <dbl>
      ## 1  2.02
      ## 2  1.32
      ## 3  1.31
      ## 4  1.45
      ## 5  2.40

With the `"stan"` engine

We’ll model the number of articles published by graduate students in
biochemistry Ph.D. programs.

``` r
  library(tidymodels)
  library(poissonreg)
  tidymodels_prefer()
  
  data(bioChemists, package = "pscl")
  
  biochemists_train <- bioChemists[-c(1:5), ]
  biochemists_test <- bioChemists[1:5, ]
```

We can define the model:

``` r
  pr_spec <- 
    poisson_reg() |>
    set_engine("stan") |> 
    set_mode("regression") 
  pr_spec
```

      ## Poisson Regression Model Specification (regression)
      ## 
      ## Computational engine: stan

Now we create the model fit object:

``` r
  set.seed(1)
  pr_fit <- pr_spec |> fit(art ~ ., data = biochemists_train)
```

      ## 
      ## SAMPLING FOR MODEL 'count' NOW (CHAIN 1).
      ## Chain 1: 
      ## Chain 1: Gradient evaluation took 5.2e-05 seconds
      ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.52 seconds.
      ## Chain 1: Adjust your expectations accordingly!
      ## Chain 1: 
      ## Chain 1: 
      ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
      ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
      ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
      ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
      ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
      ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
      ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
      ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
      ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
      ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
      ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
      ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
      ## Chain 1: 
      ## Chain 1:  Elapsed Time: 0.239 seconds (Warm-up)
      ## Chain 1:                0.251 seconds (Sampling)
      ## Chain 1:                0.49 seconds (Total)
      ## Chain 1: 
      ## 
      ## SAMPLING FOR MODEL 'count' NOW (CHAIN 2).
      ## Chain 2: 
      ## Chain 2: Gradient evaluation took 3.1e-05 seconds
      ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.31 seconds.
      ## Chain 2: Adjust your expectations accordingly!
      ## Chain 2: 
      ## Chain 2: 
      ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
      ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
      ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
      ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
      ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
      ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
      ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
      ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
      ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
      ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
      ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
      ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
      ## Chain 2: 
      ## Chain 2:  Elapsed Time: 0.238 seconds (Warm-up)
      ## Chain 2:                0.26 seconds (Sampling)
      ## Chain 2:                0.498 seconds (Total)
      ## Chain 2: 
      ## 
      ## SAMPLING FOR MODEL 'count' NOW (CHAIN 3).
      ## Chain 3: 
      ## Chain 3: Gradient evaluation took 3.1e-05 seconds
      ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.31 seconds.
      ## Chain 3: Adjust your expectations accordingly!
      ## Chain 3: 
      ## Chain 3: 
      ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
      ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
      ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
      ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
      ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
      ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
      ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
      ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
      ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
      ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
      ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
      ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
      ## Chain 3: 
      ## Chain 3:  Elapsed Time: 0.246 seconds (Warm-up)
      ## Chain 3:                0.322 seconds (Sampling)
      ## Chain 3:                0.568 seconds (Total)
      ## Chain 3: 
      ## 
      ## SAMPLING FOR MODEL 'count' NOW (CHAIN 4).
      ## Chain 4: 
      ## Chain 4: Gradient evaluation took 3.1e-05 seconds
      ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.31 seconds.
      ## Chain 4: Adjust your expectations accordingly!
      ## Chain 4: 
      ## Chain 4: 
      ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
      ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
      ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
      ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
      ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
      ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
      ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
      ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
      ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
      ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
      ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
      ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
      ## Chain 4: 
      ## Chain 4:  Elapsed Time: 0.229 seconds (Warm-up)
      ## Chain 4:                0.288 seconds (Sampling)
      ## Chain 4:                0.517 seconds (Total)
      ## Chain 4:

``` r
  pr_fit
```

      ## parsnip model object
      ## 
      ## stan_glm
      ##  family:       poisson [log]
      ##  formula:      art ~ .
      ##  observations: 910
      ##  predictors:   6
      ## ------
      ##             Median MAD_SD
      ## (Intercept)  0.3    0.1  
      ## femWomen    -0.2    0.1  
      ## marMarried   0.2    0.1  
      ## kid5        -0.2    0.0  
      ## phd          0.0    0.0  
      ## ment         0.0    0.0  
      ## 
      ## ------
      ## * For help interpreting the printed output see ?print.stanreg
      ## * For info on the priors used see ?prior_summary.stanreg

The holdout data can be predicted:

``` r
  predict(pr_fit, biochemists_test)
```

      ## # A tibble: 5 × 1
      ##   .pred
      ##   <dbl>
      ## 1 0.674
      ## 2 0.271
      ## 3 0.289
      ## 4 0.371
      ## 5 0.800

With the `"zeroinfl"` engine

We’ll model the number of articles published by graduate students in
biochemistry Ph.D. programs.

``` r
  library(tidymodels)
  library(poissonreg)
  tidymodels_prefer()
  
  data(bioChemists, package = "pscl")
  
  biochemists_train <- bioChemists[-c(1:5), ]
  biochemists_test <- bioChemists[1:5, ]
```

We can define the model:

``` r
  pr_spec <- 
    poisson_reg() |>
    set_engine("zeroinfl") |> 
    set_mode("regression") 
  pr_spec
```

      ## Poisson Regression Model Specification (regression)
      ## 
      ## Computational engine: zeroinfl

Now we create the model fit object:

``` r
  set.seed(1)
  pr_fit <- pr_spec |> fit(art ~ . | ., data = biochemists_train)
  pr_fit
```

      ## parsnip model object
      ## 
      ## 
      ## Call:
      ## pscl::zeroinfl(formula = art ~ . | ., data = data)
      ## 
      ## Count model coefficients (poisson with log link):
      ## (Intercept)     femWomen   marMarried         kid5          phd  
      ##    0.637600    -0.205020     0.099136    -0.143444    -0.005037  
      ##        ment  
      ##    0.018101  
      ## 
      ## Zero-inflation model coefficients (binomial with logit link):
      ## (Intercept)     femWomen   marMarried         kid5          phd  
      ##    -0.65529      0.12466     -0.35861      0.22921      0.03238  
      ##        ment  
      ##    -0.14778

The holdout data can be predicted:

``` r
  predict(pr_fit, biochemists_test)
```

      ## # A tibble: 5 × 1
      ##   .pred
      ##   <dbl>
      ## 1  2.05
      ## 2  1.35
      ## 3  1.32
      ## 4  1.46
      ## 5  2.39
