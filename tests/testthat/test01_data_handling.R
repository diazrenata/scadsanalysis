context("Check that data handling is okay")

test_that("download_data", {
  expect_silent(download_data(from_url = FALSE))
})

test_that("filter misc abund", {

  expect_silent(filter_miscabund(save = F))
  expect_silent(filter_fia(save = F))

})

test_that("load_dataset", {
  datasets <- c("mcdb", "misc_abund", "bbs", "fia", "gentry", "misc_abund_short", "portal_plants", "fia_short")

  for(i in 1:8) {
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

test_that("list_sites", {
  datasets <- c("mcdb", "misc_abund", "bbs", "fia", "gentry", "misc_abund_short", "portal_plants", "fia_short")
  for(i in 1:8) {
    sitelist <- list_sites(datasets[i])
    expect_true(is.data.frame(sitelist))
    expect_true(ncol(sitelist) == 2)
    expect_true(all(mode(sitelist$dat) == "character",
                    mode(sitelist$site) == "character"))
    expect_true(sitelist$dat[1] == datasets[i])
    expect_false(anyNA(sitelist))
  }
}
)
