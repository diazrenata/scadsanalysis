context("Check error in templates")

test_that("templates errors", {
  te <- render_report("this_path_doesnt_matter", dependencies = NULL, is_template = TRUE, dat_name = NULL)

  expect_true(is.character(te))

})
