context("Check that build net works")

test_that("build net works", {

  net <- build_net()

  expect_true(is.data.frame(net))

  expect_true(all(c("rank", "abund", "site", "singletons", "dat") %in% colnames(net)))

  expect_true(all(net$abund > net$rank))

  expect_true(all(as.integer(net$rank) == net$rank))
  expect_true(all(as.integer(net$abund) == net$abund))

  expect_true(all(!(net$singletons)))

  expect_true(all(net$dat == "net"))


})
