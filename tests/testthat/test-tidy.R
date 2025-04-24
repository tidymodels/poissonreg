test_that("hurdle", {
  library(pscl)
  data("bioChemists", package = "pscl")
  hurd <- hurdle(art ~ fem | ment, data = bioChemists)
  summ <- summary(hurd)

  expect_no_error(counts <- tidy(hurd))
  expect_no_error(zeros <- tidy(hurd, "zero"))
  expect_no_error(both <- tidy(hurd, "all"))

  expect_equal(
    unname(summ$coefficients$count[, "Estimate"]),
    counts$estimate
  )
  expect_equal(
    unname(summ$coefficients$zero[, "Estimate"]),
    zeros$estimate
  )
  expect_equal(
    c(
      unname(summ$coefficients$count[, "Estimate"]),
      unname(summ$coefficients$zero[, "Estimate"])
    ),
    both$estimate
  )
})
