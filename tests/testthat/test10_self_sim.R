context("Check selfsimilarity comparison")

test_that("self sim works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)

  fs_diff_samples <- rep_diff_sampler(fs_samples, 5)

  expect_false(anyNA(fs_diff_samples))

  })
