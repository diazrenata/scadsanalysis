context("Check diversity indices")

test_that("individual DIs work", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)

  one_sample <- dplyr::filter(fs_samples, sim == "1")

  di_one <- add_dis(one_sample)

  expect_type(di_one$skew, "double")
  expect_type(di_one$shannon, "double")
  expect_type(di_one$simpson, "double")

  expect_true(di_one$skew == e1071::skewness(one_sample$abund))
  expect_true(di_one$shannon == vegan::diversity(one_sample$abund, index = "shannon"))
  expect_true(di_one$simpson == vegan::diversity(one_sample$abund, index = "simpson"))
  expect_true(all(di_one$skew_percentile == 0, di_one$shannon_percentile == 0, di_one$simpson_percentile ==0))

  di_many <- add_dis(fs_samples)

  expect_true(all(di_many$skew_percentile %% 20 == 0))
  expect_true(all(di_many$shannon_percentile %% 20 == 0))
  expect_true(all(di_many$simpson_percentile %% 20 == 0))

  expect_true(di_many$skew_percentile[6] == 80)
  expect_true(di_many$shannon_percentile[6] == 0)
  expect_true(di_many$simpson_percentile[6] == 0)
})
