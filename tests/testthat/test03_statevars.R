context("Check statevars")

test_that("get statevars", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site %in% c("1001", "1002"))

  dats <- add_singletons_dataset(dat, use_max = T)

  sv <- get_statevars(dats)

  expect_true(ncol(sv) == 7)
  expect_true(all(
    mode(sv$site) == "character",
    mode(sv$dat) == "character",
    mode(sv$singletons) == "logical",
    mode(sv$sim) == "numeric",
    mode(sv$source) == "character",
    mode(sv$s0) == "numeric",
    mode(sv$n0) == "numeric"
  ))
  expect_false(anyNA(sv))

  expect_true(
    dplyr::filter(sv, site == "1001", singletons == FALSE)$n0 == sum(dplyr::filter(dats, site == "1001", singletons == FALSE)$abund)
  )

  expect_true(
    dplyr::filter(sv, site == "1001", singletons == FALSE)$s0 == nrow(dplyr::filter(dats, site == "1001", singletons == FALSE))
  )

  expect_true(
    dplyr::filter(sv, site == "1001", singletons == TRUE)$n0 == sum(dplyr::filter(dats, site == "1001", singletons == TRUE)$abund)
  )

  expect_true(
    dplyr::filter(sv, site == "1001", singletons == TRUE)$s0 == nrow(dplyr::filter(dats, site == "1001", singletons == TRUE))
  )

  expect_true(nrow(dplyr::filter(dats, site == "1001", singletons == TRUE)) > nrow(dplyr::filter(dats, site == "1001", singletons == FALSE)))

})
