# Alcohol, Cigarette, and Marijuana Use for High School Seniors

Alcohol, Cigarette, and Marijuana Use for High School Seniors

## Source

Agresti, A (2007). *An Introduction to Categorical Data Analysis*.

## Value

- seniors:

  a tibble

## Details

Data are from Table 7.3 of Agresti (2007). The first three columns make
up data from a 3-way contingency table.

## Examples

``` r
data(seniors)
str(seniors)
#> tibble [8 × 4] (S3: tbl_df/tbl/data.frame)
#>  $ marijuana: chr [1:8] "yes" "no" "yes" "no" ...
#>  $ cigarette: chr [1:8] "yes" "yes" "no" "no" ...
#>  $ alcohol  : chr [1:8] "yes" "yes" "yes" "yes" ...
#>  $ count    : num [1:8] 911 538 44 456 3 43 2 279
```
