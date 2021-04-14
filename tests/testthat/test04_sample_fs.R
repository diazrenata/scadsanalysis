context("Check FS sampling functions")

test_that("sampling fs works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  sv <- get_statevars(dat)

  p_table <- readRDS(here::here("analysis", "masterp_mamm.Rds"))

  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletonsyn = F, n_samples = 2, p_table = p_table, seed = 1)

  expect_true(ncol(fs_samples) == 10)
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

  expect_equivalent(fs_samples$abund[1:5], c(4, 8, 15, 28, 28))
  expect_equivalent(fs_samples$rank[1:5], c(1, 1, 2, 2, 3))
  expect_equivalent(fs_samples$sim[1:5], c(1, 2, 1, 2, 2))



  fs_samples_sv <- fs_samples %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(s0 = dplyr::n(), n0 = sum(abund)) %>%
    dplyr::ungroup()

  expect_true(all(fs_samples_sv$n0 == sv$n0))
  expect_true(all(fs_samples_sv$s0 == sv$s0))

  sampled <- fs_samples %>%
    dplyr::filter(sim > 0)

  expect_true(all(sampled$source == "sampled"))
  expect_true(all(sampled$dat == "mcdb"))

})

test_that("sampling edge case fxns work", {

  dat <- NULL

  p_table <- readRDS(here::here("analysis", "masterp_mamm.Rds"))
  expect_true(is.na(sample_fs_wrapper(dat, "1002", FALSE, 10, p_table = p_table)))
  expect_true(is.na(sample_fs(dat, nsamples = 10, p_table = p_table)))

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "I am not a site")

  expect_true(is.na(sample_fs_wrapper(dat, "1002", FALSE, 10, p_table = p_table)))
  expect_true(is.na(sample_fs(dat, nsamples = 10, p_table = p_table)))

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1003")
  expect_true(is.na(sample_fs_wrapper(dat, "1002", FALSE, 10, p_table = p_table)))

  expect_true(is.data.frame(sample_fs_wrapper(dat, site_name = "1003", singletonsyn =  FALSE, n_samples = 10, p_table = p_table)))


  })
