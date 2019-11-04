context("Check that adding singletons is okay")

test_that("add singletons increases s0 and n0", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  dats <- add_singletons(dat, use_max = T)

  expect_true(nrow(dats) > nrow(dat))
  expect_true(max(dats$rank) > max(dat$rank))

  expect_true(sum(dats$abund) == sum(dat$abund) + (nrow(dats) - nrow(dat)))

})


test_that("add singletons dataset agrees with individually", {

  whole_dat <- load_dataset("mcdb")
  whole_dat <- whole_dat %>%
    dplyr::filter(site %in% c("1001", "1002", "1003"))

  dat1 <- whole_dat %>%
    dplyr::filter(site == "1001")
  dat2 <- whole_dat %>%
    dplyr::filter(site == "1002")
  dat3 <- whole_dat %>%
    dplyr::filter(site == "1003")

  whole_dat_s <- add_singletons_dataset(whole_dat, use_max = T)

  ind_dat_s <- dplyr::bind_rows(
    whole_dat,
    add_singletons(dat1, use_max = T),
    add_singletons(dat2, use_max = T),
  add_singletons(dat3, use_max = T))

  expect_true(all(ind_dat_s == whole_dat_s))

})

test_that("add singletons edge cases", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001") %>%
    dplyr::mutate(abund = c(1, 1000, 10000))

  s <- add_singletons(dat)

  expect_true(nrow(dat) == nrow(s))

  expect_true(sum(dat$abund) == sum(s$abund))

  })
