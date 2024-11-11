# poissonreg (development version)

* Predictions via `multi_predict()` for glmnet models now correctly are the mean counts instead of the linear predictor (#89).

* Predictions for a single observation now work for `poisson_reg()` with the `"glmnet"` engine (#48).

* Removed the now obsolete registration of the `predict_raw()` generic as it is now exported from parsnip (#52).

* Removed the unused internal `s3_register()` function (#53).

* Tests on the model specification have been updated to the current testing pattern in parsnip and other extension packages (#55).

* The `predict()` method for the `"glmnet"` engine now checks the penalty value via `parsnip::.check_glmnet_penalty_predict()` instead of a copied version of the function (#57).

* Moved imports and declaration of global variables into the standard place (#59).

* Tests are now self-contained (#60).

* Predictions of type `"conf_int"` for the `"stan"` engine now use the function suggested by rstanarm (#86).

* Removed obsolete check on supplying `newdata` as an argument to `predict()` or `multi_predict()` (#87).


# poissonreg 1.0.1

* Update to the .Rd files to generate valid HTML5


# poissonreg 1.0.0

* Changes for using case weights with parsnip 1.0.0.


# poissonreg 0.2.0

* Model definition functions (e.g. `poisson_reg()`) were moved to the parsnip package.


# poissonreg 0.1.1

* A default engine of `glm` was added for `poisson_reg()`. 

* Added `tidy()` methods for `pscl::hurdle()` and `pscl::zeroinfl()`.


# poissonreg 0.1.0

* Work-around for a `glmnet` bug where different column order will silently produce incorrect predictions. 

* `multi_predict()` was enabled. 

* Updates to go along with new version of `parsnip`. 


# poissonreg 0.0.1

* Added a `NEWS.md` file to track changes to the package.
