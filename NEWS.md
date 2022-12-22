# poissonreg (development version)

* Predictions for a single observation now work for `poisson_reg()` with the `"glmnet"` engine (#48).

* Removed the now obsolete registration of the `predict_raw()` generic as it is now exported from parnsip (#52).

* Removed the unused internal `s3_register()` function (#53).


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
