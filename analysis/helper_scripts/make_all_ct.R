# This is a wrapper script to combine the results from each dataset-level pipeline into a single data frame.

library(drake)
library(dplyr)
library(ggplot2)
library(scadsanalysis)

all_ct <- list()
#datasets <- c("bbs",  "gentry", "fia_short", "mcdb", "misc_abund_short", "fia_small")
#datasets <- c( "gentry", "mcdb", "misc_abund_short", "bbs")
datasets <- c("bbs",  "gentry", "mcdb", "misc_abund_short", "fia_small")


for(i in 1:length(datasets)) {

  this_dataset = datasets[i]
  if(this_dataset == "misc_abund_short") {
    cache_loc = "miscabund"
  } else if(this_dataset == "fia_short") {

    cache_loc = "fia"
  } else {
    cache_loc = this_dataset
  }

  ## Set up the cache and config
  db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", paste0("drake-cache-", cache_loc, ".sqlite")))
  cache <- storr::storr_dbi("datatable", "keystable", db)

  all_ct[[i]] <- readd(all_cts, cache = cache)

  all_ct[[i]] <- filter(all_ct[[i]], source == "observed")


  DBI::dbDisconnect(db)
  rm(cache)
  rm(db)
}


all_ct <- bind_rows(all_ct)

write.csv(all_ct, here::here("analysis", "rev_prototyping", "all_ct.csv"), row.names = F)
