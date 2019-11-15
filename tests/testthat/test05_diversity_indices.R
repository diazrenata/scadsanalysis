context("Check diversity indices")

test_that("individual and site DIs work", {

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

  di_obs <- pull_di(di_many)

  expect_true(is.data.frame(di_obs))
  expect_true(ncol(di_obs) == ncol(di_many) + 3)
  expect_true(nrow(di_obs) == 1)
  expect_true(di_obs$nsamples == nrow(di_many) - 1)
  expect_true(di_obs$source[1] == "observed")
  expect_equivalent(di_obs$skew_range[1], max(dplyr::filter(di_many, source == "sampled")$skew, na.rm = T) - min(dplyr::filter(di_many, source == "sampled")$skew, na.rm = T))
  expect_equivalent(di_obs$simpson_range[1], max(dplyr::filter(di_many, source == "sampled")$simpson, na.rm = T) - min(dplyr::filter(di_many, source == "sampled")$simpson, na.rm = T))

})

test_that("dataset DIs work", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site %in% c("1001", "1003"))

  set.seed(1)
  fs_samples1 <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)
  fs_samples2 <- sample_fs_wrapper(dat, site_name = "1003", singletons = F, n_samples = 5, p_table = NULL)
  all_fs_samples <- dplyr::bind_rows(fs_samples1, fs_samples2)

  dis <- dis_wrapper(all_fs_samples)

  expect_true(anyNA(dis$skew_percentile))
  expect_false(anyNA(dis$shannon_percentile))
  expect_false(anyNA(dis$simpson_percentile))

  expect_true(length(unique(dplyr::filter(dis, source == "observed")$skew)) == 2)

  fs_no_obs <- dplyr::filter(all_fs_samples, source == "sampled")

  di_no_obs <- dis_wrapper(fs_no_obs)

  expect_equivalent(di_no_obs, dplyr::filter(dis, source == "sampled"))

  })

test_that("get percentiles work", {

  foo <- seq(1, 100, by = 5)

  foo_percentiles <- get_percentiles(foo)

  expect_equivalent(foo_percentiles, seq(0, 95, by = 5))

  a_val <- 17

  a_per <- get_percentile(a_val, foo)

  by_hand <- 100 * sum(foo <= a_val) / length(foo)

  expect_equivalent(by_hand, a_per)

})
