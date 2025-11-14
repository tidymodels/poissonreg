# Turn zero-inflated model results into a tidy tibble

Turn zero-inflated model results into a tidy tibble

## Usage

``` r
# S3 method for class 'zeroinfl'
tidy(x, type = "count", ...)

# S3 method for class 'hurdle'
tidy(x, type = "count", ...)
```

## Arguments

- x:

  A `hurdle` or `zeroinfl` model object.

- type:

  A character string for which model coefficients to return: "all",
  "count", or "zero".

- ...:

  Not currently used.

## Value

A tibble
