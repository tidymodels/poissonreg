# nocov start

# ------------------------------------------------------------------------------

# The functions below define the model information. These access the model
# environment inside of parsnip so they have to be executed once parsnip has
# been loaded.

.onLoad <- function(libname, pkgname) {
  make_poisson_reg_glm()
  make_poisson_reg_hurdle()
  make_poisson_reg_zeroinfl()
  make_poisson_reg_glmnet()
  make_poisson_reg_stan()
}

# nocov end
