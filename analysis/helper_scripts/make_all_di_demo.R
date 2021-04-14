# This is a wrapper script to combine the results from each dataset-level pipeline into a single data frame.

library(drake)
library(dplyr)
library(ggplot2)
library(scadsanalysis)

all_di <- list()
all_ct <- list()

datasets <- "mcdb-demo"



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

  all_di[[i]] <- readd(all_di_obs, cache = cache)

  all_di[[i]] <- filter(all_di[[i]], source == "observed")


  all_ct[[i]] <- readd(all_cts, cache = cache)

  all_ct[[i]] <- filter(all_ct[[i]], source == "observed")

  DBI::dbDisconnect(db)
  rm(cache)
  rm(db)
}


all_di <- bind_rows(all_di)
all_ct <- bind_rows(all_ct)

write.csv(all_di, here::here("analysis", "reports", "submission2", "all_di_demo.csv"), row.names = F)

write.csv(all_ct, here::here("analysis", "reports", "submission2", "all_ct_demo.csv"), row.names = F)
