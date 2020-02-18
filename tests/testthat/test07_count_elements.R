context("Check that counting elements in FS works")

test_that("one species means one FS", {
  s0 = 1
  n0 = 100

  expect_true(count_elements(s0, n0) == 1)

})


test_that("no p table works", {
  s0 = 3
  n0 = 5

  expect_true(gmp::is.bigz(count_elements(s0, n0)))
  expect_true(as.integer(count_elements(s0, n0)) == 2)

})


test_that("passed p table works", {
  s0 = 3
  n0 = 5

  p_table = feasiblesads::fill_ps(s0, n0, FALSE)

  expect_true(gmp::is.bigz(count_elements(s0, n0, p_table)))
  expect_true(as.integer(count_elements(s0, n0, p_table)) == 2)

})
