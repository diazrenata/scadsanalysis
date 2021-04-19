all_di <- read.csv(here::here("analysis", "rev_prototyping", "all_di.csv"))
mcdb_old_di <- filter(all_di, dat == "mcdb")
mcdb_new_di <-read.csv(here::here("mcdb_new_di.csv"))

coloverlap <- intersect(colnames(mcdb_new_di), colnames(mcdb_old_di))
coldiff <- setdiff(colnames(mcdb_new_di), colnames(mcdb_old_di))
coldiff
coldiff2 <- setdiff(colnames(mcdb_newold_di), colnames(mcdb_new_di))
coldiff2 <- setdiff(colnames(mcdb_old_di), colnames(mcdb_new_di))
coldiff2
should_overlap_old <- select(mcdb_old_di, coloverlap)
should_overlap_new <- select(mcdb_new_di, coloverlap)
colnames(should_overlap_new) == colnames(should_overlap_old)
all_equal(should_overlap_new, should_overlap_old)
should_overlap_new <- select(mcdb_new_di, coloverlap)
all_equal(should_overlap_new, should_overlap_old)
