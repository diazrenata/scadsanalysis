context("Check that adding singletons is okay")

test_that("download_data", {
  expect_true(download_data(from_url = FALSE))
})

test_that("load_dataset", {
  datasets <- c("mcdb", "misc_abund", "bbs", "fia", "gentry")

  for(i in 1:5) {
    thisdat <- load_dataset(datasets[i])
    expect_true(is.data.frame(thisdat))
    expect_true(ncol(thisdat) == 7)
    expect_true(all(
      mode(thisdat$rank) == "numeric",
      mode(thisdat$abund) == "numeric",
      mode(thisdat$site) == "character",
      mode(thisdat$dat) == "character",
      mode(thisdat$singletons) == "logical",
      mode(thisdat$sim) == "numeric",
      mode(thisdat$source) == "character"
    ))
    expect_false(anyNA(thisdat))
  }
})

