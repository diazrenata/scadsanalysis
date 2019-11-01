library(testthat)
library(scadsanalysis)
test_dir("testthat", reporter = c("check", "progress"))
test_check("scadsanalysis")
