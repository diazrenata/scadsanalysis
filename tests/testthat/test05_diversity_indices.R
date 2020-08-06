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
  expect_true(all(di_one$skew_percentile == 100, di_one$shannon_percentile == 100, di_one$simpson_percentile ==100))

  di_many <- add_dis(fs_samples)

  expect_true(all(di_many$skew_percentile %% 20 == 0))
  expect_true(all(di_many$shannon_percentile %% 20 == 0))
  expect_true(all(di_many$simpson_percentile %% 20 == 0))

  expect_true(di_many$skew_percentile[6] == 80)
  expect_true(di_many$shannon_percentile[6] == 0)
  expect_true(di_many$simpson_percentile[6] == 0)

})

test_that("dataset DIs work", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site %in% c("1001", "1003"))

  set.seed(1)
  fs_samples1 <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)
  fs_samples2 <- sample_fs_wrapper(dat, site_name = "1003", singletons = F, n_samples = 5, p_table = NULL)
  all_fs_samples <- dplyr::bind_rows(fs_samples1, fs_samples2)

  dis <- add_dis(fs_samples2)

  expect_true(anyNA(dis$skew_percentile))
  expect_false(anyNA(dis$shannon_percentile))
  expect_false(anyNA(dis$simpson_percentile))

  expect_true(length(unique(dplyr::filter(dis, source == "observed")$skew)) == 1)

  fs_no_obs <- dplyr::filter(fs_samples2, source == "sampled")

  di_no_obs <- add_dis(fs_no_obs)

  expect_equivalent(di_no_obs, dplyr::filter(dis, source == "sampled"))

  })

test_that("get percentiles and get percentile work", {

  foo <- seq(1, 100, by = 5)

  foo_percentiles <- get_percentiles(foo)

  expect_equivalent(foo_percentiles, seq(5, 100, by = 5))

  a_val <- 17

  a_per <- get_percentile(a_val, foo)

  by_hand <- 100 * sum(foo <= a_val) / length(foo)

  expect_equivalent(by_hand, a_per)

})

test_that("get percentile works if focal value is outside comparison vector", {

  foo <- seq(10, 100, by = 5)

  low_focal_value <- 5

  low_per <- get_percentile(low_focal_value, foo)

  high_focal_value <- 110

  high_per <- get_percentile(high_focal_value, foo)

  expect_equivalent(low_per, 0)
  expect_equivalent(high_per, 100)


})


test_that("get percentile works if focal value is edge of comparison vector", {

  foo <- seq(10, 100, by = 5)

  low_focal_value <- 10

  low_per <- get_percentile(low_focal_value, foo)

  high_focal_value <- 100

  high_per <- get_percentile(high_focal_value, foo)

  expect_equivalent(low_per, 100/length(foo))
  expect_equivalent(high_per, 100)

})




test_that("get percentile works with incl = F", {

  foo <- seq(1, 100, by = 5)

  foo_percentiles <- get_percentiles(foo, incl = F)

  expect_equivalent(foo_percentiles, seq(0, 95, by = 5))

  a_val <- 17

  a_per <- get_percentile(a_val, foo, incl =F)

  by_hand <- 100 * sum(foo < a_val) / length(foo)

  expect_equivalent(by_hand, a_per)

  # Edges of comparison

    foo <- seq(10, 100, by = 5)

  low_focal_value <- 10

  low_per <- get_percentile(low_focal_value, foo, incl = F)

  high_focal_value <- 100

  high_per <- get_percentile(high_focal_value, foo, F)

  # Outside vector

  expect_equivalent(low_per, 0)
  expect_equivalent(high_per, 100 -  100/length(foo))

  low_focal_value <- 5

  low_per <- get_percentile(low_focal_value, foo, incl =F)

  high_focal_value <- 110

  high_per <- get_percentile(high_focal_value, foo, incl =F)

  expect_equivalent(low_per, 0)
  expect_equivalent(high_per, 100)


})


test_that("pull_di works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 100, p_table = NULL)

  di_many <- add_dis(fs_samples)

  expect_true(floor(di_many$skew_percentile[85]) == 	82)
  expect_true(floor(di_many$simpson_percentile[85]) == 4)

  di_obs <- pull_di(di_many)

  expect_true(is.data.frame(di_obs))
  expect_true(ncol(di_obs) == ncol(di_many) + 17)
  expect_true(nrow(di_obs) == 1)
  expect_true(di_obs$nsamples == nrow(di_many) - 1)
  expect_true(di_obs$source[1] == "observed")
  expect_equivalent(di_obs$skew_range[1], max(dplyr::filter(di_many, source == "sampled")$skew, na.rm = T) - min(dplyr::filter(di_many, source == "sampled")$skew, na.rm = T))
  expect_equivalent(di_obs$simpson_range[1], max(dplyr::filter(di_many, source == "sampled")$simpson, na.rm = T) - min(dplyr::filter(di_many, source == "sampled")$simpson, na.rm = T))

  sampled_skew <- dplyr::filter(di_many, source == "sampled")$skew

  expect_equivalent(di_obs$skew_min, min(sampled_skew))
  expect_equivalent(di_obs$skew_95, quantile(sampled_skew, probs = .95))
  expect_equivalent(di_obs$skew_95_ratio_1t, (quantile(sampled_skew, probs = .95) - min(sampled_skew)) / (max(sampled_skew) - min(sampled_skew)))
  expect_equivalent(max(sampled_skew) - min(sampled_skew), di_obs$skew_range)


  sampled_simpson <- dplyr::filter(di_many, source == "sampled")$simpson

  expect_equivalent(di_obs$simpson_max, max(sampled_simpson))
  expect_equivalent(di_obs$simpson_5, quantile(sampled_simpson, probs = .05))
  expect_equivalent(di_obs$simpson_95_ratio_1t, (max(sampled_simpson) - quantile(sampled_simpson, probs = .05)) / (max(sampled_simpson) - min(sampled_simpson)))
  expect_equivalent(max(sampled_simpson) - min(sampled_simpson), di_obs$simpson_range)

  })
