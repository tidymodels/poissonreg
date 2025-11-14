# Model predictions across many sub-models

For some models, predictions can be made on sub-models in the model
object.

## Usage

``` r
# S3 method for class '`_fishnet`'
predict_raw(object, new_data, opts = list(), ...)

# S3 method for class '`_fishnet`'
multi_predict(object, new_data, type = NULL, penalty = NULL, ...)
```

## Arguments

- object:

  A `model_fit` object.

- new_data:

  A rectangular data object, such as a data frame.

- opts:

  A list of options..

- ...:

  Optional arguments to pass to `predict.model_fit(type = "raw")` such
  as `type`.

- penalty:

  A numeric vector of penalty values.

## Value

A tibble with the same number of rows as the data being predicted. There
is a list-column named `.pred` that contains tibbles with multiple rows
per sub-model.
