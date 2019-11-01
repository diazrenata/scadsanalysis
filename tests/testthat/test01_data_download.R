context("Check that data handling is okay")


test_that("load_dataset", {
  mcdb <- load_dataset("mcdb")
  expect_true(is.data.frame(mcdb))
  expect_true(ncol(mcdb) == 7)
  expect_true(all(
    mode(mcdb$rank) == "numeric",
    mode(mcdb$abund) == "numeric",
    mode(mcdb$site) == "character",
    mode(mcdb$dat) == "character",
    mode(mcdb$singletons) == "logical",
    mode(mcdb$sim) == "numeric",
    mode(mcdb$source) == "character"
  ))
  expect_false(anyNA(mcdb))
})
