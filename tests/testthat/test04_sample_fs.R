context("Check FS sampling functions")

test_that("sampling fs works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  sv <- get_statevars(dat)

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletonsyn = F, n_samples = 2, p_table = NULL)

  expect_true(ncol(fs_samples) == 7)
  expect_true(all(
    mode(fs_samples$site) == "character",
    mode(fs_samples$dat) == "character",
    mode(fs_samples$singletons) == "logical",
    mode(fs_samples$sim) == "numeric",
    mode(fs_samples$source) == "character",
    mode(fs_samples$rank) == "numeric",
    mode(fs_samples$abund) == "numeric"
  ))
  expect_false(anyNA(fs_samples))

  expect_true(min(fs_samples$abund) > 0)

  fs_samples_sv <- fs_samples %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(s0 = dplyr::n(), n0 = sum(abund)) %>%
    dplyr::ungroup()

  expect_true(all(fs_samples_sv$n0 == sv$n0))
  expect_true(all(fs_samples_sv$s0 == sv$s0))

})
