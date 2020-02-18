context("Check data handling for experimental manips")

test_that("MACD ctrl-treatment pairing works", {

  dat <- load_dataset("macdb")
  dat <- dat %>%
    dplyr::filter(site %in% c(22, 20, 19))

  set.seed(1)
  fs_samples <- lapply(unique(dat$site), FUN = sample_fs_wrapper, dat = dat, singletons = F, n_samples = 5, p_table = NULL)

  dis <- lapply(fs_samples, FUN = add_dis)

  dis_obs <- lapply(dis, FUN = pull_di)

  di_obs_s <- dplyr::bind_rows(dis_obs)

  expect_silent(wtrts <- assign_macdb_manips(di_obs_s))
  expect_true(ncol(wtrts) == 10)
  expect_false(anyNA(wtrts))
  expect_equivalent(wtrts$comparison, c("19", "20"))
  expect_equivalent(wtrts$control, c("22", "22"))
  expect_equivalent(wtrts$simpson_change, c(40, 0))
  expect_equivalent(wtrts$skew_change, c(-40, -20))

  }
)


test_that("Portal plot treatment parsing works", {

  dat <- load_dataset("portal_plants_manip")
  dat <- dat %>%
    dplyr::filter(site %in% c("1999_15_exclosure_winter", "2012_9_control_summer", "2013_18_exclosure_summer")) # chosen bc small sv

  set.seed(1)
  fs_samples <- lapply(unique(dat$site), FUN = sample_fs_wrapper, dat = dat, singletons = F, n_samples = 5, p_table = NULL)

  dis <- lapply(fs_samples, FUN = add_dis)

  dis_obs <- lapply(dis, FUN = pull_di)

  di_obs_s <- dplyr::bind_rows(dis_obs)

  expect_silent(wtrts <- assign_portal_manips(di_obs_s))
  expect_true(ncol(wtrts) == 25)
  expect_false(anyNA(wtrts))
  expect_equivalent(wtrts$year, c(2012, 1999, 2013))
  expect_equivalent(wtrts$plot, c(9, 15, 18))
  expect_equivalent(wtrts$treatment, c("control", "exclosure", "exclosure"))
  expect_equivalent(wtrts$season, c("summer", "winter", "summer"))

}
)
